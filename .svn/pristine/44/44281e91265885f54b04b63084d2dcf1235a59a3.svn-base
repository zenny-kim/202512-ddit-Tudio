<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%-- 날짜 비교를 위해 fmt 라이브러리 추가 --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- [NEW 아이콘 로직] 오늘 날짜 구하기 (yyyy-MM-dd) --%>
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="today" />

<style>
/* 기존 배지 스타일 유지 */
.tudio-badge.badge-red { background-color: #ffeded; color: #ff4d4f; border: 1px solid #ffccc7; }
.tudio-badge.badge-yellow { background-color: #fffbe6; color: #faad14; border: 1px solid #ffe58f; }
.tudio-badge.badge-blue { background-color: #e6f7ff; color: #1890ff; border: 1px solid #91d5ff; }
.tudio-badge.badge-default { background-color: #f5f5f5; color: #8c8c8c; border: 1px solid #d9d9d9; }
.tudio-section .tudio-table-card { border-collapse: collapse !important; border-spacing: 0 !important; }

/* new 아이콘 */
.badge-new-style {
   	display: inline-flex;
    align-items: center;
    justify-content: center;
    background-color: #ff4d4f;
    color: #fff;
    font-size: 10px;
    font-weight: bold;
    width: 18px;                /* 너비 높이 똑같이 */
    height: 18px;
    border-radius: 50%;         /* 완전 동그라미 */
    margin-left: 5px;
    line-height: 1;
    vertical-align: middle;
    transform: translateY(-1px);
}

/*  심플 라인 스타일
.badge-new-style {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    
    background-color: #fff;
    border: 1px solid #ff4d4f; 
    color: #ff4d4f; 
    
    font-size: 10px;
    font-weight: 700;
    
    height: 18px;
    padding: 0 6px;
    border-radius: 4px; 
    
    margin-left: 6px;
    line-height: 1;
    vertical-align: middle;
    transform: translateY(-1px);
} 
 */
/* 파일 아이콘 */
.file-icon-wrap {
    display: inline-flex;
    align-items: center;
    color: #868e96;     /* 차분한 회색 */
    font-size: 0.8rem;
    margin-left: 8px;
    font-weight: 500;
    gap: 2px;           /* 아이콘과 숫자 사이 간격 */
}
.file-icon-wrap i {
    font-size: 0.9rem;  /* 아이콘 크기 미세 조정 */
}
</style>

<div class="tudio-board">

    <div class="tudio-section-header d-flex align-items-center justify-content-between">
        <h5 class="h5 fw-bold m-0 text-primary-dark">
            <i class="bi bi-journal-text me-2"></i>커뮤니티
        </h5>

        <div class="d-flex align-items-center gap-2">
            <div class="tudio-pills">
                <button class="tudio-pill is-active" data-category="">전체</button>
                <button class="tudio-pill" data-category="NOTICE">공지</button>
                <button class="tudio-pill" data-category="FREE">자유</button>
                <button class="tudio-pill" data-category="MINUTES">회의록</button>
            </div>
            
            <button class="tudio-btn tudio-btn-primary ms-2" type="button" id="btnInsertForm">
                <i class="bi bi-pencil me-1"></i> 글쓰기
            </button>
        </div>
    </div>

    <div class="tudio-section-filter d-flex justify-content-between align-items-center mb-3">
        
        <div class="text-muted ms-2" style="font-size: 14px;">
            총 <b class="text-dark" id="totalCnt">0</b>건
        </div>
    
        <div class="d-flex align-items-center gap-2">
            <div class="tudio-search" style="width: 250px;">
                <input type="text" id="searchWord" value="${searchWord}" placeholder="검색어를 입력하세요" />
            </div>
            <button type="button" id="btnSearch" class="tudio-btn tudio-btn-primary">
                검색
            </button>
        </div>
    </div>

    <div class="tudio-table-wrap">
        <table class="tudio-table-card">
            <thead>
                <tr>
                    <th class="text-center" style="width: 15%">구분</th>
                    <th class="text" style="width: 40%">제목</th>
                    <th class="text-center" style="width: 15%">작성자</th>
                    <th class="text-center" style="width: 20%">작성일</th>
                    <th class="text-center" style="width: 10%">조회수</th>
                </tr>
            </thead>
            <tbody id="boardTbody">
                <c:forEach items="${boardList}" var="board">
                    <c:set var="tempTitle" value="${board.boTitle}" />
                    <c:set var="tempTitle" value="${fn:replace(tempTitle, '[공지]', '')}" />
                    <c:set var="tempTitle" value="${fn:replace(tempTitle, '[자유]', '')}" />
                    <c:set var="tempTitle" value="${fn:replace(tempTitle, '[회의록]', '')}" />
                    
                    <tr class="row-click">
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${board.categoryName == 'NOTICE'}">
                                    <span class="tudio-badge badge-red">공지</span>
                                </c:when>
                                <c:when test="${board.categoryName == 'FREE'}">
                                    <span class="tudio-badge badge-yellow">자유</span>
                                </c:when>
                                <c:when test="${board.categoryName == 'MINUTES'}">
                                    <span class="tudio-badge badge-blue">회의록</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="tudio-badge badge-default">기타</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        
                        <td class="title" onclick="goDetail(${param.projectNo}, ${board.boNo})" style="cursor: pointer;">
                            <a href="javascript:void(0);" style="pointer-events: none;" class="text-decoration-none text-dark">
                                ${fn:trim(tempTitle)}
                                
                                <%-- [수정 2] 파일 아이콘 및 개수 표시 (fileCount가 0보다 클 때만) --%>
                                <c:if test="${board.fileCount > 0}">
                                    <span class="text-muted ms-2" style="font-size: 0.85rem;" title="첨부파일 ${board.fileCount}개">
                                        <i class="bi bi-paperclip"></i> ${board.fileCount}
                                    </span>
                                </c:if>

                                <%-- [수정 3] NEW 아이콘 (오늘 작성한 글일 경우) --%>
                                <%-- boRegdate 문자열 앞 10자리(yyyy-MM-dd)가 오늘 날짜와 같으면 표시 --%>
                                <c:if test="${fn:substring(board.boRegdate, 0, 10) == today}">
                                    <span class="badge-new-style">N</span>
                                </c:if>
                            </a>
                        </td>

                        <td class="text-center">${board.memberVO.memberName}</td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${fn:length(board.boRegdate) >= 10}">
                                    ${fn:substring(board.boRegdate, 2, 10)}
                                </c:when>
                                <c:otherwise>${board.boRegdate}</c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-center">${board.boHit}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <div class="tudio-pager" id="boardPager"></div>

</div>
<script src="/js/projectBoard.js"></script>