<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <title>Tudio - 프로젝트 목록</title>
  <jsp:include page="/WEB-INF/views/include/common.jsp" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/project_common.css">
</head>

<body class="d-flex flex-column min-vh-100">

  <jsp:include page="../include/headerUser.jsp" />

  <div class="d-flex flex-grow-1">
    <jsp:include page="../include/sidebarUser.jsp">
      <jsp:param name="menu" value="project_list" />
    </jsp:include>

    <main class="main-content-wrap flex-grow-1">
      <div class="container-fluid px-4 pt-4">

        <div class="d-flex align-items-center justify-content-between mb-4">
          <h1 class="h3 fw-bold m-0 text-primary-dark">
            <i class="bi bi-collection-fill me-2"></i> 프로젝트 목록
          </h1>
        </div>

        <form action="${pageContext.request.contextPath}/tudio/project/list" method="get" id="searchForm">
          <input type="hidden" id="page" name="page" value="${pagingVO.currentPage}">

          <div class="tudio-card p-3 mb-4 bg-light border shadow-sm">
            <div class="row g-3 align-items-center">
              <div class="col-auto">
                <label class="small text-muted fw-bold">검색조건</label>
              </div>

              <div class="col-md-2">
                <select id="searchType" name="searchType" class="form-select form-select-sm">
                  <option value="title" <c:if test="${searchType eq 'title'}">selected</c:if>>프로젝트명</option>
                  <option value="projectDuration" <c:if test="${searchType eq 'projectDuration'}">selected</c:if>>프로젝트 기간</option>
                </select>
              </div>

              <div class="col">
                <div id="inputName" class="filter-input-group">
                  <input type="text" class="form-control form-control-sm" name="searchWord" value="${searchWord}" placeholder="검색어를 입력하세요">
                </div>
                <div id="inputDuration" class="filter-input-group d-none">
                  <div class="input-group input-group-sm">
                    <input type="date" class="form-control" name="startDate" value="${startDate}" id="startDate">
                    <span class="input-group-text">~</span>
                    <input type="date" class="form-control" name="endDate" value="${endDate}" id="endDate">
                  </div>
                </div>
              </div>

              <div class="col-auto">
                <button class="tudio-btn tudio-btn-primary" type="submit">
                  <i class="bi bi-search"></i> 검색
                </button>
              </div>

              <div class="col-auto d-none d-lg-block border-start mx-2" style="height: 24px;"></div>

              <div class="col-auto ms-auto">
                <div class="d-flex align-items-center">
                  <label class="small text-muted me-2 text-nowrap"><i class="bi bi-sort-down"></i> 정렬</label>
                  <select id="sort" name="sort" class="form-select form-select-sm sort-select">
                    <option value="latest" <c:if test="${sort eq 'latest'}">selected</c:if>>최신 등록순</option>
                    <option value="deadline" <c:if test="${sort eq 'deadline'}">selected</c:if>>마감 임박순</option>
                    <option value="name" <c:if test="${sort eq 'name'}">selected</c:if>>프로젝트명순</option>
                  </select>
                </div>
              </div>
            </div>
          </div>
        </form>

        <!-- =========================
             ✅ 카드 그리드 목록
             (중요: id/class/data- 유지 -> 기존 JS 그대로 동작)
             ========================= -->
        <div class="project-grid" id="projectListContainer">
          <c:set value="${pagingVO.dataList}" var="projectList"/>

          <c:choose>
            <c:when test="${empty projectList}">
              <div class="w-100 text-center py-5">
                <i class="bi bi-folder-x fs-1 text-muted"></i>
                <p class="mt-3 text-muted">조회된 프로젝트가 없습니다.</p>
              </div>
            </c:when>

            <c:otherwise>
              <c:forEach items="${projectList}" var="l">


                <div class="card project-card"
                     data-url="${pageContext.request.contextPath}/tudio/project/detail?projectNo=${l.projectNo}"
                     style="cursor:pointer;">

                  <div class="card-body d-flex flex-column p-4 h-100">

                    <!-- 상단: 상태/디데이 + 북마크 -->
                    <div class="d-flex justify-content-between align-items-center mb-3">
                      <div class="d-flex align-items-center">
                        <c:choose>
                          <c:when test="${l.statusLabel == '진행중'}"><span class="badge bg-success">${l.statusLabel}</span></c:when>
                          <c:when test="${l.statusLabel == '완료'}"><span class="badge bg-secondary">${l.statusLabel}</span></c:when>

                          <c:when test="${l.statusLabel == '지연'}"><span class="badge bg-danger">${l.statusLabel}</span></c:when>
                          <c:otherwise><span class="badge-ios bg-red-soft">${l.statusLabel}</span></c:otherwise>
                        </c:choose>

                        <c:if test="${l.statusLabel != '완료'}">
                          <span class="dday-badge">${l.ddayLabel}</span>
                        </c:if>
                      </div>

                      <c:set var="bookmark" value="${l.projectBookmark eq 'Y'}"/>
                      <button type="button"
                              class="bookmark-btn btn p-0 border-0 bg-transparent"
                              aria-label="북마크 토글"
                              data-project-no="${l.projectNo}"
                              data-bookmarked="${bookmark ? 'true' : 'false'}">
                        <i class="bi ${bookmark ? 'bi-star-fill text-warning' : 'bi-star text-muted'}"></i>
                      </button>
                    </div>

                    <!-- 제목 -->
                    <div class="mb-auto">
                      <h5 class="proj-title" title="${l.projectName}">
                        ${l.projectName}
                      </h5>
                    </div>

                    <!-- 중단: PM(테스트용) + 진행률(테스트/고정 75) -->
                    <div class="d-flex justify-content-between align-items-end mt-3 mb-3">
                      <div class="d-flex align-items-center">
                        <div class="rounded-circle d-flex align-items-center justify-content-center me-2"
                             style="width:32px; height:32px; background:#F9FAFB; border:1px solid #F2F4F6;">
                          <i class="bi bi-person-fill" style="color:#B0B8C1; font-size: 1.1rem;"></i>
                        </div>
                        <div class="d-flex flex-column">
                          <div class="fw-bold text-dark" style="font-size: 13px;">
                            ${l.pmName} <span class="text-muted" style="font-size: 11px; font-weight: 600;">PM</span>
                          </div>
                        </div>
                      </div>

                      <%-- ✅ 추가: projectRateMap에서 현재 프로젝트의 진척률 꺼내기 (없으면 0) --%>
                      <c:set var="progVal" value="${projectRateMap[l.projectNo]}"/>
                      <c:if test="${empty progVal}">
                        <c:set var="progVal" value="0"/>
                      </c:if>

                      <%-- ✅ 추가: 100%면 원형 그래프 숨김 --%>
                    <c:choose>
  <c:when test="${progVal ge 100}">
    <div class="progress-circle"
         style="background:#3182F6;">
      <span class="progress-value">100%</span>
    </div>
  </c:when>
  <c:otherwise>
    <div class="progress-circle"
         style="background: conic-gradient(#3182F6 ${progVal}%, #F2F4F6 0deg);">
      <span class="progress-value">${progVal}%</span>
    </div>
  </c:otherwise>
