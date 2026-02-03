<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
/* 전체 컨테이너는 공통 CSS의 tudio-card를 따르되 내부 패딩 제거 (헤더 배경 꽉 채우기 위해) */
.tudio-card.board-container {
    padding: 0 !important; 
    overflow: hidden; /* 배경색 둥근 모서리 적용 */
}

.tudio-badge.badge-red { background-color: #ffeded; color: #ff4d4f; }
.tudio-badge.badge-yellow { background-color: #fffbe6; color: #faad14; }

/* [1] 헤더 영역 (배경색 추가로 백지 느낌 탈피) */
.board-visual-header {
    background: linear-gradient(to bottom, #f8fbff, #ffffff); /* 은은한 블루->화이트 */
    border-bottom: 1px solid #eef2f7;
    padding: 40px 40px 30px 40px;
}

/* 상단 배지 & 버튼 줄 */
.board-header-top {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 15px;
}

/* 제목 스타일 */
.board-view-title {
    font-size: 1.85rem;
    font-weight: 800;
    color: #1e293b; /* 진한 네이비 */
    line-height: 1.35;
    margin-bottom: 25px;
    letter-spacing: -0.5px;
}

/* 작성자 정보 바 */
.board-info-bar {
    display: flex;
    align-items: center;
    gap: 12px;
}

.profile-img-lg {
    width: 48px;
    height: 48px;
    border-radius: 50%;
    border: 2px solid #fff;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    object-fit: cover;
}

.writer-info {
    display: flex;
    flex-direction: column;
}

.writer-name {
    font-size: 1rem;
    font-weight: 700;
    color: #334155;
}

.writer-meta {
    font-size: 0.85rem;
    color: #94a3b8;
    margin-top: 2px;
    font-weight: 500;
}

/* [2] 본문 영역 */
.board-body-wrapper {
    padding: 40px;
}

.board-view-content {
    min-height: 200px;
    font-size: 1.05rem;
    line-height: 1.8;
    color: #334155;
    white-space: pre-wrap; /* 줄바꿈 유지 */
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

/* [4] 하단 버튼 */
.board-action-bar {
    margin-top: 40px;
    display: flex;
    justify-content: center;
    gap: 8px;
}
</style>

<div class="tudio-card board-container">
    
    <div class="board-visual-header">
        <div class="board-header-top">
            <span class="tudio-badge ${board.categoryName == 'NOTICE' ? 'badge-red' : 'badge-yellow'}" 
                  style="font-size: 13px; padding: 6px 14px;">
                ${board.categoryName == 'NOTICE' ? '📢 공지사항' : '💬 자유게시판'}
            </span>
            
            <button class="tudio-btn" id="btnBackToList" style="background: white; border:1px solid #e2e8f0;">
                목록으로
            </button>
        </div>

        <h1 class="board-view-title">${board.boTitle}</h1>

        <div class="board-info-bar">
            <img src="${pageContext.request.contextPath}${board.memberVO.memberProfileimg}" 
                 onerror="this.src='${pageContext.request.contextPath}/images/default_profile.png'"
                 class="profile-img-lg">
            
            <div class="writer-info">
                <span class="writer-name">${board.memberVO.memberName}</span>
                <span class="writer-meta">
                    ${fn:replace(fn:replace(fn:substring(board.boRegdate, 0, 16), 'T', ' '), '-', '.')}
                    <span class="mx-2" style="color:#cbd5e1;">|</span>
                    조회 ${board.boHit}
                </span>
            </div>
        </div>
    </div>

    <div class="board-body-wrapper">
        <div class="board-view-content">
            ${board.boContent}
        </div>

        <c:if test="${not empty board.boFileDetailList}">
            <div class="board-file-section">
                <span class="file-label">
                    <i class="bi bi-paperclip me-1"></i> 첨부파일 <span class="text-primary">${fn:length(board.boFileDetailList)}</span>개
                </span>
                
                <div class="file-card-grid">
                    <c:forEach items="${board.boFileDetailList}" var="file">
                        <a href="${pageContext.request.contextPath}/tudio/project/board/download?fileNo=${file.fileNo}" 
                           class="file-card">
                            <div class="file-icon-box">
                                <i class="bi bi-file-earmark-text"></i>
                            </div>
                            <div class="file-info">
                                <span class="file-name">${file.fileOriginalName}</span>
                                <span class="file-size">${file.fileFancysize}</span>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </div>
        </c:if>

        <div class="board-action-bar">
            <c:if test="${loginUser.memberNo == board.memberVO.memberNo}">
                <button type="button" class="tudio-btn tudio-btn-outline" 
                        onclick="goUpdate('${projectNo}', '${board.boNo}')">
                    <i class="bi bi-pencil-square"></i> 수정
                </button>
                <button type="button" class="tudio-btn tudio-btn-outline-danger" 
                        onclick="deleteBoard('${board.boNo}')">
                    <i class="bi bi-trash"></i> 삭제
                </button>
            </c:if>
        </div>
    </div>

</div>