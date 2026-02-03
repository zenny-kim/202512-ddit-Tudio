<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>프로젝트 결과보고서</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.3/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/project_report.css">
</head>
<body>

<div class="toolbar">
	<c:if test="${not empty project.latestReportfileno}">
        <a href="${pageContext.request.contextPath}/tudio/project/report/download?fileNo=${project.latestReportfileno}" 
           class="btn btn-secondary fw-bold me-2" target="_blank">
            <i class="bi bi-file-earmark-pdf"></i> 이전 보고서 확인
        </a>
    </c:if>
    <form id="reportForm" action="${pageContext.request.contextPath }/tudio/project/report/send" method="post">
        <input type="hidden" name="projectNo" value="${project.projectNo}">
        <input type="hidden" name="memberNo" value="${sessionScope.loginMember.memberNo}">
        <input type="hidden" name="progressChartImage" id="progressChartImage">
        <input type="hidden" name="memberChartImage" id="memberChartImage">
        <button type="button" class="btn btn-primary fw-bold" onclick="submitReport()">
            <i class="bi bi-send"></i> 결과보고서 저장 및 발송
        </button>
    </form>
</div>

<div class="page-container">
    
    <h1>프로젝트 결과보고서</h1>

    <h2 class="secTitle">프로젝트 개요</h2>
    <table class="biz-table">
        <colgroup>
            <col style="width: 18%">
            <col style="width: 32%">
            <col style="width: 18%">
            <col style="width: 32%">
        </colgroup>
        <tr>
            <th>프로젝트명</th>
            <td>${project.projectName}</td>
            <th>프로젝트 관리자</th>
            <td>${project.pmName}</td>
        </tr>
        <tr>
            <th>프로젝트 기간</th>
            <td colspan="3">
                <fmt:formatDate value="${project.projectStartdate}" pattern="yyyy-MM-dd" />
                 ~ 
                <fmt:formatDate value="${project.projectFinishdate}" pattern="yyyy-MM-dd" />
            </td>
        </tr>
        <tr>
            <th>프로젝트 목적<br>(개요)</th>
            <td colspan="3" style="height: 100px; vertical-align: top;">
                ${fn:replace(project.projectDesc, '\\n', '<br/>')}
            </td>
        </tr>
    </table>

    <h2 class="secTitle">고객사</h2>
    <table class="biz-table">
        <colgroup>
            <col style="width: 25%"><col style="width: 25%"><col style="width: 25%"><col style="width: 25%">
        </colgroup>
        <thead>
            <tr>
                <th>기업명</th><th>부서/직책</th><th>성명</th><th>역할</th>
            </tr>
        </thead>
        <tbody>
            <c:set var="hasClient" value="false"/>
            <c:forEach items="${memberList}" var="mem">
                <c:if test="${mem.memberRole eq 'CLIENT'}">
                    <c:set var="hasClient" value="true"/>
                    <tr>
                        <td class="text-center">${mem.companyName}</td>
                        <td class="text-center">${mem.memberDepartment} / ${mem.memberPosition}</td>
                        <td class="text-center">${mem.memberName}</td>
                        <td class="text-center">기업담당자</td>
                    </tr>
                </c:if>
            </c:forEach>
            <c:if test="${not hasClient}">
                <tr><td colspan="4" class="text-center">- 등록된 고객사 정보 없음 -</td></tr>
            </c:if>
        </tbody>
    </table>

    <h2 class="secTitle">프로젝트 구성원 및 역할</h2>
    <table class="biz-table">
        <colgroup>
            <col style="width: 35%"><col style="width: 10%"><col style="width: 10%"><col style="width: 15%"><col style="width: 30%">
        </colgroup>
        <thead>
            <tr>
                <th>소속</th><th>부서</th><th>직위</th><th>성명</th><th>역할</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${memberList}" var="mem">
                <c:if test="${mem.memberRole ne 'CLIENT'}">
                    <tr>
                        <td class="text-center">${mem.companyName}</td>
                        <td class="text-center">${mem.memberDepartment}</td>
                        <td class="text-center">${mem.memberPosition}</td>
                        <td class="text-center">${mem.memberName}</td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${mem.memberRole eq 'MANAGER'}">프로젝트 관리자</c:when>
                                <c:otherwise>프로젝트 참여자</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:if>
            </c:forEach>
        </tbody>
    </table>

    <h2 class="secTitle">세부 추진 사항</h2>
    <table class="biz-table">
        <colgroup>
            <col style="width: 12%"><col style="width: 33%"><col style="width: 10%"><col style="width: 35%"><col style="width: 10%">
        </colgroup>
        <thead>
            <tr>
                <th>구분</th><th>업무 내용</th><th>담당자</th><th>투입 기간</th><th>상태</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${taskList}" var="task">
                <tr>
                    <td class="text-center">${task.WORK_TYPE}</td>
                    <td>
                        <c:if test="${task.WORK_TYPE eq '단위업무'}">&nbsp;└ </c:if>
                        ${task.TITLE}
                    </td>
                    <td class="text-center">
                    	${task.ASSIGNEE}
                    </td>
                    <td class="text-center">
                        ${task.START_DATE} ~ ${task.FINISH_DATE}
                    </td>
                    <td class="text-center">
                        <c:choose>
                            <c:when test="${task.IS_DELAYED eq 'Y'}"><span style="color:red;">지연</span></c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <h2 class="secTitle">프로젝트 성과 분석</h2>
    <table class="biz-table">
        <tr>
            <th>프로젝트 실적 (통계)</th>
            <th>차후 진행 시 보완사항 (종합 의견)</th>
        </tr>
        <tr>
            <td style="width: 50%; padding: 10px; vertical-align: top;">
                <div style="margin-bottom: 20px;">
                    <div class="chart-title text-center">[업무 일정 준수율]</div>
                    <canvas id="complianceChart" style="max-height: 150px;"></canvas>
                </div>
                <div>
                    <div class="chart-title text-center">[팀원별 업무 기여도]</div>
                    <canvas id="contributionChart" style="max-height: 150px;"></canvas>
                </div>
            </td>
            <td style="width: 50%; vertical-align: top; padding: 0;">
                <textarea class="pm-comment" id="pmComment" name="pmComment" form="reportForm" 
                	placeholder="프로젝트 수행 결과에 대한 총평 및 보완사항을 입력하세요."></textarea>
            </td>
        </tr>
    </table>
