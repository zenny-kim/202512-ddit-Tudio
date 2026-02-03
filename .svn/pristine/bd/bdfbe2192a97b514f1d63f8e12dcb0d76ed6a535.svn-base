/**
 * projectCreate.js
 * 프로젝트 생성 페이지 관련 로직
 */

document.addEventListener('DOMContentLoaded', function() {
	
	const CONTEXT_PATH = document.body.dataset.contextPath;
	const STATUS = document.body.dataset.status;
	const PROJECT_NO = document.body.dataset.projectNo;
    
    // 1. 탭 순서 변경 (SortableJS) 초기화
    initSortable();

    // 2. 버튼 이벤트 리스너 등록
    // 2-1. 프로젝트 생성 버튼
    const btnSubmit = document.getElementById('projectSubmitBtn');
    if(btnSubmit) {
		// 함수 실행이 아니라 함수 자체를 넘겨야 하므로 화살표 함수 사용
		btnSubmit.addEventListener('click', () => submitProject(CONTEXT_PATH, PROJECT_NO, STATUS));
    }

    // 2-2. 팀원 초대 모달의 '추가' 버튼
    const btnInvite = document.getElementById('processInviteBtn');
    if(btnInvite) {
        btnInvite.addEventListener('click', () => processInvitations(CONTEXT_PATH));
    }
	
	const participantList = document.getElementById('participantList');
	if (participantList) {
		participantList.addEventListener('click', function(e) {
			// 1. [삭제] 버튼
			// 클릭된 요소가 .btn-remove-member 클래스를 가지고 있거나, 그 안의 아이콘이면 실행
			const btnRemove = e.target.closest('.btn-remove-member');
			if (btnRemove) {
				if (confirm("이 사용자를 목록에서 제거하시겠습니까?")) {
					btnRemove.closest('tr').remove();
				}
			}
			
			// 2. [복구] 버튼
			const btnRestore = e.target.closest('.btn-restore-member');
			if (btnRestore) {
				if (confirm("이 사용자를 다시 프로젝트에 참여시키겠습니까?")) {
					const tr = btnRestore.closest('tr');

					// 스타일 원복
					tr.classList.remove('table-secondary', 'text-muted', 'excluded-member');
					tr.querySelector('.fw-bold').classList.remove('text-muted');
					tr.querySelector('.fw-bold').classList.add('text-dark');
					tr.cells[1].classList.remove('text-decoration-line-through');

					// 뱃지 변경 (제외됨 -> 참여중)
					const statusBadge = tr.querySelector('.badge:last-child'); // 마지막 뱃지
					statusBadge.className = 'badge bg-success border ms-1';
					statusBadge.innerText = '복구됨';

					// 버튼 변경 (복구 -> 삭제)
					const tdAction = btnRestore.parentElement;
					tdAction.innerHTML = `
			        	<button type="button" class="btn btn-sm btn-outline-danger p-1 btn-remove-member" title="삭제">
			            	<i class="bi bi-trash"></i>
			        	</button>
			    	`;
				}
			}
		});
	}
	
	// 프로젝트 완료 버튼 (0 -> 1)
	const btnComplete = document.getElementById('btnCompleteProject');
	if (btnComplete) {
		btnComplete.addEventListener('click', () => toggleProjectStatus(CONTEXT_PATH, PROJECT_NO, 1));
	}
 
	// 프로젝트 재진행 버튼 (1 -> 0)
	const btnReopen = document.getElementById('btnReopenProject');
	if (btnReopen) {
		btnReopen.addEventListener('click', () => toggleProjectStatus(CONTEXT_PATH, PROJECT_NO, 0));
	}
});


// Sortable
function initSortable() {
    const el = document.getElementById('tabSortableList');
    if (el) {
        Sortable.create(el, {
            animation: 150,
            handle: '.drag-handle',
            ghostClass: 'sortable-ghost',
            filter: '.static-row',
            onMove: evt => evt.related.className.indexOf('static-row') === -1
        });
    }
}

