/**
 * ======================================================================================
 * [공통 댓글 시스템 가이드 - comment.js]
 * 작성일: 2026-01-15
 * 작성자: 김수정
 * * ======================================================================================
 * 1. 필수 전역 변수 설정 (JSP 상단 </body> 위에 두줄 다 선언하기])
 * --------------------------------------------------------------------------------------
 
<script>
	const contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/comment.js"></script>

 * * ======================================================================================
 * 2. 필수 HTML ID 및 구조 (이 ID들이 HTML에 없으면 에러가 납니다)
 * --------------------------------------------------------------------------------------
 * [메인 댓글 작성 영역]
 * - #commentForm        : 댓글 작성을 감싸는 <form> 태그 (targetType, targetId, memberNo 포함 필수)
 * - #mainCmtContent     : 댓글 내용을 입력하는 <textarea>
 * - #cmtFileListList            : 파일 첨부 <input type="file">
 * - #fileNameArea       : 선택된 파일명을 보여줄 영역 (div 또는 span)
 * - #fileNameText       : 실제 파일명 텍스트가 들어갈 곳 (span)
 * * [답글(대댓글) 영역 - 반복문 안]
 * - #replyForm_{cmtNo}    : 대댓글 입력 폼을 감싸는 영역 (숨김 처리됨)
 * - #replyContent_{cmtNo} : 대댓글 내용을 입력하는 <textarea>
 * * [댓글 리스트 영역]
 * - .comment-item       : 개별 댓글을 감싸는 div (삭제 시 애니메이션 용도)
 * - #cmt_{cmtNo}        : 개별 댓글의 고유 ID (삭제 시 특정하기 위함)
 * * ======================================================================================
 * 3. 제공되는 함수 목록
 * --------------------------------------------------------------------------------------
 * - checkFile(input)       : 파일 선택 시 파일명을 화면에 표시
 * - clearFile()            : 선택된 파일 취소 및 초기화
 * - insertComment()        : 메인 댓글 등록 (파일 포함 가능)
 * - toggleReplyForm(cmtNo) : 답글 입력창 열기/닫기 토글
 * - insertReplyComment(parentNo, groupNo) : 답글(대댓글) 등록
 * - deleteComment(cmtNo)   : 댓글 삭제
 * ======================================================================================
 */

/* --------------------------------------------------------------------------------------
 * [1] 파일 관련 UI 함수
 * -------------------------------------------------------------------------------------- */

/**
 * 파일 선택 시 실행되는 함수
 * @param {Object} input - onchange 이벤트가 발생한 input 태그 자신(this)
 * 기능: 사용자가 파일을 선택하면 파일명을 #fileNameText에 넣고, #fileNameArea를 보여줍니다.
 */
function checkFile(input) {
	let $area = $("#fileNameArea");
	if (input.id === "cmtFileList") {
		// 메인 댓글창인 경우
		$area = $("#fileNameArea");
	} else if (input.id.startsWith("replyFile_")) {
		// 대댓글창인 경우 (ID에서 번호 추출)
		// 예: replyFile_105 -> 105 추출 -> replyFileNameArea_105 찾기
		let cmtNo = input.id.split("_")[1];
		$area = $("#replyFileNameArea_" + cmtNo);
	} else {
		return;
	}
	$area.empty();
	
	if (input.files && input.files.length > 0) {
		Array.from(input.files).forEach((file) => {
			// 개별 파일 모양 생성
			let badgeHtml = `<span class="file-badge-item">` +
				`   <i class="bi bi-paperclip"></i> ` + file.name +
				`</span>`;
			$area.append(badgeHtml);
		});

		// 마지막에 '전체 삭제(X)' 버튼
		let clearBtn = `<i class="bi bi-x-circle-fill text-danger ms-1" ` +
			`   onclick="clearFile()" ` +
			`   style="cursor:pointer; font-size: 1rem;" ` +
			`   title="전체 삭제"></i>`;
		$area.append(clearBtn);
		$area.css("display", "flex");
	} else {
		$area.hide();
	}
}

