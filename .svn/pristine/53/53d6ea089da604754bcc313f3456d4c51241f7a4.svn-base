/**
 * chatroom.js
 * 채팅방 내부 페이지 관련 로직
 */

$(function(){
	
	let currentOnlineMemCnt = 0;
	
	// [함수 정의]
	// - 채팅 메세지 div 생성하는 함수
	// 채팅 내용 HTML 생성기 (이미지/파일/텍스트 분기 처리)
	function getMessageContentHtml(chat) {
	    let contentHtml = "";
		let contextPath = window.contextPath || ""; 

	    // 이미지인 경우
	    if (chat.chatType === "IMAGE") {
			let imgUrl = `${contextPath}/upload/chat/${chat.file.fileSaveName}`;
	        contentHtml = `
	            <div class="message-media-image" onclick="window.open('${imgUrl}')" style="width: 180px;">
	                <img src="${imgUrl}" onerror="this.src='${contextPath}/resources/img/no_img.png'">
	            </div>
	        `;
	    } 
	    // 파일인 경우
	    else if (chat.chatType === "FILE") {
			let downloadUrl = `${contextPath}/tudio/chat/download?fileNo=${chat.fileAttachNo}`;
			// 파일명이 없을 경우 대비
			let fileName = chat.file.fileOriginalName || "파일";
			
	        contentHtml = `
	            <div class="message-bubble file-type">
	                <div class="file-attachment-card" onclick="location.href='${downloadUrl}'" style="cursor:pointer;">
	                    <div class="file-icon-box">
	                        <i data-feather="file-text" style="width:18px; height:18px;"></i>
	                    </div>
	                    <div class="file-info-area">
	                        <span class="file-name">${fileName}</span>
	                        <span class="file-size">${chat.file.fileFancysize}</span> 
	                    </div>
	                </div>
	            </div>
	        `;
	    } 
	    // 일반 텍스트인 경우
	    else {
	        contentHtml = `<div class="message-bubble">${chat.message}</div>`;
	    }
	    
	    return contentHtml;
	}

	// 날짜 알림 div 만들어주는 함수
	function createDateNoti(date){
		moment.locale("ko");
		let fmtDate = moment(date).format("LL dddd");
		
		dateDiv = `
			<div class="system-message-container">
	            <span class="system-message">
	            	${fmtDate}
	            </span>
	        </div>
		`;
		
		return dateDiv;
	}

	// 시스템 메시지 div 만들어주는 함수
	function createSystemNoti(chat){
		let chatHtml = `
	    	<div class="system-message-container" id="chat${chat.chatNo}">
	    		<span class="system-message">
	    			${chat.message }
	   			</span>
			</div>
		`;
		
	    return chatHtml;
	}


	// 내가 보낸 메세지 div 만들어주는 함수
	function createMyChat(chat){
		let chatHtml = "";
		let contentHtml = getMessageContentHtml(chat);
		
		chatHtml += `
	    	<div class="message-row sent" id="chat${chat.chatNo}">
	    		<div class="bubble-container">
	    			<div class="sent-info">
	   	`;
	    if(chat.notReadCnt != 0){ // 해당 채팅을 안읽은 사람이 있다면
	    	chatHtml += `
	                	<span class="unread-count">
	                		${chat.notReadCnt }
	                	</span>
	    	`;
	    }
	    chatHtml += `
	                	<span class="message-time">
	                   		${chat.fmtCreateDate }
	                    </span>
	                </div>
	                ${contentHtml}
	            </div>
	        </div>
	    `;
	    
	    return chatHtml;
	}

	// 상대방이 보낸 메세지 div 만들어주는 함수
	function createOtherChat(chat){
		let chatHtml = "";
		let profileHtml = "";
		let contentHtml = getMessageContentHtml(chat);
	    
	    if(chat.memberProfileimg != null && chat.memberProfileimg != "") {
	        profileHtml = `<img src="${chat.memberProfileimg}" class="profile-img">`;
	    } else {
	        let colorIndex = chat.memberNo % 5;
	        profileHtml = `
	            <div class="default-avatar avatar-color-${colorIndex}">
	     			<i data-feather="user" style="width:20px; height:20px;"></i>
	            </div>
	        `;
	    }
	    
	    chatHtml += `
	        <div class="message-row received" id="chat${chat.chatNo}">
	        	${profileHtml}	
	        	<div class="message-content">
	        		<span class="sender-name">
	        			${chat.memberName }
	        		</span>
	        		<div class="bubble-container">
	        			${contentHtml}
	        			<div class="received-info">
	    `;
	    if(chat.notReadCnt != 0) chatHtml += `<span class="unread-count">${chat.notReadCnt }</span>`;
		
	    chatHtml += `
	                    	<span class="message-time">
	                        	${chat.fmtCreateDate }
	                        </span>
	            		</div>
	            	</div>
	        	</div>
	        </div>
	    `;
	    
	    return chatHtml;
	}

	// - 메세지 전송 함수
	function sendMessage(message){
		chatSocketClient.publish({
	 		destination: "/pub/chat/message",
	 		body: JSON.stringify({
	 			chatroomNo: chatroomNo,
	 			memberNo : myMemNo,
	 			memberName : myName,
	 			memberProfileimg : myProfileimg,
				message : message,
				createDate : Date.now(),
				chatType: "TEXT"			
	 		})
	 	})
		
		textarea.val('');
		textarea.css("height", 'auto'); 
	    adjustHeight(); 
	}	

	// - 커스텀 sweetAlert 
	// 채팅방 나가는 여부를 물어보는 sweetAlert
	let savedScrollY = 0;
	function sweetAlert(){
		savedScrollY = window.scrollY;
		
		Swal.fire({
	        title: "정말로 채팅방을<br>나가시겠습니까?", 
	        target: document.querySelector('.chat-widget'),
	        width: 280,         
	        padding: 0,             
	        showCancelButton: true,
	        cancelButtonText: '취소',
	        confirmButtonText: '나가기', 
	        reverseButtons: true,   
	        buttonsStyling: false, 
			backdrop: false,        
			scrollbarPadding: false,
			heightAuto: false,
	        customClass: {
	        	container: 'my-swal-container',
	            popup: 'my-swal-popup',
	            title: 'my-mini-title',
	            htmlContainer: 'my-mini-content', 
	            input: 'my-swal-input',
	            actions: 'my-swal-actions',
	            confirmButton: 'my-mini-btn my-danger-btn', 
	            cancelButton: 'my-mini-btn my-cancel-btn',   
	            validationMessage: 'my-validation-msg'
	        },
			didOpen: () => {
				window.scrollTo(0, savedScrollY);
			},
			willClose: () => {
				window.scrollTo(0, savedScrollY);
			},
		    preConfirm: () => {
		    	const deleteInfo = {
		    		chatroomNo : chatroomNo,
					memCount: memCount,
		    		memberNo : myMemNo,
		    		memberName : myName
		    	};
		    	
		    	return $.ajax({
		    		url: "/tudio/chat/chatroom/exit",
		    		type: "post", 
		    		contentType: "application/json;charset=utf-8",
		    		data: JSON.stringify(deleteInfo),
		    		error: function(error, status, thrown){
		    			console.log(error);
		    			console.log(status);
		    			console.log(thrown);
		    		}
		    	})  
		    }
	    }).then((response) => {
	        if (response.isConfirmed) {
	        	if(response.value == "OK"){
		        	$container.load("/tudio/chat/list", function(){
		                feather.replace();
		            });
	        	} else{
	        		Swal.fire({
	                    title: '채팅방 나가기 실패',
	                    text: '잠시 후 다시 시도해주세요.',
	                    
	                    target: document.querySelector('.chat-widget'),
	                    width: 280,
	                    padding: 0,
	                    
	                    // 확인 버튼 하나만 띄움
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

	// 웹소켓을 통해 받은 메세지 처리하는 함수
	const onMessageReceived = function(message){
		let chat = JSON.parse(message.body);
		const $nowChatContent = $('.chat-room-content');
		// TODO: 날짜 바뀔 경우를 대비해 날짜 알림 띄우는 로직 추가
		
		if(isEmptyChat == 'true'){
			$nowChatContent.append(createDateNoti(new Date));
			isEmptyChat = false;
		}
		
		if(chat.chatType == "SYSTEM"){
			$nowChatContent.append(createSystemNoti(chat));
		}else if(chat.chatType == "ENTRY" || chat.chatType == "EXIT"){ // 누군가가 채팅방에 입장
			currentOnlineMemCnt = chat.currentOnlineCnt;
			if(chat.chatType == "ENTRY"){
				$(".message-row").each(function(index, message){
					if($(message).attr("id").slice(4) > chat.lastReadChatNo){
						console.log($(message).attr("id").slice(4), "|", chat.lastReadChatNo);
						let $unreadSpan = $(message).find(".unread-count");
						$unreadSpan.text($unreadSpan.text() - 1 <= 0 ? "" :$unreadSpan.text() -1);
					}
				})
			}
			console.log("현재 접속인원 : " + currentOnlineMemCnt);
		}else if(chat.memberNo == myMemNo){
			let notRead =  window.memCount - currentOnlineMemCnt;
			chat.notReadCnt = notRead <= 0 ? '' : notRead;
			$nowChatContent.append(createMyChat(chat));
		}else if(chat.memberNo != myMemNo){
			let notRead =  window.memCount - currentOnlineMemCnt;
			chat.notReadCnt = notRead <= 0 ? '' : notRead;
			$nowChatContent.append(createOtherChat(chat));
		}
		
		
		feather.replace();
		$nowChatContent.scrollTop($nowChatContent[0].scrollHeight);
	}

	//////////////////////////////////////////////////////////
	// 채팅방 진입 시, 구독
	if(window.chatSocketClient && window.chatSocketClient.connected){
		window.connectChatroom(chatroomNo, onMessageReceived);
	}
	
	//////////////////////////////////////////////////////////////
	// [디자인적 요소를 위한 스크립트 부분]
	// 아이콘 렌더링
	feather.replace();
	
	// 스크롤을 맨 아래로 내려줌
	const $chatContent = $('.chat-room-content');
	const textarea = $('.chat-input');

	if($chatContent.length > 0) {
		$chatContent.scrollTop($chatContent[0].scrollHeight);
	}

	// textarea 높이 조절 및 스크롤바 제어 함수
	function adjustHeight() {
	    // 1. 높이를 초기화해야 줄어들었을 때를 감지함
	    textarea.css('height', 'auto'); 
	    
	    // 2. 현재 글자 높이 계산
	    let newHeight = textarea[0].scrollHeight;
	    
	    // 3. 120px(CSS max-height)를 넘어가면 스크롤바 켜기, 아니면 끄기
	    if (newHeight > 120) {
			textarea.css("padding-right", "0px");
	        textarea.css("overflow-y", "auto");  
	    } else {
	        textarea.css("overflow-y", "hidden"); 
			textarea.css("padding-right", "12px");
	    }
	    
	    // 4. 최소 높이 보정 
	    if(newHeight < 36) newHeight = 36;
	    
	    // 5. 높이 적용
	    textarea.css('height', newHeight + 'px');
	}

	//////////////////////////////////////////////////////////////
	// textarea에 내용을 작성 후, enter 키를 누르면 실행됨
	if(textarea.length > 0){
	    textarea.on('input', adjustHeight);
	    textarea.on('keydown', function(e) {
	        if (e.key === 'Enter' && !e.shiftKey) {
	            e.preventDefault();
	            let msg = $(this).val()
	            if(msg.trim() === "") return;

	            sendMessage(msg);
	        } 
	    });
	    
	    adjustHeight();
	}
	
	// 설정 버튼을 눌렀을 경우
	$("#settingBtn").on("click", function(e){
		e.stopPropagation();
		
		$(this).toggleClass("active");
		$("#settingMenu").toggleClass("active");		
	})

	// 화면의 빈 곳을 클릭했을 시, 설정의 메뉴창이 닫히도록 
	$(document).off("click").on("click", function(){
		$("#settingMenu").removeClass("active");		
		$("#settingBtn").removeClass("active");		
	}) 	

	// 채팅방 나가기 항목을 클릭했을 경우
	$("#menuExit").on("click", function(){
		sweetAlert();
	})

	// 파일 첨부 버튼을 눌렀을 경우
	$(".attach-btn").on("click", function(){
		const inputFile = $(".input-file");
		inputFile.click();
		inputFile.off("change").on("change", function(){
			let formData = new FormData();
			let $files = $(this.files);
			$files.each(function(index, file){
				formData.append("fileList", file);
			})
			
			$.ajax({
				url: "/tudio/chat/file/upload",
				type: "post",
				contentType: false,
				processData: false,
				data: formData,
				success: function(result){
					let message = "";
					let chatType = "";
					
					$.each(result, function(index, fileDetail){
						console.log(fileDetail)
						if(fileDetail.fileMime.indexOf("image") >= 0){
							message = "사진을 보냈습니다.";
							chatType = "IMAGE";
						}else{
							message = "파일: " + fileDetail.fileOriginalName ; 
							chatType = "FILE";
						}
						
						let file = {
							fileOriginalName: fileDetail.fileOriginalName,
							fileSaveName : fileDetail.fileSaveName,
							fileFancysize: fileDetail.fileFancysize
						}
						
						chatSocketClient.publish({
					 		destination: "/pub/chat/message",
					 		body: JSON.stringify({
					 			chatroomNo: chatroomNo,
					 			memberNo : myMemNo,
					 			memberName : myName,
					 			memberProfileimg : myProfileimg,
								message : message,
								createDate : Date.now(),
								fileAttachNo : fileDetail.fileNo,
								file: file,
								chatType: chatType			
					 		})
					 	})
					})
				},
				error: function(error, status, thrown){
	    			console.log(error);
	    			console.log(status);
	    			console.log(thrown);
	    		}
			})
		})
	})

	// 전송 버튼을 눌렀을 경우
	$(".send-btn").on("click", function(){
		if(textarea.length > 0){
			let msg = textarea.val();
	        if(msg.trim() === "") return;
	        sendMessage(msg);
		}
	})

	// 뒤로가기 버튼을 클릭할 경우
	$("#backBtn").on("click", function(){
		window.disconnectChatroom();
		
		if($(".message-row:last").attr("id") != undefined){
			$.ajax({
				url: "/tudio/chat/update/lastReadChatNo",
				type: "post",
				contentType: "application/json;charset=utf-8",
				data: JSON.stringify({
					chatroomNo: chatroomNo,
					memberNo: myMemNo,
					chatNo: $(".message-row:last").attr("id").slice(4)
				}),
				success: function(result){
					console.log("변경 성공~");
				    $container.load("/tudio/chat/list", function(){
				        feather.replace();
				    });
				},
				error: function(error, status, thrown){
	    			console.log(error);
	    			console.log(status);
	    			console.log(thrown);
	    		}
				
			});
		} else{
			$container.load("/tudio/chat/list", function(){
		        feather.replace();
		    });
		}
		
	});

	// 서버에서 데이터를 가져오는 중인지 판별
	let isLoading = false;

	// ajax 요청을 통해 생성된 div의 첫 채팅 날짜
	let firstChatDate = "";

	 $chatContent.on('scroll', function(){
	    if(isLoading || isEnd) return;
	    
	    let currentScrollTop = $(this).scrollTop();
	    let viewHeight = $(this).innerHeight();
	    
	 	// 사용자가 스크롤 맨 위로 도달하기까지 얼마 안남았다면 실행됨
	    if(currentScrollTop <= viewHeight){
	        isLoading = true;
	        $.ajax({
	            url: "/tudio/chat/chatroom/oldchat",
	            type: "get",
	            contentType : "application/json;charset=utf-8",
	            data: { 
	            	chatroomNo : chatroomNo, 
	            	chatNo : parseInt(lastChatNo) 
	           	},
	            success: function(result){
	                let chatHtml = "";
	             	// forEach에서 현재 index의 바로 직전 ChatDate
	                let preChatDate = "";
	                
	             	// ajax로 불러온 이전 채팅 메세지 목록 html 구조로 변환
	                result.forEach(function(chat, index){
	                    if(index == 0) {
	                    	lastChatNo = chat.chatNo;
	                    	  
	                        if(result.length < 30){
	                        	chatHtml += createDateNoti(chat.createDate);          	
	                           	isEnd = true;
	                        }
	                    }
	                    
	                 	// 동일한 메세지가 있는지 확인 
	   					// (이미 출력한 메세지를 다시 출력하는 불상사를 막기위해)
	                    let idChatNo = "#chat"+chat.chatNo;
	                    if($(idChatNo).length == 0){
	                    	// 날짜 비교를 위해 moment 라이브러리를 사용하여 변수 생성
	                        let mmtPreChatDate = parseInt(moment(preChatDate).format("YYYYMMDD"));
	                        let mmtCurChatDate = parseInt(moment(chat.createDate).format("YYYYMMDD"));
	                        
	                     	// 다음 ajax 요청 실행시, 마지막 채팅과의 날짜 비교를 위해 값 저장
	                        if(index == 0){
	                            firstChatDate = chat.createDate;
	                            mmtPreChatDate = 99999999;
	                        }
	                        
	                     	// 현재 채팅의 날짜가 이전 채팅 날짜 값보다 크다면 실행
	   						// (날짜가 다음날로 변경된 것이므로)
	                        if(mmtCurChatDate > mmtPreChatDate){
	                            chatHtml += createDateNoti(chat.createDate);
	                        }
	                        preChatDate = chat.createDate;
	                        
	                        if(chat.chatType == "SYSTEM"){
	                        	chatHtml += createSystemNoti(chat);
	                        }else if(chat.memberNo == myMemNo){	// 본인이 작성한 메세지라면
	                        	chatHtml += createMyChat(chat);
	                        }else if(chat.memberNo != myMemNo){	// 타인이 작성한 메세지라면
	                        	chatHtml += createOtherChat(chat);
	                        } 

	                        if(index == result.length-1){
	                            let mmtBottomFirstChatDate = parseInt(moment(bottomFirstChatDate).format("YYYYMMDD"));
	                            
	                            if(mmtCurChatDate < mmtBottomFirstChatDate){
	                                chatHtml += createDateNoti(bottomFirstChatDate);
	                            }
	                            bottomFirstChatDate = firstChatDate;
	                        }
	                        
	                        
	                    } // 기존에 없는 채팅인지 확인 if문 끝
	                }) // forEach 끝

	             	// 불러온 메세지들을 기존 메세지의 앞에 붙여줌
	                $chatContent.prepend(chatHtml);

	                feather.replace();
	                isLoading = false;
	            },
	            error: function(error){ 
	           		console.log("error : " + error.status); 
	       		}
	        }) // ajax 끝
	    } // 스크롤 상단 도착 직전 확인 if문 끝
	}) // scroll 이벤트 끝
})