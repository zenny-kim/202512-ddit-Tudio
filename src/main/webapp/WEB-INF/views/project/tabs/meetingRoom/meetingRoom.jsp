<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- appkey 에 본인 앱키넣기  -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=본인 앱키 넣기&libraries=services"></script>

<link rel="stylesheet" href="/css/meeting_room.css">

<div class="tudio-meeting">

    <div class="tudio-section-header d-flex align-items-center justify-content-between">
        <h5 class="h5 fw-bold m-0 text-primary-dark">
            <i class="bi bi-calendar-check me-2"></i>회의실 예약
        </h5>
        <div>
            <button class="tudio-btn tudio-btn-outline" onclick="reservationList()">
                <i class="bi bi-journal-check"></i> 나의 예약 현황
            </button>
        </div>
    </div>

    <div class="p-3">
        <h6 class="fw-bold mb-3 text-dark"><i class="bi bi-geo-alt-fill text-danger me-1"></i>지점을 선택해주세요</h6>
        
        <div class="res-grid-container" id="branch-list">
            <c:choose>
                <c:when test="${not empty branchList}">
                    <c:forEach items="${branchList}" var="branch">
                        <div class="res-card" onclick="selectBranch(this, ${branch.branchId}, '${branch.branchName}', '${branch.branchAddr}', ${branch.fileGroupNo})">
                            <div class="card-title">${branch.branchName}</div>
                            <div class="card-desc">${branch.branchAddr}</div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="col-12 text-center p-4 border rounded bg-light">
                        등록된 지점 정보가 없습니다.
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div id="branch-info-section" style="display:none; margin-top: 30px; margin-bottom: 30px;">
            <div class="row g-4">
                <div class="col-md-6">
                    <div class="branch-slider-wrap">
                        <div class="slider-container" id="slider-images"></div>
                        <button class="slider-btn prev" onclick="moveSlide(-1)"><i class="bi bi-chevron-left"></i></button>
                        <button class="slider-btn next" onclick="moveSlide(1)"><i class="bi bi-chevron-right"></i></button>
                        <div class="slider-dots" id="slider-dots"></div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div id="map" class="branch-map" style="width:100%; height:300px;"></div>
                </div>
            </div>
        </div>
        
        <div id="room-section" style="display:none;">
            <div class="section-divider"></div>
            <h6 class="fw-bold mb-3 text-dark">
                <i class="bi bi-door-open-fill text-warning me-1"></i>회의실을 선택해주세요 
                <span id="selected-branch-name" class="text-primary small ms-2"></span>
            </h6>
            <div class="res-grid-container" id="room-grid-target"></div>
        </div>
        

        <div id="calendar-section" class="calendar-wrapper" style="display:none;">
            <div class="section-divider"></div>
            <div class="d-flex flex-column align-items-center mb-4">
                <div class="calendar-header-control">
                    <button class="cal-btn" onclick="moveWeek(-1)"><i class="bi bi-chevron-left"></i></button>
                    <div class="current-date-range" id="current-week-range" onclick="document.getElementById('date-picker-trigger').showPicker()"></div>
                    <input type="date" id="date-picker-trigger" style="visibility: hidden; position: absolute;" onchange="pickDate(this.value)">
                    <button class="cal-btn" onclick="moveWeek(1)"><i class="bi bi-chevron-right"></i></button>
                </div>
                <span class="small text-muted bg-light px-2 py-1 rounded">
                    <i class="bi bi-info-circle me-1"></i>예약은 09:00 ~ 18:00 가능 (최대 4시간)
                </span>
            </div>
            <div class="week-grid-scroll">
                <div class="week-grid" id="week-grid-target"></div>
            </div>
        </div>
    </div>
</div>

