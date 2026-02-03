// 1. 공통 변수 설정
if (typeof urlParams === 'undefined') {
	var urlParams = new URLSearchParams(window.location.search);
}
if (typeof ctxPath === 'undefined') {
	var ctxPath = window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
}

if (window.projectNo == null) {
	const urlParam = new URLSearchParams(location.search).get('projectNo');
	if (urlParam) {
		window.projectNo = Number(urlParam);
	}
}

console.log('[확정 projectNo]', window.projectNo);

//회의 참석자 배열
if (typeof selectedMembers === 'undefined') {
	var selectedMembers = [];
}

//페이지 로드 시 실행
$(function() {
	//초기 리스트 로드
	if ($('#boardTbody').length > 0) loadList(1);
		
	// [페이지네이션 클릭 처리]
	$(document).off('click', '#boardPager a').on('click', '#boardPager a', function(e) {
	    e.preventDefault(); 
	    
	    let pageNo = null;
	    const href = $(this).attr('href');
	    const text = $(this).text().trim();
	    const dataPage = $(this).data('page'); 

	    if (dataPage) {
	        pageNo = dataPage;
	    }
	    else if (href && href.includes('page=')) {
	        const match = href.match(/page=([0-9]+)/);
	        if (match && match[1]) {
	            pageNo = match[1];
	        }
	    }
	    else if (!isNaN(text) && text !== "") {
	        pageNo = text;
	    }

	    if (pageNo) {
	        loadList(pageNo); 
	    } else {
	        console.warn("페이지 번호를 찾을 수 없습니다.");
	    }
	});
	

	$(document).off('click', '.tudio-pill').on('click', '.tudio-pill', function() {
	    $(".tudio-pill").removeClass("is-active");
	    $(this).addClass("is-active");
	    loadList(1);
	});

	// [등록/수정 폼 로드]
	$(document).off('click', '#btnInsertForm').on('click', '#btnInsertForm', function() {
		const url = `${ctxPath}/tudio/project/board/insert?projectNo=${window.projectNo}`;
		$(".tudio-board").load(url, initInsertForm);
	});
	sss
	// [참석자 추가]
	$(document).off('click', '.btn-add-member').on('click', '.btn-add-member', function() {
		const li = $(this).closest('li');
		    const memNo = String(li.data('no'));
		    const memName = li.data('name');

		    if (selectedMembers.find(m => m.no === memNo)) {
		        Swal.fire({
		            title: '알림',
		            text: '이미 추가된 멤버입니다.',
		            icon: 'info',
		            timer: 1500,
		            showConfirmButton: false
		        });
		        return;
		    }

		    selectedMembers.push({ no: memNo, name: memName });
		    renderSelectedMembers();

		    Swal.fire({
		        title: '성공',
		        text: `${memName}님이 추가되었습니다.`,
		        icon: 'success',
		        timer: 1000, 
		        showConfirmButton: false
		    });
	});

	// [참석자 삭제]
	$(document).off('click', '.btn-remove-member').on('click', '.btn-remove-member', function() {
		const targetNo = String($(this).data('no'));
		selectedMembers = selectedMembers.filter(m => m.no !== targetNo);
		renderSelectedMembers();
	});

	//[참석자 검색]
	$(document).off('input', '#memberSearchInput')
		.on('input', '#memberSearchInput', function() {
			const val = $(this).val().trim().toLowerCase();
			$('#memberSearchList .member-item').each(function() {
				const memberText = $(this).text().toLowerCase();
				const isMatch = memberText.indexOf(val) > -1;

				$(this).css('display', isMatch ? 'flex' : 'none');
			});
		});

	// [검색 버튼]
	$(document).off('click', '#btnSearch')
		.on('click', '#btnSearch', function() {
			loadList(1);
		});

	// [목록으로 돌아가기]
	$(document).off('click', '#btnBackToList')
		.on('click', '#btnBackToList', function() {
			$(".tudio-board").load(
				`${ctxPath}/tudio/project/board?projectNo=${window.projectNo}`
			);
		});
		
	$(document).on('click', '#boardTbody tr.row-click', function(e) {
		// 만약 a태그나 버튼 클릭을 방해하지 않으려면 체크 (옵션)
		if ($(e.target).is('button, i, input')) return;

		// 해당 행의 boNo 가져오기 (이미 onclick이 달려있지만, 안전하게 여기서 실행)
		const boNo = $(this).find('.title').attr('onclick').match(/\d+/)[0];
		goDetail(boNo);
	});
});

