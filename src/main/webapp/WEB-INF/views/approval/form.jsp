<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Tudio</title>
<jsp:include page="/WEB-INF/views/include/common.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/project_common.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script	src="https://cdn.ckeditor.com/ckeditor5/34.0.0/classic/ckeditor.js"></script>
<script	src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<style>
.ck-editor__editable {
	min-height: 400px !important;
	border: 1px solid #ccced1 !important;
} /* 에디터 높이 확보 */
.bg-light {
	background-color: #f8fafc !important;
}
/* 테이블 마우스 오버 시 발생하는 배경색 변화와 글자 흔들림 방지 */
.table.table-hover-custom, .table.table-hover-custom tr, .table.table-hover-custom td
	{
	--bs-table-hover-bg: transparent !important; /* 배경색 변화 제거 */
	--bs-table-accent-bg: transparent !important;
	transition: none !important; /* 움직임 효과 제거 */
	transform: none !important; /* 위치 이동 제거 */
}
/* 1. 테이블 전체 스타일 수정 */
.custom-table {
	border-collapse: collapse !important;
	border-left: none !important; /* 왼쪽 외곽선 제거 */
	border-right: none !important; /* 오른쪽 외곽선 제거 */
	border-top: 1px solid #dee2e6 !important; /* 상단 실선 */
	border-bottom: 1px solid #dee2e6 !important; /* 하단 실선 */
}

/* 2. 내부 셀 테두리 설정 */
.custom-table th, .custom-table td {
	border: 1px solid #dee2e6 !important; /* 내부를 한줄 실선으로 */
	border-left: none !important; /* 셀의 왼쪽 선 제거 (중복 방지 및 외곽선 제거) */
	border-right: none !important; /* 셀의 오른쪽 선 제거 */
}

/* 3. 첫 번째 칸(헤더)과 마지막 칸의 간격 조절 */
.custom-table th:first-child, .custom-table td:first-child {
	border-left: none !important;
	padding-left: 15px;
}

.custom-table th:last-child, .custom-table td:last-child {
	border-right: none !important;
	padding-right: 15px;
}

/* 4. 제목(th) 배경색 및 글자색 살짝 조정 */
.custom-table th.bg-light {
	background-color: #fcfcfc !important; /* 너무 칙칙하지 않은 밝은 회색 */
	font-weight: 600;
	color: #444;
}


/* ============= 결재라인 css ========= */
.org-wrap {
    display: flex;
	float: right;
    font-family: Arial, sans-serif;
	margin-bottom: 10px;
	padding-left: 50px;
	width : 100%;
  }

  .group {
    display: flex;
	border: 1px solid #dee2e6;
  }

  .vertical {
    writing-mode: vertical-rl;
    text-orientation: mixed;
    padding: 5px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: bold;
    min-width: 20px;
    background: #f8fafc;
  }

  .box {
    flex-direction: column;
	min-width: 80px;
	border-left: 1px solid #dee2e6;
  }

  .position {
    border-bottom: 1px solid #dee2e6;
    height: 20px;
  }

  .name {
    border-bottom: 1px solid #dee2e6;
	height: 80px;
  }

  .name:last-child {
    border-bottom: none;
  }
  
  .date {
	height: 20px;
	text-align: center;
  }
  
  .box div{
	display: flex;
	align-items: center;
    justify-content: center;
	font-size: 12px;
  }
  
  .tudio-scope{
  width: 80%;
  max-width: 1100px;  /* 너무 넓어지는 거 방지 */
  margin: 0 auto;     /* 가운데 정렬 */
}
  
