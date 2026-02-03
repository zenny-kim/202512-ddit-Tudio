<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<div class="chat-widget">
    <div class="chat-header">
        <h2>채팅</h2>
        <div class="header-actions">
            <button class="header-btn" aria-label="검색" 
            		id= "openSearchBtn"
                    data-tooltip="대화방 검색">
                <i data-feather="search" style="width:20px; height:20px;"></i>
            </button>
            
        </div>
    </div>

    <div class="chat-tabs-container">
        <div class="chat-tabs">
            <button class="tab active" id="all">전체</button>
            <button class="tab" id="one">1:1 채팅</button>
            <button class="tab" id="group">그룹 채팅</button>
        </div>
    </div>

    <ul class="chat-list">
        <c:forEach items="${chatroomList }" var="chatroom">
            <li class="chat-item" data-type="${chatroom.chatroomType }">
                <input type="hidden" id="chatroomNo" value="${chatroom.chatroomNo }">
                <div class="avatar-container">
                    <div class="avatar" style="background-color: #ff3b30; color: white;">
                        ${fn:substring(chatroom.chatroomName, 0, 1) }
                    </div>
                </div>
                <div class="chat-content">
                    <div class="chat-title-row">
                        <span class="chat-title">
                            <span class="name-text">
                            	${not empty chatroom.chatroomName ? chatroom.chatroomName : 'null'}
                           	</span>
                            <c:if test="${chatroom.memCount > 2 }">
                                <span class="count">(${chatroom.memCount })</span>
                            </c:if>
                        </span>
                        <span class="chat-time">
                            ${chatroom.fmtLastChatDate }
                        </span>
                    </div>
                    <div class="chat-preview-row">
                        <p class="chat-preview">
                            ${chatroom.lastChat }
                        </p>
                        <c:if test="${chatroom.notReadCnt > 0}">
                            <span class="room-badge">
                                ${chatroom.notReadCnt }
                            </span>
                        </c:if>
                    </div>
                </div>
            </li>
        </c:forEach>
    </ul>

    <button class="new-chat-btn">
        <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
        <span>새 채팅</span>
    </button>
</div>

<script>
$(function(){

    // 초기 로딩 시 아이콘 렌더링
    feather.replace();

    let avatars = $(".avatar");
    
    const bgColors = [
        '#007aff', '#ff3b30', '#34c759', '#5856d6', '#ff9500', 
        '#af52de', '#ff2d55', '#5ac8fa', '#ffcc00', '#8e8e93'
    ];
    
    $(avatars).each(function(index, avatar){
        $(avatar).css("background-color", bgColors[index % 10]);
    })
    
    let $chatrooms = $(".chat-item");
    
    $(".tab").on("click", function(){
        $(".tab").removeClass("active");
        $(this).addClass("active");

        $chatrooms.hide();
        
        let tabId = $(this).attr("id")
        if(tabId == "one"){
            $chatrooms.filter(function(index, chatroom){
                return $(chatroom).data("type") == "PRIVATE"
            }).show();
        }else if(tabId == "group"){
            $chatrooms.filter(function(index, chatroom){
                return $(chatroom).data("type") == "GROUP"
            }).show();
        }else if(tabId == "all"){
            $chatrooms.show();
        }
    })
    
    // header의 검색 버튼 클릭 시
    $("#openSearchBtn").on("click", function(){
    	if($(".chat-widget").find(".search-area").length < 1){
	    	$(".chat-header").after(`
	   			<div class="search-area" style="padding-top: 0px">
	    	        <div class="search-input-wrapper">
	    	            <i data-feather="search" class="search-icon" style="width: 18px; height: 18px;"></i>
	    	            <input type="text" class="search-input" placeholder="이름, 부서 검색">
	    	        </div>
	    	    </div>		
			`);
	    	feather.replace();
    	}else{
    		$(".search-area").remove();
    	}
    })
    
    $(".chat-widget").on("input", ".search-input", function(){
    	// TODO : 검색 기능 구현 ㄱㄱ
		/*
    	$.ajax({
			url: "",
			type: "get",
			data: {
				chatroomName : ""
			},
			success: function(result){
				console.log(result);
				let listHtml = "";
				
				$(".chat-list").html(); 
			},
			error: function(error, status, thrown){
				console.log(error);
				console.log(status);
				console.log(thrown);
			}
		})
		*/
    })
})
</script>