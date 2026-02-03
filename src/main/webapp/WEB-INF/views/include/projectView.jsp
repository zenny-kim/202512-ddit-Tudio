<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 1. 현재 어떤 탭을 보여줄지 'content'라는 이름의 파라미터로 받습니다.
    // 값이 없으면 기본값으로 'board'(게시판)를 보여주게 설정합니다.
    String content = request.getParameter("content");
    if(content == null) {
        content = "board"; 
    }
    
    // 2. 탭에 따라 불러올 파일 경로를 결정합니다.
    String pagePath = "";
    if(content.equals("tasks"))    pagePath = "tab_tasks.jsp";    // 팀원 A의 파일
    else if(content.equals("library")) pagePath = "tab_library.jsp"; // 팀원 B의 파일
    else if(content.equals("board"))   pagePath = "tab_board.jsp";   // 팀원 C의 파일
    // ... 나머지 탭들도 추가
%>
<!DOCTYPE html>
<html>
<head>
    </head>
<body class="d-flex flex-column min-vh-100">
    <jsp:include page="../include/header_user.jsp" />
    
    <div class="d-flex flex-grow-1">
        <jsp:include page="../include/sidebar_user.jsp" />

        <main class="main-content-wrap flex-grow-1">
            <div class="container-fluid py-4">
                <ul class="nav nav-tabs custom-index-tabs">
                    <li class="nav-item">
                        <a class="nav-link <%= content.equals("tasks") ? "active" : "" %>" href="project_view.jsp?content=tasks">업무</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <%= content.equals("board") ? "active" : "" %>" href="project_view.jsp?content=board">게시판</a>
                    </li>
                    </ul>

                <div class="card tab-content-card">
                    <div class="card-body p-0">
                        <jsp:include page="<%= pagePath %>" />
                    </div>
                </div>
            </div>
        </main>
    </div>

    <jsp:include page="../include/footer.jsp" />
</body>
</html>