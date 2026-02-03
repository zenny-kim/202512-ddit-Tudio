<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 상세 보기</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/projectBoardlist.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/header.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/sidebar.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/footer.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
body {
	background-color: #f8f9fa;
	font-family: 'Pretendard', sans-serif;
	padding-top: var(--header-height);
}

/* 사이드바 우측 본문 영역 */
.main-content {
	margin-left: var(--sidebar-width) !important;
	width: calc(100% - var(--sidebar-width));
	padding: 40px 20px;
}

/* 본문 중앙 정렬 박스 */
.main-content .container {
	margin-left: auto !important;
	margin-right: auto !important;
	max-width: 1000px; /* 900px이 좁다면 여기서 조절 */
	width: 100%;
}

.card {
	border: none;
	border-radius: 15px;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
	overflow: hidden;
}

.card-header-custom {
	background: white;
	border-bottom: 1px solid #f1f1f1;
	padding: 40px;
}

.card-body-custom {
	padding: 40px;
}

.detail-title {
	font-size: 2rem;
	font-weight: 700;
	margin-bottom: 15px;
	color: #212529;
	padding: 5px;
}

.badge-complete {
	background-color: #e7f5ff;
	color: #228be6;
	border: 1px solid #d0ebff;
	padding: 5px 10px;
	border-radius: 6px;
	font-size: 0.85rem;
	display: inline-block;
}

.badge-wait {
	background-color: #fff4e6;
	color: #fd7e14;
	border: 1px solid #ffe8cc;
	padding: 5px 10px;
	border-radius: 6px;
	font-size: 0.85rem;
	display: inline-block;
}

.content-area {
	min-height: 250px;
	line-height: 1.8;
	color: #333;
	font-size: 1.05rem;
}

.file-item {
	display: inline-flex;
	align-items: center;
	padding: 10px 18px;
	background: #f8f9fa;
	border: 1px solid #e9ecef;
	border-radius: 8px;
	text-decoration: none;
	color: #495057;
	font-size: 0.9rem;
	transition: 0.2s;
	margin-top: 10px;
}

.file-item:hover {
	background: #f1f3f5;
	color: #000;
	border-color: #dee2e6;
}

.reply-section {
	background-color: #f8fbff;
	border-radius: 12px;
	border: 1px solid #e9f2ff;
	padding: 35px;
	margin-top: 30px;
}

.admin-icon {
	width: 45px;
	height: 45px;
	background: #0d6efd;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	color: white;
	margin-right: 15px;
}

.reply-text {
	display: block;           /* 박스 형태로 고정 */
    text-align: left;         /* 텍스트 왼쪽 정렬 */
    padding: 20px;            /* 안쪽 여백 */
    background-color: #ffffff;
    border-radius: 10px;
    border: 1px solid #eef2f8;
    line-height: 1.5;
    color: #444;
    
    /* 줄바꿈 설정 */
    overflow-wrap: break-word; /* 너무 긴 단어(영어/URL 등)는 잘라서 다음 줄로 */
    word-break: break-all;     /* 어떤 상황에서도 영역 안에서 줄바꿈 */
    
    /* 위치 고정 */
    width: 100%;              /* 가로 꽉 채우기 */
    height: auto;
    margin-left: 0;           /* 왼쪽 여백 제거 */
}

.admin-reply-form {
	background-color: #fff;
	border: 1px dashed #dee2e6;
	border-radius: 12px;
	padding: 30px;
	margin-top: 30px;
}

.btn-primary {
	background-color: #3b5bdb !important; /* 팀장님 스타일의 남색/파란색 */
	border: none !important;
}

