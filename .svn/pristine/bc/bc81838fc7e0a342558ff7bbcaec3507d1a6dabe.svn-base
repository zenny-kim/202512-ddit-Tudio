<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="tudio-scope">

    <div class="tudio-section mb-4">
        <div class="tudio-section-header">
            <h5 class="m-0 fw-bold text-primary-dark">
                <i class="bi bi-building me-2"></i>회의실 예약
            </h5>
            <div>
                <button class="tudio-btn tudio-btn-outline" onclick="alert('나의 예약 현황 모달 띄우기')">
                    <i class="bi bi-journal-check"></i> 나의 예약 현황
                </button>
            </div>
        </div>

        <div class="tudio-section-filter row g-2 m-0">
            <div class="col-md-3">
                <label class="small text-muted fw-bold mb-1">지점 선택</label>
                <select class="form-select form-select-sm" id="officeSelect" onchange="loadRooms()">
                    <option value="gangnam">Tudio 강남점</option>
                    <option value="pangyo">Tudio 판교점</option>
                    <option value="yeouido">Tudio 여의도점</option>
                </select>
            </div>

            <div class="col-md-3">
                <label class="small text-muted fw-bold mb-1">날짜 선택</label>
                <input type="date" class="form-control form-control-sm" id="reservationDate">
            </div>
            
            <div class="col-md-6 d-flex align-items-end justify-content-end pb-1">
                <div class="d-flex gap-3 small">
                    <div class="d-flex align-items-center gap-1">
                        <span class="d-inline-block rounded border bg-white" style="width:12px; height:12px;"></span>
                        <span class="text-muted">예약 가능</span>
                    </div>
                    <div class="d-flex align-items-center gap-1">
                        <span class="d-inline-block rounded bg-secondary opacity-25" style="width:12px; height:12px;"></span>
                        <span class="text-muted">예약 불가</span>
                    </div>
                    <div class="d-flex align-items-center gap-1">
                        <span class="d-inline-block rounded bg-primary" style="width:12px; height:12px;"></span>
                        <span class="text-muted">내 선택</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="roomListContainer" class="d-flex flex-column gap-3">
        <div class="text-center py-5 text-muted">
            <div class="spinner-border text-primary mb-2" role="status"></div>
            <p>회의실 정보를 불러오는 중입니다...</p>
        </div>
    </div>

</div>

<div class="modal fade" id="reservationConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content tudio-modal">
            <div class="tudio-modal-header p-3 d-flex justify-content-between align-items-center">
                <h6 class="tudio-modal-title fw-bold m-0">예약 확인</h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <div class="alert alert-primary d-flex align-items-center mb-3" role="alert">
                    <i class="bi bi-info-circle-fill me-2 fs-5"></i>
                    <div>선택하신 시간에 예약을 진행하시겠습니까?</div>
                </div>
                
                <table class="table table-borderless table-sm mb-0">
                    <tr>
                        <th class="text-muted" style="width: 80px;">지점</th>
                        <td class="fw-bold" id="modalOfficeName">-</td>
                    </tr>
                    <tr>
                        <th class="text-muted">회의실</th>
                        <td class="fw-bold" id="modalRoomName">-</td>
                    </tr>
                    <tr>
                        <th class="text-muted">날짜</th>
                        <td id="modalDate">-</td>
                    </tr>
                    <tr>
                        <th class="text-muted">시간</th>
                        <td class="text-primary fw-bold" id="modalTime">-</td>
                    </tr>
                </table>
            </div>
            <div class="tudio-modal-footer p-2 text-end">
                <button type="button" class="tudio-btn tudio-btn-outline" data-bs-dismiss="modal">취소</button>
                <button type="button" class="tudio-btn tudio-btn-primary" id="btnConfirmReservation">
                    <i class="bi bi-check-lg"></i> 예약 확정
                </button>
            </div>
        </div>
    </div>
</div>

<style>
    /* 시간 슬롯 버튼 스타일 */
    .time-slot-btn {
        width: 100%;
        padding: 8px 0;
        font-size: 0.85rem;
        border: 1px solid #eef2f7;
        background-color: #fff;
        color: #334155;
        border-radius: 8px;
        transition: all 0.2s ease;
    }
    
    .time-slot-btn:hover:not(:disabled) {
        border-color: var(--main-blue);
        color: var(--main-blue);
        background-color: #f0f7ff;
    }

    /* 선택된 상태 */
    .time-slot-btn.selected {
        background-color: var(--main-blue);
        color: #fff;
        border-color: var(--main-blue);
        font-weight: 700;
        box-shadow: 0 4px 10px rgba(59, 130, 246, 0.3);
    }

    /* 예약 불가(마감) 상태 */
    .time-slot-btn:disabled {
        background-color: #f1f5f9;
        color: #cbd5e1;
        border-color: #f1f5f9;
        cursor: not-allowed;
        text-decoration: line-through;
    }
    
    /* 회의실 이미지 플레이스홀더 */
    .room-img-placeholder {
        width: 120px;
        height: 120px;
        background-color: #f8fafc;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #94a3b8;
        font-size: 2rem;
    }
</style>

