<%@ page contentType="text/html; charset=UTF-8" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/notification.css">

<input type="hidden"
       name="memberNo"
       id="memberNo"
       value="${loginUser.memberNo}" />

<!-- 알림 드롭다운 패널 -->
<div id="notiPanel"
     class="dropdown-menu dropdown-menu-end shadow border-0 mt-2 p-0"
     style="width: 380px;">

  <div class="noti-top">
    <span class="noti-title">알림</span>
    <button type="button"
            class="noti-close-btn"
            id="notiCloseBtn"
            aria-label="close">×</button>
  </div>

  <div class="noti-tabs2">
    <button type="button"
            class="noti-tab2 active"
            data-tab="unread"
            id="tabUnread">
      안읽음
      <span id="unreadCountTab"
            class="noti-count"
            style="display:none;">0</span>
    </button>

    <button type="button"
            class="noti-tab2"
            data-tab="read"
            id="tabRead">
      읽음
    </button>
  </div>

  <!-- ✅ 필터(카테고리) -->
  <div class="noti-filters">
    <button type="button" class="noti-filter-btn active" data-filter="ALL">전체</button>
    <button type="button" class="noti-filter-btn" data-filter="TASK">업무</button>
    <button type="button" class="noti-filter-btn" data-filter="SCHEDULE">일정</button>
    <button type="button" class="noti-filter-btn" data-filter="SYSTEM">시스템</button>
    <button type="button" class="noti-filter-btn" data-filter="PROJECT">초대</button>
    <!-- 여기에 기업 관리자와 PM만 보이는 탭으로 만들어아럄 -->
    <button type="button" class="noti-filter-btn" data-filter="APPROVAL">결재</button>
  </div>

  <div class="noti-list-wrap">
    <ul id="notiList"></ul>
    <div id="notiEmpty">알림이 없습니다.</div>
  </div>
</div>

<style>
/* ✅ 로그인 후 새 알림 토스트 */
.noti-login-toast{
  position: absolute;
  top: 38px;
  right: 0;
  z-index: 2000;
  background: #111827;
  color: #fff;
  font-size: 12px;
  padding: 8px 10px;
  border-radius: 10px;
  box-shadow: 0 10px 20px rgba(0,0,0,0.18);
  cursor: pointer;
  user-select: none;
  white-space: nowrap;
}
.noti-login-toast:hover{
  filter: brightness(1.05);
}
</style>

<script>
const isLoggedIn   = ${loginUser != null ? "true" : "false"};
const ctxPathNoti  = "${pageContext.request.contextPath}";
const apiBaseNoti  = ctxPathNoti + "/tudio/noti";

// ✅ 상태: 탭(안읽음/읽음) + 필터(전체/시스템/결재/업무/일정/...)
const notiState = {
  tab: "unread",
  filter: "ALL"
};

const memberNo = (document.getElementById("memberNo")
  ? document.getElementById("memberNo").value
  : ""
);

const LS_KEY_LAST_MAX_NOTI = "tudio:lastMaxNotiNo:" + memberNo;

function pickList(data){
  return (data && (data.notiList || data.list))
    ? (data.notiList || data.list)
    : [];
}

function pickUnreadCount(data){
  return Number(
    (data && (data.notiUnreadCount != null || data.unreadCount != null))
      ? (data.notiUnreadCount != null ? data.notiUnreadCount : data.unreadCount)
      : 0
  );
}

// ✅ 헤더 배지(숫자) 업데이트
function updateHeaderNotiDot(unreadCount){
  var $dot = $("#headerNotiDot");
  if (!$dot.length) return;

  var n = Number(unreadCount || 0);
  if (n > 0) {
    $dot.text(n > 99 ? "99+" : String(n));
    $dot.removeClass("d-none");
  } else {
    $dot.text("");
    $dot.addClass("d-none");
  }
}

function updateUnreadCountTab(unreadCount){
  var $c = $("#unreadCountTab");
  var n = Number(unreadCount || 0);

  if (n > 0) $c.text(n > 99 ? "99+" : String(n)).show();
  else $c.text("0").hide();
}

function getMaxNotiNo(list){
  var max = 0;
  (list || []).forEach(function(n){
    var v = Number(n.notiNo || n.NOTI_NO || 0);
    if (v > max) max = v;
  });
  return max;
}

function showLoginToast(unreadCount){
  var $t = $("#notiLoginToast");
  if (!$t.length) return;

  var n = Number(unreadCount || 0);
  if (!(n > 0)) {
    // ✅ 알림 없으면 토스트 숨김
    $t.addClass("d-none");
    return;
  }

  $t.removeClass("d-none");
  clearTimeout(window.__notiToastTimer);
  window.__notiToastTimer = setTimeout(function(){
    $t.addClass("d-none");
  }, 6000);
}

