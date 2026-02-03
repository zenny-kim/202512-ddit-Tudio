<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/projectTabMemberList.css">
<div  id="tabMember"
	data-project-no="${projectNo}">
	
	<!-- ✅ 여기: 탭 컨텐츠 최상단 제목 -->
<div class="tudio-section-header d-flex align-items-center justify-content-between">
    <h2 class="h5 fw-bold m-0 text-primary-dark">
        <i class="bi bi-people-fill me-2"></i>구성원
    </h2>
    <div></div> 
</div>


	<!-- ===== 구성원 탭 컨텐츠 시작 ===== -->
	<section class="member-panel">

		<main class="project-main">

			<!-- 좌측 : 업무 현황 차트 -->
			<section class="main-card chart-area">
				<h3 class="card-title">진행 중인 담당 업무 현황</h3>
				<div class="chart-box">
					<!-- chart.js / echarts 들어갈 자리 -->
					<canvas id="memTaskChart"></canvas>
					<div id="noTaskMsg"
						style="display: none; text-align: center; padding: 24px 0; font-weight: 600;">
						진행중인 업무가 없습니다</div>
				</div>
			</section>


			<section class="main-card member-area">
				<h3 class="card-title">구성원 목록 (${projectMemberCount})</h3>


				<!--  검색 영역 -->
				<div class="d-flex gap-2 align-items-center mb-2">
					<select id="searchType" class="form-select form-select-sm"
						style="width: 140px;">
						<option value="memberName">이름</option>
						<option value="companyName">회사명</option>
						<option value="memberDepartment">부서</option>
					</select> <input id="searchWord" class="form-control form-control-sm"
						style="max-width: 240px;" type="text" placeholder="검색어 입력" />

					<button id="memSearchBtn" class="btn btn-sm btn-primary"
						type="button">검색</button>
				</div>
				<!--  검색 영역 -->

				<table class="member-table">
					<thead>
						<tr>
							<th>No</th>
							<th>이름</th>
							<th>구분</th>
							<th>회사명</th>
							<th>부서</th>
							<th>직급</th>
							<th>채팅</th>
						</tr>
					</thead>

					<tbody id="memTbody">
						<!-- 비동기 렌더링 -->
					</tbody>

				</table>
			</section>

		</main>

	</section>

</div>

