<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<title>Tudio - 자주 묻는 질문</title>
<jsp:include page="/WEB-INF/views/include/common.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/project_common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/cs_common.css">
<link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
</head>
<body>
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

    <div class="cs-main-wrapper">
    <jsp:include page="../include/sidebarCs.jsp">
        <jsp:param name="menu" value="faq" />
    </jsp:include>

    <div class="cs-header-section">
        <div class="cs-breadcrumb">
            <span>고객센터</span>
            <i class="bi bi-chevron-right small"></i>
            <span class="active">자주 묻는 질문</span>
        </div>
        <h2 class="cs-page-title">
            <i class="bi bi-question-circle"></i> 자주 묻는 질문
        </h2>
    </div>

    <main class="cs-card">
        <div class="accordion faq-accordion" id="faqAccordion">
            <c:choose>
                <c:when test="${not empty faqList}">
                    <c:forEach items="${faqList}" var="faq" varStatus="status">
                        <c:if test="${faq.publicStatus eq 'Y'}">
                            <div class="accordion-item">
                                <h2 class="accordion-header">
                                    <button class="accordion-button collapsed" type="button" 
                                            data-bs-toggle="collapse" data-bs-target="#collapse${status.index}">
                                        <span class="q-icon">Q</span>
                                        ${faq.faqTitle}
                                    </button>
                                </h2>
                                <div id="collapse${status.index}" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                                    <div class="accordion-body">
                                        <c:out value="${faq.faqContent}" escapeXml="false" />
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5">
                        <i class="bi bi-exclamation-circle text-muted" style="font-size: 48px;"></i>
                        <p class="text-muted mt-3">등록된 질문이 없습니다.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="tudio-pager mt-4">
            ${pagingVO.pagingHTML}
        </div>
    </main>
</div>

    <%-- 푸터 포함 --%>
    <jsp:include page="../include/footer.jsp" />

</body>
</html>