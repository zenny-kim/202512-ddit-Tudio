package kr.or.ddit.member.service.impl;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.configurationprocessor.json.JSONArray;
import org.springframework.boot.configurationprocessor.json.JSONObject;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import jakarta.servlet.ServletContext;
import jakarta.transaction.Transactional;
import kr.or.ddit.ServiceResult;
import kr.or.ddit.dashboard.service.IWidgetService;
import kr.or.ddit.file.mapper.IFileMapper;
import kr.or.ddit.file.service.IFileService;
import kr.or.ddit.member.mapper.IMemberMapper;
import kr.or.ddit.member.service.IMemberService;
import kr.or.ddit.project.mapper.IProjectMapper;
import kr.or.ddit.vo.ClientCompanyVO;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.MemberVO;
import kr.or.ddit.vo.project.ProjectMemberVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MemberServiceImpl implements IMemberService {
	
	@Autowired
	private ServletContext servletContext;

	@Autowired
	private BCryptPasswordEncoder passwordEncoder;

	@Autowired
	private IMemberMapper memberMapper;
	
	@Autowired
    private IFileService fileService; 
    
    @Autowired
    private IFileMapper fileMapper;

	@Autowired
	private JavaMailSender mailSender;
	
	@Autowired
	private IWidgetService widgetService;
	
	@Autowired
	private IProjectMapper projectMapper;

	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;

	private final long MAX_FILE_SIZE = 2 * 1024 * 1024;

	// 아이디 찾기
	@Override
	public String findMemberId(MemberVO memberVO) {
		return memberMapper.findMemberId(memberVO);
	}

	// 비밀번호 찾기
	@Override
	public MemberVO findMemberPw(MemberVO memberVO) {
		MemberVO result = memberMapper.findMemberPw(memberVO);
		if (result != null) {
			// 임시 비밀번호 생성 (예: tudio1234)
			String tempPw = "tudio" + (int) (Math.random() * 8999 + 1000);
			String encodedPassword = passwordEncoder.encode(tempPw);

			result.setMemberPw(encodedPassword);
			memberMapper.updateNewMemberPw(result);

			sendTempPwEmail(result.getMemberEmail(), tempPw);
			log.info("발급된 임시 비번: {}, 암호화된 비번: {}", tempPw, encodedPassword);
			return result;
		}
		return null;
	}

	// 임시비밀번호 발송
	public void sendTempPwEmail(String toEmail, String tempPw) {
		try {
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

			try {
				helper.setFrom("sujeong1246@gmail.com", "TUDIO 관리자");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			helper.setTo(toEmail);
			helper.setSubject("[TUDIO] 임시 비밀번호 발급 안내입니다.");

			// 임시 비밀번호 HTML 템플릿
			String html = "<div style='margin:0;padding:0;background-color:#f4f7f9;font-family:\"Apple SD Gothic Neo\", \"Malgun Gothic\", sans-serif;'>"
					+ "    <table width='100%' cellpadding='0' cellspacing='0' style='padding:40px 0;'>"
					+ "        <tr>" + "            <td align='center'>"
					+ "                <table width='500' style='background-color:#ffffff;border-radius:12px;overflow:hidden;box-shadow:0 4px 10px rgba(0,0,0,0.1);'>"
					+ "                    " + "                    <tr>"
					+ "                        <td style='background-color:#0d6efd;padding:30px;text-align:center;'>"
					+ "                            <h1 style='color:#ffffff;margin:0;font-size:24px;letter-spacing:-1px;'>TUDIO</h1>"
					+ "                        </td>" + "                    </tr>" + "                    "
					+ "                    <tr>" + "                        <td style='padding:40px 30px;'>"
					+ "                            <h2 style='color:#333;margin:0 0 20px 0;font-size:20px;'>임시 비밀번호 안내</h2>"
					+ "                            <p style='color:#666;font-size:15px;line-height:1.6;margin:0 0 30px 0;'>"
					+ "안녕하세요. TUDIO를 이용해 주셔서 감사합니다.<br>" + "요청하신 임시 비밀번호를 발급해 드립니다."
					+ "                            </p>" + "                            "
					+ "                            <div style='background-color:#f8f9fa;border:1px solid #e9ecef;border-radius:8px;padding:25px;text-align:center;margin-bottom:30px;'>"
					+ "                                <span style='display:block;color:#999;font-size:13px;margin-bottom:8px;'>임시 비밀번호</span>"
					+ "                                <strong style='color:#0d6efd;font-size:28px;letter-spacing:2px;'>"
					+ tempPw + "</strong>" + "                            </div>"
					+ "                            <p style='color:#e74c3c;font-size:13px;margin:0;'>"
					+ "※ 로그인 후 마이페이지에서 반드시 비밀번호를 변경해 주세요." + "                            </p>"
					+ "                        </td>" + "                    </tr>" + "                    "
					+ "                    <tr>"
					+ "                        <td style='background-color:#f8f9fa;padding:20px;text-align:center;border-top:1px solid #eeeeee;'>"
					+ "                            <p style='color:#999;font-size:12px;margin:0;'>본 메일은 발신 전용 메일입니다.</p>"
					+ "                        </td>" + "                    </tr>" + "                </table>"
					+ "            </td>" + "        </tr>" + "    </table>" + "</div>";
			helper.setText(html, true);
			mailSender.send(message);

		} catch (MessagingException e) {
			e.printStackTrace();
			// 에러 처리 로직
		}
	}
	
	// 아이디 중복 확인
	@Override
	public ServiceResult idCheck(String memberId) {
		ServiceResult result = null;
		MemberVO member = memberMapper.idCheck(memberId);
		if (member != null) {
			result = ServiceResult.EXSIST;
			// 아이디와 일치하는 회원이 있으면 EXSIST
		} else {
			result = ServiceResult.NOTEXSIST;
			// 회원 존재하지 않으면 NOTEXSIST
		}
		return result;
	}

	// 사용자 회원가입
	@Transactional
	@Override
	public ServiceResult signup(MemberVO memberVO, ClientCompanyVO companyVO) {
		// 비밀번호 암호화
		if (memberVO.getMemberPw() != null) {
			memberVO.setMemberPw(passwordEncoder.encode(memberVO.getMemberPw()));
		}
		ClientCompanyVO existing = memberMapper.getCompanyInfo(companyVO.getCompanyNo());
		if (existing == null) {
	        memberMapper.insertCompanySimple(companyVO);
	    }
		memberVO.setCompanyNo(companyVO.getCompanyNo());
		int status = memberMapper.memberSignup(memberVO);
		if (status > 0) {
			// 권한 저장
			memberMapper.insertMemberAuth(memberVO.getMemberNo(), "ROLE_MEMBER");
			// 알림 디폴트 설정
			memberMapper.insertDefaultNotification(memberVO.getMemberNo());
			
			if (memberVO.getProfileImageFile() != null && !memberVO.getProfileImageFile().isEmpty()) {
	            // 업로드 후 반환된 경로(예: /upload/profile/uuid.jpg)를 받습니다.
	            String savedWebPath = fileService.fileUpload(memberVO.getProfileImageFile(), memberVO.getMemberNo(), 408);
	            
	            // 3. 반환된 경로를 VO에 담아서 DB를 업데이트합니다.
	            memberVO.setMemberProfileimg(savedWebPath);
	            memberMapper.updateMemberProfile(memberVO); // 마이페이지용 이미지 경로 업데이트 쿼리 필요
	        }
			// 위젯 기본 정보 설정
			widgetService.createDefaultWidget(memberVO.getMemberNo(), memberVO.getMemberRole());
			// 인증 토큰 정보 전송
			processInviteToken(memberVO);
			
			return ServiceResult.OK;
		}
		return ServiceResult.FAILED;
	}

	// 사용자 회원가입 이메일 인증
	public void emailAuthCode(String memberEmail, String authCode) {
		try {
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
			// 한 번에 예외처리 하도록 수정
			helper.setFrom("sujeong1246@gmail.com");
			helper.setTo(memberEmail);
			helper.setSubject("[TUDIO] 회원가입 이메일 인증번호입니다.");

			String html = "<div style='text-align:center; padding:20px; border:1px solid #ddd;'>" + "<h2>이메일 인증번호</h2>"
					+ "<p>아래의 인증번호 6자리를 회원가입 화면에 입력해주세요.</p>" + "<h1 style='color:#0d6efd; letter-spacing:5px;'>"
					+ authCode + "</h1>" + "</div>";

			helper.setText(html, true);
			mailSender.send(message);
			log.info("메일 발송 성공! 대상: {}, 번호: {}", memberEmail, authCode);

		} catch (Exception e) {
			log.error("메일 발송 중 에러 발생: " + e.getMessage());
			throw new RuntimeException(e);
		}
	}

	// 사업자번호 db 조회
	@Override
	public ClientCompanyVO getCompanyInfoFromDb(String companyNo) {
		return memberMapper.getCompanyInfo(companyNo);
	}

	// 사업자번호 api 조회
	@Override
	public Map<String, Object> getCompanyNameFromApi(String companyNo) {
		Map<String, Object> result = new HashMap<>();

		String apiKey = "HvSmJ3zXG09nGsyqARen21GSJP5QIvtN";
		String cleanNo = companyNo.replace("-", ""); // 숫자만 추출
		String apiUrl = "https://bizno.net/api/fapi?key=" + apiKey + "&gb=1&q=" + cleanNo + "&type=json";

		try {
			URL url = new URL(apiUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");

			// API 응답 읽기
			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
			StringBuilder sb = new StringBuilder();
			String line;
			while ((line = br.readLine()) != null) {
				sb.append(line);
			}
			br.close();

			// JSON 파싱 (org.json 라이브러리 사용 가정)
			JSONObject jsonObj = new JSONObject(sb.toString());
			int resultCode = jsonObj.getInt("resultCode");

			result.put("resultCode", resultCode);

			if (resultCode == 0) {
				JSONArray items = jsonObj.getJSONArray("items");
				if (items.length() > 0) {
					result.put("companyName", items.getJSONObject(0).getString("company"));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			result.put("resultCode", -9); // 기타 통신 에러
		}
		return result;
	}

	// 기업 회원가입
	@Transactional
	@Override
	public ServiceResult clientSignup(MemberVO memberVO, ClientCompanyVO companyVO
			, MultipartFile profileImageFile, MultipartFile bizFile) {
		// 비밀번호 암호화
		if (memberVO.getMemberPw() != null) {
			memberVO.setMemberPw(passwordEncoder.encode(memberVO.getMemberPw()));
		}
		int companyStatus = memberMapper.insertClientCompany(companyVO);
	    if (companyStatus <= 0) return ServiceResult.FAILED;

	    //회원 정보 등록
	    memberVO.setCompanyNo(companyVO.getCompanyNo());
	    int status = memberMapper.memberSignup(memberVO);
	    
	    if (status > 0) {
	        //권한 부여
	        memberMapper.insertMemberAuth(memberVO.getMemberNo(), "ROLE_CLIENT");
	        // 알림 디폴트 설정
	     	memberMapper.insertDefaultNotification(memberVO.getMemberNo());
	        
	     	if (bizFile != null && !bizFile.isEmpty()) {
	            fileService.fileUpload(bizFile, memberVO.getMemberNo(), 409);
	        }
	        // [수정] 프로필 (08)
	        if (profileImageFile != null && !profileImageFile.isEmpty()) {
	        	memberMapper.updateMemberProfile(memberVO);
	            fileService.fileUpload(profileImageFile, memberVO.getMemberNo(), 408);
	        }
	        // 위젯 기본 정보 설정
	     	widgetService.createDefaultWidget(memberVO.getMemberNo(), memberVO.getMemberRole());
	     	// 인증 토큰 정보 전송
	     	processInviteToken(memberVO);
	        
	        return ServiceResult.OK;
	    }
	    return ServiceResult.FAILED;
	}
	
	// 비회원 회원가입 후 초대된 프로젝트 자동 참여
	private void processInviteToken(MemberVO memberVO) {
        // 토큰 존재 여부 확인
        if (memberVO.getToken() != null && !memberVO.getToken().isEmpty()) {
            
            // 토큰으로 초대 정보 조회
            ProjectMemberVO inviteVO = projectMapper.selectInvitationByToken(memberVO.getToken());
            
            // 유효한 초대장인지 확인 (존재하고, 아직 사용 안 했는지)
            if (inviteVO != null && "N".equals(inviteVO.getUsedYn())) {
                
                // 프로젝트 구성원 등록 
                ProjectMemberVO pm = new ProjectMemberVO();
                pm.setProjectNo(inviteVO.getProjectNo());
                pm.setMemberNo(memberVO.getMemberNo()); 	  // 방금 가입된 회원 번호
                pm.setProjectRole(inviteVO.getProjectRole()); // 초대된 역할 (MEMBER/CLIENT)
                pm.setProjectMemstatus("Y"); // 즉시 참여 상태
                
                projectMapper.insertProjectMember(pm);
                
                // 초대장 사용 처리 (Y)
                projectMapper.updateInvitationUsed(memberVO.getToken());
                
                log.info("초대 가입 완료: Project {} -> Member {}", inviteVO.getProjectNo(), memberVO.getMemberNo());
            }
        }
    }

	//////////////////////////	로그인 이후 기능	/////////////////////////
	
	//마이페이지 화면
	@Override
	public MemberVO findByMemberId(String memberId) {
		return memberMapper.findByMemberId(memberId);
	}
	
	//마이페이지 회원정보 수정
	@Transactional
	@Override
	public boolean memberModify(MemberVO memberVO, MultipartFile profileImageFile) {
	    //비밀번호 암호화 (입력되었을 때만)
	    if (memberVO.getMemberPw() != null && !memberVO.getMemberPw().isEmpty()) {
	        memberVO.setMemberPw(passwordEncoder.encode(memberVO.getMemberPw()));
	    }

	    //회사 정보 처리 (기존 동일)
	    ClientCompanyVO company = memberMapper.getCompanyInfo(memberVO.getCompanyNo());
	    if (company == null) {
	        ClientCompanyVO newCom = new ClientCompanyVO();
	        newCom.setCompanyNo(memberVO.getCompanyNo());
	        newCom.setCompanyName(memberVO.getCompanyName());
	        memberMapper.insertCompanySimple(newCom);
	    }

	    //프로필 이미지 파일 처리 및 물리적 삭제
	    if (profileImageFile != null && !profileImageFile.isEmpty()) {

	        // 3-1. 기존 프로필 파일 조회
	        List<FileDetailVO> oldFiles =
	            fileMapper.selectProfileFileDetail(memberVO.getMemberNo());

	        if (oldFiles != null && !oldFiles.isEmpty()) {
	            for (FileDetailVO oldFile : oldFiles) {
	                File old =
	                    new File(servletContext.getRealPath(oldFile.getFilePath()));
	                if (old.exists()) {
	                    old.delete();
	                }
	            }

	            // DB 삭제
	            fileMapper.deleteProfileFile(memberVO.getMemberNo());
	            fileMapper.deleteProfileGroup(memberVO.getMemberNo());
	        }

	        // 3-2. 새 프로필 업로드
	        String newProfilePath =
	            fileService.fileUpload(profileImageFile, memberVO.getMemberNo(), 408);

	        // 3-3. MEMBER 테이블에 새 경로 세팅
	        memberVO.setMemberProfileimg(newProfilePath);
	    }
	    //최종 업데이트
	    int memberResult = memberMapper.updateMember(memberVO);
	    
	    int notiResult = 1;
	    if (memberVO.getNotificationSettingVO() != null) {
	        // JSP에서 넘어온 알림 VO에 현재 사용자의 번호를 세팅
	        memberVO.getNotificationSettingVO().setMemberNo(memberVO.getMemberNo());
	        // 알림 설정 테이블 업데이트 (Mapper에 해당 메서드 필요)
	        notiResult = memberMapper.updateNotification(memberVO.getNotificationSettingVO());
	    }
	    
	    return memberResult > 0 && notiResult > 0;
	}
}