</style>
</head>
<body>
	<section class="tudio-section">
		<!-- APPROVAL FORM 화면 입니다. -->
		<jsp:include page="../include/headerUser.jsp" />

		<div class="d-flex">
			<!-- 사이드바 -->
			<jsp:include page="../include/sidebarUser.jsp">
				<jsp:param name="menu" value="approval" />
			</jsp:include>

			<main class="main-content-wrap flex-grow-1 px-4 pt-4 pb-5">
				<div class="container-fluid">

					<div class="d-flex justify-content-between align-items-center mb-4">
						<!-- 소제목 -->
						<h2 class="h3 fw-bold text-primary-dark mb-0">
							<i class="bi bi-file-earmark-check me-2"></i> 결재 문서 작성
						</h2>
					</div>




					<div class="tudio-scope">
						<div class="d-flex justify-content-between align-items-end mb-0">
							<ul class="nav nav-tabs custom-index-tabs border-0 mb-0">
								<li class="nav-item">
									<button class="nav-link active" type="button">
										<i class="bi bi-pencil-fill"></i> <span>기안서 작성</span>
									</button>
								</li>
							</ul>
						</div>

						<div class="tab-content-card p-4">
							<form id="approvalForm">
								<div class="row mb-4">
									<div class="col-md-7">
										<table
											class="table table-bordered align-middle mb-0 custom-table table-hover-custom"
											style="height: 100%;">
											<tr>
												<th class="bg-light text-center" style="width: 25%;">프로젝트<span
													class="text-danger">*</span></th>
												<td><select name="projectNo" id="projectSelect"
													class="form-select form-select-sm">
														<option value="0">-- 프로젝트 선택 --</option>
														<c:forEach items="${myProjectList}" var="p">
															<option value="${p.projectNo}"
																${p.projectNo == projectNo ? 'selected' : ''}>
																${p.projectName}</option>
														</c:forEach>
												</select></td>
											</tr>
											<tr>
												<th class="bg-light text-center">기안자</th>
												<td class="small">${loginUser.memberName}<span
													class="text-muted"> (<c:out
															value="${loginUser.memberDepartment}" default="부서미지정" />
														/ <c:out value="${loginUser.memberPosition}"
															default="직책미지정" />)
												</span>
												</td>
											</tr>
											<tr>
												<th class="bg-light text-center">기안일자</th>
												<td class="small" id="currentDate"></td>
											</tr>
											<tr>
												<th class="bg-light text-center">보안</th>
												<td>
													<div class="d-flex gap-3 small">
														<div class="form-check">
															<input class="form-check-input" type="radio"
																name="isPublic" id="secPublic" value="Y" checked>
															<label class="form-check-label" for="secPublic">보안 낮음
																<span class="text-muted">(모두 조회 가능)</span>
															</label>
														</div>
														<div class="form-check">
															<input class="form-check-input" type="radio"
																name="isPublic" id="secPrivate" value="N"> <label
																class="form-check-label" for="secPrivate">보안 높음 <span
																class="text-muted">(결재자만 가능)</span></label>
														</div>
													</div>
												</td>
											</tr>
										</table>
									</div>

									<div class="col-md-5">
										
										<div class="org-wrap justify-content-end">
										  <div class="group" style="margin-right: 5px;">
										    <div class="vertical">기안</div>
										    <div class="box">
										      <div class="position">${loginUser.memberPosition}</div>
										      <div class="name">${loginUser.memberName}</div>
											  <div class="date" id="draftDate"></div>
										    </div>
										  </div>

										  <div class="group">
										    <div class="vertical">승인</div>
											<div class="box approver-slot" id="slot-1">
												<div class="position"></div>
												<div class="name slot-name">
														<span class="text-muted" style="cursor: pointer;" onclick="openApproverModal()">지정</span>
													</div>
													<input type="hidden" class="mem-no" value="">
												<div class="date"></div>
											</div>
											<div class="box approver-slot" id="slot-2">
												<div class="position"></div>
												<div class="name slot-name">
														<span class="text-muted" style="cursor: pointer;" onclick="openApproverModal()">지정</span>
													</div>
													<input type="hidden" class="mem-no" value="">
												<div class="date"></div>
											</div>
											<div class="box approver-slot" id="slot-3">
												<div class="position"></div>
												<div class="name slot-name">
														<span class="text-muted" style="cursor: pointer;" onclick="openApproverModal()">지정</span>
													</div>
													<input type="hidden" class="mem-no" value="">
												<div class="date"></div>
											</div>
										  </div>
										</div>
									<div class="text-end mt-2">
										<button type="button" class="btn btn-xs btn-outline-primary"
											onclick="openApproverModal()">
											<i class="bi bi-person-plus"></i> 결재선 지정
										</button>
									</div>

									</div>
									
								</div>

								<div class="mb-4">
									<label class="fw-bold mb-2">제목 <span
										class="text-danger">*</span>
									</label>
									<div class="row g-2">
										<div class="col-3">
											<select class="form-select" id="docType"
												onchange="changeTemplate(this.value)">
												<option value="">-- 양식 선택 --</option>
												<option value="resource">자원/인력 투입요청</option>
												<option value="schedule">일정변경요청</option>
												<option value="budget">예산조정요청</option>
												<option value="check">검수 및 보고</option>
												<option value="report">최종 완료 보고</option>
												<option value="other">기타</option>
											</select>
										</div>
										<div class="col-9">
											<input type="text" name="documentTitle" class="form-control"
												id="docTitle" placeholder="제목을 입력하세요">
										</div>
									</div>
								</div>

								<div class="mb-4">
									<label class="fw-bold mb-2">상세 내용 <span
										class="text-danger">*</span></label>
									<div id="editor"></div>
								</div>

								<div class="p-3 border rounded bg-light">
								    <input type="file" id="upfile" name="upfile" multiple class="d-none" onchange="updateFileList()">
								    
								    <button type="button" class="btn btn-sm btn-outline-secondary mb-2" onclick="document.getElementById('upfile').click()">
								        <i class="bi bi-paperclip"></i> 파일 첨부
								    </button>
								    
								    <div id="fileListContainer" class="text-muted small">
								        첨부된 파일이 없습니다.
								    </div>
								</div>
							</form>
						</div>

						<div class="d-flex justify-content-between mt-4 border-top pt-3">
							<button type="button" class="tudio-btn tudio-btn-outline"
								onclick="history.back()">취소</button>
							<div class="gap-2 d-flex">
								<button type="button" class="tudio-btn tudio-btn-light">임시저장</button>
								<button type="button" class="tudio-btn tudio-btn-primary"
									id="btnSubmit">결재상신</button>
							</div>
						</div>
					</div>
				</div>
			</main>
		</div>
		<div class="modal fade" id="approvalLineModal" tabindex="-1">
			<div class="modal-dialog modal-dialog-centered">
				<div class="modal-content tudio-modal-content">
					<div class="modal-header tudio-modal-header">
						<h5 class="modal-title fw-bold text-primary-dark">
							<i class="bi bi-person-gear me-2"></i>결재선 지정
						</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
					</div>

					<div class="modal-body p-4">
						<div class="d-flex align-items-center gap-2 mb-3">
						    <div class="tudio-search">
						        <input type="text" id="approverSearch" placeholder="이름 검색..." onkeyup="filterApprovers()">
						    </div>
						    <button class="tudio-search-btn">검색</button>
						</div>

						<p class="text-muted small mb-2">
							<i class="bi bi-info-circle me-1"></i> 체크한 순서대로 결재 순서가 지정되며,
							드래그하여 순서를 바꿀 수 있습니다.
						</p>

						<div class="todo-list-area" id="accordionContainer"></div>
					</div>

					<div class="modal-footer tudio-modal-footer">
						<button type="button" class="tudio-btn tudio-btn-outline"
							data-bs-dismiss="modal">취소</button>
						<button type="button" class="tudio-btn tudio-btn-primary"
							onclick="confirmApprovalLine()">설정완료</button>
					</div>
				</div>
			</div>
		</div>
	</section>
	
	<jsp:include page="../chat/main.jsp"/>
	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
	
