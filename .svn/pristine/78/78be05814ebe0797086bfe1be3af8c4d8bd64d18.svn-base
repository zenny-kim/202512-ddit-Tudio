<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<meta charset="UTF-8">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/project_common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/project_kanban.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.3/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.3/dist/sweetalert2.all.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js"></script>

<input type="hidden" id="projectNoInput" value="${projectNo}" />

<div class="tudio-section-header mb-4">
     <h2 class="h5 fw-bold m-0 text-primary-dark" id="taskViewTitle">
     	<i class="fa-solid fa-chalkboard-user me-2"></i>업무 목록 (칸반보드)
     </h2>
     <div class="d-flex gap-2">
         <button type="button" class="tudio-btn" id="btnListView" style="border: 1px solid var(--tudio-border-soft);">
            <i class="bi bi-list-task me-1"></i> 리스트형 보기
         </button>
         
     </div>
 </div>

<div class="main-content-wrap-tap">
    <div class="kanban-wrapper">

        <div class="kanban-col">
            <div class="col-header request">TO DO<span class="count" id="count-201">0</span></div>
            <div class="task-list" data-status="201"></div>
        </div>

        <div class="kanban-col">
            <div class="col-header inprogress">IN PROGRESS<span class="count" id="count-202">0</span></div>
            <div class="task-list" data-status="202"></div>
        </div>

        <div class="kanban-col">
            <div class="col-header done">DONE<span class="count" id="count-203">0</span></div>
            <div class="task-list" data-status="203"></div>
        </div>

        <div class="kanban-col">
            <div class="col-header hold">ON HOLD<span class="count" id="count-204">0</span></div>
            <div class="task-list" data-status="204"></div>
        </div>

        <div class="kanban-col">
            <div class="col-header delayed">DELAYED<span class="count" id="count-205">0</span></div>
            <div class="task-list" data-status="205"></div>
        </div>

    </div>
</div>

