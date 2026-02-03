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
    <div class="signup-container shadow border bg-white p-5" style="max-width: 800px; margin: 50px auto; border-radius: 15px;">
        <h2 class="text-center mb-4 fw-bold">기업 회원가입 신청</h2>

        <form action="/tudio/clientSignup" method="post" enctype="multipart/form-data" id="signupForm">
			<c:if test="${not empty param.token}">
				<input type="hidden" name="token" value="${param.token}">
			</c:if>
			
            <input type="hidden" name="companyNoStatus" id="companyNoStatus" value="N">
            <input type="hidden" name="emailStatus" id="emailStatus" value="N">
            <input type="hidden" id="idCheckFlag" value="N">
            
            <div class="info-section">
                <div class="section-title fw-bold">담당자 정보</div>
                <div class="mb-4 text-center">
                    <img id="imagePreview" src="#" alt="미리보기">
                    <label for="profileImageFile" class="btn btn-sm btn-outline-secondary d-block m-auto" style="width: 150px;">프로필 사진 선택</label>
                    <input type="file" class="d-none" name="profileImageFile" id="profileImageFile" accept="image/*">
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold required-dot">아이디</label>
                        <div class="input-group">
                            <input type="text" class="form-control" name="memberId" id="memberId" required>
                            <button class="btn btn-outline-primary" type="button" id="idCheckBtn">중복확인</button>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold required-dot">담당자 성함</label> 
                        <input type="text" class="form-control" name="memberName" required>
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
                        <small id="pwMatchMsg"></small>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold required-dot">담당부서</label>
                        <input type="text" class="form-control" name="memberDepartment" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold required-dot">직급/직책</label>
                        <input type="text" class="form-control" name="memberPosition" required>
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
                    <label class="form-label fw-bold required-dot">담당자 이메일</label>
			<c:choose>
				<%-- 초대받은 경우 --%>
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
						<input type="email" class="form-control" name="memberEmail" id="memberEmail" placeholder="example@email.com" required>
					  	<button class="btn btn-outline-dark" type="button" id="sendEmailBtn">인증번호 발송</button>
					</div>
				</c:otherwise>
			</c:choose>
                </div>
			
			<c:if test="${empty param.token}">
                <div class="mb-3" id="emailAuthArea" style="display:none;">
                    <div class="input-group">
                        <input type="text" class="form-control" id="emailAuthCode" placeholder="인증번호 입력">
                        <button class="btn btn-success" type="button" id="verifyEmailBtn">인증확인</button>
                    </div>
                </div>
			</c:if>
                <div class="row mb-3">
					<div class="col-md-12">
						<label class="form-label fw-bold required-dot">담당자 생년월일</label>
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
            </div>
            

            <div class="info-section">
                <div class="section-title fw-bold">기업 정보</div>
                <div class="row mb-3">
                    <div class="col-md-12">
                        <label class="form-label fw-bold required-dot">사업자등록번호</label>
                        <div class="input-group">
                            <input type="text" class="form-control" name="companyNo" id="companyNo" placeholder="'-' 제외 10자리 입력" required>
                            <button class="btn btn-secondary" type="button" id="checkCompanyBtn">조회</button>
                        </div>
                        <div id="companySearchBtnArea" class="mt-2" style="display:none;">
                            <button type="button" class="btn btn-sm btn-info w-100 text-white" id="searchCompanyBtn">신규 업체 API 검색</button>
                        </div>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold required-dot">기업명</label>
                        <input type="text" class="form-control" name="companyName" id="companyName" readonly required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold required-dot">대표자명</label>
                        <input type="text" class="form-control" name="companyCeoName" id="companyCeoName" readonly required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold required-dot">기업 대표 전화번호</label>
                    <input type="text" class="form-control" name="companyTel" id="companyTel" readonly required>
                	<small class="text-muted">하이픈(-)을 포함하여 입력해주세요.</small>
                </div>

                <div class="mb-3">
				    <label class="form-label fw-bold required-dot">기업 주소</label>
				    <div class="input-group mb-2" style="max-width: 400px;">
				        <input type="text" class="form-control" name="companyPostcode" id="companyPostcode" readonly placeholder="우편번호" required>
				        <button type="button" class="btn btn-secondary" onclick="DaumPostcode()">주소 검색</button>
				    </div>
				    
				    <input type="text" class="form-control mb-2" name="companyAddr1" id="companyAddr1" readonly placeholder="기본주소" required>
				    <input type="text" class="form-control mb-2" name="companyAddr2" id="companyAddr2" placeholder="상세주소를 입력해주세요">
				    
				    <div id="map" style="width:100%; height:300px; display:none; border-radius: 10px; border: 1px solid #ddd;"></div>
				</div>
                <div class="mb-3" id="fileUploadArea" style="display:none;">
                    <label class="form-label fw-bold required-dot">사업자등록증 사본</label>
                    <input type="file" class="form-control" name="bizFile" id="bizFile">
                    <small class="text-danger">* 신규 업체인 경우 반드시 파일을 첨부해야 합니다.</small>
                </div>
            </div>

            <div class="mb-4 form-check">
                <input type="checkbox" class="form-check-input" id="selectiveConsent_chk" required>
                <label class="form-check-label" for="selectiveConsent_chk">마케팅 정보 수신 및 이용약관 동의 (필수)</label>
            </div>

            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary btn-lg fw-bold">가입 요청</button>
                <a href="/tudio/login" class="btn btn-light">취소</a>
            </div>
        </form>
    </div>

