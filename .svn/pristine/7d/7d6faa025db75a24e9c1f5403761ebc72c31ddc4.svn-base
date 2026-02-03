<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<nav class="breadcrumb-nav mb-4">
    <span class="text-muted">Admin</span>
    <span class="sep"><i class="bi bi-chevron-right small"></i></span>
    <span class="text-body fw-bold">로그 관리</span>
    <span class="sep"><i class="bi bi-chevron-right small"></i></span>
    <span class="text-danger fw-bold">오류 로그</span> </nav>

<div class="card admin-card mb-4">
    <div class="card-body bg-light rounded">
        <form class="row g-3 align-items-end">
            <div class="col-md-4">
                <label class="form-label fw-bold small text-muted">발생 기간</label>
                <div class="input-group">
                    <input type="date" class="form-control" id="search-start-date">
                    <span class="input-group-text bg-white border-start-0 border-end-0">~</span>
                    <input type="date" class="form-control" id="search-end-date">
                </div>
            </div>
            
            <div class="col-md-2">
                <label class="form-label fw-bold small text-muted">오류 유형</label>
                <select class="form-select">
                    <option value="all">전체</option>
                    <option value="500">500 (Server Error)</option>
                    <option value="404">404 (Not Found)</option>
                    <option value="403">403 (Forbidden)</option>
                    <option value="400">400 (Bad Request)</option>
                </select>
            </div>

            <div class="col-md-3">
                <label class="form-label fw-bold small text-muted">검색어 (URL, 메시지)</label>
                <input type="text" class="form-control" placeholder="검색어를 입력하세요">
            </div>

            <div class="col-md-2 d-flex gap-2">
                <button type="button" class="btn btn-primary flex-fill" onclick="searchLogs()">
                    <i class="bi bi-search"></i> 검색
                </button>
                <button type="button" class="btn btn-outline-secondary" onclick="resetForm()">
                    <i class="bi bi-arrow-counterclockwise"></i>
                </button>
            </div>
        </form>
    </div>
</div>

<div class="card admin-card">
    <div class="admin-card-header d-flex justify-content-between align-items-center">
        <div>
            <h5 class="fw-bold mb-0 text-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>시스템 오류 발생 내역</h5>
            <small class="text-muted">
                총 <span class="text-danger fw-bold">${not empty errorList ? fn:length(errorList) : 0}</span>건의 오류가 감지되었습니다.
            </small>
        </div>
        <div>
            <button class="btn btn-success btn-sm" onclick="downloadExcel()">
                <i class="bi bi-file-earmark-excel-fill"></i> 엑셀 다운로드
            </button>
        </div>
    </div>
    
    <div class="table-responsive p-3">
        <table class="table table-hover align-middle" style="font-size: 0.95rem;">
            <thead class="table-light text-muted">
                <tr>
                    <th scope="col" class="text-center" style="width: 60px;">No</th>
                    <th scope="col" style="width: 160px;">발생 일시</th>
                    <th scope="col" class="text-center" style="width: 100px;">Code</th>
                    <th scope="col">요청 URL</th>
                    <th scope="col">오류 메시지 (Summary)</th>
                    <th scope="col" style="width: 120px;">발생자</th>
                    <th scope="col" class="text-center" style="width: 100px;">상세</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty errorList}">
                        <c:forEach var="err" items="${errorList}">
                            <tr>
                                <td class="text-center">${err[0]}</td>
                                <td>${err[1]}</td>
                                
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${fn:startsWith(err[2], '5')}">
                                            <span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25">${err[2]}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-warning bg-opacity-10 text-dark border border-warning border-opacity-25">${err[2]}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <td class="text-primary small text-truncate" style="max-width: 200px;">${err[3]}</td>
                                <td class="text-truncate" style="max-width: 300px;">${err[4]}</td>
                                <td><span class="fw-bold text-secondary">${err[5]}</span></td>
                                
                                <td class="text-center">
                                    <button class="btn btn-sm btn-light border" onclick="showErrorDetail('${err[0]}', '${err[2]}', '${err[4]}')">
                                       	<i class="bi bi-search"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7" class="text-center py-5 text-muted">
                                <i class="bi bi-check-circle fs-3 d-block mb-3 text-success"></i>
                                최근 발생한 오류 내역이 없습니다.
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>

    <div class="card-footer bg-white border-0 py-3">
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center mb-0">
                <li class="page-item disabled"><a class="page-link" href="#"><i class="bi bi-chevron-left"></i></a></li>
                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                <li class="page-item"><a class="page-link" href="#">2</a></li>
                <li class="page-item"><a class="page-link" href="#"><i class="bi bi-chevron-right"></i></a></li>
            </ul>
        </nav>
    </div>
</div>

<div class="modal fade" id="errorDetailModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-bug-fill me-2"></i>오류 상세 정보</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label fw-bold text-muted small">오류 코드</label>
                    <input type="text" class="form-control" id="modal-error-code" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold text-muted small">오류 메시지</label>
                    <textarea class="form-control text-danger fw-bold" id="modal-error-msg" rows="2" readonly></textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold text-muted small">Stack Trace (상세 로그)</label>
                    <div class="p-3 bg-dark text-white rounded small font-monospace" style="height: 200px; overflow-y: auto;">
                        at com.tudio.controller.UserController.delete(UserController.java:45)<br>
                        at com.tudio.service.UserService.removeUser(UserService.java:102)<br>
                        at java.base/java.lang.Thread.run(Thread.java:833)<br>
                        ... (실제 DB에서 가져온 Stack Trace 내용이 여기에 표시됩니다)
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

<script>
    // 날짜 초기화
    document.getElementById('search-start-date').valueAsDate = new Date();
    document.getElementById('search-end-date').valueAsDate = new Date();

    function searchLogs() {
        alert("검색 기능은 추후 개발됩니다.");
    }

    function downloadExcel() {
        alert("엑셀 다운로드를 시작합니다.");
    }

    // 모달 열기 함수
    function showErrorDetail(id, code, msg) {
        document.getElementById('modal-error-code').value = code;
        document.getElementById('modal-error-msg').value = msg;
        
        // Bootstrap 5 모달 띄우기
        var myModal = new bootstrap.Modal(document.getElementById('errorDetailModal'));
        myModal.show();
    }
</script>