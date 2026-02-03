<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tudio - 자료실</title>
    <jsp:include page="/WEB-INF/views/include/common.jsp" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/project_common.css">
    
    <style>
        .folder-card {
            background: #fff;
            border: 1px solid #e6edf6;
            border-radius: 12px;
            padding: 20px;
            transition: all 0.2s ease;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 15px;
            height: 100%;
        }
        .folder-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 24px rgba(15, 23, 42, .06);
            border-color: var(--main-blue);
        }
        .folder-icon {
            font-size: 2rem;
            color: #FFC107; /* 폴더 노란색 */
        }
        .folder-info h6 { margin: 0; font-weight: 700; color: var(--text-main); }
        .folder-info span { font-size: 0.8rem; color: #94a3b8; }
        
        .file-icon-cell { font-size: 1.4rem; color: #64748B; text-align: center; width: 50px; }
        .file-name-link { text-decoration: none; color: var(--text-main); font-weight: 600; }
        .file-name-link:hover { text-decoration: underline; color: var(--main-blue); }
        
        /* 파일 확장자별 아이콘 색상 (하드코딩용) */
        .icon-pdf { color: #F40F02; }
        .icon-xls { color: #1D6F42; }
        .icon-ppt { color: #D04423; }
        .icon-zip { color: #78797D; }
        .icon-img { color: #B64AFF; }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">
    <jsp:include page="/WEB-INF/views/include/headerUser.jsp"/>
    
    <div class="d-flex flex-grow-1">
        <jsp:include page="../include/sidebarUser.jsp">
              <jsp:param name="menu" value="drive" />
        </jsp:include>
        
        <main class="main-content-wrap flex-grow-1 px-4 pt-4 pb-5">
            <div class="container-fluid">
                
                <div class="d-flex justify-content-between align-items-end mb-4">
                    <div>
                        <h3 class="fw-bold text-primary-dark m-0">
                            <i class="bi bi-archive me-2"></i>자료실
                        </h3>
                        <p class="text-muted mb-0 small mt-2">프로젝트의 모든 파일과 문서를 안전하게 관리하세요.</p>
                    </div>
                    
                    <div class="d-flex gap-2 align-items-center">
                        <div class="tudio-search" style="width: 250px;">
                            <input type="text" placeholder="파일/폴더명 검색...">
                            <i class="bi bi-search text-muted"></i>
                        </div>
                        <button class="tudio-search-btn">검색</button>
                        
                        <button type="button" class="tudio-btn tudio-btn-outline ms-2" data-bs-toggle="modal" data-bs-target="#newFolderModal">
                            <i class="bi bi-folder-plus"></i> 새 폴더
                        </button>
                        <button type="button" class="tudio-btn tudio-btn-primary" data-bs-toggle="modal" data-bs-target="#uploadModal">
                            <i class="bi bi-cloud-arrow-up"></i> 파일 업로드
                        </button>
                    </div>
                </div>

                <h6 class="fw-bold text-muted mb-3"><i class="bi bi-folder2-open me-1"></i>Folders</h6>
                <div class="row g-3 mb-5">
                    <div class="col-md-3 col-sm-6">
                        <div class="folder-card" onclick="alert('폴더 진입 기능은 구현 예정입니다.')">
                            <i class="bi bi-folder-fill folder-icon"></i>
                            <div class="folder-info">
                                <h6>공지사항 및 규정</h6>
                                <span>파일 12개 · 24MB</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="folder-card" onclick="alert('폴더 진입 기능은 구현 예정입니다.')">
                            <i class="bi bi-folder-fill folder-icon"></i>
                            <div class="folder-info">
                                <h6>디자인 리소스</h6>
                                <span>파일 48개 · 1.2GB</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="folder-card" onclick="alert('폴더 진입 기능은 구현 예정입니다.')">
                            <i class="bi bi-folder-fill folder-icon"></i>
                            <div class="folder-info">
                                <h6>회의록(Minutes)</h6>
                                <span>파일 8개 · 450KB</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 col-sm-6">
                        <div class="folder-card" onclick="alert('폴더 진입 기능은 구현 예정입니다.')">
                            <i class="bi bi-folder-fill folder-icon"></i>
                            <div class="folder-info">
                                <h6>개발 산출물</h6>
                                <span>파일 32개 · 150MB</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tudio-section">
                    <div class="tudio-section-header">
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-files text-primary-dark"></i>
                            <span class="fw-bold text-primary-dark">전체 파일 목록</span>
                            <span class="tudio-badge bg-light text-secondary border">5</span>
                        </div>
                        
                        <div class="d-flex gap-2">
                            <select class="form-select form-select-sm" style="width: 120px; border-radius: 8px;">
                                <option selected>최신순</option>
                                <option>오래된순</option>
                                <option>이름순</option>
                                <option>용량순</option>
                            </select>
                        </div>
                    </div>

                    <div class="p-0">
                        <table class="tudio-table-card mb-0">
                            <thead>
                                <tr>
                                    <th class="text-center" style="width: 60px;">유형</th>
                                    <th>파일명</th>
                                    <th style="width: 100px;">크기</th>
                                    <th style="width: 120px;">업로더</th>
                                    <th style="width: 150px;">등록일</th>
                                    <th class="text-center" style="width: 100px;">관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="file-icon-cell"><i class="bi bi-file-earmark-pdf-fill icon-pdf"></i></td>
                                    <td>
                                        <div class="d-flex flex-column">
                                            <a href="#" class="file-name-link">2026년도_프로젝트_수행계획서_v1.0.pdf</a>
                                            <span class="small text-muted">경로: /개발 산출물/기획서</span>
                                        </div>
                                    </td>
                                    <td><span class="small text-muted">2.4 MB</span></td>
                                    <td><span class="tudio-badge bg-light-blue text-primary-dark border-0">김팀장</span></td>
                                    <td><span class="small text-muted">2026.01.24</span></td>
                                    <td class="text-center">
                                        <button class="btn btn-sm btn-link text-dark p-0 me-2" title="다운로드"><i class="bi bi-download"></i></button>
                                        <button class="btn btn-sm btn-link text-danger p-0" title="삭제"><i class="bi bi-trash"></i></button>
                                    </td>
                                </tr>

                                <tr>
                                    <td class="file-icon-cell"><i class="bi bi-file-earmark-excel-fill icon-xls"></i></td>
                                    <td>
                                        <div class="d-flex flex-column">
                                            <a href="#" class="file-name-link">1월_WBS_일정관리표.xlsx</a>
                                            <span class="small text-muted">경로: /공지사항 및 규정</span>
                                        </div>
                                    </td>
                                    <td><span class="small text-muted">45 KB</span></td>
                                    <td><span class="tudio-badge bg-light text-dark border">이대리</span></td>
                                    <td><span class="small text-muted">2026.01.23</span></td>
                                    <td class="text-center">
                                        <button class="btn btn-sm btn-link text-dark p-0 me-2"><i class="bi bi-download"></i></button>
                                        <button class="btn btn-sm btn-link text-danger p-0"><i class="bi bi-trash"></i></button>
                                    </td>
                                </tr>

                                <tr>
                                    <td class="file-icon-cell"><i class="bi bi-file-earmark-ppt-fill icon-ppt"></i></td>
                                    <td>
                                        <div class="d-flex flex-column">
                                            <a href="#" class="file-name-link">UI_UX_화면설계서_최종.pptx</a>
                                            <span class="small text-muted">경로: /디자인 리소스</span>
                                        </div>
                                    </td>
                                    <td><span class="small text-muted">15.8 MB</span></td>
                                    <td><span class="tudio-badge bg-light text-dark border">박디자</span></td>
                                    <td><span class="small text-muted">2026.01.20</span></td>
                                    <td class="text-center">
                                        <button class="btn btn-sm btn-link text-dark p-0 me-2"><i class="bi bi-download"></i></button>
                                        <button class="btn btn-sm btn-link text-danger p-0"><i class="bi bi-trash"></i></button>
                                    </td>
                                </tr>

                                <tr>
                                    <td class="file-icon-cell"><i class="bi bi-file-earmark-image-fill icon-img"></i></td>
                                    <td>
                                        <div class="d-flex flex-column">
                                            <a href="#" class="file-name-link">메인_로고_시안_A타입.png</a>
                                            <span class="small text-muted">경로: /디자인 리소스/로고</span>
                                        </div>
                                    </td>
                                    <td><span class="small text-muted">2.1 MB</span></td>
                                    <td><span class="tudio-badge bg-light text-dark border">박디자</span></td>
                                    <td><span class="small text-muted">2026.01.20</span></td>
                                    <td class="text-center">
                                        <button class="btn btn-sm btn-link text-dark p-0 me-2"><i class="bi bi-download"></i></button>
                                        <button class="btn btn-sm btn-link text-danger p-0"><i class="bi bi-trash"></i></button>
                                    </td>
                                </tr>

                                <tr>
                                    <td class="file-icon-cell"><i class="bi bi-file-earmark-zip-fill icon-zip"></i></td>
                                    <td>
                                        <div class="d-flex flex-column">
                                            <a href="#" class="file-name-link">프로젝트_초기_세팅_소스코드.zip</a>
                                            <span class="small text-muted">경로: /개발 산출물/소스</span>
                                        </div>
                                    </td>
                                    <td><span class="small text-muted">104 MB</span></td>
                                    <td><span class="tudio-badge bg-light-blue text-primary-dark border-0">최사원</span></td>
                                    <td><span class="small text-muted">2026.01.15</span></td>
                                    <td class="text-center">
                                        <button class="btn btn-sm btn-link text-dark p-0 me-2"><i class="bi bi-download"></i></button>
                                        <button class="btn btn-sm btn-link text-danger p-0"><i class="bi bi-trash"></i></button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    
                    <div class="board-footer border-top">
                        <div class="pager">
                            <a href="#" class="pg text-muted"><i class="bi bi-chevron-left"></i></a>
                            <a href="#" class="pg is-active">1</a>
                            <a href="#" class="pg">2</a>
                            <a href="#" class="pg">3</a>
                            <a href="#" class="pg text-muted"><i class="bi bi-chevron-right"></i></a>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>

    <div class="modal fade" id="newFolderModal" tabindex="-1">
       <div class="modal-dialog modal-dialog-centered tudio-modal">
            <div class="modal-content">
                <div class="modal-header tudio-modal-header">
                    <h5 class="modal-title tudio-modal-title fw-bold">새 폴더 생성</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">폴더명</label>
                            <input type="text" class="form-control" placeholder="새 폴더 이름을 입력하세요">
                        </div>
                    </form>
                </div>
                <div class="modal-footer tudio-modal-footer">
                    <button type="button" class="tudio-btn tudio-btn-outline" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="tudio-btn tudio-btn-primary">생성하기</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="uploadModal" tabindex="-1">
       <div class="modal-dialog modal-dialog-centered tudio-modal">
            <div class="modal-content">
                <div class="modal-header tudio-modal-header">
                    <h5 class="modal-title tudio-modal-title fw-bold">파일 업로드</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center py-5">
                    <div class="border rounded-3 bg-light p-4 border-dashed" style="border-style: dashed !important; border-color: #cbd5e1 !important;">
                        <i class="bi bi-cloud-arrow-up fs-1 text-muted mb-3 d-block"></i>
                        <p class="mb-2 fw-bold text-dark">이곳에 파일을 드래그하세요</p>
                        <p class="small text-muted">또는 아래 버튼을 클릭하여 선택</p>
                        <button class="tudio-btn tudio-btn-outline btn-sm mt-2">파일 선택</button>
                    </div>
                </div>
                <div class="modal-footer tudio-modal-footer">
                    <button type="button" class="tudio-btn tudio-btn-outline" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="tudio-btn tudio-btn-primary">업로드</button>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../chat/main.jsp"/>
    <jsp:include page="/WEB-INF/views/include/footer.jsp"/>
</body>
<script>
    // 스크립트가 필요하다면 여기에 작성
    // 현재는 하드코딩된 UI 표출용이므로 별도 로직 없음
</script>
</html>