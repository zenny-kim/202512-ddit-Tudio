<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 
    파일명: policy_terms.jsp
    설명: 정책 관리 (이용약관 편집)
--%>

<div class="main-content-wrap flex-grow-1">
    <div class="container-fluid">
        
        <nav class="breadcrumb-nav mb-4">
            <span class="text-muted">Admin</span>
            <span class="sep"><i class="bi bi-chevron-right small"></i></span>
            <span class="text-body fw-bold">정책 관리</span>
            <span class="sep"><i class="bi bi-chevron-right small"></i></span>
            <span class="text-primary fw-bold">이용약관 및 권한</span>
        </nav>

        <div id="section-policy-terms" class="admin-section active">
            <div class="card admin-card">
                <div class="admin-card-header">
                    <h5 class="fw-bold mb-0">📜 이용약관 관리</h5>
                </div>
                <div class="p-4">
                    <div class="mb-3">
                        <label class="form-label fw-bold">서비스 이용약관</label>
                        <textarea class="form-control" id="term-content" rows="15" readonly>제 1조 (목적)
본 약관은 Tudio(이하 "회사")가 제공하는 서비스의 이용조건 및 절차, 이용자와 회사의 권리, 의무, 책임사항을 규정함을 목적으로 합니다.

제 2조 (용어의 정의)
1. "서비스"라 함은 구현되는 단말기와 상관없이 "회원"이 이용할 수 있는 Tudio 및 Tudio 관련 제반 서비스를 의미합니다.
2. "회원"이라 함은 회사의 "서비스"에 접속하여 이 약관에 따라 "회사"와 이용계약을 체결하고 "회사"가 제공하는 "서비스"를 이용하는 고객을 말합니다.
3. "아이디(ID)"라 함은 "회원"의 식별과 "서비스" 이용을 위하여 "회원"이 정하고 "회사"가 승인하는 문자와 숫자의 조합을 의미합니다.

제 3조 (약관의 게시와 개정)
1. "회사"는 이 약관의 내용을 "회원"이 쉽게 알 수 있도록 서비스 초기 화면에 게시합니다.
2. "회사"는 "약관의 규제에 관한 법률", "정보통신망 이용촉진 및 정보보호 등에 관한 법률(이하 "정보통신망법")" 등 관련법을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다.
                        </textarea>
                    </div>
                    <div class="d-flex justify-content-end">
                        <button class="btn btn-primary px-4" id="btn-edit-terms">수정</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        
        // 이용약관 수정/저장 토글 로직
        const btnEditTerms = document.getElementById('btn-edit-terms');
        const termContent = document.getElementById('term-content');

        if (btnEditTerms && termContent) {
            btnEditTerms.addEventListener('click', function() {
                // 현재 읽기 전용인지 확인
                if (termContent.hasAttribute('readonly')) {
                    // [수정 모드 전환]
                    termContent.removeAttribute('readonly');
                    termContent.focus(); 
                    
                    // 버튼 스타일 및 텍스트 변경
                    this.textContent = '저장';
                    this.classList.remove('btn-primary');
                    this.classList.add('btn-success');
                } else {
                    // [저장 처리]
                    if (confirm('변경된 약관을 저장하시겠습니까?')) {
                        // 읽기 모드로 복귀
                        termContent.setAttribute('readonly', true);
                        
                        // 버튼 원복
                        this.textContent = '수정';
                        this.classList.remove('btn-success');
                        this.classList.add('btn-primary');
                        
                        // 실제 구현 시: 여기서 AJAX로 서버에 데이터 전송
                        alert('이용약관이 수정되었습니다.');
                    }
                }
            });
        }
    });
</script>