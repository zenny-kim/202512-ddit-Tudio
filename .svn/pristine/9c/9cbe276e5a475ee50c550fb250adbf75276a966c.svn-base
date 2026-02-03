<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="tab-content-card">

	<h5 class="mb-3">프로젝트 간트 차트</h5>
	
	<div class="d-flex justify-content-between align-items-center mb-3 p-2 bg-light rounded">
	    <div class="d-flex align-items-center">
	        <div class="btn-group btn-group-sm me-3">
	            <button type="button" class="btn btn-outline-secondary active">월별</button>
	            <button type="button" class="btn btn-outline-secondary">주별</button>
	            <button type="button" class="btn btn-outline-secondary">일별</button>
	        </div>
	        <button class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrows-expand me-1"></i> 전체 펼치기</button>
	    </div>
	    <small class="text-muted">기준 시점: 2025-12-16</small>
	</div>
	
	<div class="gantt-wrapper shadow-sm">
	    <div class="gantt-sidebar">
	        <table class="table table-sm table-striped mb-0 small">
	            <thead class="sticky-top table-light">
	                <tr>
	                    <th style="width: 50%;">업무명</th>
	                    <th style="width: 30%;">담당자</th>
	                    <th style="width: 20%;">기간</th>
	                </tr>
	            </thead>
	            <tbody>
	                <tr class="table-primary fw-bold" style="cursor: pointer;"><td><i class="bi bi-caret-down-fill me-1"></i> 1. 서비스 기획</td><td>PM</td><td>15일</td></tr>
	                <tr><td class="ps-3">요구사항 정의</td><td>김기획</td><td>12/01~12/05</td></tr>
	            </tbody>
	        </table>
	    </div>
	    
	    <div class="gantt-chart-area" id="ganttChartArea">
	        <div class="gantt-bars-container"> 
	            <h6 class="text-center text-muted border-bottom pb-2">가상 시간표 (12월)</h6>
	            <div class="current-time-line"></div> <div class="gantt-bars" style="min-width: 1000px; padding-top: 5px;">
	                <div style="height: 38px;"></div> <div class="gantt-bar-row">
	                    <span class="bg-success rounded text-white px-2 small position-absolute" style="left: 0%; width: 60px; top: 8px; line-height: 20px;">완료됨</span>
	                </div>
	            </div>
	        </div>
	    </div>
	</div>
</div>