<script type="text/javascript">
const contextPath = "/tudio";
let myEditor;

const docTypeMap = {
	    "resource": 601,
	    "schedule": 602,
	    "budget": 603,
	    "check": 604,
	    "report": 605,
	    "other": 606
	};


let selectedApprovers = [];
let allClientData = []; 
let uploadedFiles = [];

// [KJS] AI 로 생성한 데이터를 가져와서 변수에 저장
let AIData = null;

$(document).ready(function() {
	
	AIData = localStorage.AIData ? 
			JSON.parse(localStorage.AIData).fillData : null;
			
	console.log(AIData);			
			
	let AIDocType = AIData ? AIData.docType : null;
			
    // 1. 에디터 초기화
    ClassicEditor
        .create(document.querySelector('#editor'), {
            language: 'ko'
        })
        .then(editor => { 
            myEditor = editor; 

			// [KJS] AIData에서 받은 값으로 양식 선택 후 값 삽입
            if(AIDocType){
				$("#docType").val(AIDocType);
				changeTemplate(AIDocType);
				localStorage.removeItem("AIData");
				
				// 자동 입력 완료를 알리는 Toast 알림 출력
				const robotIcon = `<i class="bi bi-robot" style="font-size: 1.1rem;"></i>`;
				const Toast = Swal.mixin({
					  toast: true,
					  position: "top-end",
					  showConfirmButton: false,
					  timer: 2500,
					  timerProgressBar: true,
					  didOpen: (toast) => {
					    toast.onmouseenter = Swal.stopTimer;
					    toast.onmouseleave = Swal.resumeTimer;
					  }
					});
				Toast.fire({
				  icon: "info",
				  iconHtml: robotIcon,
				  title: "AI 결재 작성 완료!"
				});
			}
        })
        .catch(error => { console.error(error); });
    
    
}); 

