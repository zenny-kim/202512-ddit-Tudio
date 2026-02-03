package kr.or.ddit.inquiry.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.FileGroupVO;
import kr.or.ddit.vo.InquiryPaginationInfoVO;
import kr.or.ddit.vo.InquiryVO;

@Mapper
public interface IInquiryMapper {
	 // 사용자
    public int insertInquiry(InquiryVO inquiry);
    
    public List<InquiryVO> selectInquiryListByUser(InquiryPaginationInfoVO<InquiryVO> pagingVO);
    
    public int selectInquiryCount(InquiryPaginationInfoVO<InquiryVO> pagingVO);

    public InquiryVO selectInquiryDetail(int inquiryNo);

    public int updateInquiry(InquiryVO inquiry);

    public int deleteInquiryByUser(@Param("inquiryNo") int inquiryNo,
            						@Param("userNo") int userNo);

    public int incrementInquiryHit(int inquiryNo);
    
    public void insertInquiryFileGroup(FileGroupVO fileGroupVO);

    public void insertInquiryFileDetail(FileDetailVO fileDetailVO);

    // 관리자
    public List<InquiryVO> selectInquiryListAll(@Param("pagingVO") InquiryPaginationInfoVO<InquiryVO> pagingVO);

    public int updateInquiryReply(InquiryVO inquiry);
    
    public int deleteInquiryByAdmin(int inquiryNo);

	public List<FileDetailVO> getFileList(int fileGroupNo);

	public int selectInquiryCountAll(@Param("pagingVO") InquiryPaginationInfoVO<InquiryVO> pagingVO);

	public void removeInquiryReply(int inquiryNo);
	
	public FileDetailVO selectFileDetail(int fileNo);

	public int getCompletedCount(InquiryPaginationInfoVO<InquiryVO> pagingVO);
}