<div id="reservation-modal" class="res-modal-overlay" style="display: none;">
    <input type="hidden" id="current-member-no" value="${loginUser.memberNo}">
    
    <div class="res-modal"> 
        <div class="d-flex align-items-center justify-content-between mb-3">
		    <div class="res-modal-title">회의실 예약</div>
			<!-- 더미데이터용 버튼 -->
		    <button type="button"
		            class="tudio-btn tudio-btn-outline btn-sm"
		            onclick="fillDummyReservation()"
		            title="시연용 더미 데이터 입력">
		        <i class="bi bi-magic"></i>
		    </button>
		</div>
        <div class="alert alert-light border mb-4 d-flex align-items-center" style="cursor: pointer;" onclick="document.getElementById('modal-date-input').showPicker()" title="날짜 변경하려면 클릭하세요">
            <i class="bi bi-calendar3 me-2 text-primary"></i>
            <span id="modal-date-display" class="fw-bold text-dark">날짜 정보</span>
            <input type="date" id="modal-date-input" style="visibility: hidden; position: absolute; width: 0;" onchange="updateModalDate(this.value)">
        </div>

        <div class="mb-3">
            <label class="form-label small fw-bold text-muted">회의 제목</label>
            <input type="text" class="form-control" id="res-title" placeholder="회의 주제를 입력해주세요">
        </div>

        <div class="mb-3">
            <label class="form-label small fw-bold text-muted">시작 시간 (09:00 ~ 17:00)</label>
            <select class="form-select form-control" id="start-time-select" onchange="updateEndTimeOptions()"></select>
        </div>
        
        <div id="booked-info-area" class="mb-3 small fw-bold"></div>
        
        <div class="mb-3">
            <label class="form-label small fw-bold text-muted">종료 시간 (최대 4시간)</label>
            <select class="form-select form-control" id="end-time-select">
                <option value="">시작 시간을 먼저 선택하세요</option>
            </select>
        </div>

        <div class="mb-3">
            <label class="form-label small fw-bold text-muted">예약자</label>
            <input type="text" class="form-control" value="${loginUser.memberName}" readonly>
        </div>
    
        <div class="mb-3">
            <label class="form-label small fw-bold text-muted">참석자 선택</label>
            <div id="attendee-checkbox-area" class="border rounded p-2" style="max-height: 150px; overflow-y: auto;">
                <div class="text-center text-muted small p-2">로딩 중...</div>
            </div>
        </div>

        <div class="d-flex gap-2 mt-4">
            <button class="tudio-btn tudio-btn-outline w-50 justify-content-center" onclick="closeModal()">취소</button>
            <button class="tudio-btn tudio-btn-primary w-50 justify-content-center" onclick="confirmReservation()">
                예약하기
            </button>
        </div>
    </div>
</div>

