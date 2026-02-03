/**
 * projectCreate.js
 * - 프로젝트 생성 및 수정 페이지 핵심 로직
 * - 팀원 초대 프로세스: [검색] -> [대기목록(장바구니)] -> [최종 적용]
 * @author YHB
 * @since 2025.01.15
 */

// ============================================================
// 1. 전역 변수 및 상수 정의
// ============================================================
const DOM = {
    // Context Info
    body: document.body,
    // Forms & Inputs
    submitBtn: document.getElementById('projectSubmitBtn'),	
	// Modal Elements
	inviteModal: document.getElementById('inviteModal'),
	searchInput: document.getElementById('searchEmailKeyword'),
	searchBtn: document.getElementById('btnSearchMember'),
	searchResultArea: document.getElementById('searchResultArea'),
	candidateListArea: document.getElementById('inviteCandidateList'),
	candidateCountBadge: document.getElementById('candidateCount'),
	applyInviteBtn: document.getElementById('processInviteBtn'),
	// Main Table
	participantList: document.getElementById('participantList'),	
    // Status Buttons
    btnComplete: document.getElementById('btnCompleteProject'),
    btnReopen: document.getElementById('btnReopenProject'),
	// 시연용 Button
	btnAutoFill: document.getElementById('btnAutoFill'),
};

// 초대 대기자 목록 (Map: Key=Email, Value=MemberObj)
let inviteCandidates = new Map();

// ============================================================
// 2. 초기화 및 이벤트 리스너 등록
// ============================================================
document.addEventListener('DOMContentLoaded', function() {
    
    // 환경 변수 로드
    const CONTEXT_PATH = DOM.body.dataset.contextPath || '';
    const STATUS = DOM.body.dataset.status;
    const PROJECT_NO = DOM.body.dataset.projectNo;

    // 탭 순서 변경 (SortableJS) 초기화
    initSortable();

	// 2-1. [프로젝트 생성/수정] 버튼
    if (DOM.submitBtn) {
        DOM.submitBtn.addEventListener('click', () => submitProject(CONTEXT_PATH, PROJECT_NO, STATUS));
    }

    // 2-2. 모달 관련 이벤트 (검색, 적용, 닫기)
	if (DOM.searchBtn) {
		DOM.searchBtn.addEventListener('click', () => searchMember(CONTEXT_PATH));
	}
	if (DOM.searchInput) {
		DOM.searchInput.addEventListener('keyup', (e) => {
			if (e.key === 'Enter') searchMember(CONTEXT_PATH);
		});
	}
	
	// 2-3. [초대 적용] 버튼
	if (DOM.applyInviteBtn) {
		DOM.applyInviteBtn.addEventListener('click', applyInviteListToMain);
	}

	// 2-4. [메인 테이블] 삭제/복구 이벤트 위임
	if (DOM.participantList) {
		DOM.participantList.addEventListener('click', handleMainTableClick);
	}

    // 2-5. [프로젝트 상태] 변경 (완료[1]/재진행[0])
    if (DOM.btnComplete) DOM.btnComplete.addEventListener('click', () => toggleProjectStatus(CONTEXT_PATH, PROJECT_NO, 1));
    if (DOM.btnReopen) DOM.btnReopen.addEventListener('click', () => toggleProjectStatus(CONTEXT_PATH, PROJECT_NO, 0));

	// 2-6 [프로젝트 삭제] 버튼 이벤트
	const btnDelete = document.getElementById('btnDeleteProject');
	if (btnDelete) {
		btnDelete.addEventListener('click', handleDeleteProject);
	}
	
	// 2-7. 모달 닫힐 때 초기화
	if (DOM.inviteModal) {
		DOM.inviteModal.addEventListener('hidden.bs.modal', function(){
			// 입력창 초기화
			resetInviteModal();
		});
	}
	
	// 2-8. 동적 요소 이벤트 위임 (모달 내부 추가 버튼)
	$(document).on('click', '.btn-add-candidate', function() {
		const roleType = document.querySelector('input[name="inviteType"]:checked').value;
		const member = {
			memberNo: $(this).data('no'),
			memberName: $(this).data('name'),
			memberEmail: $(this).data('email'),
			deptName: $(this).data('dept'),
			positionName: $(this).data('pos'),
			role: roleType,
			isMember: true // 검색된 회원이므로 true
	        };
		addCandidateToBasket(member);
	});	
	
	// 2-9. 시연용 자동입력 버튼 이벤트
	if (DOM.btnAutoFill) {
		DOM.btnAutoFill.addEventListener('click', autoFillProjectData);
	}
});


// ============================================================
// 3. [모달] 팀원 검색 및 대기 목록 로직
// ============================================================