<script>
$(function() {
	
    // 1. 이미지 미리보기
    $('#profileImageFile').on('change', function(e) {
        let file = e.target.files[0];
        if (file && file.type.match('image.*')) {
            let reader = new FileReader();
            reader.onload = function(e) { $('#imagePreview').attr('src', e.target.result).show(); }
            reader.readAsDataURL(file);
        }
    });

    // 2. 이메일 발송 & 인증
    $('#sendEmailBtn').on('click', function() {
        let email = $('#memberEmail').val();
        if(!email) { Swal.fire('경고', '이메일을 입력하세요.', 'warning'); return; }
        $.ajax({
            url: "/tudio/emailAuthCode",
            type: "post",
            data: JSON.stringify({"memberEmail": email}),
            contentType: "application/json",
            success: function(res) {
                if(res === "SUCCESS") { 
                    Swal.fire('성공', '인증번호 발송!', 'success');
                    $('#emailAuthArea').show(); 
                }
            }
        });
    });

    $('#verifyEmailBtn').on('click', function() {
        let code = $('#emailAuthCode').val();
        $.ajax({
            url: "/tudio/verifyAuthCode",
            type: "post",
            data: JSON.stringify({"inputCode": code}),
            contentType: "application/json",
            success: function(res) {
                if(res === "MATCH") {
                    $('#emailStatus').val('Y');
                    Swal.fire('인증 성공', '이메일이 인증되었습니다.', 'success');
                } else {
                    Swal.fire('인증 실패', '인증번호를 확인하세요.', 'error');
                }
            }
        });
    });

    // 3. 기업 DB 조회
    $('#checkCompanyBtn').on('click', function() {
        let comNo = $('#companyNo').val();
        if(!comNo) { Swal.fire('경고', '사업자번호를 입력하세요.', 'warning'); return; }

        $.ajax({
            url: '/bizno/checkDb',
            type: 'GET',
            data: { companyNo: comNo },
            success: function(res) {
                if (res.status === 'SUCCESS') {
                    // DB에 있는 경우: 모든 정보 자동 세팅 및 수정 불가(readonly)
                    $('#companyName').val(res.companyName).prop('readonly', true);
                    $('#companyCeoName').val(res.companyCeoName).prop('readonly', true);
                    $('#companyTel').val(res.companyTel).prop('readonly', true);
                    $('#companyAddr1').val(res.companyAddr1).prop('readonly', true);
                    $('#companyAddr2').val(res.companyAddr2).prop('readonly', true);
                    
                    $('#companySearchBtnArea').hide();
                    $('#fileUploadArea').hide();
                    $('#companyNoStatus').val('Y');
                    Swal.fire('확인', '등록된 기업 정보가 연동되었습니다.', 'success');
                } else {
                    // DB에 없는 경우: 입력창 초기화 및 API 버튼 노출
                    $('#companyName, #companyCeoName, #companyTel, #companyAddr1, #companyAddr2').val("").prop('readonly', true);
                    $('#companySearchBtnArea').show();
                    $('#fileUploadArea').hide();
                    $('#companyNoStatus').val('N');
                    Swal.fire('알림', '신규 업체입니다. API 조회를 진행해 주세요.', 'info');
                }
            }
        });
    });

    // 4. API 조회 클릭 시
    $('#searchCompanyBtn').on('click', function() {
        let comNo = $('#companyNo').val();
        $.ajax({
            url: '/bizno/checkApi',
            type: 'GET',
            data: { companyNo: comNo },
            success: function(res) {
                if (res.resultCode === 0) {
                    // API 조회 성공 시 기업명 세팅 및 나머지 수기 입력 활성화
                    $('#companyName').val(res.companyName).prop('readonly', true);
                    activateManualInput();
                    Swal.fire('성공', '기업명이 확인되었습니다. 나머지 정보를 입력하세요.', 'success');
                } else {
                    // 한도 초과나 조회 실패 시 기업명까지 직접 입력
                    activateManualInput();
                    $('#companyName').prop('readonly', false).focus();
                    Swal.fire('알림', '직접 정보를 입력해 주세요.', 'info');
                }
            }
        });
    });

    function activateManualInput() {
        $('#companyCeoName, #companyTel, #companyAddr1, #companyAddr2').prop('readonly', false);
        $('#fileUploadArea').show();
        $('#companyNoStatus').val('Y');
    }

    // 5. 아이디 중복 확인
    $('#idCheckBtn').on('click', function() {
        let id = $('#memberId').val();
        if(!id) return;
        $.ajax({
            url: "/tudio/idCheck",
            type: "post",
            data: JSON.stringify({"memberId": id}),
            contentType: "application/json",
            success: function(res) {
                if(res === "NOTEXSIST") {
                    $('#idCheckFlag').val('Y');
                    Swal.fire('성공', '사용 가능한 아이디입니다.', 'success');
                } else {
                    $('#idCheckFlag').val('N');
                    Swal.fire('중복', '이미 존재하는 아이디입니다.', 'error');
                }
            }
        });
    });

    // 6. 비밀번호 일치 확인
    $('#memberPwConfirm').on('keyup', function() {
        let pw = $('#memberPw').val();
        let confirm = $(this).val();
        if(pw === confirm) {
            $('#pwMatchMsg').text('비밀번호가 일치합니다.').css('color', 'green');
        } else {
            $('#pwMatchMsg').text('비밀번호가 일치하지 않습니다.').css('color', 'red');
        }
    });

 	// 7. 주민등록번호 합치기 로직
    let $regNo1 = $('#regNo1');
    let $regNo2 = $('#regNo2');
    let $totalRegNo = $('#memberRegno');

    let updateRegNo = function() {
        $totalRegNo.val($regNo1.val() + $regNo2.val());
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

    // 상세주소 입력 후 포커스가 나갈 때 지도를 갱신하는 함수
    $('#companyAddr2').on('focusout', function() {
        let addr1 = $("#companyAddr1").val();
        let addr2 = $("#companyAddr2").val();
        
        if(addr1) {
            showMap(addr1 + " " + addr2);
        }
    });
 
    // 8. 폼 제출 유효성 검사
    $('#signupForm').on('submit', function(e) {
        if($('#idCheckFlag').val() !== 'Y') {
            Swal.fire('경고', '아이디 중복 확인을 해주세요.', 'warning');
            e.preventDefault(); return;
        }
        if($('#emailStatus').val() !== 'Y') {
            Swal.fire('경고', '이메일 인증을 완료해주세요.', 'warning');
            e.preventDefault(); return;
        }
        if($('#companyNoStatus').val() !== 'Y') {
            Swal.fire('경고', '기업 조회를 완료해주세요.', 'warning');
            e.preventDefault(); return;
        }

        let $memberTel = $('#memberTel');
        $memberTel.val($memberTel.val().replace(/-/g, ""));

        let $companyTel = $('#companyTel');
        $companyTel.val($companyTel.val().replace(/-/g, ""));

        let regno = $('#regNo1').val() + $('#regNo2').val();
        $('#memberRegno').val(regno); 

        let $companyNo = $('#companyNo');
        $companyNo.val($companyNo.val().replace(/-/g, ""));

        if(!$('#selectiveConsent_chk').is(':checked')){
            Swal.fire('경고', '필수 약관에 동의해주세요.', 'warning');
            e.preventDefault(); return false;
        }
    });
    
    
    
});

//7. 카카오 주소 및 지도 관련 함수
function DaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {

            var addr = data.address;
            document.getElementById('companyPostcode').value = data.zonecode;
            document.getElementById("companyAddr1").value = addr;
            document.getElementById("companyAddr2").focus();
            showMap(addr);
        }
    }).open();
}

//지도를 생성하고 마커를 찍는 공통 함수
function showMap(fullAddress) {
    var mapContainer = document.getElementById('map'); 
    mapContainer.style.display = "block"; // 지도 영역 보이기

    var mapOption = {
        center: new kakao.maps.LatLng(33.450701, 126.570667),
        level: 3
    };

    var map = new kakao.maps.Map(mapContainer, mapOption);
    var geocoder = new kakao.maps.services.Geocoder();

    geocoder.addressSearch(fullAddress, function(result, status) {
        if (status === kakao.maps.services.Status.OK) {
            var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

            var marker = new kakao.maps.Marker({
                map: map,
                position: coords
            });

            var infowindow = new kakao.maps.InfoWindow({
                content: '<div style="width:150px;text-align:center;padding:6px 0;">기업 위치</div>'
            });
            infowindow.open(map, marker);

            map.setCenter(coords);
        }
    });
}


</script>

<jsp:include page="/WEB-INF/views/include/footer.jsp"/>
<!-- appkey 에 본인 앱키넣기  -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=본인 앱키 넣기&libraries=services"></script>

</body>
</html>