<script>
    // === [1] 전역 변수 ===
    var currentDate = new Date();
    var map = null;       		
    var marker = null;    		
    var currentSlide = 0; 		
    var totalSlides = 0;  		
    var selectedRoomId = 0;
    var currentBookedTimes = []; // 현재 선택된 날짜의 예약된 시간들

    // 화면 로드 시 실행
    document.addEventListener("DOMContentLoaded", () => {
        if (!window.projectNo) {
            const urlParam = new URLSearchParams(location.search).get('projectNo');
            if (urlParam) window.projectNo = Number(urlParam);
        }
        // 모달 강제 닫기 (자동 열림 방지)
        document.getElementById('reservation-modal').style.display = 'none';
    });

    // === [2] 예약 확정 함수 (중복 멤버 해결, 모달 닫기 해결) ===
    function confirmReservation() {
        console.log("1. 예약 버튼 클릭됨");

        const titleElem = document.getElementById('res-title');
        const dateElem = document.getElementById('modal-date-input');
        const startElem = document.getElementById('start-time-select');
        const endElem = document.getElementById('end-time-select');
        const myMemberNo = parseInt(document.getElementById('current-member-no').value);

        const title = titleElem.value.trim();
        const dateVal = dateElem.value; 
        const startHour = startElem.value;
        const endHour = endElem.value;

        // 유효성 검사
        if (!title) return Swal.fire('경고', '회의 제목을 입력해주세요.', 'warning');
        if (!startHour || !endHour) return Swal.fire('경고', '시간을 선택해주세요.', 'warning');
        if (!selectedRoomId) return Swal.fire('오류', '회의실 정보가 없습니다.', 'error');

        // [중요] 멤버 중복 제거 로직 (Set 사용)
        const memberSet = new Set();
        memberSet.add(myMemberNo); // 나 자신 추가

        // 체크된 멤버들 추가
        document.querySelectorAll('.member-check:checked').forEach(cb => {
            if (!cb.disabled) { // disabled는 나 자신이므로 중복 방지 (Set써서 상관없긴 함)
                memberSet.add(parseInt(cb.value));
            }
        });

        // Set을 배열로 변환
        const uniqueMembers = Array.from(memberSet);
        console.log("최종 멤버 리스트(중복제거됨):", uniqueMembers);

        // 데이터 생성
        const startTimeStr = String(startHour).padStart(2, '0'); 
        const endTimeStr = String(endHour).padStart(2, '0');     
        const reservationData = {
            roomId: selectedRoomId,
            projectNo: window.projectNo,
            memberNo: myMemberNo,
            resMeetingTitle: title,
            resStartdate: `\${dateVal}T\${startTimeStr}:00:00`,
            resEnddate: `\${dateVal}T\${endTimeStr}:00:00`,
            resStatus: 701,
            resType: 'P',
            memberList: uniqueMembers
        };

        // AJAX 요청
        fetch('/tudio/project/meetingRoom/reservation', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(reservationData)
        })
        .then(res => {
            if (res.ok) return res.text();
            throw new Error('Server Error');
        })
        .then(data => {
            if(data === 'SUCCESS') {
                Swal.fire('성공', '예약이 완료되었습니다.', 'success').then(() => {
                    closeModal(); // 모달 닫기
                    reservationList(); // 목록 탭으로 이동
                });
            } else {
                Swal.fire('실패', '예약 처리에 실패했습니다.', 'error');
            }
        })
        .catch(err => {
            console.error(err);
            Swal.fire('오류', '서버 통신 중 오류가 발생했습니다.', 'error');
        });
    }
    
    //모달 더미 생성
    function fillDummyReservation() {
    // 제목
    document.getElementById('res-title').value = '업무 분장 추가회의';

    // 시작 시간: 09:00 고정
    const startSelect = document.getElementById('start-time-select');
    startSelect.value = '10';
    updateEndTimeOptions();

    // 종료 시간: 13:00
    const endSelect = document.getElementById('end-time-select');
    endSelect.value = '13';

    // 참석자 선택 (39, 42, 41, 43, 40)
    const dummyMembers = [39, 42, 41, 43, 40];

    document.querySelectorAll('.member-check').forEach(cb => {
        const memNo = parseInt(cb.value);
        if (dummyMembers.includes(memNo) && !cb.disabled) {
            cb.checked = true;
        }
    });
	}
    
    

    // === [3] 지점 선택 (지도 주소 표시 해결) ===
    function selectBranch(element, branchId, branchName, branchAddr, fileGroupNo) {
        // 스타일 활성화
        document.querySelectorAll('#branch-list .res-card').forEach(el => el.classList.remove('active'));
        element.classList.add('active');
        document.getElementById('selected-branch-name').innerText = '- ' + branchName;

        // 섹션 전환
        document.getElementById('branch-info-section').style.display = 'block';
        document.getElementById('calendar-section').style.display = 'none';
        document.getElementById('room-section').style.display = 'block';
        
        // 로딩 표시
        document.getElementById('room-grid-target').innerHTML = '<div class="text-center w-100 py-5"><div class="spinner-border text-primary"></div></div>';

        // [중요] 지도가 display:block 된 후에 그려야 깨지지 않음
        setTimeout(() => {
            loadMap(branchName, branchAddr);
        }, 100);
        
        initSlider(fileGroupNo);

        // 회의실 목록 조회
        fetch('/tudio/project/meetingRoom/meetingRoomList?branchId=' + branchId)
            .then(res => res.json())
            .then(data => renderRooms(data))
            .catch(err => console.error(err));
    }

    // === [4] 회의실 목록 렌더링 ===
    function renderRooms(roomList) {
        const target = document.getElementById('room-grid-target');
        target.innerHTML = ''; 
        if (!roomList || roomList.length === 0) {
            target.innerHTML = '<div class="text-center p-4">예약 가능한 회의실이 없습니다.</div>';
            return;
        }
        roomList.forEach(room => {
        	let tagsHtml = '';
            const rName = room.roomName.toUpperCase();
         	// [A, D 회의실]: 빔프로젝터, 화이트보드, 컴퓨터, 소화기
            if (rName.includes('A') || rName.includes('D')) {
                tagsHtml = `
                    <span><i class="bi bi-projector"></i> 빔프로젝터</span>
                    <span><i class="bi bi-easel"></i> 화이트보드</span>
                    <span><i class="bi bi-pc-display"></i> 컴퓨터</span>
                    <span><i class="bi bi-fire"></i> 소화기</span>
                `;
            } 
            // [B, C 회의실]: 스크린, 마이크, 화이트보드, 소화기
            else if (rName.includes('B') || rName.includes('C')) {
                tagsHtml = `
                    <span><i class="bi bi-display"></i> 스크린</span>
                    <span><i class="bi bi-mic"></i> 마이크</span>
                    <span><i class="bi bi-easel"></i> 화이트보드</span>
                    <span><i class="bi bi-fire"></i> 소화기</span>
                `;
            } 
            // [기타]: 기본 태그
            else {
                tagsHtml = `
                    <span><i class="bi bi-check-circle"></i> 회의시설 완비</span>
                    <span><i class="bi bi-wifi"></i> 와이파이</span>
                `;
            }

            const html = `
                <div class="res-card" onclick="selectRoom(this, '\${room.roomName}', \${room.roomId})">
                    <div class="card-title">\${room.roomName}</div>
                    <div class="card-desc">최대 \${room.roomCapacity}인 수용</div>
                    <div class="room-tags">
                        \${tagsHtml}
                    </div>
                </div>`;
            target.insertAdjacentHTML('beforeend', html);
        });
    }

    // === [5] 회의실 선택 & 달력 표시 ===
    function selectRoom(element, roomName, roomId) {
        selectedRoomId = roomId; 
        document.querySelectorAll('#room-grid-target .res-card').forEach(el => el.classList.remove('active'));
        element.classList.add('active');

        const calSection = document.getElementById('calendar-section');
        calSection.style.display = 'block';
        renderCalendar(); // 달력 그리기
        calSection.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }

 // === [6] 달력 그리기 & 주간 데이터 로드 ===
    function renderCalendar() {
        const grid = document.getElementById('week-grid-target');
        if (!grid) return; 
        grid.innerHTML = ''; 

        const startDate = getStartDate(currentDate);
        const today = new Date(); 
        today.setHours(0,0,0,0);
        const endDate = new Date(startDate);
        endDate.setDate(startDate.getDate() + 6);
        
        document.getElementById('current-week-range').innerText = 
            `\${startDate.getFullYear()}.\${startDate.getMonth()+1}.\${startDate.getDate()} ~ \${endDate.getMonth()+1}.\${endDate.getDate()}`;

        for (let i = 0; i < 7; i++) {
            const tempDate = new Date(startDate);
            tempDate.setDate(startDate.getDate() + i);
            
            const year = tempDate.getFullYear();
            const month = String(tempDate.getMonth() + 1).padStart(2, '0');
            const day = String(tempDate.getDate()).padStart(2, '0');
            const dateStr = `\${year}-\${month}-\${day}`; 
            
            const isPast = tempDate < today;
            
            const dayNames = ['일', '월', '화', '수', '목', '금', '토'];
            const dayName = dayNames[tempDate.getDay()];
            const isToday = tempDate.toDateString() === today.toDateString();
            
            // [수정] day-col에 d-flex flex-column 추가하여 내부 정렬 제어
            const col = document.createElement('div');
            col.className = 'day-col d-flex flex-column'; 
            col.id = `col-\${dateStr}`;
            
            let headerClass = `day-header \${isToday ? 'today' : ''}`;
            let colorStyle = (i===0) ? "color: #ef4444;" : (i===6) ? "color: #3b82f6;" : "";

            // 1. 헤더 (날짜)
            col.innerHTML = `<span class="\${headerClass}" style="\${colorStyle}">\${dayName} (\${day})</span>`;
            
            if (isPast) {
                col.style.backgroundColor = "#f9f9f9";
                col.innerHTML += `
                    <div class="mt-auto mb-auto w-100 d-flex align-items-center justify-content-center text-muted small">
                        <span style="font-size:11px;">예약 불가</span>
                    </div>`;
            } else {
                // 2. 시간표 그리드 (항상 위쪽에 고정)
                let gridHtml = '<div class="mini-time-grid mt-1">';
                for (let h = 9; h <= 17; h++) {
                    let timeLabel = String(h).padStart(2, '0') + ":00";
                    gridHtml += `<div id="cell-\${dateStr}-\${h}" class="mini-time-cell" onclick="openModal('\${dateStr}', '\${dayName}', \${h})">\${timeLabel}</div>`;
                }
                gridHtml += '</div>';

                // 3. 상태 텍스트 (mt-auto로 맨 아래로 밀기)
                col.innerHTML += `
                    \${gridHtml}
                    <div id="status-\${dateStr}" class="mt-auto pt-3 w-100 pb-2 d-flex justify-content-center" style="min-height: 20px;">
                        </div>
                `;
            }

            grid.appendChild(col);
        }
        
        loadWeeklyData(selectedRoomId, startDate, endDate);
    }

    // 주간 예약 데이터 로드
    function loadWeeklyData(roomId, startObj, endObj) {
        if(!roomId) return;
        
        const toStr = (d) => {
            const m = String(d.getMonth() + 1).padStart(2, '0');
            const day = String(d.getDate()).padStart(2, '0');
            return `\${d.getFullYear()}-\${m}-\${day}`;
        };
        const sDate = toStr(startObj);
        const eDate = toStr(endObj);

        fetch(`/tudio/project/meetingRoom/weekBookedTimes?roomId=\${roomId}&startDate=\${sDate}&endDate=\${eDate}`)
            .then(res => res.json())
            .then(data => {
                // 날짜별 예약된 시간 합계 계산용 객체
                const dateUsage = {}; 

                data.forEach(item => {
                    const d = item.RES_DATE; // 날짜
                    const startH = parseInt(item.START_TIME.split(':')[0]); 
                    const endH = parseInt(item.END_TIME.split(':')[0]);     
                    const resType = item.RES_TYPE;
                    // 예약된 시간만큼 반복하며 'booked' 클래스 추가 (회색 처리)
                    for (let h = startH; h < endH; h++) {
                        const cell = document.getElementById(`cell-\${d}-\${h}`);
                        if (cell) {
                            cell.classList.remove('mini-time-cell'); // 기존 클래스 리셋 방지용
                            if (resType === 'B') {
                                // 관리자 예약 (관리중)
                                cell.classList.add('mini-time-cell', 'admin-blocked'); 
                                cell.innerHTML = `<span class="admin-text">점검중</span>`;
                                cell.title = "회의실 점검중";
                            } else {
                                // 일반 사용자 예약
                                cell.classList.add('mini-time-cell', 'booked'); 
                                cell.title = "사용자 예약됨";
                            }
                            cell.title = "예약됨";
                            cell.onclick = null; // 클릭 방지
                        }
                    }

                    // 총 예약 시간 누적 (마감 처리용)
                    if (!dateUsage[d]) dateUsage[d] = 0;
                    dateUsage[d] += (endH - startH);
                });

                // 9시간 이상 예약된 날짜 처리 (예약 마감 텍스트 표시)
                for (const [dateKey, totalHours] of Object.entries(dateUsage)) {
                    if (totalHours >= 9) { // 09:00 ~ 18:00 (9시간) 전체 마감
                        const statusDiv = document.getElementById(`status-\${dateKey}`);
                        if (statusDiv) {
                        	statusDiv.innerHTML = `<span class="text-danger fw-bold" style="font-size:11px;">예약 마감</span>`;
                        }
                        
                        // 해당 날짜의 모든 셀 비활성화 (시각적 처리)
                        for(let h=9; h<=17; h++) {
                             const cell = document.getElementById(`cell-\${dateKey}-\${h}`);
                             if(cell) cell.classList.add('booked');
                        }
                    }
                }
            })
            .catch(err => console.error(err));
    }

    // === [7] 모달 열기 & 초기화 ===
    function openModal(dateStr, dayName, preSelectedTime = null) {
        // 값 초기화
        document.getElementById('res-title').value = ''; 
        document.getElementById('modal-date-display').innerText = `\${dateStr} (\${dayName})`;
        document.getElementById('modal-date-input').value = dateStr;
        
        // 모달 보이기
        document.getElementById('reservation-modal').style.display = 'flex';
        document.body.style.overflow = 'hidden';
        
        loadProjectMembers(); 
        
        // 예약 가능 여부 확인 후, 시간이 전달되었다면 자동 선택
        checkAvailability(selectedRoomId, dateStr).then(() => {
            if (preSelectedTime) {
                const startSelect = document.getElementById('start-time-select');
                // 해당 시간이 disabled(마감) 상태가 아니라면 선택
                const option = startSelect.querySelector(`option[value="\${preSelectedTime}"]`);
                if (option && !option.disabled) {
                    startSelect.value = preSelectedTime;
                    updateEndTimeOptions(); // 종료 시간 옵션 갱신
                } else if (option && option.disabled) {
                    Swal.fire('알림', '이미 예약된 시간입니다.', 'warning');
                }
            }
        });
    }

    // 날짜 변경 시 (제목 초기화는 선택사항, 여기선 유지)
    function updateModalDate(val) {
        if(!val) return;
        const d = new Date(val);
        const dayNames = ['일', '월', '화', '수', '목', '금', '토'];
        document.getElementById('modal-date-display').innerText = `\${val} (\${dayNames[d.getDay()]})`;
        document.getElementById('res-title').value = ''; // 날짜 바꾸면 제목도 초기화
        
        checkAvailability(selectedRoomId, val);
    }

    // 예약 가능 여부 확인 (빠른 순 정렬 & 안내 문구)
    function checkAvailability(roomId, dateStr) {
        currentBookedTimes = [];
        const infoArea = document.getElementById('booked-info-area');
        infoArea.innerHTML = '';
        
        const selectedDate = new Date(dateStr);
        const today = new Date();
        today.setHours(0,0,0,0);

        if (selectedDate < today) {
            infoArea.innerHTML = '<span class="text-danger fw-bold">지난 날짜 예약 불가</span>';
            document.getElementById('start-time-select').innerHTML = '<option value="">선택 불가</option>';
            document.getElementById('start-time-select').disabled = true;
            document.getElementById('end-time-select').disabled = true;
            return Promise.resolve(); // 빈 Promise 반환
        } else {
            document.getElementById('start-time-select').disabled = false;
            document.getElementById('end-time-select').disabled = false;
        }
        
        // fetch 리턴
        return fetch(`/tudio/project/meetingRoom/bookedTimes?roomId=\${roomId}&date=\${dateStr}`)
            .then(res => res.json())
            .then(data => {
                data.sort((a, b) => a.START_TIME.localeCompare(b.START_TIME));
                currentBookedTimes = data; 
                
                if(data.length > 0) {
                    let timeTexts = data.map(item => `\${item.START_TIME}:00~\${item.END_TIME}:00`);
                    infoArea.innerHTML = `<span class="text-danger small"><i class="bi bi-exclamation-circle"></i> 예약됨: \${timeTexts.join(', ')}</span>`;
                } else {
                    infoArea.innerHTML = '<span class="text-success small"><i class="bi bi-check-circle"></i> 전체 시간 예약 가능</span>';
                }
                renderStartTimeOptions();
            })
            .catch(err => console.error(err));
    }

    // 시간 옵션 렌더링
    function renderStartTimeOptions() {
        const startSelect = document.getElementById('start-time-select');
        startSelect.innerHTML = '<option value="">선택</option>';
        document.getElementById('end-time-select').innerHTML = '<option value="">시작 시간 먼저 선택</option>';

        for(let h=9; h<=17; h++) {
            let isDisabled = false;
            // 예약된 시간과 겹치는지 확인
            for(let item of currentBookedTimes) {
                let s = parseInt(item.START_TIME);
                let e = parseInt(item.END_TIME);
                if(h >= s && h < e) {
                    isDisabled = true;
                    break;
                }
            }
            const timeLabel = String(h).padStart(2, '0') + ":00";
            if(isDisabled) {
                startSelect.innerHTML += `<option value="\${h}" disabled style="background:#eee; color:#aaa;">\${timeLabel} (마감)</option>`;
            } else {
                startSelect.innerHTML += `<option value="\${h}">\${timeLabel}</option>`;
            }
        }
    }
    
    // 종료 시간 옵션
    function updateEndTimeOptions() {
        const startVal = parseInt(document.getElementById('start-time-select').value);
        const endSelect = document.getElementById('end-time-select');
        endSelect.innerHTML = '';
        
        if (isNaN(startVal)) {
            endSelect.innerHTML = '<option value="">시작 시간 먼저 선택</option>';
            return;
        }

        const maxEnd = Math.min(startVal + 4, 18); // 최대 4시간
        
        // 내 시작시간 이후 가장 빠른 남의 예약 찾기 (중복 방지)
        let limitTime = 99;
        for(let item of currentBookedTimes) {
            let s = parseInt(item.START_TIME);
            if(s > startVal) {
                limitTime = Math.min(limitTime, s);
            }
        }

        for (let h = startVal + 1; h <= maxEnd; h++) {
            if(h > limitTime) break; // 남의 예약 시작 시간 침범 불가
            const time = String(h).padStart(2, '0') + ":00";
            endSelect.innerHTML += `<option value="\${h}">\${time}</option>`;
        }
    }

    // === [8] 공통 유틸 ===
    function closeModal() {
        document.getElementById('reservation-modal').style.display = 'none';
        document.body.style.overflow = 'auto';
    }
    window.onclick = function(event) {
        if (event.target == document.getElementById('reservation-modal')) closeModal();
    }
    function reservationList() {
        $(".tudio-meeting").load("/tudio/project/meetingRoom/meetingReservation");
    }
    function loadProjectMembers() {
        const area = document.getElementById('attendee-checkbox-area');
        area.innerHTML = '로딩중...';
        
        fetch('/tudio/project/meetingRoom/projectMembers?projectNo=' + window.projectNo)
            .then(res => res.json())
            .then(members => {
                const myNo = parseInt(document.getElementById('current-member-no').value);
                let html = '';
                members.forEach(m => {
                    const mName = m.memberVO ? m.memberVO.memberName : m.memberName;
                    const isMe = (m.memberNo === myNo);
                    const checkedState = isMe ? 'checked disabled' : '';
                    const labelText = isMe ? `\${mName} (나)` : mName;
                    html += `
                        <div class="form-check">
                            <input class="form-check-input member-check" type="checkbox" value="\${m.memberNo}" id="mem_\${m.memberNo}" \${checkedState}>
                            <label class="form-check-label small" for="mem_\${m.memberNo}" style="cursor:pointer;">\${labelText}</label>
                        </div>`;
                });
                area.innerHTML = html;
            })
            .catch(err => area.innerHTML = '멤버 로드 실패');
    }
    
    // (지도/슬라이더/날짜계산 기존 함수 유지)
    function loadMap(name, addr) {
        kakao.maps.load(function() {    
            var mapContainer = document.getElementById('map');
            var mapOption = { center: new kakao.maps.LatLng(33.450701, 126.570667), level: 3 };
            if (!map) map = new kakao.maps.Map(mapContainer, mapOption);
            
            // [중요] 지도가 보인 후 레이아웃 재조정
            map.relayout();
            
            var geocoder = new kakao.maps.services.Geocoder();
            geocoder.addressSearch(addr, function(result, status) {
                if (status === kakao.maps.services.Status.OK) {
                    var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                    if(marker) marker.setMap(null); 
                    marker = new kakao.maps.Marker({ map: map, position: coords });
                    map.setCenter(coords);
                }
            });
        }); 
    }
    function initSlider(fileGroupNo) {
        currentSlide = 0;
        const container = document.getElementById('slider-images');
        const dotsContainer = document.getElementById('slider-dots');
        if (!fileGroupNo || fileGroupNo === 0) { renderSlider(['https://via.placeholder.com/800x400?text=Tudio']); return; }
        fetch('/tudio/project/meetingRoom/meetingRoomFileList?fileGroupNo=' + fileGroupNo)
            .then(res => res.json())
            .then(data => {
                let urls = (data && data.length > 0) ? data.map(f=>f.filePath) : ['https://via.placeholder.com/800x400?text=No+Image'];
                renderSlider(urls);
            });
    }
    function renderSlider(images) {
        const container = document.getElementById('slider-images');
        const dotsContainer = document.getElementById('slider-dots');
        totalSlides = images.length;
        let imgHtml = '', dotHtml = '';
        images.forEach((src, idx) => {
            imgHtml += `<img src="\${src}" class="slider-img">`;
            dotHtml += `<div class="dot \${idx === 0 ? 'active' : ''}" onclick="goToSlide(\${idx})"></div>`;
        });
        container.innerHTML = imgHtml;
        dotsContainer.innerHTML = dotHtml;
        updateSlidePosition();
    }
    function moveSlide(d) { 
        if(totalSlides===0)return; 
        currentSlide+=d; 
        if(currentSlide<0) currentSlide=totalSlides-1; 
        if(currentSlide>=totalSlides) currentSlide=0; 
        updateSlidePosition(); 
    }
    function goToSlide(i) { currentSlide=i; updateSlidePosition(); }
    function updateSlidePosition() {
        document.getElementById('slider-images').style.transform = `translateX(-\${currentSlide * 100}%)`;
        document.querySelectorAll('.dot').forEach((dot, i) => dot.classList.toggle('active', i===currentSlide));
    }
    function getStartDate(d) {
        const date = new Date(d);
        const day = date.getDay(); 
        const diff = date.getDate() - day; 
        return new Date(date.setDate(diff));
    }
    function moveWeek(dir) { currentDate.setDate(currentDate.getDate() + (dir * 7)); renderCalendar(); }
    function pickDate(val) { if(!val) return; currentDate = new Date(val); renderCalendar(); }
</script>