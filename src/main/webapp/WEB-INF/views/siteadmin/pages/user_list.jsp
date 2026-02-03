<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 
    파일명: user_list.jsp
    설명: 관리자 회원 관리 (전체, 일반, 기업, 탈퇴 회원 조회 및 상세 수정)
--%>

<div class="main-content-wrap flex-grow-1">
    <div class="container-fluid">
        
        <nav class="breadcrumb-nav mb-4">
            <span class="text-muted">Admin</span>
            <span class="sep"><i class="bi bi-chevron-right small"></i></span>
            <span class="text-primary fw-bold">회원 관리</span>
        </nav>

        <div class="card admin-card">
            <div class="admin-card-header d-flex justify-content-between align-items-center flex-wrap pb-0 border-0">
                <h5 class="fw-bold mb-3">회원 관리</h5>
            </div>
            
            <div class="d-flex justify-content-between align-items-center px-4 mb-2">
                <ul class="nav custom-tabs" id="userMgmtTabs">
                    <li class="nav-item"><a class="nav-link active" data-tab="all">전체</a></li>
                    <li class="nav-item"><a class="nav-link" data-tab="general">일반</a></li>
                    <li class="nav-item"><a class="nav-link" data-tab="company">기업</a></li>
                    <li class="nav-item"><a class="nav-link" data-tab="withdrawal">탈퇴</a></li>
                </ul>
                <div>
                    <span class="text-muted small me-2">회원 목록 Total 1,280</span>
                    <button class="btn btn-primary btn-sm px-3 fw-bold" onclick="alert('신규 회원 등록 모달 오픈')">신규 회원 등록</button>
                </div>
            </div>

            <div class="p-3">
                
                <div id="tab-content-all" class="tab-content-area active">
                    <table class="table table-hover align-middle">
                        <thead class="bg-light text-muted">
                            <tr>
                                <th class="py-3">유형</th>
                                <th class="py-3">이름/기업명</th>
                                <th class="py-3">계정(Email)</th>
                                <th class="py-3">상태</th>
                                <th class="py-3 text-center">등록일</th>
                                <th class="py-3 text-center">관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><span class="badge bg-info bg-opacity-10 text-info border border-info">기업</span></td>
                                <td class="fw-bold">에이비씨 테크놀로지</td>
                                <td>admin@abc-tech.com</td>
                                <td><span class="badge bg-success bg-opacity-25 text-success border border-success border-opacity-25 rounded-pill px-3">정상</span></td>
                                <td class="text-center">2025.10.12</td>
                                <td class="text-center">
                                    <button class="btn btn-light btn-sm btn-company-detail" 
                                        data-company="에이비씨 테크놀로지" 
                                        data-id="user_abc" 
                                        data-manager="박담당" 
                                        data-email="admin@abc-tech.com" 
                                        data-rep="김대표" 
                                        data-biznum="123-45-67890" 
                                        data-phone="02-1234-5678" 
                                        data-addr="서울시 강남구" 
                                        data-status="활성">
                                        <i class="bi bi-gear-fill text-secondary"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td><span class="badge bg-secondary bg-opacity-10 text-secondary border border-secondary">일반</span></td>
                                <td class="fw-bold">홍길동</td>
                                <td>hong@test.com</td>
                                <td><span class="badge bg-success bg-opacity-25 text-success border border-success border-opacity-25 rounded-pill px-3">활성</span></td>
                                <td class="text-center">2024.01.01</td>
                                <td class="text-center">
                                    <button class="btn btn-light btn-sm btn-user-detail"
                                        data-id="hong123" 
                                        data-name="홍길동" 
                                        data-email="hong@test.com" 
                                        data-birth="1990-05-05" 
                                        data-gender="male" 
                                        data-company="(주)테스트컴퍼니" 
                                        data-dept="개발팀" 
                                        data-position="팀장" 
                                        data-status="활성">
                                        <i class="bi bi-gear-fill text-secondary"></i>
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div id="tab-content-general" class="tab-content-area">
                    <table class="table table-hover align-middle">
                        <thead class="bg-light text-muted">
                            <tr>
                                <th>이름</th><th>이메일</th><th>소속</th><th>가입일</th><th>상태</th><th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>홍길동</td><td>hong@test.com</td><td>개발팀</td><td>2024-01-01</td>
                                <td><span class="badge bg-success">활성</span></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-secondary btn-user-detail"
                                        data-id="hong123" data-name="홍길동" data-email="hong@test.com" data-birth="1990-05-05" data-gender="male" data-company="(주)테스트컴퍼니" data-dept="개발팀" data-position="팀장" data-status="활성">상세</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div id="tab-content-company" class="tab-content-area">
                    <table class="table table-hover align-middle" style="font-size: 0.95rem;">
                        <thead class="bg-light text-muted">
                            <tr>
                                <th class="py-3">상태</th><th class="py-3">사업자 번호</th><th class="py-3">대표자</th><th class="py-3">고객사명</th><th class="py-3">주소</th><th class="py-3 text-center">관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><span class="badge bg-success bg-opacity-25 text-success border border-success border-opacity-25 rounded-pill px-3">정상</span></td>
                                <td>123-45-67890</td>
                                <td>홍길동</td>
                                <td class="fw-bold">에이비씨 테크놀로지 글로벌 주식회사</td>
                                <td>서울시 강남구 테헤란로 123, 7층</td>
                                <td class="text-center">
                                    <button class="btn btn-light btn-sm btn-company-detail"
                                     data-company="에이비씨 테크놀로지" data-id="user_abc" data-manager="박담당" data-email="admin@abc-tech.com" data-rep="김대표" data-biznum="123-45-67890" data-phone="02-1234-5678" data-addr="서울시 강남구" data-status="활성">
                                     <i class="bi bi-gear-fill text-secondary"></i>
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div id="tab-content-withdrawal" class="tab-content-area">
                    <table class="table table-hover align-middle">
                        <thead class="bg-light text-muted">
                            <tr>
                                <th>구분</th><th>이름/기업명</th><th>계정(Email)</th><th>탈퇴 사유</th><th class="text-center">탈퇴일</th><th class="text-center">복구/삭제</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><span class="badge bg-secondary bg-opacity-25 text-secondary border border-secondary border-opacity-25 rounded-pill px-3">기업</span></td>
                                <td class="text-decoration-line-through">(주)하이퍼데이터 분석연구소</td>
                                <td>admin@hyper-data.net</td>
                                <td>서비스 이용 불만족</td>
                                <td class="text-center">2024.12.30</td>
                                <td class="text-center"><button class="btn btn-sm btn-outline-danger">영구삭제</button></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="companyDetailModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-building me-2"></i>고객사 상세 정보 수정</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <h6 class="text-primary fw-bold mb-3 border-bottom pb-2"><i class="bi bi-person-badge me-2"></i>계정 정보 (메인 담당자)</h6>
                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <label class="form-label text-muted small fw-bold">아이디</label>
                        <input type="text" class="form-control bg-light" id="c-detail-id" readonly>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label text-muted small fw-bold">담당자 이름</label>
                        <input type="text" class="form-control" id="c-detail-manager">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label text-muted small fw-bold">담당자 이메일</label>
                        <input type="email" class="form-control" id="c-detail-email">
                    </div>
                </div>

                <h6 class="text-primary fw-bold mb-3 border-bottom pb-2"><i class="bi bi-buildings me-2"></i>기업 정보</h6>
                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">기업명 (법인명)</label>
                        <input type="text" class="form-control fw-bold" id="c-detail-company">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">대표자명</label>
                        <input type="text" class="form-control" id="c-detail-rep">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">사업자 등록번호</label>
                        <input type="text" class="form-control" id="c-detail-biznum">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">기업 대표 전화번호</label>
                        <input type="text" class="form-control" id="c-detail-phone">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">상태</label>
                        <select class="form-select" id="c-detail-status">
                            <option value="활성">활성</option>
                            <option value="비활성">비활성</option>
                        </select>
                    </div>
                    <div class="col-12">
                        <label class="form-label text-muted small fw-bold">기업 주소</label>
                        <input type="text" class="form-control" id="c-detail-addr">
                    </div>
                </div>
            </div>
            <div class="modal-footer bg-light justify-content-between">
                <div><button type="button" class="btn btn-outline-danger" id="btn-delete-company"><i class="bi bi-trash"></i> 삭제</button></div>
                <div>
                    <button type="button" class="btn btn-primary px-4 me-2">저장</button>
                    <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="userGeneralDetailModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-person me-2"></i>일반 회원 상세 정보 수정</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <h6 class="text-primary fw-bold mb-3 border-bottom pb-2">계정 정보</h6>
                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">아이디</label>
                        <input type="text" class="form-control bg-light" id="u-detail-id" readonly>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">이메일</label>
                        <input type="email" class="form-control" id="u-detail-email">
                    </div>
                </div>

                <h6 class="text-primary fw-bold mb-3 border-bottom pb-2">개인 정보</h6>
                <div class="row g-3 mb-4">
                    <div class="col-md-4">
                        <label class="form-label text-muted small fw-bold">이름</label>
                        <input type="text" class="form-control" id="u-detail-name">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label text-muted small fw-bold">생년월일</label>
                        <input type="date" class="form-control" id="u-detail-birth">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label text-muted small fw-bold d-block">성별</label>
                        <div class="form-check form-check-inline mt-1">
                            <input class="form-check-input" type="radio" name="u-detail-gender" id="u-gender-male" value="male">
                            <label class="form-check-label" for="u-gender-male">남성</label>
                        </div>
                        <div class="form-check form-check-inline mt-1">
                            <input class="form-check-input" type="radio" name="u-detail-gender" id="u-gender-female" value="female">
                            <label class="form-check-label" for="u-gender-female">여성</label>
                        </div>
                    </div>
                </div>

                <h6 class="text-primary fw-bold mb-3 border-bottom pb-2">소속 정보</h6>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">소속 회사</label>
                        <input type="text" class="form-control" id="u-detail-company">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">부서</label>
                        <input type="text" class="form-control" id="u-detail-dept">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">직급/역할</label>
                        <input type="text" class="form-control" id="u-detail-position">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">계정 상태</label>
                        <select class="form-select" id="u-detail-status">
                            <option value="활성">활성</option>
                            <option value="비활성">비활성</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="modal-footer bg-light justify-content-between">
                <div><button type="button" class="btn btn-outline-danger" id="btn-delete-user"><i class="bi bi-trash"></i> 삭제</button></div>
                <div>
                    <button type="button" class="btn btn-primary px-4 me-2">저장</button>
                    <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        
        // 1. 탭 전환 로직
        const userTabs = document.querySelectorAll('#userMgmtTabs .nav-link');
        const tabContentAreas = document.querySelectorAll('.tab-content-area');

        userTabs.forEach(tab => {
            tab.addEventListener('click', function() {
                // Active Class Toggling
                userTabs.forEach(t => t.classList.remove('active'));
                this.classList.add('active');

                // Content Display Toggling
                const targetTab = this.getAttribute('data-tab');
                tabContentAreas.forEach(area => area.classList.remove('active'));
                
                const targetContent = document.getElementById('tab-content-' + targetTab);
                if(targetContent) targetContent.classList.add('active');
            });
        });

        // 2. 고객사 상세 모달 로직
        const companyModalEl = document.getElementById('companyDetailModal');
        if (companyModalEl) {
            const companyModal = new bootstrap.Modal(companyModalEl);
            
            // 모달 내부 입력 필드 참조
            const inputs = {
                id: document.getElementById('c-detail-id'),
                manager: document.getElementById('c-detail-manager'),
                email: document.getElementById('c-detail-email'),
                company: document.getElementById('c-detail-company'),
                rep: document.getElementById('c-detail-rep'),
                biznum: document.getElementById('c-detail-biznum'),
                phone: document.getElementById('c-detail-phone'),
                addr: document.getElementById('c-detail-addr'),
                status: document.getElementById('c-detail-status')
            };

            // 목록의 '상세(톱니바퀴)' 버튼 클릭 시 이벤트 위임
            document.body.addEventListener('click', function(e) {
                const btn = e.target.closest('.btn-company-detail');
                if (btn) {
                    const data = btn.dataset;
                    // 데이터 바인딩
                    inputs.id.value = data.id || '';
                    inputs.manager.value = data.manager || '';
                    inputs.email.value = data.email || '';
                    inputs.company.value = data.company || '';
                    inputs.rep.value = data.rep || '';
                    inputs.biznum.value = data.biznum || '';
                    inputs.phone.value = data.phone || '';
                    inputs.addr.value = data.addr || '';
                    inputs.status.value = data.status || '활성';
                    
                    companyModal.show();
                }
            });

            // 삭제 버튼 로직
            document.getElementById('btn-delete-company').addEventListener('click', function() {
                if(confirm("정말로 이 담당자(고객사) 정보를 삭제하시겠습니까?")) {
                    alert("삭제되었습니다.");
                    companyModal.hide();
                }
            });
        }

        // 3. 일반 회원 상세 모달 로직
        const userGeneralModalEl = document.getElementById('userGeneralDetailModal');
        if (userGeneralModalEl) {
            const userGeneralModal = new bootstrap.Modal(userGeneralModalEl);
            
            // 모달 내부 입력 필드 참조
            const inputs = {
                id: document.getElementById('u-detail-id'),
                email: document.getElementById('u-detail-email'),
                name: document.getElementById('u-detail-name'),
                birth: document.getElementById('u-detail-birth'),
                company: document.getElementById('u-detail-company'),
                dept: document.getElementById('u-detail-dept'),
                position: document.getElementById('u-detail-position'),
                status: document.getElementById('u-detail-status'),
                genderMale: document.getElementById('u-gender-male'),
                genderFemale: document.getElementById('u-gender-female')
            };

            document.body.addEventListener('click', function(e) {
                const btn = e.target.closest('.btn-user-detail');
                if (btn) {
                    const data = btn.dataset;
                    // 데이터 바인딩
                    inputs.id.value = data.id || '';
                    inputs.email.value = data.email || '';
                    inputs.name.value = data.name || '';
                    inputs.birth.value = data.birth || '';
                    inputs.company.value = data.company || '';
                    inputs.dept.value = data.dept || '';
                    inputs.position.value = data.position || '';
                    inputs.status.value = data.status || '활성';
                    
                    if (data.gender === 'male') inputs.genderMale.checked = true;
                    else inputs.genderFemale.checked = true;
                    
                    userGeneralModal.show();
                }
            });

            document.getElementById('btn-delete-user').addEventListener('click', function() {
                if(confirm("정말로 이 회원을 삭제하시겠습니까?")) {
                    alert("회원이 삭제되었습니다.");
                    userGeneralModal.hide();
                }
            });
        }
    });
</script>