<!-- ===== 구성원 상세 모달 (Bootstrap) ===== -->
<div class="modal fade" id="memberModal" tabindex="-1"
	aria-hidden="true">
	<div class="modal-dialog modal-lg modal-dialog-centered">
		<div class="modal-content member-modal">

			<div class="modal-header">
				<div>
					<h5 class="modal-title">구성원 상세 정보</h5>
				</div>

				<div class="d-flex align-items-center gap-2">
					

					<!-- 닫기 -->
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="닫기"></button>
				</div>
			</div>

			<div class="modal-body">
				<!-- 상단 -->
				<div class="mm-modal2">

					<!-- 상단: 프로필 + 업무현황 -->
					<div class="mm-topWrap2">
						<div class="mm-avatar4">
							<img id="mAvatarImg" alt="profile" />
						</div>

						<div class="mm-right2">
							<div class="mm-nameRow">
								<div class="mm-name4" id="mName">-</div>
								<!-- ✅ [마스킹 기능 추가] 마스킹 토글(눈 아이콘) 버튼 -->
					<button type="button" class="btn btn-sm btn-outline-secondary" id="maskToggleBtn"
						aria-label="개인정보 마스킹 해제">
						<i class="bi bi-eye"></i>
					</button>
							</div>

							<div class="mm-workCard2 mm-workAlign" id="mWorkCard">
								<div class="mm-workHead2">
									<div class="mm-workTitle2">업무 현황</div>
									<div class="mm-workHint2" id="mWorkHint" style="display: none;"></div>
								</div>

								<div class="mm-workGrid2">

									<!-- 1줄: 총업무 + 진행중 (반반) -->
									<div class="mm-workRowTop">
										<!-- 총 업무 -->
										<div class="mm-stat2 mm-total">
											<div class="mm-statTop2">
												<i class="bi bi-clipboard-check mm-ico2"></i> <span
													class="mm-statLabel2">총 업무</span>
											</div>
											<div class="mm-statNum2">
												<span id="mTotal">0</span><small>개</small>
											</div>
										</div>

										<!-- 진행중 -->
										<div class="mm-stat2">
											<div class="mm-statTop2">
												<i class="bi bi-play-circle mm-ico2"></i> <span
													class="mm-statLabel2">진행중</span>
											</div>
											<div class="mm-statNum2">
												<span id="mIng">0</span><small>개</small>
											</div>
										</div>
									</div>

									<!-- 2줄: 완료 / 지연 / 보류 (3칸) -->
									<div class="mm-workRowBottom">
										<!-- 완료 -->
										<div class="mm-stat2">
											<div class="mm-statTop2">
												<i class="bi bi-check-circle mm-ico2"></i> <span
													class="mm-statLabel2">완료</span>
											</div>
											<div class="mm-statNum2">
												<span id="mDone">0</span><small>개</small>
											</div>
										</div>

										<!-- 지연 -->
										<div class="mm-stat2">
											<div class="mm-statTop2">
												<i class="bi bi-exclamation-triangle mm-ico2"></i> <span
													class="mm-statLabel2">지연</span>
											</div>
											<div class="mm-statNum2">
												<span id="mDelay">0</span><small>개</small>
											</div>
										</div>

										<!-- 보류 -->
										<div class="mm-stat2 mm-hold">
											<div class="mm-statTop2">
												<i class="bi bi-pause-circle mm-ico2"></i> <span
													class="mm-statLabel2">보류</span>
											</div>
											<div class="mm-statNum2">
												<span id="mHold">0</span><small>개</small>
											</div>
										</div>
									</div>

								</div>
							</div>


						</div>
					</div>
				</div>

				<!-- 구분선 -->
				<div class="mm-divider2"></div>

				<!-- ✅ Info: 리스트 말고 "카드형"으로 압축 -->
				<div class="mm-infoGrid2">
					<div class="mm-infoItem2">
						<div class="k">참여일</div>
						<div class="v" id="mDate">-</div>
					</div>

					<div class="mm-infoItem2">
						<div class="k">연락처</div>
						<div class="v" id="mTel">-</div>
					</div>

					<!-- ✅ 부서/직급을 위로 -->
					<div class="mm-infoItem2">
						<div class="k">부서</div>
						<div class="v" id="mDept">-</div>
					</div>

					<div class="mm-infoItem2">
						<div class="k">직급</div>
						<div class="v" id="mPos">-</div>
					</div>

					<!-- ✅ 이메일을 아래로(길어서 span2) -->
					<div class="mm-infoItem2 mm-span2">
						<div class="k">이메일</div>
						<div class="v" id="mEmail">-</div>
					</div>
				</div>


				<div class="mm-desc" id="mProgHint" style="display: none;"></div>
			</div>

			<div class="modal-footer">
				<button type="button" class="btn btn-outline-secondary btn-sm"
					data-bs-dismiss="modal">닫기</button>
			</div>

		</div>
	</div>
</div>


<!-- 플러그인 CDN 추가. 파이조각 위에 숫자값 표시를 하려고 추가함 -->
<script src="${pageContext.request.contextPath}/js/footer.js"></script>

<script type="text/javascript">

/* =========================
   ✅ [마스킹 기능 추가] 전역 상태/유틸
   ========================= */
window.__maskState = {
  enabled: true,   // 기본: 마스킹 ON
  raw: {           // 모달에 들어온 원본값 저장
    name: null,
    email: null,
    tel: null
  }
};

function maskName(name) {
  if (!name) return "-";
  const s = String(name).trim();
  if (s.length === 1) return "*";
  if (s.length === 2) return s.charAt(0) + "*";
  // 홍길동 -> 홍*동
  return s.charAt(0) + "*".repeat(s.length - 2) + s.charAt(s.length - 1);
}