const now = new Date();
const formattedDate = now.getFullYear() + "-" + (now.getMonth() + 1).toString().padStart(2, '0') + "-" + now.getDate().toString().padStart(2, '0');
const formattedDraftDate = now.getFullYear() + "/" + (now.getMonth() + 1).toString().padStart(2, '0') + "/" + now.getDate().toString().padStart(2, '0');
$("#currentDate").text(formattedDate);
$("#draftDate").text(formattedDraftDate);

// 2. 양식 변경 함수
function changeTemplate(val) {
	
    // 공통 상단 테이블 
    var getCommonHeader = function(title) {
        var header = "";
        header += "<div style='max-width:850px; margin:0 auto;'>";
        header += "<h2 style='text-align:center;'>" + title + "</h2>";
        return header;
    };

   	// [KJS] AI로부터 받아온 자동 입력 데이터를 넣어줬습니다
   	const AIContentData = AIData ? AIData.contentData : {}; 

   	const templates = {
        resource: getCommonHeader("[인력 투입 요청]") + `
            <p>상기 관련 근거에 의거 아래와 같이 진행하고자 하오니 승인하여 주시기 바랍니다. </p>
            <p><strong>1. 투입 목적</strong></p>
            <p>- \${AIContentData.inputPurpose || ""}</p>
            <p><strong>2. 투입 요청 상세</strong></p>
            <table border="1" style="width:100%; border-collapse:collapse;">
                <thead style="background-color:#f8f9fa;">
                    <tr>
                        <th style="width:20%;">구분</th>
                        <th style="width:30%;">필요 인원/자원</th>
                        <th style="width:30%;">투입 기간</th>
                        <th style="width:20%;">비고</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                    	<td style="height:30px; text-align:center;">인력</td>
                    	<td>\${AIContentData.requiredPeople || ""}</td>
                    	<td>\${AIContentData.peoplePeriod || ""}</td>
                    	<td>\${AIContentData.peopleNote || ""}</td>
                   	</tr>
                    <tr>
                    	<td style="height:30px; text-align:center;">장비/기타</td>
                    	<td>\${AIContentData.requiredResources || ""}</td>
                    	<td>\${AIContentData.resourcesPeriod || ""}</td>
                    	<td>\${AIContentData.resourcesNote || ""}</td>
                   	</tr>
                </tbody>
            </table>
            </div>`,
        schedule: getCommonHeader("[일정 변경 요청]") + `
            <p><strong>1. 변경 사유</strong></p>
            <p>- \${AIContentData.changeReason || ""}</p>
            <p><strong>2. 일정 변경 대비</strong></p>
            <table border="1" style="width:100%; border-collapse:collapse;">
                <thead style="background-color:#f8f9fa;">
                    <tr>
                        <th style="width:30%;">구분</th>
                        <th style="width:35%;">기존 일정</th>
                        <th style="width:35%;">변경(안)</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                    	<td style="height:30px; text-align:center;">착수일</td>
                    	<td>\${AIContentData.existingStartDate || ""}</td>
                    	<td>\${AIContentData.changeStartDate || ""}</td>
                   	</tr>
                    <tr>
	                    <td style="height:30px; text-align:center;">종료일</td>
	                    <td>\${AIContentData.existingEndDate || ""}</td>
	                    <td>\${AIContentData.changeEndDate || ""}</td>
                    </tr>
                </tbody>
            </table>
            </div>`,
        budget: getCommonHeader("[예산 조정 요청]") + `
            <p><strong>1. 조정 사유</strong></p>
            <p>- \${AIContentData.adjustmentReason || ""}</p>
            <p><strong>2. 예산 조정 내역 (단위: 원)</strong></p>
            <table border="1" style="width:100%; border-collapse:collapse;">
                <thead style="background-color:#f8f9fa;">
                    <tr>
                        <th>항목</th>
                        <th>기존 예산</th>
                        <th>조정 금액</th>
                        <th>최종 예산</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                    	<td style="height:30px;">\${AIContentData.adjustItem || ""}</td>
                    	<td>\${AIContentData.existingBudget || ""}</td>
                    	<td>\${AIContentData.adjustAmount || ""}</td>
                    	<td>\${AIContentData.finalBudget || ""}</td>
                   	</tr>
                </tbody>
            </table>
            </div>`,
        check: getCommonHeader("[검수 및 보고]") + `
            <p><strong>1. 검수 대상</strong></p>
            <p>- \${AIContentData.inspectTarget || ""}</p>
            <p><strong>2. 검수 결과 요약</strong></p>
            <table border="1" style="width:100%; border-collapse:collapse;">
                <tr>
                    <th style="width:30%; background-color:#f8f9fa;">검수 결과</th>
                    <td style="padding:10px;">■ 적합 / □ 보완필요 / □ 부적합</td>
                </tr>
                <tr>
                    <th style="background-color:#f8f9fa;">주요 이슈</th>
                    <td style="padding:10px; height:60px;">\${AIContentData.keyIssue || ""}</td>
                </tr>
            </table>
            </div>`,
        report: getCommonHeader("[최종 완료 보고]") + `
            <p><strong>1. 프로젝트 개요</strong></p>
            <p>- 수행 기간: \${AIContentData.duration || ""}</p>
            <p><strong>2. 최종 성과</strong></p>
            <p>- 주요 목표 달성 여부: \${AIContentData.objectiveAchieved || ""}</p>
            <p><strong>3. 향후 유지보수 계획</strong></p>
            <p>- \${AIContentData.maintenanceSystem || ""}</p>
            </div>`,
        other: getCommonHeader("[기타 요청]") + `
            <p><strong>1. 요청 내용</strong></p>
            <div style="min-height:150px; border:1px solid #dee2e6; padding:10px;">
            	\${AIContentData.requestContent || "여기에 상세 내용을 입력하세요."}
            </div>
            </div>`
    };

    if(val && myEditor) {
        // JSP에서 전달받은 로그인 사용자 정보를 여기에 바로 넣으려면 변수를 활용하세요
        // 예: getCommonHeader("제목", "${loginUser.memberName}", "${loginUser.memberDepartment}")
        myEditor.setData(templates[val]);
    }
}