// 회원 검색 핸들러
function searchMember(contextPath) {
    let email = DOM.searchInput.value.trim();

    if (!email) {
        Swal.fire('알림', '이메일 주소를 입력해주세요.', 'warning');
        return;
    }
	
	// 이메일 정규식 검사
	let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	if (!emailRegex.test(email)) {
		Swal.fire('형식 오류', '올바른 이메일 형식이 아닙니다.', 'warning');
		return;
	}
	
	// 장바구니 중복 체크
	if (inviteCandidates.has(email)) {
		Swal.fire('중복', '이미 초대 목록에 추가된 이메일입니다.', 'info');
		return;
	}
	
	// 메인 테이블(이미 참여중인 사람) 중복 체크
	if (isMemberInMainTable(email)) {
		Swal.fire('중복', '이미 프로젝트에 참여 중인 멤버입니다.', 'info');
		return;
	}

	// 로딩 표시
    DOM.searchResultArea.innerHTML = `
		<div class="text-center py-3">
			<div class="spinner-border text-primary spinner-border-sm"></div>
			<p class="mt-2 text-muted small">검색 중...</p>
		</div>
	`;
	
	// 현재 선택된 초대 유형 (MEMBER_AUTH : ROLE_MEMBER / ROLE_CLIENT)
	const roleRadio = document.querySelector('input[name="inviteType"]:checked');
	const inviteType = roleRadio ? roleRadio.value : 'MEMBER';
	
	// 이메일로 회원 여부 단건 조회
	$.ajax({
		url: `${contextPath}/tudio/project/checkMember`, 
	    type: 'GET',
		data: { email: email, type: inviteType },
		dataType: 'json',
		success: function(res) {
	        // res가 null이거나 비어있으면 비회원 처리
	        if (!res || !res.memberNo) {
				renderNonMemberUI(email);
			} else {
				// renderSearchResult(res);
				renderSearchResult([res]);	// 단건 객체
			}
		},
		error: function(xhr) {
			// 에러 발생 시에도 비회원으로 간주하여 초대 가능
			console.log("회원 조회 실패(비회원 추정):", xhr);
			renderNonMemberUI(email);
		}
	});
}

// 회원 검색 결과 : 성공 (카드 UI)
function renderSearchResult(memberList) {
	const searchResultArea = DOM.searchResultArea;
	
	let role = document.querySelector('input[name="inviteType"]:checked').value;
	let roleText = role === 'CLIENT' ? '기업 담당자' : '팀원';
    
    const roleBadge = role === 'MEMBER' 
        ? '<span class="badge bg-primary">팀원</span>' 
        : '<span class="badge bg-warning text-dark">기업 담당자</span>';
	
	let html = '';
	
	memberList.forEach(member => {
		// 중복 체크
		const isPending = inviteCandidates.has(member.memberEmail);
		const isJoined = isMemberInMainTable(member.memberEmail);
			
		let btnHtml = '';
		if (isJoined) {
			btnHtml = `<button class="btn btn-sm btn-secondary w-100" disabled>참여중</button>`;
		} else if (isPending) {
			btnHtml = `<button class="btn btn-sm btn-outline-secondary w-100" disabled>대기중</button>`;
		} else {
			btnHtml = `<button class="btn btn-sm btn-outline-primary w-100 btn-add-candidate" 
						data-no="${member.memberNo}" 
						data-name="${member.memberName}" 
						data-email="${member.memberEmail}"
						data-dept="${member.memberDepartment || ''}"
						data-pos="${member.memberPosition || ''}">
						<i class="bi bi-plus-lg"></i> 추가
					</button>`;
		}
		html += `
			<div class="alert alert-light border shadow-sm mt-2 mb-0 animate__animated animate__fadeIn">
				<div class="d-flex justify-content-between align-items-center">
					<div class="d-flex align-items-center" style="max-width: 70%;">
						<div class="me-3 flex-shrink-0">
							<div class="bg-success text-white rounded-circle d-flex align-items-center justify-content-center fw-bold" style="width:40px; height:40px;">
								${member.memberName.charAt(0)}
							</div>
						</div>
						<div class="overflow-hidden">
							<div class="fw-bold text-dark text-truncate">
								${member.memberName} <small class="text-muted fw-normal">(${member.memberEmail})</small>
								<span class="badge bg-light text-success border border-success ms-1">회원</span>
							</div>
							<div class="small text-muted text-truncate">
								${member.memberDepartment || '-'} | ${member.memberPosition || '-'}
							</div>
						</div>
					</div>
					<div class="text-end ps-2" style="min-width: 80px;">
						<div class="mb-1">${roleBadge}</div>
						${btnHtml}
					</div>
				</div>
			</div>
		`;
	});	
		
	searchResultArea.innerHTML = html;
}

