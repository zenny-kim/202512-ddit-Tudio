package kr.or.ddit.inquiry.service.impl;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.inquiry.mapper.IInquiryMapper;
import kr.or.ddit.inquiry.service.IInquiryService;
import kr.or.ddit.notification.service.INotificationService;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.FileGroupVO;
import kr.or.ddit.vo.InquiryPaginationInfoVO;
import kr.or.ddit.vo.InquiryVO;
import kr.or.ddit.vo.NotificationVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class InquiryServiceImpl implements IInquiryService {

	@Autowired
	private IInquiryMapper inquiryMapper;
	
	@Autowired
	private INotificationService notiService;
	
	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;
	
	/* ==================== 사용자 ===================== */
		
	@Transactional
	@Override
	public void registerInquiry(InquiryVO inquiryVO, List<MultipartFile> files) {

		
	    //파일 그룹 먼저 생성
	    FileGroupVO fileGroupVO = new FileGroupVO();
	    fileGroupVO.setMemberNo(inquiryVO.getUserNo());
	    fileGroupVO.setFileGroupType(402); // 문의

	    inquiryMapper.insertInquiryFileGroup(fileGroupVO);

	    //inquiry에 fileGroupNo 세팅
	    inquiryVO.setFileGroupNo(fileGroupVO.getFileGroupNo());

	    //문의 등록
	    int result = inquiryMapper.insertInquiry(inquiryVO);
	    
	    if(result == 0) {
	        throw new RuntimeException("문의 등록 실패");
	    }

	    //파일 없으면 끝
	    if(files == null || files.isEmpty()) return;

	    //파일 저장
	    
//	    String saveDir = uploadPath + "inquiry/" + inquiryVO.getInquiryNo();
//	    File dir = new File(saveDir);
//	    if(!dir.exists()) dir.mkdirs();
	    
	    File saveDir = new File(uploadPath, "inquiry/" + inquiryVO.getInquiryNo());
	    if(!saveDir.exists()) saveDir.mkdirs();

	    for(MultipartFile file : files) {
	        if(file.isEmpty()) continue;

	        String originName = file.getOriginalFilename();
	        String saveName = UUID.randomUUID() + "_" + originName;
	        String extension = originName.substring(originName.lastIndexOf(".") + 1);

	        try {
	            file.transferTo(new File(saveDir, saveName));
	        } catch (IOException e) {
	            throw new RuntimeException("파일 저장 실패");
	        }

	        FileDetailVO fileDetailVO = new FileDetailVO();
	        fileDetailVO.setFileGroupNo(fileGroupVO.getFileGroupNo());
	        fileDetailVO.setFileOriginalName(originName);
	        fileDetailVO.setFileSaveName(saveName);
	        fileDetailVO.setFilePath("/upload/inquiry/" + inquiryVO.getInquiryNo() + "/" + saveName);
	        fileDetailVO.setFileSize((int) file.getSize());
	        fileDetailVO.setFileExtension(extension);
	        fileDetailVO.setFileMime(file.getContentType());

	        inquiryMapper.insertInquiryFileDetail(fileDetailVO);
	    }
	}
	
	@Override
	public int getInquiryCount(InquiryPaginationInfoVO<InquiryVO> pagingVO) {
	    return inquiryMapper.selectInquiryCount(pagingVO);
	}

	@Override
	public List<InquiryVO> getInquiryListByUser(InquiryPaginationInfoVO<InquiryVO> pagingVO) {
	    return inquiryMapper.selectInquiryListByUser(pagingVO);
	}
	
	@Transactional
	@Override
	public InquiryVO getInquiryDetail(int inquiryNo) {
		
		inquiryMapper.incrementInquiryHit(inquiryNo);
		
		InquiryVO inquiryVO = inquiryMapper.selectInquiryDetail(inquiryNo);
		if(inquiryVO == null) {
			throw new IllegalArgumentException("존재하지 않는 문의입니다.");
		}
		
		return inquiryVO;
	}
	
	@Transactional
	@Override
	public void modifyInquiry(InquiryVO inquiryVO, List<MultipartFile> files) {
		// 1. 기존 데이터 존재 여부 및 권한 체크
	    InquiryVO saved = inquiryMapper.selectInquiryDetail(inquiryVO.getInquiryNo());
	    if(saved == null) throw new IllegalArgumentException("존재하지 않는 문의입니다.");
	    if(saved.getUserNo() != inquiryVO.getUserNo()) throw new SecurityException("본인 문의만 수정 가능");
	    if("Y".equals(saved.getReplyStatus())) throw new IllegalArgumentException("답변 완료 문의는 수정 불가");

	    // 2. 파일 그룹 번호 가져오기 (기존 글에 저장된 번호)
	    int fileGroupNo = saved.getFileGroupNo();

	    // 3. 첨부파일이 있는 경우에만 실행
	    if(files != null && !files.isEmpty() && !files.get(0).isEmpty()) {
	        
	        // 3-1. 기존에 파일 그룹이 없었다면 신규 생성
	        if(fileGroupNo == 0) {
	            FileGroupVO fileGroupVO = new FileGroupVO();
	            fileGroupVO.setMemberNo(inquiryVO.getUserNo());
	            fileGroupVO.setFileGroupType(402); // 문의사항 타입
	            
	            inquiryMapper.insertInquiryFileGroup(fileGroupVO);
	            fileGroupNo = fileGroupVO.getFileGroupNo(); 
	            
	            // 신규 생성된 그룹번호를 inquiryVO에 세팅 (나중에 updateInquiry할 때 DB에 반영됨)
	            inquiryVO.setFileGroupNo(fileGroupNo);
	        } else {
	            // 기존에 그룹번호가 있었다면 inquiryVO에도 유지해줌
	            inquiryVO.setFileGroupNo(fileGroupNo);
	        }

	        // 3-2. 실제 물리 파일 저장 및 DB 상세 정보 등록
	        String saveDir = uploadPath + "inquiry/" + inquiryVO.getInquiryNo();
	        File dir = new File(saveDir);
	        if(!dir.exists()) dir.mkdirs();

	        for(MultipartFile file : files) {
	            if(file.isEmpty()) continue;

	            String originName = file.getOriginalFilename();
	            String saveName = UUID.randomUUID() + "_" + originName;
	            String extension = originName.substring(originName.lastIndexOf(".") + 1);

	            try {
	                file.transferTo(new File(dir, saveName));
	            } catch (IOException e) {
	                throw new RuntimeException("파일 저장 실패", e);
	            }

	            FileDetailVO fileDetailVO = new FileDetailVO();
	            fileDetailVO.setFileGroupNo(fileGroupNo); // 위에서 확보한 그룹번호 사용
	            fileDetailVO.setFileOriginalName(originName);
	            fileDetailVO.setFileSaveName(saveName);
	            fileDetailVO.setFilePath("/upload/inquiry/" + inquiryVO.getInquiryNo() + "/" + saveName);
	            fileDetailVO.setFileSize((int) file.getSize());
	            fileDetailVO.setFileExtension(extension);
	            fileDetailVO.setFileMime(file.getContentType());

	            inquiryMapper.insertInquiryFileDetail(fileDetailVO);
	        }
	    } else {
	        // 파일을 새로 올리지 않았다면 기존 그룹번호 유지
	        inquiryVO.setFileGroupNo(fileGroupNo);
	    }

	    // 4. 문의글 내용 업데이트 (내용, 제목, 신규 파일그룹번호 등)
	    inquiryMapper.updateInquiry(inquiryVO);
	}

	@Transactional
	@Override
	public void removeInquiryByUser(int inquiryNo, int userNo) {
		int result = inquiryMapper.deleteInquiryByUser(inquiryNo, userNo);
		if(result == 0) {
			throw new RuntimeException("문의 삭제 실패");
		}
		
	}

	/* ==================== 관리자 ===================== */
	
	@Override
	public List<InquiryVO> getInquiryListAll(InquiryPaginationInfoVO<InquiryVO> pagingVO) {
		return inquiryMapper.selectInquiryListAll(pagingVO);
	}

	@Transactional
	@Override
	public void registerReply(InquiryVO inquiryVO) {
		int result = inquiryMapper.updateInquiryReply(inquiryVO);
		
		
	// 문의사항 답변 알림 시작	
		if(result > 0) {
			
			int inquiryNo = inquiryVO.getInquiryNo();
			NotificationVO notiVO = new NotificationVO();
			notiService.pushInquiryNoti(notiVO, inquiryNo);
			
		}else {
			throw new RuntimeException("답변 등록 실패");
		}
   // 문의사항 답변 알림 끝
		
	}	

	@Transactional
	@Override
	public void removeInquiryByAdmin(int inquiryNo) {
		int result = inquiryMapper.deleteInquiryByAdmin(inquiryNo);
		if(result == 0) {
			throw new RuntimeException("문의 삭제 실패");
		}
	}

	@Override
	public void incrementInquiryHit(int inquiryNo) {
		inquiryMapper.incrementInquiryHit(inquiryNo);		
	}

	@Override
	public List<FileDetailVO> getFileList(int fileGroupNo) {
		return inquiryMapper.getFileList(fileGroupNo);
	}

	@Override
	public int getInquiryCountAll(InquiryPaginationInfoVO<InquiryVO> pagingVO) {		
		return inquiryMapper.selectInquiryCountAll(pagingVO);
	}

	@Override
	public void removeInquiryReply(int inquiryNo) {
		inquiryMapper.removeInquiryReply(inquiryNo);
	}

	@Override
	public void deleteInquiryByAdmin(int inquiryNo) {
		inquiryMapper.deleteInquiryByAdmin(inquiryNo);
	}
	
	@Override
	public FileDetailVO getFileDetail(int fileNo) {
	    return inquiryMapper.selectFileDetail(fileNo);
	}

	@Override
	public int getCompletedCount(InquiryPaginationInfoVO<InquiryVO> pagingVO) {
		return inquiryMapper.getCompletedCount(pagingVO);
	}
}
