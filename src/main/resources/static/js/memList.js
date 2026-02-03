/**
 * memList.js
 * 초대 가능한 멤버 목록 조회 및 선택 로직
 */
 window.MemberSelectList = {
    
    // 상태 관리 변수들
    state: {
        checkedCount: 0,
        selectedUserNo: [],      
        selectedAllUserName: [], 
        chatroomName: []         
    },
    
    // DOM 요소
    $container: null,    // 전체 컨테이너
    $startBtn: null,     
    $track: null,        // 상단 선택된 멤버 영역 내부 트랙
    $area: null,         // 상단 선택된 멤버 영역 (숨김/표시용)
    
    contextPath: "",
	btnText: "",
	callbackFn: null,

    // [초기화 함수] JSP에서 init 호출시 시작됨
    init: function(contextPath, btnText, callbackFn, container) {
        this.contextPath = contextPath; // 경로 저장
		this.btnText = btnText; 
		this.callbackFn = callbackFn;
        
        this.$container = $(container);
        this.$startBtn = $(".start-chat-btn");
        this.$track = $("#selectedUsersTrack");
        this.$area = $("#selectedUsersArea");

		this.resetState();

        this.bindEvents(); // 이벤트 연결
    },
	
	// 상태값 리셋 함수
    resetState: function() {
		// 선택된 항목 싹다 지워주기
		this.$container.find(".user-checkbox")
					   .prop("checked", false).trigger("change");
					   
        this.state.checkedCount = 0;
        this.state.selectedUserNo = [];
        this.state.selectedAllUserName = [];
        this.state.chatroomName = [];
    },
		
    // [이벤트 연결] 모든 클릭/변경 이벤트 관리
    bindEvents: function() {
        const self = this;

        // 멤버 리스트 아이템 클릭 (체크박스 토글)
        this.$container.off("click").on("click", ".user-item", function(e) {
            if (!$(e.target).is("input[type='checkbox']")) {
                const $chk = $(this).find(".user-checkbox");
                $chk.prop("checked", !$chk.prop("checked")).trigger("change");
            }
        });

        // 체크박스 변경 감지 
        this.$container.off("change").on("change", ".user-checkbox", function() {
            // 여기서 this는 체크박스 태그, self는 객체
            self.handleCheckboxChange($(this));
        });

        // 상단 선택된 태그 삭제(X) 버튼 클릭
        this.$track.off("click").on("click", ".tag-remove-btn", function() {
            const memberNo = $(this).data("no");
            // 해당 체크박스 찾아서 해제 -> change 이벤트 트리거
            $(`#user${memberNo}`).prop("checked", false).trigger("change");
        });

        // 채팅 시작 버튼 클릭
        this.$startBtn.off("click").on("click", function() {
			if(self.btnText == " 초대"){
				self.handleInviteMem();	
			}else{
	            self.handleStartChat();
			}
        });

        // 뒤로가기 버튼 클릭
        $("#backBtn").off("click").on("click", function() {
            // (참고) container가 전역변수라면 사용 가능, 아니면 파라미터로 받아야 함
            // 여기선 예시로 id가 main-content라고 가정
           $container.load(self.contextPath + "/tudio/chat/list", function(){
                if(typeof feather !== 'undefined') feather.replace();
            });
        });
    },

    // [비즈니스 로직] 복잡한 계산 관리
    handleCheckboxChange: function($target) {
        const memberNo = $target.val();
        const $userItem = $target.closest(".user-item");
        const memberName = $userItem.find(".user-name").text(); 
        const userInfoWrapper = $userItem.find(".user-info-wrapper");
        const isChecked = $target.prop("checked");

        if (isChecked) {
            // [멤버 추가 로직]
            this.state.checkedCount++;
            // 상단 태그 추가
            const html = this.createSelectedUserHtml(memberNo, memberName, userInfoWrapper);
            this.$track.append(html);
            
            // 영역 보이기
            if (this.state.checkedCount === 1) this.$area.slideDown(200);
            
            // 스크롤 이동
            setTimeout(() => {
                this.$track.scrollTop(this.$track[0].scrollHeight);
            }, 10);

        } else {
            // [멤버 삭제 로직]
            this.state.checkedCount--;
            const $tag = $(`#user-tag-${memberNo}`);
            $tag.addClass("removing");
            
            setTimeout(() => {
                $tag.remove();
                if (this.state.checkedCount === 0) this.$area.slideUp(200);
            }, 50);
        }

        this.updateButtonUI(); // 버튼 상태 갱신
        if(typeof feather !== 'undefined') feather.replace();
    },

    updateButtonUI: function() {
        if (this.state.checkedCount > 0) {
            this.$startBtn.prop("disabled", false).addClass("active");
            this.$startBtn.text(this.state.checkedCount + "명" + this.btnText);
        } else {
            this.$startBtn.prop("disabled", true).removeClass("active");
            this.$startBtn.text(this.btnText);
        }
    },

    createSelectedUserHtml: function(memberNo, memberName, $wrapper) {
        let imgHtml = "";
        if ($wrapper.find(".profile-img").length <= 0) {
            imgHtml = `
                <div class="tag-default-avatar avatar-color-${memberNo % 5}">
                    <i data-feather="user"></i>
                </div>`;
        } else {
            let src = $wrapper.find(".profile-img").attr("src");
            // 이미 src에 contextPath가 포함되어 있다면 중복 방지 필요할 수 있음
            imgHtml = `<img src="${src}" class="tag-profile-img" alt="${memberName}">`;
        }

        return `
            <div class="selected-user-tag" id="user-tag-${memberNo}">
                <input type="hidden" value="${memberNo}"/>
                ${imgHtml}
                <span class="tag-user-name">${memberName}</span>
                <button type="button" class="tag-remove-btn" data-no="${memberNo}">
                    <i data-feather="x"></i>
                </button>
            </div>
        `;
    },

    handleStartChat: function() {
        //state 초기화 후 다시 담기
        this.state.selectedUserNo = [];
        this.state.chatroomName = [];
        this.state.selectedAllUserName = [];

        const self = this;
        $(".user-checkbox:checked").each(function(index) {
            const no = $(this).val();
            const name = $(this).closest(".user-item").find(".user-name").text();
            
            self.state.selectedUserNo.push(no);
            self.state.selectedAllUserName.push(name);
            
            if (index < 3) self.state.chatroomName.push(name);
        });

        if (this.state.selectedAllUserName.length > 3) {
            this.state.chatroomName.push("...");
        }

		if(this.state.checkedCount > 1){ // 단체 채팅일 경우 
			if(this.callbackFn){
				this.callbackFn(this.state);
			}
		}else{ // 1대1 채팅일 경우
			let chatroomType = "";
			
	    	if(this.state.checkedCount > 1){
	    		chatroomType = "GROUP"
	    	}else{
	    		chatroomType = "PRIVATE"
	    	}
			
			const chatroomVo = {
				chatroomName : this.state.chatroomName[0],
				chatroomType : chatroomType,
				memCount : (this.state.checkedCount + 1),
				chatMemberNoList : this.state.selectedUserNo,
				chatMemberNameList : this.state.selectedAllUserName
			};
			
			return $.ajax({
				url: "/tudio/chat/new",
				type: "post", 
				contentType: "application/json;charset=utf-8",
				data: JSON.stringify(chatroomVo),
				success: function(result){
					console.log(result);
					$container.load("/tudio/chat/chatroom/" + result.chatroomNo, function(){
		                feather.replace();
		            });
				},
				error: function(error, status, thrown){
					console.log(error);
					console.log(status);
					console.log(thrown);
				}
			})  
		}
		
    },
	
	handleInviteMem: function(){
		this.state.selectedUserNo = [];
        this.state.selectedAllUserName = [];
				
		const self = this;
		$(".user-checkbox:checked").each(function(index) {
		    const no = $(this).val();
		    const name = $(this).closest(".user-item").find(".user-name").text();
		    
		    self.state.selectedUserNo.push(no);
		    self.state.selectedAllUserName.push(name);
		});
				
		if(this.callbackFn){
			this.callbackFn(this.state);
		}
	}
};