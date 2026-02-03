<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>Tudio</title>
	<title>Tudio - 프로젝트 초대</title>
	<jsp:include page="/WEB-INF/views/include/common.jsp" />
	<style>
		.footer {
		    margin-left: 0 !important;
		    width: 100%;
		}
		body {
			background-color: #f0f2f5;
		}
		.invite-card {
			width: 100%;
			max-width: 480px;
			border: none;
			border-radius: 20px;
			box-shadow: 0 15px 35px rgba(0,0,0,0.1);
			background: white;
			overflow: hidden;
			position: relative;
	    }
		.invite-header {
			background: linear-gradient(135deg, #4e73df 0%, #224abe 100%);
			padding: 30px 20px 40px;
			text-align: center;
			color: white;
			clip-path: ellipse(150% 100% at 50% 0%);
		}
		.invite-icon-circle {
			width: 80px;
			height: 80px;
			background: white;
			border-radius: 50%;
			display: flex;
			align-items: center;
			justify-content: center;
			margin: 0 auto 20px;
			box-shadow: 0 5px 15px rgba(0,0,0,0.1);
			color: #4e73df;
			font-size: 2.5rem;
		}
		.invite-body {
			padding: 0 30px 40px;
			text-align: center;
			margin-top: -30px; /* 헤더 위로 살짝 올림 */
	     }
		.project-info-box {
			background: white;
			border-radius: 15px;
			padding: 45px 25px 25px;
			margin-bottom: 25px;
			box-shadow: 0 5px 20px rgba(0,0,0,0.05);
			border: 1px solid #edf2f9;
		}
		.project-dates {
			font-size: 0.85rem;
			color: #858796;
			margin-top: 10px;
			background: #f8f9fc;
			padding: 8px 15px;
			border-radius: 50px;
			display: inline-block;
		}
	</style>
</head>
<body class="bg-light min-vh-100 d-flex flex-column">

	<jsp:include page="/WEB-INF/views/include/headerUser.jsp"/>
	
	<main class="flex-grow-1 d-flex align-items-center justify-content-center">
		<div class="w-100 d-flex justify-content-center px-3 py-3">
			<div class="invite-card animate__animated animate__fadeInUp">    
		        <div class="invite-header">
		            <div class="invite-icon-circle animate__animated animate__bounceIn">
		                <i class="bi bi-envelope-check-fill"></i>
		            </div>
		            <h3 class="fw-bold mb-1">프로젝트 초대</h3>
		            <p class="mb-0 opacity-75 small">팀원들이 당신을 기다리고 있습니다!</p>
		        </div>

		        <div class="invite-body">		            
		            <c:choose>
		                <%-- CASE 1: 비로그인 상태 (Guest) --%>
		                <c:when test="${isGuest}">
		                    <div class="project-info-box">
		                        <i class="bi bi-shield-lock text-warning fs-1 mb-3 d-block"></i>
		                        <h5 class="fw-bold text-dark mb-2">로그인이 필요합니다</h5>
		                        <p class="text-muted small mb-0">
		                            안전한 프로젝트 참여를 위해<br>먼저 로그인을 완료해 주세요.
		                        </p>
		                    </div>
		                    <div class="d-grid">
		                        <a href="${pageContext.request.contextPath}/tudio/login" class="btn btn-primary btn-lg fw-bold py-3 rounded-pill shadow-sm">
		                            로그인 하러 가기 <i class="bi bi-arrow-right-circle ms-2"></i>
		                        </a>
		                    </div>
		                </c:when>

		                <%-- CASE 2: 로그인 상태 (초대 정보 표시) --%>
		                <c:otherwise>
		                    <div class="project-info-box">
		                        <h6 class="text-primary fw-bold small text-uppercase mb-2">Invited Project</h6>
		                        
		                        <h4 class="fw-bolder text-dark mb-2">
		                            ${not empty project.projectName ? project.projectName : '프로젝트 정보 없음'}
		                        </h4>
		                        
		                        <c:if test="${not empty project.projectDesc}">
		                            <p class="text-muted small mb-0 text-truncate-2">
		                                ${project.projectDesc}
		                            </p>
		                        </c:if>

		                        <div class="project-dates">
		                            <i class="bi bi-calendar-event me-1"></i>
		                            <fmt:formatDate value="${project.projectStartdate}" pattern="yyyy.MM.dd"/> ~ 
		                            <fmt:formatDate value="${project.projectEnddate}" pattern="yyyy.MM.dd"/>
		                        </div>
		                    </div>

		                    <p class="text-secondary small mb-4">
		                        위 프로젝트의 구성원으로 초대되셨습니다.<br>
		                        <strong>'수락하기'</strong> 버튼을 눌러 바로 참여하세요.
		                    </p>

		                    <div class="d-grid gap-2">
		                        <button type="button" class="btn btn-primary btn-lg fw-bold py-3 rounded-pill shadow-sm" id="btnAccept">
		                            <i class="bi bi-check-lg me-1"></i> 초대 수락하기
		                        </button>
		                        <a href="${pageContext.request.contextPath}/tudio/dashboard" class="btn btn-light btn-lg text-secondary fw-bold py-3 rounded-pill">
		                            다음에 하기
		                        </a>
		                    </div>
		                </c:otherwise>
		            </c:choose>
		        </div>
		    </div>
		</div>
	</main>
		
	<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
	
	<script>
		$(document).ready(function() {
			const projectNo = "${project.projectNo}";

			$('#btnAccept').on('click', function() {
				const $btn = $(this);
				const originalText = $btn.html();

				// 버튼 비활성화 (중복 클릭 방지)
	            $btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm me-2"></span>처리 중...');

				$.ajax({
					url: "${pageContext.request.contextPath}/tudio/project/invite/accept",
					type: "POST",
					data: JSON.stringify({ projectNo: projectNo }),
					contentType: "application/json; charset=utf-8",
					dataType: "json",
					success: function(res) {
						if (res.status === "SUCCESS") {	// 성공
							Swal.fire({
								icon: 'success',
								title: '환영합니다!',
								text: '프로젝트 참여가 완료되었습니다.',
								showConfirmButton: false,
								timer: 1500
							}).then(() => {
								// 프로젝트 상세 페이지로 이동
								location.href = "${pageContext.request.contextPath}" + res.redirectUrl;
							});
						} else if (res.status === "ALREADY_JOINED") {
							// 이미 참여 중인 경우
							Swal.fire('알림', '이미 참여 중인 프로젝트입니다.', 'info')
								.then(() => location.href = "${pageContext.request.contextPath}" + res.redirectUrl);
						} else { // 실패 시							
							Swal.fire('오류', '초대 수락 처리에 실패했습니다.', 'error');
							$btn.prop('disabled', false).html(originalText);
						}
					},
					error: function(xhr) {
						console.error(xhr);
						Swal.fire('에러', '서버 통신 중 오류가 발생했습니다.', 'error');
						$btn.prop('disabled', false).html(originalText);
					}
				});
			});
		});
	</script>
</body>
</html>