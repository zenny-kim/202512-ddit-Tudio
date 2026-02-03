<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    /* 전체 높이 재계산: 상단(30px) + 메인(44px) = 74px */
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
        display: flex;
        align-items: center;
        z-index: 1030;
    }

    /* [2단] 메인 내비게이션 */
    .main-navbar-wrapper {
   		width: 100%;
        height: 100%;
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
    }
    
    .hlink {
    	margin-bottom : 0;
    	font-size: 1rem;
    }

    /* 사이드바 위치 보정 */
    .sidebar {
        top: var(--local-header-height) !important;
        height: calc(100vh - var(--local-header-height)) !important;
    }
</style>
<header class="fixed-top header-container-wrapper">
	<nav class="navbar navbar-expand-lg navbar-light bg-white main-navbar-wrapper">
		<div class="container-fluid p-0">

			<%-- 로고 --%>
            <a class="navbar-brand tudio-brand" href="${pageContext.request.contextPath}/tudio/main" style="padding: 0; margin: 0; display: flex; align-items: center;">
                <span class="text-primary brand-text-adjusted">Tudio</span>
            </a>
            
            <%-- 
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#mainNav"
				aria-controls="mainNav" aria-expanded="false"
				aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			--%>			

			<ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-4">
				<li class="nav-item">
					<a class="nav-link fw-bold hlink" href="${pageContext.request.contextPath}/tudio/notice/list">공지사항</a>
				</li>
				<li class="nav-item"><a class="nav-link hlink" href="${pageContext.request.contextPath}/tudio/faq/list">FAQ</a></li>
			</ul>

			<div class="d-flex align-items-center ms-auto">
				<a href="${pageContext.request.contextPath}/tudio/login" class="btn btn-outline-primary me-2">로그인</a>
				<a href="${pageContext.request.contextPath}/tudio/memberType" class="btn btn-primary">회원가입</a>
			</div>
		</div>
	</nav>
</header>