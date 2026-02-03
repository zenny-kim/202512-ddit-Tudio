package kr.or.ddit.file.service.impl;

import java.io.File;
import java.io.FileOutputStream;
import java.util.List;
import java.util.UUID;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.ServletContext;
import jakarta.transaction.Transactional;
import kr.or.ddit.file.mapper.IFileMapper;
import kr.or.ddit.file.service.IFileService;
import kr.or.ddit.vo.FileDetailVO;
import kr.or.ddit.vo.FileGroupVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class FileServiceImpl implements IFileService {

	@Autowired
	private ServletContext servletContext;

	@Autowired
	private IFileMapper fileMapper;

	// 파일용 변수 (C:/upload/)
	@Value("${kr.or.ddit.upload.path}")
	private String uploadPath;

	// 이미지용 변수 (svn 내부 main/webapp/upload/폴더명
	@Value("${kr.or.ddit.imageUpload.path}")
	private String imageUploadPath;

	/**
	 * 
	 * // 1. public String fileUpload(MultipartFile file, int memberNo, String
	 * fileType) -> XML <insert id="insertFileGroup"> 호출 impl 에서 사용 시 ->
	 * fileMapper.insertFileGroup(fileGroupVO);
	 * 
	 * // 2. 위 쿼리가 성공하면 selectKey에 의해 번호가 VO에 담김 int fileGroupNo =
	 * fileGroupVO.getFileGroupNo();
	 * 
	 * // 3. for문 안에서 이 코드가 실행될 때 -> XML의 <insert id="insertFileDetail"> 반복 호출됨
	 * fileMapper.insertFileDetail(fileDetailVO);
	 * 
	 * 
	 */

	@Override
	public String fileUpload(MultipartFile file, int memberNo, int fileType) {
		if (file == null || file.isEmpty()) {
			return "";
		}

		try {
			// 폴더명 가져오기
			String folderName = getFolderName(fileType);

			// 이미지 파일 확인하기
			String mimeType = file.getContentType();
			boolean isImage = mimeType != null && mimeType.startsWith("image");

			// 경로 설정
			String savePath = ""; // 컴퓨터에 저장될 실제 물리 경로
			String webPath = ""; // DB에 저장될 웹 접근 경로

			if (isImage) {
				// 이미지 파일일 경우
				String svnImageUploadPath = servletContext.getRealPath(imageUploadPath);
				savePath = svnImageUploadPath + File.separator + folderName;
				// DB 저장값 : "/upload/폴더명/파일명"
				webPath = imageUploadPath + folderName;
			} else {
				// 일반 파일일 경우
				savePath = uploadPath + folderName;

				// local 은 식별자라서 다운로드 주소 만들때는 컨트롤러에서 지우는 내용이 필요함
				webPath = "/local/" + folderName;
			}

			// 폴더가 없으면 생성
			File fileDir = new File(savePath);
			if (!fileDir.exists()) {
				fileDir.mkdirs();
			}

			// 파일명 생성 (UUID)
			String originalName = file.getOriginalFilename();
			String saveName = UUID.randomUUID().toString() + "_" + originalName;

			// 파일 저장
			File target = new File(savePath, saveName);
			file.transferTo(target);

			// DB에 저장할 최종 경로 완성 (경로 + 파일명)
			String finalDbPath = webPath + "/" + saveName;

			// DB 저장 (FileGroup)
			FileGroupVO fileGroupVO = new FileGroupVO();
			fileGroupVO.setMemberNo(memberNo);
			fileGroupVO.setFileGroupType(fileType);
			fileMapper.insertFileGroup(fileGroupVO);

			// DB 저장 (FileDetail)
			FileDetailVO fileDetailVO = new FileDetailVO();
			fileDetailVO.setFileGroupNo(fileGroupVO.getFileGroupNo());
			fileDetailVO.setFileOriginalName(originalName);
			fileDetailVO.setFileSaveName(saveName);

			// 경로 넣어주기
			fileDetailVO.setFilePath(finalDbPath);

			fileDetailVO.setFileSize((int) file.getSize());
			fileDetailVO.setFileExtension(FilenameUtils.getExtension(originalName));
			fileDetailVO.setFileMime(mimeType);

			fileMapper.insertFileDetail(fileDetailVO);

			return finalDbPath;

		} catch (Exception e) {
			log.error("파일 업로드 실패: ", e);
			throw new RuntimeException("업로드 에러: " + e.getMessage());
		}
	}

	// fileType 로직 분리
	private String getFolderName(int fileType) {
		switch (fileType) {
		case 401:
			return "notice"; // 사이트 공지사항
		case 402:
			return "inquiry"; // 문의사항
		case 403:
			return "projectTask"; // 프로젝트 상위업무
		case 404:
			return "taskSub"; // 프로젝트 하위업무
		case 405:
			return "projectBoard"; // 프로젝트 게시판
		case 406:
			return "comment"; // 댓글
		case 407:
			return "chat"; // 채팅
		case 408:
			return "profile"; // 프로필 이미지
		case 409:
			return "bizFileNo"; // 사업자등록증
		case 410:
			return "draftDocument"; // 기안
		case 411:
			return "faq"; // 자주묻는질문
		case 412:
			return "comment"; // 댓글
		case 413:
			return "replyComment"; // 대댓글
		case 414:
			return "meetingRoom"; // 회의실 사진
		case 415: 
			return "projectReport";	// 프로젝트 결과보고서
		default:
			return "others";
		}
	}

	@Override
	@Transactional // 여러 파일 저장 중 하나라도 실패하면 롤백
	public int uploadFiles(List<MultipartFile> fileList, int memberNo, int fileType) {

		if (fileList == null || fileList.isEmpty() || fileList.get(0).isEmpty()) {
			return 0;
		}

		try {
			// 폴더명 생성
			String folderName = getFolderName(fileType);

			// 파일 그룹 생성
			FileGroupVO fileGroupVO = new FileGroupVO();
			fileGroupVO.setMemberNo(memberNo);
			fileGroupVO.setFileGroupType(fileType);
			fileMapper.insertFileGroup(fileGroupVO);

			int fileGroupNo = fileGroupVO.getFileGroupNo();

			// 리스트 반복 -> 파일 하나씩 확인 필요
			for (MultipartFile file : fileList) {
				if (file.isEmpty())
					continue;

				// 파일마다 이미지인지 아닌지 확인
				String mimeType = file.getContentType();
				boolean isImage = mimeType != null && mimeType.startsWith("image");

				String savePath = "";
				String webPath = "";

				if (isImage) {
					// 이미지 -> SVN 경로
					String svnImageUploadPath = servletContext.getRealPath(imageUploadPath);
					savePath = svnImageUploadPath + File.separator + folderName;
					webPath = imageUploadPath + folderName;
				} else {
					// 일반파일 -> C드라이브
					savePath = uploadPath + folderName;
					webPath = "/local/" + folderName;
				}

				// 폴더 생성
				File fileDir = new File(savePath);
				if (!fileDir.exists()) {
					fileDir.mkdirs();
				}

				String originalName = file.getOriginalFilename();
				String saveName = UUID.randomUUID().toString() + "_" + originalName;

				// 저장
				File target = new File(savePath, saveName);
				file.transferTo(target);

				// 상세 정보 DB 저장
				FileDetailVO fileDetailVO = new FileDetailVO();
				fileDetailVO.setFileGroupNo(fileGroupNo);
				fileDetailVO.setFileOriginalName(originalName);
				fileDetailVO.setFileSaveName(saveName);

				// 결정된 경로 + 파일명
				fileDetailVO.setFilePath(webPath + "/" + saveName);

				fileDetailVO.setFileSize((int) file.getSize());
				fileDetailVO.setFileExtension(FilenameUtils.getExtension(originalName));
				fileDetailVO.setFileMime(mimeType);

				fileMapper.insertFileDetail(fileDetailVO);
			}

			return fileGroupNo;

		} catch (Exception e) {
			log.error("다중 파일 업로드 중 에러 발생: ", e);
			throw new RuntimeException("파일 저장 중 오류가 발생했습니다.");
		}
	}

	
	@Override
	public FileDetailVO selectFileDetail(int fileNo) {
		return fileMapper.selectFileDetail(fileNo);
	}

	@Override
	public List<FileDetailVO> selectFileDetailList(int fileGroupNo) {
		return fileMapper.selectFileDetailList(fileGroupNo);
	}

	@Override
	public int insertFilesToExistingGroup(List<MultipartFile> fileList, int memberNo, int fileType, int fileGroupNo) {
		if (fileList == null || fileList.isEmpty() || fileList.get(0).isEmpty()) {
			return 0;
		}
		
		try {
			// 폴더명 생성
			String folderName = getFolderName(fileType);
			
			// 리스트 반복 -> 파일 하나씩 확인 필요
			for (MultipartFile file : fileList) {
				if (file.isEmpty())
					continue;

				// 파일마다 이미지인지 아닌지 확인
				String mimeType = file.getContentType();
				boolean isImage = mimeType != null && mimeType.startsWith("image");

				String savePath = "";
				String webPath = "";

				if (isImage) {
					// 이미지 -> SVN 경로
					String svnImageUploadPath = servletContext.getRealPath(imageUploadPath);
					savePath = svnImageUploadPath + File.separator + folderName;
					webPath = imageUploadPath + folderName;
				} else {
					// 일반파일 -> C드라이브
					savePath = uploadPath + folderName;
					webPath = "/local/" + folderName;
				}

				// 폴더 생성
				File fileDir = new File(savePath);
				if (!fileDir.exists()) {
					fileDir.mkdirs();
				}

				String originalName = file.getOriginalFilename();
				String saveName = UUID.randomUUID().toString() + "_" + originalName;

				// 저장
				File target = new File(savePath, saveName);
				file.transferTo(target);

				// 상세 정보 DB 저장
				FileDetailVO fileDetailVO = new FileDetailVO();
				fileDetailVO.setFileGroupNo(fileGroupNo);
				fileDetailVO.setFileOriginalName(originalName);
				fileDetailVO.setFileSaveName(saveName);

				// 결정된 경로 + 파일명
				fileDetailVO.setFilePath(webPath + "/" + saveName);

				fileDetailVO.setFileSize((int) file.getSize());
				fileDetailVO.setFileExtension(FilenameUtils.getExtension(originalName));
				fileDetailVO.setFileMime(mimeType);

				fileMapper.insertFileDetail(fileDetailVO);
			}

			return fileGroupNo;
		}catch(Exception e) {
			log.error("다중 파일 업로드 중 에러 발생: ", e);
			throw new RuntimeException("파일 저장 중 오류가 발생했습니다.");
		}
	}

	@Override
	public int updateFileDelete(int fileNo) {
		return fileMapper.updateFileDelete(fileNo);
	}

	// 결과보고서 pdf 생성 및 업로드
	@Override
    @Transactional
	public String fileUpload(String originalName, byte[] fileData, int memberNo, int fileType) {
		if (fileData == null || fileData.length == 0) {
            return "";
        }
		
		try {
            // 폴더명
            String folderName = getFolderName(fileType);

            String mimeType = "application/octet-stream";
            if(originalName.toLowerCase().endsWith(".pdf")) mimeType = "application/pdf";
            
            boolean isImage = mimeType != null && mimeType.startsWith("image");

            String savePath = "";
            String webPath = "";

            if (isImage) {
                String svnImageUploadPath = servletContext.getRealPath(imageUploadPath);
                savePath = svnImageUploadPath + File.separator + folderName;
                webPath = imageUploadPath + folderName;
            } else {
                savePath = uploadPath + folderName;
                webPath = "/local/" + folderName;
            }

            // 폴더 생성
            File fileDir = new File(savePath);
            if (!fileDir.exists()) {
                fileDir.mkdirs();
            }

            // 파일명 생성 (UUID)
            String saveName = UUID.randomUUID().toString() + "_" + originalName;

            // 파일 저장
            File target = new File(savePath, saveName);
            try (FileOutputStream fos = new FileOutputStream(target)) {
                fos.write(fileData);
            }

            String finalDbPath = webPath + "/" + saveName;

            FileGroupVO fileGroupVO = new FileGroupVO();
            fileGroupVO.setMemberNo(memberNo);
            fileGroupVO.setFileGroupType(fileType);
            fileMapper.insertFileGroup(fileGroupVO);

            FileDetailVO fileDetailVO = new FileDetailVO();
            fileDetailVO.setFileGroupNo(fileGroupVO.getFileGroupNo());
            fileDetailVO.setFileOriginalName(originalName);
            fileDetailVO.setFileSaveName(saveName);

            fileDetailVO.setFilePath(finalDbPath);

            fileDetailVO.setFileSize(fileData.length); 
            fileDetailVO.setFileExtension(FilenameUtils.getExtension(originalName));
            fileDetailVO.setFileMime(mimeType);

            fileMapper.insertFileDetail(fileDetailVO);

            return finalDbPath;

        } catch (Exception e) {
            log.error("서버 파일 업로드 실패: ", e);
            throw new RuntimeException("업로드 에러: " + e.getMessage());
        }
    }

}
