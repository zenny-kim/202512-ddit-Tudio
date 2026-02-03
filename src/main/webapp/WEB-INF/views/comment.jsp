<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="commentListArea">
    <c:choose>
        <c:when test="${empty commentList}">
            <div class="tudio-empty">
                <i class="bi bi-chat-dots"></i>
                <p class="title">아직 작성된 댓글이 없습니다.</p>
                <span style="font-size: 0.9rem;">첫 번째 댓글을 남겨보세요!</span>
            </div>
        </c:when>
        
        <c:otherwise>
            <c:forEach items="${commentList}" var="cmt">
                <div class="comment-item ${cmt.cmtDepth > 0 ? 'reply' : ''}" id="cmt_${cmt.cmtNo}">
                    
                    <img src="${pageContext.request.contextPath}${cmt.memberProfileimg}" 
                            onerror="this.src='${pageContext.request.contextPath}/images/default_profile.png'"
                            class="comment-profile-img" alt="작성자">
                    
                    <div class="comment-content-box">
                        <c:choose>
                            <c:when test="${cmt.cmtStatus == 'N'}">
                                <div class="deleted-message text-muted fst-italic py-2">
                                    <i class="bi bi-exclamation-circle me-1"></i> 삭제된 댓글입니다.
                                </div>
                            </c:when>

                            <c:otherwise>
                                <div class="comment-meta">
                                    <div>
                                        <span class="comment-writer">${cmt.memberVO.memberName}</span> 
                                        <span class="comment-date"><fmt:formatDate value="${cmt.cmtRegdate}" pattern="yyyy.MM.dd HH:mm"/></span>
                                    </div>
                                    
                                    <div class="d-flex gap-2">
                                        <c:if test="${cmt.cmtDepth == 0}">
                                            <button type="button" class="btn-cmt-action" onclick="toggleReplyForm(${cmt.cmtNo})">답글</button>
                                        </c:if>
                                        
                                        <c:if test="${sessionScope.loginUser.memberNo == cmt.memberNo}">
                                            <button type="button" class="btn-cmt-action delete" onclick="deleteComment(${cmt.cmtNo})">삭제</button>
                                        </c:if>
                                    </div>
                                </div>

                                <div class="comment-text"><c:out value="${cmt.cmtContent}" /></div>

                                <c:if test="${not empty cmt.cmtFileDetailList}">
                                    <div class="comment-file-area mt-2">
                                        <c:forEach items="${cmt.cmtFileDetailList}" var="cFile">
                                        	<c:if test="${cFile.fileNo > 0 and not empty cFile.fileOriginalName}">
                                            <a href="${pageContext.request.contextPath}/comment/download?fileNo=${cFile.fileNo}" 
                                                    class="file-badge-item text-decoration-none">
                                                    <i class="bi bi-paperclip"></i> ${cFile.fileOriginalName} 
                                                    <span class="ms-1" style="font-size: 0.7em;">(${cFile.fileFancysize})</span>
                                            </a>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </c:if>

                                <div id="replyForm_${cmt.cmtNo}" class="reply-form-container mt-3" style="display:none;">
								    <div class="comment-write-box" style="margin-bottom: 0;">
								        <div class="comment-input-area">
								            
								            <div id="replyFileNameArea_${cmt.cmtNo}" class="file-name-area-sm" style="display:none; margin-bottom: 5px;">
								                </div>
								
								            <div class="messenger-input-row" style="background: #fff;">
								                <textarea id="replyContent_${cmt.cmtNo}" onkeydown="handleReplyEnter(event, ${cmt.cmtNo}, ${cmt.cmtGroup})" placeholder="답글을 입력하세요." rows="1" ></textarea>
								                <div class="messenger-actions">
								                    <label for="replyFile_${cmt.cmtNo}" class="btn-file-icon" title="파일 첨부">
								                        <i class="bi bi-paperclip"></i>
								                    </label>
								                    
								                    <input type="file" id="replyFile_${cmt.cmtNo}" class="file-upload-hidden" 
								                           onchange="checkFile(this)" multiple>
								                    
								                    <button type="button" class="btn-send-simple" 
								                            onclick="insertReplyComment(${cmt.cmtNo}, ${cmt.cmtGroup})" title="답글 등록">
								                        <i class="bi bi-arrow-return-left" style="font-size: 0.9rem;"></i>
								                    </button>
								                </div>
								            </div>
								        </div>
								    </div>
								</div>
                            </c:otherwise> 
                        </c:choose> 
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>