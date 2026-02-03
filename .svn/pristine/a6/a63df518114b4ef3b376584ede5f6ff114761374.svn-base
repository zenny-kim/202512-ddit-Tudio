<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tudio Admin System</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/siteAdminMain.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/log_login.css">
</head>

<body class="admin-mode">

    <jsp:include page="../include/header_site.jsp"/>
    
    <div class="d-flex">
        <jsp:include page="../include/sidebar_site.jsp" />

        <main class="main-content-wrap flex-grow-1">
            <div id="loading-spinner" class="text-center mt-5" style="display:none;">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>

            <div id="dynamic-content" class="container-fluid pt-4">
                </div>
        </main>
    </div>
    
    <jsp:include page="../include/footer.jsp"/>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/footer.js"></script>

    <script>
        // 초기 화면 설정
        $(document).ready(function() {
        	var initUrl = "${pageContext.request.contextPath}/admin/user/list";
            
            loadPage(initUrl, null);
        });

        /*
         * 페이지 비동기 로드 함수
         * @param url : 불러올 페이지 경로 (Controller URL 권장)
         * @param element : 클릭한 사이드바 메뉴 요소 (this)
         */
        function loadPage(url, element) {
            
            // 1. 메뉴 활성화 표시 (Active 클래스 이동)
            if (element) {
                // 사이드바의 모든 active 제거
                $('.nav-link').removeClass('active'); 
                // 현재 클릭한 메뉴에 active 추가
                $(element).addClass('active');        
            }

            // 2. 로딩 시작 (스피너 표시)
            $('#dynamic-content').hide();
            $('#loading-spinner').show();

            // 3. 실제 페이지 내용을 가져와서 갈아끼움
            $('#dynamic-content').load(url, function(response, status, xhr) {
                
                // 로딩 끝 (스피너 숨김)
                $('#loading-spinner').hide();
                $('#dynamic-content').fadeIn(200); // 부드럽게 나타나기

                if (status == "error") {
                    // 에러 발생 시 처리
                    var msg = '<div class="alert alert-danger text-center mt-5">';
                    msg += '<h4><i class="bi bi-exclamation-triangle-fill"></i> 페이지 로드 실패</h4>';
                    msg += '<p>요청하신 페이지를 불러올 수 없습니다. (' + xhr.status + ' ' + xhr.statusText + ')</p>';
                    msg += '</div>';
                    $('#dynamic-content').html(msg);
                }
            });
        }
    </script>
</body>
</html>