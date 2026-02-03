<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
	<title>Tudio</title>
	<jsp:include page="/WEB-INF/views/include/common.jsp" />
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/member.css">
</head>

<body>
<jsp:include page="/WEB-INF/views/include/headerGuest.jsp"/>
	<div class="signup-container shadow border">
		<h2 class="text-center mb-4 ">프로젝트 사용자 회원가입</h2>

		<form action="/tudio/memberSignup" method="post" enctype="multipart/form-data">
		
			<c:if test="${not empty param.token}">
				<input type="hidden" name="token" value="${param.token}">
			</c:if>
					
			<input type="hidden" name="companyNoStatus" id="companyNoStatus" value="N">
			<input type="hidden" name="emailStatus" id="emailStatus" value="N">
			<input type="hidden" id="idCheckFlag" value="N">
			
			<div class="mb-4 text-center">
				<label class="form-label fw-bold d-block">프로필 이미지</label>
				<img id="imagePreview" src="#" alt="미리보기" style="width: 120px; height: 120px; border-radius: 50%; object-fit: cover; display: none; margin: 10px auto; border: 2px solid #ddd;">
				<input type="file" class="form-control" name="profileImageFile" id="profileImageFile" accept="image/*">
			</div>

			<hr>

			<div class="row mb-3">
				<div class="col-md-6">
					<label class="form-label fw-bold required-dot">아이디</label>
					<div class="input-group">
						<input type="text" class="form-control" name="memberId" id="memberId" required>
						<button class="btn btn-outline-primary" type="button" id="idCheckBtn">중복확인</button>
					</div>
				</div>
				<div class="col-md-6">
					<label class="form-label fw-bold required-dot">이름</label> <input type="text" class="form-control" name="memberName" required>
				</div>
			</div>

			<div class="row mb-3">
				<div class="col-md-6">
					<label class="form-label fw-bold required-dot">비밀번호</label>
					<input type="password" class="form-control" id="memberPw" name="memberPw" required>
				</div>
				<div class="col-md-6">
					<label class="form-label fw-bold required-dot">비밀번호 확인</label>
					<input type="password" class="form-control" name="memberPwConfirm" id="memberPwConfirm" required>
					<span id="pwMatchMsg" class="error-msg"></span>
				</div>
			</div>
			<div class="row mb-3">
			    <div class="col-md-12">
			        <label class="form-label fw-bold required-dot">연락처</label>
			        <input type="text" class="form-control" name="memberTel" id="memberTel" placeholder="010-0000-0000" required>
			        <small class="text-muted">하이픈(-)을 포함하여 입력해주세요.</small>
			    </div>
			</div>
			<div class="mb-3">
				<label class="form-label fw-bold required-dot">이메일</label>
		<c:choose>
			<%-- 1. 초대 토큰이 있는 경우 (초대받은 사용자) --%>
			<c:when test="${not empty param.token}">
				<div class="input-group">
					<input type="email" class="form-control" name="memberEmail" id="memberEmail" 
						value="${param.email}" readonly style="background-color: #e9ecef;">
					<button class="btn btn-secondary" type="button" disabled>초대 확인됨</button>
				</div>
				<small class="text-success fw-bold mt-1 d-block">
					<i class="bi bi-check-circle-fill"></i> 초대받은 이메일로 가입이 진행됩니다.
				</small>
				<script>
					$(function() {
						// 초대 토큰이 있으면 이메일 인증 패스 (Status = Y)
						$('#emailStatus').val('Y');
					});
				</script>
			</c:when>
					
			<%-- 일반 가입 --%>
			<c:otherwise>
				<div class="input-group">
					<input type="email" class="form-control" name="memberEmail" id="memberEmail" placeholder="example@email.com">
					<button class="btn btn-outline-dark" type="button" id="sendEmailBtn">인증번호 발송</button>
				</div>
			</c:otherwise>
		</c:choose>
			</div>

		<c:if test="${empty param.token}">
			<div class="mb-3" id="emailAuthArea">
				<div class="input-group">
					<input type="text" class="form-control" id="emailAuthCode" placeholder="인증번호 6자리 입력">
					<button class="btn btn-success" type="button" id="verifyEmailBtn">인증확인</button>
				</div>
				<div id="emailResultMsg"></div>
				<small class="text-muted">이메일로 발송된 번호를 입력해주세요.</small>
			</div>
		</c:if>

			<div class="row mb-3">
				<div class="col-md-6">
					<label class="form-label fw-bold required-dot">사업자등록번호</label>
					<div class="input-group">
						<input type="text" class="form-control" name="companyNo" id="companyNo" placeholder="'-' 제외 입력">
						<button class="btn btn-outline-secondary" type="button" id="checkCompanyBtn">조회</button>
					</div>
				</div>
				<div class="col-md-6">
					<label class="form-label fw-bold required-dot">회사명</label> <input type="text"
						class="form-control" id="companyName" readonly name="companyName"
						placeholder="번호 조회 시 자동 입력">
					<div id="companySearchBtnArea" class="mt-2">
						<button type="button" class="btn btn-sm btn-info w-100 text-white" id="searchCompanyBtn">신규 업체 검색</button>
					</div>
				</div>
			</div>
			<div class="row mb-3">
				<div class="col-md-12">
					<label class="form-label fw-bold required-dot">생년월일</label>
					<div class="input-group">
						<input type="text" class="form-control" id="regNo1" maxlength="6" placeholder="앞 6자리" required style="flex: 2;">
						<span class="input-group-text">-</span>
						<input type="text" class="form-control" id="regNo2" maxlength="1" placeholder="뒤 1자리" required style="flex: 0.8; text-align: center; min-width: 60px;">
						<span class="input-group-text">● ● ● ● ● ●</span>
						<input type="hidden" name="memberRegno" id="memberRegno">
					</div>
					<small class="text-muted">본인 확인을 위해 주민번호 앞자리와 뒷자리 첫 번째 숫자를 입력해주세요.</small>
				</div>
			</div>
			<div class="row mb-3">
				<div class="col-md-6">
					<label class="form-label fw-bold">부서</label>
					<input type="text" class="form-control" name="memberDepartment">
				</div>
				<div class="col-md-6">
					<label class="form-label fw-bold required-dot">직책</label>
					<input type="text" class="form-control" name="memberPosition">
				</div>
			</div>

			<div class="mb-4 form-check">
				<input type="hidden" id="selectiveConsent_hidden" name="selectiveConsent" value="N">
				<input type="checkbox" class="form-check-input" id="selectiveConsent_chk">
				<label class="form-check-label" for="selectiveConsent required-dot">마케팅 정보 수신 동의 (필수)</label>
			</div>

			<div class="d-grid gap-2">
				<button type="submit" class="btn btn-primary btn-lg">회원가입 완료</button>
				<a href="/tudio/login" class="btn btn-light">이전으로</a>
			</div>
		</form>
	</div>
