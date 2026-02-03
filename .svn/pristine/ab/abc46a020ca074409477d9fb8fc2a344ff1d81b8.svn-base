package kr.or.ddit.projectMember.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.projectMember.mapper.IProjectMemberMapper;
import kr.or.ddit.projectMember.service.IProjectMemberService;
import kr.or.ddit.vo.project.ProjectMemberVO;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Service
public class ProjectMemberServiceImpl implements IProjectMemberService {

	@Autowired
	private IProjectMemberMapper projectMemberMapper;
	
	/**
	 *  구성원 목록 조회
	 */
	@Override
	public List<ProjectMemberVO> projectMemberList(int projectNo) {
		
		return projectMemberMapper.projectMemberList(projectNo);
	}

	
	/**
	 * 구성원 정보 조회
	 */
	@Override
	public ProjectMemberVO projectMemberDetail(ProjectMemberVO vo) {
		ProjectMemberVO memberInfo = projectMemberMapper.projectMemberDetail(vo);  			 // 이름/이메일/참여일 등
		ProjectMemberVO cnt = projectMemberMapper.projectMemberDetailTaskCount(vo);          // total/ing/done

		 if (cnt == null) {
		        memberInfo.setTotalTaskCnt(0);
		        memberInfo.setIngCnt(0);
		        memberInfo.setDoneCnt(0);
		        memberInfo.setDelayCnt(0);
		        memberInfo.setHoldCnt(0);
		    } else {
		        memberInfo.setTotalTaskCnt(cnt.getTotalTaskCnt());
		        memberInfo.setIngCnt(cnt.getIngCnt());
		        memberInfo.setDoneCnt(cnt.getDoneCnt());
		        memberInfo.setDelayCnt(cnt.getDelayCnt());
		        memberInfo.setHoldCnt(cnt.getHoldCnt());
		    }
		    return memberInfo;
	}

	
	/**
	 *  프로젝트 내 구성원 수
	 */
	@Override
	public int projectMemberCount(int projectNo) {
		return projectMemberMapper.projectMemberCount(projectNo);
	}


	@Override
	public ProjectMemberVO projectMemberDetailTaskCount(ProjectMemberVO vo) {
		return projectMemberMapper.projectMemberDetailTaskCount(vo);
	}


	@Override
	public List<ProjectMemberVO> projectMemberDetailTaskCountChart(int projectNo) {
		return projectMemberMapper.projectMemberDetailTaskCountChart(projectNo);
	}


	@Override
	public List<ProjectMemberVO> projectMemberListSearch(Map<String, Object> param) {
		
		return projectMemberMapper.projectMemberListSearch(param);
	}

}
	

