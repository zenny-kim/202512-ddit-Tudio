<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>

<head>
<title>Tudio - 문의사항</title>
<jsp:include page="/WEB-INF/views/include/common.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/project_common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/cs_common.css">
<link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
</head>

<body>
    <jsp:include page="../include/headerUser.jsp" />

    <div class="cs-main-wrapper">
        <%-- 사이드바 포함 --%>
        <jsp:include page="../include/sidebarCs.jsp">
            <jsp:param name="menu" value="inquiry" />
        </jsp:include>

        <%-- [3] 경로 및 제목 시작점 통일 --%>
        <div class="cs-header-section">
            <div class="cs-breadcrumb">
                <span>고객센터</span>
                <i class="bi bi-chevron-right small"></i>
                <span>1:1 문의</span>
                <i class="bi bi-chevron-right small"></i>
                <span class="active">문의 작성</span>
            </div>
            
            <c:set var="isEdit" value="${not empty inquiry.inquiryNo}" />
            <h2 class="cs-page-title">
                <i class="bi bi-pencil-square"></i> ${isEdit ? '문의 내용 수정' : '새로운 문의 작성'}
            </h2>
        </div>

        <main class="cs-card" >
            <p class="text-muted mb-4 pb-3 border-bottom">
                ${isEdit ? '기존 문의 내용을 수정하여 다시 접수할 수 있습니다.' : '서비스 이용 중 발생한 궁금한 점이나 불편한 사항을 남겨주시면 신속하게 답변해 드리겠습니다.'}
            </p>

            <form action="${pageContext.request.contextPath}/tudio/inquiry/${isEdit ? 'update' : 'create'}" 
                  method="post" enctype="multipart/form-data" id="inquiryForm">
                
                <c:if test="${isEdit}">
                    <input type="hidden" name="inquiryNo" value="${inquiry.inquiryNo}">
                </c:if>

                <div class="mb-4">
                    <label for="inquiryType" class="form-label">문의 유형 <span class="required">*</span></label>
                    <select class="form-select" id="inquiryType" name="inquiryType" required>
                        <option value="" disabled ${!isEdit ? 'selected' : ''}>유형을 선택해주세요</option>
                        <option value="INQUIRY" ${inquiry.inquiryType eq 'INQUIRY' ? 'selected' : ''}>일반문의</option>
                        <option value="REPORT" ${inquiry.inquiryType eq 'REPORT' ? 'selected' : ''}>신고하기</option>
                    </select>
                </div>

                <div class="mb-4">
                    <label for="inquiryTitle" class="form-label">제목 <span class="required">*</span></label>
                    <input type="text" class="form-control" id="inquiryTitle" name="inquiryTitle" 
                           value="${inquiry.inquiryTitle}"
                           placeholder="제목을 입력해주세요 (최대 50자)" maxlength="50" required>
                </div>

                <div class="mb-4">
                    <label for="inquiryContent" class="form-label">문의 내용 <span class="required">*</span></label>
                    <textarea class="form-control" id="inquiryContent" name="inquiryContent" rows="10" 
                              placeholder="구체적인 내용을 적어주시면 보다 정확한 답변이 가능합니다." required>${inquiry.inquiryContent}</textarea>
                </div>

                <div class="mb-5">
                    <label for="files" class="form-label">첨부 파일</label>
                    <div class="form-info-box">
                        <input class="form-control" type="file" id="files" name="files" multiple>
                        <c:if test="${isEdit && not empty fileList}">
                            <div class="mt-2 small text-primary">
                                <i class="bi bi-file-earmark-check"></i> 기존 첨부된 파일이 있습니다. 새로 등록 시 기존 파일은 대체됩니다.
                            </div>
                        </c:if>
                        <div class="form-text mt-2"><i class="bi bi-info-circle me-1"></i> 여러 개의 파일을 동시에 선택할 수 있습니다.</div>
                    </div>
                </div>

                <%-- 공통 버튼 클래스 tudio-btn 적용 --%>
                <div class="d-flex justify-content-center gap-3 mt-5">
                    <button type="button" class="tudio-btn tudio-btn-outline px-5" onclick="history.back()">취소</button>
                    <button type="submit" class="tudio-btn tudio-btn-primary px-5" style="min-width: 160px; justify-content: center;">
                        ${isEdit ? '수정 완료' : '등록하기'}
                    </button>
                </div>
            </form>
        </main>
    </div>
    
     <jsp:include page="../include/footer.jsp" />
    <script src="${pageContext.request.contextPath}/js/footer.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
$(function() {
    $("#inquiryForm").on("submit", function(e) {
        
        // 제목 체크 
        let title = $("input[name='inquiryTitle']").val().trim();
        if(title == "") {
            alert("제목을 입력해주세요.");
            $("input[name='inquiryTitle']").focus();
            e.preventDefault(); 
            return false;
        }

        // 내용 체크 
        let content = $("textarea[name='inquiryContent']").val().trim();
        if(content == "") {
            alert("내용을 입력해주세요.");
            $("textarea[name='inquiryContent']").focus();
            e.preventDefault(); 
            return false;
        }
    });
});
</script>
</body>
</html>