</c:choose>

                    </div>

                    <!-- 하단: 기간 -->
                    <div class="pt-3 border-top d-flex align-items-center">
                      <i class="bi bi-calendar4 me-2" style="color:#ADB5BD;"></i>
                      <span class="proj-date">
                        <fmt:formatDate value="${l.projectStartdate}" pattern="yyyy.MM.dd"/>
                        -
                        <fmt:formatDate value="${l.projectEnddate}" pattern="yyyy.MM.dd"/>
                      </span>
                    </div>

                  </div>
                </div>


              </c:forEach>
            </c:otherwise>
          </c:choose>
        </div>

        <div class="d-flex justify-content-center my-5" id="pagingArea">
          ${pagingVO.pagingHTML}
        </div>

      </div>
    </main>
  </div>

  <jsp:include page="../chat/main.jsp"/>
  <jsp:include page="../include/footer.jsp" />

  <script>
    // 검색 정렬 페이징 다시하기
    document.addEventListener('DOMContentLoaded', function() {
      const filterSelect = document.getElementById('searchType');
      const inputName = document.getElementById('inputName');
      const inputDuration = document.getElementById('inputDuration');
      const searchForm = document.getElementById('searchForm');
      const ctx = '${pageContext.request.contextPath}';

      // 1. 검색 조건 전환 (이름 vs 기간)
      function toggleInputs() {
        if (filterSelect.value === 'title') {
          inputDuration.classList.add('d-none');
          inputName.classList.remove('d-none');
        } else {
          inputName.classList.add('d-none');
          inputDuration.classList.remove('d-none');
        }
      }
      filterSelect.addEventListener('change', toggleInputs);
      toggleInputs(); // 초기 실행

      // 2. 정렬 변경 시 자동 검색
      document.getElementById('sort').addEventListener('change', function() {
        searchForm.submit();
      });


      // 목록 HTML만 갱신
      async function refreshListOnly() {
        const res = await fetch(location.pathname + location.search, {
          headers: { 'X-Requested-With': 'XMLHttpRequest' }
        });
        if (!res.ok) throw new Error('HTTP ' + res.status);

        const html = await res.text();
        const doc = new DOMParser().parseFromString(html, 'text/html');

        const newList = doc.querySelector('#projectListContainer');
        const newPaging = doc.querySelector('#pagingArea');

        if (newList) document.querySelector('#projectListContainer').innerHTML = newList.innerHTML;
        if (newPaging) document.querySelector('#pagingArea').innerHTML = newPaging.innerHTML;

        // 갈아끼운 뒤 다시 이벤트 바인딩
        bindBookmarkHandlers();
        bindCardHandlers();
        bindPagingHandlers();
      }

      // 북마크 이벤트 바인딩(재사용)
      function bindBookmarkHandlers() {
        document.querySelectorAll('.bookmark-btn').forEach(btn => {
          if (btn.dataset.bound === 'true') return;
          btn.dataset.bound = 'true';

          btn.addEventListener('click', async function(e) {
            e.preventDefault();
            e.stopPropagation(); // 카드 클릭 막기

            const projectNo = this.dataset.projectNo;
            const wasBookmarked = (this.dataset.bookmarked === 'true');
            const nextBookmarked = !wasBookmarked;

            // 1) 화면 아이콘 즉시 변경
            const iconEl = this.querySelector('i');
            iconEl.classList.remove('bi-star', 'bi-star-fill', 'text-warning', 'text-muted');
            if (nextBookmarked) {
              iconEl.classList.add('bi-star-fill', 'text-warning');
            } else {
              iconEl.classList.add('bi-star', 'text-muted');
            }
            this.dataset.bookmarked = String(nextBookmarked);

            try {
              const res = await fetch(ctx + '/tudio/project/list/bookmark', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },
                body: 'projectNo=' + encodeURIComponent(projectNo) // ✅ '=' 꼭 필요
              });

              if (!res.ok) throw new Error('HTTP ' + res.status);

              // 서버 토글 성공하면(정렬 반영 위해) 목록만 새로고침
              await res.json(); // { bookmark: "Y"|"N" } - 값은 refreshListOnly가 다시 그림
              await refreshListOnly();

            } catch (err) {
              // 실패하면 원복
              iconEl.classList.remove('bi-star', 'bi-star-fill', 'text-warning', 'text-muted');
              if (wasBookmarked) {
                iconEl.classList.add('bi-star-fill', 'text-warning');
              } else {
                iconEl.classList.add('bi-star', 'text-muted');
              }
              this.dataset.bookmarked = String(wasBookmarked);
              console.error(err);
            }
          });
        });
      }

      // =========================
      // 카드 클릭 바인딩
      // =========================
      function bindCardHandlers() {
        document.querySelectorAll('.project-card').forEach(card => {
          if (card.dataset.bound === 'true') return;
          card.dataset.bound = 'true';

          card.addEventListener('click', function() {
            window.location.href = this.dataset.url;
          });
        });
      }

      // =========================
      //  페이징 바인딩
      // =========================
      function bindPagingHandlers() {
        const pagingArea = document.getElementById('pagingArea');
        if (!pagingArea) return;

        // pagingArea는 매번 innerHTML 교체되므로 dataset.bound는 새로 다시 세팅됨
        pagingArea.addEventListener('click', function(e) {
          const aTag = e.target.closest('a');
          if (!aTag) return;
          e.preventDefault();

          document.getElementById('page').value = aTag.dataset.page;
          searchForm.submit();
        }, { once: true }); // 중복 이벤트 방지용(이 노드에서 1번만)
      }

      // ====== 초기 바인딩 ======
      bindBookmarkHandlers();
      bindCardHandlers();
      bindPagingHandlers();
    });
  </script>
</body>
</html>
