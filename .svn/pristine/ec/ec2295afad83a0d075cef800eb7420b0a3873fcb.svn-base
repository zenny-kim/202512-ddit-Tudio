<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>

<script src="${pageContext.request.contextPath}/js/memList.js"></script>

<div class="chat-widget">
    <c:set var="memCount" value="${chatroomTitle.MEM_COUNT }"/>

    <header class="chat-room-header">
        <div class="header-left">
            <button id="backBtn" class="header-btn" aria-label="뒤로 가기" 
                    data-tooltip="뒤로 가기" data-tooltip-pos="left">
                <i data-feather="chevron-left"></i>
            </button>
        </div>

        <h2 class="room-title">
            <span class="room-name-text">${not empty chatroomTitle.CHATROOM_NAME? chatroomTitle.CHATROOM_NAME : 'null'}</span>
            <c:if test="${chatroomTitle.MEM_COUNT > 2}">
                <span class="member-count">${memCount }</span>
            </c:if>
        </h2>
        
        <div class="header-right">
            <button class="header-btn" aria-label="검색" data-tooltip="대화 검색">
                <i data-feather="search" style="width:20px; height:20px;"></i>
            </button>

            <button id="settingBtn" class="header-btn" aria-label="채팅방 설정" data-tooltip="설정">
		        <i data-feather="settings" style="width:20px; height:20px;"></i>
		    </button>
		
		    <div id="settingMenu" class="chat-dropdown-menu" >
		        <ul>
		            <li><a href="#" id="menuInvite">대화상대 초대</a></li>
		            <li class="danger"><a href="#" id="menuExit">채팅방 나가기</a></li>
		        </ul>
		    </div>
        </div>
    </header>

	<c:set var="isEnd" value="false"/>

    <main class="chat-room-content">
        <c:set var="lastChatNo" value=""/>
        <c:set var="preChatDate" value=""/>
        <c:set var="firstChatDate" value=""/>
        <c:set var="myProfileimg" value="${sessionScope.loginUser.memberProfileimg }"/>
        <c:set var="isEmptyChat" value="true"/>
        <c:set var="myName" value="${myName }"/>
        <c:set var="lastReadChatNo" value="${lastReadChatNo }"/>
    	
        <c:forEach items="${chatList }" var="chat" varStatus="status">
            <fmt:formatDate value="${preChatDate }" var="fmtPreChatDate" pattern="yyyyMMdd"/>
            <fmt:formatDate value="${chat.createDate }" var="fmtCurChatDate" pattern="yyyyMMdd"/>
        
            <c:if test="${status.first }">
		        <c:set var="isEmptyChat" value="false"/>
                <fmt:formatDate value="${chat.createDate }" var="firstChatDate" pattern="yyyyMMdd"/>
                <c:set var="lastChatNo" value="${chat.chatNo }"/>
                
                <%-- 
                	불러온 채팅의 길이가 30보다 작다는 것은 해당 채팅방의 전체 채팅을 다 불러온 것이다.
                	그렇기에 맨 상단에 날짜 알림 div를 띄워준다. 
               	--%>
                <c:if test="${fn:length(chatList) < 30 }">
					<c:set var="isEnd" value="true"/>
                	<div class="system-message-container" >
	                    <span class="system-message">
	                        <fmt:formatDate value="${chat.createDate }" pattern="yyyy년 MM월 dd일 E요일"/>
	                    </span>
	                </div>
                </c:if>
            </c:if>
            
            <c:if test="${!status.first and (fmtPreChatDate < fmtCurChatDate)}">
                <div class="system-message-container" >
                    <span class="system-message">
                        <fmt:formatDate value="${chat.createDate }" pattern="yyyy년 MM월 dd일 E요일"/>
                    </span>
                </div>
            </c:if>
            <c:set var="preChatDate" value="${chat.createDate }"/>
        
            <c:choose>
                <c:when test="${chat.chatType eq 'SYSTEM'}">
                    <div class="system-message-container" id="chat${chat.chatNo}">
                        <span class="system-message">${chat.message }</span>
                    </div>
                </c:when>
                <%-- 내가 보낸 채팅이라면 --%>
                <c:when test="${chat.memberNo eq myMemNo }">
	                    <div class="message-row sent" id="chat${chat.chatNo}">
	                        <div class="bubble-container">
	                            <div class="sent-info">
	                                <c:if test="${chat.notReadCnt ne 0}">
	                                    <span class="unread-count">${chat.notReadCnt }</span>
	                                </c:if>
	                                <span class="message-time">${chat.fmtCreateDate }</span>
	                            </div>
								<c:choose>
									<c:when test="${chat.chatType eq 'TEXT'}">
			                            <div class="message-bubble">${chat.message }</div>
									</c:when>
									<c:when test="${chat.chatType eq 'IMAGE' }">
										<div class="message-media-image" onclick="window.open('${pageContext.request.contextPath}/upload/chat/${chat.file.fileSaveName}')" style="width: 180px;">
	                                        <img src="${pageContext.request.contextPath}/upload/chat/${chat.file.fileSaveName}">
	                                    </div>
									</c:when>
									<c:otherwise>
										<div class="message-bubble file-type">
											<div class="file-attachment-card" onclick="location.href='${pageContext.request.contextPath}/tudio/chat/download?fileNo=${chat.fileAttachNo}'" style="cursor:pointer;">
	                                            <div class="file-icon-box">
	                                                <i data-feather="file-text" style="width:18px; height:18px;"></i>
	                                            </div>
	                                            <div class="file-info-area">
	                                                <span class="file-name">${chat.file.fileOriginalName}</span>
	                                                <c:if test="${empty chat.file.fileOriginalName}">
									                    <span class="file-name">파일</span>
									                </c:if>
	                                                <span class="file-size">${chat.file.fileFancysize }</span>
	                                            </div>
	                                        </div>
										</div>
									</c:otherwise>
								</c:choose>
	                        </div>
	                    </div>
                </c:when>
                <%-- 상대방이 보낸 채팅이라면 --%>
                <c:when test="${chat.memberNo ne myMemNo  }">
                    <div class="message-row received" id="chat${chat.chatNo}">
                        <c:choose>
                            <c:when test="${not empty chat.memberProfileimg}">
                                <img src="${pageContext.request.contextPath}${chat.memberProfileimg}" class="profile-img" alt="프로필">
                            </c:when>
                            <c:otherwise>
                                <div class="default-avatar avatar-color-${chat.memberNo % 5}">
                                    <i data-feather="user" style="width:20px; height:20px;"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div class="message-content">
                            <span class="sender-name">${chat.memberName }</span>
                            <div class="bubble-container">
                                <c:choose>
									<c:when test="${chat.chatType eq 'TEXT'}">
			                            <div class="message-bubble">${chat.message }</div>
									</c:when>
									<c:when test="${chat.chatType eq 'IMAGE' }">
										<div class="message-media-image" onclick="window.open('${pageContext.request.contextPath}/upload/chat/${chat.file.fileSaveName}')" style="width: 180px;">
	                                        <img src="${pageContext.request.contextPath}/upload/chat/${chat.file.fileSaveName}">
	                                    </div>
									</c:when>
									<c:otherwise>
										<div class="message-bubble file-type">
											<div class="file-attachment-card" onclick="location.href='${pageContext.request.contextPath}/tudio/chat/download?fileNo=${chat.fileAttachNo}'" style="cursor:pointer;">
	                                            <div class="file-icon-box">
	                                                <i data-feather="file-text" style="width:20px; height:20px;"></i>
	                                            </div>
	                                            <div class="file-info-area">
	                                                <span class="file-name">${chat.file.fileOriginalName}</span>
	                                                <c:if test="${empty chat.file.fileOriginalName}">
									                    <span class="file-name">파일</span>
									                </c:if>
	                                                <span class="file-size">${chat.file.fileFancysize}</span>
	                                            </div>
	                                        </div>
	                                    </div>
									</c:otherwise>
								</c:choose>
                                
                                <div class="received-info">
                                    <c:if test="${chat.notReadCnt ne 0}">
                                        <span class="unread-count">${chat.notReadCnt }</span>
                                    </c:if>
                                    <span class="message-time">${chat.fmtCreateDate }</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:when>
            </c:choose>
        </c:forEach>
    </main>

    <footer class="chat-input-area">
        <button class="footer-btn attach-btn" aria-label="파일 첨부" 
                data-tooltip="파일 첨부" data-tooltip-pos="left">
            <i data-feather="plus" width="24" height="24"></i>
        </button>
        
        <input type="file" class="input-file" multiple>

        <div class="input-wrapper">
            <textarea class="chat-input" placeholder="메시지 보내기" rows="1"></textarea>
        </div>

        <button class="footer-btn send-btn" aria-label="전송" 
                data-tooltip="전송" data-tooltip-pos="right">
            <i data-feather="send" width="18" height="18"></i>
        </button>
    </footer>
    
	<div class="new-chat-container-wrapper">    
		<div id="inviteModal" class="modal-overlay" style="display: none;">
	        <div class="modal-window">
	            
	            <div class="modal-header-bar">
	                <span class="modal-title-text">대화상대 초대</span>
	                <button type="button" id="closeModalBtn" class="modal-close-btn" aria-label="닫기">
	                    <i data-feather="x"></i>
	                </button>
	            </div>
	
	            <div class="modal-body-content">
	                <jsp:include page="./memList.jsp">
	                    <jsp:param name="btnText" value="초대"/>
	                </jsp:include>
	            </div>
	        </div>
	    </div>
	</div>
	
