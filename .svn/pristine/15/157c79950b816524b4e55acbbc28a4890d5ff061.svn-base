(function () {
	let contextPath;
	let projectNo;
	let $content;
	
	$(document).on('tab:loaded', function (e, tabName) {
		if (tabName !== 'task') return;
		initTaskTab();
	});
	
	function initTaskTab(){
		contextPath = $('body').data('contextPath');
		projectNo = $('body').data('projectNo');
		$content = $('#projectTabContent');
		
		// 에러 메시지 처리 (세션 스토리지 활용하여 중복 알림 방지)
		showFlashError();
		
		// 리스트 아코디언 이벤트 (중복 방지 off 후 on)
		bindAccordion();
		// 전체 토글 (펼치기/접기) 이벤트
		bindToggleAll();		
		
		// 리스트 <-> 칸반 전환
		bindViewToggle();		
		// 정렬 이벤트 바인딩
		bindSortEvents();
		
		// 모달 관련 이벤트 바인딩
		bindCreateModal();		// 상위업무 생성
		bindSubCreateModal();	// 하위업무 생성	
		bindDetailModal();		// 업무 상세조회
		
		// 상세 모달 내부 수정/삭제 버튼 이벤트
		bindDetailActions();	
		
		// 고정 기능
		if(!window.setPin){
			window.setPin = function(id, type, event) {
			    event.stopPropagation(); // 상세/토글 등 다른 이벤트 방지
			    
			    $.ajax({
			        url: `${contextPath}/tudio/project/task/setPin`,
			        type: 'POST',
			        data: { id: id, type: type },
			        success: function(res) {
			            if (res === 'SUCCESS') {
			                // 정렬 순서가 바뀌므로 탭 리로드
			                if (typeof loadTab === 'function') loadTab('task');
			            } else if (res === 'LOGIN_REQUIRED') {
			                alert('로그인이 필요합니다.');
			            } else {
			                alert('처리 실패');
			            }
			        },
			        error: function() {
			            alert('서버 통신 오류');
			        }
			    });
			}
		}
	}
	
	function showFlashError() {
		const $msg = $content.find('#taskErrorMsg');
		if ($msg.length === 0) return;

		const text = String($msg.data('errorMsg') || '').trim();
		if (!text) return;

		// 같은 메시지 중복 방지(탭 다시 눌러도 계속 뜨는 거 방지)
		const key = `task:error:${projectNo}`;
		if (sessionStorage.getItem(key) === text) return;
		sessionStorage.setItem(key, text);

		if (window.Swal) {
			Swal.fire({
				icon: 'error',
				title: '등록 실패',
				text: text,
				confirmButtonText: '확인'
			});
		} else {
			alert(text); // Swal 없으면 보험
		}

		// DOM에서 제거해서 같은 탭 컨텐츠 내 재호출 방지
		$msg.remove();
	}
	
	function bindAccordion(){
		$content
				.off('click.taskAccordion')
				.on('click.taskAccordion', '.toggle-btn', function(e){
					e.stopPropagation(); // 상위 tr 클릭 이벤트(상세 조회) 방지
					
					const $btn = $(this);
					const $taskRow = $btn.closest('.task-row');
					const taskId = $taskRow.data('taskId');
					
					const $subs = $content.find(
						`.sub-row[data-parent-task-id="${taskId}"], .sub-add-row[data-parent-task-id="${taskId}"]`
					);
					
					const $icon = $taskRow.find('.toggle-icon');
					const isOpen = $subs.first().is(':visible');
					
					$subs.css('display', isOpen ? 'none' : 'table-row');
					
					$icon
						.toggleClass('bi-caret-right-fill', isOpen)
						.toggleClass('bi-caret-down-fill', !isOpen);
				});
	}
	
	// [추가] 모두 펼치기/접기 기능
	function bindToggleAll() {
		const $checkbox = $('#toggleAllCheckbox');
		
		const syncState = () => {
			const $chk = $('#toggleAllCheckbox');
			if ($chk.length === 0) return; // 요소가 없으면 종료
			const isChecked = $chk.is(':checked');
			
            const $label = $checkbox.next('label');
            const $allSubs = $content.find('.sub-row, .sub-add-row');
            const $allIcons = $content.find('.toggle-icon');

            if (isChecked) {
                // 펼치기 상태 강제 적용
                $allSubs.css('display', 'table-row');
                $allIcons.removeClass('bi-caret-right-fill').addClass('bi-caret-down-fill');
                $label.text('업무 펼치기'); // 텍스트 변경
            } else {
                // 접기 상태 강제 적용
                $allSubs.css('display', 'none');
                $allIcons.removeClass('bi-caret-down-fill').addClass('bi-caret-right-fill');
                $label.text('업무 펼치기');
            }
        };
		
		$content.off('change.toggleAll')
			.on('change', '#toggleAllCheckbox', function() {
				syncState();
		});
		
		if ($checkbox.length > 0) {
            //syncState($checkbox.is(':checked'));
			//setTimeout(syncState(), 0);
			syncState();
        }
	}
	
	// 전환 이벤트만 따로 함수로 빼기
    function bindViewToggle() {
		// 중복 방지를 위해 기존 이벤트 제거
        $(document).off('click.toggleView', '#toggleViewButton');
        $(document).off('click.listView', '#btnListView');

        // 1) 리스트 -> 칸반보드
        $(document).on('click.toggleView', '#toggleViewButton', function() {
            const url = `${contextPath}/tudio/project/task/kanban?projectNo=${projectNo}`;
            console.log("[뷰 전환] 칸반보드로 로드:", url);
            
            $content.load(url, function(res, status, xhr) {
                if (status === "error") {
                    Swal.fire('오류', '칸반보드 로딩 실패', 'error');
                }
            });
        });

        // 2) 칸반 -> 리스트로 돌아오기
        $(document).on('click.listView', '#btnListView', function() {
            console.log("[뷰 전환] 리스트형 보기 클릭");
			const url = `${contextPath}/tudio/project/task/list?projectNo=${projectNo}`;
			
			$content.load(url, function(res, status, xhr) {
	        	if (status === "error") {
	        		Swal.fire('오류', '리스트 로딩 실패', 'error');
	        	}
	        });
        });
    }
	
	// [추가] 정렬 이벤트 처리 함수
    function bindSortEvents() {
        $content.off('click.sortTask').on('click.sortTask', '.sort-btn', function() {
            const $btn = $(this);
            const selectedType = $btn.data('sortType'); // 클릭한 정렬 기준 (REGDATE, ENDDATE, PRIORITY)
            const defaultOrder = $btn.data('defaultOrder'); // 해당 기준의 기본 정렬 방향
            
            // 현재 상태 가져오기 (JSP 히든 태그값)
            const currentType = $('#currentSortType').val();
            const currentOrder = $('#currentSortOrder').val();
            
            let newOrder = defaultOrder; // 일단 기본 방향으로 설정

            // 1. 같은 버튼을 또 눌렀다면? -> 방향 토글 (ASC <-> DESC)
            if (selectedType === currentType) {
                newOrder = (currentOrder === 'ASC') ? 'DESC' : 'ASC';
            } 
            // 2. 다른 버튼을 눌렀다면? -> 해당 버튼의 기본 방향(defaultOrder) 사용 (이미 위에서 할당됨)

            console.log(`[정렬 요청] Type: ${selectedType}, Order: ${newOrder}`);
            
            // 목록 리로드 (정렬 파라미터 포함)
            reloadTaskList(selectedType, newOrder);
        });
    }

    // [추가] 목록 영역만 새로고침 (페이지 전체 새로고침 방지)
    function reloadTaskList(sortType, sortOrder) {
        // 기존의 검색어도 유지하고 싶다면 여기서 검색어 input 값도 가져와야 함
        // const keyword = $('.tudio-search input').val();
        
        const url = `${contextPath}/tudio/project/task/list`;
        const params = {
            projectNo: projectNo,
            sortType: sortType,
            sortOrder: sortOrder
            // searchKeyword: keyword 
        };

        // load() 메서드는 GET 방식 파라미터를 쿼리스트링으로 변환하여 호출
        // 주의: #listView만 교체하는 게 아니라 탭 컨텐츠 전체를 교체해야 
        // 상단 버튼 상태(active 클래스 등)가 서버 렌더링 결과로 갱신됨.
        // 만약 부분 갱신을 원하면 AJAX로 데이터만 받아와서 DOM 조작을 해야 하지만,
        // 여기서는 JSP 구조상 load로 전체 탭 내용을 갈아끼우는 방식을 사용 (기존 구조 준수)
        
        $content.load(url + '?' + $.param(params), function(res, status, xhr) {
            if (status === "error") {
                alert("목록을 불러오는데 실패했습니다.");
            } else {
				initTaskTab();
			}
        });
    }
	
	/**
	 * <p>공용 모달 로드 함수 (지연 오버레이 적용 - 깜빡임 완벽 제거)</p>
	 * @param {String} url : 불러올 JSP 경로
	 * @param {String} size : 모달 사이즈 클래스명
	 * @param {Function} callback : 로드 완료 후 실행할 함수  
	 */
	function loadModal(url, size, callback){
		const $modalEl = document.getElementById('projectCommonModal');
		const $dialog = $('#projectCommonModalDialog');
		const $content = $('#projectCommonModalContent');
		
		// 1. 현재 모달이 열려있는지 확인
        const isAlreadyOpen = $modalEl.classList.contains('show');
        let overlayTimer = null; // 타이머 변수
        
        // 2. 상태별 로딩 처리
        if (!isAlreadyOpen) {
            // [케이스 A] 처음 열 때: 이건 어쩔 수 없이 스피너 보여줌 (내용이 없으니까)
            $content.html('<div class="text-center py-5"><div class="spinner-border text-primary"></div></div>');
            $dialog.removeClass('modal-lg modal-xl modal-sm').addClass(size || '');
            
            const modalInstance = bootstrap.Modal.getOrCreateInstance($modalEl);
            modalInstance.show();
        } else {
            // [케이스 B] 이미 열려있을 때: "지연 오버레이" 전략
            // 바로 로딩바를 띄우지 않고 150ms 기다림. 
            // 그 안에 데이터가 오면 로딩바 없이 교체 (깜빡임 0)
            overlayTimer = setTimeout(() => {
                $content.css('position', 'relative');
                $content.append(`
                    <div id="modal-temp-overlay" style="
                        position: absolute; top: 0; left: 0; width: 100%; height: 100%;
                        background-color: rgba(255, 255, 255, 0.8); 
                        z-index: 1000; display: flex; justify-content: center; align-items: center;
                        border-radius: 0.3rem; opacity: 0; transition: opacity 0.2s;">
                        <div class="spinner-border text-primary" role="status"></div>
                    </div>
                `);
                // 약간의 시간차를 두고 페이드인 (부드럽게 등장)
                setTimeout(() => $('#modal-temp-overlay').css('opacity', '1'), 10);
            }, 150); 
        }

		// 3. AJAX 데이터 요청
        $.ajax({
            url: url,
            type: 'GET',
            success: function(htmlData) {
                // 데이터 도착!
                
                // 타이머가 돌고 있다면 취소 (150ms 안에 도착했으면 로딩바 아예 안 뜸)
                if (overlayTimer) clearTimeout(overlayTimer);
                
                // 4. 모달 사이즈 교체
                $dialog.removeClass('modal-lg modal-xl modal-sm').addClass(size || ''); 
                
                // 5. 내용 교체 
                // html() 함수가 기존 내용(오버레이 포함)을 싹 지우고 새 내용을 넣음 -> 즉시 전환
                $content.html(htmlData);
                
                // 스타일 초기화
                $content.css('position', ''); 
                
                // 콜백 실행
                if (callback) callback();
            },
            error: function() {
                if (overlayTimer) clearTimeout(overlayTimer);
                $content.html('<div class="p-4 text-center text-danger">컨텐츠를 불러오지 못했습니다.</div>');
            }
        });
	}
	
	// [헬퍼 함수 추가] 모달 닫기 및 탭 리로드 (중복 코드 제거용)
    function reloadTaskTab() {
        // 모달 닫기 (Bootstrap 인스턴스)
        const modalEl = document.getElementById('projectCommonModal');
        const modal = bootstrap.Modal.getInstance(modalEl);
        if (modal) {
            modal.hide();
        }
        
        // 회색 배경(Backdrop) 강제 제거 및 스크롤 복구(부트스트랩 찌꺼기 청소)
        $('.modal-backdrop').remove(); 
        $('body').removeClass('modal-open')
				.css('overflow', 'auto')
				.css('padding-right', '');
				
		// body에 aria-hidden이 남는 경우 제거 (접근성 경고 방지)
		$('body').removeAttr('aria-hidden');

        // 탭 리로드 (전역 함수 호출)
        if (typeof window.loadTab === 'function') {
            window.loadTab('task');
        } else {
            console.error("loadTab 함수를 찾을 수 없습니다.");
            location.reload(); // 최후의 수단
        }
    }
	
	/**
	 * 업무 생성 모달
	 */
	function bindCreateModal(){
		$content.off('click.taskCreate')
				.on('click.taskCreate', '#createTaskBtn', function(){
					
					const url = `${contextPath}/tudio/project/task/create?projectNo=${projectNo}`;
					
					loadModal(url, 'modal-lg', function(){
						if(typeof initTaskCreateUI === 'function'){
							initTaskCreateUI($('#projectCommonModalContent'));	
						}
					});
		});
	}
	
	/**
	 * 업무 상세 모달
	 */
	function bindDetailModal(){
		// 상위 업무 클릭
		$content.off('click.openDetail')
			.on('click.openDetail', '.task-row', function(e) {
				// 토글 버튼이나 하위 추가 버튼 클릭 시에는 상세 모달 이벤트 무시
				if ($(e.target).closest('.toggle-btn, .add-sub-btn').length > 0) {
					return;
				}

				const id = $(this).data('taskId');
				console.log(`[Debug] Open Task Detail ID: ${id}`);
				openDetailModal(id, 'T');
			});

		// 하위 업무 클릭
		$content.off('click.openSubDetail')
			.on('click.openSubDetail', '.sub-row', function(e) {
				const id = $(this).data('subId');
				console.log(`[Debug] Open SubTask Detail ID: ${id}`);
				openDetailModal(id, 'S');
			});
	}
	
	// 상세 모달 호출 공통 함수
	function openDetailModal(id, type) {
		const viewUrl = `${contextPath}/tudio/project/task/view/detail`;
		loadModal(viewUrl, 'modal-lg', function() {
			fetchAndFillDetail(id, type);
		});
	}
	
	/**
	 * 하위 업무 추가 모달
	 */
	function bindSubCreateModal() {
		$content.off('click.addSub')
				.on('click.addSub', '.sub-add-row', function(e) {
			e.stopPropagation();
			const parentTaskId = $(this).data('parentTaskId');

			console.log("[Debug] Add SubTask for Parent ID:", parentTaskId);

			if (!parentTaskId) {
				alert("상위 업무 ID를 찾을 수 없습니다.");
				return;
			}
			
			const viewUrl = `${contextPath}/tudio/project/task/view/sub/create?projectNo=${projectNo}`;
			
			loadModal(viewUrl, 'modal-lg', function() {
				// 상위ID 주입
				$('#targetParentTaskId').val(parentTaskId); 

				// UI 초기화 및 상위업무 데이터 가져오기
				initSubCreateUI(parentTaskId);
				
				// 등록 버튼 이벤트 바인딩
				$('#btnSubmitSubTask').on('click', submitSubTask);
			});
		});
	}
	
	function initSubCreateUI(parentTaskId){
		const $root = $('#projectCommonModalContent');
		
		// 상위업무 날짜데이터 가져오기
		$.ajax({
			url: `${contextPath}/tudio/project/task/detail/${parentTaskId}`,
			type: 'GET',
			dataType: 'json',
			success: function(data){
				const sDate = data.taskStartdate ? data.taskStartdate.substring(0, 10) : '';
				const eDate = data.taskEnddate ? data.taskEnddate.substring(0, 10) : '';
				
				// hidden 필드에 저장
				$root.find('#hiddenParentStart').val(sDate);
				$root.find('#hiddenParentEnd').val(eDate);
			}
		});
		
		// 상위업무와 날짜 동기화 클릭 이벤트
		$root.find('#btnSyncParentDate').off('click').on('click', function(){
			const s = $root.find('#hiddenParentStart').val();
			const e = $root.find('#hiddenParentEnd').val();
			
			$root.find('#subStartdate').val(s);
			$root.find('#subEnddate').val(e);
		});
		
		// 진척도 슬라이더 이벤트
		const $range = $root.find('#subRateRange');
		const $rateVal = $root.find('#subRateValue');
		const $rateHidden = $root.find('#subRateHidden');
		
		$range.off('input').on('input', function(){
			const val = $(this).val();
			$rateVal.text(val);
			$rateHidden.val(val);
		})
		
	}
	
	/**
	 * 하위 업무 등록 처리 함수
	 */
	function submitSubTask(){
		const form = $('#createSubTaskForm')[0];
		const formData = new FormData(form);
		
		// 유효성 검사
		if (!formData.get('subTitle')) {
			alert('업무 제목을 입력해주세요.');
			$('#createSubTaskForm input[name=subTitle]').focus();
			return;
		}
		

		const subS = formData.get('subStartdate'); 		// 하위업무 시작일
		const subE = formData.get('subEnddate');   		// 하위업무 마감일
		
		const parentS = $('#hiddenParentStart').val();	// 상위업무 시작일
		const parentE = $('#hiddenParentEnd').val();	// 상위업무 마감일
		
		if (!subS) {
			alert('시작일 입력은 필수입니다.');
			$('#subStartdate').focus();
			return;
		}

		if (!subE) {
			alert('마감일 입력은 필수입니다.');
			$('#subEnddate').focus();
			return;
		}
		
		if(subS && subE && subS > subE){
			alert('마감일은 시작일보다 빠를 수 없습니다.');
			$('#subEnddate').focus();
			return;
		}
		
		// 상위업무와 기간 비교 체크
		if(parentS && subS && subS < parentS){
			alert(`하위업무 시작일은 상위업무 시작일(${parentS})보다 빠를 수 없습니다.`);
			// 상위업무 시작일로 자동삽입 후 포커스
			$('#subStartdate').val(parentS).focus();	
			return;
		}
		if(parentE && subE && subE > parentE){
			alert(`하위업무 마감일은 상위업무 마감일(${parentE})을 초과할 수 없습니다.`);
			// 상위업무 시작일로 자동삽입 후 포커스
			$('#subEnddate').val(parentE).focus();	
			return;
		}
		
		$.ajax({
			url: `${contextPath}/tudio/project/task/sub/create`,
			type: 'POST',
			data: formData,
			contentType: false,
			processData: false,
			success: function(res) {
				if (res === 'SUCCESS') {
					if (window.Swal) {
						Swal.fire('성공', '단위업무가 등록되었습니다.', 'success').then(() => {
							const modalEl = document.getElementById('projectCommonModal');
							const modal = bootstrap.Modal.getInstance(modalEl);
							modal.hide();
							// 목록 새로고침 (loadTab이 projectMain.js에 전역으로 있다고 가정)
							if (typeof loadTab === 'function') loadTab('task');
						});
					} else {
						alert("등록 완료");
						const modalEl = document.getElementById('projectCommonModal');
						const modal = bootstrap.Modal.getInstance(modalEl);
						modal.hide();
						if (typeof loadTab === 'function') loadTab('task');
					}
				} else {
					Swal.fire({
						icon: 'error',
						title: '등록 실패',
						text: '등록에 실패했습니다: ' + res,
						confirmButtonText: '확인'
					});
				}
			},
			error: function(xhr) {
				console.error(xhr);
				Swal.fire({
					icon: 'error',
					title: '오류 발생',
					text: '서버 통신 중 오류가 발생했습니다.',
					confirmButtonText: '확인'
				});
			}
		});
	}
	
	/**
	 * 업무 상세 데이터 바인딩
	 */
	function fetchAndFillDetail(id, type) {
	    let dataUrl = type === 'T' 
	        ? `${contextPath}/tudio/project/task/detail/${id}`
	        : `${contextPath}/tudio/project/task/sub/detail/${id}`;

	    $.ajax({
	        url: dataUrl,
	        type: 'GET',
	        dataType: 'json',
	        success: function(data) {
				console.log("Detail Data:", data);
				// 수정/삭제 시 사용할 ID 저장
				if (type === 'T') {
	                $('#detailTaskId').val(data.taskId);
	            } else {
	                $('#detailTaskId').val(data.subId);
	            }
				
				$('#detailProjectNo').val(data.projectNo);
				$('#detailTaskType').val(type);
	            
				// 날짜 문자열 자르기
				const toYMD = function(dateStr) {
					if (!dateStr || dateStr.length < 10) return '';
					return dateStr.substring(0, 10);
				};
				
				// eum 객체 변수
				const statusObj = type === 'T' ? data.taskStatus : data.subStatus;
				const priorityObj = type === 'T' ? data.taskPriority : data.subPriority;
				
				
				console.log("[DEBUG] statusObj:", statusObj);
				console.log("[DEBUG] priorityObj:", priorityObj);
				
	            // 데이터 매핑
	            const info = {
					projectName: data.projectName || 'Project Name',
	                parentTitle: data.parentTitle || 'Task Title',
	                title:      type === 'T' ? data.taskTitle : data.subTitle,
	                content:    type === 'T' ? data.taskContent : data.subContent,
	                start:      toYMD(type === 'T' ? data.taskStartdate : data.subStartdate),
	                end:        toYMD(type === 'T' ? data.taskEnddate : data.subEnddate),
					finish: 	toYMD(type === 'T' ? data.taskFinishdate : data.subFinishdate),
	                rate:       type === 'T' ? data.taskRate : data.subRate,
	                writer:     data.writerName, 
	                writerNo:   type === 'T' ? data.taskWriter : data.subWriter,
	                regdate:    toYMD(data.taskRegdate || data.subRegdate),
	                
	                statusLabel: statusObj.label,
	                statusCss:   statusObj.cssClass,
	                priorityLabel: priorityObj ? priorityObj.label : "보통",
	                priorityCss:   priorityObj.cssClass,
	                
	                managers: type === 'T' ? data.taskManagers : data.subManagers
	            };

	            // 1. 텍스트 바인딩
	            $('#detailProjectName').text(info.projectName);
	            $('#detailTitle').text(info.title);
	            $('#detailContent').text(info.content || '내용이 없습니다.');
	            $('#detailWriter').text(info.writer || '미상');
	            
				
				
				// 등록일
	            const regDate = info.regdate ? new Date(info.regdate).toLocaleDateString() : '-';
	            $('#detailRegDate').text(regDate);
	            
	            // 시작일 & 마감일
				const periodStr = (info.start && info.end) ? `${info.start} ~ ${info.end}` : '미지정';
	            $('#detailPeriod').text(periodStr);
				
				// 완료일
				if (info.finish) {
		            $('#detailFinishDateArea').show();
		            $('#detailFinishDate').text(info.finish);
		            
		            // 마감일(info.end)보다 늦게 끝났으면 빨간색 표시
		            if(info.end && info.finish > info.end) {
		                $('#detailFinishDate').addClass('text-danger fw-bold').attr('title', '지연 완료');
		            } else {
		                $('#detailFinishDate').removeClass('text-danger fw-bold').attr('title', '정상 완료');
		            }
		        } else {
		            $('#detailFinishDateArea').hide(); // 완료 안 됐으면 숨김
		        }
				

	            // 상태 & 중요도
	            $('#detailTaskStatusBadge').text(info.statusLabel)
	                                     .attr('class', 'tudio-badge ' + (info.statusCss || ''))
										 .removeAttr('style');
	            $('#detailTaskPriority').text(info.priorityLabel)
										.attr('class', 'tudio-badge ' + (info.priorityCss || ''))
				    					.removeAttr('style');
	            
				// 진척도
				const $rateContainer = $('#detailRateContainer');
				$rateContainer.empty();
				
				// 현재 로그인한 사용자 memberNo
				const currentMemberNo = Number($('#currentMemberNo').val());
				const $btnGroup = $('#detailBtnGroup');
				
				
				// 권한 부여: 작성자
				// 업무 수정/삭제 버튼 활성화를 위함
				let isAuth = (info.writerNo === currentMemberNo);

				// 수정 / 삭제 버튼 가시화여부
	            if (info.writerNo === currentMemberNo) {
	                $btnGroup.show(); // 버튼 그룹 보이기
	            } else {
	                $btnGroup.hide(); // 버튼 그룹 숨기기
	            }
				
				// 권한 부여: (작성자) + 담당자
				// 상세보기에서 바로 진척도를 변경하기 위함
				if(!isAuth && info.managers && info.managers.length > 0){
					isAuth = info.managers.some(m => m.memberNo === currentMemberNo);
				}
				
				// 하위업무 진척도 즉시 변경
				if(type === 'S' && isAuth){
					// 수정 전용
					const sliderHtml = `
	                    <input type="range" class="flex-grow-1"
	                           id="detailRateSlider"
	                           min="0" max="100" step="5"
	                           value="${info.rate}"/>
	                    <span id="detailRateText" class="small fw-bold text-primary ms-2" style="min-width:40px; text-align:right;">
							${info.rate}%
						</span>
					`;
					$rateContainer.html(sliderHtml);
					
					// 슬라이더 배경색 채우기 함수
					const updateSliderFill = function($el){
						const val = $el.val();
						$el.css('background', `linear-gradient(to right, #3182f6 ${val}%, #e9ecef ${val}%)`);
					}
					
					const $slider = $('#detailRateSlider');
					
					updateSliderFill($slider);
					
					// 슬라이더 이벤트
					$slider.on('input', function(){
						// 드래그 중에는 숫자만 변경
						$('#detailRateText').text($(this).val() + '%');
						updateSliderFill($(this));
					}).on('change', function(){
						// 드래그 종료시 DB 업데이트 함수 호출
						updateDetailTaskRate(id, $(this).val(), type);
					});
				} else {
					// 읽기 전용
					const progressHtml = `
	                    <div class="progress flex-grow-1" style="height: 6px;">
	                        <div class="progress-bar bg-primary" role="progressbar" style="width: ${info.rate}%"></div>
	                    </div>
	                    <span class="small fw-bold text-primary ms-2">${info.rate}%</span>
					`;
					$rateContainer.html(progressHtml);
				}

	            // 2. [담당자] 렌더링 로직 
	            const $assigneeArea = $('#detailAssigneeArea').empty();
	            
	            if(info.managers && info.managers.length > 0) {
	                info.managers.forEach(man => {
	                    // man.memberName: 이름, man.memberRole: 역할 등 VO 필드 확인 필요
	                    const name = man.memberName || '이름없음';
	                    const initial = name.charAt(0);
	                    
	                    $assigneeArea.append(`
	                        <div class="task-user-chip">
	                            <div class="task-user-profile">${initial}</div>
	                            <span>${name}</span>
	                        </div>
	                    `);
	                });
	            } else {
	                $assigneeArea.html('<span class="text-muted small">지정되지 않음</span>');
	            }

	            // 3. 첨부파일
	            const $fList = $('#detailFileList').empty();
	            if(data.fileList && data.fileList.length > 0) {
	                data.fileList.forEach(f => {
	                    let downUrl = `${contextPath}/tudio/file/download?fileNo=${f.fileNo}`;
	                    $fList.append(`
	                        <li class="list-group-item d-flex justify-content-between align-items-center">
	                            <a href="${downUrl}" class="text-decoration-none text-dark text-truncate">
	                                <i class="bi bi-file-earmark"></i> ${f.fileOriginalName}
	                            </a>
	                            <span class="text-muted small">${f.fileFancySize}</span>
	                        </li>
	                    `);
	                });
	            } else {
	                $fList.html('<li class="list-group-item text-muted small text-center">첨부파일이 없습니다.</li>');
	            }

	            // 상위/하위 뷰 전환
	            if(type === 'T') {					// 상위업무 상세페이지
	                $('#parentLinkArea').hide();
	                $('#subTaskListArea').show();
					$('#breadcrumbSeparator').hide();
					$('#btnGoParent').hide();
	                
					// 종속된 하위업무 리스트
					const $subGroup = $('#detailSubListGroup').empty();
					if (data.subTasks && data.subTasks.length > 0) {
						data.subTasks.forEach(sub => {
							// 하위업무 리스트 아이템 (테이블 스타일)
							const sLabel = statusObj.label || statusObj;
							const sCss = statusObj.cssClass || 'bg-secondary';
							
							const sDate = toYMD(sub.subEnddate) || '-';

							let assigneeHtml = '<span class="text-muted small">-</span>';
							
							// 종속된 하위업무 담당자가 다수인 경우 첫 번쨰 담당자의 이름만 표기
							if (sub.subManagers && sub.subManagers.length > 0) {
								const member = sub.subManagers[0];
								const name = member.memberName || '이름없음';
								// 뷁 일단은 프로필 사진이 아닌 이니셜로...
								const initial = name.charAt(0);
								
								const countStr = sub.subManagers.length > 1 ? ` <span class="text-muted">+${sub.subManagers.length-1}</span>` : '';
								
								assigneeHtml = `
				                    <div class="d-flex align-items-center" style="gap:6px;">
				                        <div class="task-user-profile" style="width:20px; height:20px; font-size:10px;">${initial}</div>
				                        <span class="text-truncate" style="max-width:60px;">${name}</span>
				                        ${countStr}
				                    </div>
				                 `;
							}
							$subGroup.append(`
	                            <div class="task-sub-item">
	                                <div class="task-sub-status">
										<span class="badge ${sCss}" style="font-weight:normal; font-size:11px;">${sLabel}</span>
	                                </div>
									
	                                <div class="task-sub-title" 
										data-sub-id="${sub.subId}"
										title="${sub.subTitle}"
										style="cursor:pointer;">
										${sub.subTitle}
									</div>
									
	                                <div class="task-sub-date">
										<i class="bi bi-calendar4 me-2" style="color:#b0b8c1; font-size:12px;"></i>
										<span>${sDate}</span>
	                                </div>
									
									<div class="task-sub-assignee">
										${assigneeHtml}
									</div>
	                            </div>
	                         `);
	                     });
						 
						 // 하위업무 제목 클릭 이벤트
						 $('#detailSubListGroup').off('click').on('click', '.task-sub-title', function() {
							const subId = $(this).data('subId');
							if(subId){
								// 상세 조회 함수 재호출 (하위업무)
								fetchAndFillDetail(subId, 'S');
							}
						 });
	                } else {
	                    $subGroup.html('<div class="text-muted small p-2 text-center">단위업무가 없습니다.</div>');
	                }
	            } else {							// 하위업무 상세페이지
	                $('#subTaskListArea').hide();
					$('#breadcrumbSeparator').show(); // (>) 아이콘
	                $('#parentLinkArea').show();
	                $('#detailParentTitle').text(data.parentTitle || '상위 업무로 이동');
	                
					// 상위업무 제목 클릭 이벤트
	                $('#btnGoParent')
						.text(info.parentTitle || '상위업무')
						.show()
						.off('click')
						.on('click', function(e){
	                    	e.preventDefault();
	                    	if(data.taskId) fetchAndFillDetail(data.taskId, 'T');
	                });
	            }
	        },
	        error: function(xhr) {
	            console.error(xhr);
	            $('.task-modal-wrap').html('<div class="p-5 text-center text-danger">정보를 불러오지 못했습니다.</div>');
	        }
	    });
	}
	
	/**
	 * 상세 모달 내 수정/삭제 버튼 이벤트
	 */
	function bindDetailActions() {
	    // 1. 수정 버튼 클릭
	    $(document).off('click.modifyTask').on('click.modifyTask', '#btnModifyTask', function() {
	        const id = $('#detailTaskId').val();
	        const type = $('#detailTaskType').val();
	        const pNo = $('#detailProjectNo').val();

	        // 상위 업무(T)인 경우 -> taskCreate.jsp를 수정 모드로 호출
	        if (type === 'T') {
	            // Controller에 새로 만든 URL 매핑 사용 (/project/task/edit)
	            const url = `${contextPath}/tudio/project/task/edit?projectNo=${pNo}&taskId=${id}`;
	            
	            // 모달 내용을 수정 폼으로 교체 (loadModal 재사용)
	            loadModal(url, 'modal-lg', function() {
	                // 수정 폼 UI 초기화 (이전에 만든 함수 재활용)
	                if(typeof initTaskCreateUI === 'function'){
	                    initTaskCreateUI($('#projectCommonModalContent'));  
	                }
	            });
	        } else {
	            Swal.fire('알림', '단위업무 수정은 업무 상세 내에서 진행해주세요.', 'info');
	        }
	    });

	    // 2. 삭제 버튼 클릭
	    $(document).off('click.deleteTask').on('click.deleteTask', '#btnDeleteTask', function() {
			Swal.fire({
                title: '삭제 확인',
                text: '정말 이 업무를 삭제하시겠습니까?\n(단위업무도 함께 삭제됩니다)',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: '삭제',
                cancelButtonText: '취소'
            }).then((result) => {
				if (result.isConfirmed) {
	       			const workId = $('#detailTaskId').val();
	       			const type = $('#detailTaskType').val(); // T or S
	        
			        // 삭제 AJAX 요청
			        $.ajax({
			            url: `${contextPath}/tudio/project/task/delete`, // [주의] 삭제 Controller 구현 필요
			            type: 'POST',
			            data: { workId: workId, type: type }, // Controller 파라미터에 맞게 수정
			            success: function(res) {
			                if(res === 'SUCCESS') {
			                    Swal.fire('삭제됨', '업무가 삭제되었습니다.', 'success').then(() => reloadTaskTab());
			                    // 모달 닫기
			                    const modalEl = document.getElementById('projectCommonModal');
			                    const modal = bootstrap.Modal.getInstance(modalEl);
			                    if (modal) modal.hide();
			                    
			                    // 목록 새로고침
			                    if (typeof loadTab === 'function') loadTab('task');
			                } else {
			                    Swal.fire('실패', '삭제 실패했습니다.', 'error');
			                }
			            },
			            error: function() {
			                Swal.fire('오류', '서버 통신 오류', 'error');
			            }
			        });
				}
			});
	    });
	}
	
	/**
	 * create UI 초기화 
	 */
	function initTaskCreateUI($root) {
		const $wrap = $root.find('.task-create-wrap');
		const $form = $root.find('#createTaskForm');
		
		// 상태(Status) Select 박스 제어 객체
		const $statusSelect = $root.find('#taskStatusSelect');
		
		// 초기 로딩 시 '지연(DELAYED)' 선택 불가 처리
		// 현재 값이 DELAYED가 아니면, 옵션에서 숨기거나 비활성화
		const initialStatus = $statusSelect.val();
		if (initialStatus !== 'DELAYED') {
			// DELAYED 옵션을 찾아서 비활성화 및 숨김 (사용자 선택 방지)
			$statusSelect.find('option[value="DELAYED"]').prop('disabled', true).hide();
		}

		// 1) 프로젝트 마감일 동기화
		$root.find('#syncProjectEndBtn').off('click.sync').on('click.sync', function() {
			const endYmd = $wrap.attr('data-project-end');
			if (!endYmd) return;
			$root.find('#taskEnddate').val(endYmd);
		});
		
		$root.find('#btnFillDummyData').off('click').on('click', function() {
            // 시연 시나리오에 맞는 그럴듯한 데이터
            const dummyTitle = "이벤트 페이지 내 카테고리 및 상세 조건 필터 기능 구현";
            const dummyContent = 
`[개요]
올리브영 이벤트 페이지에서 사용자가 원하는 상품을 빠르게 찾을 수 있도록 카테고리 및 조건별 필터 기능을 추가합니다.

[구현 목표]
1. 브랜드, 가격대, 혜택(쿠폰/증정)별 체크박스 필터 UI 적용
2. 필터 선택 시 비동기(AJAX)로 상품 리스트 실시간 갱신
3. 모바일/PC 반응형 레이아웃 대응

[추가할 단위업무 리스트]
1. 필터 UI 퍼블리싱 (사이드바 및 모달)
2. 조건별 상품 조회 API 개발 (MyBatis 동적 쿼리)
3. 프론트엔드 필터 로직 연동 및 상태관리
4. 필터 적용 속도 최적화 및 QA 테스트`;

            // 값 주입
            $form.find('input[name="taskTitle"]').val(dummyTitle);
            $form.find('textarea[name="taskContent"]').val(dummyContent);
            
            //입력 효과를 위해 포커스 한번 주기
            $form.find('input[name="taskTitle"]').focus();
        });

		// 2) 진척도 슬라이더
		const $range = $root.find('#taskRateRange');
		const $rateVal = $root.find('#taskRateValue');
		const $rateHidden = $root.find('#taskRateHidden');
		
		const $inputMode = $root.find('#taskRateInputMode');   // 슬라이더 영역
		const $staticMode = $root.find('#taskRateStaticMode'); // 막대바 영역
		const $staticBar = $root.find('#taskRateStaticBar');   // 실제 색깔 바

		function setParentRate(v) {
			const val = Number(v || 0);
			// 텍스트 & 히든값 업데이트
			$rateVal.text(val);
			$rateHidden.val(val);
			
			// 두 UI 모두 값 동기화 (보이는 쪽이든 아니든)
			$range.val(val);
			$staticBar.css('width', val + '%');
			
			// 진척도에 따른 상태 자동 변경 로직 호출
			syncStatusWithRate(val);
		}
		
		// 진척도 -> 상태 동기화 로직 함수
		function syncStatusWithRate(rate) {
			const currentStatus = $statusSelect.val();
			
			// 예외: 현재 상태가 '보류(HOLD)' 또는 '지연(DELAYED)'인 경우
			// 1~99% 구간에서는 상태를 강제로 변경하지 않음 (사용자가 의도한 상태 유지)
			// 단, 0%나 100%가 되면 명확한 시작/끝이므로 변경 가능 (기획에 따라 100%만 허용할 수도 있음)
			const isExceptionState = (currentStatus === 'HOLD' || currentStatus === 'DELAYED');

			if (rate == 0) {
				$statusSelect.val('REQUEST');
			} else if (rate == 100) {
				$statusSelect.val('DONE');
			} else {
				// 1 ~ 99% 구간
				if (!isExceptionState) {
					$statusSelect.val('PROGRESS');
				}
			}
		}

		// 슬라이더 움직일 때 이벤트
		$range.off('input.rate').on('input.rate', function() {
			setParentRate(this.value);
		});
		
		// 상위업무 진척도 자동 계산 및 UI 모드 전환
		function calcParentRate(){
			const $subs = $root.find('.subtask-item');
			const count = $subs.length;
			
			// 종속된 하위 업무가 없는 경우, 슬라이더 활성화
			if(count === 0){
				$staticMode.hide();
				$inputMode.show();
				return;
			}
			
			// 종속된 하위업무가 있을시 슬라이더 비활성화
			$inputMode.hide();
			$staticMode.show();
									
			// 종속된 하위업무 진척도 총합
			let total = 0;
			$subs.each(function(){
				// 하위업무 진척도 슬라이더 값 가져오기
				const val = Number($(this).find('input[name*="subRate"]').val()) || 0;
				total += val;
			});
			
			// 종속된 하위업무 평균값 계산 후 세팅
			const avg = Math.round(total / count);
			setParentRate(avg);
		}
		
		// 초기화 시점에 한 번 실행해서 잠금 상태 적용!
		calcParentRate();

		// 3) 상위 담당자(assignee) - hidden inputs 만들기: name="taskManagerNos"
		const $search = $root.find('#assigneeSearchInput');
		const $dropdown = $root.find('#assigneeDropdown');
		const $tags = $root.find('#selectedAssigneeTags');
		const $hidden = $root.find('#taskManagerNosFields');

		// 초기화 시 정렬 한 번 수행
		sortAssigneeItems();

		function sortAssigneeItems() {
			const items = $dropdown.find('.assignee-item').get();
			items.sort((a, b) => {
				const $a = $(a), $b = $(b);
				const ca = $a.find('input[type="checkbox"]').prop('checked');
				const cb = $b.find('input[type="checkbox"]').prop('checked');
				// 체크된 항목을 위로
				if (ca !== cb) return ca ? -1 : 1;
				const na = String($a.data('memberName') || '');
				const nb = String($b.data('memberName') || '');
				return na.localeCompare(nb, 'ko');
			});
			$dropdown.empty().append(items);
		}

		function rebuildTaskManagerHidden() {
			$hidden.empty();
			$dropdown.find('.assignee-item').each(function() {
				const $item = $(this);
				const checked = $item.find('input[type="checkbox"]').prop('checked');
				if (!checked) return;
				const no = $item.data('memberNo');
				$hidden.append(`<input type="hidden" name="taskManagerNos" value="${no}">`);
			});
		}

		function rebuildTaskManagerTags() {
			$tags.empty();
			$dropdown.find('.assignee-item').each(function() {
				const $item = $(this);
				const checked = $item.find('input[type="checkbox"]').prop('checked');
				if (!checked) return;

				const no = $item.data('memberNo');
				const name = $item.data('memberName');

				const $tag = $(`
	         <span class="assignee-tag" data-member-no="${no}">
	           <span>${name}</span>
	           <button type="button" aria-label="remove">✕</button>
	         </span>
	       `);

				$tag.find('button').on('click', function() {
					$item.find('input[type="checkbox"]').prop('checked', false);
					// 체크 해제 시 태그 삭제 및 목록 갱신
					sortAssigneeItems();
					rebuildTaskManagerTags();
					rebuildTaskManagerHidden();
				});

				$tags.append($tag);
			});
		}

		function filterAssignee(keyword) {
			const k = String(keyword || '').trim();
			const $items = $dropdown.find('.assignee-item');
			
			if (k === '') {
				$items.show();
			} else {
				$items.each(function() {
					const name = String($(this).data('memberName') || '');
					$(this).toggle(name.includes(k));
				});
			}
		}

		// [수정 1] 포커스 또는 클릭 시 드롭다운 열기 (.show() 추가)
		$search.off('focus.assignee click.assignee').on('focus.assignee click.assignee', function(e) {
			e.stopPropagation(); // 상위로 이벤트 전파 방지 (문서 클릭 이벤트와 충돌 방지)
			$dropdown.addClass('show'); 
			$dropdown.show(); // display: none 제거 (hide()로 닫혔을 때를 대비)
			sortAssigneeItems();
			filterAssignee($(this).val());
		});

		// 입력 시 필터링
		$search.off('input.assignee').on('input.assignee', function() {
			$dropdown.show(); // 입력 중에는 무조건 보이기
			filterAssignee(this.value);
		});

		// 아이템 클릭 시 체크 토글 (이벤트 위임)
		$dropdown.off('click.assigneeItem').on('click.assigneeItem', '.assignee-item', function(e) {
			e.stopPropagation(); // 드롭다운 내부 클릭 시 닫히지 않도록
			
			// 체크박스 직접 클릭이 아니면 강제 토글
			if (!$(e.target).is('input[type="checkbox"]')) {
				const $chk = $(this).find('input[type="checkbox"]');
				$chk.prop('checked', !$chk.prop('checked'));
			}

			sortAssigneeItems();
			rebuildTaskManagerTags();
			rebuildTaskManagerHidden();
			
			// 선택 후에도 계속 검색하려면 포커스 유지
			$search.focus();
		});
		
		// [수정 2] 외부 클릭 시 드롭다운 닫기 (네임스페이스 .assigneeClose 사용으로 중복 방지)
		$(document).off('click.assigneeClose').on('click.assigneeClose', function(e) {
		    // assignee-box 내부가 아니라면 닫기
		    if (!$(e.target).closest('.assignee-box').length) {
		        $dropdown.hide();
		        $dropdown.removeClass('show');
		    }
		});

		// [수정 3] 수정 모드일 때: 기존 담당자 데이터 불러와서 체크하기
		// (taskCreate.jsp 하단에 var isEditMode, existingManagers 선언되어 있어야 함)
		if (typeof isEditMode !== 'undefined' && isEditMode && typeof existingManagers !== 'undefined') {
			existingManagers.forEach(m => {
				const $item = $dropdown.find(`.assignee-item[data-member-no="${m.memberNo}"]`);
				if ($item.length > 0) {
					$item.find('input[type="checkbox"]').prop('checked', true);
				}
			});
			// 초기화 적용
			sortAssigneeItems();
			rebuildTaskManagerTags();
			rebuildTaskManagerHidden();
		}
		//  하위업무 추가/삭제 + 일정동기화 + 인덱스 재정렬
		const $subList = $root.find('#subTaskList');
		const tpl = $root.find('#subTaskTemplate').html();
		let subSeq = 0;

		// [1] 하위업무 추가
	    $root.find('#addSubTaskBtn').off('click.addSub').on('click.addSub', function() {
	        // 템플릿 임시 추가 (인덱스는 reindexSubTasks에서 잡음)
	        const tempHtml = tpl.replaceAll('{{idx}}', '0').replaceAll('{{n}}', '0');
	        $subList.append(tempHtml);
	        
	        reindexSubTasks(); // [핵심] 추가 직후 재정렬
	        calcParentRate();
	    });
		
		// 단위업무 개별 일정 동기화 버튼
		$root.find('#subTaskList').on('click', '.btn-sync-parent', function() {
		    const s = $root.find('#taskStartdate').val();
		    const e = $root.find('#taskEnddate').val();
		    
		    // 시간까지 넘어와도 날짜만 나오도록
		    const sDate = (s && s.length > 10) ? s.substring(0, 10) : s;
		    const eDate = (e && e.length > 10) ? e.substring(0, 10) : e;
		    
		    const $row = $(this).closest('.subtask-item');
		    $row.find('[data-role="subStart"]').val(sDate);
		    $row.find('[data-role="subEnd"]').val(eDate);
		});
		
		// [2] 하위업무 삭제
	    $subList.off('click.removeSub').on('click.removeSub', '[data-action="removeSubTask"]', function() {
	        const $item = $(this).closest('.subtask-item');
	        const existingId = $(this).data('existingSubId');

	        // 기존 DB 데이터라면 삭제 ID 목록에 추가
	        if (existingId) {
	            const $delInput = $root.find('#deleteSubIds');
	            let ids = $delInput.val() ? $delInput.val().split(',') : [];
	            ids.push(existingId);
	            $delInput.val(ids.join(','));
	        }

	        $item.remove();
	        
	        reindexSubTasks(); // [핵심] 삭제 직후 재정렬
	        calcParentRate();  // 삭제 시 재계산
	    });
		
		// [3] 하위업무 인덱스 재정렬 함수 (The Best Practice)
	    function reindexSubTasks() {
	        const $items = $subList.find('.subtask-item');
	        
	        $items.each(function(index) {
	            const $row = $(this);
	            
	            // 1. data-index 업데이트
	            $row.attr('data-sub-index', index);
	            
	            // 2. 제목 업데이트 (하위업무 1, 2, 3...)
	            $row.find('.subtask-title').text('단위업무 ' + (index + 1));
	            
	            // 3. 모든 input, select, textarea의 name 속성 업데이트
	            // 예: subTasks[old].subTitle -> subTasks[new].subTitle
	            $row.find('[name]').each(function() {
	                const oldName = $(this).attr('name');
	                if (oldName && oldName.includes('subTasks[')) {
	                    // 정규식으로 인덱스 부분만 교체
	                    const newName = oldName.replace(/subTasks\[\d+\]/, `subTasks[${index}]`);
	                    $(this).attr('name', newName);
	                }
	            });
	            
	            // 4. 담당자 hidden input도 재생성 (인덱스가 바뀌었으므로)
	            rebuildSubManagerHiddenForItem($row); 
	        });
			subSeq = $subList.find('.subtask-item').length; // Seq 동기화
	    }
		
		// [4] 하위 담당자 체크박스 변경 시 hidden input 동기화
	    $subList.off('change.subAssignee').on('change.subAssignee', '[data-sub-assignee] input[type="checkbox"]', function() {
	        const $subItem = $(this).closest('.subtask-item');
	        rebuildSubManagerHiddenForItem($subItem);
	    });
		
		// 개별 하위업무의 담당자 hidden fields를 갱신하는 함수
	    function rebuildSubManagerHiddenForItem($subItem) {
	        const currentIndex = $subItem.attr('data-sub-index'); // 현재의 정확한 인덱스
	        const $container = $subItem.find('[data-sub-manager-nos-fields]');
			
			// 기존 hidden input 일괄 제거 (jsp에서 만든 것과 중복 방지)
	        $container.empty();

	        $subItem.find('.sub-assignee-item input[type="checkbox"]:checked').each(function() {
	            const memberNo = $(this).closest('.sub-assignee-item').data('memberNo');
	            // 정확한 인덱스로 hidden input 생성
	            $container.append(`<input type="hidden" name="subTasks[${currentIndex}].subManagerNos" value="${memberNo}">`);
	        });
	    }
		
		// 상위업무와 일정 동기화 버튼 이벤트
		$root.find('#syncSubDatesBtn').off('click.syncSub').on('click.syncSub', function() {
			const s = $root.find('#taskStartdate').val();
			const e = $root.find('#taskEnddate').val();
			
			// 시간까지 넘어와도 날짜만 나오도록
			if(s && s.length > 10) s = s.substring(0, 10);
			if(e && e.length > 10) e = e.substring(0, 10);
			
			$subList.find('[data-role="subStart"]').val(s);
			$subList.find('[data-role="subEnd"]').val(e);
		});
		
		// 뷁 이거 왜 있는 거더라...
		$subList.on('input', '.sub-rate-range', function(){
			$(this).closest('.col-md-6').find('.sub-rate-val').text(this.value);
			calcParentRate();
		});
		
		// 취소 버튼 수동 제어
		$root.find('#btnCancelTask').off('click').on('click', function() {
            // 1. 모달 닫기
            const modalEl = document.getElementById('projectCommonModal');
            const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
            modal.hide();

            // 2. [핵심] 백드롭 및 잠금 스타일 강제 제거 (약간의 딜레이 후)
            setTimeout(() => {
                $('.modal-backdrop').remove(); 
                $('body').removeClass('modal-open')
                         .css('overflow', 'auto')      
                         .css('padding-right', '');
                $('body').removeAttr('aria-hidden'); 
            }, 350);
        });

		// 5) 상위업무 submit 
		function submitTask() {
			// 최소 검증: 상위 제목
			const title = String($form.find('[name="taskTitle"]').val() || '').trim();
			const startDate = $form.find('#taskStartdate').val();
			const endDate = $form.find('#taskEnddate').val();
			
			// 상위업무 제목 검증
			if (!title) {
				alert('업무 제목 입력은 필수입니다.');
				$form.find('[name="taskTitle"]').focus();
				return;
			}
			
			// 상위업무 시작일 검증
			if(!startDate){
				alert('시작일 입력은 필수입니다.');
				$form.find('#taskStartdate').focus();
				return;
			}
			
			// 상위업무 마감일 검증
			if(!endDate){
				alert('마감일 입력은 필수입니다.');
				$form.find('#taskEnddate').focus();
				return;
			}
			
			if (startDate > endDate) { // yyyy-MM-dd 문자열 비교 가능
			    alert('마감일은 시작일보다 빠를 수 없습니다.');
			    $form.find('#taskEnddate').focus();
			    return;
			}

			// 하위업무 제목 검증: 입력된 subTask가 있으면 title 필수
			let invalid = false;
			$subList.find('.subtask-item').each(function() {
				const v = String($(this).find('input[name*=".subTitle"]').val() || '').trim();
				if (!v) {
					invalid = true;
					$(this).find('input[name*=".subTitle"]').focus();
					return false;
				}
			});
			if (invalid) {
				alert('업무 제목은 비워둘 수 없습니다.');
				return;
			}

			// 상위 담당자 hidden 최신화
			rebuildTaskManagerHidden();

			// 하위 담당자 hidden 최신화
			$subList.find('.subtask-item').each(function() {
				rebuildSubManagerHiddenForItem($(this));
			});

			let formData = new FormData($form[0]);
			
			$.ajax({
				url: $form.attr('action'),
				type: 'POST',
				data: formData,
				contentType: false,
				processData: false,
				success: function(res){
					if (res === "SUCCESS") {
                        // 헬퍼 함수 호출로 교체하여 백드롭 제거 및 리로드 보장
						if (window.Swal) {
							// 모달을 먼저 숨겨서 포커스 반환을 유도
							$('#projectCommonModal').modal('hide');
							
							Swal.fire({
                                title: '성공', 
                                text: '업무가 저장되었습니다.', 
                                icon: 'success',
                                timer: 1500, // 1.5초 뒤 자동 닫힘 (편의성)
                                showConfirmButton: false
                            }).then(() => {
								reloadTaskTab(); // 2. 탭 리로드 및 찌꺼기 청소
							});
						} else {
							alert("업무가 저장되었습니다.");
							reloadTaskTab();
						}
					} else if (res === "LOGIN_REQUIRED") {
						alert("로그인이 필요합니다.");
						location.href = "/tudio/login";
					} else {
						alert("업무 생성/수정에 실패했습니다.")
					}
				},
				error: function(xhr, status, error) {
					console.error("에러 발생:", error);
					alert("서버 통신 중 오류가 발생했습니다.");
				}
			})
		}

		$root.find('#submitTaskBtn').off('click.submit').on('click.submit', submitTask);
	}

	function updateDetailTaskRate(id, rate, type) {
		// 안전장치: 상위업무는 수정 불가
		if (type === 'T') {
			alert("상위업무의 진척도는 단위업무에 의해 자동 계산됩니다.");
			return;
		}

		console.log(`[UpdateRate] ID: ${id}, Rate: ${rate}`);

		$.ajax({
			url: `${contextPath}/tudio/project/task/sub/updateRate`,
			type: 'POST',
			data: {
				subId: id,   // Controller 파라미터명 매칭
				subRate: rate
			},
			success: function(res) {
				if (res === 'success') {
					// 성공 시 화면 갱신 (상태값이 자동으로 변했을 수 있으므로 다시 불러옴)
					fetchAndFillDetail(id, 'S');

					// 목록 탭도 갱신 (상위업무 진척도 변화 반영)
					if (typeof loadTab === 'function') loadTab('task');
				} else {
					alert('진척도 수정에 실패했습니다.');
				}
			},
			error: function(xhr) {
				console.error(xhr);
				alert('서버 통신 오류가 발생했습니다.');
			}
		});
	}
})();
