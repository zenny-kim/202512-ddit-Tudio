<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<style>
/* [1] 웹 화면용 스타일 (상세보기 화면) */
#pdfArea.detail-view-container {
    background: #fff;
    padding: 30px;
    border: 1.5px solid var(--border-blue);
    border-radius: 16px;
}

/* 웹 화면에서의 테이블 스타일 (게시판 느낌) */
.pdf-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 20px;
}

.pdf-table th {
    background-color: #f8fafc;
    border: 1px solid #e2e8f0;
    color: var(--dark-navy);
    width: 150px;
    text-align: center;
    font-weight: 700;
}

.pdf-table td {
    border: 1px solid #e2e8f0;
    padding: 15px;
    color: var(--text-main);
}

.pdf-main-title {
    font-size: 24px;
    font-weight: 800;
    color: var(--dark-navy);
    margin-bottom: 30px;
    text-align: center;
}

.content-cell {
    min-height: 200px;
    vertical-align: top;
    line-height: 1.6;
}

/* [2] PDF 출력 전용 스타일 (saveAsPdf 호출 시에만 작동) */
/* PDF 저장 시 버튼 영역 숨기기 */
.is-pdf-mode .no-print {
    display: none !important;
}
/* PDF 모드일 때 테이블의 행(tr)이 페이지 중간에서 잘리지 않도록 설정 */
.is-pdf-mode tr {
    page-break-inside: avoid;
}
.is-pdf-mode { 
    padding: 0 !important; 
    margin: 0 !important; 
    display: flex !important;
    justify-content: center !important;
}

.is-pdf-mode .pdf-border-box {
    background: #fff !important;
    width: 210mm !important;
    min-height: 297mm !important;
    margin: 0 auto !important;
    padding: 25mm 20mm !important;
    border: none !important;
}

.is-pdf-mode .pdf-main-title {
    font-size: 32pt !important;
    letter-spacing: 15px !important;
    border-bottom: 3px double var(--main-blue) !important;
    display: inline-block !important;
    padding-bottom: 5mm !important;
    margin-bottom: 15mm !important;
}

.is-pdf-mode .pdf-table th {
    background-color: #f8fafc !important;
    border: 1px solid #cbd5e1 !important;
    font-size: 11pt !important;
}

.is-pdf-mode .pdf-table td {
    border: 1px solid #cbd5e1 !important;
    font-size: 11pt !important;
}


#pdfArea .tudio-section-header {
    border-bottom: none;      /* 하단 선 제거 */
    background: transparent;  /* 배경색 투명하게 (흰색이랑 어울리게) */
    padding-bottom: 10px;     /* 간격만 살짝 유지 */
}

/* 첨부파일 배지 스타일 */
.file-badge-item {
    display: inline-flex;
    align-items: center;
    background-color: #f1f5f9;
    color: #475569;
    padding: 4px 10px;
    border-radius: 20px;
    font-size: 0.85rem;
    margin-right: 5px;
    margin-bottom: 5px;
}
.file-badge-item i {
    margin-right: 4px;
}
</style>
<div id="pdfArea" class="detail-view-container meeting-mode">
<div class="tudio-section-header no-print d-flex gap-2 justify-content-end">
    <button class="tudio-btn tudio-btn-primary" onclick="saveAsPdf()">
        <i class="bi bi-file-earmark-pdf"></i> PDF 저장
    </button>
    <button class="tudio-btn" id="btnBackToList">목록</button>
