<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tudio - Project Workspace</title>
    
    <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footer.css">
    
    <style>
        body, main, .footer, header.fixed-top { margin-left: 0 !important; padding-left: 0 !important; left: 0 !important; }
        .footer { background-color: #343a40; color: #fff; padding: 60px 0 30px; width: 100% !important; margin-top: auto; }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/views/include/headerGuest.jsp"/>

    <main>
        <section class="hero-section">
            <div class="ambient-blob blob-1"></div>
            <div class="ambient-blob blob-2"></div>

            <div class="hero-content">
                <h2 class="hero-tagline">
                    완벽한 프로젝트의 마침표를 찍다
                </h2>

                <h1 class="hero-brand">
                    Tudi
                    <svg class="tudio-circle-svg" viewBox="0 0 100 100">
                        <circle class="circle-bg" cx="50" cy="50" r="40"></circle>
                        <circle class="circle-progress" cx="50" cy="50" r="40"></circle>
                    </svg>
                </h1>
                
                <p class="hero-desc">
                    흩어진 일정, 쏟아지는 피드백, 복잡한 리소스 관리.<br>
                    Tudio 하나로 오직 <b>성공</b>에만 집중하세요.
                </p>
                
                <div>
                    <a href="${pageContext.request.contextPath}/tudio/memberType" class="btn-cta">지금 무료로 시작하기</a>
                </div>
            </div>
        </section>

        <section class="scroll-container">
            <div class="container sticky-wrapper">
                <div class="scroll-content">
                    <div class="step-block active" data-index="0">
                        <span class="step-num">Step 01. Planning</span>
                        <h2 class="step-title">계획은 치밀하게<br>실행은 간결하게</h2>
                        <p class="step-desc">드래그 앤 드롭으로 일정을 관리하고 타임라인을 구축하세요. 복잡한 WBS도 Tudio에서는 클릭 한 번으로 관리됩니다.</p>
                    </div>
                    <div class="step-block" data-index="1">
                        <span class="step-num">Step 02. Tracking</span>
                        <h2 class="step-title">진척도를 한눈에<br>놓치는 업무 없이</h2>
                        <p class="step-desc">실시간으로 연동되는 칸반 보드와 간트 차트로 팀원들의 업무 과부하 상태를 미리 파악하고 조율하세요.</p>
                    </div>
                    <div class="step-block" data-index="2">
                        <span class="step-num">Step 03. Goal</span>
                        <h2 class="step-title">고객사 피드백도<br>하나의 흐름으로</h2>
                        <p class="step-desc">이메일과 메신저를 오갈 필요 없습니다. 고객사를 프로젝트에 초대하여 직접 피드백을 받고 승인받으세요.</p>
                    </div>
                </div>

                <div class="sticky-image-area">
    
				    <div class="ui-screen active" id="screen-0">
				        <div class="mock-header">
				            <span class="mock-title">2026년 1월 전체 일정</span>
				            <div><span class="mock-btn active"></span><span class="mock-btn"></span></div>
				        </div>
				        <div class="mock-calendar-wrapper">
				            <div class="mock-cal-header-row">
				                <span class="mock-cal-day">일</span><span class="mock-cal-day">월</span>
				                <span class="mock-cal-day">화</span><span class="mock-cal-day">수</span>
				                <span class="mock-cal-day">목</span><span class="mock-cal-day">금</span>
				                <span class="mock-cal-day">토</span>
				            </div>
				            <div class="mock-cal-grid">
				                <div class="mock-cal-cell" style="grid-column: span 7;">
				                    <div class="mock-cal-bar bar-blue" style="width: 40%;">시스템 정기 운영 및 모니터링</div>
				                </div>
				                <div class="mock-cal-cell" style="grid-column: span 7; display: grid; grid-template-columns: subgrid;">
				                    <div style="grid-column: 2 / span 3;" class="mock-cal-bar bar-red">이벤트 배너 스케줄러 수정</div>
				                    <div style="grid-column: 5 / span 3;" class="mock-cal-bar bar-yellow">클라우드 인스턴스 점검</div>
				                </div>
				                <div class="mock-cal-cell" style="grid-column: span 7; display: grid; grid-template-columns: subgrid;">
				                    <div style="grid-column: 1 / span 4;" class="mock-cal-bar bar-blue">올리브영 유지보수 프로젝트</div>
				                </div>
				                 <div class="mock-cal-cell" style="grid-column: span 7; display: grid; grid-template-columns: subgrid;">
				                    <div style="grid-column: 3 / span 5;" class="mock-cal-bar bar-yellow">API 응답 상태 전수 조사</div>
				                </div>
				            </div>
				        </div>
				    </div>
				
				    <div class="ui-screen" id="screen-1">
				        <div class="mock-header">
				            <span class="mock-title">업무 목록 (Kanban)</span>
				            <span class="text-muted small">Sprint 24</span>
				        </div>
				        <div class="mock-kanban-board">
				            <div class="mock-kb-col">
				                <div class="mock-kb-header">TO DO <span class="text-primary">2</span></div>
				                <div class="mock-kb-card">
				                    <span class="kb-tag tag-blue">필터 UI</span>
				                    <span class="kb-title">상세 조건 필터 기능 구현</span>
				                    <div class="kb-progress-bg"><div class="kb-progress-bar" style="width: 0%"></div></div>
				                </div>
				                <div class="mock-kb-card">
				                    <span class="kb-tag tag-blue">퍼블리싱</span>
				                    <span class="kb-title">이벤트 페이지 마크업</span>
				                    <div class="kb-progress-bg"><div class="kb-progress-bar" style="width: 0%"></div></div>
				                </div>
				            </div>
				            <div class="mock-kb-col">
				                <div class="mock-kb-header">IN PROGRESS <span class="text-primary">1</span></div>
				                <div class="mock-kb-card">
				                    <span class="kb-tag tag-red">긴급</span>
				                    <span class="kb-title">DB 인덱스 최적화 점검</span>
				                    <div class="d-flex justify-content-between align-items-center mt-2">
				                        <div class="user-avatar" style="width: 20px; height: 20px;"></div>
				                        <span class="small text-muted">60%</span>
				                    </div>
				                    <div class="kb-progress-bg mt-1"><div class="kb-progress-bar" style="width: 60%"></div></div>
				                </div>
				            </div>
				            <div class="mock-kb-col">
				                <div class="mock-kb-header">DONE <span class="text-success">5</span></div>
				                <div class="mock-kb-card">
				                    <span class="kb-tag tag-blue">모니터링</span>
				                    <span class="kb-title">Lighthouse 점수 개선</span>
				                    <div class="kb-progress-bg"><div class="kb-progress-bar" style="width: 100%; background: #40c057;"></div></div>
				                </div>
				            </div>
				        </div>
				    </div>
				
				    <div class="ui-screen" id="screen-2">
				        <div class="mock-header">
				            <span class="mock-title">전자 결재 및 승인</span>
				            <button class="btn btn-sm btn-primary py-0" style="font-size: 0.8rem;">+ 결재 작성</button>
				        </div>
				        
				        <div class="d-flex gap-3 mb-4">
				            <div class="p-3 border rounded bg-light flex-fill text-center">
				                <span class="d-block small text-muted">결재 진행</span>
				                <span class="fw-bold text-primary fs-5">2건</span>
				            </div>
				            <div class="p-3 border rounded bg-light flex-fill text-center">
				                <span class="d-block small text-muted">반려</span>
				                <span class="fw-bold text-danger fs-5">1건</span>
				            </div>
				            <div class="p-3 border rounded bg-light flex-fill text-center">
				                <span class="d-block small text-muted">승인 완료</span>
				                <span class="fw-bold text-success fs-5">14건</span>
				            </div>
				        </div>
				
				        <div class="mock-list-wrapper">
				            <div class="mock-approval-card">
				                <span class="ap-status status-done">완료</span>
				                <div class="ap-info">
				                    <span class="ap-title">기능 추가 대응에 대한 인력 요청의 건</span>
				                    <span class="ap-meta">2026-01-29 · 김수정</span>
				                </div>
				                <div class="user-avatar"></div>
				            </div>
				            
				            <div class="mock-approval-card">
				                <span class="ap-status status-temp">임시보관</span>
				                <div class="ap-info">
				                    <span class="ap-title">장바구니 UI 개선을 통한 전환율 향상 방안</span>
				                    <span class="ap-meta">2026-01-29 · 작성 중</span>
				                </div>
				                <div class="user-avatar"></div>
				            </div>
				
				            <div class="mock-approval-card">
				                <span class="ap-status status-wait">대기</span>
				                <div class="ap-info">
				                    <span class="ap-title">긴급 운영 및 장애 대응 승인 요청</span>
				                    <span class="ap-meta">2026-01-27 · 카카오뱅크 내부 관리자</span>
				                </div>
				                <div class="user-avatar"></div>
				            </div>
				        </div>
				    </div>
				</div>
            </div>
        </section>

        <section class="bento-section">
            <div class="container">
                <h2 class="text-center fw-bold mb-5 display-6">팀을 위한 강력한 도구상자</h2>
                <div class="bento-grid js-scroll reveal-hidden">
                    <div class="bento-item bento-large">
                        <h3 class="bento-title">📊 실시간 대시보드</h3>
                        <p class="bento-desc">프로젝트의 모든 지표를 한 화면에서 모니터링하세요. 커스터마이징 가능한 위젯을 제공합니다.</p>
                    </div>
                    <div class="bento-item">
                        <h3 class="bento-title">💬 인앱 메신저</h3>
                        <p class="bento-desc">사리지지 않는 채팅창과 함께 업무 문맥을 잃지 않고 즉시 소통합니다.  </p>
                    </div>
                    <div class="bento-item bento-tall">
                        <h3 class="bento-title">🤖 AI 어시스턴트</h3>
                        <p class="bento-desc mt-3">복잡한 기안 결재, 튜디오 AI에게<br>"기안 작성 도와줘" 라고 요청해 보세요. A부터 Z까지 당신의 업무를 보조합니다.</p>
                    </div>
                    <div class="bento-item">
                        <h3 class="bento-title">📂 팀 내 드라이브</h3>
                        <p class="bento-desc">Tudio 하나로 폴더와 파일 관리까지 가능합니다.</p>
                    </div>
                    <div class="bento-item bento-large">
                        <h3 class="bento-title">📋 온라인&오프라인 회의실</h3>
                        <p class="bento-desc">Team Studio, 화상채팅과 회의실 예약으로 온오프라인 통합 회의공간을 제공합니다. 회의록으로 더 완성도 높은 회의를 경험해 보세요.</p>
                    </div>
                </div>
            </div>
        </section>

        <section class="stats-section">
            <div class="container">
                <div class="row">
                    <div class="col-md-4 mb-4 stat-item js-scroll reveal-hidden">
                        <h3><span class="count-up" data-target="200">0</span>%</h3>
                        <p>업무 효율 증가율</p>
                    </div>
                    <div class="col-md-4 mb-4 stat-item js-scroll reveal-hidden delay-100">
                        <h3><span class="count-up" data-target="5000">0</span>+</h3>
                        <p>함께하는 기업</p>
                    </div>
                    <div class="col-md-4 mb-4 stat-item js-scroll reveal-hidden delay-200">
                        <h3><span class="count-up" data-target="98">0</span>%</h3>
                        <p>고객 만족도</p>
                    </div>
                </div>
            </div>
        </section>

        <section class="py-5 text-center bg-light">
            <div class="container py-5 js-scroll reveal-hidden">
                <h2 class="fw-bold mb-4">이제, 프로젝트 관리는 Tudio에게 맡기세요.</h2>
                <a href="${pageContext.request.contextPath}/tudio/memberType" class="btn-cta">무료로 시작하기</a>
            </div>
        </section>

        <section class="logo-section border-top bg-white py-5">
            <div class="container-fluid text-center mb-4">
                 <p class="text-muted small fw-bold tracking-wide">TRUSTED BY INNOVATIVE TEAMS</p>
            </div>
            <div class="logo-slider-wrap">
                <div class="logo-slider">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Samsung_wordmark.svg/7051px-Samsung_wordmark.svg.png" alt="Samsung">
                    
                    <img src="https://upload.wikimedia.org/wikipedia/commons/7/7b/Meta_Platforms_Inc._logo.svg" alt="Meta">
                    
                    <img src="https://upload.wikimedia.org/wikipedia/commons/2/21/Nvidia_logo.svg" alt="NVIDIA">
                    
                    <img src="https://cdn.worldvectorlogo.com/logos/berkshire-hathaway.svg" alt="Berkshire Hathaway">
                    
                    <span class="logo-badge">DDIT</span>
                </div>
                
                <div class="logo-slider">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Samsung_wordmark.svg/7051px-Samsung_wordmark.svg.png" alt="Samsung">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/7/7b/Meta_Platforms_Inc._logo.svg" alt="Meta">
                    <img src="https://upload.wikimedia.org/wikipedia/commons/2/21/Nvidia_logo.svg" alt="NVIDIA">
                    <img src="https://cdn.worldvectorlogo.com/logos/berkshire-hathaway.svg" alt="Berkshire Hathaway">
                    <span class="logo-badge">DDIT</span>
                </div>
            </div>
        </section>
        
    </main>

    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-3">
                    <h5>Tudio</h5>
                    <p class="small">팀 프로젝트 스튜디오</p>
                    <address class="small">
                        (주)튜터 | 대표: 홍길동<br>
                        주소: 서울특별시 Tudio구 창작로 123 | 사업자 등록 번호: 123-45-67890<br>
                        대표 전화: 02-1234-5678 | 이메일: support@tudio.com
                    </address>
                </div>
                <div class="col-md-2 col-6 mb-3">
                    <h6>서비스</h6>
                    <ul class="list-unstyled">
                        <li><a href="about.html">회사 소개</a></li>
                        <li><a href="features.html">주요 기능</a></li>
                        <li><a href="pricing.html">가격 정책</a></li>
                    </ul>
                </div>
                <div class="col-md-2 col-6 mb-3">
                    <h6>지원</h6>
                    <ul class="list-unstyled">
                        <li><a href="notice.html">공지사항</a></li>
                        <li><a href="faq.html">자주 묻는 질문</a></li>
                        <li><a href="contact.html">문의하기</a></li>
                    </ul>
                </div>
                <div class="col-md-4 mb-3">
                    <h6>법적 고지</h6>
                    <ul class="list-unstyled">
                        <li><a href="terms.html">이용약관</a></li>
                        <li><a href="privacy.html">개인정보처리방침</a></li>
                        <li><a href="legal.html">법적 고지</a></li>
                    </ul>
                </div>
            </div>
            <hr class="border-top mt-2 mb-3">
            <div class="text-center">
                <p class="mb-0 small">&copy; 2025 Tudio Tech Inc. All Rights Reserved.</p>
            </div>
        </div>
    </footer>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>