function isNotiPanelOpen(){
  return $("#notiPanel").hasClass("show");
}

function hideLoginToast(){
  $("#notiLoginToast").addClass("d-none");
}

/* =========================================================
   ✅ 핵심: 서버 notiType -> 프론트 filter 그룹 매핑
========================================================= */
function mapTypeToFilter(n){
  var type = String(n.notiType || n.NOTI_TYPE || "").toUpperCase();

  // ✅ 초대
  if (type === "NOTI_INVITE") return "PROJECT";

  // ✅ 요청한 매핑
  if (type === "NOTI_SYSTEM")   return "SYSTEM";
  if (type === "NOTI_APPROVAL") return "APPROVAL";
  if (type === "NOTI_TASK")     return "TASK";
  if (type === "NOTI_SCHEDULE") return "SCHEDULE";

  // (옵션) 프로젝트 계열
  if (type.indexOf("PROJECT") >= 0) return "PROJECT";

  return "ETC";
}

// ✅ 프론트 2차 필터링: 전체는 전부, 나머지는 매핑된 것만
function applyClientFilter(list){
  if (!list) return [];
  if (notiState.filter === "ALL") return list;

  return list.filter(function(n){
    return mapTypeToFilter(n) === notiState.filter;
  });
}

function loadNotiList(){
  return $.ajax({
    url: apiBaseNoti + "/list",
    method: "GET",
    dataType: "json",
    data: {
      tab: notiState.tab,
      filter: notiState.filter
    }, // 서버가 filter 무시해도 됨
    success: function(data){
      var list   = pickList(data);
      var unread = pickUnreadCount(data);

      // ✅ 서버가 filter를 제대로 지원 안 해도, 프론트에서 보정
      list = applyClientFilter(list);

      renderNotiList(list);
      updateUnreadCountTab(unread);
      updateHeaderNotiDot(unread);
    },
    error: function(xhr){
      console.error("알림 목록 조회 실패", xhr.status, xhr.responseText);
    }
  });
}

function renderNotiList(list){
  var $list = $("#notiList");
  var $empty = $("#notiEmpty");

  $list.empty();

  if (!list || list.length === 0) {
    $empty.show();
    return;
  }
  $empty.hide();

  $.each(list, function(i, n){
    var isUnread = (String(n.isRead || n.IS_READ || "N") === "N");
    var stateClass = isUnread ? "is-unread" : "is-read";

    var tagInfo  = getTagInfo(n);
    var whenText = formatNotiTime(n.notiRegdate || n.NOTI_REGDATE);
    var headline = getHeadline(n);
    var preview  = escapeHtml(getPreview(n));

    var notiNo  = n.notiNo || n.NOTI_NO;
    var notiUrl = n.notiUrl || n.NOTI_URL || "";

    var categoryText = escapeHtml(n.notiCategory || n.NOTI_CATEGORY || "");

    var html = ""
      + '<li class="noti-row ' + stateClass + '"'
      + ' data-noti-no="' + escapeHtml(notiNo) + '"'
      + ' data-noti-url="' + escapeHtml(notiUrl) + '">'
      + '  <div class="noti-right">'
      + '    <button type="button" class="noti-item-x" aria-label="delete">×</button>'
      + '    <div class="noti-when">' + escapeHtml(whenText) + '</div>'
      + '  </div>'
      + '  <div class="noti-content">'
      + '    <div class="noti-meta">'
      +          (tagInfo.text
                   ? ('<span class="noti-tag ' + tagInfo.cls + '">' + escapeHtml(tagInfo.text) + '</span>')
                   : '')
      +          (categoryText
                   ? '<span class="noti-category"> ' + categoryText + '</span>'
                   : '')
      + '    </div>'
      + '    <div class="noti-headline">' + headline + '</div>'
      +          (preview ? ('<div class="noti-preview">"' + preview + '"</div>') : '')
      + '  </div>'
      + '</li>';

    $list.append($(html));
  });
}

function getTagInfo(n){
  var filter = mapTypeToFilter(n);

  if (filter === "TASK")     return { text: "업무", cls: "tag-task" };
  if (filter === "SCHEDULE") return { text: "일정", cls: "tag-schedule" };
  if (filter === "SYSTEM")   return { text: "시스템", cls: "tag-system" };
  if (filter === "PROJECT")  return { text: "초대", cls: "tag-project" };
  if (filter === "APPROVAL") return { text: "결재", cls: "tag-approval" };

  return { text: "", cls: "" };
}