//파일 첨부
function updateFileList() {
    console.log("1. updateFileList 함수 진입 완료!");
    const fileInput = document.getElementById('upfile');
    
    if (!fileInput.files || fileInput.files.length === 0) {
        console.log("2. 선택된 파일이 없습니다.");
        return;
    }

    const newFiles = Array.from(fileInput.files);
    console.log("3. 새로 선택된 파일들:", newFiles);

    uploadedFiles = [...uploadedFiles, ...newFiles];
    console.log("4. 전체 누적 파일들:", uploadedFiles);

    renderFiles();
    fileInput.value = ""; // 초기화
}

//파일 목록을 화면에 그려주는 함수
function renderFiles() {
    const container = document.getElementById('fileListContainer');
    if (!container) return; // 컨테이너가 없으면 종료

    if (uploadedFiles.length === 0) {
        container.innerHTML = "첨부된 파일이 없습니다.";
        return;
    }

    let html = '<div class="mt-2">';
    uploadedFiles.forEach((file, index) => {
        const size = (file.size / 1024 / 1024).toFixed(2); // MB 단위
        html += `
            <div class="d-flex align-items-center justify-content-between bg-white border rounded p-2 mb-1 shadow-sm">
                <span class="small"><i class="bi bi-file-earmark-check me-2 text-primary"></i>\${file.name} (${size}MB)</span>
                <i class="bi bi-x-circle text-danger" style="cursor:pointer;" onclick="removeFile(${index})"></i>
            </div>`;
    });
    html += '</div>';
    container.innerHTML = html;
}

