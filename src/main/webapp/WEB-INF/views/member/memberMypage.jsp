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
<jsp:include page="/WEB-INF/views/include/headerUser.jsp"/>
<div class="signup-container">
    <div class="profile-section">
	    <div class="profile-thumb-wrapper">
	        <div class="thumb-round-box">
	            <img src="${pageContext.request.contextPath}${memberVO.memberProfileimg}" class="profile-thumb" id="profilePrev">
	        </div>
	        
	        <label for="profileUpload" class="profile-edit-label" id="profileEditBtn">📸</label>
	    </div>
	    <h2 class="signup-title mt-3">
		    <span style="font-weight: 600; color: var(--primary-color);">${memberVO.memberName} </span>님의 마이페이지
		</h2>
	</div>

    <form id="modifyForm" action="${pageContext.request.contextPath}/tudio/memberModify" method="post" enctype="multipart/form-data">
        
        <input type="file" id="profileUpload" name="profileImageFile" style="display:none;" accept="image/*">
        
        <input type="hidden" name="memberName" value="${memberVO.memberName}">
		<input type="hidden" name="memberId" value="${memberVO.memberId}">
		<input type="hidden" name="memberNo" value="${memberVO.memberNo}">
		<h4 class="mt-5 mb-3" style="color: var(--primary-color); font-weight: 700;">개인정보</h4>
        <table class="info-table">
            <tr>
                <th>아이디</th>
                <td><span style="font-weight: 800; color: var(--primary-color);">${memberVO.memberId}</span></td>
            </tr>

            <tr class="edit-mode-only hidden">
                <th>새 비밀번호</th>
                <td>
                    <input type="password" name="memberPw" id="memberPw" class="form-control" placeholder="변경할 비밀번호 입력">
                    <input type="password" id="memberPwConfirm" class="form-control mt-2" placeholder="비밀번호 확인">
                    <div id="pwMatchMsg" class="edit-help-text"></div>
                </td>
            </tr>
			<tr>
		        <th>부서 / 직책</th>
		        <td>
		            <div class="display-text">${memberVO.memberDepartment} / ${memberVO.memberPosition}</div>
		            <div class="edit-input-group" style="gap: 10px;">
		                <input type="text" name="memberDepartment" class="form-control edit-input" value="${memberVO.memberDepartment}">
		                <input type="text" name="memberPosition" class="form-control edit-input" value="${memberVO.memberPosition}">
		            </div>
		        </td>
		    </tr>
            <tr>
                <th>연락처</th>
                <td>
                    <span class="display-text">${memberVO.memberTel}</span>
                    <input type="text" name="memberTel" class="form-control edit-input hidden" value="${memberVO.memberTel}">
                </td>
            </tr>

            <tr>
                <th>이메일</th>
                <td>
                    <span class="display-text">${memberVO.memberEmail}</span>
                    <div class="edit-input-group">
                        <input type="email" name="memberEmail" id="memberEmail" class="form-control" value="${memberVO.memberEmail}">
                        <button type="button" class="btn btn-outline-primary btn-sm" id="btnSendEmail">인증</button>
                    </div>
                    <div class="edit-input-group mt-2" id="emailAuthGroup">
                        <input type="text" id="emailAuthCode" class="form-control" placeholder="인증번호 입력">
                        <button type="button" class="btn btn-primary btn-sm" id="btnVerifyEmail">확인</button>
                    </div>
                </td>
            </tr>

            <tr>
                <th>회사 정보</th>
                <td>
                    <div class="display-text">
                        ${memberVO.companyName} / ${memberVO.companyNo}
                    </div>
                    <div class="edit-input-group">
                        <input type="text" name="companyNo" id="companyNo" class="form-control" value="${memberVO.companyNo}" placeholder="사업자번호">
                        <button type="button" class="btn btn-outline-primary btn-sm" id="btnBizCheck">조회</button>
                    </div>
                    <input type="text" name="companyName" id="companyName" class="form-control edit-input mt-2 hidden" value="${memberVO.companyName}" readonly>
                </td>
            </tr>
        </table>
        <hr/>
		<h4 class="mt-5 mb-3" style="color: var(--primary-color); font-weight: 700;">알림</h4>
		<table class="info-table noti-table">
		    <tr>
		        <th>프로젝트 공지 알림</th>
		        <td>
		            <div class="form-check form-switch">
		                <input class="form-check-input noti-check" type="checkbox" name="notificationSettingVO.notiProjectNotice" 
		                       value="Y" ${memberVO.notificationSettingVO.notiProjectNotice == 'Y' ? 'checked' : ''} disabled>
		                <span class="noti-status-text">${memberVO.notificationSettingVO.notiProjectNotice == 'Y' ? 'ON' : 'OFF'}</span>
		            </div>
		        </td>
		    </tr>
		    <tr>
		        <th>업무 댓글 알림</th>
		        <td>
		            <div class="form-check form-switch">
		                <input class="form-check-input noti-check" type="checkbox" name="notificationSettingVO.notiTaskComment" 
		                       value="Y" ${memberVO.notificationSettingVO.notiTaskComment == 'Y' ? 'checked' : ''} disabled>
		                <span class="noti-status-text">${memberVO.notificationSettingVO.notiTaskComment == 'Y' ? 'ON' : 'OFF'}</span>
		            </div>
		        </td>
		    </tr>
		    <tr>
		        <th>게시글 댓글 알림</th>
		        <td>
		            <div class="form-check form-switch">
		                <input class="form-check-input noti-check" type="checkbox" name="notificationSettingVO.notiBoComment" 
		                       value="Y" ${memberVO.notificationSettingVO.notiBoComment == 'Y' ? 'checked' : ''} disabled>
		                <span class="noti-status-text">${memberVO.notificationSettingVO.notiBoComment == 'Y' ? 'ON' : 'OFF'}</span>
		            </div>
		        </td>
		    </tr>
		    <tr>
		        <th>일정 알림</th>
		        <td>
		            <div class="form-check form-switch">
		                <input class="form-check-input noti-check" type="checkbox" name="notificationSettingVO.notiSchedule" 
		                       value="Y" ${memberVO.notificationSettingVO.notiSchedule == 'Y' ? 'checked' : ''} disabled>
		                <span class="noti-status-text">${memberVO.notificationSettingVO.notiSchedule == 'Y' ? 'ON' : 'OFF'}</span>
		            </div>
		        </td>
		    </tr>
		    <tr>
		        <th>사이트 공지 알림</th>
		        <td>
		            <div class="form-check form-switch">
		                <input class="form-check-input noti-check" type="checkbox" name="notificationSettingVO.notiSite" 
		                       value="Y" ${memberVO.notificationSettingVO.notiSite == 'Y' ? 'checked' : ''} disabled>
		                <span class="noti-status-text">${memberVO.notificationSettingVO.notiSite == 'Y' ? 'ON' : 'OFF'}</span>
		            </div>
		        </td>
		    </tr>
		</table>
        <div class="mypage-btn-area">
            <button type="button" id="btnEdit" class="btn btn-primary btn-mypage">회원정보 수정</button>
            <button type="submit" id="btnSave" class="btn btn-primary btn-mypage hidden">저장하기</button>
            <button type="button" id="btnCancel" class="btn btn-cancel-custom btn-mypage hidden">취소</button>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp"/>

