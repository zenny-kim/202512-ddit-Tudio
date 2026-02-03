<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Tudio - 화상미팅</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/project_common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/video_chat.css">
	<jsp:include page="/WEB-INF/views/include/common.jsp" />   
	<style>
	    /* 토스트 상단 중앙 정렬 및 디자인 */
	    .toast-container { top: 20px !important; }
	    .toast-success { background-color: #3B82F6; color: white; }
	    .toast-warning { background-color: #ffc107; color: #212529; }
	    .toast-danger { background-color: #dc3545; color: white; }
	    #videoToast { min-width: 300px; width: 100%; box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15); }
	</style>
</head>
<body data-context-path="${pageContext.request.contextPath}"
	data-login-no="${loginUser.memberNo}"
	class="d-flex flex-column min-vh-100">
	
	<jsp:include page="../include/headerUser.jsp"/>
    
    <div class="d-flex flex-grow-1">
	    <jsp:include page="../include/sidebarUser.jsp">
	    	<jsp:param name="menu" value="video_chat" />
	    </jsp:include>
	
		<main class="main-content-wrap flex-grow-1 px-4 pt-4 pb-5">
			<div class="container-fluid">
				<div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h3 class="fw-bold text-primary-dark m-0">
                            <i class="bi bi-camera-video me-2"></i> 화상미팅
                        </h3>
                        <p class="text-muted mb-0 small mt-2">프로젝트 구성원과 실시간으로 소통하세요 !</p>
                    </div>
		    	</div>

				<div class="row g-4 justify-content-center mb-5">
            		<div class="col-md-5 col-lg-4">
            			<div class="card h-100 p-4 text-center video-action-card" data-bs-toggle="modal" data-bs-target="#createMeetingModal">
            				<div class="card-body">
            					<div class="text-primary icon-large">
            						<i class="bi bi-plus-circle-dotted"></i>
            					</div>
            					<h5 class="card-title fw-bold mb-2">화상미팅 생성</h5>
            					<p class="card-text text-muted small">프로젝트 구성원을 초대하여<br>새 화상미팅를 시작합니다.</p>
            				</div>
            			</div>
            		</div>
            		
            		<div class="col-md-5 col-lg-4">
            			<div class="card h-100 p-4 text-center video-action-card" data-bs-toggle="modal" data-bs-target="#joinMeetingModal">
            				<div class="card-body">
            					<div class="text-success icon-large">
            						<i class="bi bi-box-arrow-in-right"></i>
            					</div>
            					<h5 class="card-title fw-bold mb-2">화상미팅 참여</h5>
            					<p class="card-text text-muted small">초대받은 코드를 입력하여<br>화상미팅에 입장합니다.</p>
            				</div>
            			</div>
            		</div>
            	</div>  

				<div class="card shadow-sm border-0">
					<div class="card-header bg-white py-3">
						<h5 class="m-0 fw-bold"><i class="bi bi-clock-history me-2"></i>최근 화상미팅 이력</h5>
					</div>
					<div class="card-body p-0">
						<div class="table-responsive">
							<table class="table table-hover history-table mb-0 text-center">
								<thead>
									<tr>
										<th scope="col" style="width: 10%;">번호</th>
										<th scope="col" style="width: 15%;">프로젝트</th>
										<th scope="col" class="text-start">화상미팅 제목</th>
										<th scope="col" style="width: 15%;">생성자</th>
										<th scope="col" style="width: 20%;">생성 일시</th>
										<th scope="col" style="width: 10%;">상태</th>
									</tr>
								</thead>
								<tbody>
								    <c:choose>
								        <c:when test="${empty pagingVO.dataList}">
								            <tr>
								                <td colspan="6" class="py-5 text-muted">참여한 화상미팅 기록이 없습니다.</td>
								            </tr>
								        </c:when>
								        <c:otherwise>
								            <c:forEach items="${pagingVO.dataList}" var="chat" varStatus="status">
								                <tr>
								                    <td>${pagingVO.totalRecord - (pagingVO.currentPage - 1) * pagingVO.screenSize - status.index}</td>
								                    <td><span class="badge bg-light text-dark border">${chat.projectName}</span></td>
								                    <td class="text-start fw-bold text-primary">
								                        <a href="${pageContext.request.contextPath}/tudio/videoChat/waitingRoom?roomId=${chat.videochatId}" class="text-decoration-none">
								                            ${chat.videochatTitle}
								                        </a>
								                    </td>
								                    <td>${chat.creatorName}</td>
								                    <td><fmt:formatDate value="${chat.createdDate}" pattern="yyyy-MM-dd HH:mm"/></td>
								                    <td>
								                        <c:choose>
								                            <c:when test="${chat.videochatStatus eq 0}">
								                                <span class="badge bg-success">진행중</span>
								                            </c:when>
								                            <c:otherwise>
								                                <span class="badge bg-secondary">종료</span>
								                            </c:otherwise>
								                        </c:choose>
								                    </td>
								                </tr>
								            </c:forEach>
								        </c:otherwise>
								    </c:choose>
								</tbody>
							</table>
							<div class="card-footer bg-white py-3 clearfix">
							    <div id="pagingArea" class="d-flex justify-content-center">
							        ${pagingVO.pagingHTML}
							    </div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</main>	
	</div>

	<div class="modal fade" id="createMeetingModal" tabindex="-1" aria-hidden="true">
		<div class="modal-dialog modal-lg modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title fw-bold">
						<i class="bi bi-camera-video"></i> 새 화상미팅 만들기
					</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<div class="mb-4">
						<label for="projectSelect" class="form-label fw-bold">프로젝트 선택</label> 
						<select class="form-select" id="projectSelect">
						    <option selected disabled value="">화상미팅를 진행할 프로젝트를 선택하세요</option>
						    <c:choose>
						        <c:when test="${empty projectList}">
						            <option disabled>참여 중인 프로젝트가 없습니다.</option>
						        </c:when>
						        <c:otherwise>
						            <c:forEach items="${projectList}" var="project">
						                <option value="${project.projectNo}">${project.projectName}</option>
						            </c:forEach>
						        </c:otherwise>
						    </c:choose>
						</select>
					</div>
					
					<div class="mb-4">
					    <label for="videochatTitle" class="form-label fw-bold">화상미팅 제목</label>
					    <input type="text" class="form-control" id="videochatTitle" 
					           placeholder="프로젝트를 선택하면 제목이 자동으로 제안됩니다." 
					           style="background-color: #f8f9fa;">
					</div>

					<div class="mb-3">
						<label class="form-label fw-bold">초대할 프로젝트 구성원 선택</label>
						<div class="card">
							<div class="card-body bg-light" id="adminListArea" style="max-height: 200px; overflow-y: auto;">
								<div class="text-center text-muted py-3">프로젝트를 먼저 선택해주세요.</div>
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
					<button type="button" class="btn btn-primary" id="btnCreateRoom">화상미팅 방 생성 및 초대</button>
				</div>
			</div>
		</div>
	</div>

	<div class="modal fade" id="joinMeetingModal" tabindex="-1" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title fw-bold">화상미팅 참여하기</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<div class="mb-3">
						<label for="inputRoomId" class="form-label">방 ID (Room ID)</label>
						<input type="text" class="form-control" id="inputRoomId" placeholder="전달받은 UUID 입력">
					</div>
					<div class="mb-3">
						<label for="inputRoomPw" class="form-label">방 비밀번호 (Password)</label> 
						<input type="password" class="form-control" id="inputRoomPw" placeholder="비밀번호 입력">
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
					<button type="button" class="btn btn-success" id="btnJoinRoom">입장하기</button>
				</div>
			</div>
		</div>
	</div>
	
	<div class="toast-container position-fixed top-0 start-50 translate-middle-x p-3" style="z-index: 10000;">
	    <div id="videoToast" class="toast align-items-center border-0 shadow" role="alert" aria-live="assertive" aria-atomic="true">
	        <div class="d-flex align-items-center">
	            <div class="toast-body d-flex align-items-center gap-3">
	                <div id="toastIconArea"></div>
	                <div id="toastMessageArea" class="fw-bold"></div>
	            </div>
	            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
	        </div>
	    </div>
	</div>

	<jsp:include page="../chat/main.jsp"/>
	
	<jsp:include page="../include/footer.jsp"/>
    
	<script src="${pageContext.request.contextPath}/js/footer.js" ></script>
	
	<script>
		$(document).ready(function(){
			
			function showVideoToast(message, type = 'success') {
			    const toastEl = document.getElementById('videoToast');
			    const iconArea = document.getElementById('toastIconArea');
			    const msgArea = document.getElementById('toastMessageArea');
			    
			    $(toastEl).removeClass('toast-success toast-warning toast-danger text-white text-dark');
			    
			    let iconHtml = '';
			    switch(type) {
			        case 'loading': // 로딩 중 (스피너)
			            $(toastEl).addClass('bg-primary text-white');
			            iconHtml = `<div class="spinner-border spinner-border-sm" role="status"></div>`;
			            break;
			        case 'success': // 성공 (체크)
			            $(toastEl).addClass('bg-success text-white');
			            iconHtml = `<i class="bi bi-check-circle-fill"></i>`;
			            break;
			        case 'warning': // 경고 (주의)
			            $(toastEl).addClass('bg-warning text-dark');
			            iconHtml = `<i class="bi bi-exclamation-triangle-fill"></i>`;
			            break;
			        case 'danger': // 에러 (X)
			            $(toastEl).addClass('bg-danger text-white');
			            iconHtml = `<i class="bi bi-x-circle-fill"></i>`;
			            break;
			    }
			    
			    iconArea.innerHTML = iconHtml;
			    msgArea.innerText = message;
			    
			    const toast = new bootstrap.Toast(toastEl, { delay: 3500 });
			    toast.show();
			}
			
			$('#pagingArea').on('click', 'a', function(e){
		        e.preventDefault();
		        let pageNo = $(this).data('page');
		        location.href = "${pageContext.request.contextPath}/tudio/videoChat/list?page=" + pageNo;
		    });
			
			// 프로젝트 선택 시 제목 제안 로직 수정
		    $('#projectSelect').on('change', function(){
		        let projectNo = $(this).val(); 
		        let projectName = $("#projectSelect option:selected").text(); // 선택된 프로젝트명
		        
		        // 제목 자동 세팅 및 기본값 저장
		        let defaultTitle = projectName + " 화상미팅";
		        $('#videochatTitle').val(defaultTitle)
		                           .attr('data-default', defaultTitle) // 비교를 위한 데이터 속성 저장
		                           .css('color', '#6c757d'); // 기본값은 약간 흐리게
			
				// 프로젝트 선택 시 해당 프로젝트 구성원 목록 조회
		        $('#adminListArea').html('<div class="text-center text-muted p-3">멤버 목록을 불러오는 중...</div>');

		        $.ajax({
		            url: "${pageContext.request.contextPath}/tudio/videoChat/getProjectMembers",
		            type: "post",
		            // data: JSON.stringify(projectNo), 
		            data: JSON.stringify({ projectNo: parseInt(projectNo) }),
		            contentType: "application/json; charset=utf-8",
		            dataType: "json",
		            success: function(res) {
		                let html = "";
		                
						html += `
							<div class="alert alert-info py-1 px-2 small mb-2 d-flex justify-content-between align-items-center" style="font-size:0.75rem;">
								<span><i class="bi bi-info-circle me-1"></i> 방 생성자는 자동으로 참여 인원에 포함됩니다.</span>
								<div class="form-check d-flex align-items-center gap-2">
									<input class="form-check-input" type="checkbox" id="selectAllMembers">
									<label class="form-check-label fw-bold" for="selectAllMembers" style="cursor:pointer;">전체 선택</label>
								</div>
							</div>
						`;
		                
		                if(res.length === 0) {
		                    html = '<div class="text-center text-muted py-3">초대 가능한 프로젝트 구성원 없습니다.</div>';
		                } else {
		                    $.each(res, function(idx, member){
		                        html += `
		                            <div class="form-check p-2 border-bottom">
		                                <input class="form-check-input ms-1 member-check" type="checkbox" 
		                                       name="inviteMemberList" 
		                                       value="\${member.memberNo}" 
		                                       id="mem_\${member.memberNo}">
		                                <label class="form-check-label ms-2 cursor-pointer" for="mem_\${member.memberNo}">
		                                    <strong>\${member.memberName}</strong> 
		                                    <span class="text-muted small">(\${member.memberRole ? member.memberRole : '참여자'})</span>
		                                </label>
		                            </div>
		                        `;
		                    });
		                }
		                $('#adminListArea').html(html);
		            },
		            error: function(xhr) {
		                console.error(xhr);
		                $('#adminListArea').html('<div class="text-danger text-center py-3">목록을 불러오지 못했습니다.</div>');
		            }
		        });
		    });
			
		 	// 제목 입력창 클릭(Focus) 시 초기화 및 복구
		    $('#videochatTitle').on('focus', function() {
		        const currentVal = $(this).val();
		        const defaultVal = $(this).attr('data-default');
		        
		        if (currentVal === defaultVal) {
		            $(this).val('').css('color', '#212529'); // 기본값과 같으면 비우고 글자색 진하게
		        }
		    });

		    $('#videochatTitle').on('blur', function() {
		        const currentVal = $(this).val().trim();
		        const defaultVal = $(this).attr('data-default');
		        
		        if (currentVal === '') {
		            $(this).val(defaultVal).css('color', '#6c757d'); // 비어있으면 다시 기본값으로
		        }
		    });
		    
		    // 구성원 전체 선택 이벤트
		    $(document).on('change', '#selectAllMembers', function() {
		        const isChecked = $(this).prop('checked');
		        // 모든 체크박스를 전체 선택 상태와 동기화
		        $('input[name="inviteMemberList"]').prop('checked', isChecked);
		    });
		    
		    // 구성원 전체 선택 해제 이벤트
		    $(document).on('change', 'input[name="inviteMemberList"]', function() {
		        const total = $('input[name="inviteMemberList"]').length;
		        const checked = $('input[name="inviteMemberList"]:checked').length;
		        
		        // 모두 체크되어 있으면 전체 선택 체크, 하나라도 해제되면 전체 선택 해제
		        $('#selectAllMembers').prop('checked', total === checked);
		    });
	
			// 방 생성 버튼 클릭 이벤트
			$('#btnCreateRoom').on('click', function(){
			    let projectNo = $('#projectSelect').val();
			    let videochatTitle = $('#videochatTitle').val().trim();
			    let invitedMembers = [];
			    
			    $('input[name="inviteMemberList"]:checked').each(function(){
			        invitedMembers.push($(this).val());
			    });

			    if(!projectNo) {
			        alert("프로젝트를 선택해주세요.");
			        return;
			    }
			    
			    if(invitedMembers.length === 0) {
			        alert("초대할 멤버를 최소 1명 선택해주세요.");
			        return;
			    }

			    let data = {
			        projectNo: parseInt(projectNo),
			        inviteMemberList: invitedMembers,
			        videochatTitle: videochatTitle 
			    };
			    
			    showVideoToast("회의실을 생성하고 구성원을 초대하는 중입니다...", 'loading');

			    $.ajax({
			        url: "${pageContext.request.contextPath}/tudio/videoChat/create",
			        type: "post",
			        data: JSON.stringify(data),
			        contentType: "application/json; charset=utf-8",
			        dataType: "json",
			        success: function(res) {
			            showVideoToast("회의실 생성 완료! 대기실로 이동합니다.", 'success');            
			            setTimeout(() => {
			                location.href = "${pageContext.request.contextPath}/tudio/videoChat/waitingRoom?roomId=" + res.videochatId;
			            }, 1200);
			        },
			        error: function(xhr) {
			            console.error(xhr);
			            alert("회의실 생성에 실패했습니다.");
			        }
			    });
			});
	
			// 방 참여 버튼 클릭 이벤트
			$('#btnJoinRoom').on('click', function(){
				const id = $('#inputRoomId').val().trim();
				const pw = $('#inputRoomPw').val().trim();
				
				if(!id || !pw) {
					alert("ID와 비밀번호를 모두 입력해주세요.");
					return;
				}

				// 서버에 ID/PW 검증 요청
				let data = {
					roomId: id,
					roomPw: pw
				};

				$.ajax({
					url: "${pageContext.request.contextPath}/tudio/videoChat/checkRoom",
					type: "post",
					data: JSON.stringify(data),
					contentType: "application/json; charset=utf-8",
					dataType: "json",
					success: function(isValid) {
						if(isValid) {
							// 검증 성공 시 대기실로 이동
							location.href = "${pageContext.request.contextPath}/tudio/videoChat/waitingRoom?roomId=" + id;
						} else {
							// 검증 실패
							alert("방 정보가 존재하지 않거나 비밀번호가 일치하지 않습니다.\n또는 이미 종료된 회의일 수 있습니다.");
						}
					},
					error: function(xhr) {
						console.error(xhr);
						alert("서버 통신 중 오류가 발생했습니다.");
					}
				});
			});
		});
	</script>
</body>
</html>