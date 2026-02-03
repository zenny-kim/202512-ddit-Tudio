<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="/WEB-INF/views/include/common.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/project_common.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
.bg-light { background-color: #f8fafc !important; }
.custom-table {
    border-collapse: collapse !important;
    border-left: none !important;
    border-right: none !important;
    border-top: 1px solid #dee2e6 !important;
    border-bottom: 1px solid #dee2e6 !important;
}
.custom-table th, .custom-table td {
    border: 1px solid #dee2e6 !important;
    border-left: none !important;
    border-right: none !important;
}
.custom-table th.bg-light {
    background-color: #fcfcfc !important;
    font-weight: 600;
    color: #444;
}
/* 결재 칸 전용 스타일 추가 */
.approver-box {
    width: 80px;
    border: 1px solid #dee2e6;
    text-align: center;
}
.stamp-circle {
    position: absolute;
    width: 55px; /* 원 크기를 살짝 키웠습니다 (기존 45px) */
    height: 55px;
    border: 3px solid; /* 테두리도 좀 더 두껍게 */
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 900; /* 글씨를 아주 두껍게 */
    font-size: 1rem; /* 글씨 크기 키움 (기존 0.75rem) */
    z-index: 2;
    background-color: rgba(255, 255, 255, 0.6); /* 배경을 조금 더 불투명하게 해서 이름과 겹쳐도 잘 보이게 */
    transform: rotate(-15deg); /* 각도를 조금 더 주어 도장 느낌 강조 */
    top: 50%;
    left: 50%;
    margin-top: -27.5px; /* 중앙 정렬 값 조정 */
    margin-left: -27.5px;
}

/* 승인 도장: 파란색 */
.stamp-approve {
    border-color: #0d6efd;
    color: #0d6efd;
}

/* 반려 도장: 빨간색 */
.stamp-reject {
    border-color: #dc3545;
    color: #dc3545;
}
/* 테이블 마우스 오버 시 발생하는 배경색 변화와 글자 흔들림 방지 */
.table.table-hover-custom, .table.table-hover-custom tr, .table.table-hover-custom td
	{
	--bs-table-hover-bg: transparent !important; /* 배경색 변화 제거 */
	--bs-table-accent-bg: transparent !important;
	transition: none !important; /* 움직임 효과 제거 */
	transform: none !important; /* 위치 이동 제거 */
}
/* 파일 하나하나를 카드로 만듦 */
.file-card {
    display: flex;
    align-items: center;
    background: #f8fafc;
    border: 1px solid #eef2f7;
    border-radius: 12px;
    padding: 12px 16px;
    text-decoration: none;
    transition: all 0.2s ease;
}

.file-card:hover {
    background: #fff;
    border-color: var(--main-blue);
    box-shadow: 0 4px 12px rgba(59, 130, 246, 0.1);
    transform: translateY(-2px);
}

.file-icon-box {
    width: 36px;
    height: 36px;
    background: #eff6ff;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: var(--main-blue);
    font-size: 1.2rem;
    margin-right: 12px;
    flex-shrink: 0;
}

.file-info {
    display: flex;
    flex-direction: column;
    overflow: hidden;
}

.file-name {
    font-size: 0.9rem;
    font-weight: 600;
    color: #334155;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.file-size {
    font-size: 0.75rem;
    color: #94a3b8;
    margin-top: 2px;
}
/* [3] 첨부파일 영역 (카드 스타일) */
.board-file-section {
    margin-top: 60px;
    border-top: 1px dashed #e2e8f0;
    padding-top: 20px;
}

.file-label {
    font-size: 0.9rem;
    font-weight: 700;
    color: #64748b;
    margin-bottom: 12px;
    display: block;
}

.file-card-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
    gap: 12px;
}
.tudio-btn-danger {
    background-color: #dc3545 !important; /* 프로젝트 Danger 색상에 맞춰 조절 */
    color: #fff !important;
    border-color: #dc3545 !important;
}