</body>

<script type="text/javascript">
$(function() {
    // 상태 체크 변수 (기본값은 이미 등록된 정보이므로 Y)
    let emailStatus = "Y";
    let companyNoStatus = "Y";

    // [수정] 버튼 클릭 시 화면 전환
    $('#btnEdit').on('click', function() {
        $('.display-text').addClass('hidden');
        $('.edit-input').removeClass('hidden').show();
        $('.edit-input-group').css('display', 'flex'); 
        $('.edit-mode-only').removeClass('hidden');
        $('#profileEditBtn').show();
        $(this).addClass('hidden');
        $('#btnSave, #btnCancel').removeClass('hidden');
        $('.noti-check').removeAttr('disabled');
    });
    
    $(document).on('change', '.noti-check', function() {
        const statusText = $(this).is(':checked') ? 'ON' : 'OFF';
        $(this).siblings('.noti-status-text').text(statusText);
    });
     
    // 1. 이메일 인증번호 발송 (회원가입 로직과 동일)
    $('#btnSendEmail').on('click', function() {
        let memberEmail = $('#memberEmail').val();
        if(!memberEmail) {
            Swal.fire('경고', '이메일을 입력해주세요.', 'warning');
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
                    $('#emailAuthArea').css('display', 'flex'); // 인증번호 입력칸 보이기
                    emailStatus = "N"; // 메일을 새로 보냈으므로 인증 전 상태로 변경
                } else {
                    Swal.fire('오류', '메일 발송에 실패했습니다.', 'error');
                }
            }
        });
    });

    // 2. 이메일 인증번호 확인
    $('#btnVerifyEmail').on('click', function() {
        let inputCode = $('#emailAuthCode').val();
        $.ajax({
            url: "/tudio/verifyAuthCode",
            type: "post",
            data: JSON.stringify({"inputCode": inputCode}),
            contentType: "application/json;charset=utf-8",
            success: function(res) {
                if (res === "MATCH") {
                    emailStatus = "Y"; 
                    Swal.fire('성공', '인증되었습니다.', 'success');
                    $('#emailAuthArea').hide();
                } else {
                    emailStatus = "N";
                    Swal.fire('실패', '인증번호가 틀렸습니다.', 'error');
                }
            }
        });
    });

 // 3. 사업자번호 조회
    $('#btnBizCheck').on('click', function() {
        let comNo = $('#companyNo').val();
        let $nameInput = $('#companyName');

        if (!comNo) {
            Swal.fire('경고', '사업자번호를 입력해주세요.', 'warning');
            return;
        }

        //DB 조회
        $.ajax({
            url: '/bizno/checkDb',
            type: 'GET',
            data: { companyNo: comNo },
            success: function(res) {
                if (res.status === 'SUCCESS') {
                    // DB에 있는 경우: 자동 입력 및 완료 처리
                    $nameInput.val(res.companyName).prop('readonly', true).removeClass('hidden').show();
                    companyNoStatus = "Y";
                    Swal.fire('성공', '등록된 기업이 확인되었습니다.', 'success');
                } else {
                    // DB에 없는 경우: API 조회 의사 확인
                    Swal.fire({
                        title: 'DB 등록 정보 없음',
                        text: 'DB에 등록되지 않은 업체입니다. API 조회를 진행할까요?',
                        icon: 'info',
                        showCancelButton: true,
                        confirmButtonText: 'API 조회',
                        cancelButtonText: '취소'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            // API 조회 함수 호출
                            fetchFromBizApi(comNo);
                        }
                    });
                }
            }
        });
    });

    //checkApi 로직
    function fetchFromBizApi(comNo) {
        let $nameInput = $('#companyName');
        
        $.ajax({
            url: '/bizno/checkApi', // 회원가입과 동일한 엔드포인트
            type: 'GET',
            data: { companyNo: comNo },
            success: function(res) {
                // 회원가입 시 resultCode === 0 이 성공이었으므로 동일하게 처리
                if (res.resultCode === 0) {
                    $nameInput.val(res.companyName).prop('readonly', true).removeClass('hidden').show();
                    companyNoStatus = "Y";
                    Swal.fire('성공', 'API 조회를 통해 기업정보를 가져왔습니다.', 'success');
                } 
                else if (res.resultCode === -1 || res.resultCode === -3) {
                    // 한도 초과나 미등록 시 직접 입력 허용 로직
                    Swal.fire('알림', '조회 한도 초과 또는 미등록 업체입니다. 회사명을 직접 입력해주세요.', 'info');
                    $nameInput.val("").prop('readonly', false).removeClass('hidden').show().focus();
                    $nameInput.attr("placeholder", "회사명을 직접 입력하세요.");
                    companyNoStatus = "Y"; // 직접 입력했으므로 진행 가능하게 처리
                } else {
                    Swal.fire('오류', '오류가 발생했습니다. (코드: ' + res.resultCode + ')', 'error');
                    companyNoStatus = "N";
                }
            }
        });
    }

    // 4. 비밀번호 실시간 체크
    $('#memberPwConfirm').on('keyup', function() {
        let pw = $('#memberPw').val();
        let confirm = $(this).val();
        let $msg = $('#pwMatchMsg');

        if(pw === "" && confirm === "") {
            $msg.text("");
        } else if(pw === confirm) {
            $msg.text("비밀번호가 일치합니다.").css('color', 'blue');
        } else {
            $msg.text("비밀번호가 일치하지 않습니다.").css('color', 'red');
        }
    });

    // 5. 저장(Submit) 전 유효성 검사
    $('#modifyForm').on('submit', function(e) {
        if (emailStatus !== "Y") {
            Swal.fire('경고', '이메일 인증을 완료해주세요.', 'warning');
            return false;
        }
        
        if (companyNoStatus !== "Y") {
            Swal.fire('경고', '사업자 조회를 완료해주세요.', 'warning');
            return false;
        }

        // 비밀번호를 입력했다면 일치 확인
        let pw = $('#memberPw').val();
        let pwConfirm = $('#memberPwConfirm').val();
        if(pw !== "" && pw !== pwConfirm) {
            Swal.fire('경고', '비밀번호가 일치하지 않습니다.', 'warning');
            return false;
        }
        
        $('.noti-check').each(function() {
            // 1. 기존 체크박스의 name을 변수에 저장하고 삭제 (중복 전송 방지)
            let originalName = $(this).attr('name');
            if(originalName) {
                $(this).removeAttr('name');
                
                // 2. 체크 상태에 따라 'Y' 또는 'N' 결정
                let finalValue = $(this).is(':checked') ? 'Y' : 'N';
                
                // 3. 숨겨진 input을 생성해서 폼에 추가
                $('<input>').attr({
                    type: 'hidden',
                    name: originalName,
                    value: finalValue
                }).appendTo('#modifyForm');
            }
        });

        // 연락처 하이픈 제거 후 전송
        let telInput = $('input[name="memberTel"]');
        telInput.val(telInput.val().replace(/-/g, ""));
    });

    $('#btnCancel').on('click', function() {
        if(confirm("수정을 취소하시겠습니까?")) location.reload();
    });

    $('#profileUpload').on('change', function(e) {
        let file = e.target.files[0];
        if (file) {
            // 이미지 파일인지 확인
            if (!file.type.match('image.*')) {
                Swal.fire('경고', '이미지 파일만 선택 가능합니다.', 'warning');
                return;
            }

            let reader = new FileReader();
            reader.onload = function(e) {
                // 파일을 읽어서 이미지 태그의 src를 변경 (미리보기)
                $('#profilePrev').attr('src', e.target.result);
            }
            reader.readAsDataURL(file);
        }
    });
    
    
});
</script>
</html>