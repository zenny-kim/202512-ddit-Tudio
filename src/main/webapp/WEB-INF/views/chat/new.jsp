<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<script src="${pageContext.request.contextPath}/js/memList.js"></script>

<div class="chat-widget new-chat-container">
    <header class="chat-room-header">
        <div class="header-left">
            <button id="backBtn" class="header-btn" aria-label="뒤로 가기" 
                    data-tooltip="뒤로 가기" data-tooltip-pos="left">
                <i data-feather="arrow-left"></i>
            </button>
        </div>
        <h2 class="room-title">새 채팅</h2>
        <div class="header-right">
            </div>
    </header>

    <jsp:include page="./memList.jsp">
    	<jsp:param name="btnText" value="채팅 시작"/>
    </jsp:include>

</div>

<script>
$(function(){
	
    feather.replace();

    // [함수 정의]
 	// 채팅방 이름 입력받는 sweetAlert
    function sweetAlert(selectData){
    	Swal.fire({
            title: "채팅방 이름 입력", 
            input: "text",
            target: document.querySelector('.new-chat-container'),
            width: "85%",           
            padding: 0,             
            showCancelButton: true,
            cancelButtonText: '취소',
            confirmButtonText: '생성', 
            reverseButtons: true,   
            buttonsStyling: false, 
            backdrop: false,        
            scrollbarPadding: false,
            heightAuto: false,
            inputValue: selectData.chatroomName.join(", "),
            didOpen: () => {
            	Swal.getInput().select();
            },
            customClass: {
                container: 'my-swal-container',
                popup: 'my-swal-popup',
                title: 'my-mini-title',
                input: 'my-swal-input',
                actions: 'my-swal-actions',
                confirmButton: 'my-mini-btn my-confirm-btn', 
                cancelButton: 'my-mini-btn my-cancel-btn',   
                validationMessage: 'my-validation-msg'
            },
            inputValidator: (value) => {
                if(!value){
                    return "채팅방 이름을 입력해주세요.";
                } 
            },
  		    preConfirm: (chatroomName) => {
  		    	let chatroomType = "";
  		    	if(selectData.checkedCount > 1){
  		    		chatroomType = "GROUP"
  		    	}else{
  		    		chatroomType = "PRIVATE"
  		    	}
  		    	
  		    	const chatroomVo = {
  		    		chatroomName : chatroomName,
  		    		chatroomType : chatroomType,
  		    		memCount : (selectData.checkedCount + 1),
  		    		chatMemberNoList : selectData.selectedUserNo,
  		    		chatMemberNameList : selectData.selectedAllUserName
  		    	};
  		    	
  		    	return $.ajax({
  		    		url: "/tudio/chat/new",
  		    		type: "post", 
  		    		contentType: "application/json;charset=utf-8",
  		    		data: JSON.stringify(chatroomVo),
  		    		error: function(error, status, thrown){
  		    			console.log(error);
  		    			console.log(status);
  		    			console.log(thrown);
  		    		}
  		    	})  
  		    }
	    }).then((response) => {
	        if (response.isConfirmed) {
	        	if(response.value.result === "OK"){
		        	$container.load("/tudio/chat/chatroom/" + response.value.chatroomNo, function(){
		                feather.replace();
		            });
	        	} else{
	        		Swal.fire({
	                    title: '채팅방 생성 실패',
	                    text: '채팅방을 만들지 못했습니다.',
	                    
	                    target: document.querySelector('.new-chat-container'),
	                    width: 280,
	                    padding: 0,
	                    
	                    confirmButtonText: '확인',
	                    buttonsStyling: false,
	                    
	                    customClass: {
	                        container: 'my-swal-container',
	                        popup: 'my-swal-popup',
	                        title: 'my-mini-title',
	                        htmlContainer: 'my-mini-content',
	                        confirmButton: 'my-mini-btn my-confirm-btn'
	                    }
	                });
	        	}
	        } 
	    });
    }
    
    MemberSelectList.init("${pageContext.request.contextPath}", "과 채팅 시작", sweetAlert, ".new-chat-container")
});
</script>