function maskEmail(email) {
  if (!email) return "-";
  const s = String(email).trim();
  const at = s.indexOf("@");
  if (at <= 0) return maskGeneric(s, 2);
  const id = s.slice(0, at);
  const domain = s.slice(at + 1);
  const maskedId = (id.length <= 2)
    ? (id.charAt(0) + "*")
    : (id.charAt(0) + "*".repeat(id.length - 2) + id.charAt(id.length - 1));
  return maskedId + "@" + domain;
}

function maskTel(tel) {
  if (!tel) return "-";
  const s = String(tel).replaceAll(" ", "").trim();
  // 010-1234-5678 / 01012345678 둘 다 대응
  const digits = s.replaceAll("-", "");
  if (digits.length < 7) return maskGeneric(s, 2);

  const midLen = digits.length === 11 ? 4 : 3; // 11자리면 4, 아니면 3
  const a = digits.slice(0, 3);
  const b = digits.slice(3, 3 + midLen);
  const c = digits.slice(3 + midLen);
  return a + "-" + "*".repeat(b.length) + "-" + c;
}

function maskGeneric(str, keepEnd) {
  const s = String(str);
  if (s.length <= keepEnd) return "*".repeat(s.length);
  return "*".repeat(s.length - keepEnd) + s.slice(-keepEnd);
}

function applyMaskToModal() {
  const enabled = window.__maskState.enabled;

  const rawName = window.__maskState.raw.name;
  const rawEmail = window.__maskState.raw.email;
  const rawTel = window.__maskState.raw.tel;

  const setText = (id, v) => {
    const el = document.getElementById(id);
    if (el) el.innerText = (v ?? "-");
  };

  setText("mName",  enabled ? maskName(rawName) : (rawName ?? "-"));
  setText("mEmail", enabled ? maskEmail(rawEmail) : (rawEmail ?? "-"));
  setText("mTel",   enabled ? maskTel(rawTel) : (rawTel ?? "-"));

  // 아이콘 토글 (eye / eye-slash)
  const btn = document.getElementById("maskToggleBtn");
  if (btn) {
    btn.setAttribute("aria-label", enabled ? "개인정보 마스킹 해제" : "개인정보 마스킹 적용");
    btn.innerHTML = enabled ? '<i class="bi bi-eye"></i>' : '<i class="bi bi-eye-slash"></i>';
  }
}

// ✅ [마스킹 기능 추가] 버튼 클릭 시 토글
document.getElementById("maskToggleBtn").addEventListener("click", function() {
  window.__maskState.enabled = !window.__maskState.enabled;
  applyMaskToModal();
});


/* =========================
   기존 코드
   ========================= */

//모달 이벤트 리스너
document.getElementById('memberModal').addEventListener('show.bs.modal', async (event) => {
	const target = event.relatedTarget || window.__memberModalTarget;

  // ✅ 수정 1) td.member-name -> tr.member-row
  const row = target.closest(".member-row");
  if (!row) return;

  // ✅ 수정 2) dataset도 tr에서 꺼냄
  const memberNo = row.dataset.memberNo;

  const url = "/tudio/project/member/memberModal?projectNo=" + encodeURIComponent(projectNo)
            + "&memberNo=" + encodeURIComponent(memberNo);

  try {
    const res = await fetch(url);
    if (!res.ok) {
      console.error("memberModal 응답 실패:", res.status, url);
      return;
    }
    const data = await res.json();

    // 안전하게 넣기 (존재하는 엘리먼트만)
    const setText = (id, v) => {
      const el = document.getElementById(id);
      if (el) el.innerText = (v ?? "-");
    };

    /* ✅ [마스킹 기능 추가]
       모달 열릴 때는 기본 마스킹 ON 상태로 시작
       원본값 저장 후 applyMaskToModal()로 표시
    */
    window.__maskState.enabled = true;
    window.__maskState.raw.name = data.memberName ?? null;
    window.__maskState.raw.email = data.memberEmail ?? null;
    window.__maskState.raw.tel = data.memberTel ?? null;

    // 개인정보는 applyMaskToModal에서 표시함
    // setText("mName",  data.memberName);
    // setText("mEmail", data.memberEmail);
    // setText("mTel",   data.memberTel);
    applyMaskToModal();

    // 나머지는 그대로 세팅
    setText("mDate",  data.projectMemregdate);

    setText("mDept",  data.memberDepartment ?? data.companyName);
    setText("mPos",   data.memberPosition);

    setText("mTotal", data.totalTaskCnt);
    setText("mIng",   data.ingCnt);
    setText("mDone",  data.doneCnt);
    setText("mDelay", data.delayCnt);
    setText("mHold",  data.holdCnt);
    
    const workCard = document.getElementById("mWorkCard");
    if (workCard) {
      const isClient =
        data.projectRole === "CLIENT" ||
        data.projectRole === "ROLE_CLIENT";

      workCard.style.display = isClient ? "none" : "";
    }

    const img = document.getElementById("mAvatarImg");
    if (img) img.src = data.memberProfileImg ? data.memberProfileImg : "/images/default_profile.png";

  } catch (err) {
    console.error("모달 데이터 로드 실패:", err);
  }
});

