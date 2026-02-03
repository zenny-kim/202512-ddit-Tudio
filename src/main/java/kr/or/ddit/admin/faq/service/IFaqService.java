package kr.or.ddit.admin.faq.service;

import java.util.List;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.vo.FaqVO;

public interface IFaqService {

	public List<FaqVO> selectFaqList();

	public ServiceResult insertFaq(FaqVO faqVo);

	public ServiceResult updateFaq(FaqVO faqVO);

	public ServiceResult deleteFaq(int faqNo);

	public ServiceResult updatePublicStatus(FaqVO faqVo);

	public ServiceResult updateFaqOrder(List<FaqVO> faqList);

}
