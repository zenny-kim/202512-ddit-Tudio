<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
.chart-wrap { position: relative; width: 100%; height: 260px; }
.chart-wrap canvas { display: block; width: 100% !important; height: 100% !important; }
</style>

<div class="tudio-scope">
	<div class="tudio-section mb-4">
		<div class="tudio-section-header">
			<h5 class="m-0 fw-bold text-primary-dark"><i class="bi bi-pie-chart-fill me-2"></i>프로젝트 요약·분석</h5>
			<div class="d-flex gap-2">
				<button class="tudio-btn tudio-btn-outline" onclick="window.print()"><i class="bi bi-printer"></i> 리포트 출력</button>
			</div>
		</div>
	</div>

	<div class="row mb-4">
		<div class="col-12">
			<div class="tudio-card p-4 shadow-sm" style="border: 1px solid rgba(0, 0, 0, 0.05); background-color: #fff;">
				<span class="text-primary-dark fw-bold d-block mb-2" style="font-size: 1.05rem; letter-spacing: -0.02em;">프로젝트 개요</span>
				<div class="text-dark fw-medium" style="line-height: 1.5; white-space: pre-wrap; font-size: 0.85rem; letter-spacing: -0.01em; text-align: left; color: #4b5563 !important;"><c:out value="${not empty insight.projectDesc ? insight.projectDesc : '등록된 프로젝트 설명이 없습니다.'}" /></div>
			</div>
		</div>
	</div>

	<div class="row g-3 mb-4">
		<div class="col-md-3">
			<div class="tudio-card p-3 h-100 d-flex flex-column justify-content-between">
				<span class="text-muted small fw-bold">총 업무</span>
				<div class="d-flex align-items-end justify-content-between mt-2">
					<h2 class="fw-bold m-0 text-primary-dark">${not empty insight.totalTaskCount ? insight.totalTaskCount : 0}<span class="fs-6 fw-normal text-muted ms-1">건</span></h2>
					<i class="bi bi-check2-square fs-3 text-primary-light" style="opacity: 0.3"></i>
				</div>
				<div class="mt-2 text-end">
				    <span class="badge bg-primary bg-opacity-10 text-primary rounded-pill px-2" style="font-size: 11px;">상위 ${insight.parentTaskCount} / 단위 ${insight.subTaskCount}</span>
				</div>
			</div>
		</div>
		<div class="col-md-3">
			<div class="tudio-card p-3 h-100 d-flex flex-column justify-content-between">
				<span class="text-muted small fw-bold">전체 업무 진행률</span>
				<div class="d-flex align-items-end justify-content-between mt-2">
					<h2 class="fw-bold m-0 text-primary">${not empty insight.overallProgress ? insight.overallProgress : 0}<span class="fs-6 fw-normal text-muted ms-1">%</span></h2>
					<i class="bi bi-graph-up-arrow fs-3 text-primary" style="opacity: 0.3"></i>
				</div>
				<div class="progress mt-3" style="height: 6px;">
					<div class="progress-bar" role="progressbar" style="width: ${insight.overallProgress}%; background-color: var(--main-blue);" aria-valuenow="${insight.overallProgress}" aria-valuemin="0" aria-valuemax="100"></div>
				</div>
			</div>
		</div>
		<div class="col-md-3">
			<div class="tudio-card p-3 h-100 d-flex flex-column justify-content-between">
				<span class="text-muted small fw-bold">지연 업무</span>
				<div class="d-flex align-items-end justify-content-between mt-2">
					<h2 class="fw-bold m-0 text-primary-dark">${not empty insight.delayedTaskCount ? insight.delayedTaskCount : 0}<span class="fs-6 fw-normal text-muted ms-1">건</span></h2>
					<i class="bi bi-exclamation-triangle-fill fs-3 text-muted" style="opacity: 0.3"></i>
				</div>
				<div class="mt-2 text-muted small text-end">마감일 경과 업무 수</div>
			</div>
		</div>
		<div class="col-md-3">
			<div class="tudio-card p-3 h-100 d-flex flex-column justify-content-between">
				<span class="text-muted small fw-bold">프로젝트 일정</span>
				<div class="d-flex align-items-end justify-content-between mt-2">
					<h2 class="fw-bold m-0 text-dark">${not empty insight.projectDday ? insight.projectDday : 'D-?'}</h2>
					<i class="bi bi-hourglass-split fs-3 text-muted" style="opacity: 0.3"></i>
				</div>
				<div class="mt-2 text-muted small text-end">현 시점 기준 남은 일수</div>
			</div>
		</div>
	</div>

	<div class="row g-4 mb-4">
		<div class="col-md-4">
			<div class="tudio-card p-4 h-100">
				<h6 class="fw-bold mb-4 text-primary-dark">업무 상태 분포</h6>
				<div style="position: relative; height: 250px; width: 100%;"><canvas id="taskStatusChart"></canvas></div>
				<div class="mt-3 text-center small text-muted">상위·단위 전체 업무(${insight.totalTaskCount}건) 상태 분포</div>
			</div>
		</div>
		<div class="col-md-8">
			<div class="tudio-card p-4 h-100">
				<div class="d-flex justify-content-between align-items-center mb-4">
					<h6 class="fw-bold m-0 text-primary-dark">일정 준수 현황</h6>
					<span class="tudio-badge qna">전체 업무(${insight.totalTaskCount}건) 기준</span>
				</div>
				<div style="position: relative; height: 250px; width: 100%;"><canvas id="schedulePerformanceChart"></canvas></div>
				<div class="row mt-3 text-center small">
				    <div class="col text-success"><i class="bi bi-lightning-fill"></i> 조기 완료</div>
				    <div class="col text-primary"><i class="bi bi-check-circle-fill"></i> 정시 완료</div>
				    <div class="col text-danger"><i class="bi bi-clock-history"></i> 지연 완료</div>
				    <div class="col text-secondary"><i class="bi bi-pause-circle-fill"></i> 미완료 업무</div>
				</div>
			</div>
		</div>
	</div>

	<div class="row g-4 mb-4">
		<div class="col-md-4">
			<div class="tudio-card p-4 h-100">
				<h6 class="fw-bold mb-4 text-primary-dark">업무 우선순위 분포 비율</h6>
				<div style="position: relative; height: 250px; width: 100%;"><canvas id="taskPriorityChart"></canvas></div>
				<div class="mt-3 text-center small text-muted">상위·단위 전체 업무(${insight.totalTaskCount}건) 우선순위 분포</div>
			</div>
		</div>
		<div class="col-md-8">
			<div class="tudio-card p-4 h-100">
				<h6 class="fw-bold mb-4 text-primary-dark">프로젝트 기간 대비 누적 완료율</h6>
				<div class="chart-wrap"><canvas id="projectProgressChart"></canvas></div>
			</div>
		</div>
	</div>

	<div class="tudio-section">
		<div class="tudio-section-header"><h6 class="m-0 fw-bold text-primary-dark">팀원별 업무 기여도</h6></div>
		<div class="table-responsive">
			<table class="table tudio-table-card table-hover m-0">
				<thead class="bg-light">
					<tr>
						<th class="ps-4">이름 / 직책</th>
						<th class="text-center">배정된 업무</th>
						<th class="text-center">진행 중</th>
						<th class="text-center">완료</th>
						<th class="text-center">지연</th>
						<th class="text-center">완료율</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${memberList}" var="member">
						<tr>
							<td class="ps-4">
								<div class="d-flex align-items-center">
									<div class="bg-light text-primary rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 36px; height: 36px; font-weight: 700;">${member.memberName.substring(0, 1)}</div>
									<div><div class="fw-bold text-dark">${member.memberName}</div><div class="small text-muted">${member.memberPosition}</div></div>
								</div>
							</td>
							<td class="text-center align-middle fw-bold">${member.totalTaskCnt}건</td>
							<td class="text-center align-middle text-primary">${member.ingCnt}</td>
							<td class="text-center align-middle text-success">${member.doneCnt}</td>
							<td class="text-center align-middle ${member.delayCnt > 0 ? 'text-danger fw-bold' : ''}">${member.delayCnt}</td>
							<td class="text-center align-middle">
								<div class="d-flex align-items-center justify-content-center">
									<c:set var="calcRate" value="${member.totalTaskCnt > 0 ? (member.doneCnt / member.totalTaskCnt) * 100 : 0}" />
									<div class="progress" style="width: 80px; height: 6px; margin-right: 8px;">
										<div class="progress-bar bg-primary" role="progressbar" style="width: ${calcRate}%"></div>
									</div>
									<span class="small fw-bold text-primary"><fmt:formatNumber value="${calcRate}" pattern="0.0" />%</span>
								</div>
							</td>
						</tr>
					</c:forEach>
					<c:if test="${empty memberList}"><tr><td colspan="6" class="text-center py-5 text-muted">참여 중인 팀원 정보가 없습니다.</td></tr></c:if>
				</tbody>
			</table>
		</div>
	</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>
