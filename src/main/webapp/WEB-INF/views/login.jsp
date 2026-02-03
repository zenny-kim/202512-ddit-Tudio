<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>Tudio</title>
	<jsp:include page="/WEB-INF/views/include/common.jsp" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/member.css">
</head>

<body>
<jsp:include page="/WEB-INF/views/include/headerGuest.jsp"/>
	<div class="login-wrapper">
    <div class="login-container shadow">
        <h2 class="text-center login-title">Tudio</h2>

        <form id="loginForm" action="${pageContext.request.contextPath}/login" method="POST">
            <div class="mb-3">
                <label for="username" class="form-label fw-bold">아이디</label>
                <input type="text" class="form-control login-input" id="username" name="username" placeholder="아이디를 입력하세요" required>
            </div>
            <div class="mb-4">
                <label for="password" class="form-label fw-bold">비밀번호</label>
                <input type="password" class="form-control login-input" id="password" name="password" placeholder="비밀번호를 입력하세요" required>
                <div class="error-msg text-danger small mt-1" style="height: 20px;"></div>
            </div>
            <!-- 퀵로그인 -->
            <div class="text-center mb-4">
			    <div class="btn-group" role="group">
			        <button type="button" class="btn btn-outline-secondary" onclick="quickLogin('c004', '1234')">
			            <i class="bi bi-person-fill-check"></i>사용자
			        </button>
			        <button type="button" class="btn btn-outline-secondary" onclick="quickLogin('c005', '1234')">
			            <i class="bi bi-person-badge"></i>기업
			        </button>
			        <button type="button" class="btn btn-outline-secondary" onclick="quickLogin('a001', '1234')">
			            <i class="bi bi-person-gear"></i>관리자
			        </button>
			    </div>
			</div>
			<!-- 퀵로그인 -->
            <div class="d-grid gap-2 mb-3">
                <button type="submit" class="btn btn-primary btn-lg">로그인</button>
            </div>

            <div class="d-flex justify-content-center mb-3">
                <a href="${pageContext.request.contextPath}/tudio/findMemberId" class="text-decoration-none text-muted small mx-2">아이디 찾기</a>
                <span class="text-muted small">|</span>
                <a href="${pageContext.request.contextPath}/tudio/findMemberPw" class="text-decoration-none text-muted small mx-2">비밀번호 찾기</a>
            </div>

            <hr class="my-4">
            
            <div class="text-center">
                <p class="text-muted small">아직 계정이 없으신가요?</p>
                <button type="button" class="btn btn-outline-secondary w-100" 
                        onclick="location.href='${pageContext.request.contextPath}/tudio/memberType'">회원가입</button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp"/>

</body>
<script>
$(function() {
    // 1. 사용할 요소들을 변수에 미리 담아둡니다 (성능 최적화)
    const $loginInput = $(".login-input");  // 아이디, 비밀번호 입력창
    const $errorText = $(".error-msg");     // 화면에 빨간색으로 뜰 에러 메시지
    const $loginForm = $("#loginForm");           // 로그인 폼 전체
    
    const urlParams = new URLSearchParams(window.location.search);
    
    if (urlParams.get("message")) {
        Swal.fire({
            icon: 'error',
            title: '로그인 실패',
            text: params.get("message"),
            confirmButtonText: '확인'
        });

    // 로그아웃 성공
    } else if (urlParams.get("logout") === "true") {
        Swal.fire({
            icon: 'success',
            title: '로그아웃 되었습니다',
            confirmButtonText: '확인'
        });
    }

    // 알럿 표시 후 URL 파라미터 제거
    if (urlParams.toString()) {
        window.history.replaceState({}, document.title, window.location.pathname);
    }

    // 3. 입력창 이벤트 처리
    $loginInput.on("keydown click", function(event) {
        $errorText.html("");
        
        // 3-2. CapsLock 상태 체크 (비밀번호 입력 시 유용)
        if (event.originalEvent && typeof event.originalEvent.getModifierState === "function") {
            if (event.originalEvent.getModifierState("CapsLock")) {
                $errorText.html("⚠️ CapsLock이 켜져 있습니다.");
            }
        }
        
        // 3-3. Enter 키(13번)를 누르면 바로 폼을 전송(Submit)합니다.
        if (event.which === 13) {
            $loginForm.submit();
        }
    });
});

//퀵로그인 기능 - 구현 시 수정하거나 삭제
function quickLogin(userId, userPw) {
    $("#username").val(userId);
    $("#password").val(userPw);
    $(".error-msg").html("");
    $("#loginForm").submit();

}


</script>
</html>