.tudio-btn-danger:hover {
    background-color: #c82333 !important; /* 마우스 올렸을 때 살짝 어둡게 */
}
.tudio-scope{
  width: 80%;
  max-width: 1100px;  /* 너무 넓어지는 거 방지 */
  margin: 0 auto;     /* 가운데 정렬 */
}
</style>
</head>
<body>
	<section class="tudio-section">
		<!-- APPROVAL DETAIL 화면 입니다. -->
		<jsp:include page="../include/headerUser.jsp" />

		<div class="d-flex">
			<!-- 사이드바 -->
			<jsp:include page="../include/sidebarUser.jsp">
				<jsp:param name="menu" value="approval" />
			</jsp:include>

			<main class="main-content-wrap flex-grow-1 px-4 pt-4 pb-5">
				<div class="container-fluid">

					<div class="d-flex justify-content-between align-items-center mb-4">
						<!-- 소제목 -->
						<h2 class="h3 fw-bold text-primary-dark mb-0">
							<i class="bi bi-file-earmark-check me-2"></i> 결재 문서 
						</h2>
					</div>




					<div class="tudio-scope">
						<div class="d-flex justify-content-between align-items-end mb-0">
							<ul class="nav nav-tabs custom-index-tabs border-0 mb-0">
								<li class="nav-item">
									<button class="nav-link active" type="button">
										<i class="bi bi-pencil-fill"></i> <span>문서 확인</span>
									</button>
								</li>
							</ul>
						</div>

						<div class="tab-content-card p-4">
								<div class="row mb-4">
									<div class="col-md-7">
										<table class="table table-bordered align-middle mb-0 custom-table table-hover-custom">
											<tr>
												<th class="bg-light text-center" style="width: 25%;">프로젝트</th>
												<td>${draft.projectName}</td>
											</tr>
											<tr>
												<th class="bg-light text-center">기안자</th>
												<td class="small">${draft.drafterName}
													<span class="text-muted"> 
														(<c:out value="${draft.drafterDept}" default="부서미지정" /> / 
														 <c:out value="${draft.drafterPos}" default="직책미지정" />)
													</span>
												</td>
											</tr>
											<tr>
												<th class="bg-light text-center">기안일자</th>
												<td class="small">${draft.documentRegdate}</td>
											</tr>
											<tr>
												<th class="bg-light text-center">보안 등급</th>
												<td>
						                            <c:choose>
						                                <c:when test="${draft.isPublic == 'Y'}">
						                                    <span class="badge bg-success">낮음</span> 
						                                    <span class="text-muted small">모두 조회</span>
						                                </c:when>
						                                <c:otherwise>
						                                    <span class="badge bg-danger">높음</span> 
						                                    <span class="text-muted small">결재자만 조회</span>
						                                </c:otherwise>
						                            </c:choose>
						                        </td>
											</tr>
										</table>
									</div>

									<div class="col-md-5">
										<div class="d-flex justify-content-end align-items-start gap-1">
										    <div class="border text-center" style="width: 80px;">
										        <div class="bg-light border-bottom p-1 small">담당</div>
										        <div class="p-2 d-flex align-items-center justify-content-center" style="height: 60px;">
										            ${draft.drafterName}
										        </div>
										        <div class="bg-light border-top p-1 small">
										        	<c:choose>
											            <c:when test="${not empty draft.documentRegdate}">
											                ${fn:substring(draft.documentRegdate, 5, 10)}
											            </c:when>
											            <c:otherwise>-</c:otherwise>
											        </c:choose>
										        </div>
										    </div>
										
										    <c:forEach var="app" items="${approvalList}">
										        <div class="border text-center" style="width: 80px;">
										            <div class="bg-light border-bottom p-1 small">
											            <c:out value="${app.memberPosition}" default="-" />
											        </div>
										            <div class="p-2 d-flex flex-column align-items-center justify-content-center" style="height: 60px; position: relative;">
													    <span class="text-dark small" style="z-index: 1;">${app.memberName}</span>
													
													    <c:choose>
													        <c:when test="${app.approvalStatus == 609}">
													            <div class="stamp-circle stamp-approve">승인</div>
													        </c:when>
													        <c:when test="${app.approvalStatus == 610}">
													            <div class="stamp-circle stamp-reject">반려</div>
													        </c:when>
													    </c:choose>
													</div>
										            <div class="bg-light border-top p-1 small">
										                <c:choose>
													        <c:when test="${not empty app.approvalDate}">
													            ${fn:substring(app.approvalDate, 5, 10)} 
													        </c:when>
													        <c:otherwise>&nbsp;</c:otherwise>
													    </c:choose>
										            </div>
										        </div>
										    </c:forEach>
										</div>
									</div>
								</div>

								<div class="mb-4">
								    <table class="table table-bordered align-middle mb-0 custom-table table-hover-custom">
								        <tr>
								            <th class="bg-light text-center" style="width: 17.8%;">제목</th>
								            <td class="fw-bold">${draft.documentTitle}</td>
								        </tr>
								        <tr>
								            <th class="bg-light text-center" style="vertical-align: top; padding-top: 20px;">내용</th>
								            <td style="min-height: 400px; vertical-align: top; padding: 20px;">
								                <c:out value="${draft.documentContent}" escapeXml="false" />
								            </td>
								        </tr>
								    </table>
								</div>
								
				