// 회원 검색 결과 : 비회원(가입되지 않은 이메일)
function renderNonMemberUI(email) {
    let role = document.querySelector('input[name="inviteType"]:checked').value;
    let roleText = role === 'CLIENT' ? '기업 담당자' : '팀원';
	
	// 비회원 객체
	const memberObjStr = JSON.stringify({
		memberEmail: email,
		memberName: '비회원',
		role: role,
		isMember: false
	}).replace(/"/g, '&quot;');
	
	let html = `
        <div class="card border-warning shadow-sm animate__animated animate__fadeIn">
            <div class="card-body">
                <div class="d-flex align-items-start mb-3">
                    <div class="me-3 fs-1 text-warning"><i class="bi bi-exclamation-circle"></i></div>
                    <div>
                        <h6 class="card-title fw-bold text-dark mb-1">회원 정보를 찾을 수 없습니다.</h6>
                        <p class="card-text text-muted small mb-0">
                            <strong>${email}</strong> 계정은 아직 가입되지 않았습니다.<br>
                            초대 메일을 보내 프로젝트에 참여를 요청할 수 있습니다
                        </p>
                    </div>
                </div>
                <div class="alert alert-light border small text-muted p-2 mb-3">
                    <i class="bi bi-info-circle-fill me-1"></i> 
                    상대방에게 <strong>${roleText}</strong> 권한으로 가입 초대 메일이 발송됩니다.
                </div>
                <div class="d-grid">
					<button class="btn btn-warning text-dark btn-sm fw-bold" onclick='addCandidateToBasket(${memberObjStr})'>
						<i class="bi bi-envelope-plus me-1"></i> 비회원 초대 추가
					</button>
                </div>
            </div>
        </div>
    `;
    DOM.searchResultArea.innerHTML = html;
}

// 초대 대기 목록에 사용자 추가
window.addCandidateToBasket = function(member) {
	// 중복 체크
	if(inviteCandidates.has(member.memberEmail)) return;
	inviteCandidates.set(member.memberEmail, member);
	
	renderCandidateList();
	
	// UI 초기화
	DOM.searchResultArea.innerHTML = '';
	DOM.searchInput.value = '';
	DOM.searchInput.focus();
}

// 초대 대기 목록 UI 갱신
function renderCandidateList() {
    DOM.candidateListArea.innerHTML = '';
	DOM.candidateCountBadge.textContent = inviteCandidates.size + "명";
	
	if(inviteCandidates.size === 0) {
		DOM.candidateListArea.innerHTML = `
			<li class="list-group-item border-0 text-center text-muted py-5 mt-5 empty-msg">
		    	<i class="bi bi-basket3 fs-1 text-secondary opacity-50 mb-3"></i>
		        <p class="small">검색된 사용자를 추가하면<br>이곳에 표시됩니다.</p>
		    </li>
		`;
		return;
	}

    inviteCandidates.forEach((member, email) => {
		// 팀원 / 기업 담당자 구분 뱃지
        const roleBadge = member.role === 'MEMBER' 
			? '<span class="badge bg-primary me-2">팀원</span>' 
			: '<span class="badge bg-warning text-dark me-2">기업 담당자</span>';
			            
		// 회원/비회원 구분 뱃지
		const memberBadge = member.isMember 
			? '<span class="badge bg-light text-success border border-success me-1">회원</span>' 
			: '<span class="badge bg-light text-secondary border me-1">비회원</span>';

        let li = document.createElement('li');
        li.className = 'list-group-item d-flex justify-content-between align-items-center animate__animated animate__fadeIn';
        li.innerHTML = `			
			<div>
				${roleBadge}
				<span class="fw-bold">${member.memberName}</span>
				${memberBadge}
				<small class="text-muted ms-1">(${email})</small>
			</div>
			<button type="button" class="btn-close btn-sm"  onclick="removeCandidateFromBasket('${email}')">
				
			</button>
		`;
        DOM.candidateListArea.appendChild(li);
    });
}

// 초대 대기목록 삭제
window.removeCandidateFromBasket = function(email) {
    inviteCandidates.delete(email);
    renderCandidateList();
}

// 모달 초기화
function resetInviteModal() {
    DOM.searchInput.value = '';
    DOM.searchResultArea.innerHTML = '';
    inviteCandidates.clear();
    renderCandidateList();
}


/// ============================================================
// 4. [메인] 테이블 적용 및 삭제
// ============================================================
// 모달 대기 목록 -> 폼 화면 테이블에 적용
function applyInviteListToMain() {
	
    if (inviteCandidates.size === 0) {
        Swal.fire('알림', '초대할 대상을 목록에 추가해주세요.', 'warning');
        return;
    }

	// 메인 테이블에 행 추가
    inviteCandidates.forEach((member) => {
        addMemberRowToMainTable(member);
    });

    // 모달 닫기
	const closeBtn = DOM.inviteModal.querySelector('[data-bs-dismiss="modal"]');
	    
	if (closeBtn) {
	    closeBtn.click(); // 취소 버튼과 동일하게 동작하도록 설정
	} else {
		// 만약 버튼을 못 찾으면 표준 API 사용
	    const modal = bootstrap.Modal.getOrCreateInstance(DOM.inviteModal);
	    modal.hide();
	}
	
	// 모달이 완전히 닫힌 후 hidden 이벤트에서 초기화(resetInviteModl()) 이벤트 진행
}

// 폼화면 테이블에 행 추가
function addMemberRowToMainTable(member) {
    const newRow = DOM.participantList.insertRow();
    
    newRow.setAttribute('data-type', member.role);
    newRow.classList.add('new-member-row'); // 신규로 추가된 행 식별자
    if (!member.isMember) newRow.classList.add('table-light'); // 비회원 배경색(회원과 다르게 설정)
	
	// 신규/비회원은 노란 배경
	newRow.classList.add('table-warning');

    // 역할 뱃지
	let roleBadge = '';
	if (member.role === 'MANAGER') {
		roleBadge = '<span class="badge bg-secondary"><i class="bi bi-person-fill me-1">프로젝트 관리자</span>';
	} else if (member.role === 'CLIENT') {
		roleBadge = '<span class="badge bg-warning text-dark"><i class="bi bi-building me-1"></i>기업 담당자</span>';
	} else {
		roleBadge = '<span class="badge bg-primary"><i class="bi bi-person-fill me-1">프로젝트 참여자</span>';
	}
   
	// 상태 뱃지 (신규: 초대중)
	let statusBadge = '<span class="badge bg-info text-dark border ms-1 animate__animated animate__flash animate__slow animate__infinite">초대중</span>';	
	
    // 사용자 이름(비회원: 괄호 표시)
    let nameDisplay = member.isMember 
        ? `<span class="fw-bold text-dark">${member.memberName}</span>`
        : `<span class="fw-bold text-muted">(${member.memberName})</span>`;

    newRow.innerHTML = `
		<td class="text-center">${roleBadge}</td>
        <td>
            ${nameDisplay}
            ${statusBadge}
        </td>
        <td>${member.memberEmail}</td>
        <td class="text-center">
            <button type="button" class="btn btn-sm btn-outline-danger p-1 btn-remove-member" title="삭제">
                <i class="bi bi-trash"></i>
            </button>
        </td>
    `;
}

// 폼화면 태이블 중복 체크 (이메일 기준)
function isMemberInMainTable(email) {
    let exists = false;
    const rows = DOM.participantList.querySelectorAll('tr');
    
    rows.forEach(row => {
        const emailCell = row.cells[2];
        if(emailCell) {
            const rowEmail = emailCell.innerText.trim();
            // 삭제된 멤버(취소선)가 아니면 중복
            if (rowEmail === email && !emailCell.classList.contains('text-decoration-line-through')) {
                exists = true;
            }
        }
    });
    return exists;
}

// 폼화면 테이블 클릭 이벤트 (삭제/복구/초대취소/관리자 권한 위임)
function handleMainTableClick(e) {
    // 삭제 버튼
    const btnRemove = e.target.closest('.btn-remove-member');
    if (btnRemove) {
        const tr = btnRemove.closest('tr');
        if(tr.classList.contains('new-member-row')) {
            tr.remove(); // 신규 행은 그냥 삭제
        } else {
			// 기존 멤버는 논리 삭제 처리
            if (confirm("이 사용자를 목록에서 제외하시겠습니까?")) toggleMemberRowStatus(tr, 'REMOVE');
        }
        return;
    }
    
    // 복구 버튼
    const btnRestore = e.target.closest('.btn-restore-member');
    if (btnRestore) {
        const tr = btnRestore.closest('tr');
        if (confirm("이 사용자를 다시 참여시키겠습니까?")) toggleMemberRowStatus(tr, 'RESTORE');
    }
	
	// 초대 취소 버튼
	const btnCancel = e.target.closest('.btn-cancel-invite');
	if (btnCancel) {
		const email = btnCancel.dataset.email;
		const projectNo = DOM.body.dataset.projectNo;

		Swal.fire({
			title: '초대 회수',
			html: `[<span class="text-primary fw-bold">${email}</span>]<br>초대를 취소하시겠습니까?<br><small class="text-muted">해당 링크는 즉시 무효화됩니다.</small>`,
			icon: 'warning',
			showCancelButton: true,
			confirmButtonColor: '#d33',
			confirmButtonText: '네, 회수합니다',
			cancelButtonText: '아니오'
		}).then((result) => {
			if (result.isConfirmed) {
				// 서버로 취소 요청 전송
				requestCancelInvite(projectNo, email, btnCancel);
			}
		});
		return;
	}
	
	// 프로젝트 관리자 권한 위임 버튼
	const btnDelegate = e.target.closest('.btn-delegate-manager');
	if (btnDelegate) {
	    const memberNo = btnDelegate.dataset.no;
	    const memberName = btnDelegate.dataset.name;
	    const projectNo = DOM.body.dataset.projectNo;

	    Swal.fire({
	        title: '관리자 권한 위임',
	        html: `<strong>[${memberName}]</strong> 님에게<br>프로젝트 관리자 권한을 넘기시겠습니까?<br><br><span class="text-danger small">※ 위임 후 회원님은 일반 팀원으로 변경되며,<br>프로젝트 설정 권한을 잃게 됩니다.</span>`,
	        icon: 'warning',
	        showCancelButton: true,
	        confirmButtonColor: '#d33',
	        cancelButtonColor: '#3085d6',
	        confirmButtonText: '네, 위임합니다',
	        cancelButtonText: '취소'
	    }).then((result) => {
	        if (result.isConfirmed) {
	            requestDelegateManager(projectNo, memberNo);
	        }
	    });
	    return;
	}
}

// 행 상태 변경
function toggleMemberRowStatus(tr, action) {
	const nameCell = tr.cells[1];
	const nameSpan = nameCell.querySelector('.fw-bold');
    const statusBadge = nameCell.querySelector('.badge:last-child'); // 상태 뱃지 위치
    const emailCell = tr.cells[2];
    const tdAction = tr.cells[3];

    if (action === 'REMOVE') {
        tr.classList.add('table-secondary', 'text-muted', 'excluded-member');
        if(nameSpan) { 
			nameSpan.classList.add('text-muted'); 
			nameSpan.classList.remove('text-dark'); 
		}
        emailCell.classList.add('text-decoration-line-through');
        
        // 뱃지 업데이트
        if(statusBadge) { 
			statusBadge.className = 'badge bg-secondary border ms-1'; 
			statusBadge.innerText = '제외됨'; 
		}
        
        tdAction.innerHTML = `
            <button type="button" class="btn btn-sm btn-outline-success p-1 btn-restore-member" title="복구">
                <i class="bi bi-arrow-counterclockwise"></i>
            </button>`;
            
    } else if (action === 'RESTORE') {
        tr.classList.remove('table-secondary', 'text-muted', 'excluded-member');
        if(nameSpan) { 
			nameSpan.classList.remove('text-muted'); 
			nameSpan.classList.add('text-dark'); 
		}
        emailCell.classList.remove('text-decoration-line-through');

		// 뱃지 업데이트
		if(statusBadge) { 
			statusBadge.className = 'badge bg-warning text-dark border ms-1'; 
			statusBadge.innerText = '초대중'; 
		}

        tdAction.innerHTML = `
            <button type="button" class="btn btn-sm btn-outline-danger p-1 btn-remove-member" title="삭제">
                <i class="bi bi-trash"></i>
            </button>`;
    }
}

// 프로젝트 초대 취소 요청
function requestCancelInvite(projectNo, email, btnElement) {
    const contextPath = DOM.body.dataset.contextPath || ''; 

    $.ajax({
        url: `${contextPath}/tudio/project/invite/cancel`,
        type: "post",
        data: JSON.stringify({ projectNo: parseInt(projectNo), email: email }),
        contentType: "application/json; charset=utf-8",
        success: function(res) {
            if (res.status === "SUCCESS") {
                Swal.fire('완료', '초대가 성공적으로 회수되었습니다.', 'success');
                const tr = btnElement.closest('tr');
                tr.style.transition = 'all 0.3s';
                tr.style.opacity = '0';
                setTimeout(() => {
                    tr.remove();
                }, 300);
                
            } else {
                Swal.fire('실패', res.message || '초대 취소에 실패했습니다.', 'error');
            }
        },
        error: function(xhr) {
            console.error(xhr);
            Swal.fire('에러', '서버 통신 중 오류가 발생했습니다.', 'error');
        }
    });
}

// 프로젝트 관리자 권한 위임 요청
function requestDelegateManager(projectNo, newManagerNo) {
    const contextPath = DOM.body.dataset.contextPath || '';

    $.ajax({
        url: `${contextPath}/tudio/project/delegate`,
        type: "post",
        data: JSON.stringify({ 
            projectNo: parseInt(projectNo), 
            newManagerNo: parseInt(newManagerNo) 
        }),
        contentType: "application/json; charset=utf-8",
        success: function(res) {
            if (res.status === "SUCCESS") {
                Swal.fire({
                    icon: 'success',
                    title: '위임 완료',
                    text: '관리자 권한이 성공적으로 변경되었습니다.\n메인 화면으로 이동합니다.'
                }).then(() => {
                    // 권한이 바뀌었으므로 더 이상 수정 페이지에 머물 수 없기 때문에 프로젝트 상세 페이지로 이동한다
                    location.href = `${contextPath}/tudio/project/detail?projectNo=` + projectNo; 
                });
            } else {
                Swal.fire('실패', res.message, 'error');
            }
        },
        error: function(xhr) {
            console.error(xhr);
            Swal.fire('에러', '서버 통신 중 오류가 발생했습니다.', 'error');
        }
    });
}


// ============================================================
// 5. [서버 통신] 프로젝트 생성/수정/상태변경
// ============================================================

// SortableJS 초기화
function initSortable() {
    const el = document.getElementById('tabSortableList');
    if (el) {
		const fixedTabRow = el.querySelector('tr[data-tap-id="8"]');
		if (fixedTabRow) {
			el.appendChild(fixedTabRow); 
		}
        Sortable.create(el, {
            animation: 150,
            handle: '.drag-handle',
            ghostClass: 'sortable-ghost',
            filter: '.static-row',
            onMove: evt => evt.related.className.indexOf('static-row') === -1
        });
    }
}

// 프로젝트 생성폼 / 수정폼 제출
function submitProject(contextPath, projectNo, status) {
    // 입력값 수집
    const projectName = document.getElementById('projectName').value;
    const projectDesc = document.getElementById('projectDesc').value;
    const projectType = document.getElementById('projectType').value;
    const startDate = document.getElementById('startDate').value;
    const endDate = document.getElementById('endDate').value;
    
    // 유효성 검사
    if (!projectName) { Swal.fire({ icon: 'warning', title: '필수 입력', text: "프로젝트명을 입력해주세요!" }); return false; }
    if (!projectType) { Swal.fire({ icon: 'warning', title: '필수 선택', text: "프로젝트 타입을 선택해주세요!" }); return false; }
    if (!startDate) { Swal.fire({ icon: 'warning', title: '필수 입력', text: "프로젝트 시작일을 입력해주세요!" }); return false; }
    if (!endDate) { Swal.fire({ icon: 'warning', title: '필수 입력', text: "프로젝트 종료일을 입력해주세요!" }); return false; }

    // 미니헤더 탭 순서
    const tabRows = document.querySelectorAll('#tabSortableList tr');
    const tabOrderList = [];
    tabRows.forEach(row => {
        const tabIdAttr = row.getAttribute('data-tap-id');
        const checkbox = row.querySelector('input[type="checkbox"]');
        if (tabIdAttr && checkbox && (checkbox.checked)) {
            tabOrderList.push(parseInt(tabIdAttr));
        }
    });
    
    // 구성원 (MEMBER / CLIENT)
    const memberList = [];
    const clientList = [];
    const memberRows = DOM.participantList.querySelectorAll('tr');

    memberRows.forEach(row => {
        // 제외된 멤버는 전송 데이터에 포함하지 않음
        if (row.classList.contains('excluded-member')) return;
		
		// td[0]: 권한, td[1]: 이름, td[2]: 이메일, td[3]: 버튼       
        // 본인(관리자) 제외 필터링
        const fullCellText = row.cells[1].innerText;
		const memberType = row.getAttribute('data-type') || 'MEMBER';
		
		// 본인(관리자) 제외 추가
        if (!memberType.includes("MANAGER") && !fullCellText.includes("프로젝트 관리자")) {
			// 이름/이메일 추출
			const emailText = row.cells[2].innerText.trim();
			const nameSpan = row.querySelector('.fw-bold');
			const nameText = nameSpan ? nameSpan.innerText.trim() : '비회원';
			
			let memberStatus = 'Y'; // 기본값 (기존 멤버)
			// 신규 초대 또는 기존 멤버여도 아직 초대 수락 안한 상태 = P
			if (row.classList.contains('new-member-row') || row.classList.contains('table-warning')) {
				memberStatus = 'P';
			}
			
            const memberData = {
                memberEmail: emailText,
                memberName: nameText,
                projectRole: memberType,
				projectMemstatus: memberStatus
            };

            if (memberType === 'CLIENT') {
                clientList.push(memberData);
            } else {
                memberList.push(memberData);
            }
        }
    });
    
    // 필수 구성원 유효성 검사 : 기업 담장자(CLIENT)
    if (clientList.length === 0) {
        Swal.fire({
            icon: 'warning',
            title: '구성원 누락',
            html: '프로젝트에는 최소 1명의 <b>기업 담당자(CLIENT)</b>가<br>포함되어야 합니다.'
        });
        return false; // 전송 중단
    }

    // 전송 데이터 객체 생성
    const data = {
        projectNo: projectNo,
        projectName: projectName,
        projectDesc: projectDesc,
        projectType: projectType,
        projectStartdate: startDate,
        projectEnddate: endDate,
        miniheader: { tabOrderList: tabOrderList },
        memberList: memberList,
        clientList: clientList
    };
    console.log("전송할 데이터: ", data);
    
    let requestUrl = `${contextPath}/tudio/project/create`;
	let loadingMsg = "프로젝트 생성 중 ...";
	let loadingHtml = "팀원들에게 초대 메일을 발송하고 있습니다.<br>잠시만 기다려주세요."; // 생성 시 메시지
	let successMsg = "프로젝트가 생성되었습니다";
            
    if (status === 'u') {
        requestUrl = `${contextPath}/tudio/project/update`;
		loadingMsg = "프로젝트 수정 중 ...";
		loadingHtml = "변경 정보를 안전하게 저장하고 있습니다.<br>잠시만 기다려주세요.";
        successMsg = "프로젝트가 수정되었습니다.";
    }
    
    if (typeof $ !== 'undefined') {
        $.ajax({
            url: requestUrl,
            type: "post",
            data: JSON.stringify(data),
            contentType: "application/json; charset=utf-8",
			beforeSend: function() {	// 전송 시작 전 로딩바 노출				
				Swal.fire({
					title: loadingMsg,
					html: loadingHtml,
					allowOutsideClick: false,
					didOpen: () => {
						Swal.showLoading();
					}
				});
			},
            success: function(res) {
                if (res.status === "SUCCESS") {
                    Swal.fire({ icon: 'success', title: '완료', text: successMsg })
                        .then(() => location.href = `${contextPath}/tudio/project/detail?projectNo=${res.projectNo}`);
                } else if (res.status === "ACCESS_DENIED") {
                    Swal.fire('권한 없음', res.message, 'error');  // message: 프로젝트 관리자만 수정할 수 있습니다.
                } else {
                    Swal.fire('실패', '프로젝트 처리에 실패했습니다.', 'error');
                }
            },
            error: function(xhr) {
                console.error(xhr);
                Swal.fire('에러', '서버 통신 중 오류가 발생했습니다.', 'error');
            }
        });
    }
}

// 프로젝트 상태 변경 (완료[1]/재진행[0])
function toggleProjectStatus(contextPath, projectNo, projectStatus) {
    let confirmTitle = '프로젝트 완료';
    let confirmText = "프로젝트를 완료 처리하시겠습니까? (모든 업무가 완료 상태여야 합니다)";
    let confirmBtnText = '네, 완료합니다';
    let confirmBtnColor = '#198754'; // color: green

	// 프로젝트를 재진행할 경우
    if (projectStatus === 0) {
        confirmTitle = '완료 취소';
        confirmText = "프로젝트를 다시 진행 상태로 변경하시겠습니까?";
        confirmBtnText = '네, 재진행합니다';
        confirmBtnColor = '#ffc107'; // color: yellow
    }
	
    Swal.fire({
        title: confirmTitle,
        text: confirmText,
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: confirmBtnColor,
        cancelButtonColor: '#6c757d',
        confirmButtonText: confirmBtnText,
        cancelButtonText: '취소'
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: `${contextPath}/tudio/project/status`,
                type: 'POST',
                data: JSON.stringify({ projectNo: projectNo, status: projectStatus }), 
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                success: function(res) {
                    if (res.status === "SUCCESS") {
						//  완료 상태(1)로 변경 성공 시 -> 결과보고서 알림창 
						if (projectStatus === 1) {
							Swal.fire({
								icon: 'success',
								title: '프로젝트 완료',
								html: '수고하셨습니다!<br>프로젝트가 성공적으로 완료되었습니다.<br><br><b>결과보고서를 작성하여 메일로 발송하시겠습니까?</b>',
								showCancelButton: true,
								confirmButtonText: '네, 결과보고서 작성',
								cancelButtonText: '나중에 하기',
								confirmButtonColor: '#0d6efd',
								cancelButtonColor: '#6c757d'
							}).then((result) => {
								const gopage = `${contextPath}/tudio/project/detail?projectNo=${projectNo}`;
								
								if (result.isConfirmed) {
									// 결과보고서 미리보기 페이지로 이동(새 창으로 열기)
									window.open(`${contextPath}/tudio/project/report/${projectNo}`, '_blank');									                                    
									// 기존 창은 프로젝트 메인 페이지로 이동
									location.href = gopage;
								} else {
									location.href = gopage; // 나중에 하기 -> 완료한 프로젝트 메인 페이지로 이동
								}
							});
						} else {
							// 재진행 상태(0)로 변경 성공 시 -> 새로고침하여 상태 반영
							Swal.fire('처리 완료', '상태가 변경되었습니다.', 'success')
								.then(() => location.reload());
						}    
					} else if (res.status === "NO_CLIENT_Y") {
		            	// 활성화된 기업 담당자가 없는 경우
						Swal.fire({
							title: '완료 불가',
							html: '현재 프로젝트에 <b>참여 중(Y)인 기업 담당자</b>가 없습니다.<br>담당자가 초대를 수락했는지 확인해주세요.',
							icon: 'error'
						});
					} else if (res.status === "NO_TASKS") {
						// 등록된 업무가 아예 없는 경우
						Swal.fire({
							title: '완료 불가',
							text: '등록된 업무가 없습니다. 프로젝트 업무를 추가해주세요.',
							icon: 'warning'
						});					                                       
                    } else if (res.status === "UNFINISHED_TASKS") {
                        Swal.fire({
                            title: '완료 불가',
                            html: `미완료된 업무가 <b>${res.count}</b>건 존재합니다.`,
                            icon: 'warning'
                        });
                    } else {
                        Swal.fire('실패', res.message || '오류 발생', 'error');
                    }
                },
                error: function(xhr) {
                    Swal.fire('에러', '서버 통신 중 오류가 발생했습니다!', 'error');
                }
            });
        }
    });
}

