/**
 * 공통 알림창 함수 (SweetAlert2)
 * @param {string} type - 'success', 'error', 'warning', 'info'
 * @param {string} msg - 표시할 메시지
 */
function sweetAlert(type, msg) {
    Swal.fire({
        title: msg,
        icon: type,
        draggable: true,
        confirmButtonColor: '#0d6efd' // 부트스트랩 프라이머리 색상과 통일
    });
}

//에러코드 확인용 함수
function handleAjaxError(xhr, status, error) {
    console.log("----- 에러 발생 상세 로그 -----");
    console.log("상태 코드: " + xhr.status);
    console.log("에러 내용: " + error);
    console.log("서버 응답: ", xhr.responseText);
    console.log("----------------------------");
    Swal.fire('에러', '서버 통신 중 문제가 발생했습니다.', 'error');
}

//footer.js 함수
function formatToHour(dateStr) {
    if (!dateStr) return '-';
    let dateTime = dateStr.replace('T', ' '); 
    return dateTime.includes(':') ? dateTime.split(':')[0] + '시' : dateTime;
}

//공통 데이터 체크 함수
function isEmpty(val) {
    return (val === "" || val === null || val === undefined || (val !== null && typeof val === "object" && !Object.keys(val).length));
}

// 천 단위 콤마 포맷 (금액 표시용)
function formatComma(num) {
    if(!num) return "0";
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}