</div>

<script>
	window.contextPath = "${pageContext.request.contextPath}"
	window.chatroomNo = ${chatroomTitle.CHATROOM_NO};
	window.lastChatNo = "${lastChatNo}";
	window.memCount = ${memCount};
	window.myMemNo = ${myMemNo};
	window.myName = "${myName}";
	window.myProfileimg = "${myProfileimg}";
	// 해당 채팅방에 채팅이 아예 없는지의 여부
 	window.isEmptyChat = "${isEmptyChat}";
    // 서버에서 해당 채팅방의 모든 채팅을 가져왔는지 확인
    window.isEnd = ${isEnd};
 	// 이미 생성되어있는 div의 첫 채팅 날짜
    window.bottomFirstChatDate = "${firstChatDate}";
    
    $(function(){
    	// 대화상대 초대 시 실행될 멤버추가 ajax
    	function inviteMember(selectData){
    		const chatroomVo = {
    			chatroomNo : window.chatroomNo,
  				chatMemberNoList : selectData.selectedUserNo,
	    		chatMemberNameList : selectData.selectedAllUserName
    		}
    		$.ajax({
    			url: "/tudio/chat/invite",
    			type: "post",
    			contentType: "application/json;charset=utf-8",
    			data: JSON.stringify(chatroomVo),
    			success: function(result){
    				$("#inviteModal").fadeOut(200); 
    				$(".member-count").text(result)
    			},
    			error: function(error, status, thrown){
    				console.log(error);
    				console.log(status);
    				console.log(thrown);
    			}
    		})
    	}
    	// 대화상대 초대 항목을 클릭했을 경우
    	$("#menuInvite").on("click", function(e){
            e.preventDefault();
            $("#settingMenu").removeClass("active"); // 메뉴 닫기
            $("#inviteModal").fadeIn(200); // 모달 열기
		  	MemberSelectList.init("${pageContext.request.contextPath}", " 초대", inviteMember, ".new-chat-container-wrapper")
        });
    	
    	// 대화상대 초대 모달에서 닫기 버튼을 클릭했을 경우
    	$("#closeModalBtn").on("click", function(){
            $("#inviteModal").fadeOut(200); // 모달 닫기
        })
        
        $("#inviteModal").on("click", function(e){
            if($(e.target).is("#inviteModal")) {
                $(this).fadeOut(200);
            }
        });
    	
    })
</script>
<script src="${pageContext.request.contextPath}/js/chatroom.js"></script>