// 카테고리에 따라 회의록 영역 보이기/숨기기 함수
function toggleMeetingArea(category) {
	if (category === 'MINUTES') {
		$('#meetingDetailsArea, #meetingResultArea').stop().slideDown(300);
		$('#titleLabel').html('<i class="bi bi-tag-fill me-1"></i> 회의 주제');
		$('#submitBtn').html('<i class="bi bi-check-lg"></i> 회의록 저장');
		renderSelectedMembers(); 
	} else {
		$('#meetingDetailsArea, #meetingResultArea').stop().slideUp(200);
		$('#titleLabel').html('<i class="bi bi-tag-fill me-1"></i> 제목');
		$('#submitBtn').html('<i class="bi bi-check-lg"></i> 게시글 저장');
	}
}

// 폼 저장 핸들러
function handleFormSubmit(e) {
	e.preventDefault();
	const form = this;
	const category = $('input[name="categoryName"]:checked').val();

	if (!$('#boardTitle').val().trim()) {
		Swal.fire('알림', '제목을 입력해주세요.', 'warning');
		return;
	}

	Swal.fire({ title: '저장하시겠습니까?', showCancelButton: true }).then(res => {
		if (res.isConfirmed) {
			const formData = new FormData(form);
			$.ajax({
				url: $(form).attr('action'),
				type: 'POST',
				data: formData,
				processData: false,
				contentType: false,
				success: function(res) {
					if (res.status === "success") {
						Swal.fire('완료', '저장되었습니다.', 'success')
						const finalBoNo = res.boNo || $('#boNo').val(); 
						            goDetail(finalBoNo);
					}
				}
			});
		}
	});
}


// ★★★ [핵심 수정] 목록 로드 함수 ★★★
function loadList(page) {
	let category = $(".tudio-pill.is-active").data("category") || "";
	let searchType = $("#searchType").val();
	let searchWord = $("#searchWord").val();

    // 오늘 날짜 구하기 (YYYY-MM-DD) - NEW 아이콘용
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const todayStr = `${year}-${month}-${day}`;

	$.ajax({
		url: ctxPath + "/tudio/project/board/listData",
		type: "GET",
		data: {
			projectNo: window.projectNo,
			category: category,
			page: page,
			searchType: searchType,
			searchWord: searchWord
		},
		success: function(res) {
			// 1. 총 건수 표시
			$("#totalCnt").text(res.totalRecord);

			// 2. 리스트 그리기
			let html = "";
			if (res.dataList && res.dataList.length > 0) {
				res.dataList.forEach(board => {
					console.log(`글번호: ${board.boNo}, 제목: ${board.boTitle}, 파일개수: ${board.fileCount}`);
					// 뱃지 HTML 생성
					let badgeHtml = getBadgeHtml(board.categoryName);
					
					// 날짜 자르기 (YYYY-MM-DD)
					let dateStr = board.boRegdate;
					if(dateStr && dateStr.length >= 10) dateStr = dateStr.substring(0, 10);

					// 멤버 이름 처리
					let memName = board.memberVO ? board.memberVO.memberName : '-';

                    // 파일 아이콘
					let fileHtml = "";
					if (board.fileCount > 0) {
						fileHtml = `<span class="file-icon-wrap" title="첨부파일 ${board.fileCount}개">
					                                        <i class="bi bi-paperclip"></i> 
					                                        <span>${board.fileCount}</span>
					                                    </span>`;
					}

                    // NEW 아이콘 처리
					let newIconHtml = "";
					if (dateStr === todayStr) {
						newIconHtml = `<span class="badge-new-style">N</span>`;
					}

                    // [수정] onclick에 style='cursor:pointer' 추가하고, 파일/NEW 아이콘 결합
					html += `
											<tr class="row-click">
												<td class="text-center">${badgeHtml}</td>
												<td class="title" onclick="goDetail(${board.boNo})" style="cursor: pointer;">
													<span class="text-dark text-decoration-none">
					                                    ${board.boTitle}
					                                </span>
					                                ${fileHtml}
					                                ${newIconHtml}
												</td>
												<td class="text-center">${memName}</td>
												<td class="text-center">${dateStr}</td>
												<td class="text-center">${board.boHit}</td>
											</tr>`;
				});
			} else {
				html = "<tr><td colspan='6' class='text-center'>게시글이 없습니다.</td></tr>";
			}
			$("#boardTbody").html(html);

			// 페이징 HTML 넣기
			$("#boardPager").html(res.pagingHTML);
		},
        error: function(xhr, status, error) {
            console.error("=== [Error] AJAX 요청 실패 ===");
            console.error("상태코드:", xhr.status);
            
            if(xhr.status == 404) {
                alert("URL을 찾을 수 없습니다.");
            } else {
                alert("목록을 불러오는 중 오류가 발생했습니다.");
            }
        }
	});
}