<script>
$(function () {
	
	const Alert = {
	    // 1. [자동 소멸] 확인 버튼 없이 1.5초 뒤 사라짐 (성공/알림용)
	    // 핀 고정, 단순 이동 성공 등 가벼운 피드백에 사용
	    fast: function(msg) {
	        Swal.fire({
	            icon: 'success',
	            title: '확인',
	            text: msg,
	            showConfirmButton: false,
	            timer: 1500
	        });
	    },
	    
	 	// 2. [자동 소멸 - 에러/경고] 빨간색 아이콘, 1.5초 뒤 사라짐
	    // 핀 업데이트 실패 등 가벼운 오류 피드백에 사용
	    fastError: function(msg) {
	        Swal.fire({
	            icon: 'error',
	            title: '실패',
	            text: msg,
	            showConfirmButton: false, // 확인 버튼 없음
	            timer: 1500               // 1.5초 뒤 자동 소멸
	        });
	    },

	    // 3. [확인 버튼] 사용자가 직접 눌러야 닫힘 (중요 성공용)
	    // 업무 생성, 전체 저장 등 명확한 확인이 필요할 때 사용
	    success: function(msg) {
	        Swal.fire({
	            icon: 'success',
	            title: '성공',
	            text: msg,
	            confirmButtonColor: '#56ACFF',
	            confirmButtonText: '확인'
	        });
	    },

	    // 4. [경고/에러] 빨간색 X 아이콘, 확인 버튼 있음
	    // 권한 없음, 시스템 오류 등 차단이 필요할 때 사용
	    error: function(msg) {
	        Swal.fire({
	            icon: 'error',
	            title: '실패',
	            text: msg,
	            confirmButtonColor: '#ef4444',
	            confirmButtonText: '확인'
	        });
	    },

	    // 5. [질문/확인] 확인/취소 버튼이 있는 창
	    // 삭제 전 확인, 상태 강제 변경 전 확인 시 사용
	    confirm: function(msg, callback, cancelCallback) {
	        Swal.fire({
	            title: '확인',
	            text: msg,
	            icon: 'question',
	            showCancelButton: true,
	            confirmButtonColor: '#56ACFF',
	            cancelButtonColor: '#94a3b8',
	            confirmButtonText: '확인',
	            cancelButtonText: '취소'
	        }).then((result) => {
	        	if (result.isConfirmed) {
	                if (typeof callback === 'function') callback(); 
	            } else {
	                if (typeof cancelCallback === 'function') cancelCallback();
	                else loadTasks(); // 기본적으로 원위치
	            }
	        });
	    }
	};
	
	const contextPath = "${pageContext.request.contextPath}";
    // 1. 초기 상수 및 설정
    const STATUS = {
        REQUEST: 201,
        PROGRESS: 202,
        DONE: 203,
        HOLD: 204,
        DELAYED: 205
    };
    const pNo = $("#projectNoInput").val();
    const loginMemberNo = "${loginMemberNo}";
    
    const FIXED_PIN_ON = `<i class="fa-solid fa-thumbtack"></i>`;
    const FIXED_PIN_OFF = `<i class="fa-solid fa-thumbtack" style="opacity: 0.3; transform: rotate(-45deg);"></i>`;
    
    // 2. 이벤트 위임 (이벤트 중복 및 누락 방지)    
    // [핀 고정 클릭]
    $(document).on("click", ".pin-btn", function (e) {
        e.stopPropagation();
        const $card = $(this).closest(".task-card");
        if ($card.hasClass("read-only")) {
        	Alert.error("해당 업무 담당자만 고정할 수 있습니다.");
            return;
        }
        const subId = $card.data("id");
        const taskId = $card.data("task-id");
        const newPin = ($card.attr("data-pin") === "Y") ? "N" : "Y";

        $.post(`\${contextPath}/tudio/project/task/updatePin`, { subId: subId, subPinYn: newPin, taskId: taskId })
         .done(() => loadTasks())
         .fail(() => Alert.fastError("핀 업데이트 실패"));
    });

    // [슬라이더 숫자 실시간 표시]
    $(document).on("input", ".rate-slider", function() {
    	$(this).closest(".rate-container").find(".rate-text").text($(this).val() + "% 완료");
    });

    // [슬라이더 드래그 끝났을 때 저장 및 상태 이동]
    $(document).on("change", ".rate-slider", function() {
        const $card = $(this).closest(".task-card");
        if ($card.hasClass("read-only")) return;

        const rate = parseInt($(this).val());
        const id = $card.data("id");
        let newStatus;
        
        if (rate === 0) {
            newStatus = STATUS.REQUEST; // 201
        } else if (rate === 100) {
            newStatus = STATUS.DONE; // 203
        } else {
            newStatus = STATUS.PROGRESS; // 202 
        }

        $.post(`\${contextPath}/tudio/project/task/updateRate`, { subId: id, subRate: rate })
         .done(() => {
             $.post(`\${contextPath}/tudio/project/task/modifyStatus`, { subId: id, subStatus: newStatus })
              .done(() => loadTasks());
         });
    });

    // 3. 데이터 로드 및 렌더링
    function loadTasks() {
        $.ajax({
            url: `\${contextPath}/tudio/project/task/getTaskList`,
            type: "GET",
            data: { projectNo: pNo },
            success: function(data) { renderCards(data); },
            error: function(xhr) { console.error("데이터 로드 실패", xhr.status); }
        });
    }

    function renderCards(data) {
        $(".task-list").empty();
        $(".count").text("0");
        const counts = { 201:0, 202:0, 203:0, 204:0, 205:0 };

        // 핀 상단 정렬 (문자열 비교 안정화)
        data.sort((a, b) => {
        	const aPin = a.subPinYn === 'Y' ? 1 : 0;
            const bPin = b.subPinYn === 'Y' ? 1 : 0;
            
            if (aPin !== bPin) {
                return bPin - aPin; 
            }
            
            if (aPin === 1) {
                return (parseInt(b.subPinOrder) || 0) - (parseInt(a.subPinOrder) || 0);
            }

            return 0;
        });

        data.forEach(item => {
            let status = item.subStatus ? item.subStatus.code : 201;
            const rate = parseInt(item.subRate || 0);
            const today = new Date().setHours(0,0,0,0);
            const endDate = item.subEnddate ? new Date(item.subEnddate).setHours(0,0,0,0) : null;

            // [로직 보정 우선순위]
            if (rate === 100) status = STATUS.DONE;
            else if (status !== STATUS.DONE && endDate && endDate < today) status = STATUS.DELAYED;
            else if (rate > 0 && status === STATUS.REQUEST) status = STATUS.PROGRESS;
			
            if (counts[status] !== undefined){
	            counts[status]++;
            }

            const managerIds = (item.taskManagerIds || "").split(",").map(v => v.trim()).filter(Boolean);
            const hasAuth = managerIds.includes(loginMemberNo.toString());
            const authClass = hasAuth ? "" : "read-only";
            const holdClass = (status === STATUS.HOLD) ? "status-hold" : "";
            const myTaskBadge = hasAuth ? `<span class="my-task-badge">담당업무</span>` : "";
            const pinYn = item.subPinYn || "N";
            const currentPinIcon = (pinYn === 'Y') ? FIXED_PIN_ON : FIXED_PIN_OFF;

            const cardHtml = `
            <div class="task-card \${pinYn === 'Y' ? 'pin-on' : 'pin-off'} \${authClass} \${holdClass}"
                 data-id="\${item.subId}" 
               	 data-task-id="\${item.taskId}"
               	 data-pin="\${pinYn}">
                <div class="card-header">
                    <span class="parent-title">
                        📁 \${item.parentTitle || "일반"}
                        \${!hasAuth ? '<i class="fa-solid fa-lock lock-icon"></i>' : ''}
                    </span>
                    <span class="pin-btn">\${currentPinIcon}</span>
                </div>
                <span class="task-title">
                	\${item.subTitle}
                	\${myTaskBadge}</span>
                <span class="manager-name">👤 \${item.taskManagerName || "미지정"}</span>
                <span class="end-date">📅 \${item.subEnddate?.substring(0,10) || "-"}</span>
                <div class="rate-container">
                    <input type="range" class="rate-slider"
                        min="0" max="100" step="10"
                        value="\${item.subRate}"
                        \${!hasAuth ? "disabled" : ""}
                        onmousedown="event.stopPropagation();"
                        ontouchstart="event.stopPropagation();">
                    <span class="rate-text">\${item.subRate}% 완료</span>
                </div>
            </div>`;

            $('.task-list[data-status="' + status + '"]').append(cardHtml);
        });

        Object.keys(counts).forEach(s => $("#count-" + s).text(counts[s]));
        initSortable(); // 카드를 다 그린 후 드래그 기능 부여
    }

    // 4. 드래그 앤 드롭 (Sortable) 초기화
    function initSortable() {
    	$(".task-list").each(function () {
            const columnStatus = $(this).data("status");
        
            new Sortable(this, {
                group: "kanban",
                animation: 150,
                filter: ".rate-slider, .pin-btn",
                preventOnFilter: false,
                disabled: columnStatus == STATUS.DELAYED,
                
                onMove: function (evt) {
                    const toStatus = $(evt.to).data("status");

                    if (toStatus == STATUS.DELAYED) {
                        return false;
                    }

                    if ($(evt.dragged).hasClass("read-only")) {
                        return false;
                    }
                },
                                
                onEnd: function (evt) {
                    const $item = $(evt.item);
                    
                    if ($item.hasClass("read-only")) {
                        const from = evt.from;
                        const oldIndex = evt.oldIndex;

                        if (from.children[oldIndex]) {
                            from.insertBefore(evt.item, from.children[oldIndex]);
                        } else {
                            from.appendChild(evt.item);
                        }

                        Alert.error("해당 업무 담당자만 수정할 수 있습니다.");
                        return;
                    }
                    
                    const id = $item.data("id"); // ID 정의 추가
                    const rate = parseInt($item.find(".rate-slider").val());
                    const toStatus = parseInt($(evt.to).data("status"));
                    
                 	// 진행중인데 0%인 경우
                    if (toStatus === 202 && rate === 0) {
                        Alert.confirm("업무를 진행 상태로 변경하시겠습니까?", function() {
                            $.post(`${contextPath}/tudio/project/task/updateRate`, { subId: id, subRate: 10 })
                             .done(() => {
                                 $.post(`${contextPath}/tudio/project/task/modifyStatus`, { subId: id, subStatus: 202 })
                                  .done(() => {
                                      Alert.fast("업무가 진행 상태로 변경되었습니다.");
                                      loadTasks();
                                  });
                             });
                        });
                        return; // 아래 일반 이동 로직이 실행되지 않도록 리턴
                    }
	
                    if (rate === 100 && toStatus !== 203) {
                    	Alert.fastError("이미 완료된 업무 입니다.");
                        loadTasks(); // 원위치 시키기 위해 리로드
                        return;
                    }

                    if (toStatus === 201 && rate >= 10) {
                    	Alert.fastError("이미 진행 중인 업무입니다.");
                        loadTasks();
                        return;
                    }

                    if (toStatus === 203 && rate < 100) {
                        // Alert.confirm의 두 번째 인자로 "확인을 눌렀을 때 실행할 함수"를 넘깁니다.
                        Alert.confirm("진척도를 100%로 수정하고 완료 처리하시겠습니까?", function() {
                            // [확인]을 눌렀을 때만 실행되는 구간
                            $.post(`${contextPath}/tudio/project/task/updateRate`, { subId: id, subRate: 100 })
                             .done(() => {
                                 $.post(`${contextPath}/tudio/project/task/modifyStatus`, { subId: id, subStatus: 203 })
                                  .done(() => {
                                      Alert.success("업무가 완료되었습니다.");
                                      loadTasks();
                                  });
                             })
                             .fail(() => Alert.fastError("업데이트에 실패했습니다."));
                        });
                        
                        // [취소]를 누르거나 창이 닫히면 위 함수가 실행되지 않으므로 
                        // 리로드하여 카드를 원래 위치로 돌려놓습니다.
                        // (단, Alert.confirm 내부 로직에 따라 cancel 시 loadTasks를 따로 호출해야 할 수도 있습니다.)
                    } else {
                        // 일반적인 이동
                        $.post(`${contextPath}/tudio/project/task/modifyStatus`, { subId: id, subStatus: toStatus })
                         .done(() => loadTasks());
                    }
                }
            });
        });
    }

    loadTasks(); // 첫 실행
});
</script>