// 파일 삭제 함수
function removeFile(index) {
    uploadedFiles.splice(index, 1);
    renderFiles();
}

//1. 모달 열기 및 데이터 로드
function openApproverModal() {
    const projectNo = $("#projectSelect").val();
    
    if (projectNo === "0" || projectNo === "") {
        Swal.fire({
            icon: 'warning',          // 경고 아이콘 (노란색 느낌표)
            title: '필수 입력 누락',
            text: '프로젝트를 먼저 선택해주세요.',
            confirmButtonColor: '#f8bb86', // 경고에 어울리는 색상
            confirmButtonText: '확인'
        }).then(() => {
            $("#projectSelect").focus(); // 확인 버튼 누른 후 포커스 이동
        });
        return;
    }

    $.ajax({
        url: contextPath + "/approval/getApproverList",
        type: "GET",
        data: { projectNo: projectNo },
        success: function(data) {
            try {
                renderApproverList(data); // 1. 리스트 그리기 (여기서 에러가 나도 catch로 보냄)
            } catch (e) {
                console.error("렌더링 중 에러 발생:", e);
            }
            
            // 2. 모달 띄우기 (강제로 실행)
            const modalEl = document.getElementById('approvalLineModal');
            if (modalEl) {
                let myModal = bootstrap.Modal.getInstance(modalEl);
                if (!myModal) myModal = new bootstrap.Modal(modalEl);
                myModal.show();
            } else {
                console.error("모달 HTML 요소를 찾을 수 없습니다! ID를 확인하세요.");
            }
        },
        error: function(xhr) {
            console.error("에러 발생 상태값:", xhr.status); // 에러 번호 확인
            alert("서버 통신 실패!");
        }
    });
}

