<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>

<div class="chat-widget">

    <header class="chat-room-header">
        <div class="header-left">
            <button id="backBtn" class="header-btn" aria-label="뒤로 가기" 
                    data-tooltip="뒤로 가기" data-tooltip-pos="left">
                <i data-feather="chevron-left"></i>
            </button>
        </div>

        <h2 class="room-title">
            <span class="room-name-text">AI 튜디오 비서</span>
            <div class="powered-by">
		        Powered by <span class="vertex-text">Vertex AI</span> <span class="gemini-text">Gemini</span>
		    </div>
        </h2>
        
        <div class="header-right">
            <button id="settingBtn" class="header-btn" aria-label="설정" data-tooltip="설정">
		        <i data-feather="more-vertical" style="width:20px; height:20px;"></i>
		    </button>
		
            <div id="settingMenu" class="chat-dropdown-menu" >
		        <ul>
		            <li><a href="#">알림 끄기</a></li>
		            <li class="danger"><a href="#">대화 내용 삭제</a></li>
		        </ul>
		    </div>
        </div>
    </header>

    <main class="chat-room-content">

        <div class="message-row received">
            <div class="default-avatar" style="background-color: var(--primary-color); color: white;">
                <i class="bi bi-robot" style="font-size: 1.1rem;"></i>
            </div>

            <div class="message-content">
                <span class="sender-name">AI 비서</span>
                <div class="bubble-container">
                    <div class="message-bubble">안녕하세요! Tudio AI 비서입니다. 🤖<br>일정 관리나 프로젝트 진행 상황에 대해 궁금한 점이 있으신가요?</div>
                </div>
            </div>
        </div>

        

    </main>

    <footer class="chat-input-area">
        <button class="footer-btn attach-btn" aria-label="파일 첨부" 
                data-tooltip="파일 첨부" data-tooltip-pos="left">
            <i data-feather="plus" width="24" height="24"></i>
        </button>
        
        <div class="input-wrapper">
            <textarea class="chat-input" placeholder="AI에게 무엇이든 물어보세요..." rows="1"></textarea>
        </div>

        <button class="footer-btn send-btn" aria-label="전송" 
                data-tooltip="전송" data-tooltip-pos="right">
            <i data-feather="send" width="18" height="18"></i>
        </button>
    </footer>
    
</div>

