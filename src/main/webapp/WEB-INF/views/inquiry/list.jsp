<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>Tudio - 문의사항</title>
<jsp:include page="/WEB-INF/views/include/common.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/project_common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/cs_common.css">
<link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
</head>
<body>
	<jsp:include page="../include/headerUser.jsp" />

	<div class="cs-main-wrapper">
        
        <jsp:include page="../include/sidebarCs.jsp">
            <jsp:param name="menu" value="inquiry" />
        </jsp:include>

        <%-- [4] cs-header-section: 경로 및 제목 시작점 통일 --%>
        <div class="cs-header-section">
            <div class="cs-breadcrumb">
                <span>고객센터</span>
                <i class="bi bi-chevron-right small"></i>
                <span class="active">1:1 문의</span>
            </div>
            
            <c:set var="isAdmin" value="false" />
            <c:forEach items="${loginUser.memberAuthVOList}" var="authVO">
                <c:if test="${authVO.auth eq 'ROLE_ADMIN'}">
                    <c:set var="isAdmin" value="true" />
                </c:if>
            </c:forEach>

            <div class="d-flex justify-content-between align-items-center">
                <h2 class="cs-page-title">
                    <c:choose>
                        <c:when test="${isAdmin}">
                            <i class="bi bi-shield-check"></i> 문의내역 관리
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-chat-dots"></i> 나의 문의내역
                        </c:otherwise>
                    </c:choose>
                </h2>
                <c:if test="${not isAdmin}">
                    <a href="${pageContext.request.contextPath}/tudio/inquiry/form"
                       class="tudio-btn tudio-btn-primary">
                        <i class="bi bi-pencil-square"></i> 문의하기
                    </a>
                </c:if>
            </div>
        </div>

        <%-- [5] cs-card: 메인 카드 영역 시작점 통일 --%>
        <main class="cs-card">
            
            <%-- 상단 필터/검색 바 (common.css의 tudio-toolbar/filter 스타일 활용) --%>
            <div class="d-flex justify-content-between mb-4 gap-2">
                <div class="d-flex gap-2">
                    <select class="form-select form-select-sm w-auto" id="statusFilter">
                        <option value="" ${empty pagingVO.searchStatus ? 'selected' : ''}>전체 상태</option>
                        <option value="N" ${pagingVO.searchStatus eq 'N' ? 'selected' : ''}>답변 대기</option>
                        <option value="Y" ${pagingVO.searchStatus eq 'Y' ? 'selected' : ''}>답변 완료</option>
                    </select>
                </div>
                
                <div class="d-flex gap-2">
                    <select class="form-select form-select-sm w-auto" id="searchType">
                        <option value="T" ${pagingVO.searchType eq 'T' ? 'selected' : ''}>제목</option>
                        <option value="C" ${pagingVO.searchType eq 'C' ? 'selected' : ''}>내용</option>
                        <option value="TC" ${pagingVO.searchType eq 'TC' ? 'selected' : ''}>제목+내용</option>
                        <c:if test="${isAdmin}">
                            <option value="W" ${pagingVO.searchType eq 'W' ? 'selected' : ''}>작성자</option>
                        </c:if>
                    </select>
                    <div class="tudio-search">
                        <input type="text" id="searchWord" value="${pagingVO.searchWord}" placeholder="검색어를 입력하세요">
                    </div>
                    <button class="tudio-search-btn" id="searchBtn">검색</button>
                </div>
            </div>

            <table class="table tudio-table-card">
                <thead>
                    <tr class="text-center">
                        <th style="width: 8%;">No</th>
                        <th style="width: 12%;">상태</th>
                        <th class="text-center">제목</th>
                        <c:if test="${isAdmin}">
                            <th style="width: 12%;">작성자</th>
                        </c:if>
                        <th style="width: 15%;">작성일</th>
                        <th style="width: 15%;">답변일</th>
                        <th style="width: 10%;">조회수</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${not empty pagingVO.dataList}">
                            <c:forEach items="${pagingVO.dataList}" var="inquiry" varStatus="status">
                                <tr class="text-center">
                                    <td>${pagingVO.totalRecord - (pagingVO.currentPage - 1) * 10 - status.index}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${inquiry.replyStatus eq 'Y'}">
                                                <span class="badge-complete">답변완료</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-wait">답변대기</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-start">
                                        <c:set var="detailPath" value="${isAdmin ? '/tudio/admin/inquiry/detail/' : '/tudio/inquiry/detail/'}" />
                                        <a href="${pageContext.request.contextPath}${detailPath}${inquiry.inquiryNo}" class="inquiry-title"> 
                                            ${inquiry.inquiryTitle} 
                                            <i class="bi bi-lock-fill ms-1 text-muted small"></i>
                                        </a>
                                    </td>
                                    <c:if test="${isAdmin}">
                                        <td>${inquiry.userName}</td>
                                    </c:if>
                                    <td>${inquiry.inquiryRegdate}</td>
                                    <td class="text-muted">
                                        <c:choose>
                                            <c:when test="${not empty inquiry.replyDate}">${inquiry.replyDate}</c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${inquiry.inquiryHit}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="${isAdmin ? 7 : 6}" class="text-center py-5 text-muted">문의 내역이 없습니다.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <%-- common.css의 tudio-pager 클래스 활용 --%>
            <div class="tudio-pager mt-5" id="pagingArea">
                ${pagingVO.pagingHTML}
            </div>
        </main>
    </div>

<jsp:include page="../include/footer.jsp" />

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="${pageContext.request.contextPath}/js/footer.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
$(function() {
	function getTargetUrl(pageNo) {
        var isAdminPage = window.location.pathname.includes('/admin/');
        var targetPath = isAdminPage ? "/tudio/admin/inquiry/list" : "/tudio/inquiry/list";
        
        var status = $("#statusFilter").val() || "";
        var type = $("#searchType").val() || "";
        var word = $("#searchWord").val() || "";
        
        return "${pageContext.request.contextPath}" + targetPath 
               + "?page=" + pageNo 
               + "&searchStatus=" + status 
               + "&searchType=" + type 
               + "&searchWord=" + encodeURIComponent(word);
    }

    // 검색 버튼 클릭 시
    $("#searchBtn").on("click", function() {
        location.href = getTargetUrl(1);
    });

    // 엔터키 검색 지원
    $("#searchWord").on("keypress", function(e) {
        if(e.keyCode == 13) $("#searchBtn").click();
    });

    // 상태 필터 변경 시
    $("#statusFilter").on("change", function() {
        location.href = getTargetUrl(1);
    });

    // 페이징 클릭 시
    $("#pagingArea").on("click", "a", function(event) {
        event.preventDefault();
        var pageNo = $(this).data("page");
        if(pageNo) location.href = getTargetUrl(pageNo);
    });
});
</script>
</body>
</html>