// 2. 결재자 목록 렌더링 (1열 심플 아코디언 형태)
function renderApproverList(data) {
    console.log("렌더링 시작!", data);
    const container = $("#accordionContainer");
    container.empty();

    if (!data || data.length === 0) {
        container.append('<div class="text-center py-4">조회된 결재자가 없습니다.</div>');
        return;
    }

    // 부서별 그룹화 (부서가 없으면 '미지정' 처리)
    const grouped = data.reduce((acc, obj) => {
        const key = obj.memberDepartment || "부서미지정";
        if (!acc[key]) acc[key] = [];
        acc[key].push(obj);
        return acc;
    }, {});

    Object.keys(grouped).forEach((dept, index) => {
        const deptId = `list-group-${index}`;
        let html = `
            <div class="accordion-item border-0 mb-3 shadow-sm">
                <div class="fw-bold p-2 bg-light border-bottom" style="font-size: 0.9rem;">
                    <i class="bi bi-folder2-open me-2 text-primary"></i> \${dept}
                </div>
                <div class="list-group sortable-list" id="\${deptId}">`;
        
        grouped[dept].forEach(mem => {
            const isChecked = selectedApprovers.some(a => a.memNo == mem.memberNo);
            
            html += `
                <div class="todo-item-row d-flex align-items-center p-2 px-3 approver-item" 
                     data-no="\${mem.memberNo}" 
                     data-name="\${mem.memberName}"
                    	 data-position="\${mem.memberPosition || ''}">
                    <input type="checkbox" class="form-check-input custom-chk me-3 approver-chk" 
                           value="\${mem.memberNo}" \${isChecked ? 'checked' : ''}
                           onchange="handleCheck(this, '\${mem.memberName}', '\${mem.memberPosition}')">
                    <div class="flex-grow-1">
                        <span class="fw-bold small">\${mem.memberName}</span>
                        <span class="text-muted" style="font-size: 0.75rem;">\${mem.memberPosition || ''}</span>
                    </div>
                    <span class="badge bg-primary rounded-pill order-badge \${isChecked ? '' : 'd-none'}"></span>
                    <i class="bi bi-grip-vertical ms-2 drag-handle text-muted" 
                       style="cursor:grab; \${isChecked ? '' : 'display:none;'}"></i>
                </div>`;
        });

        html += `</div></div>`;
        container.append(html);
        
        // SortableJS가 로드되었는지 확인 후 실행
        if (typeof Sortable !== 'undefined') {
            initSortable(deptId);
        }
    });
    updateOrderBadges();
}

// 3. 체크박스 클릭 핸들링
function handleCheck(chk, name, position) {
    const mNo = $(chk).val();
    const row = $(chk).closest('.approver-item');

    if (chk.checked) {
        if (selectedApprovers.length >= 5) {
            alert("최대 5명까지 선택 가능합니다.");
            chk.checked = false;
            return;
        }
        selectedApprovers.push({ memNo: mNo, name: name , memberPosition : position});
        row.find('.drag-handle').show();
    } else {
        selectedApprovers = selectedApprovers.filter(a => a.memNo != mNo);
        row.find('.drag-handle').hide();
    }
    updateOrderBadges();
}

// 4. 순서 배지 업데이트
function updateOrderBadges() {
    $('.order-badge').addClass('d-none');
    selectedApprovers.forEach((mem, idx) => {
        const row = $(`.approver-item[data-no="\${mem.memNo}"]`);
        row.find('.order-badge').text(idx + 1).removeClass('d-none');
    });
}

// 5. 드래그 앤 드롭 초기화
function initSortable(id) {
    const el = document.getElementById(id);
    new Sortable(el, {
        handle: '.drag-handle',
        animation: 150,
        onEnd: function() { reorderListByDOM(); }
    });
}

function reorderListByDOM() {
    let newOrder = [];
    $('.approver-chk:checked').each(function() {
    	const row = $(this).closest('.approver-item');
        const mNo = $(this).val();
        const name = row.data('name');
        const position = row.data('position');

        newOrder.push({ memNo: mNo, name: name, memberPosition: position });
    });
    selectedApprovers = newOrder;
    updateOrderBadges();
}

// 6. 메인 화면 슬롯 업데이트 (모달 -> 본문)
function confirmApprovalLine() {
    if (selectedApprovers.length === 0) {
        alert("결재자를 선택해주세요.");
        return;
    }
    setApproverList(selectedApprovers);
    bootstrap.Modal.getInstance(document.getElementById('approvalLineModal')).hide();
}

