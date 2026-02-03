<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


	<!-- 회의록 : detailMeetingMinutes.jsp -->
	<!-- 공지&자유 : detailProjectBoard.jsp -->
    <c:choose>
        <c:when test="${board.categoryName == 'MINUTES'}">
            <jsp:include page="detailMeetingMinutes.jsp" />
        </c:when>
        <c:otherwise>
            <jsp:include page="detailProjectBoard.jsp" />
        </c:otherwise>
    </c:choose>

    <div class="tudio-comment-wrapper mt-5">
        <div class="comment-header-title mb-3">
            <i class="bi bi-chat-square-text-fill text-primary"></i> 댓글 
            <span class="text-muted ms-1 fs-6" id="commentCount">(${fn:length(commentList)})</span>
        </div>

        <div class="comment-list">
            <jsp:include page="/WEB-INF/views/comment.jsp" />
        </div>

        <div class="comment-write-box" style="margin-top: 20px;">
            <img src="${pageContext.request.contextPath}${loginUser.memberProfileimg}" 
                 onerror="this.src='${pageContext.request.contextPath}/resources/images/default_profile.png'"
                 class="comment-profile-img" alt="프로필">
            
            <div class="comment-input-area">
                <form id="commentForm">
                    <input type="hidden" name="targetType" value="B"> 
                    <input type="hidden" name="targetId" value="${board.boNo}"> 
                    
                    <div id="fileNameArea" style="display:none;">
                        <i class="bi bi-paperclip"></i>
                        <span id="fileNameText"></span>
                        <i class="bi bi-x-circle-fill text-danger" onclick="clearFile()" style="cursor:pointer;" title="삭제"></i>
                    </div>

                    <div class="messenger-input-row">
                        <textarea name="cmtContent" id="mainCmtContent" onkeydown="handleMainEnter(event)" placeholder="댓글을 남겨주세요." rows="1"></textarea>
                        
                        <div class="messenger-actions">
                            <label for="cmtFileList" class="btn-file-icon" title="파일 첨부">
                                <i class="bi bi-paperclip"></i>
                            </label>
                            <input type="file" id="cmtFileList" name="cmtFileList" class="file-upload-hidden" onchange="checkFile(this)" multiple> 
                            
                            <button type="button" class="btn-send-simple" onclick="insertComment()" title="등록">
                                <i class="bi bi-send-fill"></i>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>


<script>
    const contextPath = "${pageContext.request.contextPath}";
    const reloadUrl = "${pageContext.request.contextPath}/comment/list?targetType=B&targetId=${board.boNo}";
</script>	
<script src="${pageContext.request.contextPath}/js/comment.js"></script>