function loadProjectMembers() {
	$.get(
		`${ctxPath}/tudio/project/member/view`,
		{ projectNo: window.projectNo },
		function(list) {
			const ul = $('#memberSearchList');
			ul.empty();

			list.forEach(m => {
				ul.append(`
					<li class="list-group-item member-item d-flex justify-content-between align-items-center"
					                        data-no="${m.memberNo}"
					                        data-name="${m.memberName}">
					                        <span>${m.memberName} (${m.memberId})</span>
					                        <button type="button" class="btn btn-sm btn-outline-primary btn-add-member">추가</button>
					                    </li>
                `);
			});
		}
	);
};

// 헬퍼 함수: 뱃지 정보
function getBadgeInfo(category) {
	switch (category) {
		case 'NOTICE': return { txt: "공지", cls: "badge-red" };
		case 'FREE': return { txt: "자유", cls: "badge-yellow" };
		case 'MINUTES': return { txt: "회의록", cls: "badge-blue" };
		default: return { txt: "기타", cls: "badge-default" };
	}
}
function getBadgeHtml(category) {
	const info = getBadgeInfo(category);
	return `<span class="tudio-badge ${info.cls}">${info.txt}</span>`;
}

//글쓰기 폼
function initInsertForm() {

	selectedMembers = []; 

	const serverCategoryInput = $('#serverCategory');
	let currentCategory = null;

	if (serverCategoryInput.length > 0) {
		currentCategory = serverCategoryInput.val();
		$(`input[name="categoryName"][value="${currentCategory}"]`).prop('checked', true);
	} else {
		currentCategory = $('input[name="categoryName"]:checked').val();
	}
	
	$('.old-mem').each(function() {
		const no = String($(this).data('no'));
		const name = $(this).data('name');

		if (no && name && !selectedMembers.find(m => m.no === no)) {
			selectedMembers.push({ no, name });
		}
	});

	loadProjectMembers();
	toggleMeetingArea(currentCategory);
	renderSelectedMembers();

	$('#insertForm').off('submit').on('submit', handleFormSubmit);

}

// 선택 멤버 태그로 보이기
function renderSelectedMembers() {
	const nameArea = $('#selectedAttendeeNames');
	const inputArea = $('#attendeeHiddenInputs');
	if (!nameArea.length) return; 

	nameArea.empty();
	inputArea.empty();

	if (selectedMembers.length === 0) {
		nameArea.append('<span class="text-muted">선택된 참석자가 없습니다.</span>');
		return;
	}

	selectedMembers.forEach((mem, index) => {
		nameArea.append(`
            <span class="attendee-tag">
                ${mem.name}
                <span class="btn-remove-member" data-no="${mem.no}">&times;</span>
            </span>
        `);
		inputArea.append(`<input type="hidden" name="meetingMemberList[${index}].memberNo" value="${mem.no}">`);
	});
}

// 상세화면 페이지
function goDetail(boNo) {
	const projectNo = window.projectNo;
	$.post(ctxPath + "/tudio/project/board/hit", { boNo });

	$(".tudio-board").load(
		`${ctxPath}/tudio/project/board/detail?projectNo=${projectNo}&boNo=${boNo}`,
		function() {
			window.scrollTo(0, 0);
		}
	);
}

// 게시글 상세 - 수정버튼 클릭
function goUpdate(pNo, boNo) {
	$(".tudio-board").load(`${ctxPath}/tudio/project/board/update?projectNo=${pNo}&boNo=${boNo}`, function() {
		initInsertForm();
	});
}

// 게시글 상세 - 삭제버튼 클릭
function deleteBoard(boNo) {
	Swal.fire({
		title: '정말 삭제하시겠습니까?',
		text: "삭제된 게시글은 복구할 수 없습니다.",
		icon: 'warning',
		showCancelButton: true,
		confirmButtonColor: '#d33',
		confirmButtonText: '삭제',
		cancelButtonText: '취소'
	}).then((result) => {
		if (result.isConfirmed) {
			$.ajax({
				url: `${ctxPath}/tudio/project/board/delete`,
				type: 'POST',
				data: { boNo: boNo },
				success: function(res) {
					Swal.fire('완료', '게시글이 삭제되었습니다.', 'success').then(() => {
						$(".tudio-board").load(`${ctxPath}/tudio/project/board?projectNo=${window.projectNo}`);
					});
				},
				error: function() {
					Swal.fire('오류', '삭제 처리 중 문제가 발생했습니다.', 'error');
				}
			});
		}
	});
}

// 게시글 수정 데이터 관련
function setupUpdateData() {
	const currentCategory = $('input[name="categoryName"]:checked').val();
	if (currentCategory === 'MINUTES') {
		$('#meetingDetailsArea, #meetingResultArea').show();

		$('.old-mem').each(function() {
			const no = String($(this).data('no'));
			const name = $(this).data('name');
			if (no && name) {
				selectedMembers.push({ no: no, name: name });
			}
		});
		renderSelectedMembers();
	}
}