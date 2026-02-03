<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>Tudio</title>
<jsp:include page="/WEB-INF/views/include/common.jsp" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/project_common.css">
</head>

<body class="d-flex flex-column min-vh-100">

	<jsp:include page="../include/header_user.jsp" />

	<div class="d-flex flex-grow-1">
		<jsp:include page="../include/sidebar_user.jsp">
			<jsp:param name="menu" value="메뉴아이디" />
		</jsp:include>

		<main class="main-content-wrap flex-grow-1">
			
			<div class="container-fluid px-4 pt-4">
				<div class="d-flex align-items-center justify-content-between mb-4">
					<h1 class="h3 fw-bold m-0 text-primary-dark">
						<i class="bi bi-tag-fill me-2"></i>페이지 큰 제목
					</h1>
					<button type="button" class="btn btn-primary">
						<i class="bi bi-plus-lg me-1"></i>주요 작업 버튼
					</button>
				</div>

				<div class="row justify-content-center">
					<div class="col-12">
						<div class="tudio-card p-4">
							<form id="commonForm">
								<div class="mb-4">
									<label class="form-label fw-bold">항목 이름
										<span class="text-danger">*</span>
									</label>
									<input type="text" class="form-control" placeholder="내용을 입력하세요.">
								</div>
								<div class="row mb-4">
									<div class="col-md-6">
										<label class="form-label fw-bold">선택 항목</label>
										<select class="form-select">
											<option value="">선택해주세요</option>
										</select>
									</div>
									<div class="col-md-6">
										<label class="form-label fw-bold">날짜 항목</label>
										<input type="date" class="form-control">
									</div>
								</div>
								<div class="d-flex justify-content-end pt-3 border-top">
									<button type="button" class="btn btn-outline-secondary me-2"onclick="history.back()">취소</button>
									<button type="submit" class="btn btn-primary">저장하기</button>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</main>
	</div>

	<jsp:include page="../include/footer.jsp" />
	<script>
		// 페이지 개별 스크립트 작성 영역
	</script>
</body>
</html>