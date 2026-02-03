<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 
    파일명: reference.jsp
    설명: 자료실 이미지/미디어 탭 뷰 (프로젝트별 폴더 및 갤러리 그리드)
--%>

<div class="main-content-wrap flex-grow-1">
    <div class="container-fluid">
        
        <nav class="breadcrumb-nav">
            <div class="dropdown">
                <span class="dropdown-text" onclick="location.href='global_data.jsp';">자료실</span>
            </div>
            <span class="sep"><i class="bi bi-chevron-right small"></i></span>
            <div class="dropdown">
                <span class="dropdown-text text-primary" data-bs-toggle="dropdown">
                    이미지 <i class="bi bi-chevron-down ms-2 small"></i>
                </span>
                <ul class="dropdown-menu shadow border-0">
                    <li><a class="dropdown-item" href="data_docs.jsp"><i class="bi bi-file-earmark-text me-2"></i>일반 문서</a></li>
                    <li><a class="dropdown-item active" href="data_images.jsp"><i class="bi bi-image me-2"></i>이미지</a></li>
                    <li><a class="dropdown-item" href="data_pdf.jsp"><i class="bi bi-file-earmark-pdf me-2"></i>PDF 문서</a></li>
                    <li><a class="dropdown-item" href="data_zip.jsp"><i class="bi bi-archive me-2"></i>압축파일</a></li>
                </ul>
            </div>
        </nav>

        <ul class="nav nav-tabs nav-tabs-custom" id="projectTab" role="tablist">
            <li class="nav-item">
                <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#proj-tudio" type="button">Tudio 런칭 프로젝트</button>
            </li>
            <li class="nav-item">
                <button class="nav-link" data-bs-toggle="tab" data-bs-target="#proj-common" type="button">전사 공통 자료</button>
            </li>
            <li class="nav-item">
                <button class="nav-link" data-bs-toggle="tab" data-bs-target="#proj-alpha" type="button">Alpha 서비스 고도화</button>
            </li>
        </ul>

        <div class="tab-content" id="projectTabContent">
            
            <div class="tab-pane fade show active" id="proj-tudio">
                
                <div class="folder-group">
                    <div class="folder-header"><i class="bi bi-folder-fill"></i> 디자인 시스템 가이드</div>
                    <div class="row g-3">
                        <div class="col-6 col-md-4 col-lg-2">
                            <div class="card gallery-card" onclick="showFileDetail('Color_Palette_v2.png', '450KB', '2025.12.17', 'Tudio 런칭 프로젝트', '공지사항: 디자인 가이드 배포', '김사용', 'K', 'https://images.unsplash.com/photo-1586717791821-3f44a563dc4c?q=80&w=300')">
                                <span class="my-file-badge">내 파일</span>
                                <button class="btn-file-delete is-mine" onclick="event.stopPropagation(); if(confirm('파일을 삭제하시겠습니까?')) alert('삭제되었습니다.');">
                                    <i class="bi bi-trash3-fill"></i>
                                </button>
                                <div class="img-box">
                                    <img src="https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?q=80&w=300" alt="thumbnail">
                                    <div class="img-overlay"><i class="bi bi-check-circle-fill text-primary fs-4"></i></div>
                                </div>
                                <div class="file-info">
                                    <div class="file-title">Color_Palette_v2.png</div>
                                    <div class="file-size-date"><span>450KB</span><span>2025.12.17</span></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="folder-group">
                    <div class="folder-header"><i class="bi bi-folder-fill"></i> 메인페이지 시안</div>
                    <div class="row g-3">
                        <div class="col-6 col-md-4 col-lg-2">
                            <div class="card gallery-card" onclick="showFileDetail('Main_Hero_Draft.jpg', '2.1MB', '2025.12.16', 'Tudio 런칭 프로젝트', '업무: 메인 UI 설계', '박디자인', 'P', 'https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?q=80&w=300')">
                                <div class="img-box">
                                    <img src="https://images.unsplash.com/photo-1507238691740-187a5b1d37b8?q=80&w=300" alt="thumbnail">
                                    <div class="img-overlay"><i class="bi bi-check-circle-fill text-primary fs-4"></i></div>
                                </div>
                                <div class="file-info">
                                    <div class="file-title">Main_Hero_Draft.jpg</div>
                                    <div class="file-size-date"><span>2.1MB</span><span>2025.12.16</span></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div> 
            
            <div class="tab-pane fade" id="proj-common">
                <div class="py-5 text-center text-muted">등록된 자료가 없습니다.</div>
            </div>
            <div class="tab-pane fade" id="proj-alpha">
                <div class="py-5 text-center text-muted">등록된 자료가 없습니다.</div>
            </div>

        </div>
    </div>
</div>

<div class="modal fade" id="fileDetailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content border-0 shadow-lg" style="border-radius: 20px; overflow: hidden;">
            <div class="row g-0">
                <div class="col-md-7 bg-light d-flex align-items-center justify-content-center p-4" style="min-height: 400px; background: #222 !important;">
                    <img id="modalImg" src="" class="img-fluid rounded shadow-sm" style="max-height: 80vh; object-fit: contain;">
                </div>
                <div class="col-md-5 bg-white p-4">
                    <div class="d-flex justify-content-between align-items-start mb-4">
                        <div>
                            <h5 class="fw-bold mb-1" id="modalFileName">파일명.png</h5>
                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle" id="modalFileSize">0KB</span>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <hr class="my-4 opacity-50">
                    <div class="mb-4">
                        <span class="path-label">Project Source</span>
                        <a href="#" class="path-value" id="modalProjectName">프로젝트명</a>
                        <span class="path-label">Connected Task/Post</span>
                        <a href="#" class="path-value" id="modalTaskName">게시글 또는 업무명</a>
                    </div>
                    <div class="d-flex align-items-center p-3 rounded-4 bg-light mb-4">
                        <div class="profile-img-lg me-3 shadow-sm" id="modalUserInitial">K</div>
                        <div>
                            <span class="extra-small text-muted d-block">Uploaded by</span>
                            <strong id="modalUserName">사용자명</strong>
                            <span class="text-muted small ms-2" id="modalUploadDate">2025.00.00</span>
                        </div>
                    </div>
                    <div class="d-grid gap-2">
                        <button class="btn btn-primary py-2 fw-bold rounded-3 shadow-sm"><i class="bi bi-download me-2"></i>파일 다운로드</button>
                        <button class="btn btn-outline-secondary py-2 small rounded-3 border-0">원본 링크 복사</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    /**
     * 파일 상세 모달 표시 함수
     * @param {string} name - 파일명
     * @param {string} size - 파일 크기
     * @param {string} date - 업로드 날짜
     * @param {string} project - 프로젝트명
     * @param {string} task - 연결된 업무/게시글
     * @param {string} user - 업로더 이름
     * @param {string} initial - 업로더 이니셜
     * @param {string} imgUrl - 이미지 경로
     */
    function showFileDetail(name, size, date, project, task, user, initial, imgUrl) {
        document.getElementById('modalFileName').innerText = name;
        document.getElementById('modalFileSize').innerText = size;
        document.getElementById('modalUploadDate').innerText = date;
        document.getElementById('modalProjectName').innerText = project;
        document.getElementById('modalTaskName').innerText = task;
        document.getElementById('modalUserName').innerText = user;
        document.getElementById('modalUserInitial').innerText = initial;
        document.getElementById('modalImg').src = imgUrl;

        // Bootstrap 5 모달 인스턴스 생성 및 표시
        const myModal = new bootstrap.Modal(document.getElementById('fileDetailModal'));
        myModal.show();
    }
</script>