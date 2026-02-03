<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 1. 세션 체크 --%>
<c:if test="${empty loginUser}">
    <script>
        alert("세션이 만료되었습니다. 다시 로그인해주세요.");
        location.href = "${pageContext.request.contextPath}/tudio/login";
    </script>
</c:if>

<style>
    /* [수정 1] 전체 높이 재계산: 상단(30px) + 메인(44px) = 74px */
    :root {
        --local-header-height: 74px; 
    }

    /* 본문 여백 조정 */
    body {
        padding-top: var(--local-header-height) !important;
    }

    /* 헤더 전체 틀 */
    .header-container-wrapper {
        height: var(--local-header-height);
        background-color: #fff;
        border-bottom: 1px solid #dee2e6;
        z-index: 1030;
    }

    /* [수정 2] 상단 유틸리티 바 높이 늘리기 (여유 공간 확보) */
    .top-utility-bar {
        height: 30px; /* 기존 22px -> 30px로 변경하여 위아래 간격 확보 */
        background-color: #fff;
        border-bottom: none !important;
        display: flex;
        align-items: center;
        justify-content: flex-end;
        padding: 0 42px 0 25px;
        font-size: 15px;
    }
    .top-utility-link {
        color: #888;
        text-decoration: none;
        margin-left: 15px;
        transition: color 0.2s;
    }
    .top-utility-link:hover { color: #0d6efd; }
    .utility-divider { color: #e0e0e0; margin-left: 15px; }

    /* [2단] 메인 내비게이션 (높이 44px 유지) */
    .main-navbar-wrapper {
        height: 44px; 
        padding: 0 20px;
        display: flex;
        align-items: center;
    }
    
    /* 로고 스타일 */
    .brand-text-adjusted {
        font-size: 1.5rem;       
        letter-spacing: -0.5px;
        font-weight: 800;
        line-height: 1;
        
        display: flex;
        align-items: center;
        
        /* 로고 위치 미세 조정 (-10px은 너무 과해서 -3px 정도로 수정 권장) */
        position: relative;
        top: -15px; 
    }

    /* 사이드바 위치 보정 */
    .sidebar {
        top: var(--local-header-height) !important;
        height: calc(100vh - var(--local-header-height)) !important;
    }
    
    
    
    
    
    
    
</style>

<header class="fixed-top header-container-wrapper">

    <%-- [1단] 상단 유틸리티 바 --%>
    <div class="top-utility-bar">
        <a href="${pageContext.request.contextPath}/tudio/notice/list" class="top-utility-link">공지사항</a>
        <span class="utility-divider">|</span>
        <a href="${pageContext.request.contextPath}/tudio/faq/list" class="top-utility-link">FAQ</a>
        <span class="utility-divider">|</span>
        <a href="${pageContext.request.contextPath}/tudio/inquiry/list" class="top-utility-link">문의사항</a>
        <span class="utility-divider">|</span>
        <a href="${pageContext.request.contextPath}/tudio/survey/detail/3" class="top-utility-link">설문</a>
    </div>

    <%-- [2단] 메인 헤더 --%>
    <nav class="navbar navbar-expand-lg navbar-light bg-white main-navbar-wrapper">
        <div class="container-fluid p-0">
            <%-- 로고 --%>
            <a class="navbar-brand tudio-brand" href="${pageContext.request.contextPath}/tudio/dashboard" style="padding: 0; margin: 0; display: flex; align-items: center;">
                <span class="text-primary brand-text-adjusted">Tudio</span>
            </a>

            <div class="d-flex align-items-center ms-auto">
                <%-- 알림 --%>
                  <div class="dropdown me-2 position-relative">
				    <button id="headerNotiBtn"
				            class="header-icon-btn text-secondary"
				            type="button"
				            data-bs-toggle="dropdown"
				            data-bs-auto-close="outside"
				            style="width: 32px; height: 32px;">
				        <i class="bi bi-bell"></i>
				        <span id="headerNotiDot" class="notification-badge d-none"></span>
				    </button>
				
				    <!-- ✅ 토스트는 dropdown-menu(패널) 밖, 버튼과 같은 dropdown wrapper 안에 둬야 함 -->
				    <div id="notiLoginToast" class="noti-login-toast d-none" role="button" tabindex="0">
				        새 알림이 도착했습니다
				    </div>
				
				    <jsp:include page="/WEB-INF/views/include/notificationPanel.jsp" />
				</div>

                <%-- 프로필 --%>
                <div class="dropdown">
                    <a class="header-profile dropdown-toggle text-dark d-flex align-items-center text-decoration-none" href="#" role="button" data-bs-toggle="dropdown">
                        <span class="profile-img me-2" style="width:28px; height:28px; border-radius:50%; overflow:hidden; display:inline-flex;">
                            <img src="${pageContext.request.contextPath}${loginUser.memberProfileimg}" 
                                 alt="Profile" style="width:100%; height:100%; object-fit:cover;"
                                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/default_profile.png';">
                        </span>
                        <span class="fw-bold small d-none d-sm-block">
                            ${loginUser.memberName} 님
                        </span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/tudio/memberMypage">마이페이지</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/tudio/notice/list">고객센터</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">로그아웃</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>
</header>