<c:if test="${not empty fileList}">
    <div class="board-file-section mt-4">
        <span class="file-label mb-3 d-inline-block fw-bold">
            <i class="bi bi-paperclip me-1"></i> 첨부파일 
            <span class="text-primary">${fn:length(fileList)}</span>개
        </span>
        
        <div class="file-card-grid">
            <c:forEach items="${fileList}" var="file">
                <%-- 다운로드 경로는 아까 만든 내 컨트롤러 주소로! --%>
                <a href="/tudio/approval/download?fileNo=${file.fileNo}" 
                   class="file-card">
                    <div class="file-icon-box">
                        <i class="bi bi-file-earmark-text"></i>
                    </div>
                    <div class="file-info">
                        <span class="file-name" title="${file.fileOriginalName}">${file.fileOriginalName}</span>
                        <span class="file-size">${file.fileFancysize}</span>
                    </div>
                </a>
            </c:forEach>
        </div>
    </div>
</c:if>
				
				
								
								
						</div>

						<div class="mt-4 d-flex justify-content-between align-items-center">
						    <div>
						    	<a href="/tudio/approval/list" class="tudio-btn" style="background: white; border:1px solid #e2e8f0; text-decoration: none; color: black;">목록으로</a>
					    	</div>
						
							<div class="d-flex gap-2">
							    <c:if test="${projectRole == 'MANAGER' && draft.memberNo == loginUser.memberNo && draft.documentStatus == 611}">
							        <button type="button" class="btn btn-warning" onclick="recallDocument()">회수</button>
							    </c:if>
							    
							    <c:if test="${draft.memberNo == loginUser.memberNo && (draft.documentStatus == 615 || draft.documentStatus == 616)}">
							        <button type="button" class="tudio-btn tudio-btn-outline" onclick="location.href='/tudio/approval/edit?no=${draft.documentNo}'">
							        	<i class="bi bi-pencil-square"></i>수정</button>
							        <button type="button" class="tudio-btn tudio-btn-outline-danger" onclick="deleteDocument()">
							        	<i class="bi bi-trash"></i>삭제</button>
							    </c:if>
								
							    <c:if test="${userAuth == 'ROLE_CLIENT' && isCurrentApprover && (draft.documentStatus == 611 || draft.documentStatus == 612)}">
								    <button type="button" class="tudio-btn tudio-btn-danger" onclick="openRejectModal()">반려</button>
								    <button type="button" class="tudio-btn tudio-btn-primary" onclick="approveDocument()">승인</button>
								</c:if>
							</div>
						</div>
					</div>
				</div>
			</main>
		</div>
		
	</section>
	<div class="modal fade" id="rejectModal" tabindex="-1" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	            <div class="modal-header">
	                <h5 class="modal-title fw-bold">결재 반려</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
	            </div>
	            <div class="modal-body">
	                <p class="text-muted small">반려 사유를 입력해주세요. 기안자가 확인할 수 있습니다.</p>
	                <textarea id="rejectionReason" class="form-control" rows="4" placeholder="사유 입력 (필수)"></textarea>
	            </div>
	            <div class="modal-footer">
	                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
	                <button type="button" class="btn btn-danger" onclick="rejectDocument()">반려 처리</button>
	            </div>
	        </div>
	    </div>
	</div>
	
	<jsp:include page="../chat/main.jsp"/>
	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
	
