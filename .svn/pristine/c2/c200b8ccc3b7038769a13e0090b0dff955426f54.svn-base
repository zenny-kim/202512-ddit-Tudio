<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 
    파일명: board_inquiry.jsp
    설명: 고객센터 1:1 문의사항 목록 및 상세 조회 (SPA 형태 전환)
--%>

<div class="admin-card">
    
    <div id="inquiryListSection" class="admin-section active">
        <div class="admin-card-header">
            <h5 class="fw-bold mb-0"><i class="bi bi-chat-dots me-2"></i>나의 문의 내역</h5>
            <button class="btn btn-sm btn-primary fw-bold px-3" onclick="alert('문의하기 페이지/모달로 이동')">
                <i class="bi bi-pencil-square me-1"></i> 문의하기
            </button>
        </div>
        
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="bg-light">
                        <tr>
                            <th width="80" class="text-center">No</th>
                            <th width="120" class="text-center">상태</th>
                            <th class="ps-4">제목</th>
                            <th width="150" class="text-center">작성일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr onclick="showInquiryDetail(3, 'API 연동 키 발급 관련 문의드립니다.', '2025.12.17', 'pending', 'API 키를 재발급 받으려고 하는데, 기존 키는 즉시 만료되나요? 아니면 유예 기간이 있나요?')" style="cursor: pointer;">
                            <td class="text-center">3</td>
                            <td class="text-center"><span class="badge bg-warning text-dark border border-warning">답변대기</span></td>
                            <td class="ps-4 fw-bold">
                                API 연동 키 발급 관련 문의드립니다. <i class="bi bi-lock-fill text-muted ms-1 small"></i>
                            </td>
                            <td class="text-center text-muted">2025.12.17</td>
                        </tr>

                        <tr onclick="showInquiryDetail(2, '결제 영수증 출력 오류', '2025.12.10', 'complete', '결제 내역에서 영수증 인쇄 버튼을 눌러도 반응이 없습니다.\n브라우저는 크롬 사용 중입니다.', '2025.12.11', '안녕하세요. Tudio 고객센터입니다.\n해당 문제는 팝업 차단 설정 때문일 수 있습니다. 브라우저 설정을 확인해주세요.')" style="cursor: pointer;">
                            <td class="text-center">2</td>
                            <td class="text-center"><span class="badge bg-primary-subtle text-primary border border-primary-subtle">답변완료</span></td>
                            <td class="ps-4">
                                결제 영수증 출력 오류 <i class="bi bi-lock-fill text-muted ms-1 small"></i>
                            </td>
                            <td class="text-center text-muted">2025.12.10</td>
                        </tr>

                        <tr onclick="showInquiryDetail(1, '계정 비밀번호 초기화 요청', '2025.11.25', 'complete', '비밀번호를 잊어버렸습니다.', '2025.11.25', '이메일 인증을 통해 재설정 가능합니다.')" style="cursor: pointer;">
                            <td class="text-center">1</td>
                            <td class="text-center"><span class="badge bg-primary-subtle text-primary border border-primary-subtle">답변완료</span></td>
                            <td class="ps-4">
                                계정 비밀번호 초기화 요청 <i class="bi bi-lock-fill text-muted ms-1 small"></i>
                            </td>
                            <td class="text-center text-muted">2025.11.25</td>
                        </tr>
                    </tbody>
                </table>
            </div>
            
            <div class="p-3 border-top">
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center mb-0">
                        <li class="page-item disabled"><a class="page-link" href="#"><i class="bi bi-chevron-left"></i></a></li>
                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#"><i class="bi bi-chevron-right"></i></a></li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

    <div id="inquiryDetailSection" class="admin-section">
        <div class="admin-card-header">
            <div class="d-flex align-items-center gap-3">
                <button class="btn btn-sm btn-outline-secondary" onclick="showInquiryList()">
                    <i class="bi bi-arrow-left me-1"></i> 목록
                </button>
                <h5 class="fw-bold mb-0" id="detailTitle">제목이 들어갑니다</h5>
            </div>
            <div id="detailStatusBadge">
                </div>
        </div>

        <div class="card-body p-4">
            <div class="d-flex justify-content-between text-muted small mb-3 border-bottom pb-2">
                <div>
                    <span class="me-3"><i class="bi bi-person me-1"></i> 작성자: <strong>나</strong></span>
                    <span><i class="bi bi-calendar3 me-1"></i> 작성일: <span id="detailDate">2025.00.00</span></span>
                </div>
                <div>
                    <button class="btn btn-link p-0 text-muted text-decoration-none me-2">수정</button>
                    <button class="btn btn-link p-0 text-danger text-decoration-none">삭제</button>
                </div>
            </div>

            <div id="inquiry-detail-content">
                </div>

            <div id="answerSection" class="mt-4 p-4 bg-light rounded border d-none">
                <h6 class="fw-bold text-primary mb-3"><i class="bi bi-headset me-2"></i>Tudio 고객센터 답변</h6>
                <div class="small text-muted mb-2 pb-2 border-bottom">
                    답변일: <span id="answerDate"></span>
                </div>
                <div id="answerContent" style="white-space: pre-line; color: #333;"></div>
            </div>
        </div>
    </div>

</div>

<script>
    /**
     * 문의사항 상세 보기 함수
     * @param {number} id - 글 번호
     * @param {string} title - 제목
     * @param {string} date - 작성일
     * @param {string} status - 상태 ('pending' | 'complete')
     * @param {string} content - 문의 내용
     * @param {string} ansDate - (Optional) 답변일
     * @param {string} ansContent - (Optional) 답변 내용
     */
    function showInquiryDetail(id, title, date, status, content, ansDate, ansContent) {
        // 1. 데이터 바인딩
        document.getElementById('detailTitle').innerText = title;
        document.getElementById('detailDate').innerText = date;
        document.getElementById('inquiry-detail-content').innerText = content;

        // 2. 상태 뱃지 설정
        const badgeContainer = document.getElementById('detailStatusBadge');
        if (status === 'pending') {
            badgeContainer.innerHTML = '<span class="badge bg-warning text-dark border border-warning">답변대기</span>';
            document.getElementById('answerSection').classList.add('d-none');
        } else {
            badgeContainer.innerHTML = '<span class="badge bg-primary-subtle text-primary border border-primary-subtle">답변완료</span>';
            
            // 답변 내용 표시
            document.getElementById('answerSection').classList.remove('d-none');
            document.getElementById('answerDate').innerText = ansDate || '-';
            document.getElementById('answerContent').innerText = ansContent || '답변 내용이 없습니다.';
        }

        // 3. 화면 전환 (목록 숨김 -> 상세 표시)
        document.getElementById('inquiryListSection').classList.remove('active');
        document.getElementById('inquiryDetailSection').classList.add('active');
    }

    /**
     * 목록으로 돌아가기 함수
     */
    function showInquiryList() {
        // 화면 전환 (상세 숨김 -> 목록 표시)
        document.getElementById('inquiryDetailSection').classList.remove('active');
        document.getElementById('inquiryListSection').classList.add('active');
    }
</script>