<script>
(function() {
	// 데이터 준비
	const priorityLabels = []; const priorityCounts = [];
	<c:forEach items="${priorityData}" var="p">
		priorityLabels.push("${p.priorityLabel}"); priorityCounts.push(${p.priorityCnt});
	</c:forEach>
	
	const progressLabel = []; const progressPct = [];
	<c:forEach items="${progressData}" var="p">
	  progressLabel.push("${p.progressLabel}");
	  progressPct.push(${empty p.progressPct ? 'null' : p.progressPct});
	</c:forEach>

    const taskStats = {
        todo: ${insight.todoCount != null ? insight.todoCount : 0},
        inProgress: ${insight.inProgressCount != null ? insight.inProgressCount : 0},
        review: ${insight.reviewCount != null ? insight.reviewCount : 0},
        done: ${insight.doneCount != null ? insight.doneCount : 0}
    };

    const scheduleStats = {
        early: ${insight.earlyDoneCount != null ? insight.earlyDoneCount : 0},
        onTime: ${insight.onTimeDoneCount != null ? insight.onTimeDoneCount : 0},
        delayed: ${insight.lateDoneCount != null ? insight.lateDoneCount : 0}
    };

    const getPct = (val, total) => total > 0 ? ((val / total) * 100).toFixed(1) : '0.0';

	// 1. 업무 상태 파이 차트
    const ctxStatus = document.getElementById('taskStatusChart').getContext('2d');
    const sTotal = taskStats.todo + taskStats.inProgress + taskStats.review + taskStats.done;

    new Chart(ctxStatus, {
        type: 'doughnut',
        data: {
            labels: [
                '할 일 ' + taskStats.todo + '건 (' + getPct(taskStats.todo, sTotal) + '%)', 
                '진행 중 ' + taskStats.inProgress + '건 (' + getPct(taskStats.inProgress, sTotal) + '%)', 
                '검토 ' + taskStats.review + '건 (' + getPct(taskStats.review, sTotal) + '%)', 
                '완료 ' + taskStats.done + '건 (' + getPct(taskStats.done, sTotal) + '%)'
            ],
            datasets: [{
                data: [taskStats.todo, taskStats.inProgress, taskStats.review, taskStats.done],
                backgroundColor: ['#e2e8f0', '#3b82f6', '#f59e0b', '#22c55e'],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true, maintainAspectRatio: false,
            layout: { padding: { top: 0, bottom: 10 } },
            plugins: { legend: { position: 'bottom', labels: { usePointStyle: true, padding: 20, font: { size: 11 } } } },
            cutout: '70%'
        }
    });

	// 2. 업무 우선순위 도넛 차트
	const ctxPriority = document.getElementById('taskPriorityChart').getContext('2d');
    const pTotal = priorityCounts.reduce((a, b) => a + b, 0);

	new Chart(ctxPriority, {
	  type: 'doughnut',
	  data: {
	    labels: priorityLabels.map((l, i) => l + ' ' + priorityCounts[i] + '건 (' + getPct(priorityCounts[i], pTotal) + '%)'),
	    datasets: [{ data: priorityCounts, backgroundColor: ['#ef4444','#f97316','#3b82f6','#22c55e'], borderWidth: 0 }]
	  },
	  options: {
	    responsive: true, maintainAspectRatio: false, rotation: -90,
        layout: { padding: { top: 0, bottom: 10 } },
	    cutout: '70%',
	    plugins: { legend: { display: true, position: 'bottom', labels: { usePointStyle: true, padding: 20, font: { size: 11 } } }, datalabels: { display: false } }
	  }
	});

	// 3. 누적 완료율 (Line Chart)
	const ctxLine = document.getElementById('projectProgressChart');
	const lastIdx = progressPct.findLastIndex(v => v !== null);

	new Chart(ctxLine, {
	  type: 'line',
	  data: {
	    labels: progressLabel,
	    datasets: [{
	      label: '실제 진행률', data: progressPct, borderColor: '#2563eb', backgroundColor: 'rgba(37, 99, 235, 0.12)',
	      borderWidth: 3, tension: 0.35, fill: true,
	      pointRadius: (ctx) => ctx.raw == null ? 0 : 3,
	      pointBackgroundColor: (ctx) => ctx.dataIndex === lastIdx ? '#ef4444' : '#ffffff',
	      pointBorderColor: (ctx) => ctx.dataIndex === lastIdx ? '#dc2626' : '#2563eb',
	      pointBorderWidth: (ctx) => ctx.dataIndex === lastIdx ? 3 : 2
	    }]
	  },
	  options: {
	    responsive: true, maintainAspectRatio: false, spanGaps: false,
	    plugins: { legend: { display: false }, tooltip: { callbacks: { label: (ctx) => '진행률 ' + ctx.raw + '%' } } },
	    scales: { 
            x: { ticks: { color: (c) => c.index === lastIdx ? '#ef4444' : '#64748b' } },
            y: { min: 0, max: 100, ticks: { callback: (v) => v + '%' } }
        }
	  }
	});

    // 4. 일정 준수 바 차트
    const ctxBar = document.getElementById('schedulePerformanceChart').getContext('2d');
    const yetDone = ${insight.totalTaskCount} - (scheduleStats.early + scheduleStats.onTime + scheduleStats.delayed);

    new Chart(ctxBar, {
        type: 'bar',
        data: {
            labels: ['조기 완료', '정시 완료', '지연 완료', '미완료'],
            datasets: [{
                data: [scheduleStats.early, scheduleStats.onTime, scheduleStats.delayed, yetDone],
                backgroundColor: ['rgba(34, 197, 94, 0.2)', 'rgba(59, 130, 246, 0.2)', 'rgba(239, 68, 68, 0.2)', 'rgba(148, 163, 184, 0.2)'],
                borderColor: ['#22c55e', '#3b82f6', '#ef4444', '#94a3b8'],
                borderWidth: 1, borderRadius: 5, barThickness: 30
            }]
        },
        options: {
            indexAxis: 'y', responsive: true, maintainAspectRatio: false,
            layout: { padding: { left: 10, right: 30, top: 10, bottom: 10 } },
            plugins: { legend: { display: false }, tooltip: { callbacks: { label: (ctx) => ' ' + ctx.raw + '건' } } },
            scales: { x: { beginAtZero: true, ticks: { stepSize: 1 } }, y: { grid: { display: false } } }
        }
    });
})();
</script>