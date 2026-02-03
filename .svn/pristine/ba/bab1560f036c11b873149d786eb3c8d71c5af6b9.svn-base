<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 
    파일명: board_faq.jsp
    설명: 관리자용 FAQ 목록 관리 (드래그 앤 드롭 순서 변경 기능 포함)
--%>

<script src="https://cdn.jsdelivr.net/npm/sortablejs@latest/Sortable.min.js"></script>

<div class="main-content-wrap flex-grow-1">
    <div class="container-fluid">
        
        <div class="card admin-card">
            <div class="admin-card-header">
                <h5 class="fw-bold mb-0">❓ FAQ (자주 묻는 질문) 관리</h5>
                <button class="btn btn-primary btn-sm" onclick="alert('FAQ 등록 페이지로 이동')">FAQ 등록</button>
            </div>
            
            <div class="p-3">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 50px;">순서</th>
                                <th>질문</th>
                                <th>상태</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody id="faqTableBody">
                            <tr data-id="1">
                                <td class="text-center"><i class="bi bi-grip-vertical drag-handle"></i></td>
                                <td class="fw-bold">기업 회원은 어떻게 가입하나요?</td>
                                <td><span class="badge bg-success">공개</span></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-secondary btn-edit-faq"
                                        data-id="1"
                                        data-question="기업 회원은 어떻게 가입하나요?"
                                        data-answer="기업 회원 가입 절차는 다음과 같습니다..."
                                        data-active="true">수정</button>
                                    <button class="btn btn-sm btn-outline-danger btn-delete-faq">삭제</button>
                                </td>
                            </tr>
                            
                            <tr data-id="2">
                                <td class="text-center"><i class="bi bi-grip-vertical drag-handle"></i></td>
                                <td class="fw-bold">결제 영수증은 어디서 확인하나요?</td>
                                <td><span class="badge bg-success">공개</span></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-secondary btn-edit-faq"
                                        data-id="2"
                                        data-question="결제 영수증은 어디서 확인하나요?"
                                        data-answer="로그인 후 [마이페이지] > [결제 내역]..."
                                        data-active="true">수정</button>
                                    <button class="btn btn-sm btn-outline-danger btn-delete-faq">삭제</button>
                                </td>
                            </tr>

                            <tr data-id="3">
                                <td class="text-center"><i class="bi bi-grip-vertical drag-handle"></i></td>
                                <td class="fw-bold">API 연동 키는 어떻게 발급받나요?</td>
                                <td><span class="badge bg-secondary">비공개</span></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-secondary btn-edit-faq"
                                        data-id="3"
                                        data-question="API 연동 키는 어떻게 발급받나요?"
                                        data-answer="[설정] > [API 관리] 메뉴에서..."
                                        data-active="false">수정</button>
                                    <button class="btn btn-sm btn-outline-danger btn-delete-faq">삭제</button>
                                </td>
                            </tr>

                            <tr data-id="4">
                                <td class="text-center"><i class="bi bi-grip-vertical drag-handle"></i></td>
                                <td class="fw-bold">프로젝트 생성 개수에 제한이 있나요?</td>
                                <td><span class="badge bg-success">공개</span></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-secondary btn-edit-faq"
                                        data-id="4"
                                        data-question="프로젝트 생성 개수에 제한이 있나요?"
                                        data-answer="무료 회원은 최대 3개..."
                                        data-active="true">수정</button>
                                    <button class="btn btn-sm btn-outline-danger btn-delete-faq">삭제</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <div class="card-footer bg-white border-top-0 d-flex justify-content-between align-items-center mb-2">
                <small class="text-muted"><i class="bi bi-info-circle me-1"></i>좌측 핸들을 드래그하여 순서를 변경할 수 있습니다.</small>
                <button class="btn btn-dark" onclick="saveOrder()">순서 저장</button>
            </div>
        </div>

    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        
        // 1. SortableJS 초기화 (드래그 앤 드롭)
        const faqTableBody = document.getElementById('faqTableBody');
        if (faqTableBody) {
            new Sortable(faqTableBody, {
                animation: 150,
                handle: '.drag-handle', // 드래그 핸들 클래스 지정 (CSS 참고)
                ghostClass: 'sortable-ghost', // 드래그 중인 아이템 스타일 (CSS 참고)
                onEnd: function (evt) {
                    console.log('순서 변경됨:', evt.oldIndex, '->', evt.newIndex);
                    // 필요 시 여기서 바로 AJAX로 순서 업데이트 요청 가능
                }
            });
        }

        // 2. 수정 버튼 클릭 이벤트 (이벤트 위임)
        document.body.addEventListener('click', function(e) {
            if (e.target.closest('.btn-edit-faq')) {
                const btn = e.target.closest('.btn-edit-faq');
                const data = btn.dataset;
                
                // 실제 구현 시: 수정 모달을 띄우거나 페이지 이동
                alert(`[수정 모드]\nID: \${data.id}\n질문: \${data.question}`);
                console.log('데이터:', data);
            }
        });

        // 3. 삭제 버튼 클릭 이벤트 (이벤트 위임)
        document.body.addEventListener('click', function(e) {
            if (e.target.closest('.btn-delete-faq')) {
                if (confirm('정말로 삭제하시겠습니까?')) {
                    const row = e.target.closest('tr');
                    if (row) {
                        row.remove(); // DOM에서 제거
                        // 실제 구현 시: AJAX로 서버에 삭제 요청
                        alert('삭제되었습니다.');
                    }
                }
            }
        });
    });

    // 4. 순서 저장 함수
    function saveOrder() {
        const rows = document.querySelectorAll('#faqTableBody tr');
        const orderList = [];

        rows.forEach((row, index) => {
            orderList.push({
                id: row.getAttribute('data-id'),
                order: index + 1
            });
        });

        console.log('저장할 순서 데이터:', orderList);
        alert('순서가 저장되었습니다.');
        // 실제 구현 시: fetch 또는 ajax로 서버에 orderList 전송
    }
</script>