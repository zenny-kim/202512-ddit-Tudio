package kr.or.ddit.faq.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.admin.faq.service.IFaqService;
import kr.or.ddit.vo.FaqVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/tudio/faq")
public class FaqController {

	@Autowired
	private IFaqService faqService;
	
	@GetMapping("/list")
	public String faqList(Model model) {
		List<FaqVO> faqList = faqService.selectFaqList();
		model.addAttribute("faqList", faqList);
		return "faq/list";
	}
}
