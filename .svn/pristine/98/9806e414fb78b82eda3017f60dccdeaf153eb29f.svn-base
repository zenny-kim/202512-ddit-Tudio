package kr.or.ddit.admin.faq.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.or.ddit.ServiceResult;
import kr.or.ddit.admin.faq.mapper.IFaqMapper;
import kr.or.ddit.admin.faq.service.IFaqService;
import kr.or.ddit.vo.FaqVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FaqServiceImpl implements IFaqService {
	
	@Autowired
	private IFaqMapper faqMapper;
	
	@Override
	public List<FaqVO> selectFaqList() {
		return faqMapper.selectFaqList();
	}
	

	@Override
	public ServiceResult insertFaq(FaqVO faqVo) {
		ServiceResult result = null;
		int status = faqMapper.insertFaq(faqVo);
		
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public ServiceResult updateFaq(FaqVO faqVO) {
		ServiceResult result = null;
		int status = faqMapper.updateFaq(faqVO);
		
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public ServiceResult deleteFaq(int faqNo) {
		ServiceResult result = null;
		int status = faqMapper.deleteFaq(faqNo);
		
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}


	@Override
	public ServiceResult updatePublicStatus(FaqVO faqVo) {
		ServiceResult result = null;
		int status = faqMapper.updatePublicStatus(faqVo);
		
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		
		return result;
	}

	@Override
	public ServiceResult updateFaqOrder(List<FaqVO> faqList) {
		ServiceResult result = null;
		int status = faqMapper.updateFaqOrder(faqList);
		
		if(status > 0) {
			result = ServiceResult.OK;
		}else {
			result = ServiceResult.FAILED;
		}
		return result;
	}

	
	
}
