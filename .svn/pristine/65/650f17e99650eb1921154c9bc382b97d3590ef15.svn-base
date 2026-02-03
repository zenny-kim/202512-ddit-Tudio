$(function() {
    // ==========================================
    // 1. 변수 및 초기화
    // ==========================================
    const $views = $('.notice-section'); // 모든 뷰(목록, 작성, 상세, 수정)
    const $titleText = $('#page-title-text');

    // 화면 전환 함수
    function switchView(viewId, title) {
        $views.hide();
        $(viewId).fadeIn(200);
        if(title) $titleText.text(title);
    }

    // ==========================================
    // 2. 이벤트 리스너 (버튼 클릭 동작)
    // ==========================================

    // [목록] -> [글쓰기] 화면으로 이동
    $('#btn-go-write').on('click', function() {
        switchView('#view-notice-write', '공지사항 작성');
        // 폼 초기화
        $('#form-notice-write')[0].reset();
    });

    // [작성/상세/수정] -> [목록] 화면으로 복귀 (취소 버튼들)
    $(document).on('click', '.btn-cancel', function() {
        switchView('#view-notice-list', '공지사항 목록');
    });

    // [목록] -> [상세] 화면으로 이동 (제목 클릭 시)
    $(document).on('click', '.notice-link', function(e) {
        e.preventDefault();
        
        // 데이터 가져오기 (실제로는 서버에서 ID로 조회)
        const id = $(this).data('id');
        const title = $(this).data('title');
        const writer = $(this).data('writer');
        const date = $(this).data('date');
        const content = $(this).data('content');

        // 상세 화면에 뿌리기
        $('#detail-title').text(title);
        $('#detail-writer').text('작성자: ' + writer);
        $('#detail-date').text('작성일: ' + date);
        $('#detail-content').text(content); // pre-line CSS가 있어서 줄바꿈 적용됨

        // 수정 화면을 위해 임시 저장 (hidden input 등에 넣어도 됨)
        $('#edit-id').val(id);
        $('#edit-title').val(title);
        $('#edit-content').val(content);

        switchView('#view-notice-detail', '공지사항 상세');
    });

    // [상세] -> [수정] 화면으로 이동
    $('#btn-go-edit').on('click', function() {
        switchView('#view-notice-edit', '공지사항 수정');
    });

    // [수정] -> [상세] (수정 취소)
    $('.btn-cancel-edit').on('click', function() {
        switchView('#view-notice-detail', '공지사항 상세');
    });

    // ==========================================
    // 3. CRUD 액션 (AJAX 연동 위치)
    // ==========================================

    // 글 등록
    $('#form-notice-write').on('submit', function(e) {
        e.preventDefault();
        if(confirm('공지사항을 등록하시겠습니까?')) {
            alert('등록되었습니다.');
            switchView('#view-notice-list', '공지사항 목록');
        }
    });

    // 글 수정 완료
    $('#btn-update').on('click', function() {
        if(confirm('수정하시겠습니까?')) {
            // 여기에 AJAX 수정 요청 코드 작성
            alert('수정되었습니다.');
            
            // 상세 화면 내용 갱신 후 이동
            $('#detail-title').text($('#edit-title').val());
            $('#detail-content').text($('#edit-content').val());
            switchView('#view-notice-detail', '공지사항 상세');
        }
    });

    // 글 삭제
    $('#btn-delete').on('click', function() {
        if(confirm('정말로 삭제하시겠습니까?')) {
            // 여기에 AJAX 삭제 요청 코드 작성
            alert('삭제되었습니다.');
            switchView('#view-notice-list', '공지사항 목록');
        }
    });
});