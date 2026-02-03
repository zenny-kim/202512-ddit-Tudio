<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<nav class="breadcrumb-nav mb-4">
    <span class="text-muted">Admin</span>
    <span class="sep"><i class="bi bi-chevron-right small"></i></span>
    <span class="text-body fw-bold">로그 관리</span>
    <span class="sep"><i class="bi bi-chevron-right small"></i></span>
    <span class="text-primary fw-bold">로그인 로그</span>
</nav>

<div class="card admin-card mb-4">
    <div class="card-body bg-light rounded">
        <form class="row g-3 align-items-end">
            <div class="col-md-4">
                <label class="form-label fw-bold small text-muted">조회 기간</label>
                <div class="input-group">
                    <input type="date" class="form-control" id="search-start-date">
                    <span class="input-group-text bg-white border-start-0 border-end-0">~</span>
                    <input type="date" class="form-control" id="search-end-date">
                </div>
            </div>
            
            <div class="col-md-2">
                <label class="form-label fw-bold small text-muted">검색 조건</label>
                <select class="form-select">
                    <option value="id">아이디</option>
                    <option value="name">이름</option>
                    <option value="ip">접속 IP</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label fw-bold small text-muted">검색어</label>
                <input type="text" class="form-control" placeholder="검색어를 입력하세요">
            </div>

            <div class="col-md-2">
                <label class="form-label fw-bold small text-muted">로그인 상태</label>
                <select class="form-select">
                    <option value="all">전체</option>
                    <option value="success">성공</option>
                    <option value="fail">실패</option>
                </select>
            </div>

            <div class="col-md-1">
                <button type="button" class="btn btn-primary w-100" onclick="searchLogs()">
                    <i class="bi bi-search"></i>
                </button>
            </div>
        </form>
    </div>
</div>

<div class="card admin-card">
    <div class="admin-card-header d-flex justify-content-between align-items-center">
        <div>
            <h5 class="fw-bold mb-0">📋 로그인 이력 목록</h5>
            <small class="text-muted">
                총 <span class="text-primary fw-bold">${not empty logList ? fn:length(logList) : 0}</span>건의 로그가 검색되었습니다. 
                (로그 보관 기간: <span class="text-danger">6개월</span>)
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
                    <th scope="col">접속 일시</th>
                    <th scope="col">사용자 (ID)</th>
                    <th scope="col">접속 IP</th>
                    <th scope="col">OS / 브라우저</th>
                    <th scope="col" class="text-center">상태</th>
                    <th scope="col">비고 (실패 사유 등)</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty logList}">
                        <c:forEach var="log" items="${logList}">
                            <tr>
                                <td class="text-center">${log[0]}</td>
                                
                                <td>${log[1]}</td>
                                
                                <td>
                                    <span class="fw-bold">${log[2]}</span>
                                </td>
                                
                                <td>${log[3]}</td>
                                
                                <td>Windows 10 / Chrome</td>
                                
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${log[4] eq '성공'}">
                                            <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25">성공</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25">실패</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <td class="text-muted small">
                                    <c:if test="${log[4] ne '성공'}">
                                        <span class="text-danger">비밀번호 오류</span>
                                    </c:if>
                                    <c:if test="${log[4] eq '성공'}">
                                        -
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7" class="text-center py-5 text-muted">
                                <i class="bi bi-info-circle fs-3 d-block mb-3"></i>
                                검색된 로그 데이터가 없습니다.
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
                <li class="page-item"><a class="page-link" href="#">3</a></li>
                <li class="page-item"><a class="page-link" href="#">4</a></li>
                <li class="page-item"><a class="page-link" href="#">5</a></li>
                <li class="page-item"><a class="page-link" href="#"><i class="bi bi-chevron-right"></i></a></li>
            </ul>
        </nav>
    </div>
</div>

<script>
    // 오늘 날짜로 date picker 초기화
    document.getElementById('search-start-date').valueAsDate = new Date();
    document.getElementById('search-end-date').valueAsDate = new Date();

    function searchLogs() {
        // 검색 버튼 클릭 시 동작 (추후 검색 조건 쿼리스트링 생성 로직 필요)
        alert("검색 기능은 컨트롤러와 연동 후 작동합니다.");
        // 예: loadPage('/admin/log/login?startDate=...');
    }

    function downloadExcel() {
        var count = "${not empty logList ? fn:length(logList) : 0}";
        if(confirm("현재 검색된 " + count + "건의 로그를 엑셀로 다운로드 하시겠습니까?")) {
            alert("다운로드가 시작되었습니다.");
            // location.href = "/admin/log/login/excel"; // 엑셀 다운로드 컨트롤러 주소
        }
    }
</script>