/**
 * 파일 선택 취소 (X 버튼 클릭 시)
 * 기능: input 값을 비우고, 파일명 표시 영역을 숨깁니다.
 */
/* common-comment.js */

function clearFile() {
	$("#cmtFileList").val(""); // 파일 input 초기화
	$("#fileNameArea").empty().hide(); // 영역 비우고 숨기기
}

/* --------------------------------------------------------------------------------------
 * [2] 댓글 등록/삭제 (AJAX)
 * -------------------------------------------------------------------------------------- */

/**
 * 메인 댓글 등록 함수 (파일 첨부 지원)
 * HTML 요건: <button onclick="insertComment()">
 * 주의: contextPath 변수가 선언되어 있어야 합니다.
 */
function insertComment() {
	let content = $("#mainCmtContent").val();

	if (!content || content.trim() === "") {
		Swal.fire({ icon: 'warning', text: '댓글 내용을 입력해주세요.' });
		$("#mainCmtContent").focus();
		return;
	}

	let formData = new FormData();

	// 1. 일반 데이터 담기
	formData.append("targetId", $("input[name='targetId']").val());
	formData.append("targetType", $("input[name='targetType']").val());
	formData.append("cmtContent", $("#mainCmtContent").val());
	formData.append("cmtDepth", 0);

	let fileInput = $("#cmtFileList")[0]; // 제이쿼리 객체에서 순수 DOM 꺼내기
	if (fileInput.files.length > 0) {
		for (let i = 0; i < fileInput.files.length; i++) {
			formData.append("cmtFileList", fileInput.files[i]);
		}
	}

	$.ajax({
		url: contextPath + "/comment/insert",
		type: "POST",
		contentType: "application/json; charset=utf-8",
		data: formData,
		processData: false,
		contentType: false,
		success: function(res) {
			if (res.includes("SUCCESS") || res.includes("OK")) {

				$("#mainCmtContent").val("");
				clearFile();

				Swal.fire({
					icon: 'success',
					title: '등록되었습니다',
					showConfirmButton: false,
					timer: 1000
				});

				loadCommentList();

			} else if (res === "LOGIN_REQUIRED") {
				Swal.fire('알림', '로그인이 필요합니다.', 'warning');
			} else {
				Swal.fire('실패', '댓글 등록에 실패했습니다.', 'error');
			}
		},
		error: function(xhr) {
			console.log(xhr);
			Swal.fire('오류', '서버 에러가 발생했습니다.', 'error');
		}
	});
}

/**
 * 답글(대댓글) 입력창 토글 함수
 * @param {Number} cmtNo - 답글을 달려는 원본 댓글 번호
 */
function toggleReplyForm(cmtNo) {
	let formId = "#replyForm_" + cmtNo;

	// 다른 열려있는 창들은 닫아주기 (선택사항)
	$(".reply-form-container").not(formId).slideUp(200);

	if ($(formId).css("display") === "none") {
		$(formId).slideDown(200);
		$(formId).find("textarea").focus();
	} else {
		$(formId).slideUp(200);
	}
}

/**
 * 대댓글 등록 함수
 */