<script type="text/javascript">
const contextPath = "/tudio";
//1. 승인 처리
function approveDocument() {
    Swal.fire({
        title: '승인하시겠습니까?',
        text: "승인 후에는 취소할 수 없습니다.",
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#28a745',
        cancelButtonColor: '#6c757d',
        confirmButtonText: '승인',
        cancelButtonText: '취소'
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                url: contextPath + "/approval/approve",
                type: "POST",
                data: { 
                    documentNo: "${draft.documentNo}",
                    memberNo: "${loginUser.memberNo}" 
                },
                success: function(res) {
                    if(res === "success") {
                        Swal.fire('완료', '승인 처리가 완료되었습니다.', 'success')
                        .then(() => location.reload()); // 화면 새로고침해서 상태 반영
                    } else {
                        Swal.fire('에러', '처리 중 오류가 발생했습니다.', 'error');
                    }
                }
            });
        }
    });
}
//2. 반려 모달 열기 (반려 사유 입력 필요)
function openRejectModal() {
    Swal.fire({
    	title: '반려 사유 입력',
        input: 'textarea',
        inputPlaceholder: '반려 사유를 입력하세요...',
        showCancelButton: true,
        confirmButtonColor: '#d33',
        confirmButtonText: '반려 처리',
        cancelButtonText: '취소'
    }).then((result) => {
        // result가 null이거나 undefined인 경우 방어
        if (result && result.isConfirmed) {
            if (result.value) {
                rejectDocument(result.value);
            } else {
                Swal.fire('알림', '사유를 입력해야 반려가 가능합니다.', 'warning');
            }
        }
    }).catch(err => console.error("Swal Error:", err));
}
//3. 반려 처리 Ajax
function rejectDocument(rejectionReason) {
	if (!contextPath) {
        console.error("contextPath가 정의되지 않았습니다.");
        return;
    }
    $.ajax({
        url: contextPath + "/approval/reject",
        type: "POST",
        data: { 
            documentNo: "${draft.documentNo}",
            memberNo: "${loginUser.memberNo}",
            rejectionReason: rejectionReason 
        },
        success: function(res) {
            if(res === "success") {
                Swal.fire('반려 완료', '문서가 반려되었습니다.', 'info')
                .then(() => location.reload());
            } else {
                Swal.fire('에러', '처리 중 오류가 발생했습니다: ' + (res || "알 수 없는 에러"), 'error');
            }
        }, 
        error: function(xhr) {
            console.error("Ajax Error:", xhr);
        } // error 끝
    });
}
function recallDocument() {
    Swal.fire({
        title: '문서를 회수하시겠습니까?',
        text: "회수하면 결재자가 문서를 조회할 수 없습니다.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#ffc107', 
        cancelButtonColor: '#6c757d',
        confirmButtonText: '회수',
        cancelButtonText: '취소'
    }).then((result) => {
        if (result.isConfirmed) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '/tudio/approval/recall';

            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'documentNo';
            input.value = '${draft.documentNo}';

            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
        }
    });
}

window.onload = function() {
    const message = "${message}"; 
    const error = "${error}";     

    if (message) {
        Swal.fire({
            icon: 'success',
            title: '회수 완료',
            text: message,
            confirmButtonColor: '#28a745'
        });
    }
    
    if (error) {
        Swal.fire({
            icon: 'error',
            title: '실패',
            text: error,
            confirmButtonText: '확인'
        });
    }
};
</script>
</body>
</html>