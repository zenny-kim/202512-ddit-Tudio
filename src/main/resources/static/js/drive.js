/**
 * drive.js
 * 프로젝트 내 드라이브 (완성 기능: 조회, 업로드, 삭제/복구, 폴더생성) - Swal 적용판
 */
$(function () {
    let contextPath = $('body').data('contextPath');
    let projectNo = $('body').data('projectNo');
    let currentFolderId = 0; 
    let isTrashMode = false; 

    // 탭 로드 이벤트
    $(document).off('tab:loaded.drive').on('tab:loaded.drive', function (e, tabName) {
        if (tabName !== 'drive') return;
        initDriveTab();
    });

    function initDriveTab() {
        // DOM 다시 읽기
        contextPath = $('body').data('contextPath');
        projectNo = $('body').data('projectNo');
		
        loadDriveList(0);
        bindDriveEvents();
        
        $(document).off('click.driveMenu').on('click.driveMenu', function() {
            $('#driveContextMenu').hide();
        });
    }

    function loadDriveList(folderId) {
        currentFolderId = folderId;
        const url = isTrashMode 
            ? `${contextPath}/tudio/project/drive/trash?projectNo=${projectNo}`
            : `${contextPath}/tudio/project/drive/api/list`;

        $.ajax({
            url: url,
            type: "get",
            data: { projectNo: projectNo, folderId: folderId },
            dataType: "json",
            success: function(result){
                renderTable(result.driveList);
            },
            error: function(xhr){
                console.error("로드 실패");
                // 로드 실패는 사용자에게 굳이 알리지 않거나 조용히 처리 (선택사항)
            }
        });
    }

    function renderTable(list) {
        const $tbody = $('#driveListBody');
        $tbody.empty();

        if (!list || list.length === 0) {
            $('#driveEmptyState').show();
            return;
        }
        $('#driveEmptyState').hide();
        
        let html = '';
        list.forEach(item => {
            const fileType = item.fileType ? item.fileType.toLowerCase() : 'file';
            const fileName = item.fileName || '이름 없음';
            const sizeStr = (item.fileType === 'FOLDER') ? '-' : formatBytes(item.fileSize);
            const iconClass = item.iconClass || 'fa-solid fa-file text-secondary';
            const uploader = item.uploaderName || '-';
            const regDate = item.regDate || '-';

            html += `
                <tr class="drive-row" data-id="${item.fileId}" data-type="${fileType}" data-name="${fileName}">
                    <td class="text-center drive-icon-td"><i class="${iconClass} fa-lg"></i></td>
                    <td class="drive-name-td">
                        ${fileType === 'folder' ? `<span class="fw-bold text-dark cursor-pointer">${fileName}</span>` : `<span class="text-dark">${fileName}</span>`}
                    </td>
                    <td>${uploader}</td>
                    <td class="text-muted">${regDate}</td>
                    <td class="text-muted text-center small">${sizeStr}</td>
                    <td class="text-center position-relative">
                        <button class="btn btn-sm text-muted btn-context-menu" type="button">
                            <i class="fa-solid fa-ellipsis-vertical"></i>
                        </button>
                    </td>
                </tr>
            `;
        });
        $tbody.html(html);
    }

    function bindDriveEvents() {
        const $body = $('#driveListBody');
        $body.off(); // 중복 방지

        // 1. 진입 (폴더 더블클릭 or 클릭)
        $body.on('click', '.drive-row', function(e) {
            if ($(e.target).closest('.btn-context-menu').length > 0) return;
            const type = $(this).data('type');
            const id = $(this).data('id');
            const name = $(this).data('name');

            if (type === 'folder' && !isTrashMode) {
                updateBreadcrumb(id, name);
                loadDriveList(id);
            } else if (type === 'file') {
                // 파일 클릭 시 다운로드 여부 묻기
                Swal.fire({
                    title: '파일 다운로드',
                    text: `"${name}" 파일을 다운로드 하시겠습니까?`,
                    icon: 'question',
                    showCancelButton: true,
                    confirmButtonText: '다운로드',
                    cancelButtonText: '취소'
                }).then((result) => {
                    if (result.isConfirmed) {
                        location.href = `${contextPath}/tudio/project/drive/download?fileNo=${id}`;
                    }
                });
            }
        });

        // 2. 컨텍스트 메뉴 (더보기 버튼)
        $body.on('click', '.btn-context-menu', function(e) {
            e.stopPropagation();
            const $row = $(this).closest('tr');
            const id = $row.data('id');
            const type = $row.data('type');
            
            updateContextMenu(isTrashMode); 
            
            $('#driveContextMenu')
                .data('id', id)
                .data('type', type)
                .css({ top: e.pageY + 'px', left: (e.pageX - 100) + 'px' })
                .show();
        });

		// 3. 업로드 버튼 연결
		$('#btnUpload').off('click').on('click', function() {
            $('#driveFileInput').click();
        });
		
        // 4. 파일 업로드 실행
        $('#driveFileInput').off('change').on('change', function() {
            if(this.files.length === 0) return;
            
            let formData = new FormData();
            for(let i=0; i<this.files.length; i++) {
                formData.append("files", this.files[i]);
            }
            formData.append("projectNo", projectNo);
            formData.append("folderId", currentFolderId);

            // 로딩 표시 (선택사항)
            Swal.fire({
                title: '업로드 중...',
                text: '잠시만 기다려주세요.',
                allowOutsideClick: false,
                didOpen: () => { Swal.showLoading(); }
            });

            $.ajax({
                url: `${contextPath}/tudio/project/drive/upload`,
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(res) {
                    if(res === 'SUCCESS') {
                        Swal.fire({
                            icon: 'success',
                            title: '업로드 완료',
                            text: '파일이 성공적으로 업로드되었습니다.',
                            timer: 1500,
                            showConfirmButton: false
                        });
                        loadDriveList(currentFolderId);
                    }
                },
				error: function() { 
                    Swal.fire({
                        icon: 'error',
                        title: '업로드 실패',
                        text: '파일 업로드 중 오류가 발생했습니다.'
                    });
                }
            });
            $(this).val('');
        });

        // 5. 컨텍스트 메뉴 동작
        $('#driveContextMenu').off('click').on('click', 'a', function(e) {
            e.preventDefault();
            const actionType = $(this).data('action'); 
            const id = $('#driveContextMenu').data('id');
            const type = $('#driveContextMenu').data('type'); 

            if (actionType === 'download') {
                if (type === 'folder') {
                    Swal.fire('알림', '폴더는 다운로드할 수 없습니다.', 'info');
                    return;
                }
                location.href = `${contextPath}/tudio/project/drive/download?fileNo=${id}`;
            } else if (actionType === 'delete') {
                callDriveAction('softDelete', type, id, '삭제하시겠습니까?', '삭제됨');
            } else if (actionType === 'restore') {
                callDriveAction('restore', type, id, '복구하시겠습니까?', '복구됨');
            } else if (actionType === 'hard-delete') {
                // 영구 삭제는 더 강력한 경고
                Swal.fire({
                    title: '영구 삭제하시겠습니까?',
                    text: "이 작업은 되돌릴 수 없습니다!",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#d33',
                    cancelButtonColor: '#3085d6',
                    confirmButtonText: '영구 삭제',
                    cancelButtonText: '취소'
                }).then((result) => {
                    if (result.isConfirmed) {
                        performAction('hardDelete', type, id, '삭제됨');
                    }
                });
            }
            $('#driveContextMenu').hide();
        });
        
        // 6. 새 폴더 생성
        $('#btnNewFolder').off('click').on('click', function() {
            Swal.fire({
                title: '새 폴더 생성',
                input: 'text',
                inputLabel: '폴더 이름을 입력하세요',
                inputPlaceholder: '새 폴더',
                showCancelButton: true,
                confirmButtonText: '생성',
                cancelButtonText: '취소',
                preConfirm: (name) => {
                    if (!name || !name.trim()) {
                        Swal.showValidationMessage('폴더 이름을 입력해주세요');
                    }
                    return name;
                }
            }).then((result) => {
                if (result.isConfirmed && result.value) {
                    createFolder(result.value);
                }
            });
        });
        
        // 7. 모드 전환 버튼들
        $('#btnGoTrash').off('click').on('click', function() {
            isTrashMode = true;
            toggleHeaderMode();
            loadDriveList(0); 
        });

        $('#btnGoDrive').off('click').on('click', function() {
            isTrashMode = false;
            toggleHeaderMode();
            resetBreadcrumb();
            loadDriveList(0); 
        });
        
        // 8. Breadcrumb
        $('#driveBreadcrumb').off('click', '.breadcrumb-item').on('click', '.breadcrumb-item', function() {
            if(isTrashMode) return;
            const folderId = $(this).data('folderId');
            $(this).nextAll().remove();
            loadDriveList(folderId);
        });
    }

    // 서버 작업 요청 (공통 함수 - Swal 적용)
    // confirmMsg가 있으면 확인창을 띄우고, 없으면 바로 실행
    function callDriveAction(action, type, id, confirmMsg, successTitle) {
        if (confirmMsg) {
            Swal.fire({
                title: confirmMsg,
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: '확인',
                cancelButtonText: '취소'
            }).then((result) => {
                if (result.isConfirmed) {
                    performAction(action, type, id, successTitle);
                }
            });
        } else {
            performAction(action, type, id, successTitle);
        }
    }

    // 실제 AJAX 요청 함수
    function performAction(action, type, id, successTitle) {
        $.ajax({
            url: `${contextPath}/tudio/project/drive/action`,
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ action: action, type: type, id: id }),
            success: function(res) {
                if (res === 'SUCCESS') {
                    Swal.fire({
                        icon: 'success',
                        title: successTitle,
                        timer: 1500,
                        showConfirmButton: false
                    });
                    loadDriveList(currentFolderId);
                } else {
                    Swal.fire('실패', '작업을 완료하지 못했습니다.', 'error');
                }
            },
            error: function() {
                Swal.fire('오류', '서버 통신 오류가 발생했습니다.', 'error');
            }
        });
    }
    
    // 폴더 생성 AJAX
    function createFolder(folderName) {
        $.ajax({
            url: `${contextPath}/tudio/project/drive/api/folder`,
            type: 'post',
            contentType: 'application/json',
            data: JSON.stringify({
                projectNo: projectNo,
                folderName: folderName,
                parentFolderNo: currentFolderId
            }),
            success: function(res) {
                if (res === "SUCCESS") {
                    Swal.fire({
                        icon: 'success',
                        title: '완료',
                        text: '새 폴더가 생성되었습니다.',
                        timer: 1500,
                        showConfirmButton: false
                    });
                    loadDriveList(currentFolderId);
                } else {
                    Swal.fire('실패', '폴더 생성에 실패했습니다.', 'error');
                }
            },
            error: function() {
                Swal.fire('오류', '서버 오류가 발생했습니다.', 'error');
            }
        });
    }

    // 메뉴 구성 변경 (휴지통 vs 일반)
    function updateContextMenu(isTrash) {
        const $menu = $('#driveContextMenu');
        $menu.empty();
        
        if (isTrash) {
            $menu.append(`
                <a class="dropdown-item" href="#" data-action="restore"><i class="fa-solid fa-trash-arrow-up me-2"></i>복구</a>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item text-danger" href="#" data-action="hard-delete"><i class="fa-solid fa-ban me-2"></i>영구 삭제</a>
            `);
        } else {
            $menu.append(`
                <a class="dropdown-item" href="#" data-action="download"><i class="fa-solid fa-download me-2"></i>다운로드</a>
                <a class="dropdown-item text-danger" href="#" data-action="delete"><i class="fa-solid fa-trash me-2"></i>삭제</a>
            `);
        }
    }
    
    // UI: 헤더 모드 전환
    function toggleHeaderMode() {
        if (isTrashMode) {
            $('#driveViewTitle').html('<i class="fa-solid fa-trash-can me-2"></i>휴지통');
            $('#driveBreadcrumb').hide(); 
            $('#driveActionBtns').addClass('d-none');
            $('#trashActionBtns').removeClass('d-none');
        } else {
            $('#driveViewTitle').html('<i class="fa-solid fa-hard-drive me-2"></i>프로젝트 드라이브');
            $('#driveBreadcrumb').show();
            $('#driveActionBtns').removeClass('d-none');
            $('#trashActionBtns').addClass('d-none');
        }
    }

    // 헬퍼 함수들
    function formatBytes(bytes, decimals = 2) {
        if (!+bytes) return '0 Bytes';
        const k = 1024;
        const dm = decimals < 0 ? 0 : decimals;
        const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return `${parseFloat((bytes / Math.pow(k, i)).toFixed(dm))} ${sizes[i]}`;
    }
    
    function resetBreadcrumb(){
        const $ol = $('#driveBreadcrumb');
        $ol.empty();
        $ol.append(`<li class="breadcrumb-item active" data-folder-id="0"><i class="fa-solid fa-house me-1"></i>${project.projectName}</li>`);
    }
    
    function updateBreadcrumb(folderId, folderName){
        const $ol = $('#driveBreadcrumb');
        $ol.find('.active').removeClass('active');
        $ol.append(`<li class="breadcrumb-item active" data-folder-id="${folderId}">${folderName}</li>`);
    }
});