</div>

<script>
    // PDF용 차트 설정
    Chart.register(ChartDataLabels);
    Chart.defaults.font.family = "'Malgun Gothic', sans-serif";
    Chart.defaults.font.size = 11;
    Chart.defaults.color = '#333';

    // 원형 차트 (업무 일정 준수율)
    new Chart(document.getElementById('complianceChart'), {
        type: 'doughnut',
        data: {
            labels: ['조기', '정시', '지연'],
            datasets: [{
                data: [${complianceStats.early}, ${complianceStats.onTime}, ${complianceStats.delayed}],
                backgroundColor: ['#4A7EBB', '#BEBEBE', '#E06666'], // 파랑(조기), 회색(정시), 빨강(지연)
                borderWidth: 1
            }]
        },
        options: {
            responsive: true, maintainAspectRatio: false, animation: false,
            plugins: {
                legend: { position: 'right', labels: { boxWidth: 10 } },
                datalabels: { color: '#fff', font: { weight: 'bold' } }
            }
        }
    });

 	// 가로 막대 차트 (팀원별 업무 기여도)
    const names = [], topData = [], subData = [];
    <c:forEach items="${contributionStats}" var="s">
        names.push("${s.name}");
        topData.push(${s.taskTotal});
        subData.push(${s.subTaskTotal});
    </c:forEach>

    new Chart(document.getElementById('contributionChart'), {
        type: 'bar',
        data: {
            labels: names,
            datasets: [
                { 
                    label: '업무', 
                    data: topData, 
                    backgroundColor: '#343a40' 
                },
                { 
                    label: '단위업무', 
                    data: subData, 
                    backgroundColor: '#adb5bd' 
                }
            ]
        },
        options: {
            indexAxis: 'y', 
            responsive: true,
            maintainAspectRatio: false,
            animation: false,
            scales: {
                x: { stacked: true, grid: { display: false } },
                y: { stacked: true, grid: { display: false } }
            },
            plugins: {
                legend: { 
                    display: true,         
                    position: 'bottom',    
                    labels: {
                        usePointStyle: true, 
                        padding: 20         
                    }
                },
                datalabels: {
                    display: false
                }
            }
        }
    });

    function submitReport() {
	    const pmComment = document.getElementById('pmComment').value.trim();
	
	    if (!pmComment) {
	        Swal.fire({
	            icon: 'warning',
	            title: '입력 확인',
	            text: '종합 의견 및 보완사항을 작성해주세요.',
	            confirmButtonColor: '#3085d6'
	        });
	        return;
	    }

	    Swal.fire({
	        title: '보고서를 확정하시겠습니까?',
	        html: "결과보고서가 PDF로 생성되어<br>프로젝트 구성원들에게 메일로 발송됩니다.",
	        icon: 'question',
	        showCancelButton: true,
	        confirmButtonColor: '#0d6efd',
	        cancelButtonColor: '#6c757d',
	        confirmButtonText: '확정 및 발송',
	        cancelButtonText: '취소',
	        reverseButtons: true
	    }).then((result) => {
	        if (result.isConfirmed) {
	            Swal.fire({
	                title: '보고서 생성 중',
	                html: 'PDF를 생성하고 메일을 발송하고 있습니다.<br>잠시만 기다려주세요...',
	                allowOutsideClick: false,
	                didOpen: () => {
	                    Swal.showLoading();
	                }
	            });

	            // 차트를 이미지(Base64)로 변환
	            const progressImg = document.getElementById('complianceChart').toDataURL('image/png');
	            const memberImg = document.getElementById('contributionChart').toDataURL('image/png');
	           
	            document.getElementById('progressChartImage').value = progressImg;
	            document.getElementById('memberChartImage').value = memberImg;	
	            document.getElementById('reportForm').submit();
	        }
	    });
	}
    
    document.addEventListener('DOMContentLoaded', function() {
        const message = "${message}";
        const error = "${error}";

        if (message) {
            Swal.fire({
                icon: 'success',
                title: '발송 완료',
                text: message,
                confirmButtonColor: '#0d6efd'
            });
        }

        if (error) {
            Swal.fire({
                icon: 'error',
                title: '오류 발생',
                text: error,
                confirmButtonColor: '#dc3545'
            });
        }
    });
</script>
</body>
</html>