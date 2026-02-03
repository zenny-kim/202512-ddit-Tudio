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
		<div id="findPwArea">
			<h2 class="text-center login-title">비밀번호 찾기</h2>
			<p class="text-center text-muted small mb-4">가입 시 등록한 아이디, 이름,
				휴대폰 번호를 입력해주세요.</p>

			<form id="findPwForm">
				<div class="mb-3">
					<label for="memberId" class="form-label fw-bold">아이디</label>
					<input type="text" class="form-control" id="memberId" placeholder="아이디를 입력하세요" required>
				</div>

				<div class="mb-3">
					<label for="memberName" class="form-label fw-bold">이름</label>
					<input type="text" class="form-control" id="memberName" placeholder="이름을 입력하세요" required>
				</div>

				<div class="mb-4">
					<label for="memberTel" class="form-label fw-bold">휴대폰 번호</label>
					<input type="tel" class="form-control" id="memberTel" placeholder="010-0000-0000" required>
				</div>

				<div class="d-grid gap-2 mb-3">
					<button type="button" class="btn btn-primary btn-lg" id="pwFindBtn">임시 비밀번호 발송</button>
				</div>
			</form>
		</div>

		<div id="resultArea" class="text-center" style="display: none;">
			<div class="mb-3">
				<span style="font-size: 50px; color: #198754;">📧</span>
			</div>
			<h3 class="fw-bold">이메일 발송 완료</h3>
			<p class="text-muted small">입력하신 정보와 일치하는 이메일로<br>임시 비밀번호를 발송해 드렸습니다.</p>

			<div class="p-3 my-4 bg-light border rounded">
				<span id="targetEmail" class="fw-bold text-primary"></span>
			</div>

			<p class="text-muted x-small">메일이 오지 않았다면 스팸함을 확인해 주세요.</p>

			<div class="d-grid gap-2 mt-4">
				<a href="${pageContext.request.contextPath}/tudio/login" class="btn btn-primary">로그인하러 가기</a>
			</div>
		</div>

		<hr class="my-4">
		<div class="sub-menu text-center">
			<a href="${pageContext.request.contextPath}/tudio/login" class="text-decoration-none text-muted small mx-2">로그인</a>
			<span>|</span>
			<a href="${pageContext.request.contextPath}/tudio/findMemberId" class="text-decoration-none text-muted small mx-2">아이디 찾기</a>
			<span>|</span>
			<a href="${pageContext.request.contextPath}/tudio/memberSignup" class="text-decoration-none text-muted small mx-2">회원가입</a>
		</div>
	</div>

<script type="text/javascript">
    $(function() {
        $("#pwFindBtn").on("click", function() {
            let memberId = $("#memberId").val();
            let memberName = $("#memberName").val();
            let memberTel = $("#memberTel").val();

            // 유효성 검사
            if (!memberId || !memberName || !memberTel) {
                sweetAlert("warning", "모든 정보를 입력해주세요!");
                return false;
            }

            let data = {
                memberId: memberId,
                memberName: memberName,
                memberTel: memberTel
            };

            // AJAX 요청
            $.ajax({
                url: "${pageContext.request.contextPath}/tudio/findMemberPw",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(data),
                success: function(res) {
                    // res는 서버에서 보낸 MemberVO 객체
                    if (res && res.memberEmail) {
                        $("#findPwArea").hide();
                        $("#targetEmail").text(res.memberEmail);
                        $("#resultArea").fadeIn();
                        sweetAlert("success", "임시 비밀번호가 발송되었습니다!");
                    }
                },
                error: function() {
                    sweetAlert("error", "일치하는 회원 정보가 없습니다.");
                }
            });
        });
    });
</script>
</body>
</html>