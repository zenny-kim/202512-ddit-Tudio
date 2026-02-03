package kr.or.ddit.admin.siteNotice.service.impl;

import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.admin.siteNotice.mapper.ISiteNoticeMapper;
import kr.or.ddit.admin.siteNotice.service.ISiteNoticeService;
import kr.or.ddit.notification.service.INotificationService;
import kr.or.ddit.vo.MemberAuthVO;
import kr.or.ddit.vo.NoticeVO;
import kr.or.ddit.vo.PageResult;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class SiteNoticeServiceImpl implements ISiteNoticeService {
	
	@Autowired
	private ISiteNoticeMapper noticeMapper;
	
	@Autowired
	private INotificationService notiService;
	
	@Autowired
    private kr.or.ddit.file.service.IFileService fileService;

	/**
	 * 공지사항 목록 조회 (페이징 포함)
	 * 리액트가 받을 데이터: { dataList: [...], pageInfo: {...} }
	 */
	@Override
	public PageResult<NoticeVO> retrieveNoticeList(NoticeVO noticeVO) {
		
		int totalRecordCount = noticeMapper.selectNoticeCount(noticeVO);
		noticeVO.setTotalRecordCount(totalRecordCount); // 페이징 계산
		
		List<NoticeVO> noticeList = null;
		
		if(totalRecordCount > 0) {
			noticeList = noticeMapper.selectNoticeList(noticeVO);
		} else {
			noticeList = Collections.emptyList();
		}
		
		// ★ Map 대신 PageResult 객체 반환
		return new PageResult<>(noticeList, noticeVO);
	}

	/**
	 * 공지사항 등록
	 */
	@Override
	public String createNotice(NoticeVO noticeVO) {
		int result = noticeMapper.insertNotice(noticeVO);

		 if(result !=0) { 
			  int noticeNo = noticeVO.getNoticeNo();
			  String notiUrl = "/tudio/notice/detail?noticeNo="+noticeVO.getNoticeNo();
		   	  String notiMessage = "["+noticeVO.getNoticeTitle()+"] 등록되었습니다.";
		   	  
			  notiService.pushSiteNotice(noticeNo, notiUrl, notiMessage);
  
		  }
		
		
		return result > 0 ? "SUCCESS" : "FAIL";
	}

	/**
	 * 공지사항 수정 (제목, 내용, 핀)
	 */
	@Override
	public String modifyNotice(NoticeVO vo, java.util.List<org.springframework.web.multipart.MultipartFile> upfiles) {
		try {
	        // 1. 새로 첨부된 파일이 있는지 확인
	        if (upfiles != null && !upfiles.isEmpty() && !upfiles.get(0).isEmpty()) {
	            // 새 파일을 업로드하고 새로운 그룹번호를 생성 (동료분 서비스 활용)
	            // 기존 파일을 유지할지 여부에 따라 401 대신 기존 그룹번호를 넣을 수도 있습니다.
	            int newFileGroupNo = fileService.uploadFiles(upfiles, vo.getMemberNo(), 401);
	            
	            // VO에 새 그룹번호 세팅 (이 값이 XML의 NOTICE_FILE_NO로 들어감)
	            vo.setFileGroupNo(newFileGroupNo);
	            log.info("[Service] 수정 중 새 파일 업로드 완료 - 그룹번호: {}", newFileGroupNo);
	        }

	        // 2. DB 업데이트 (제목, 내용, 파일번호 등)
	        int result = noticeMapper.updateNotice(vo);
	        
	        if(result !=0) { 
				  int noticeNo = vo.getNoticeNo();
				  String notiUrl = "/tudio/notice/detail?noticeNo="+vo.getNoticeNo();
			   	  String notiMessage = "["+vo.getNoticeTitle()+"] 변경되었습니다.";
			   	  
				  notiService.pushSiteNotice(noticeNo, notiUrl, notiMessage);
	  
			  }
 
	        return result > 0 ? "SUCCESS" : "FAIL";

	    } catch (Exception e) {
	        log.error("[Service ERROR] 수정 중 예외 발생: ", e);
	        return "FAIL";
	    }
	}

	/**
	 * 상단 고정(핀) 상태 변경
	 */
	@Override
	public String modifyPin(NoticeVO noticeVO) {
		int result = noticeMapper.updateNoticePin(noticeVO);
		return result > 0 ? "SUCCESS" : "FAIL";
	}

	/**
	 * 공지사항 삭제
	 */
	@Override
	public String removeNotice(int noticeNo) {
		int result = noticeMapper.deleteNotice(noticeNo);
		return result > 0 ? "SUCCESS" : "FAIL";
	}

	/**
	 * 상세 조회 
	 */
	@Override
	public NoticeVO retrieveNotice(int noticeNo, int viewerNo) {
		
		NoticeVO noticeVO = noticeMapper.selectNoticeDetail(noticeNo);
		
		if (noticeVO == null) return null;

	    boolean skipHit = false;
	    
	    if (viewerNo > 0 && viewerNo == noticeVO.getMemberNo()) {
	        skipHit = true;
	    }

	    if (!skipHit && viewerNo > 0) {
	        List<MemberAuthVO> authList = noticeMapper.selectMemberAuthList(viewerNo);
	        if (authList != null) {
	            for (MemberAuthVO authVO : authList) {
	                if ("ROLE_ADMIN".equals(authVO.getAuth())) {
	                    skipHit = true;
	                    break;
	                }
	            }
	        }
	    }
	    
	    // 3. 스킵 조건에 해당하지 않을 때만 조회수 증가
	    if (!skipHit) {
	        noticeMapper.incrementHit(noticeNo);
	        // 화면에 즉시 반영하기 위해 불러온 객체의 조회수도 +1
	        noticeVO.setNoticeHit(noticeVO.getNoticeHit() + 1);
	    }

		// 3. 상세 내용 가져오기 
	    return noticeVO;
	}

}