//2. 차트 데이터를 불러오고 그리는 비동기 함수
async function loadMemberChart() {
	
	var canvasEl = document.getElementById("memTaskChart"); // 존재여부 체크, 화면 숨김 제어
	var noTaskMsg = document.getElementById("noTaskMsg");

    var canvas = document.querySelector("#memTaskChart"); // 렌더링 대상

    
    try {
    	const response = await fetch("/tudio/project/member/memberChart?projectNo=" + encodeURIComponent(projectNo));

        if (!response.ok) {
            throw new Error(`서버 통신 오류: ${response.status}`);
        }

        const data = await response.json();

        // data 안전 처리
        const safeData = Array.isArray(data) ? data : [];

        // 담당업무 0개 제외 (여기가 핵심) 배열에서 조건을 만족하는 요소를 남김. 배열순회
		const filteredData = safeData.filter(item => {
	    const role = String(item.projectRole ?? "").trim().toUpperCase();
	    return role !== "CLIENT" && role !== "ROLE_CLIENT";
	    });


       // ✅ 총 업무수(totalTaskCnt) 기준 내림차순 정렬
		filteredData.sort((a, b) => (b.totalTaskCnt ?? 0) - (a.totalTaskCnt ?? 0));
        
        console.log("filteredData : ",filteredData);

        // 전부 0개면 차트 영역 숨김 + 기존 차트 제거 후 종료
        if (filteredData.length === 0) {
		  if (window.memChartInstance) {
		    window.memChartInstance.destroy();
		    window.memChartInstance = undefined;
		  }
		  canvasEl.style.display = "none";
		  noTaskMsg.style.display = "block";
		  return;
		} else {
		  noTaskMsg.style.display = "none";
		  canvasEl.style.display = "block";
		}

        // 데이터 가공. 새 배열 생성. memberName와 totalWorkCnt뽑아서
        var labels = filteredData.map(item => item.memberName); 
        
        var totalTaskCnt  = filteredData.map(item => item.totalTaskCnt ?? 0);  // 총 업무
        var ingCnt  = filteredData.map(item => item.ingCnt ?? 0);  // 진행중
        var doneCnt = filteredData.map(item => item.doneCnt ?? 0); // 완료
        var delayCnt = filteredData.map(item => item.delayCnt ?? 0); // 지연
        var holdCnt = filteredData.map(item => item.holdCnt ?? 0); // 보류

        var palette = ['#4e79a7', '#f28e2b', '#bab0ab', '#edc949', '#76b7b2', '#59a14f', '#2f4b7c', '#e15759', '#79706e', '#ff9da7'];
        var bgColors = filteredData.map((_, i) => palette[i % palette.length]);

        // 기존 차트 파괴 (중복 방지)
        if (window.memChartInstance != undefined) {
            window.memChartInstance.destroy();
        }

        // 차트 생성
        window.memChartInstance = new Chart(canvas, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [
                	{
                    	label: '총업무',
                        data: totalTaskCnt,
                        backgroundColor: '#1E3A8A',
                        categoryPercentage: 0.6,
                        barPercentage: 0.8 ,
                        barThickness: 8
                    },
                   {
                	label: '진행중',
                    data: ingCnt,
                    backgroundColor: '#3498db', 
                    categoryPercentage: 0.6,
                    barPercentage: 0.8 ,
                    barThickness: 8
                },
                {
                	label: '완료',
                    data: doneCnt,
                    categoryPercentage: 0.6,
                    barPercentage: 0.8,
                    barThickness: 8,
                    backgroundColor: '#2ecc71'
                },
                {
                	label: '지연',
                    data: delayCnt,
                    categoryPercentage: 0.6,
                    barPercentage: 0.8,
                    barThickness: 8,
                    backgroundColor: '#e74c3c'
                },
                {
                	label: '보류',
                    data: holdCnt,
                    categoryPercentage: 0.6,
                    barPercentage: 0.8,
                    barThickness: 8,
                    backgroundColor: '#777777'
                },
                ]
            },
            options: {
            	 layout: { padding: { right: 24 } },
            	indexAxis:'y',
                responsive: true,
                maintainAspectRatio: false,
                scales:{
                	x:{
                		beginAtZero:true,
                		grace: '10%',
                		ticks:{precision:1}
                	}
                },
                plugins: {
                    legend: { position: 'top' },
                    datalabels: {
                    	 anchor: 'end',
                    	 align: 'end',
                    	 offset: 4,
                    	 clip: false,
                    	 clamp: true,
                         font: { weight: '700', size: 11 },
                  	     formatter: (v) => {
                  	    	 if(!v || v===0)return null;
                  	    	 return v;
                  	     }
                    }
                }
            },
            plugins: [ChartDataLabels]
        });

    } catch (error) {
        console.error("차트 로딩 실패:", error);
    }
}

