<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<nav class="sidebar">
	<sec:authorize access="hasRole('ROLE_MEMBER')">
		<a href="/tudio/project/create" class="nav-link ${param.menu == 'project_new' ? 'active' : ''}">
	        <i class="bi bi-plus-square"></i>
	        <span>새 프로젝트</span>
	    </a>
    </sec:authorize>
	
    <a href="/tudio/dashboard" class="nav-link ${param.menu == 'dashboard' ? 'active' : ''}">
        <i class="bi bi-speedometer2"></i>
        <span>대시보드</span>
    </a>
    
    <sec:authorize access="hasRole('ROLE_MEMBER')">
	    <a href="/tudio/myTask" class="nav-link ${param.menu == 'myTask' ? 'active' : ''}">
	        <i class="bi bi-check2-square"></i>
	        <span>내 업무</span> 
	    </a>
    </sec:authorize>

    
    <a href="/tudio/project/list" class="nav-link ${param.menu == 'project_list' ? 'active' : ''}">
        <i class="bi bi-folder2-open"></i>
        <span>프로젝트</span>
    </a>
    
    <a href="/tudio/schedule" class="nav-link ${param.menu == 'schedule' ? 'active' : ''}">
        <i class="bi bi-calendar3"></i>
        <span>전체 일정</span>
    </a>
	
	<%-- <sec:authorize access="hasRole('ROLE_MEMBER')">
		<a href="/tudio/drive" class="nav-link ${param.menu == 'drive' ? 'active' : ''}">
	        <i class="bi bi-archive"></i>
	        <span>자료실</span>
	    </a>
    </sec:authorize> --%>
    
    <a href="/tudio/videoChat/list" class="nav-link ${param.menu == 'video_chat' ? 'active' : ''}">
        <i class="bi bi-camera-video"></i>
        <span>화상미팅</span>
    </a>
    
    <a href="/tudio/approval/list" class="nav-link ${param.menu == 'approval' ? 'active' : ''}">
        <i class="bi bi-file-earmark-check"></i>
        <span>결재</span>
    </a>
</nav>