// 프로젝트 삭제 (논리삭제)
function handleDeleteProject() {
    const projectNo = DOM.body.dataset.projectNo;
    const contextPath = DOM.body.dataset.contextPath || '';

    Swal.fire({
        title: '프로젝트 삭제',
        html: `정말 프로젝트를 삭제하시겠습니까?<br><span class="text-danger small">팀원들이 더 이상 접근할 수 없게 됩니다.</span>`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        cancelButtonColor: '#6c757d',
        confirmButtonText: '네, 삭제합니다',
        cancelButtonText: '취소',
        focusCancel: true
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: `${contextPath}/tudio/project/delete`,
                type: 'POST',
                data: JSON.stringify({ projectNo: projectNo }),
                contentType: 'application/json; charset=utf-8',
                success: function(res) {
                    if (res.status === "SUCCESS") {
                        Swal.fire(
                            '삭제 완료',
                            '프로젝트가 삭제 처리되었습니다.\n목록으로 이동합니다.',
                            'success'
                        ).then(() => {
                            location.href = `${contextPath}/tudio/project/list`; 
                        });
                    } else {
                        Swal.fire('실패', res.message || '오류가 발생했습니다.', 'error');
                    }
                },
                error: function(xhr) {
                    console.error(xhr);
                    Swal.fire('에러', '서버 통신 중 오류가 발생했습니다.', 'error');
                }
            });
        }
    });
}

