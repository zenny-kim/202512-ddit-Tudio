<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Tudio</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/dhtmlxgantt.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/project_common.css">
<script src="${pageContext.request.contextPath}/js/dhtmlxgantt.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
	
	.legend {
	  display: flex;
	  gap: 12px;              /* 범례 간격 */
	  align-items: center;
	  font-size: 14px;
	}

	.legend-item {
	  display: flex;
	  align-items: center;
	  gap: 6px;
	}

	.color-box {
	  width: 18px;
	  height: 12px;
	  border-radius: 4px;     /* 둥근 사각형 */
	}

	/* 색상 정의 */
	.red    { background: #F59E0B; }
	.orange { background: #3B82F6; }
	.yellow { background: #22C55E; }
	.green  { background: #64748B; }
	.blue   { background: #ef4444; }

</style>

<script>
	$(document).on("click", "#btnWeek", function () {
	    gantt.ext.zoom.setLevel("week");
	    $(this).addClass("tudio-btn-primary").css("border", "none");
	    $("#btnDay").removeClass("tudio-btn-primary").css("border", "1px solid var(--tudio-border-soft)");
	});
	
	$(document).on("click", "#btnDay", function () {
	    gantt.ext.zoom.setLevel("day");
	    $(this).addClass("tudio-btn-primary").css("border", "none");
	    $("#btnWeek").removeClass("tudio-btn-primary").css("border", "1px solid var(--tudio-border-soft)");
	});
	
	$(function () {
	
	    gantt.plugins({
	        marker: true,
	        tooltip: true
	    });
	    
	    // 서버 변수 확인용 로깅
	    const pNo = "${projectNo}";
	    const cPath = "${pageContext.request.contextPath}";
	    
	    console.log("체크1: pNo =", pNo);
	    console.log("체크2: cPath =", cPath);
	
	    // 간트 초기 설정 
	    gantt.config.xml_date = "%Y-%m-%d";
	    gantt.config.grid_resize = true;	//
	    gantt.config.autofit = false;		//
	    gantt.config.open_tree_initially = true;
	    gantt.config.work_time = true;
	    gantt.setWorkTime({ days: [1,2,3,4,5] });
	    gantt.config.drag_move = false;
	    gantt.config.drag_resize = false;
	    gantt.config.drag_links = false;
	    gantt.config.details_on_dblclick = false;
	    gantt.config.drag_progress = false;
	
	    gantt.config.columns = [
	        { name:"text", label:"업무명", tree:true, width: 180, resize: true },
	        { name:"start_date", label:"시작일", align:"center", width: 100, resize: true },
	        { 
	            name: "end_date", 
	            label: "마감일", 
	            align: "center", 
	            width: 100,
	            resize: true,
	            template: function(obj) { return gantt.templates.date_grid(obj.end_date); }
	        },
	        { 
	            name: "subFinishdateStr", // DTO의 필드명과 일치해야 함
	            label: "실제종료일", 
	            align: "center", 
	            width: 100            
	        },
	        { 
	            name: "progress", 
	            label: "진척도", 
	            align: "center", 
	            width: 70, 
	            resize: true,
	            template: function(obj) { return Math.round((obj.progress || 0) * 100) + "%"; } 
	        }
	    ];
	    
	    // 줌 설정
	    const zoomConfig = {
	        levels: [
	            { name: "week", scales: [{ unit: "month", format: "%Y-%m" }, { unit: "week", format: "W%W" }], min_column_width: 50 },
	            { name: "day", scales: [{ unit: "month", format: "%Y-%m" }, { unit: "day", format: "%d" }], min_column_width: 30 }
	        ]
	    };
	    gantt.ext.zoom.init(zoomConfig);
	    gantt.ext.zoom.setLevel("week");
	    
		//진행상태, 담당자
	    gantt.templates.tooltip_text = function(start, end, task) {
			
			//하위업무 진행상태 한글명 표시
			var statusName = "";
			if(task.status == 201){
				statusName = "요청";
			}else if(task.status == 202){
				statusName = "진행";
			}else if(task.status == 203){
				statusName = "완료";
			}else if(task.status == 204){
				statusName = "보류";
			}else if(task.status == 205){
				statusName = "지연";
			}
					
			var status = "<span style='display:inline-block; white-space:nowrap;'>" +
						 "<b>진행상태 :</b> " + statusName + 
						 "</span>";
			
			
			//하위업무 툴팁에만 담당자명 리스트 표시
			var managers = "";
			if(task.parent != 0){
				managers = "<span style='display:inline-block; white-space:nowrap;'>" +
										 "<b>담당자 :</b> " + task.managers + 
										 "</span>";
			}
			
			var period = "<span style='display:inline-block; white-space:nowrap;'>" +
						 "<b>기간 :</b> " + gantt.templates.tooltip_date_format(start) + " ~ " + gantt.templates.tooltip_date_format(end) + 
						 "</span>";
			
			var progress = "<span style='display:inline-block; white-space:nowrap;'>" +
						 "<b>진척도 :</b> " + Math.round((task.progress || 0) * 100) + "%" +
						 "</span>";
						 
			return status + managers + period + progress;
			
	    };
	    
	    //간트차트 세로 사이즈 auto 
	    gantt.config.autosize = "y";
	    
	    //칸트차트틀
	    gantt.init("gantt_here");
	        
	    //데이터 요청 (pNo가 있을 때만)
	    if (pNo && pNo !== "" && pNo !== "0") {
	        const finalUrl = cPath + "/tudio/project/gantt/data?projectNo=" + pNo;
	        console.log("체크3: 요청 URL =", finalUrl);
	
	        fetch(finalUrl)
	           .then(res => res.json())
	           .then(result => {
	               console.log("체크4: 서버 데이터 수신 =", result);
	               gantt.clearAll();
	               gantt.parse(result);
	           
	               gantt.addMarker({
	                   start_date: new Date()
					   , css: "today_line"
	               });
	           })
	           .catch(err => console.error("데이터 로딩 에러:", err));
	    
	    }
	    
	});
</script>

</head>

<body>

	<div class="tudio-section-header mb-4">
		<h2 class="h5 fw-bold m-0 text-primary-dark" id="taskViewTitle">
		        <i class="bi bi-clipboard-data me-2"></i>진행현황 (간트차트)
		</h2>
	   	<div class="d-flex gap-1 justify-content-end">
		    <button id="btnWeek" class="view-btn tudio-btn tudio-btn-primary">Week</button>
		    <button id="btnDay"  class="view-btn tudio-btn ms-2" style="border: 1px solid var(--tudio-border-soft);">Day</button>
		</div>  
	</div>
	
	<div class="legend" style="width: 100%; height: 30px;">
		<div class="legend-item">
		    <span class="color-box red"></span>
		    <span class="label">요청</span>
		  </div>
		  <div class="legend-item">
		    <span class="color-box orange"></span>
		    <span class="label">진행</span>
		  </div>
		  <div class="legend-item">
		    <span class="color-box yellow"></span>
		    <span class="label">완료</span>
		  </div>
		  <div class="legend-item">
		    <span class="color-box green"></span>
		    <span class="label">보류</span>
		  </div>
		  <div class="legend-item">
		    <span class="color-box blue"></span>
		    <span class="label">지연</span>
		  </div>	
	</div>
	
	<div id="gantt_here" style="width: 100%; height: auto; background: #f4f4f4;"></div>

</body>
</html>