function submitProject(contextPath, projectNo, status) {
	// 프로젝트 기본 정보
	const projectName = document.getElementById('projectName').value;
	const projectDesc = document.getElementById('projectDesc').value;
	const projectType = document.getElementById('projectType').value;
	const startDate = document.getElementById('startDate').value;
	const endDate = document.getElementById('endDate').value;
	
	// 유효성 검사 (SweetAlert2)
	if (!projectName) { Swal.fire({ icon: 'warning', title: '필수 입력', text: "프로젝트명을 입력해주세요!" }); return false; }
	if (!projectType) { Swal.fire({ icon: 'warning', title: '필수 선택', text: "프로젝트 타입을 선택해주세요!" }); return false; }
	if (!startDate) { Swal.fire({ icon: 'warning', title: '필수 입력', text: "프로젝트 시작일을 입력해주세요!" }); return false; }
	if (!endDate) { Swal.fire({ icon: 'warning', title: '필수 입력', text: "프로젝트 종료일을 입력해주세요!" }); return false; }

	// 미니헤더(탭) 순서 
	const tabRows = document.querySelectorAll('#tabSortableList tr');
	const tabOrderList = [];
	tabRows.forEach(row => {
		const tabIdAttr = row.getAttribute('data-tap-id');
		const checkbox = row.querySelector('input[type="checkbox"]');
		if (tabIdAttr && checkbox && (checkbox.checked)) {
			tabOrderList.push(parseInt(tabIdAttr));
		}
	});
	
	// 구성원(팀원/고객) 분리
	const memberRows = document.querySelectorAll('#participantList tr');
	const memberList = [];
	const clientList = [];

	memberRows.forEach(row => {
		// excluded-member 클래스가 있으면(비활성 프로젝트 구성원) 전송 데이터에 포함하지 않음
		if (row.classList.contains('excluded-member')) {
			return; // 건너뛰기
		}
		
		let nameText = "";
		const nameSpan = row.querySelector('.fw-bold');
		if (nameSpan) {
			nameText = nameSpan.innerText.trim();
		} else {
			nameText = row.cells[0].innerText.trim();
		}

		const emailText = row.cells[1].innerText.trim();
		const userType = row.getAttribute('data-type') || 'MEMBER';

		// 필터링 검사
		const fullCellText = row.cells[0].innerText;

		// 본인 제외하고 추가
		if (!fullCellText.includes("(본인)") && !fullCellText.includes("관리자")) {
			const memberData = {
				memberEmail: emailText,
				memberName: nameText
			};

			if (userType === 'CLIENT') {
				clientList.push(memberData);
			} else {
				memberList.push(memberData);
			}
		}
	});
	
	// 필수 구성원 유효성 검사 : 기업 담당자(CLIENT)
	if (clientList.length === 0) {
		Swal.fire({
			icon: 'warning',
			title: '구성원 누락',
			html: '프로젝트에는 최소 1명의 <b>기업 담당자(CLIENT)</b>가<br>포함되어야 합니다.'
		});
		return false; // 전송 중단
	}

	// 전송 데이터 생성
	const data = {
		projectNo: projectNo,
		projectName: projectName,
		projectDesc: projectDesc,
		projectType: projectType,
		projectStartdate: startDate,
		projectEnddate: endDate,
		miniheader: {
			tabOrderList: tabOrderList
		},
		memberList: memberList,
		clientList: clientList
	};

	console.log("전송할 데이터: ", data);
	
	let requestUrl = `${contextPath}/tudio/project/create`;
	let successMsg = "프로젝트가 생성되었습니다.";
	        
	if (status === 'u') {
		requestUrl = `${contextPath}/tudio/project/update`; // 수정 URL
		successMsg = "프로젝트가 수정되었습니다.";
	}
	
	// AJAX 전송
	if (typeof $ !== 'undefined') {
		$.ajax({
			url: requestUrl,
			type: "post",
			data: JSON.stringify(data),
			contentType: "application/json; charset=utf-8",
			success: function(res) {
				if (res.status === "SUCCESS") {

					// 성공은 했지만 실패한 이메일이 있는 경우 확인
					const failedEmails = res.failedEmails || [];

					if (failedEmails.length > 0) {
						// 일부 초대 실패 알림
						let msg = `프로젝트는 생성되었으나, 다음 사용자는 <b style="color:red">가입되지 않은 이메일</b>이라 초대하지 못했습니다.<br><br>`
							+ failedEmails.join('<br>');

						Swal.fire({
							icon: 'warning',
							title: '일부 초대 실패',
							html: msg
						}).then(() => {
							location.href = `${contextPath}/tudio/project/detail?projectNo=${res.projectNo}`;	// 상세페이지 이동
						});
					} else {
						// 성공
						Swal.fire({
							icon: 'success',
							title: '완료',
							text: `${successMsg}`
						}).then(() => {
							location.href = `${contextPath}/tudio/project/detail?projectNo=${res.projectNo}`;   // 상세페이지 이동
						});
					}
				} else if (res.status === "ACCESS_DENIED") {
	            	// 권한 없음 알림
				    Swal.fire({
				    	icon: 'error',
				        title: '권한 없음',
				        text: res.message // message: 프로젝트 관리자만 수정할 수 있습니다.
					});  
				}else {
					Swal.fire('실패', '프로젝트 생성에 실패했습니다.', 'error');
				}
			},
			error: function(xhr, status, error) {
				console.error(error);
				Swal.fire('에러', '서버 통신 중 오류가 발생했습니다: ' + xhr.status, 'error');
			}
		});
	} else {
		alert("jQuery가 로드되지 않았습니다.");
	}
}