function getHeadline(n){
	  var msg = String(n.notiMessage || n.NOTI_MESSAGE || "").trim();
	  if (!msg) return "";

	  if (msg.startsWith("[")) {
	    var closeIdx = msg.lastIndexOf("]"); // ✅ 마지막 ] 로 변경
	    if (closeIdx > 0) {
	      var name = msg.substring(1, closeIdx);
	      var rest = msg.substring(closeIdx + 1);
	      return "<strong>" + escapeHtml(name) + "</strong>" + escapeHtml(rest);
	    }
	  }
	  return escapeHtml(msg);
	}

function getPreview(n){
  if (n.snapshotText) return String(n.snapshotText);
  if (n.SNAPSHOT_TEXT) return String(n.SNAPSHOT_TEXT);
  if (n.notiBody) return String(n.notiBody);
  if (n.NOTI_BODY) return String(n.NOTI_BODY);
  if (n.previewText) return String(n.previewText);
  return "";
}

function getNotiTitle(type){
  switch (type) {
    case "NOTI_TASK_COMMENT": return "본인 업무에 댓글이 달렸습니다.";
    case "NOTI_BO_COMMENT": return "게시글에 댓글이 달렸습니다.";
    case "NOTI_MANAGER": return "새로운 업무가 배정되었습니다.";
    case "NOTI_SCHEDULE": return "일정 알림";
    case "NOTI_SITE": return "정기 점검 안내";
    case "NOTI_INQUIRY_COMMENT": return "문의 답변이 등록되었습니다.";
    case "NOTI_DRAFT_UPLOAD": return "기안이 등록되었습니다.";
    case "NOTI_APPROVAL": return "기안 승인 요청";
    case "NOTI_PROJECT_NOTICE": return "프로젝트 공지";
    case "NOTI_CHAT": return "채팅 알림";
    default: return String(type || "");
  }
}

function formatNotiTime(notiDate){
	  if (!notiDate) return "";

	  var dt = new Date(String(notiDate).replace(" ", "T"));
	  if (isNaN(dt.getTime())) return "";

	  var now = new Date();
	  var pad2 = function(n){ return String(n).padStart(2, "0"); };

	  var isToday =
	       dt.getFullYear() === now.getFullYear()
	    && dt.getMonth() === now.getMonth()
	    && dt.getDate() === now.getDate();

	  // 작년 이전이면 날짜(YYYY-MM-DD)
	  if (dt.getFullYear() < now.getFullYear()) {
	    return dt.getFullYear() + "-" + pad2(dt.getMonth() + 1) + "-" + pad2(dt.getDate());
	  }

	  // 오늘이면 시간 (✅ NBSP로 한 줄 고정)
	  if (isToday) {
	    var h = dt.getHours();
	    var ampm = (h < 12) ? "AM" : "PM";
	    var h12 = (h % 12) === 0 ? 12 : (h % 12);
	    return ampm + "\u00A0" + pad2(h12) + ":" + pad2(dt.getMinutes()); // ✅ AM 10:21
	  }

	  // 올해 다른 날이면 MM-DD
	  return pad2(dt.getMonth() + 1) + "-" + pad2(dt.getDate());
	}

