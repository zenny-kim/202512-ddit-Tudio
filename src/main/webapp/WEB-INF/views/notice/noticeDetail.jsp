<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Tudio - 공지사항</title>
	<jsp:include page="/WEB-INF/views/include/common.jsp" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/project_common.css">
</head>
<body class="d-flex flex-column min-vh-100">
	
	<c:choose>
	    <c:when test="${not empty loginUser}">
	        <%-- 로그인 상태일 때 기존 사용자 전용 헤더 --%>
	        <jsp:include page="../include/headerUser.jsp" />
	    </c:when>
	    <c:otherwise>
	        <%-- 비로그인 상태일 때--%>
	        <jsp:include page="../include/headerGuest.jsp" />
	    </c:otherwise>
	</c:choose>

	<div class="d-flex flex-grow-1">
	
		<jsp:include page="../include/sidebarCs.jsp" >
			<jsp:param name="menu" value="notice" />
		</jsp:include>
		
		<main class="main-content-wrap fkex-grow-1">
			
			<div class="container-fluid px-4 pt-4">
                
                <div class="d-flex align-items-center justify-content-between mb-4">
                    <h2 class="h3 fw-bold text-primary-dark m-0">
                        <i class="bi bi-megaphone-fill me-2"></i>TUDIO 공지사항
                    </h2>
                    <!-- <button type="button" class="btn btn-outline-secondary" onclick="history.back()">
                        <i class="bi bi-list me-1"></i> 목록으로
                    </button> -->
                </div>

                <div class="card border-0 shadow-sm mb-5">
                    
                    <div class="card-header notice-header p-4 bg-white">
                        <div class="mb-3">
                            <h4 class="fw-bold text-dark mb-0" style="word-break: break-all;">
                            <c:if test="${notice.noticePinStatus eq 'Y'}">
                                <i class="bi bi-pin-angle-fill text-danger"></i>
                            </c:if>
                                ${notice.noticeTitle}
                            </h4>
                        </div>
                        
                        <div class="d-flex justify-content-between align-items-center text-muted small border-top pt-3">
                            <div class="d-flex align-items-center gap-4">
                                <span>
                                    <i class="bi bi-person-circle me-1"></i>
                                    <span class="fw-bold text-dark">${notice.writer}</span>
                                </span>
                                <span>
                                    <i class="bi bi-calendar3 me-1"></i>
                                    <%-- <fmt:formatDate value="${notice.noticeRegdate}" pattern="yyyy.MM.dd HH:mm"/> --%>
                                    <fmt:formatDate value="${notice.noticeRegdate}" pattern="yyyy.MM.dd"/>
                                </span>
                            </div>
                            <div>
                                <span class="me-3">
                                    <i class="bi bi-eye me-1"></i> 조회 ${notice.noticeHit}
                                </span>
                            </div>
                        </div>
                    </div>

                    <c:if test="${notice.noticeFileNo > 0}">
					    <div class="px-4 pt-4">
					        <div class="file-box p-3 bg-light border rounded">
					            <h6 class="fw-bold text-muted small mb-2">
					                <i class="bi bi-paperclip me-1"></i>첨부파일
					            </h6>
					            <ul class="list-unstyled mb-0">
					                <c:forEach items="${fileList}" var="file">
					                    <li class="mb-2">
					                        <a href="${pageContext.request.contextPath }/tudio/notice/download?fileNo=${file.fileNo}" 
					                        	class="text-decoration-none text-dark d-flex align-items-center">
					                            <i class="bi bi-file-earmark-arrow-down me-2 text-primary"></i>
					                            <span>${file.fileOriginalName}</span>
					                            <span class="text-muted small ms-2">(${file.fileFancysize})</span>
					                        </a>
					                    </li>
					                </c:forEach>
					            </ul>
					        </div>
					    </div>
					</c:if>

                    <div class="card-body p-4">
                        <div class="notice-content text-dark">
                            <% pageContext.setAttribute("newLine", "\n"); %>
                            ${fn:replace(notice.noticeContent, newLine, '<br/>')}
                        </div>
                    </div>

                    <div class="card-footer bg-white border-top p-3 text-center">
                        <button type="button" class="btn btn-secondary px-4" onclick="history.back()">목록</button>
                    </div>
                </div> 
        	</div>
		</main>
	</div>
	
	<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
	
</body>
</html>