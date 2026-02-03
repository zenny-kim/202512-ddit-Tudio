<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

	<div class="search-area">
        <div class="search-input-wrapper">
            <i data-feather="search" class="search-icon" style="width: 18px; height: 18px;"></i>
            <input type="text" class="search-input" placeholder="이름, 부서 검색">
        </div>
    </div>
    <div class="selected-users-area" id="selectedUsersArea" style="display: none;">
        <div class="selected-users-container" id="selectedUsersTrack"> 
	    </div>
	</div>

    <div class="user-list-area">
        <div class="section-title">프로젝트 구성원</div>
        
        <ul class="user-list">
        	<c:forEach items="${memberList }" var="member">
	            <li class="user-item">
	                <div class="user-info-wrapper">
	                	<c:choose>
                            <c:when test="${not empty member.memberProfileimg}">
                                <img src="${pageContext.request.contextPath}${member.memberProfileimg}" class="profile-img" alt="프로필">
                            </c:when>
                            <c:otherwise>
                                <div class="default-avatar avatar-color-${member.memberNo % 5}">
                                    <i data-feather="user" style="width:20px; height:20px;"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
	                    <div class="user-text">
	                        <span class="user-name">${member.memberName }</span>
	                        <span class="user-status">${member.memberDepartment } ${member.memberPosition }</span>
	                    </div>
	                </div>
	                <div class="checkbox-wrapper">
	                    <input type="checkbox" class="user-checkbox" id="user${member.memberNo }" value="${member.memberNo }">
	                    <span class="checkmark"></span>
	                </div>
	            </li>
        	</c:forEach>
        </ul>
    </div>
    
    <div class="bottom-action-area">
        <button class="start-chat-btn" disabled>${param.btnText }</button>
    </div>
