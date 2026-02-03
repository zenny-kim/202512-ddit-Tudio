<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<title>Tudio - 설문조사</title>
<jsp:include page="/WEB-INF/views/include/common.jsp" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/project_common.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/cs_common.css">
<link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.min.css" />
</head>

<body>

<jsp:include page="/WEB-INF/views/include/headerUser.jsp" />
<jsp:include page="../include/sidebarCs.jsp" >
			<jsp:param name="menu" value="inquiry" />
		</jsp:include>


<div class="cs-main-wrapper">
    <jsp:include page="../include/sidebarCs.jsp">
        <jsp:param name="menu" value="survey" />
    </jsp:include>
	<div class="cs-header-section">
        <div class="cs-breadcrumb">
            <span>고객센터</span>
            <i class="bi bi-chevron-right small"></i>
            <span class="active">설문조사</span>
        </div>
        <h2 class="cs-page-title">
            <i class="bi bi-pencil-square"></i> 설문조사 참여
        </h2>
    </div>
    <main class="cs-card">
        <c:choose>
            <c:when test="${survey.participated}">
                <div class="text-center py-5">
                    <i class="bi bi-check-circle-fill text-success" style="font-size: 64px;"></i>
                    <h1 class="survey-title mt-4">설문 참여 완료</h1>
                    <p class="text-muted">이미 설문에 참여하셨습니다.<br>소중한 의견을 주셔서 감사합니다.</p>
                    <button class="tudio-btn tudio-btn-outline mt-4" onclick="location.href='/tudio/dashboard'">
                        <i class="bi bi-house-door"></i> 메인으로 돌아가기
                    </button>
                </div>
            </c:when>
            
            <c:otherwise>
                <div class="survey-header">
                    <h1 class="survey-title">${survey.surveyTitle}</h1>
                    <p class="text-muted">${survey.surveyDescription}</p>
                </div>
                <div class="d-flex justify-content-end mb-3">
				    <button type="button"
				            class="tudio-btn tudio-btn-outline"
				            onclick="fillDummySurvey()"
				            title="더미 데이터 자동 입력">
				        <i class="bi bi-magic"></i>
				    </button>
				</div>

                <form id="surveyForm">
                    <input type="hidden" id="surveyNo" value="${survey.surveyNo}">
                    <input type="hidden" id="totalQuestions" value="${survey.questionList.size()}">

                    <c:forEach var="q" items="${survey.questionList}" varStatus="status">
                        <div class="question-box">
                            <h3 class="question-text">
                                <span class="q-num">${status.count}</span>
                                ${q.questionContent}
                            </h3>
                            
                            <div class="option-container">
                                <c:forEach var="opt" items="${q.optionList}">
                                    <label class="option-label">
                                        <input type="radio" 
                                               name="q-${q.questionNo}" 
                                               value="${opt.answerNo}" 
                                               data-question-no="${q.questionNo}">
                                        <span>${opt.answerContent}</span>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>
                    </c:forEach>

                    <div class="mt-5">
                        <button type="button" class="tudio-btn tudio-btn-primary w-100 justify-content-center py-3" style="font-size: 16px;" onclick="submitSurvey()">
                            설문 제출하기
                        </button>
                    </div>
                </form>
            </c:otherwise>
        </c:choose>
    </main>
</div>

<jsp:include page="/WEB-INF/views/include/footer.jsp" />

<script>
    function submitSurvey() {
        const surveyNo = document.getElementById("surveyNo").value;
        const totalQuestions = document.getElementById("totalQuestions").value;
        
        // 1. 답변 데이터 수집
        const answerList = [];
        const checkedRadios = document.querySelectorAll('input[type="radio"]:checked');
        
        checkedRadios.forEach(radio => {
            answerList.push({
                questionNo: parseInt(radio.dataset.questionNo),
                selectAnswerNo: parseInt(radio.value)
            });
        });

        // 2. 유효성 검사 (SweetAlert 적용)
        if (answerList.length < totalQuestions) {
            Swal.fire({
                icon: 'warning',
                title: '잠깐만요!',
                text: '모든 문항에 답변해 주세요.',
                confirmButtonColor: '#3182CE',
                confirmButtonText: '확인'
            });
            return;
        }

        const payload = {
            surveyNo: parseInt(surveyNo),
            answerList: answerList
        };

        // 3. AJAX 전송
        fetch("/tudio/survey/submit", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(payload)
        })
        .then(response => {
            if (response.status === 409) {
                // 이미 참여함
                Swal.fire({
                    icon: 'info',
                    title: '이미 참여하셨습니다',
                    text: '설문 결과는 한 번만 제출 가능합니다.',
                    confirmButtonColor: '#3182CE'
                }).then(() => {
                    location.reload();
                });
            } else if (response.ok) {
                // 성공
                Swal.fire({
                    icon: 'success',
                    title: '제출 완료!',
                    text: '소중한 의견 감사합니다.',
                    confirmButtonColor: '#3182CE'
                }).then(() => {
                    location.reload();
                });
            } else if (response.status === 401) {
                // 비로그인
                Swal.fire({
                    icon: 'error',
                    title: '로그인 필요',
                    text: '로그인 후 이용해 주세요.',
                    confirmButtonColor: '#d33'
                }).then(() => {
                    location.href = "/login";
                });
            } else {
                throw new Error("Server Error");
            }
        })
        .catch(error => {
            console.error("통신 에러:", error);
            Swal.fire({
                icon: 'error',
                title: '오류 발생',
                text: '저장 중 문제가 발생했습니다. 관리자에게 문의하세요.',
                confirmButtonColor: '#d33'
            });
        });
    }
    function fillDummySurvey() {
        // 문항별 선택할 보기 번호 (1부터 시작)
        const dummyAnswers = [1, 3, 1, 1, 1, 1, 4, 3, 1, 2];

        const questionBoxes = document.querySelectorAll('.question-box');

        questionBoxes.forEach((box, index) => {
            const answerIndex = dummyAnswers[index] - 1; // 0-based
            if (answerIndex < 0) return;

            const radios = box.querySelectorAll('input[type="radio"]');

            if (radios[answerIndex]) {
                radios[answerIndex].checked = true;
            }
        });

    }
</script>

</body>
</html>