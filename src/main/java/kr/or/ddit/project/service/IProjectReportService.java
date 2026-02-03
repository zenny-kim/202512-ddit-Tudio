package kr.or.ddit.project.service;

import java.util.Map;

public interface IProjectReportService {
	
	/**
     * 프로젝트 결과보고서 PDF 생성 및 메일 발송
     * @param projectNo 프로젝트 번호
     * @param memberNo 요청자(프로젝트 관리자) 번호
     * @return 성공 여부 (SUCCESS/FAIL)
     */
	public void generateReportAndSendMail(Map<String, String> data) throws Exception;;
}