var memState = {
  searchType: "memberName",
  searchWord: ""
};
var memTbody = document.getElementById("memTbody");
var searchTypeEl = document.getElementById("searchType");
var searchWordEl = document.getElementById("searchWord");
var memSearchBtn = document.getElementById("memSearchBtn");


//✅ 행 클릭 시 모달 열기 (채팅 버튼 제외)
memTbody.addEventListener("click", function(e){

  const row = e.target.closest("tr.member-row");
  if (!row) return;

  // 채팅 버튼 누르면 모달 안 뜸
  if (e.target.closest(".btn-outline-secondary")) return;

  const modalEl = document.getElementById("memberModal");
  const modal = bootstrap.Modal.getOrCreateInstance(modalEl);

  // show.bs.modal에서 쓸 대상 저장
  window.__memberModalTarget = row;

  modal.show();
});


// [KJS] 채팅 버튼 클릭 여부 판단 후, 1대1 채팅방 열기 
memTbody.addEventListener("click", function(e) {
    const btn = e.target.closest(".btn-outline-secondary");
    if (!btn) return;
    
    // 추가: 행(tr)로 이벤트 올라가는거 막아서 모달 안 뜨게
    e.preventDefault();
    e.stopPropagation();
    
	const row = btn.closest("tr");
    const memberNameTd = row.querySelector(".member-name");
    const memberNo = memberNameTd.dataset.memberNo;
    const memberName = memberNameTd.innerText;

    if(${sessionScope.loginUser.memberNo} == memberNo){
    	Swal.fire({
    		title: "자신과의 대화는 불가능합니다.",
    		confirmButtonText: '확인',
    		icon: "error",
    		
    		buttonStyling: false,
    		customClass:{
    			title:'my-swal-title ',
    			confirmButton: 'my-confirm-btn'
    		}
    	},true)
    	
    	return;
    }
    
    const chatBtn = document.querySelector(".floating-chat-btn");
    
	if(!isOpen){
		chatBtn.click();
	}
	
	const chatroomVo = {
		chatroomName : memberName,
   		chatroomType : "PRIVATE",
   		memCount : 2,
   		chatMemberNoList : [Number(memberNo)],
   		chatMemberNameList : [memberName]
	}
    
    fetch("/tudio/chat/new", {
    	method: "POST",
    	headers: {
    		"Content-Type": "application/json"
    	},
    	body: JSON.stringify(chatroomVo)
    })
    	.then((response) => response.json())
    	.then((data) => {
    		if(data.result === "OK"){
    			$container.load("/tudio/chat/chatroom/" + data.chatroomNo, function(){
	                feather.replace();
	            });
    		}
    	})
})

