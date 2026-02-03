<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="sidebar">
    <a href="${pageContext.request.contextPath}/tudio/notice/list" class="nav-link ${param.menu == 'notice' ? 'active' : ''}">
        <i class="bi bi-megaphone"></i>
        <span>공지사항</span>
    </a>
    
    <a href="${pageContext.request.contextPath}/tudio/faq/list" class="nav-link ${param.menu == 'faq' ? 'active' : ''}">
        <i class="bi bi-question-circle"></i>
        <span>자주 묻는 질문</span>
    </a>

    <a href="${pageContext.request.contextPath}/tudio/inquiry/list" class="nav-link ${param.menu == 'inquiry' ? 'active' : ''}">
        <i class="bi bi-chat-dots"></i>
        <span>1:1 문의사항</span>
    </a>
    
    <a href="${pageContext.request.contextPath}/tudio/survey/detail/3" class="nav-link ${param.menu == 'survey' ? 'active' : ''}">
        <i class="bi bi-card-checklist"></i>
        <span>설문</span>
    </a>
</nav>