<script>
(function() {
    /**
     * [Dummy Data] 백엔드 연결 전 UI 테스트용 데이터
     * 실제로는 AJAX로 데이터를 받아와야 합니다.
     */
    const dummyRooms = {
        'gangnam': [
            { id: 101, name: 'A 회의실 (대회의실)', capacity: 10, img: 'bi-people', items: ['빔프로젝터', '화이트보드'] },
            { id: 102, name: 'B 회의실 (소회의실)', capacity: 4, img: 'bi-laptop', items: ['모니터'] },
            { id: 103, name: 'C 포커스룸', capacity: 2, img: 'bi-chat-square-text', items: ['방음'] }
        ],
        'pangyo': [
            { id: 201, name: '판교 1번 룸', capacity: 6, img: 'bi-building', items: ['화상장비'] },
            { id: 202, name: '판교 2번 룸', capacity: 8, img: 'bi-building', items: ['모니터', '화이트보드'] }
        ],
        'yeouido': [
            { id: 301, name: 'VIP 라운지', capacity: 12, img: 'bi-gem', items: ['소파', '다과'] }
        ]
    };

    // 이미 예약된 시간 (Dummy)
    const bookedSlots = [ '10:00', '13:00', '14:00' ]; 
    const timeSlots = ['09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00'];

    // DOM Elements
    const officeSelect = document.getElementById('officeSelect');
    const dateInput = document.getElementById('reservationDate');
    const container = document.getElementById('roomListContainer');
    
    // 예약 모달 관련 변수
    let selectedRoomData = null;
    let selectedTimeData = null;
    const confirmModal = new bootstrap.Modal(document.getElementById('reservationConfirmModal'));

    // 1. 초기화 함수
    function init() {
        // 오늘 날짜로 세팅
        dateInput.valueAsDate = new Date();
        loadRooms(); // 초기 로드
    }

    // 2. 룸 리스트 렌더링 함수
    window.loadRooms = function() {
        const selectedOffice = officeSelect.value;
        const rooms = dummyRooms[selectedOffice] || [];
        
        container.innerHTML = ''; // 초기화

        if(rooms.length === 0) {
            container.innerHTML = `<div class="tudio-empty"><i class="bi bi-x-circle"></i><p>등록된 회의실이 없습니다.</p></div>`;
            return;
        }

        rooms.forEach(room => {
            // 편의시설 태그 생성
            const badges = room.items.map(item => 
                `<span class="badge bg-light text-secondary border fw-normal me-1">${item}</span>`
            ).join('');

            // 시간 슬롯 버튼 생성
            let slotsHtml = '<div class="row g-2">';
            timeSlots.forEach(time => {
                // 랜덤하게 예약 마감 처리 (테스트용)
                const isBooked = Math.random() < 0.3; // 30% 확률로 예약됨
                const disabledAttr = isBooked ? 'disabled' : '';
                
                slotsHtml += `
                    <div class="col-2">
                        <button type="button" class="time-slot-btn" 
                            ${disabledAttr} 
                            onclick="openBookingModal(${room.id}, '${room.name}', '${time}')">
                            ${time}
                        </button>
                    </div>
                `;
            });
            slotsHtml += '</div>';

            // HTML 조립 (tudio-card 스타일 활용)
            const cardHtml = `
                <div class="tudio-card p-4 d-flex gap-4 align-items-start">
                    <div class="d-flex flex-column align-items-center" style="min-width: 140px;">
                        <div class="room-img-placeholder mb-3">
                            <i class="bi ${room.img}"></i>
                        </div>
                        <h6 class="fw-bold mb-1 text-center">${room.name}</h6>
                        <span class="text-muted small mb-2">수용인원: ${room.capacity}명</span>
                        <div class="d-flex flex-wrap justify-content-center">
                            ${badges}
                        </div>
                    </div>

                    <div class="flex-grow-1 border-start ps-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="small fw-bold text-primary-dark">
                                <i class="bi bi-clock me-1"></i> 예약 가능 시간
                            </span>
                            <span class="badge bg-light text-muted border">${dateInput.value} 기준</span>
                        </div>
                        ${slotsHtml}
                    </div>
                </div>
            `;
            container.insertAdjacentHTML('beforeend', cardHtml);
        });
    };

    // 3. 예약 모달 열기 (전역 함수로 등록하여 HTML onclick에서 접근 가능하게 함)
    window.openBookingModal = function(roomId, roomName, time) {
        selectedRoomData = { id: roomId, name: roomName };
        selectedTimeData = time;

        const officeName = officeSelect.options[officeSelect.selectedIndex].text;
        
        document.getElementById('modalOfficeName').textContent = officeName;
        document.getElementById('modalRoomName').textContent = roomName;
        document.getElementById('modalDate').textContent = dateInput.value;
        document.getElementById('modalTime').textContent = time + " ~ " + (parseInt(time.split(':')[0]) + 1) + ":00"; // 1시간 단위

        confirmModal.show();
    };

    // 4. 예약 확정 버튼 이벤트
    document.getElementById('btnConfirmReservation').addEventListener('click', function() {
        // AJAX 예약 요청 로직이 들어갈 곳
        /*
        $.ajax({
            url: '/tudio/project/reservation/add',
            method: 'POST',
            data: { 
                projectNo: projectNo, // 전역 변수
                roomId: selectedRoomData.id,
                date: dateInput.value,
                time: selectedTimeData
            },
            success: function(res) { ... }
        });
        */
        
        // 성공 시뮬레이션
        confirmModal.hide();
        
        // SweetAlert2 (사용중이라면) 또는 기본 alert
        if(typeof Swal !== 'undefined') {
            Swal.fire('예약 완료', '회의실 예약이 확정되었습니다.', 'success');
        } else {
            alert('예약이 완료되었습니다!');
        }
        
        // 목록 새로고침 (예약된 상태 반영을 위해)
        loadRooms(); 
    });

    // 실행
    init();

})();
</script>