</div>
		<div class="pdf-border-box">
			<div class="pdf-header" style="text-align: center;">
				<h1 class="pdf-main-title">회 의 록</h1>
			</div>
		

		<table class="pdf-table">
                <tbody>
                    <tr>
                        <th>제목</th>
                        <td colspan="3" style="font-weight: 800; font-size: 1.1rem;">${board.boTitle}</td>
                    </tr>
                    <tr>
                        <th>작성자</th>
                        <td style="width: 35%;">${board.memberVO.memberName}</td>
                        <th style="width: 15%;">작성일</th>
                        <td style="width: 35%;">
                        	${fn:substring(board.boRegdate, 0, 10)}
                        </td>
                    </tr>

                        <tr>
                            <th>회의 일시</th>
                            <td>
								${fn:replace(board.boardMinutesVO.meetingDate, 'T', ' ')}
							</td>
                            <th>참석자</th>
                            <td>
                                <c:forEach items="${board.meetingMemberList}" var="meetMem" varStatus="vs">
                                    <c:forEach items="${memberList}" var="allMem">
                                        <c:if test="${meetMem.memberNo == allMem.memberNo}">
                                            ${allMem.memberName}${!vs.last ? ', ' : ''}
                                        </c:if>
                                    </c:forEach>
                                </c:forEach>
                            </td>
                        </tr>
                        <tr>
                            <th>회의 목표</th>
                            <td colspan="3">${board.boardMinutesVO.meetingGoal}</td>
                        </tr>
                    	<tr>
	                        <th colspan="4" style="text-align: left; background-color: #f1f5f9; white-space: pre-wrap;">
	                            <i class="bi bi-card-text"></i> 내용
	                        </th>
                    	</tr>
                    	<tr>
                        	<td colspan="4" class="content-cell" style="padding-left: 70px; white-space: pre-wrap;">${board.boContent}</td>
                   	 	</tr>
                        <tr>
                            <th colspan="4" style="text-align: left; background-color: #f1f5f9;  white-space: pre-wrap;">
                                <i class="bi bi-check-circle"></i> 회의 결과 및 결정사항
                            </th>
                        </tr>
                        <tr>
                            <td colspan="4" class="content-cell result-cell" style="font-weight: 400; padding-left: 70px; white-space: pre-wrap;">${board.boardMinutesVO.meetingResult}</td>
                        </tr>
                    	<tr>
						    <th style="background-color: #f8fafc;">
						        <i class="bi bi-paperclip me-1"></i> 첨부파일
						    </th>
						    <td colspan="3">
						        <c:choose>
						            <c:when test="${not empty board.boFileDetailList}">
						                <ul class="list-unstyled mb-0">
						                    <c:forEach items="${board.boFileDetailList}" var="file">
						                        <li class="mb-1">
						                            <i class="bi bi-file-earmark-arrow-down text-primary"></i>
						                            <a href="${pageContext.request.contextPath}/tudio/project/board/download?fileNo=${file.fileNo}" 
						                               class="text-decoration-none text-dark ms-1" 
						                               title="파일 다운로드">
						                                ${file.fileOriginalName} <span class="text-muted small">(${file.fileFancysize})</span>
						                            </a>
						                        </li>
						                    </c:forEach>
						                </ul>
						            </c:when>
						            <c:otherwise>
						                <span class="text-muted small">첨부된 파일이 없습니다.</span>
						            </c:otherwise>
						        </c:choose>
						    </td>
						</tr>
                	</tbody>
            	</table>
            	</div>
				<div class="d-flex justify-content-center gap-2 mt-4 no-print">
				    <c:if test="${loginUser.memberNo == board.memberVO.memberNo}">
				        <button type="button" class="tudio-btn tudio-btn-outline" 
				                onclick="goUpdate('${projectNo}', '${board.boNo}')">
				            <i class="bi bi-pencil-square" style="color: var(--main-blue);"></i> 수정
				        </button>
				        <button type="button" class="tudio-btn tudio-btn-outline-danger" 
				                onclick="deleteBoard('${board.boNo}')">
				            <i class="bi bi-trash"></i> 삭제
				        </button>
				    </c:if>
				</div>

</div>


<!-- 댓글 -->
	<div class="tudio-comment-wrapper">
	        
	        <div class="comment-header-title">
	            <i class="bi bi-chat-square-text-fill text-primary"></i> 댓글 
	            <span class="text-muted ms-1 fs-6" id="commentCount">(${fn:length(commentList)})</span>
	        </div>
	
	        <div class="comment-list">
	            <jsp:include page="/WEB-INF/views/comment.jsp" />
	        </div>
	
	        <div class="comment-write-box" style="margin-bottom: 0; margin-top: 20px;">
	            <img src="${pageContext.request.contextPath}${loginUser.memberProfileimg}" 
	                 onerror="this.src='${pageContext.request.contextPath}/resources/images/default_profile.png'"
	                 class="comment-profile-img" alt="프로필">
	            
	            <div class="comment-input-area">
	                <form id="commentForm">
	                    <input type="hidden" name="targetType" value="B"> 
	                    <input type="hidden" name="targetId" value="${board.boNo}"> 
	                    
	                    <div id="fileNameArea">
	                        <i class="bi bi-paperclip"></i>
	                        <span id="fileNameText"></span>
	                        <i class="bi bi-x-circle-fill text-danger" onclick="clearFile()" style="cursor:pointer;" title="삭제"></i>
	                    </div>
	
	                    <div class="messenger-input-row">
	                        <textarea name="cmtContent" id="mainCmtContent" placeholder="댓글을 남겨주세요." rows="1"></textarea>
	                        
	                        <div class="messenger-actions">
	                            <label for="cmtFileList" class="btn-file-icon" title="파일 첨부">
	                                <i class="bi bi-paperclip"></i>
	                            </label>
	                            <input type="file" id="cmtFileList" name="cmtFileList" class="file-upload-hidden" onchange="checkFile(this)" multiple> 
	                            
	                            <button type="button" class="btn-send-simple" onclick="insertComment()" title="등록">
	                                <i class="bi bi-send-fill" style="font-size: 0.9rem; margin-left: -2px;"></i>
	                            </button>
	                        </div>
	                    </div>
	                </form>
	            </div>
	        </div>
	</div>
<!-- 댓글 -->
<script>
    const contextPath = "${pageContext.request.contextPath}";
    const reloadUrl = "${pageContext.request.contextPath}/comment/list?targetType=B&targetId=${board.boNo}";
</script>	
<script src="${pageContext.request.contextPath}/js/comment.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
<script>


function saveAsPdf() {
    const element = document.getElementById('pdfArea');
    element.classList.add('is-pdf-mode');

    const options = {
        margin: 0,
        filename: '회의록_${board.boTitle}.pdf',
        image: { type: 'jpeg', quality: 1.0 },
        html2canvas: { 
            scale: 2, 
            useCORS: true,
            scrollY: 0,
            letterRendering: true
        },
        jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' }
    };

    html2pdf().set(options).from(element).save().then(() => {
        element.classList.remove('is-pdf-mode');
    });
}
</script>