function setApproverList(list) {
    $(".slot-name").html('<span class="text-muted" style="cursor:pointer;" onclick="openApproverModal()">지정</span>');
    $(".approver-slot input").val("");

    list.forEach((member, index) => {
        if(index < 5) {
            let slot = $("#slot-" + (index + 1));
            
            const displayPos = member.memberPosition || '';
            
            slot.find(".position").text(displayPos);
            slot.find(".slot-name").text(member.name);
            slot.find(".date").text(formattedDraftDate);
            slot.find(".mem-no").val(member.memNo);
            
            console.log(`\${index+1}번 슬롯에 들어갈 직급:`, displayPos);
        }
    });
}

// 7. 검색 필터링
function filterApprovers() {
    const val = $("#approverSearch").val().toLowerCase();
    $(".accordion-item").each(function() {
        let hasMatch = false;
        $(this).find(".approver-item").each(function() {
            const name = $(this).data('name').toLowerCase();
            if (name.includes(val)) { $(this).show(); hasMatch = true; } 
            else { $(this).hide(); }
        });
        hasMatch ? $(this).show() : $(this).hide();
    });
}

// 8. 결재 상신 (AJAX)
function submitApproval() {
	console.log("상신 프로세스 시작!");
	
	const formData = new FormData();
	const projectNo = $("#projectSelect").val();
    const docTitle = $("#docTitle").val();
    
    const selectedVal = $("#docType").val();
    
    const docTypeCode = docTypeMap[selectedVal] || 606;
    
 	// 유효성 검사
    if (projectNo === "0" || !docTitle) {
    	Swal.fire({
            icon: 'warning',
            title: '필수 입력 누락',
            text: '문서 제목을 입력해주세요.',
            confirmButtonText: '확인'
        }).then(() => {
            $("#docTitle").focus();
        });
        return;
    }
	
    formData.append("projectNo", projectNo);
    formData.append("documentTitle", docTitle);
    formData.append("documentContent", myEditor.getData());
    formData.append("documentType", docTypeCode); // 기안문서
    formData.append("documentStatus", 611);
    formData.append("security", $("input[name='security']:checked").val());
	
    let approvalList = [];
    $(".approver-slot").each(function(index) {
        const memNo = $(this).find(".mem-no").val();
        if(memNo) {
            approvalList.push({
                memberNo: parseInt(memNo),
                approvalStep: index + 1,
                approvalStatus: 607 
            });
        }
    });
    
    if(approvalList.length === 0) {
        alert("결재선을 최소 한 명 이상 지정해주세요.");
        return;
    }
    
    formData.append("approvalListJson", JSON.stringify(approvalList));
    console.log("결재선 JSON:", JSON.stringify(approvalList));
    
    if (uploadedFiles.length > 0) {
        uploadedFiles.forEach(file => {
            formData.append("upfile", file);
        });
        console.log("첨부파일 개수:", uploadedFiles.length);
    }

    $.ajax({
        url: contextPath + "/approval/insert",
        type: "POST",
        data: formData,
        processData: false, 
        contentType: false,
        success: function(res) {
            if(res === "success") {
                Swal.fire({
                    icon: 'success',
                    title: '상신 완료!',
                    text: '상신이 완료 되었습니다.',
                    confirmButtonColor: '#3085d6',
                    confirmButtonText: '확인'
                }).then((result) => {
                    if (result.isConfirmed) {
                        location.href = contextPath + "/approval/list";
                    }
                });
            } else {
                Swal.fire({
                    icon: 'error',
                    title: '상신 실패',
                    text: '오류 내용: ' + res
                });
            }
        },
        error: function(xhr) {
            console.error("에러 발생:", xhr.status, xhr.responseText);
            Swal.fire({
                icon: 'error',
                title: '통신 에러 발생',
                text: '서버와 연결하는 중 문제가 발생했습니다. (상태 코드: ' + xhr.status + ')',
                confirmButtonColor: '#d33',
                confirmButtonText: '닫기'
            });
        }
    });
}

$(function() { $("#btnSubmit").on("click", submitApproval); });
</script>
</body>
</html>