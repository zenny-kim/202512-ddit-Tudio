<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<link rel="stylesheet" href="/css/meeting_room.css">

<style>
    .badge-apply { background-color: #fff7ed; color: #c2410c; border: 1px solid #ffedd5; padding: 2px 6px; border-radius: 4px; font-size: 0.8em; font-weight: normal; margin-right: 5px; }
    .badge-confirm { background-color: #eff6ff; color: #1d4ed8; border: 1px solid #dbeafe; padding: 2px 6px; border-radius: 4px; font-size: 0.8em; font-weight: normal; margin-right: 5px; }
    .admin-cancel-reason {
        margin-top: 8px;
        padding: 4px 8px;
        background-color: #fff5f5; /* 아주 연한 빨강 */
        border: 1px solid #ffc9c9;
        border-radius: 4px;
        color: #e03131;
        font-size: 0.75rem; /* 폰트 작게 */
        display: flex;
        align-items: center;
        gap: 6px;
        white-space: nowrap; /* 줄바꿈 방지 */
        overflow: hidden;
    }
</style>

<div class="tudio-meeting">
    
    <div class="tudio-section-header d-flex align-items-center justify-content-between">
        <h5 class="h5 fw-bold m-0 text-primary-dark">
            <i class="bi bi-journal-check me-2"></i>나의 예약 현황
        </h5>
        <div class="d-flex align-items-center gap-2 my-res-tab-group">
            <button class="my-res-tab ${currentFilter eq 'ACTIVE' ? 'active' : ''}" onclick="reloadList('ACTIVE')">이용 현황</button>
            <button class="my-res-tab ${currentFilter eq 'HISTORY' ? 'active' : ''}" onclick="reloadList('HISTORY')">완료/취소 내역</button>
        </div>
        <button class="tudio-btn tudio-btn-primary" id="btnGoToMakeReservation">
            <i class="bi bi-plus-lg me-1"></i>새 예약 하러가기
        </button>
        
    </div>

    <div class="my-res-grid-container" id="my-res-list">
        <c:choose>
            <c:when test="${empty reservationList}">
                <div style="grid-column: 1 / -1; text-align: center; padding: 80px; color: #888;">
                    <i class="bi bi-calendar-x" style="font-size: 3rem; color:#cbd5e1;"></i><br>
                    <span class="mt-3 d-block">
                        <c:choose>
                            <c:when test="${currentFilter eq 'HISTORY'}">완료되거나 취소된 내역이 없습니다.</c:when>
                            <c:otherwise>예약된 내역이 없습니다.</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </c:when>

            <c:otherwise>
                <%-- 비교용 변수 초기화 --%>
                <c:set var="prevDate" value="" />
                <c:set var="prevGroup" value="INIT" />

                <c:forEach items="${reservationList}" var="res">
                    
                    <%-- 날짜 계산 --%>
                    <c:set var="startDateTimeStr" value="${res.resStartdate}" />
                    <fmt:parseDate value="${startDateTimeStr}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                    <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd" var="currDate" />
                    <fmt:formatDate value="${parsedDate}" pattern="yyyy년 MM월 dd일 (E)" var="headerDate" />

                    <%-- 
                        ★ [그룹핑 로직] 
                        703(본인취소)과 706(관리자취소)을 'ST_CANCEL'이라는 하나의 그룹으로 묶습니다.
                        이렇게 하면 헤더가 따로 생기지 않습니다.
                    --%>
                    <c:set var="currGroup" value="ST_${(res.resStatus == 703 or res.resStatus == 706) ? 'CANCEL' : res.resStatus}" />

                    <%-- 1. 날짜 헤더 (이용 현황) --%>
                    <c:if test="${currentFilter eq 'ACTIVE' and currDate ne prevDate}">
                        <div class="date-group-header"><i class="bi bi-calendar-week"></i> ${headerDate}</div>
                        <c:set var="prevDate" value="${currDate}" />
                    </c:if>

                    <%-- 2. 상태 헤더 (완료/취소 내역) --%>
                    <c:if test="${currentFilter eq 'HISTORY' and currGroup ne prevGroup}">
                        <div class="status-group-header">
                            <c:choose>
                                <%-- 703과 706 모두 여기서 걸립니다 --%>
                                <c:when test="${currGroup eq 'ST_CANCEL'}">
                                    <span class="header-cancel"><i class="bi bi-x-circle-fill me-2"></i>예약 취소</span>
                                </c:when>
                                <c:when test="${currGroup eq 'ST_704'}">
                                    <span class="header-done"><i class="bi bi-check-circle-fill me-2"></i>이용 완료</span>
                                </c:when>
                                <c:when test="${currGroup eq 'ST_705'}">
                                    <span class="header-noshow"><i class="bi bi-exclamation-triangle-fill me-2"></i>미방문</span>
                                </c:when>
                            </c:choose>
                        </div>
                        <c:set var="prevGroup" value="${currGroup}" />
                    </c:if>

                    <%-- 3. 예약 카드 --%>
                    <div class="my-res-card ${currentFilter eq 'HISTORY' ? 'history' : ''}" style="position: relative;">
                        
                        <%-- 상태 뱃지 --%>
                        <div style="position: absolute; top: 15px; right: 15px;">
                            <c:if test="${currentFilter eq 'ACTIVE'}">
                                <c:choose>
                                    <c:when test="${res.resStatus == 701}"><span class="badge badge-apply">예약 신청</span></c:when>
                                    <c:when test="${res.resStatus == 702}"><span class="badge badge-confirm">예약 확정</span></c:when>
                                </c:choose>
                            </c:if>
                        </div>
                    
                        <%-- 시간 --%>
                        <div class="my-res-date-badge">
                            <i class="bi bi-clock me-1"></i>
                            <c:if test="${currentFilter eq 'HISTORY'}"><fmt:formatDate value="${parsedDate}" pattern="MM.dd(E) " /></c:if>
                            <fmt:formatDate value="${parsedDate}" pattern="HH:mm" /> ~ 
                            <fmt:parseDate value="${res.resEnddate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedEndDate" type="both" />
                            <fmt:formatDate value="${parsedEndDate}" pattern="HH:mm" />
                        </div>
                    
                        <div class="my-res-location">${res.branchName} - ${res.roomName}</div>
                        <div class="my-res-title">${res.resMeetingTitle}</div>
                    
                        <div class="my-res-info-row">
                            <span class="my-res-info-label">예약자</span>
                            <span class="my-res-info-content">${res.memberName}</span>
                        </div>
                    
                        <div class="my-res-info-row">
                            <span class="my-res-info-label">참석자</span>
                            <span class="my-res-info-content my-res-attendees">
                                ${not empty res.memberListName ? res.memberListName : '<span class="text-muted small">정보 없음</span>'}
                            </span>
                        </div>

                        <%-- ★ 706번일 때만 뜨는 초소형 사유 박스 --%>
                        <c:if test="${res.resStatus == 706 or (res.resStatus == 703 and not empty res.resMemo)}">
						    <div class="admin-cancel-reason">
						        <i class="bi bi-info-circle-fill"></i>
						        
						        <%-- 제목 표시 --%>
						        <span class="fw-bold me-1">
						            <c:choose>
						                <c:when test="${res.resStatus == 706}">취소 사유:</c:when>
						                <c:when test="${res.resStatus == 703}">반려 사유:</c:when>
						            </c:choose>
						        </span>
						
						        <%-- 내용 표시 (상태에 따라 다른 컬럼 매핑) --%>
						        <span class="text-truncate" style="flex: 1;" 
						              title="${res.resStatus == 706 ? res.resContent : res.resMemo}">
						            <c:choose>
						                <c:when test="${res.resStatus == 706}">
						                    ${res.resContent} <%-- 관리자 강제 취소는 content --%>
						                </c:when>
						                <c:when test="${res.resStatus == 703}">
						                    ${res.resMemo}    <%-- 일반 반려/취소는 memo --%>
						                </c:when>
						            </c:choose>
						        </span>
						    </div>
						</c:if>
                    
                        <c:if test="${currentFilter eq 'ACTIVE'}">
                            <div class="my-res-btn-group">
                                <button class="btn-action btn-edit" onclick="openEditModal(${res.reservationId}, ${res.projectNo})">
                                    <i class="bi bi-pencil-square"></i> 변경
                                </button>
                                <button class="btn-action btn-cancel" onclick="cancelReservation(${res.reservationId})">
                                    <i class="bi bi-trash"></i> 취소
                                </button>
                            </div>
                        </c:if>
                    
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>


<div id="edit-modal" class="res-modal-overlay" style="display: none;">
    <input type="hidden" id="edit-res-id">
    <input type="hidden" id="edit-project-no">
    <input type="hidden" id="current-member-no" value="${loginUser.memberNo}">

    <div class="res-modal"> 
        <div class="res-modal-title">예약 변경</div>
        <div class="mb-3">
            <label class="form-label small fw-bold text-muted">날짜</label>
            <div class="d-flex align-items-center border rounded p-2" style="background:#f9f9f9;">
                <input type="date" id="edit-date-input" class="form-control border-0 bg-transparent fw-bold" style="font-size:16px;">
            </div>
        </div>
        <div class="mb-3">
            <label class="form-label small fw-bold text-muted">회의 제목</label>
            <input type="text" class="form-control" id="edit-title">
        </div>
        <div class="row mb-3">
            <div class="col-6">
                <label class="form-label small fw-bold text-muted">시작 시간</label>
                <select class="form-select" id="edit-start-time" onchange="updateEditEndTimeOptions()">
                    <c:forEach var="i" begin="9" end="17"><option value="${i}">${i < 10 ? '0' : ''}${i}:00</option></c:forEach>
                </select>
            </div>
            <div class="col-6">
                <label class="form-label small fw-bold text-muted">종료 시간</label>
                <select class="form-select" id="edit-end-time"><option value="">시작 시간 선택</option></select>
            </div>
        </div>
        <div class="mb-3">
            <label class="form-label small fw-bold text-muted">참석자 변경</label>
            <div id="edit-attendee-list" class="border rounded p-2" style="max-height: 150px; overflow-y: auto;"></div>
        </div>
        <div class="alert alert-warning small py-2 mb-0"><i class="bi bi-exclamation-triangle-fill me-1"></i> 변경 시 상태가 <b>[예약 신청]</b>으로 초기화됩니다.</div>
        <div class="d-flex gap-2 mt-4">
            <button class="tudio-btn tudio-btn-outline w-50 justify-content-center" onclick="closeEditModal()">취소</button>
            <button class="tudio-btn tudio-btn-primary w-50 justify-content-center" onclick="submitEdit()">변경 완료</button>
        </div>
    </div>
</div>

<script>
    $(document).off('click', '#btnGoToMakeReservation').on('click', '#btnGoToMakeReservation', function() {
        $(".tudio-meeting").load("/tudio/project/meetingRoom");
    });

    function reloadList(filterType) {
        $(".tudio-meeting").load("/tudio/project/meetingRoom/meetingReservation?filter=" + filterType);
    }

    // --- 수정 관련 함수 ---
    function openEditModal(resId, projectNo) {
        fetch('/tudio/project/meetingRoom/detailReservation?reservationId=' + resId)
            .then(res => res.json())
            .then(data => {
                document.getElementById('edit-res-id').value = data.reservationId;
                document.getElementById('edit-project-no').value = data.projectNo;
                document.getElementById('edit-title').value = data.resMeetingTitle;

                const startObj = new Date(data.resStartdate);
                const endObj = new Date(data.resEnddate);
                
                // 날짜 세팅 (YYYY-MM-DD)
                const yyyy = startObj.getFullYear();
                const mm = String(startObj.getMonth() + 1).padStart(2, '0');
                const dd = String(startObj.getDate()).padStart(2, '0');
                document.getElementById('edit-date-input').value = `\${yyyy}-\${mm}-\${dd}`;

                // 시간 세팅
                document.getElementById('edit-start-time').value = startObj.getHours();
                updateEditEndTimeOptions();
                document.getElementById('edit-end-time').value = endObj.getHours();

                // 멤버 로드
                loadEditMembers(data.projectNo, data.memberList);

                document.getElementById('edit-modal').style.display = 'flex';
                document.body.style.overflow = 'hidden';
            });
    }

    function updateEditEndTimeOptions() {
        const startVal = parseInt(document.getElementById('edit-start-time').value);
        const endSelect = document.getElementById('edit-end-time');
        endSelect.innerHTML = '';
        if (isNaN(startVal)) return;
        const maxEnd = Math.min(startVal + 4, 18);
        for (let h = startVal + 1; h <= maxEnd; h++) {
            const time = (h < 10 ? '0' : '') + h + ":00";
            endSelect.innerHTML += `<option value="\${h}">\${time}</option>`;
        }
    }

    function loadEditMembers(projectNo, selectedIds) {
        const area = document.getElementById('edit-attendee-list');
        const myNo = parseInt(document.getElementById('current-member-no').value);
        area.innerHTML = '로딩중...';
        
        fetch('/tudio/project/meetingRoom/projectMembers?projectNo=' + projectNo)
            .then(res => res.json())
            .then(members => {
                let html = '';
                if(!selectedIds) selectedIds = [];
                members.forEach(m => {
                    const mName = m.memberVO ? m.memberVO.memberName : m.memberName;
                    const mNo = m.memberNo;
                    const isMe = (mNo === myNo);
                    const isChecked = isMe || selectedIds.includes(mNo);
                    
                    html += `
                        <div class="form-check">
                            <input class="form-check-input edit-member-check" type="checkbox" 
                                   value="\${mNo}" id="edit_mem_\${mNo}" \${isChecked ? 'checked' : ''} \${isMe ? 'disabled' : ''}>
                            <label class="form-check-label small" for="edit_mem_\${mNo}" style="cursor:pointer;">
                                \${isMe ? mName + ' (나)' : mName}
                            </label>
                        </div>`;
                });
                area.innerHTML = html;
            });
    }

    function submitEdit() {
        const resId = document.getElementById('edit-res-id').value;
        const title = document.getElementById('edit-title').value;
        const dateVal = document.getElementById('edit-date-input').value;
        const startHour = document.getElementById('edit-start-time').value;
        const endHour = document.getElementById('edit-end-time').value;
        const myNo = parseInt(document.getElementById('current-member-no').value);

        if(!title || !dateVal || !startHour || !endHour) return Swal.fire('경고', '모든 항목을 입력하세요.', 'warning');

        const memberSet = new Set();
        memberSet.add(myNo);
        document.querySelectorAll('.edit-member-check:checked').forEach(cb => {
            if(!cb.disabled) memberSet.add(parseInt(cb.value));
        });

        const sTime = (startHour < 10 ? '0' : '') + startHour;
        const eTime = (endHour < 10 ? '0' : '') + endHour;

        const data = {
            reservationId: resId,
            resMeetingTitle: title,
            resStartdate: `\${dateVal}T\${sTime}:00:00`,
            resEnddate: `\${dateVal}T\${eTime}:00:00`,
            memberList: Array.from(memberSet)
        };

        fetch('/tudio/project/meetingRoom/updateReservation', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        })
        .then(res => { if(res.ok) return res.text(); throw new Error('ERR'); })
        .then(res => {
            if(res === 'SUCCESS') {
                Swal.fire('성공', '예약이 수정되었습니다.', 'success').then(() => {
                    closeEditModal();
                    reloadList('ACTIVE');
                });
            }
        })
        .catch(err => Swal.fire('오류', '수정 실패', 'error'));
    }

    function closeEditModal() {
        document.getElementById('edit-modal').style.display = 'none';
        document.body.style.overflow = 'auto';
    }

    function cancelReservation(id) {
        Swal.fire({
            title: '예약 취소',
            text: "정말 취소하시겠습니까?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: '네',
            cancelButtonText: '아니오'
        }).then((result) => {
            if (result.isConfirmed) {
                fetch('/tudio/project/meetingRoom/cancelReservation', { 
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ reservationId: id })
                })
                .then(res => { if(res.ok) return res.text(); throw new Error('ERR'); })
                .then(res => {
                    if(res === 'SUCCESS') Swal.fire('취소 완료', '', 'success').then(() => reloadList('ACTIVE'));
                });
            }
        });
    }
</script>