.btn-primary:hover {
	background-color: #2b48bc !important; /* 마우스 올렸을 때 조금 더 진해짐 */
}
</style>
</head>
<body>	
	<%-- 권한 체크 로직 --%>
	<c:set var="isAdmin" value="false" />
	<c:if test="${not empty loginUser.memberAuthVOList}">
		<c:forEach items="${loginUser.memberAuthVOList}" var="authVO">
			<c:if test="${authVO.auth eq 'ROLE_ADMIN'}">
				<c:set var="isAdmin" value="true" />
			</c:if>
		</c:forEach>
	</c:if>
	<jsp:include page="../include/headerUser.jsp" />
	<div class="d-flex border-top" style="min-height: calc(100vh - 60px);">
		<jsp:include page="../include/sidebarCs.jsp" >
			<jsp:param name="menu" value="inquiry" />
		</jsp:include>

		<div class="main-content flex-grow-1">
			<div class="container">
				<nav aria-label="breadcrumb" class="mb-4">
					<ol class="breadcrumb">
						<li class="breadcrumb-item text-muted">고객센터</li>
						<li class="breadcrumb-item text-muted">1:1 문의</li>
						<li class="breadcrumb-item active fw-bold">상세보기</li>
					</ol>
				</nav>

				<div class="card">
					<div class="card-header-custom">
						<div class="d-flex justify-content-between align-items-start">
							<div>
								<c:choose>
									<c:when test="${inquiry.replyStatus eq 'Y'}">
										<span class="badge-complete">답변완료</span>
									</c:when>
									<c:otherwise>
										<span class="badge-wait">답변대기</span>
									</c:otherwise>
								</c:choose>
								<h2 class="detail-title">${inquiry.inquiryTitle}</h2>
								<div class="text-muted d-flex align-items-center"
									style="font-size: 0.9rem;">
									<span class="me-3">유형: <strong>${inquiry.inquiryType eq 'INQUIRY' ? '일반문의' : '신고하기'}</strong></span>
									<span class="me-3">|</span> <span>작성일:
										${inquiry.inquiryRegdate}</span> <span class="ms-3">조회수:
										${inquiry.inquiryHit}</span>
								</div>
							</div>

							<div class="dropdown">
								<button class="btn btn-link text-dark p-0" type="button" data-bs-toggle="dropdown">
							        <i class="bi bi-three-dots-vertical fs-4"></i>
							    </button>
							    <ul class="dropdown-menu dropdown-menu-end shadow-sm">
							
							        <%-- 1. 관리자일 때: 항상 삭제 가능 --%>
							        <c:choose>
							            <c:when test="${isAdmin}">
							                <li><button class="dropdown-item text-danger" onclick="deleteInquiry()">문의글 전체 삭제</button></li>
							            </c:when>
							
							            <%-- 2. 일반 사용자일 때 --%>
							            <c:otherwise>
							                <c:choose>
							                    <%-- 답변 대기 중(N): 삭제 가능 --%>
							                    <c:when test="${inquiry.replyStatus eq 'N'}">
							                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/tudio/inquiry/form?inquiryNo=${inquiry.inquiryNo}">수정하기</a></li>
							                        <li><button class="dropdown-item text-danger" onclick="deleteInquiry()">삭제하기</button></li>
							                    </c:when>
							                    <%-- 답변 완료(Y): 삭제/수정 불가 안내 --%>
							                    <c:otherwise>
							                        <li class="dropdown-header text-muted" style="font-size: 0.8rem;">
							                            <i class="bi bi-info-circle me-1"></i> 답변이 완료된 문의는<br>수정/삭제가 불가합니다.
							                        </li>
							                    </c:otherwise>
							                </c:choose>
							            </c:otherwise>
							        </c:choose>
							        
							    </ul>
							</div>
						</div>
					</div>

					<div class="card-body-custom">
						<div class="content-area mb-5">${inquiry.inquiryContent}</div>

						<c:if test="${not empty fileList}">
							<div class="file-list-area mb-4">
								<p class="small fw-bold text-muted mb-2">
									<i class="bi bi-paperclip"></i> 첨부파일
								</p>
								<div class="d-flex flex-wrap gap-2">
									<c:forEach items="${fileList}" var="file">
										<a
											href="${pageContext.request.contextPath}/tudio/inquiry/download?fileNo=${file.fileNo}"
											class="file-item"> <span class="me-2">${file.fileOriginalName}</span>
											<span class="text-muted small">(<fmt:formatNumber
													value="${file.fileSize / 1024}" pattern="#,###" /> KB)
										</span>
										</a>
									</c:forEach>
								</div>
							</div>
						</c:if>

						<div class="card mt-5 border-0 shadow-sm" style="background-color: #f8faff; border-radius: 12px;">
						    <div class="card-body p-4">
						        <div class="d-flex align-items-center justify-content-between mb-3">
						            <div class="d-flex align-items-center">
						                <div class="admin-icon" style="width: 40px; height: 40px; background: #3b5bdb;">
						                    <i class="bi bi-headset text-white"></i>
						                </div>
						                <div class="ms-3">
						                    <h6 class="fw-bold mb-0 text-primary">Tudio 고객지원팀 답변</h6>
						                    <small class="text-muted">
						                        <c:choose>
						                            <c:when test="${not empty inquiry.replyDate}">${inquiry.replyDate}</c:when>
						                            <c:otherwise>확인 중</c:otherwise>
						                        </c:choose>
						                    </small>
						                </div>
						            </div>
						            
						            <%-- 관리자이면서 답변이 등록된 상태일 때만 삭제 버튼 노출 --%>
						            <c:if test="${isAdmin && inquiry.replyStatus eq 'Y'}">
						                <button type="button" class="btn btn-outline-danger btn-sm" onclick="confirmDeleteReply()">
						                    <i class="bi bi-trash me-1"></i>삭제
						                </button>
						            </c:if>
						        </div>
						
						        <hr class="opacity-10 mb-4">
						
						        <c:choose>
						            <%-- 1. 답변이 이미 등록된 경우 (일반 댓글 형식) --%>
						            <c:when test="${inquiry.replyStatus eq 'Y'}">
						                <div class="reply-text">
						                    ${inquiry.replyContent}
						                </div>
						            </c:when>
						
						            <%-- 2. 관리자이고 답변이 없는 경우 (입력창 노출) --%>
						            <c:when test="${isAdmin}">
						                <form id="replyForm" action="${pageContext.request.contextPath}/tudio/admin/inquiry/reply" method="post">
						                    <input type="hidden" name="inquiryNo" value="${inquiry.inquiryNo}">
						                    <textarea name="replyContent" class="form-control border-0 bg-white p-3 mb-3" 
						                              rows="6" placeholder="답변 내용을 입력하세요. 등록 후 수정이 불가하오니 신중히 작성해주세요." 
						                              style="resize: none; border-radius: 10px; border: 1px solid #e9ecef !important;" required></textarea>
						                    <div class="text-end">
						                        <button type="submit" class="btn btn-primary px-4 py-2">
						                            <i class="bi bi-check2-circle me-2"></i>답변 등록
						                        </button>
						                    </div>
						                </form>
						            </c:when>
						
						            <%-- 3. 일반 사용자이고 답변이 없는 경우 --%>
						            <c:otherwise>
						                <div class="py-4 text-center">
						                    <i class="bi bi-chat-dots text-muted fs-2 mb-2 d-block"></i>
						                    <p class="text-muted mb-0">안녕하세요, <strong>${loginUser.memberName}</strong> 님. <br>
						                    담당자가 문의 내용을 확인 중입니다. 잠시만 기다려 주세요.</p>
						                </div>
						            </c:otherwise>
						        </c:choose>
						    </div>
						</div>

						<div class="text-center mt-5">
							<c:set var="listPath"
								value="${isAdmin ? '/tudio/admin/inquiry/list' : '/tudio/inquiry/list'}" />
							<a href="${pageContext.request.contextPath}${listPath}"
								class="btn btn-primary px-5 py-2">목록으로</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<form id="deleteForm" method="post"
		action="${pageContext.request.contextPath}/tudio/inquiry/delete">
		<input type="hidden" name="inquiryNo" value="${inquiry.inquiryNo}">
	</form>

	<jsp:include page="../include/footer.jsp" />
	<script src="${pageContext.request.contextPath}/js/footer.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		
	// URL 파라미터에 따른 SweetAlert 알림
	const urlParams = new URLSearchParams(window.location.search);
	const msg = urlParams.get('msg');

	if (msg === 'regSuccess') {
	    Swal.fire({ icon: 'success', title: '등록 완료', text: '답변이 정상적으로 등록되었습니다.', confirmButtonColor: '#3b5bdb' });
	} else if (msg === 'delSuccess') {
	    Swal.fire({ icon: 'success', title: '삭제 완료', text: '답변이 삭제되었습니다.', confirmButtonColor: '#3b5bdb' });
	}

	// 답변 삭제 확인창
	function confirmDeleteReply() {
	    Swal.fire({
	        title: '답변을 삭제하시겠습니까?',
	        text: "삭제하면 답변 대기 상태로 되돌아갑니다.",
	        icon: 'warning',
	        showCancelButton: true,
	        confirmButtonColor: '#d33',
	        cancelButtonColor: '#888',
	        confirmButtonText: '삭제',
	        cancelButtonText: '취소'
	    }).then((result) => {
	        if (result.isConfirmed) {
	            location.href = "${pageContext.request.contextPath}/tudio/admin/inquiry/replyDelete?inquiryNo=${inquiry.inquiryNo}";
	        }
	    });
	}
	
	//문의글 전체 삭제
	function deleteInquiry() {
		Swal.fire({
	        title: '문의글을 삭제하시겠습니까?',
	        text: "삭제된 글은 복구할 수 없습니다.",
	        icon: 'warning',
	        showCancelButton: true,
	        confirmButtonColor: '#d33',
	        cancelButtonColor: '#888',
	        confirmButtonText: '삭제',
	        cancelButtonText: '취소'
	    }).then((result) => {
	        if (result.isConfirmed) {
	            // 현재 사용자의 권한에 따라 이동 경로 결정
	            if (${isAdmin}) {
	                // 관리자일 때: 관리자 전용 삭제 API 호출 후 관리자 목록으로
	                location.href = "${pageContext.request.contextPath}/tudio/admin/inquiry/delete?inquiryNo=${inquiry.inquiryNo}";
	            } else {
	                // 일반 사용자일 때: 기존 deleteForm(사용자용) 제출
	                document.getElementById("deleteForm").submit();
	            }
	        }
	    });
	}
	</script>
</body>
</html>