// 시연용 자동 입력 함수 
function autoFillProjectData() {
    // [1] 프로젝트 기본 정보
    document.getElementById('projectName').value = "네이버 쇼핑 웹사이트 유지 보수";
	
	const descText = `본 프로젝트는 네이버 쇼핑 웹사이트의 안정적인 운영을 위해 진행되는 유지보수 프로젝트입니다.
		서비스 운영 중 발생하는 기능 개선 요청, 오류 대응, 성능 및 안정성 관리, 정기 점검 업무를 체계적으로 관리하고, 빠른 이슈 대응과 서비스 품질 유지를 목표로 합니다.
		프로젝트 관리 시스템을 통해 업무 진행 상황, 일정, 커뮤니케이션 이력을 투명하게 관리하여 운영 리스크를 최소화하고 효율적인 유지보수 체계를 구축합니다.`;
	// 줄바꿈 후 생기는 탭/공백 제거 
	document.getElementById('projectDesc').value = descText.replace(/^\s+/gm, '');
	
    document.getElementById('projectType').value = "101"; // IT(101)

    // [2] 프로젝트 기간
	// 프로젝트 시작일 2026.02.02
	// 프로젝트 종료일 2026.05.31
	document.getElementById('startDate').value = '2026-02-02'; // 시작일 지정
	document.getElementById('endDate').value = '2026-05-31';   // 마감일 지정 

    // [3] 구성원 
    // - 반드시 CLIENT 권한을 가진 멤버가 1명 이상 포함되어야 생성이 가능
	// memberNo 실제 DB에 있는 회원 번호
    const demoMembers = [
        {
            memberNo: 44,
            memberName: "김현진",
            memberEmail: "c005@ddit.com",
            role: "CLIENT",
            isMember: true
        },
        {
            memberNo: 41,
            memberName: "이은휴",
            memberEmail: "c001@ddit.com",
            role: "MEMBER",
            isMember: true
        },
		{
			memberNo: 39,
			memberName: "김미선",
			memberEmail: "c002@ddit.com",
			role: "MEMBER",
			isMember: true
		},
		{
			memberNo: 42,
			memberName: "양효비",
			memberEmail: "c003@ddit.com",
			role: "MEMBER",
			isMember: true
		},
		{
			memberNo: 43,
			memberName: "박시은",
			memberEmail: "c006@ddit.com",
			role: "MEMBER",
			isMember: true
		},
		{
			memberNo: 40,
			memberName: "김진솔",
			memberEmail: "c007@ddit.com",
			role: "MEMBER",
			isMember: true
		},
		// 비회원인 경우
		{
		    memberNo: 0,              		
		    memberName: "비회원",   		
		    memberEmail: "evehyun0625@naver.com", // 초대 메일이 발송될 이메일
		    role: "MEMBER",           
		    isMember: false           
		}
    ];

    // 기존 목록 비우기 (본인 제외)
    const rows = DOM.participantList.querySelectorAll('tr');
    rows.forEach(row => {
        if (!row.getAttribute('data-type').includes('MANAGER')) {
            row.remove();
        }
    });

    // 더미 데이터 멤버 추가
    demoMembers.forEach(member => {
        if (!isMemberInMainTable(member.memberEmail)) {
            addMemberRowToMainTable(member);
        }
    });
}