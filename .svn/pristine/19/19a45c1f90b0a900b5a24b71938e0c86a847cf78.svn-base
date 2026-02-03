package kr.or.ddit.admin.faq.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.FaqVO;

@Mapper
public interface IFaqMapper {

	public List<FaqVO> selectFaqList();

	public int insertFaq(FaqVO faqVo);

	public int updateFaq(FaqVO faqVO);

	public int deleteFaq(int faqNo);

	public int updatePublicStatus(FaqVO faqVo);

	public int updateFaqOrder(List<FaqVO> faqList);

}
