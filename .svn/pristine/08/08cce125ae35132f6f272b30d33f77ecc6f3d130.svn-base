<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    <script src="https://unpkg.com/feather-icons"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@stomp/stompjs@7.0.0/bundles/stomp.umd.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/locale/ko.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/fonts/pretendard/pretendard.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/chat/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/chat/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/chat/list.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/chat/chatroom.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/chat/new.css">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/chat/memList.css">
	

<div class="floating-chat-container">
    <div class="chatbot-wrapper" id="chatbotBtnWrapper">
        <button class="chatbot-floating-btn" aria-label="AI 챗봇 열기">
			<i class="bi bi-robot" style="font-size: 1.1rem;"></i>
        </button>
    </div>

    <div id="chatListContainer" class="chat-list-box"></div>

    <button class="floating-chat-btn" aria-label="채팅 목록 열기">
        <div class="icon-wrapper">
            <i data-feather="message-circle"></i>
        </div>
        <span class="notification-badge"></span>
    </button>
</div>

<script>
	// 전역 소켓 클라이언트 생성
	window.chatSocketClient = new StompJs.Client({
		webSocketFactory: () => new SockJS(
			window.location.protocol + "//"+ window.location.host+"/ws-stomp"),
        reconnectDelay: 5000,	// 5초마다 재연결
        heartbeatIncoming: 10000, 	// 서버와 10초마다 핑 주고받음
        heartbeatOutgoing: 10000
 	});
	
	// 현재 구독 객체 관리
	window.alwaysSubscription = null;
	window.roomSubscription = null;

	// 플로팅 버튼 뱃지에 뜨는 안읽은 전체 채팅 개수
	window.allNotReadCnt = 0;
    let isOpen = false;
    let $container = null;
    const loginMemberNo = "${sessionScope.loginUser.memberNo}";
    
    $(function(){
    	let floatBtnBadge= $(".notification-badge");
    	
    	// 로그인 유저의 전체 안읽은 채팅 개수 구하기
    	$.ajax({
    		url: "/tudio/chat/allNotReadCnt",
    		type: "get",
    		success: function(result){
    			allNotReadCnt = result;
   				floatBtnBadge.toggle(allNotReadCnt > 0);
   				floatBtnBadge.text(allNotReadCnt);
			},
	    	error: function(error, status, thrown){
				console.log(error);
				console.log(status);
				console.log(thrown);
			}
    	})
    	
		// 소켓 연결시 수행할 작업 정의
		window.chatSocketClient.onConnect = function(frame){
    		
			let subUrl = "/sub/newChat/alarm/" + loginMemberNo;
			alwaysSubscription = chatSocketClient.subscribe(subUrl, function(message){
				
				let chatInfo = JSON.parse(message.body);
				console.log(chatInfo);
				
				// 채팅 플로팅 버튼의 뱃지(안읽은 채팅수) 실시간 변경
				if(chatInfo.memberNo != loginMemberNo){
	   				allNotReadCnt++;
				}
   				floatBtnBadge.text(allNotReadCnt);
   				floatBtnBadge.toggle(allNotReadCnt > 0);
				
				// 채팅방 목록창 실시간 변경
				if($(".chat-list").length > 0){
					const chatItems = $(".chat-item"); 
    				
					chatItems.each(function(index, item){
	    				let roomBadge = $(item).find(".room-badge");
	    				
	    				// 목록에서 새 채팅이 온 채팅방을 찾기
		    			if($(item).children("#chatroomNo").val() == chatInfo.chatroomNo){
		    				// 채팅방의 마지막 메세지와 전송 시간을 변경
		    				$(item).find(".chat-preview").text(chatInfo.message);
		    				$(item).find(".chat-time").text(chatInfo.fmtCreateDate);
		    				
		    				// 채팅방에 뱃지(안읽은 채팅수)가 존재한다면 기본값+1
		    				if(roomBadge.length > 0){
			    				roomBadge.text(parseInt(roomBadge.text()) + 1);
		    				}else{	// 없다면 뱃지를 새로 만들어서 붙여줌
		    					$(item).find(".chat-preview-row").append(`
	    							<span class="room-badge">
		                                1
		                            </span>
    							`);
		    				}
		    				
		    				// 채팅이 온 채팅방을 최상단으로 올리기
							$(item).prependTo($(".chat-list"));
		    			}
		    		})
		    		
    				// 채팅 플로팅 버튼이 X 아이콘 상태가 아니라면 뱃지가 보이도록 
	    			if($(".feather-x") != undefined){
	    				floatBtnBadge.toggle(allNotReadCnt > 0);
	    			}
				}
			});
		}
		
		// 소켓 연결
		chatSocketClient.activate();
		
		// (자식이 호출해서 사용) 채팅방 나갈 때 호출
		window.disconnectChatroom = function(){
			if(window.roomSubscription != null){
				window.roomSubscription.unsubscribe();	
				window.roomSubscription = null;
			}
		}
		
		// (자식이 호출해서 사용) 채팅방 진입시 채팅방 구독 처리
		window.connectChatroom = function(chatroomNo, callbackFn){
			// 다른 방에 구독되어있다면, 구독 끊기
			disconnectChatroom();
			
			// 현재 진입한 방 구독
			window.roomSubscription = window.chatSocketClient.subscribe(
				"/sub/chat/chatroom/"+ chatroomNo,
				callbackFn
			);
		}
		
	    // 페이지 로드 시 아이콘 렌더링
        feather.replace(); 
    	
        $container = $("#chatListContainer"); 
        $footer = $(".footer");
        defaultBottom = parseInt($(".floating-chat-container").css("bottom"));
        
        // 스크롤을 내리거나 브라우저 사이즈가 변경될 때 실행
        $(window).on("scroll resize", function(){
        	let scrollTop = $(window).scrollTop();
        	let innerHeight = $(window).innerHeight();
        	let scrollBottom = scrollTop + innerHeight
        	
        	let finalBottom = defaultBottom;
        	
        	if ($footer.length > 0 && $footer.offset()) {
                let footerTop = $footer.offset().top;
                
                // 사용자의 스크롤 하단이 footer 상단 아래까지 내려왔을 때
                if(scrollBottom >= footerTop){
                    let overlapHeight = scrollBottom - footerTop;
                    finalBottom = defaultBottom + overlapHeight;
                }
            }
            
            $(".floating-chat-container").css('bottom', finalBottom + 'px');
        })
        
        // [수정] 챗봇 버튼 클릭 이벤트
		$(".chatbot-floating-btn").on("click", function(){
		    console.log("챗봇 실행");
		
		    // 1. 챗봇 JSP 로드 (내용 교체)
		    $container.load("/tudio/bot/chat", function(){
		        feather.replace(); // 로드된 내부 아이콘 렌더링
		    });
		    
		    // 2. [핵심] 숨겨져 있던 채팅 박스 강제로 열기
		    $container.addClass("active");
		    
		    // 3. 메인 플로팅 버튼의 상태를 '열림(X)' 상태로 강제 변경
		    // (그래야 나중에 메인 버튼 눌렀을 때 자연스럽게 닫힘)
		    const $mainBtn = $(".floating-chat-btn");
		    const $iconWrapper = $mainBtn.find(".icon-wrapper");
		    const $badge = $mainBtn.find(".notification-badge");
		    const $chatbotWrapper = $("#chatbotBtnWrapper");
		
		    $mainBtn.addClass("opened");
		    $iconWrapper.html('<i data-feather="x"></i>'); // 아이콘을 X로 변경
		    $badge.css('transform', 'scale(0)'); // 뱃지 숨김
		    
		    // 4. 챗봇 버튼 스스로는 숨기기 (디자인적 선택)
		    $chatbotWrapper.addClass("hidden");
		
		    // 5. 상태 변수 업데이트
		    isOpen = true;
		    
		    // 아이콘 갱신
		    feather.replace(); 
		});
        
        // 채팅 플로팅 버튼을 클릭했을 경우 
        $(".floating-chat-btn").on("click", function(){
            const $btn = $(this);
            const $iconWrapper = $btn.find(".icon-wrapper");
            const $badge = $btn.find(".notification-badge");
            
            const $chatbotWrapper = $("#chatbotBtnWrapper"); // [추가]
            
            $container.toggleClass("active");
            $btn.toggleClass("opened");
            
            isOpen = !isOpen;
            
            if(isOpen){
            	// [추가] 채팅창이 열리면 챗봇 버튼은 숨긴다 (깔끔함 유지)
                $chatbotWrapper.addClass("hidden");
            	
                $container.load("/tudio/chat/list", function(){
                    feather.replace(); 
                });
                
                // 버튼을 X 아이콘으로 교체 
                $iconWrapper.html('<i data-feather="x"></i>');
                
                $badge.css('transform', 'scale(0)'); 
                $badge.css('transition', 'transform 0.2s');
                
            } else {
            	// [추가] 채팅창이 닫히면 챗봇 버튼 다시 등장
                $chatbotWrapper.removeClass("hidden");
            	
                // 버튼을 채팅 아이콘으로 교체 
                $iconWrapper.html('<i data-feather="message-circle"></i>');
                
                $badge.css('transform', 'scale(1)');
            }
            feather.replace(); 
        });
        
        // 채팅방 목록에서 특정 채팅방을 클릭할 경우
        $container.on("click", ".chat-item", function(){
        	allNotReadCnt -= parseInt($(".chat-item").find(".room-badge").text())
        	floatBtnBadge.toggle(allNotReadCnt > 0);
        	floatBtnBadge.text(allNotReadCnt);
        	
            let roomNo = $(this).find("#chatroomNo").val();
            $container.load("/tudio/chat/chatroom/" + roomNo, function(){
                feather.replace();
            });
        });
        
        // 채팅방 목록에서 새채팅 버튼을 클릭할 경우
        $container.on("click", ".new-chat-btn", function(){
            $container.load("/tudio/chat/new");
        });
        
    })
</script>
</body>
</html>