function escapeHtml(s){
  return String(s == null ? "" : s)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

/* =========================================================
   ✅ X 버튼 클릭이 "행 클릭"보다 먼저 먹게 하기 (캡처링)
   - 링크 타는 현상 방지
========================================================= */
document.addEventListener("click", function(e){
  var btn = e.target.closest && e.target.closest(".noti-item-x");
  if (!btn) return;

  e.preventDefault();
  e.stopPropagation();
  if (e.stopImmediatePropagation) e.stopImmediatePropagation();

  var row = btn.closest(".noti-row");
  if (!row) return;

  var notiNo = row.getAttribute("data-noti-no");

  $.ajax({
    url: apiBaseNoti + "/delete",
    method: "POST",
    dataType: "json",
    data: { notiNo: notiNo },
    success: function(){
      $(row).remove();
      loadNotiList();
    },
    error: function(xhr){
      console.error("알림 삭제 실패", xhr.status, xhr.responseText);
    }
  });
}, true);

// ✅ 토스트 클릭 -> 드롭다운 강제 오픈 + 리로드
function openNotiPanelAndReload(){
  hideLoginToast();

  var btn = document.getElementById("headerNotiBtn");
  if (btn && window.bootstrap && bootstrap.Dropdown) {
    var dd = bootstrap.Dropdown.getOrCreateInstance(btn);
    dd.show();
  } else if (btn) {
    btn.click();
  } else {
    $("#notiPanel").addClass("show");
  }

  loadNotiList();
}

// ✅ WS 연결 (로그인일 때만)
function connectNotiWs(){
  var scheme = (location.protocol === "https:") ? "wss" : "ws";
  var url = scheme + "://" + location.host + ctxPathNoti + "/ws/noti";

  var ws = new WebSocket(url);

  ws.onopen = function(){
    console.log("noti ws opened");
  };

  ws.onmessage = function(e){
    var data;
    try {
      data = JSON.parse(e.data);
    } catch (_) {
      return;
    }

    var unread = Number(
      data.unreadCount != null ? data.unreadCount : (data.notiUnreadCount || 0)
    );

    if (data.type === "NOTI_NEW") {

      // 공통: 뱃지/카운트 동기화
      updateUnreadCountTab(unread);
      updateHeaderNotiDot(unread);

      // ✅ 패널 열려있으면 토스트는 생략하고 리스트만 갱신
      if (isNotiPanelOpen()) {
        loadNotiList();
        return;
      }

      // ✅ 패널 닫혀있으면 토스트 띄우기
      showLoginToast(unread);

      // 리스트도 최신으로
      loadNotiList();

      // lastMax 갱신(옵션)
      var savedMax = Number(localStorage.getItem(LS_KEY_LAST_MAX_NOTI) || 0);
      var newNo = Number(data.notiNo || data.NOTI_NO || 0);
      if (newNo > savedMax) localStorage.setItem(LS_KEY_LAST_MAX_NOTI, String(newNo));
    }
  };
}

$(function(){
  if (!isLoggedIn) return;

  // 패널 X
  $(document)
    .off("click", "#notiCloseBtn")
    .on("click", "#notiCloseBtn", function(){
      $("#notiPanel").removeClass("show");
    });

  // 탭(안읽음/읽음)
  $(document)
    .off("click", ".noti-tab2")
    .on("click", ".noti-tab2", function(){
      $(".noti-tab2").removeClass("active");
      $(this).addClass("active");
      notiState.tab = $(this).data("tab");
      loadNotiList();
    });

  // 필터(전체/시스템/결재/업무/일정/...)
  $(document)
    .off("click", ".noti-filter-btn")
    .on("click", ".noti-filter-btn", function(){
      $(".noti-filter-btn").removeClass("active");
      $(this).addClass("active");
      notiState.filter = $(this).data("filter");
      loadNotiList();
    });

  // 행 클릭
  $(document)
    .off("click", "#notiList .noti-row")
    .on("click", "#notiList .noti-row", function(e){
      if ($(e.target).closest(".noti-item-x").length) return;

      var $row = $(this);
      var notiNo = $row.data("noti-no");
      var url = $row.data("noti-url");

      if ($row.hasClass("is-unread")) {
        $.ajax({
          url: apiBaseNoti + "/read",
          method: "POST",
          dataType: "json",
          data: { notiNo: notiNo },
          success: function(res){
            $row.removeClass("is-unread").addClass("is-read");

            var unread = Number(
              res && (res.notiUnreadCount != null || res.unreadCount != null)
                ? (res.notiUnreadCount != null ? res.notiUnreadCount : res.unreadCount)
                : 0
            );

            updateUnreadCountTab(unread);
            updateHeaderNotiDot(unread);
          }
        });
      }

      if (url) window.location.href = url;
    });

  // 토스트 클릭
  $(document)
    .off("click", "#notiLoginToast")
    .on("click", "#notiLoginToast", function(){
      openNotiPanelAndReload();
    })
    .off("keydown", "#notiLoginToast")
    .on("keydown", "#notiLoginToast", function(e){
      if (e.key === "Enter" || e.key === " ") openNotiPanelAndReload();
    });

  // ✅ 로그인 직후 1회 동기화 + 오프라인 알림이면 토스트
  notiState.tab = "unread";
  notiState.filter = "ALL";

  $.ajax({
    url: apiBaseNoti + "/list",
    method: "GET",
    dataType: "json",
    data: { tab: "unread", filter: "ALL" },
    success: function(data){
      var list = pickList(data);
      var unread = pickUnreadCount(data);

      // ✅ 필터 보정(초기 ALL이니까 실질 영향 없음)
      list = applyClientFilter(list);

      renderNotiList(list);
      updateUnreadCountTab(unread);
      updateHeaderNotiDot(unread);

      var serverMax = getMaxNotiNo(list);
      var savedMax = Number(localStorage.getItem(LS_KEY_LAST_MAX_NOTI) || 0);

      if (unread > 0 && serverMax > savedMax) showLoginToast(unread);
      if (serverMax > 0) localStorage.setItem(LS_KEY_LAST_MAX_NOTI, String(serverMax));
    }
  });

  connectNotiWs();
});
</script>
