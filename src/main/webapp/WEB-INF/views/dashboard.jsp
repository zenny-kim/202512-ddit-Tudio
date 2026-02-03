<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<jsp:include page="/WEB-INF/views/include/common.jsp" />
    
    <!-- GridStack.js -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/gridstack.js/7.2.3/gridstack.min.css" rel="stylesheet" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/gridstack.js/7.2.3/gridstack-all.js"></script>
    
	<!-- layout css -->    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/project_common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <%-- <link rel="stylesheet" href="${pageContext.request.contextPath}/dist/assets/user.css" /> --%>
</head>
<body data-context-path="${pageContext.request.contextPath}"
	data-login-no="${loginUser.memberNo}"
	class="d-flex flex-column min-vh-100">
	<jsp:include page="./include/headerUser.jsp"/>
    
    <jsp:include page="./include/sidebarUser.jsp">
    	<jsp:param name="menu" value="dashboard" />
    </jsp:include>

	<main class="main-content-wrap pt-4 pb-5" id="mainContent">
		<div id="react-user-root" class="container-fluid"
			data-page="dashboard"
         	data-member-no="${loginUser.memberNo}">
    	</div>
	</main>	
	
	<jsp:include page="./chat/main.jsp"/>
	
	<jsp:include page="./include/footer.jsp"/>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
	
	<script src="${pageContext.request.contextPath}/js/footer.js"></script>
	<script type="module" src="${pageContext.request.contextPath}/dist/js/common.chunk.js"></script>
	<script type="module" src="${pageContext.request.contextPath}/dist/js/user.bundle.js"></script>
</body>
</html>