package kr.or.ddit.inquiry.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.InquiryPaginationInfoVO;
import kr.or.ddit.vo.InquiryVO;

public interface IInquiryService {
	
	public void incrementInquiryHit(int inquiryNo);
	
	// 사용자
	public void registerInquiry(InquiryVO inquiry, List<MultipartFile> files);
	public List<InquiryVO> getInquiryListByUser(InquiryPaginationInfoVO<InquiryVO> pagingVO);
	public InquiryVO getInquiryDetail(int inquiryNo);
	public void modifyInquiry(InquiryVO inquiry, List<MultipartFile> files);
	public void removeInquiryByUser(int inquiryNo, int userNo);
    
    // 관리자
    public List<InquiryVO> getInquiryListAll(InquiryPaginationInfoVO<InquiryVO> pagingVO);
    public int getInquiryCountAll(InquiryPaginationInfoVO<InquiryVO> pagingVO);
    public void registerReply(InquiryVO inquiry);
    public void removeInquiryByAdmin(int inquiryNo);
    public void removeInquiryReply(int inquiryNo);
    public void deleteInquiryByAdmin(int inquiryNo);
    public int getCompletedCount(InquiryPaginationInfoVO<InquiryVO> pagingVO);
    
    //페이지
    public int getInquiryCount(InquiryPaginationInfoVO<InquiryVO> pagingVO);
    
    //파일
    public List<FileDetailVO> getFileList(int fileGroupNo);
    public FileDetailVO getFileDetail(int fileNo);

    
}
