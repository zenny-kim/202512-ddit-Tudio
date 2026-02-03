<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<title>Tudio</title>
	<jsp:include page="/WEB-INF/views/include/common.jsp" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/member.css">
</head>

<body>
<jsp:include page="/WEB-INF/views/include/headerGuest.jsp"/>
	<div class="login-container shadow">
		<h2 class="text-center login-title">아이디 찾기</h2>
		<p class="text-center text-muted small mb-4">가입 시 등록한 이름과 이메일을
			입력해주세요.</p>

		<form id="findIdForm"  action="${pageContext.request.contextPath}/tudio/findMemberId" method="POST">
			<div class="mb-3">
				<label for="userName" class="form-label fw-bold">이름</label>
				<input type="text" class="form-control" id="memberName" name="memberName" placeholder="이름을 입력하세요" required>
			</div>

			<div class="mb-4">
				<label for="userEmail" class="form-label fw-bold">이메일</label>
				<input type="email" class="form-control" id="memberEmail" name="memberEmail" placeholder="example@email.com" required>
			</div>

			<div class="d-grid gap-2 mb-3">
				<button type="submit" class="btn btn-primary btn-lg" id="idFindBtn">아이디 찾기</button>
			</div>

			<hr class="my-4">

			<div class="sub-menu text-center">
				<a href="${pageContext.request.contextPath}/tudio/login" class="text-decoration-none text-muted small mx-2">로그인</a>
				<span>|</span>
				<a href="${pageContext.request.contextPath}/tudio/findMemberPw" class="text-decoration-none text-muted small mx-2">비밀번호 찾기</a>
				<span>|</span>
				<a href="${pageContext.request.contextPath}/tudio/memberSignup" class="text-decoration-none text-muted small mx-2">회원가입</a>
			</div>
		</form>
		<div id="resultArea" class="text-center" style="display: none;">
		    <div class="mb-3">
		        <span style="font-size: 50px; color: #198754;">✔</span>
		    </div>
		    
		    <h3 class="fw-bold">아이디를 찾았습니다.</h3>
		    <p class="text-muted small">고객님의 정보와 일치하는 아이디입니다.</p>
		    
		    <div class="p-3 my-4 bg-light border rounded">
		        <span id="foundId" class="h4 fw-bold text-primary"></span>
		    </div>
		    
		    <div class="d-grid gap-2">
		        <a href="${pageContext.request.contextPath}/tudio/login" class="btn btn-primary">로그인</a>
		        <a href="${pageContext.request.contextPath}/tudio/findMemberPw" class="btn btn-outline-secondary">비밀번호 찾기</a>
		    </div>
		</div>
			</div>
</body>
<script type="text/javascript">
$(function() {
    let idFindBtn = $("#idFindBtn");
    
    idFindBtn.on("click", function(e) {
        e.preventDefault(); // 폼의 기본 제출 동작 방지

        let memberEmail = $("#memberEmail").val();
        let memberName = $("#memberName").val();

        if (!memberEmail) {
            sweetAlert("error", "이메일을 입력해주세요!");
            return false;
        }
        if (!memberName) {
            sweetAlert("error", "이름을 입력해주세요!");
            return false;
        }

        let data = {
            memberEmail : memberEmail,
            memberName : memberName
        };

        $.ajax({
            url : "${pageContext.request.contextPath}/tudio/findMemberId",
            type : "post",
            contentType : "application/json; charset=utf-8",
            data : JSON.stringify(data),
            success : function(res) {
                if(res) {
                    // 1. 입력 폼 숨기기
                    $("#findIdForm").hide();
                    $(".login-title").hide(); // '아이디 찾기' 타이틀도 숨기려면 추가
                    $("p.text-muted").hide(); // 상단 설명 숨기기

                    // 2. 찾은 아이디 넣고 결과 영역 보이기
                    $("#foundId").text(res);
                    $("#resultArea").fadeIn(); // 부드럽게 나타나게 하기
                } else {
                    sweetAlert("error", "일치하는 아이디가 없습니다.");
                }
            },
            error : function() {
                sweetAlert("error", "정보가 일치하지 않거나 서버 오류입니다.");
            }
        });
    });
});
</script>

</html>