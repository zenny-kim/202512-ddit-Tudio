<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tudio - 화상미팅 대기실</title>
    <script src="https://cdn.socket.io/4.7.2/socket.io.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/project_common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/video_chat.css">
    <jsp:include page="/WEB-INF/views/include/common.jsp" />   
    <style>
        .copy-btn-inner { cursor: pointer; transition: 0.2s; }
        .copy-btn-inner:hover { color: #0d6efd !important; }
        .pulse-red { animation: pulse-red-animation 2s infinite; }
        @keyframes pulse-red-animation {
            0% { box-shadow: 0 0 0 0px rgba(220, 53, 69, 0.4); }
            100% { box-shadow: 0 0 0 10px rgba(220, 53, 69, 0); }
        }
    </style>
</head>
<body data-context-path="${pageContext.request.contextPath}" class="d-flex flex-column min-vh-100">
    
    <jsp:include page="../include/headerUser.jsp"/>
    
    <div class="d-flex flex-grow-1">
        <jsp:include page="../include/sidebarUser.jsp">
            <jsp:param name="menu" value="video_chat" />
        </jsp:include>
    
        <main class="main-content-wrap flex-grow-1 px-4 pt-4 pb-5">
            <div class="container-fluid h-100">
                <div class="mb-4">
                    <h3 class="fw-bold text-primary-dark m-0">
                        <i class="bi bi-hourglass-split me-2"></i> 화상미팅 대기실
                    </h3>
                    <p class="text-muted small mt-2">입장 전 화상미팅 정보를 확인하고 기기 상태를 점검하세요 !</p>
                </div>
                
                <div class="row g-4 align-items-stretch">
                    <div class="col-lg-5 d-flex">
                        <div class="card waiting-card p-4 w-100 h-100 border-0 shadow-sm">
                            <div class="card-body">
                                
                                <div class="d-flex align-items-center mb-4 pb-3 border-bottom">
							        <%-- 배지 상태에 따른 분기 처리 --%>
							        <c:choose>
							            <c:when test="${roomInfo.videochatStatus eq '2'}">
							                <span class="badge bg-secondary me-2">종료됨</span>
							            </c:when>
							            <c:otherwise>
							                <span class="badge bg-danger pulse-red me-2">LIVE</span>
							            </c:otherwise>
							        </c:choose>
							        <h4 class="fw-bold m-0 text-truncate">${roomInfo.videochatTitle}</h4>
							    </div>
                                
                                <div class="participant-status-box mb-4 p-3 bg-light rounded-3 text-center">
							        <%-- 인원 수 안내 문구 --%>
							        <div class="small text-muted mb-1">
							            ${roomInfo.videochatStatus eq '2' ? '최종 참여 구성원' : '현재 참여 중인 구성원'}
							        </div>
							        <div class="h2 fw-bold ${roomInfo.videochatStatus eq '2' ? 'text-secondary' : 'text-primary'} mb-0">
							            <span id="realtimeCount">${memberCount}</span><small class="fs-6 text-muted"> 명</small>
							        </div>
							    </div>

                                <div class="mb-4">
                                    <label class="info-label text-muted small">초대 링크 (Waiting Room URL)</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control bg-white" id="waitingUrlDisplay" 
                                               value="http://localhost:8060/tudio/videoChat/waitingRoom?roomId=${roomInfo.videochatId}" readonly>
                                        <button class="btn btn-outline-primary" type="button" onclick="copyToClipboard('waitingUrlDisplay')">
                                            <i class="bi bi-link-45deg"></i> 복사
                                        </button>
                                    </div>
                                </div>

                                <div class="row g-3 mb-4">
                                    <div class="col-6">
                                        <label class="info-label text-muted small">Room ID</label>
                                        <div class="d-flex align-items-center p-2 bg-light rounded">
                                            <code class="text-dark flex-grow-1" id="roomIdVal">${roomInfo.videochatId}</code>
                                            <i class="bi bi-copy ms-2 text-muted copy-btn-inner" onclick="copyValue('roomIdVal')"></i>
                                        </div>
                                    </div>
                                    <div class="col-6">
                                        <label class="info-label text-muted small">Password</label>
                                        <div class="d-flex align-items-center p-2 bg-light rounded">
                                            <code class="text-danger flex-grow-1" id="roomPwVal">${roomInfo.videochatPw}</code>
                                            <i class="bi bi-copy ms-2 text-muted copy-btn-inner" onclick="copyValue('roomPwVal')"></i>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mt-4 mb-3">
                                    <label class="info-label text-muted small mb-2">
                                        <i class="bi bi-people-fill me-1"></i> 초대된 구성원 목록 
                                        <span class="badge bg-primary-subtle text-primary ms-1">${memberCount}명</span>
                                    </label>
                                    <div class="rounded border bg-white" style="max-height: 200px; overflow-y: auto;">
                                        <table class="table table-sm history-table mb-0 text-center" style="font-size: 0.85rem;">
                                            <thead class="table-light sticky-top">
                                                <tr>
                                                    <th style="width: 20%;">순번</th>
                                                    <th style="width: 45%;">성명</th>
                                                    <th style="width: 35%;">역할</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${empty memberList}">
                                                        <tr>
                                                            <td colspan="3" class="py-3 text-muted">초대 정보 없음</td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach items="${memberList}" var="member" varStatus="vs">
                                                            <tr class="${member.memberName eq loginUser.memberName ? 'bg-primary-subtle' : ''}">
                                                                <td>${vs.count}</td>
                                                                <td class="fw-bold">
											                        ${member.memberName}
											                        <c:if test="${member.memberNo eq loginUser.memberNo}">
											                            <span class="text-primary small" style="font-size: 0.75rem;">(본인)</span>
											                        </c:if>
											                    </td>
                                                                <td><small class="text-muted">${member.memberRole}</small></td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                     
                            <c:if test="${roomInfo.videochatStatus eq '2'}">
						        <div class="alert alert-secondary border-0 small mb-0 mt-auto">
						            <i class="bi bi-info-circle-fill me-2"></i>
						            이 화상미팅은 종료되었습니다. 이전 기록은 목록에서 확인 가능합니다.
						        </div>
						    </c:if>
						    <c:if test="${roomInfo.videochatStatus ne '2'}">
						        <div class="alert alert-warning border-0 small mb-0 mt-auto">
						            <i class="bi bi-exclamation-triangle-fill me-2"></i>
						            화상미팅 입장 시 카메라와 마이크 권한이 필요합니다.
						        </div>
						    </c:if>  
						                           
                            </div>
                        </div>
                    </div>
    
                    <div class="col-lg-7 d-flex">
                        <div class="card waiting-card p-5 bg-white text-center w-100 h-100 border-0 shadow-sm">
                            <div class="card-body d-flex flex-column">
                                <h5 class="fw-bold mb-4">입장 전 상태 점검</h5>
                                
                                <div class="camera-preview-box mb-4 shadow-inner" style="background:#000; border-radius:20px; overflow:hidden; position:relative; aspect-ratio: 16/9;">
                                    <%-- 카메라 미리보기 --%>
					                <c:choose>
					                    <c:when test="${roomInfo.videochatStatus eq '2'}">
					                        <%-- 화상미팅 종료 시 --%>
					                        <div class="d-flex flex-column align-items-center justify-content-center h-100 ">
					                            <i class="bi bi-camera-video-off fs-1 mb-3"></i>
					                            <p class="fw-bold">종료된 화상미팅입니다.</p>
					                            <p class="small">더 이상 카메라 미리보기를 제공하지 않습니다.</p>
					                        </div>
					                    </c:when>
					                    <c:otherwise>
					                        <video id="localVideoPreview" autoplay playsinline muted 
					                               style="width:100%; height:100%; object-fit:cover; transform: scaleX(-1); display:none;"></video>
					                        <div id="cameraPlaceholder" class="d-flex flex-column align-items-center justify-content-center h-100 text-white" style="background:#000;">
					                            <div class="spinner-border text-primary mb-3" role="status"></div>
					                            <p class="mb-0 opacity-75">카메라를 연결하는 중입니다...</p>
					                        </div>
					                    </c:otherwise>
					                </c:choose>
                               	</div>
                                
                                <div class="d-grid gap-3 col-md-9 mx-auto mt-auto">
                                
                                <%-- 입장 버튼 상태 --%>
				                <c:choose>
				                    <c:when test="${roomInfo.videochatStatus eq '2'}">
				                        <button class="btn btn-secondary btn-lg rounded-pill fw-bold py-3 shadow-none" disabled>
				                            종료된 화상미팅 입니다 <i class="bi bi-slash-circle ms-1"></i>
				                        </button>
				                    </c:when>
				                    <c:otherwise>
				                        <a href="${pageContext.request.contextPath}/tudio/videoChat/room/${roomInfo.videochatId}" 
				                           class="btn btn-primary btn-lg rounded-pill fw-bold py-3 shadow"
				                           id="btnEnter" target="_blank">
				                            지금 바로 입장하기 <i class="bi bi-arrow-right-short"></i>
				                        </a>
				                        
				                        <%-- 방 생성자에게만 종료 버튼 노출 --%>
							            <c:if test="${roomInfo.videochatCreaterNo eq loginUser.memberNo}">
							                <button type="button" class="btn btn-outline-danger btn-lg rounded-pill fw-bold py-3" 
							                        id="btnForceClose">
							                    화상미팅 종료(폐쇄) <i class="bi bi-x-circle ms-1"></i>
							                </button>
							            </c:if>
				                    </c:otherwise>
				                </c:choose>
                                
                                    <a href="${pageContext.request.contextPath}/tudio/videoChat/list" 
                                       class="btn btn-link text-muted text-decoration-none">
                                        화상미팅 대기실 나가기
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>    
    </div>
    
    <jsp:include page="../chat/main.jsp"/>
    
    <jsp:include page="../include/footer.jsp"/>
    
    <script src="${pageContext.request.contextPath}/js/footer.js"></script>

    <script>
    	let socket = null; 
    	const roomId = "${roomInfo.videochatId}";
    
        $(document).ready(function(){        	
        	// 화상미팅이 종료된 경우 카메라 동기화를 실행하지 않음
        	const isClosed = "${roomInfo.videochatStatus}" === "2";
        	
            if (!isClosed) {
                startCameraPreview();
                initRealtimeSync();
            } else {
                console.log("종료된 화상미팅은 미디어 및 소켓 연결을 생략합니다.");
            }
            
            // 수동 방 종료 이벤트
            $(document).on('click', '#btnForceClose', function() {
                swal.fire({
                    title: "화상미팅을 종료하시겠습니까?",
                    text: "종료 시 모든 구성원의 입장이 차단됩니다.",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#dc3545",
                    confirmButtonText: "네, 종료합니다",
                    cancelButtonText: "취소"
                }).then((result) => {
                    if (result.isConfirmed) {
                        $.ajax({
                            url: `${pageContext.request.contextPath}/tudio/videoChat/closeRoom`,
                            type: 'POST',
                            contentType: 'application/json',
                            data: JSON.stringify({ roomId: roomId }),
                            success: function(res) {
                                if (socket) {
                                	socket.emit("manual_close_room", { roomId: roomId });
                                }
                                
                                swal.fire({
                                    title: "종료 완료",
                                    text: "화상미팅이 폐쇄되었습니다.",
                                    icon: "success",
                                    timer: 1500,
                                    showConfirmButton: false
                                }).then(() => {
                                    location.href = "${pageContext.request.contextPath}/tudio/videoChat/list";
                                });
                            }
                        });
                    }
                });
            });
        });
        
        // 실시간 인원 및 방 종료 동기화 (Socket.io)
        function initRealtimeSync() {
            // 시그널링 서버 주소
            const SIGNALING_URL = "https://3.34.194.219:3000";
            // const roomId = "${roomInfo.videochatId}";
            
            socket = io(SIGNALING_URL, {
                rejectUnauthorized: false,
                transports: ['websocket']
            });

            socket.on("connect", () => {
                console.log("화상미팅 대기실 소켓 연결 성공");
                // 인원수 업데이트를 받기 위해 방 채널 가입
                socket.emit("join_room", { 
                	roomId: roomId,
                	userType: "WAITING"	
                });
            });

            // 서버에서 인원수 변경 알림 수신
            socket.on("participant_count", (data) => {
                console.log("참여 인원수 업데이트:", data.count);
                $('#realtimeCount').fadeOut(200, function() {
                    $(this).text(data.count).fadeIn(200);
                });
            });
            
            const myMemberNo = "${loginUser.memberNo}"; 
            
            socket.on("user_disconnected_report", function(data) {
                if (data.memId == myMemberNo) {
                    console.log("나의 화상미팅 세션이 종료되었습니다. 목록으로 이동합니다.");
                    
                    // 바로 이동하지 않고 알림창을 먼저 띄움
                    swal.fire({
                        title: "퇴장 완료",
                        text: "화상미팅을 퇴장하셨습니다. 목록으로 이동합니다.",
                        icon: "success",
                        timer: 1500, // 1.5초 후 자동 닫힘
                        showConfirmButton: false
                    }).then(() => {
                        // 알림창이 닫힌 후에 실행
                        location.href = "${pageContext.request.contextPath}/tudio/videoChat/list";
                    });
                }
            });

            // 방 자체가 종료되었을 때 (마지막 인원이 나갔을 때)
            socket.on("trigger_close_room", (data) => {
                console.log("⚠️ 모든 구성원 퇴장. DB 업데이트 시도.");
                
                $.ajax({
                    url: `${pageContext.request.contextPath}/tudio/videoChat/closeRoom`,
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({ roomId: data.roomId }),
                    success: function(res) {
                        // 성공 시 알림창 확인 후 이동
                        swal.fire({
                            title: "화상미팅 종료",
                            text: "화상미팅이 정상적으로 종료되었습니다.",
                            icon: "info",
                            confirmButtonText: "확인",
                            allowOutsideClick: false 
                        }).then((result) => {
                            if (result.isConfirmed) {
                                location.href = "${pageContext.request.contextPath}/tudio/videoChat/list";
                            }
                        });
                    },
                    error: function(err) {
                        console.error("❌ 종료 처리 실패(CORS/권한):", err);
                        // 실패하더라도 사용자는 목록으로 보내줘야 함
                        swal.fire({
                            title: "연결 종료",
                            text: "화상미팅 연결이 해제되었습니다.",
                            icon: "warning"
                        }).then(() => {
                            location.href = "${pageContext.request.contextPath}/tudio/videoChat/list";
                        });
                    }
                });
            });
        }
    
        // 카메라 미리보기
        async function startCameraPreview() {
            try {
                const stream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
                const videoElement = document.getElementById('localVideoPreview');
                const placeholder = document.getElementById('cameraPlaceholder');
                
                videoElement.srcObject = stream;
                placeholder.style.display = 'none';
                videoElement.style.display = 'block';
            } catch (err) {
                console.error("카메라 접근 실패:", err);
                $('#cameraPlaceholder').html('<i class="bi bi-camera-video-off fs-1 mb-2"></i><p>카메라를 찾을 수 없습니다.</p>');
            }
        }
    
        // 화상미팅 참여를 위한 ID, 비밀번호, url 복사
        function copyToClipboard(elementId) {
            const val = document.getElementById(elementId).value;
            performCopy(val);
        }

        function copyValue(elementId) {
            const val = document.getElementById(elementId).innerText;
            performCopy(val);
        }

        function performCopy(text) {
            navigator.clipboard.writeText(text).then(() => {
                swal.fire({ toast:true, position:'top', icon:'success', title:'복사되었습니다!', showConfirmButton:false, timer:1000 });
            });
        }
    </script>
</body>
</html>