// 4. 구성원 초대 및 검증 처리 로직
function processInvitations(contextPath) {
	const activeTabButton = document.querySelector('#inviteTabs .active');
	const activeTabId = activeTabButton.id;
	let emailList = [];

	// 초대 유형
	const inviteType = document.querySelector('input[name="inviteType"]:checked').value;

	if (activeTabId === 'excel-tab') {
		alert("엑셀 기능은 현재 구현 중입니다. 직접 입력을 이용해주세요.");
		return;
	} else {
		const emailText = document.getElementById('inviteEmails').value;
		if (!emailText.trim()) {
			Swal.fire('입력 오류', '이메일 주소를 입력해주세요.', 'warning');
			return;
		}
		emailList = emailText.split(/[\n,]+/).map(e => e.trim()).filter(e => e);
	}

	if (emailList.length === 0) return;

	// 서버 검증 요청
	$.ajax({
		url: `${contextPath}/tudio/project/check-emails`,
		type: "post",
		data: JSON.stringify(emailList),
		contentType: "application/json; charset=utf-8",
		success: function(res) {
			const validMembers = res.validMembers;
			let addedCount = 0;

			const currentEmails = [];
			document.querySelectorAll('#participantList tr td:nth-child(2)').forEach(td => {
				currentEmails.push(td.innerText.trim());
			});

			// 유효한 회원은 테이블에 추가
			validMembers.forEach(member => {
				if (!currentEmails.includes(member.memberEmail)) {
					addMemberRow(member.memberName, member.memberEmail, inviteType);
					addedCount++;
				}
			});

			const invalidEmails = res.invalidEmails;

			// 결과 메시지 처리
			if (invalidEmails.length > 0) {
				let msg = `다음 이메일은 <b style="color:red;">가입되지 않은 사용자</b>입니다:<br>` + invalidEmails.join('<br>');
				if (addedCount > 0) msg = `${addedCount}명 추가 완료.<br><hr>` + msg;
				Swal.fire({ icon: 'warning', title: '초대 결과', html: msg });
			} else if (addedCount > 0) {
				const roleName = inviteType === 'CLIENT' ? '기업 담당자' : '팀원';
				Swal.fire({
					icon: 'success',
					title: '초대 완료',
					text: `${roleName} ${addedCount}명을 추가했습니다.`
				});

				document.getElementById('inviteEmails').value = '';
				const modal = bootstrap.Modal.getInstance(document.getElementById('inviteModal'));
				modal.hide();
			} else {
				Swal.fire('중복', '이미 구성원에 추가된 사용자입니다.', 'info');
			}
		},
		error: function(xhr) {
			console.error(xhr);
			Swal.fire('에러', '사용자 확인 중 오류가 발생했습니다.', 'error');
		}
	});
}

// 목록 행 추가 함수
function addMemberRow(name, email, type) {
    const listBody = document.getElementById('participantList');
    const newRow = listBody.insertRow();
    
    newRow.setAttribute('data-type', type);
    
    let badgeHtml = type === 'CLIENT' 
        ? `<span class="badge bg-warning text-dark ms-2"><i class="bi bi-building-fill me-1">기업 담당자</i></span>` 
        : `<span class="badge bg-primary ms-2"><i class="bi bi-person-fill me-1">프로젝트 참여자</i></span>`;
    
    newRow.innerHTML = `
        <td>
            <span class="fw-bold text-dark">${name}</span>
            ${badgeHtml}
            <span class="badge bg-light text-secondary border ms-1">초대됨</span>
        </td>
        <td>${email}</td>
        <td class="text-center">
            <button type="button" class="btn btn-sm btn-outline-danger p-1 btn-remove-member" title="삭제">
                <i class="bi bi-trash"></i>
            </button>
        </td>
    `;
}

// 프로젝트 상태 변경 함수 (status: 0(진행중) or 1(완료))
function toggleProjectStatus(contextPath, projectNo, projectStatus) {
    
    let confirmTitle = '프로젝트 완료';
    let confirmText = "프로젝트를 완료 처리하시겠습니까? (모든 업무가 완료 상태여야 합니다)";
    let confirmBtnText = '네, 완료합니다';
    let confirmBtnColor = '#198754'; // Green

    // 재진행(완료 취소)일 경우 문구 변경
    if (projectStatus === 0) {
        confirmTitle = '완료 취소';
        confirmText = "프로젝트를 다시 진행 상태로 변경하시겠습니까?";
        confirmBtnText = '네, 재진행합니다';
        confirmBtnColor = '#ffc107'; // Yellow/Warning
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
                        Swal.fire('처리 완료', '상태가 변경되었습니다.', 'success')
                            .then(() => location.reload()); // 화면 새로고침하여 배지/버튼 반영
                            
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
                    console.error(xhr);
                    Swal.fire('에러', '서버 통신 중 오류가 발생했습니다!', 'error');
                }
            });
        }
    });
}

