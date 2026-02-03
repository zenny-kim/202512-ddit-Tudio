<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Tudio - 이용약관</title>
    <jsp:include page="/WEB-INF/views/include/common.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/project_common.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.14/index.global.min.js"></script>
    <style>
        /* 약관 내용 박스 스타일 */
        .terms-box {
            border: 1px solid #dee2e6;
            border-radius: 0.25rem;
            padding: 2rem;
            background-color: #fff;
            max-height: 700px;
            overflow-y: auto;
            line-height: 1.6;
            font-size: 0.95rem;
            white-space: pre-line;
        }
        .terms-title {
            font-weight: bold;
            font-size: 1.1rem;
            margin-top: 20px;
            margin-bottom: 10px;
            color: #333;
        }
        .footer {
        	margin-left: 0px;
        	background-color: #343a40;
        	color: #fff !important;
        	--bs-text-opacity: 1;
        }
    </style>
</head>
<body>

	<c:choose>
		<c:when test="${not empty loginUser}">
			<%-- 로그인 상태일 때 기존 사용자 전용 헤더 --%>
			<jsp:include page="./include/headerUser.jsp" />
		</c:when>
	    <c:otherwise>
	        <%-- 비로그인 상태일 때--%>
	        <jsp:include page="./include/headerGuest.jsp" />
	    </c:otherwise>
	</c:choose>
	
   <main class="py-5" style="background-color: #f8f9fa;">

   	<section class="container">
        <h2 class="fw-bold text-center mb-5 mt-4">TUDIO 이용약관</h2>

        <div class="terms-box shadow-sm">
            <h4 class="fw-bold text-center mb-4">TUDIO 프로젝트 관리 시스템 이용약관</h4>
            <p>본 약관은 TUDIO(이하 "회사")가 제공하는 프로젝트 관리 시스템 서비스(이하 "서비스")의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 합니다.</p>

            <div class="terms-title">제1조 (목적)</div>
            본 약관은 회사가 제공하는 TUDIO 프로젝트 관리 시스템을 이용함에 있어 회사와 이용자 간의 권리·의무 및 책임사항, 이용 조건과 절차 등 기본적인 사항을 규정함을 목적으로 합니다.

            <div class="terms-title">제2조 (용어의 정의)</div>
            본 약관에서 사용하는 용어의 정의는 다음과 같습니다.
            1. "서비스"란 회사가 제공하는 TUDIO 프로젝트 관리 시스템 및 이에 부수된 모든 기능을 의미합니다.
            2. "이용자"란 본 약관에 따라 회사와 이용계약을 체결하고 서비스를 이용하는 개인 또는 법인을 말합니다.
            3. "관리자"란 이용자 소속 조직 내에서 프로젝트 생성, 인력 배정, 결재 요청 등의 관리 권한을 부여받은 자를 의미합니다.
            4. "프로젝트"란 서비스 내에서 업무 수행을 목적으로 생성되는 관리 단위를 의미합니다.
            5. "업무"란 프로젝트 내에서 관리되는 주요 작업 단위를 의미합니다.
            6. "단위업무"란 하나의 업무를 구성하는 세부 실행 작업을 의미합니다.
            7. "콘텐츠"란 이용자가 서비스 내에 등록하거나 생성한 문서, 데이터, 게시물, 파일 등 일체의 정보를 의미합니다.

            <div class="terms-title">제3조 (약관의 효력 및 변경)</div>
            1. 본 약관은 서비스를 이용하고자 하는 모든 이용자에게 그 효력을 가집니다.
            2. 회사는 관련 법령을 위반하지 않는 범위에서 본 약관을 개정할 수 있습니다.
            3. 약관이 변경되는 경우 회사는 변경된 약관의 적용일자 및 변경 사유를 명시하여 서비스 내 공지사항을 통해 사전 공지합니다.
            4. 이용자가 변경된 약관에 동의하지 않을 경우 서비스 이용을 중단하고 이용계약을 해지할 수 있습니다.

            <div class="terms-title">제4조 (이용계약의 체결)</div>
            1. 이용계약은 이용자가 본 약관에 동의하고 회사가 이를 승인함으로써 체결됩니다.
            2. 회사는 다음 각 호에 해당하는 경우 이용계약의 체결을 거절하거나 사후에 해지할 수 있습니다.
               - 허위 정보를 제공한 경우
               - 타인의 정보를 도용한 경우
               - 서비스 운영을 고의로 방해한 경우

            <div class="terms-title">제5조 (서비스의 제공 및 변경)</div>
            1. 회사는 이용자에게 다음과 같은 서비스를 제공합니다.
               - 프로젝트 및 업무 관리 기능
               - 일정 관리 및 간트차트 제공
               - 커뮤니케이션 및 화상미팅 기능
               - 결재 및 승인 관리 기능
               - 문서 공유 및 협업 기능
            2. 회사는 서비스의 일부 또는 전부를 변경할 수 있으며, 중요한 변경 사항은 사전에 공지합니다.

            <div class="terms-title">제6조 (서비스 이용시간)</div>
            1. 서비스는 연중무휴, 1일 24시간 제공함을 원칙으로 합니다.
            2. 시스템 점검, 장애 발생, 기타 불가피한 사유가 있는 경우 서비스 제공이 일시 중단될 수 있습니다.

            <div class="terms-title">제7조 (이용자의 의무)</div>
            1. 이용자는 관계 법령, 본 약관 및 회사가 정한 운영 정책을 준수해야 합니다.
            2. 이용자는 서비스 이용 과정에서 다음 각 호의 행위를 하여서는 안 됩니다.
               - 불법 정보의 게시
               - 타인의 권리 침해
               - 서비스의 정상적인 운영을 방해하는 행위

            <div class="terms-title">제8조 (관리자의 권한 및 책임)</div>
            1. 관리자는 프로젝트 생성, 업무 및 단위업무 관리, 결재 요청 등의 권한을 가집니다.
            2. 관리자는 소속 이용자의 권한 관리 및 콘텐츠 관리에 대한 책임을 부담합니다.

            <div class="terms-title">제9조 (콘텐츠의 관리 및 권리)</div>
            1. 서비스 내에 등록된 콘텐츠의 저작권은 해당 콘텐츠를 등록한 이용자 또는 소속 조직에 귀속됩니다.
            2. 회사는 서비스 운영 및 개선을 위해 필요한 범위 내에서 콘텐츠를 이용할 수 있습니다.

            <div class="terms-title">제10조 (개인정보 보호)</div>
            회사는 개인정보 보호 관련 법령을 준수하며, 개인정보의 수집·이용·보호에 관한 사항은 별도의 개인정보처리방침에 따릅니다.

            <div class="terms-title">제11조 (서비스 이용 제한 및 중지)</div>
            회사는 이용자가 본 약관을 위반한 경우 사전 통지 없이 서비스 이용을 제한하거나 중지할 수 있습니다.

            <div class="terms-title">제12조 (책임의 제한)</div>
            1. 회사는 천재지변, 불가항력적 사유로 인한 서비스 중단에 대해 책임을 지지 않습니다.
            2. 회사는 이용자의 귀책사유로 발생한 손해에 대해 책임을 지지 않습니다.

            <div class="terms-title">제13조 (계약 해지 및 이용 종료)</div>
            1. 이용자는 언제든지 서비스 이용계약을 해지할 수 있습니다.
            2. 이용계약 해지 시 이용자의 데이터 처리에 관한 사항은 별도의 정책에 따릅니다.

            <div class="terms-title">제14조 (분쟁 해결)</div>
            본 약관과 관련하여 회사와 이용자 간 분쟁이 발생한 경우, 상호 협의를 통해 해결함을 원칙으로 합니다.

            <div class="terms-title">제15조 (준거법 및 관할)</div>
            본 약관은 대한민국 법률을 준거법으로 하며, 서비스 이용과 관련하여 발생한 분쟁에 대해서는 회사의 본점 소재지를 관할하는 법원을 전속 관할로 합니다.

            <div class="terms-title">부칙</div>
            본 약관은 2026년 1월 1일부터 시행합니다.
        </div>
    	</section>
	</main>


	<footer class="footer py-3 border-top">
	    <div class="container">
	        <div class="row">
	            <div class="col-md-6 text-center text-md-start">
	                <span class="small">&copy; 2026 Tudio. All rights reserved.</span>
	            </div>
	            <div class="col-md-6 text-center text-md-end">
	                <a href="#" class="small me-3">이용약관</a>
	                <a href="#" class="small">개인정보처리방침</a>
	            </div>
	        </div>
	    </div>
	</footer>

</body>
</html>