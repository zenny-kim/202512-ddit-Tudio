<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Tudio - 공지시항</title>
	<jsp:include page="/WEB-INF/views/include/common.jsp" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/cs_common.css">
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

    <%-- [2] cs-main-wrapper: 사이드바 및 본문 레이아웃 --%>
    <div class="cs-main-wrapper flex-grow-1">
        
        <jsp:include page="../include/sidebarCs.jsp">
            <jsp:param name="menu" value="notice" />
        </jsp:include>
        
        <jsp:useBean id="now" class="java.util.Date" />
        <fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="todayStr" />

        <%-- [3] cs-header-section: 경로 및 제목 시작점 통일 --%>
        <div class="cs-header-section">
            <div class="cs-breadcrumb">
                <span>고객센터</span>
                <i class="bi bi-chevron-right small"></i>
                <span class="active">공지사항</span>
            </div>
            <h2 class="cs-page-title">
                <i class="bi bi-megaphone"></i> TUDIO 공지사항
            </h2>
        </div>

        <%-- [4] cs-card: 메인 카드 영역 --%>
        <main class="cs-card">
            
            <%-- 상단 검색 바 (common.css 스타일 활용) --%>
            <form id="searchForm" action="${pageContext.request.contextPath}/tudio/notice/list" method="get">
                <input type="hidden" name="page" id="page" value="${pagingVO.currentPage}" />
                
                <div class="d-flex justify-content-end mb-4">
				    <div class="d-flex align-items-center gap-1" style="width: 300px;">
				        <div class="tudio-search">
				            <input type="text" name="searchWord" value="${pagingVO.searchWord}" placeholder="제목으로 검색하세요">
				        </div>
				        <button type="button" class="tudio-search-btn" onclick="fn_search(1)" style="flex-shrink: 0;">검색</button>
				    </div>
				</div>
            </form>

            <table class="table tudio-table-card align-middle">
                <thead>
                    <tr class="text-center">
                        <th style="width: 8%">No</th>
                        <th>제목</th>
                        <th style="width: 15%">작성일</th>
                        <th style="width: 15%">작성자</th>
                        <th style="width: 10%">조회수</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty pagingVO.dataList}">							
                            <tr>
                                <td colspan="5" class="text-center py-5 text-muted">등록된 공지사항이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${pagingVO.dataList}" var="notice" varStatus="vs">
                                <fmt:formatDate value="${notice.noticeRegdate}" pattern="yyyy-MM-dd" var="regDateStr"/>
                                
                                <%-- 중요 공지인 경우 notice-pinned 클래스 적용 --%>
                                <tr class="text-center ${notice.noticePinStatus eq 'Y' ? 'notice-pinned' : ''}">
                                    <td>
                                        <c:choose>
                                            <c:when test="${notice.noticePinStatus eq 'Y'}">
                                                <i class="bi bi-pin-angle-fill text-danger"></i>
                                            </c:when>
                                            <c:otherwise>
                                                ${pagingVO.totalRecord - ((pagingVO.currentPage - 1) * pagingVO.screenSize) - vs.index}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-start">
                                        <a href="${pageContext.request.contextPath}/tudio/notice/detail?noticeNo=${notice.noticeNo}" class="notice-title-link d-inline-block text-truncate" style="max-width: 450px;">
                                            ${notice.noticeTitle}
                                        </a>
                                        <c:if test="${todayStr eq regDateStr}">
                                            <span class="badge-new">NEW</span>
                                        </c:if>
                                        <c:if test="${notice.noticeFileNo > 0}">
                                            <i class="bi bi-paperclip text-muted ms-1" title="첨부파일"></i>
                                        </c:if>
                                    </td>
                                    <td class="text-muted small">
                                        <fmt:formatDate value="${notice.noticeRegdate}" pattern="yyyy-MM-dd" />
                                    </td>
                                    <td>
                                        <span class="tudio-badge" style="background: var(--header-blue); color: var(--dark-navy); font-size: 11px;">
                                            ${notice.writer}
                                        </span>
                                    </td>
                                    <td class="text-muted small">${notice.noticeHit}</td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>

            <%-- common.css의 tudio-pager 클래스 활용 --%>
            <div id="pagingArea" class="tudio-pager mt-5">
                ${pagingVO.pagingHTML}
            </div>		
        </main>
    </div>
	
	<jsp:include page="/WEB-INF/views/include/footer.jsp"/>

	<script>
	    // 검색 버튼 클릭 시 (1페이지부터 다시 검색)
	    function fn_search(pageNo) {
	        document.getElementById("page").value = pageNo;
	        document.getElementById("searchForm").submit();
	    }
	
	    // 페이징 번호 클릭 이벤트
	    document.addEventListener("DOMContentLoaded", function() {
	        const pagingArea = document.getElementById("pagingArea");
	        
	        pagingArea.addEventListener("click", function(e) {
	            // 클릭된 요소가 a태그 혹은 그 자식일 경우
	            const target = e.target.closest("a.page-link");
	            
	            if (target) {
	                e.preventDefault(); // href 이동 방지
	                const pageNo = target.getAttribute("data-page");
	                
	                if (pageNo) {
	                    fn_search(pageNo);
	                }
	            }
	        });
	    });
	</script>
</body>
</html>