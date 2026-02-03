<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/drive.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<div class="tab-content-cards">
    <div class="tudio-section-header mb-4">
        <h5 class="mb-0 text-primary-dark fw-bold" id="driveViewTitle">
            <i class="fa-solid fa-hard-drive me-2"></i>드라이브
        </h5>
        
        <div class="d-flex gap-2">
            <div id="driveActionBtns" class="d-flex gap-2">
		        <button class="tudio-btn tudio-btn-primary" id="btnUpload">
		            <i class="fa-solid fa-cloud-arrow-up me-1"></i> 파일 업로드
		        </button>
		        <input type="file" id="driveFileInput" multiple style="display:none;">
		
		        <button class="tudio-btn" id="btnNewFolder" style="border: 1px solid var(--tudio-border-soft);">
		            <i class="fa-solid fa-folder-plus me-1"></i> 새 폴더
		        </button>
		
		        <button class="tudio-btn" id="btnGoTrash" style="border: 1px solid var(--tudio-border-soft);">
		            <i class="fa-solid fa-trash-can me-1"></i> 휴지통
		        </button>
		    </div>
		
            <div id="trashActionBtns" class="d-flex gap-2 d-none">
			    <button class="tudio-btn" id="btnGoDrive" style="border: 1px solid var(--tudio-border-soft);">
			        <i class="fa-solid fa-arrow-left me-1"></i> 드라이브로 돌아가기
			    </button>
                <button class="tudio-btn tudio-btn-outline-danger" id="btnEmptyTrash" style="border: 1px solid #dc3545; color: #dc3545;">
			        <i class="fa-solid fa-dumpster me-1"></i> 휴지통 비우기
			    </button>
			</div>
		</div>
    </div>

    <div id="driveListView">
        <div class="d-flex justify-content-between align-items-center mb-3 px-3">
            <nav aria-label="breadcrumb" class="ms-2">
                <ol class="breadcrumb mb-0" id="driveBreadcrumb">
                    <li class="breadcrumb-item active" data-folder-id="0">
                        <i class="fa-solid fa-house me-1"></i>
						<span id="driveProjectName">프로젝트 드라이브</span>
                    </li>
                </ol>
            </nav>
            
            <div class="d-flex align-items-center gap-2"> 
                <div class="tudio-search">
                    <input type="text" id="driveSearchInput" placeholder="파일/폴더명 검색" />
                </div>
                <button class="tudio-search-btn" id="btnSearchDrive" aria-label="search">검색</button>
            </div>
        </div>

        <div class="tudio-table-wrap">
            <table class="tudio-table-card drive-table">
                <colgroup>
                    <col style="width: 5%;">  <col style="width: 45%;"> <col style="width: 15%;"> <col style="width: 20%;"> <col style="width: 10%;"> <col style="width: 5%;">  
                </colgroup>
                <thead>
                    <tr>
                        <th class="text-center"><i class="fa-regular fa-file"></i></th> 
                        <th>이름</th>
                        <th>공유자</th>
                        <th>공유된 날짜</th>
                        <th>파일 크기</th>
                        <th></th>
                    </tr>
                </thead>
                
                <tbody id="driveListBody"></tbody>
            </table>
            
            <div id="driveEmptyState" class="text-center py-5 text-muted" style="display:none;">
                <i class="fa-solid fa-folder-open fs-1 d-block mb-3 opacity-50"></i>
                <span>폴더가 비어있습니다.</span>
            </div>
        </div>
    </div>
</div>

<div id="driveContextMenu" class="dropdown-menu shadow" style="display:none; position:fixed; z-index: 1000;">
    <a class="dropdown-item btn-download" href="#" data-action="download"><i class="fa-solid fa-download me-2"></i>다운로드</a>
    <a class="dropdown-item btn-rename" href="#" data-action="rename"><i class="fa-solid fa-pen me-2"></i>이름 변경</a>
    <div class="dropdown-divider"></div>
    <a class="dropdown-item text-danger btn-delete" href="#" data-action="delete"><i class="fa-solid fa-trash me-2"></i>삭제</a>
</div>