<style>
    /* 타이핑 인디케이터 애니메이션 */
    @keyframes blink {
        0% { opacity: 0.2; transform: scale(0.8); }
        50% { opacity: 1; transform: scale(1); }
        100% { opacity: 0.2; transform: scale(0.8); }
    }

    /* ----------------------------------------------------
       마크다운 스타일링 (채팅 말풍선 내부 여백 제거용)
       ---------------------------------------------------- */
    .message-bubble.markdown-body {
        line-height: 1.6;
    }

    /* 1. 말풍선 안의 '모든 요소' 중 가장 마지막 놈은 마진 제거 */
    .message-bubble.markdown-body > *:last-child {
        margin-bottom: 0 !important;
    }
    
    /* 2. [추가] 혹시라도 생긴 빈 문단(<p></p>)은 아예 숨김 처리 */
    .message-bubble.markdown-body p:empty {
        display: none;
    }

    /* 문단(p) 태그 기본 마진 설정 */
    .message-bubble.markdown-body p {
        margin: 0 0 8px 0; 
    }

    /* 제목 스타일 */
    .message-bubble.markdown-body h1, 
    .message-bubble.markdown-body h2, 
    .message-bubble.markdown-body h3 {
        font-size: 1.1em;
        font-weight: bold;
        margin-top: 10px;
        margin-bottom: 5px;
        border-bottom: 1px solid rgba(0,0,0,0.1);
        padding-bottom: 3px;
    }

    /* 리스트 스타일 */
    .message-bubble.markdown-body ul, 
    .message-bubble.markdown-body ol {
        margin: 5px 0;
        padding-left: 20px;
    }

    .message-bubble.markdown-body li {
        margin-bottom: 3px;
    }

    /* 강조(Bold) 색상 */
    .message-bubble.markdown-body strong {
        color: #0056b3; 
    }
    /* [CSS] style 태그 안에 추가 */

	/* 기존 room-title 정렬 수정 (가운데 정렬 유지하면서 세로 배치) */
	.room-title {
	    display: flex;
	    flex-direction: column;
	    align-items: center;
	    justify-content: center;
	    line-height: 1.2; /* 줄 간격 좁게 */
	}
	
	/* 새로 추가된 Powered by 텍스트 스타일 */
	.powered-by {
	    font-size: 0.65rem; /* 아주 작고 귀엽게 */
	    color: #888;       /* 은은한 회색 */
	    font-weight: 400;
	    margin-top: 2px;
	    letter-spacing: 0.5px;
	}
	
	/* Vertex AI (구글 클라우드 블루) */
	.vertex-text {
	    color: #4285F4; 
	    font-weight: 600;
	}
	
	/* Gemini (제미나이 그라데이션 느낌의 보라색) */
	.gemini-text {
	    background: linear-gradient(90deg, #4E87F3, #9A66F1);
	    -webkit-background-clip: text;
	    -webkit-text-fill-color: transparent; /* 글자에만 그라데이션 적용 */
	    font-weight: 700;
	}
</style>

<script>
$(function(){
    // 1. 아이콘 렌더링 (Feather Icons)
    feather.replace();

    // 2. 스크롤 맨 아래로 이동 함수
    const $chatContent = $('.chat-room-content');
    function scrollToBottom() {
        $chatContent.scrollTop($chatContent[0].scrollHeight);
    }
    
    // 초기 로딩 시 스크롤 이동
    if($chatContent.length > 0) {
        scrollToBottom();
    }

    // 3. 텍스트 입력창 자동 높이 조절
    const textarea = $('.chat-input');
    function adjustHeight() {
        textarea.css('height', 'auto'); 
        let newHeight = textarea[0].scrollHeight;
        if (newHeight > 120) {
            textarea.css("overflow-y", "auto");  
        } else {
            textarea.css("overflow-y", "hidden"); 
        }
        if(newHeight < 36) newHeight = 36;
        textarea.css('height', newHeight + 'px');
    }

    textarea.on('input', adjustHeight);
    textarea.on('keydown', function(e) {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            let msg = $(this).val();
            if(msg.trim() !== "") {
                $(this).val('');
                adjustHeight();
                appendUserMessage(msg); // 내 메시지 먼저 추가
                sendMessage(msg);       // 서버 전송
            }
        }
    });
    
    // 전송 버튼 클릭
    $(".send-btn").on("click", function(){
        if(textarea.length > 0){
            let msg = textarea.val();
            if(msg.trim() === "") return;
            textarea.val('');
            adjustHeight();
            appendUserMessage(msg);
            sendMessage(msg);
        }
    });
    
    // [기능 1] 사용자 메시지 추가 함수
    function appendUserMessage(msg) {
        msg = msg.replace(/\n/g, '<br>');
        
        let html = `
            <div class="message-row sent">
                <div class="bubble-container">
                    <div class="message-bubble">\${msg}</div>
                </div>
            </div>
        `;
        $chatContent.append(html);
        scrollToBottom();
    }

    // [기능 2] 로딩 아이콘(버퍼링) 표시 함수 (여기 아이콘 변경됨!)
    function showLoading() {
        let loadingId = "loading-" + Date.now();
        let html = `
            <div class="message-row received" id="\${loadingId}">
                <div class="default-avatar" style="background-color: var(--primary-color); color: white;">
                    <i class="bi bi-robot" style="font-size: 1.1rem;"></i>
                </div>
                <div class="message-content">
                    <span class="sender-name">AI 비서</span>
                    <div class="bubble-container">
                        <div class="message-bubble">
                           <span style="display: inline-flex; gap: 4px; align-items: center;">
                               <span style="width: 6px; height: 6px; background: #ccc; border-radius: 50%; animation: blink 1s infinite 0s;"></span>
                               <span style="width: 6px; height: 6px; background: #ccc; border-radius: 50%; animation: blink 1s infinite 0.2s;"></span>
                               <span style="width: 6px; height: 6px; background: #ccc; border-radius: 50%; animation: blink 1s infinite 0.4s;"></span>
                           </span>
                        </div>
                    </div>
                </div>
            </div>
        `;
        $chatContent.append(html);
        scrollToBottom();
        return loadingId;
    }

    // [기능 3] AI 메시지 추가 함수 (여기 아이콘 변경됨!)
    // [기능 3] AI 메시지 추가 함수 (마크다운 적용 버전)
	function appendAiMessage(msg) {
	    
	    // 1. 마크다운을 HTML로 변환 (marked 라이브러리 사용)
	    // breaks: true 옵션은 엔터키를 <br>로 인식하게 해줍니다.
	    let parsedHtml = marked.parse(msg.trim(), { breaks: true });
	
	    let html = `
	        <div class="message-row received">
	            <div class="default-avatar" style="background-color: var(--primary-color); color: white;">
	                <i class="bi bi-robot" style="font-size: 1.1rem;"></i>
	            </div>
	            <div class="message-content">
	                <span class="sender-name">AI 비서</span>
	                <div class="bubble-container">
	                    <div class="message-bubble markdown-body">\${parsedHtml}</div>
	                </div>
	            </div>
	        </div>
	    `;
	    $chatContent.append(html);
	    scrollToBottom();
	}
    
    // AJAX 전송 로직
    function sendMessage(msg){
        
        // 1. 요청 전 로딩 아이콘 띄우기
        let loadingId = showLoading();

    	$.ajax({
    		url: "/tudio/bot/ask",
    		type: "get",
    		contentType : "application/json;charset=utf-8",
    		data: {
    			message: msg
    		},
    		success: function(result){
                // 2. 성공 시 로딩 아이콘 삭제
                $("#" + loadingId).remove();
                
                if(result.type == "COMMAND"){
                	localStorage.setItem("AIData", JSON.stringify(result));
                	$(location).attr("href", result.targetUrl);
                }else if(result.type == "TALK"){
    				appendAiMessage(result.message);
                }
                console.log(result);
    		},
    		error: function(error, status, thrown){
    			console.log(error);
                $("#" + loadingId).remove();
                appendAiMessage("죄송합니다. 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
    		}
    	})
    }

    // 설정 메뉴 및 뒤로 가기 로직은 그대로 유지
    $("#settingBtn").on("click", function(e){
        e.stopPropagation();
        $(this).toggleClass("active");
        $("#settingMenu").toggleClass("active");		
    });

    $(document).off("click").on("click", function(){
        $("#settingMenu").removeClass("active");		
        $("#settingBtn").removeClass("active");		
    });

    $("#backBtn").on("click", function(){
        if(typeof $container !== 'undefined'){
            $container.load("/tudio/chat/list", function(){
                feather.replace();
            });
        } else {
            console.log("뒤로가기 클릭 (컨테이너 못찾음)");
        }
    });
});
</script>