function escapeHtml(str) {
  if (str === null || str === undefined) return "";
  return String(str)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

function renderMemberList(list) {
	  if (!Array.isArray(list) || list.length === 0) {
	    memTbody.innerHTML = `
	      <tr>
	        <td colspan="7" style="text-align:center; padding:18px 0; color:#888;">
	          검색 결과가 없습니다.
	        </td>
	      </tr>
	    `;
	    return;
	  }

	  memTbody.innerHTML = list.map((l, idx) => {
		  const roleBadge =
			  (l.projectRole === "MANAGER") ? "<strong>PM</strong>" :
			  (l.projectRole === "CLIENT" || l.projectRole === "ROLE_CLIENT") ? "<strong>기업관리자</strong>" :
			  "팀원";

	    return `
	      <!-- ✅ 수정: tr 전체를 모달 트리거로 -->
	    <tr class="member-row"
	    style="cursor:pointer;"
	    data-member-no="\${escapeHtml(l.memberNo)}">

	        <td>\${idx + 1}</td>

	        <td class="member-name"
	            data-member-no="\${escapeHtml(l.memberNo)}">
	          \${escapeHtml(l.memberName)}
	        </td>

	        <td>\${roleBadge}</td>

	        <td>\${escapeHtml(l.companyName || "")}</td>
	        <td>\${escapeHtml(l.memberDepartment || "")}</td>
	        <td>\${escapeHtml(l.memberPosition || "")}</td>

	        <td>
	          <button class="btn btn-sm btn-outline-secondary" type="button">
	            <i class="bi bi-chat-square-text"></i>
	          </button>
	        </td>
	      </tr>
	    `;
	  }).join("");
	}


async function loadMemberList() {
  const params = new URLSearchParams();
  params.set("projectNo", projectNo);

  if (memState.searchWord && memState.searchWord.trim().length > 0) {
    params.set("searchType", memState.searchType);
    params.set("searchWord", memState.searchWord.trim());
  }
  console.log(params.toString());

  const url = "/tudio/project/member/listData?" + params.toString();

  try {
    const res = await fetch(url, { headers: { "Accept": "application/json" } });
    if (!res.ok) {
    	const text = await response.text(); // 서버 에러 페이지/ 메세지 보기
      console.error("구성원 목록 응답 실패:", res.status, url, text);
      return;
    }

    const data = await res.json();
    const list = Array.isArray(data) ? data : (data.listData || []);
    console.log(list);
    renderMemberList(list);

  } catch (e) {
    console.error("구성원 목록 로드 실패:", e);
  }
}

// 검색 버튼
memSearchBtn.addEventListener("click", () => {
	console.log("검색 버튼 클릭...!");
	console.log(searchTypeEl.value);
	console.log(searchWordEl.value);
  memState.searchType = searchTypeEl.value;
  memState.searchWord = searchWordEl.value || "";
  loadMemberList();
});

// 엔터 검색
searchWordEl.addEventListener("keydown", (e) => {
  if (e.key === "Enter") {
    memState.searchType = searchTypeEl.value;
    memState.searchWord = searchWordEl.value || "";
    loadMemberList();
  }
});

	// 최초 로드
	loadMemberList();
	// 3. 페이지 로드 시 차트 함수 실행
	loadMemberChart();

</script>
