<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/board_notice.css">

<nav class="breadcrumb-nav mb-4" id="notice-breadcrumb">
    <span class="text-muted">Admin</span>
    <span class="sep"><i class="bi bi-chevron-right small"></i></span>
    <span class="text-body fw-bold">게시판 관리</span>
    <span class="sep"><i class="bi bi-chevron-right small"></i></span>
    <span class="text-primary fw-bold" id="page-title-text">공지사항</span>
</nav>

<div id="view-notice-list" class="notice-section active">
    <div class="card admin-card">
        <div class="admin-card-header">
            <h5 class="fw-bold mb-0">📢 공지사항 목록</h5>
            <button class="btn btn-primary btn-sm" id="btn-go-write">글쓰기</button>
        </div>
        <div class="p-3">
            <table class="table table-hover align-middle">
                <thead>
                    <tr>
                        <th style="width: 60px;">No</th>
                        <th>제목</th>
                        <th style="width: 120px;">작성자</th>
                        <th style="width: 150px;">날짜</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="text-center">2</td>
                        <td>
                            <a href="#" class="notice-link"
                               data-id="2"
                               data-title="서버 점검 안내"
                               data-writer="관리자"
                               data-date="2025-12-15"
                               data-content="안녕하세요.\n서버 점검 예정입니다.">서버 점검 안내
                            </a>
                        </td>
                        <td>관리자</td>
                        <td>2025-12-15</td>
                    </tr>
                    <tr>
                        <td class="text-center">1</td>
                        <td>
                            <a href="#" class="notice-link"
                               data-id="1"
                               data-title="12월 업데이트 내역"
                               data-writer="관리자"
                               data-date="2025-12-01"
                               data-content="1. 기능 추가\n2. 버그 수정">
                                12월 업데이트 내역
                            </a>
                        </td>
                        <td>관리자</td>
                        <td>2025-12-01</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div id="view-notice-write" class="notice-section" style="display: none;">
    <div class="card admin-card">
        <div class="admin-card-header bg-light">
            <h5 class="fw-bold mb-0">✏️ 공지사항 작성</h5>
        </div>
        <div class="p-4">
            <form id="form-notice-write">
                <div class="mb-3">
                    <label class="form-label fw-bold">제목</label>
                    <input type="text" class="form-control" name="title" placeholder="제목을 입력하세요">
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold">내용</label>
                    <textarea class="form-control" name="content" rows="10" placeholder="내용을 입력하세요"></textarea>
                </div>
                <div class="form-check mb-4">
                    <input class="form-check-input" type="checkbox" id="chk-important-write">
                    <label class="form-check-label" for="chk-important-write">상단 고정 (필독)</label>
                </div>
                <div class="d-flex justify-content-end gap-2">
                    <button type="button" class="btn btn-secondary px-4 btn-cancel">취소</button>
                    <button type="submit" class="btn btn-primary px-4">등록</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div id="view-notice-detail" class="notice-section" style="display: none;">
    <div class="card admin-card">
        <div class="admin-card-header bg-light">
            <h5 class="fw-bold mb-0">📄 공지사항 상세</h5>
        </div>
        <div class="p-4">
            <div class="border-bottom pb-3 mb-4">
                <h4 class="fw-bold mb-2" id="detail-title"></h4>
                <div class="text-muted small d-flex gap-3">
                    <span id="detail-writer"></span>
                    <span class="vr"></span>
                    <span id="detail-date"></span>
                </div>
            </div>
            
            <div class="notice-content mb-5" id="detail-content" style="min-height: 200px; white-space: pre-line;"></div>

            <hr>
            <div class="d-flex justify-content-between mt-3">
                <button class="btn btn-secondary px-4 btn-cancel">목록</button>
                <div>
                    <button class="btn btn-outline-primary me-1" id="btn-go-edit">수정</button>
                    <button class="btn btn-outline-danger" id="btn-delete">삭제</button>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="view-notice-edit" class="notice-section" style="display: none;">
    <div class="card admin-card">
        <div class="admin-card-header bg-light">
            <h5 class="fw-bold mb-0">🛠️ 공지사항 수정</h5>
        </div>
        <div class="p-4">
            <form id="form-notice-edit">
                <input type="hidden" id="edit-id">
                <div class="mb-3">
                    <label class="form-label fw-bold">제목</label>
                    <input type="text" class="form-control" id="edit-title">
                </div>
                <div class="mb-3">
                    <label class="form-label fw-bold">내용</label>
                    <textarea class="form-control" id="edit-content" rows="10"></textarea>
                </div>
                <div class="d-flex justify-content-end gap-2">
                    <button type="button" class="btn btn-secondary px-4 btn-cancel-edit">취소</button>
                    <button type="button" class="btn btn-primary px-4" id="btn-update">수정 완료</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/board_notice.js"></script>