function insertReplyComment(parentCmtNo, groupNo) {
	let contentObj = $("#replyContent_" + parentCmtNo);
	let content = contentObj.val();

	if (!content || content.trim() === "") {
		Swal.fire({ icon: 'warning', text: '답글 내용을 입력해주세요.' });
		contentObj.focus();
		return;
	}

	// FormData 생성
	let formData = new FormData();

	// 필수 데이터 append
	formData.append("targetId", $("input[name='targetId']").val());
	formData.append("targetType", $("input[name='targetType']").val());
	formData.append("cmtNo", parentCmtNo);    // 부모 댓글 번호
	formData.append("cmtGroup", groupNo);     // 그룹 번호
	formData.append("cmtDepth", 1);           // 깊이
	formData.append("cmtContent", content);   // 내용

	// 대댓글 파일 추가 (반복문 안에서 생성한 ID 사용)
	let fileInput = $("#replyFile_" + parentCmtNo)[0];
	if (fileInput && fileInput.files.length > 0) {
		for (let i = 0; i < fileInput.files.length; i++) {
			formData.append("cmtFileList", fileInput.files[i]);
		}
	}

	$.ajax({
		url: contextPath + "/comment/insertReplyComment",
		type: "POST",
		// FormData 전송 시 필수 설정 2가지
		processData: false,
		contentType: false,
		data: formData,
		success: function(res) {
			if (res.includes("SUCCESS") || res.includes("OK")) {
				contentObj.val("");
				// 파일 input 초기화
				$("#replyFile_" + parentCmtNo).val("");
				$("#replyForm_" + parentCmtNo).hide();

				Swal.fire({
					icon: 'success',
					title: '답글이 등록되었습니다',
					showConfirmButton: false,
					timer: 1000
				});

				loadCommentList(); // 목록 갱신
			} else if (res === "LOGIN_REQUIRED") {
				Swal.fire('알림', '로그인이 필요합니다.', 'warning');
			} else {
				Swal.fire('실패', '답글 등록에 실패했습니다.', 'error');
			}
		},
		error: function(xhr) {
			console.log(xhr);
			Swal.fire('오류', '서버 에러가 발생했습니다.', 'error');
		}
	});
}

/**
 * 댓글 삭제 함수
 * @param {Number} cmtNo - 삭제할 댓글 번호
 */

function deleteComment(cmtNo) {
	Swal.fire({
		title: '댓글 삭제',
		text: "정말 삭제하시겠습니까?",
		icon: 'warning',
		showCancelButton: true,
		confirmButtonColor: '#ef4444',
		cancelButtonColor: '#64748b',
		confirmButtonText: '삭제',
		cancelButtonText: '취소'
	}).then((result) => {
		if (result.isConfirmed) {
			$.ajax({
				url: contextPath + "/comment/delete",
				type: "POST",
				contentType: "application/json; charset=utf-8",
				data: JSON.stringify({ cmtNo: cmtNo }),
				success: function(res) {
					if (res.includes("SUCCESS") || res.includes("OK")) {
						Swal.fire({
							icon: 'success',
							title: '삭제되었습니다',
							showConfirmButton: false,
							timer: 800
						});
						loadCommentList();
					} else {
						Swal.fire('실패', '삭제 실패했습니다.', 'error');
					}
				},
				error: function(xhr) {
					Swal.fire('오류', '서버 에러가 발생했습니다.', 'error');
				}
			});
		}
	});
}

/**
 * 댓글 목록 갱신
 */

function loadCommentList() {
	// 1. JSP에서 전역 변수로 reloadUrl을 선언했는지 확인
	// (typeof 체크를 해야 에러가 안 납니다)
	let urlToLoad;
	if (typeof reloadUrl !== 'undefined' && reloadUrl !== "") {
		urlToLoad = reloadUrl; // JSP에서 만들어준 정확한 주소 사용 (추천 ⭐)
	} else {
		urlToLoad = window.location.href; // 없으면 그냥 현재 브라우저 주소 사용
	}

	// 2. 로딩 (뒤에 공백 + #아이디 주의)
	$("#commentListArea").load(urlToLoad + " #commentListArea > *", function(response, status, xhr) {
		if (status == "error") {
			console.log("댓글 목록 갱신 실패: " + xhr.status + " " + xhr.statusText);
			return;
		}
		// 개수 갱신
		let newCount = $("#commentListArea .comment-item").length;
		$("#commentCount").text("(" + newCount + ")");

		// 파일명 영역 초기화
		clearFile();
	});
}

/**
 * 댓글용 
 * 엔터(Enter) 키를 누르면 댓글 등록 
 */

function handleMainEnter(e) {
    if (e.keyCode === 13) {
        if (!e.shiftKey) {
            e.preventDefault();
            insertComment();
        }
    }
}
/**
 * 대댓글용
 * 엔터(Enter) 키를 누르면 댓글 등록
 */
function handleReplyEnter(e, parentCmtNo, groupNo) {
    if (e.keyCode === 13) {

        if (!e.shiftKey) {
            //shift 키와 같이 입력되면 등록 아닌 줄바꿈
            e.preventDefault();
            insertReplyComment(parentCmtNo, groupNo); 
        }
    }
}