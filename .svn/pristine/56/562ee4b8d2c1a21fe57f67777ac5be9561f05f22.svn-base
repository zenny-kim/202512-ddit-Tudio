<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
	<title>Tudio</title>
	<jsp:include page="/WEB-INF/views/include/common.jsp" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/member.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/include/headerGuest.jsp"/>
	
	<%-- 초대 링크 파라미터 저장 로직 (OK) --%>
	<c:set var="inviteParams" value="" />
	    
	<%-- inviteToken --%>
	<c:if test="${not empty inviteToken}">
	    <c:set var="inviteParams" value="&token=${inviteToken}&email=${inviteEmail}" />
	</c:if>

    <div class="register-container">
        <h2 class="text-center mb-5 fw-light">어떤 유형의 계정으로 가입하시겠어요?</h2>
        
        <div class="row g-4 justify-content-center">
            
            <div class="col-md-6">
                <div class="card type-card text-center shadow-sm">
                    <div class="card-body d-flex flex-column p-4">
                        <h4 class="card-title text-dark mb-3">프로젝트 사용자</h4>
                        <p class="card-text text-muted mb-4">프로젝트 업무를 직접 수행하거나 관리하는 내부 직원 및 팀원을 위한 계정입니다.</p>
                        <a href="${pageContext.request.contextPath}/tudio/memberSignup?actor=user${inviteParams}" class="btn btn-primary btn-lg mt-auto">가입하기</a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card type-card text-center shadow-sm">
                    <div class="card-body d-flex flex-column p-4">
                        <h4 class="card-title text-dark mb-3">기업 담당자</h4>
                        <p class="card-text text-muted mb-4">진척도 확인 및 검토 등 프로젝트를 모니터링하기 위한 제한된 조회 계정입니다.</p>
						<c:choose>
							<c:when test="${not empty inviteParams}">
								<a href="${pageContext.request.contextPath}/tudio/clientSignup?dummy=1${inviteParams}" 
									class="btn btn-primary btn-lg mt-auto">가입하기</a>
							</c:when>
							<c:otherwise>
								<a href="${pageContext.request.contextPath}/tudio/clientSignup" class="btn btn-primary btn-lg mt-auto">가입하기</a>
							</c:otherwise>
						</c:choose>
						
						<!--<a href="${pageContext.request.contextPath}/tudio/clientSignup" class="btn btn-primary btn-lg mt-auto">가입하기</a>-->
                    </div>
                </div>
            </div>
            
        </div>
        
        <p class="text-center mt-5 text-muted">
            이미 계정이 있으신가요? 
            <a href="${pageContext.request.contextPath}/tudio/login" class="text-decoration-none fw-bold">로그인</a>
        </p>
    </div>
<script src="${pageContext.request.contextPath}/js/register.js"></script>
</body>
</html>