<script type="text/javascript">
$(function() {
	//마케팅 동의 선택 시 값 변경
	$('#selectiveConsent_chk').on('change', function() {
        if($(this).is(':checked')) {
            $('#selectiveConsent_hidden').val('Y');
        } else {
            $('#selectiveConsent_hidden').val('N');
        }
    });
	
    // 1. 프로필 이미지 파일 체크 및 미리보기
    $('#profileImageFile').on('change', function(e) {
        let file = e.target.files[0];
        let $preview = $('#imagePreview');

        if (!file) return;

        if (!file.type.match('image.*')) {
            Swal.fire({
                icon: 'error',
                title: '파일 형식 오류',
                text: '이미지 파일(jpg, png 등)만 업로드 가능합니다.',
                confirmButtonColor: '#0d6efd'
            });
            $(this).val(''); 
            $preview.hide();
            return;
        }

        let reader = new FileReader();
        reader.onload = function(e) {
            $preview.attr('src', e.target.result).show();
        }
        reader.readAsDataURL(file);
    });

    // 2. 이메일 인증번호 처리
    $('#sendEmailBtn').on('click', function() {
    	let memberEmail = $('#memberEmail').val();
    	console.log("입력된 이메일: " + memberEmail);
        if(!memberEmail) {
            sweetAlert('warning', '이메일을 입력해주세요.');
            return;
        }
        $.ajax({
            url: "${pageContext.request.contextPath}/tudio/emailAuthCode",
            type: "post",
            data: JSON.stringify({"memberEmail": memberEmail}),
            contentType: "application/json;charset=utf-8",
            dataType: "text",
            success: function(res) {
                if(res === "SUCCESS") {
                    Swal.fire('발송 완료', '인증번호가 이메일로 발송되었습니다.', 'success');
                    $('#emailAuthArea').show();
                } else {
                    sweetAlert('error', '메일 발송에 실패했습니다.');
                    console.log(res);
                }
            },
            error: function(xhr) {
                console.log("AJAX ERROR:", xhr.status, xhr.responseText);
                Swal.fire('요청 실패', `status=${xhr.status}\n${xhr.responseText}`, 'error');
        	}
        });
    });
    
    // 인증번호 확인 버튼
    $('#verifyEmailBtn').on('click', function() {
    	let inputCode = $('#emailAuthCode').val();
        
        $.ajax({
            url: "/tudio/verifyAuthCode",
            type: "post",
            data: JSON.stringify({"inputCode": inputCode}),
            contentType: "application/json;charset=utf-8",
            success: function(res) {
                if (res === "MATCH") {
                    $('#emailResultMsg').html('<span style="color:green;">인증 성공!</span>');
                    $('#emailStatus').val('Y'); 
                    sweetAlert('success', '인증되었습니다.');
                } else {
                    $('#emailResultMsg').html('<span style="color:red;">인증번호가 틀렸습니다.</span>');
                    $('#emailStatus').val('N');
                }
            }
        });
    });

 	// 3. 사업자번호 조회 버튼 클릭
    $('#checkCompanyBtn').on('click', function() {
        let comNo = $('#companyNo').val();
        let $nameInput = $('#companyName');
        let $apiBtnArea = $('#companySearchBtnArea');

        if (!comNo) {
            sweetAlert('warning', '사업자번호를 입력해주세요.');
            return;
        }

        $.ajax({
            url: '/bizno/checkDb', // 서버측 URL (예시)
            type: 'GET',
            data: { companyNo: comNo },
            success: function(res) {
                if (res.status === 'SUCCESS') {
                    // DB에 있는 경우
                    $nameInput.val(res.companyName).prop('readonly', true);
                    $apiBtnArea.hide();
                    $('#companyNoStatus').val('Y');
                    sweetAlert('success', '등록된 기업이 확인되었습니다.');
                } else {
                    // DB에 없는 경우 -> API 버튼을 보여줌
                    $nameInput.val("").attr("placeholder", "DB에 등록된 업체가 없습니다. API 조회를 진행하세요.");
                    $apiBtnArea.show();
                    $('#companyNoStatus').val('N');
                }
            }
        });
    });
 
 
   	// 3-1. db 값이 없다면 api 사용
	$('#searchCompanyBtn').on('click', function() {
	    let comNo = $('#companyNo').val();
	    let $nameInput = $('#companyName');
	
	    $.ajax({
	        url: '/bizno/checkApi', // 서버측 API 호출 URL (예시)
	        type: 'GET',
	        data: { companyNo: comNo },
	        success: function(res) {
	            // res.resultCode는 비즈노 API가 주는 코드값
	            if (res.resultCode === 0) {
	                // API 조회 성공
	                $nameInput.val(res.companyName).prop('readonly', true);
	                $('#companyNoStatus').val('Y');
	                sweetAlert('success', '조회를 통해 기업정보를 가져왔습니다.');
	            } 
	            else if (res.resultCode === -1 || res.resultCode === -3) {
	                // 질문하신 오류 코드 처리 (오류코드 -1: 미등록, -3: 한도초과 시에만 셀프작성), 
	                sweetAlert('info', '조회 한도 초과 또는 미등록 사용자입니다. 회사명을 직접 입력해주세요.');
	                $nameInput.prop('readonly', false).focus(); // 입력창 활성화
	                $nameInput.attr("placeholder", "회사명을 직접 입력하세요.");
	                $('#companyNoStatus').val('Y'); // 직접 입력했으므로 진행 가능하게 처리
	            } else {
	                sweetAlert('error', '오류가 발생했습니다. (코드: ' + res.resultCode + ')');
	                // 오류 -2 : 파라미터 오류, -9 : 기타 오류
	            }
	        }
	    });
	});

   	
    // 4. 비밀번호 실시간 일치 확인
    $('#memberPwConfirm').on('keyup', function() {
        let pw = $('#memberPw').val();
        let confirm = $(this).val();
        let $msg = $('#pwMatchMsg');

        if(pw === confirm) {
            $msg.text("비밀번호가 일치합니다.").attr('class', 'success-msg');
        } else {
            $msg.text("비밀번호가 일치하지 않습니다.").attr('class', 'error-msg');
        }
    });
    
    // 5. 주민등록번호 합치기 로직
    let $regNo1 = $('#regNo1');
    let $regNo2 = $('#regNo2');
    let $totalRegNo = $('#memberRegno');

    let updateRegNo = function() {
        $totalRegNo.val($regNo1.val() + "-" + $regNo2.val());
    };

    $regNo1.on('input', updateRegNo);
    $regNo2.on('input', updateRegNo);

    // 숫자만 입력 제한 및 자동 포커스 이동
    $regNo1.on('keyup', function() {
        $(this).val($(this).val().replace(/[^0-9]/g, ''));
        if ($(this).val().length === 6) $regNo2.focus(); // 6자리 다 치면 다음 칸으로
    });
    $regNo2.on('keyup', function() {
        $(this).val($(this).val().replace(/[^0-9]/g, ''));
    });

    // 6. 아이디 중복 확인 (참고하신 $.ajax 형식으로 통일)
    $('#idCheckBtn').on('click', function() {
        let id = $('#memberId').val();

        if (!id) {
            sweetAlert('warning', '아이디를 입력해주세요.');
            return;
        }

        $.ajax({
            url : "/tudio/idCheck",
            type : "post",
            data : JSON.stringify({"memberId": id}),
            contentType : "application/json;charset=utf-8",
            success : function(res){
                console.log("서버 응답:", res);
                if(res === "NOTEXSIST"){
                    sweetAlert("success", "사용 가능한 아이디입니다.");
                    $('#idCheckFlag').val("Y");
                } else {
                    sweetAlert("error", "이미 사용 중인 아이디입니다.");
                    $('#memberId').val("");
                    $('#idCheckFlag').val("N"); 
                    $('#memberId').focus();
                }
            },
            error : function(xhr) {
                console.error(xhr);
                sweetAlert("error", "서버 통신 중 오류가 발생했습니다.");
            }
        });
    });
    $('#memberId').on('input', function() {
        $('#idCheckFlag').val("N");
    });
    
    // 7. 회원가입 폼 제출 시 유효성 검사
    $('form').on('submit', function(e) {
        let idFlag = $('#idCheckFlag').val();
        let emailFlag = $('#emailStatus').val();
        let companyFlag = $('#companyNoStatus').val();

        if (idFlag !== "Y") {
            sweetAlert('warning', '아이디 중복 확인을 진행해주세요.');
            $('#memberId').focus();
            e.preventDefault();
            return false;
        }

        if (emailFlag !== "Y") {
            sweetAlert('warning', '이메일 인증을 완료해주세요.');
            e.preventDefault();
            return false;
        }
        
        let telInput = $('#memberTel');
        let telValue = telInput.val().replace(/-/g, "");
        telInput.val(telValue); // 숫자만 남은 값 서버로 전송
        
        let companyInput = $('#companyNo');
        let companyValue = companyInput.val().replace(/-/g, ""); 
        companyInput.val(companyValue);
        
        let regno = $('#regNo1').val().trim() + $('#regNo2').val().trim();
        $('#memberRegno').val(regno);

        if ($('#selectiveConsent_hidden').val() !== "Y") {
            sweetAlert('warning', '필수 약관에 동의해주세요.');
            e.preventDefault();
            return false;
        }
        const fileInput = $('#profileImageFile')[0];
        if (!fileInput.files || fileInput.files.length === 0) {
          sweetAlert('warning', '프로필 이미지를 등록해주세요.');
          $('#profileImageFile').focus();
          e.preventDefault();
          return false;
        }
        
    });
    
    //엔터 누르면 다음 input 으로 이동 -> 다 이동 후에는 form 제출
    $('form input').on('keydown', function(e) {
        if (e.which === 13) { // 엔터 키
            e.preventDefault();    
            //현재 입력창의 다음 input 요소를 찾음
            let $next = $('form input').eq($('form input').index(this) + 1);
            if ($next.length) {
                $next.focus(); 
            } else {
                $('form').submit(); 
            }
        }
    })
    
    
});
</script>
<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
</body>
</html>