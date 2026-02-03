package kr.or.ddit.common.code;

import java.util.Arrays;
import java.util.List;

public enum FileIconType {
	FOLDER("fa-solid fa-folder text-warning", "folder"),
    EXCEL("fa-solid fa-file-excel text-success", "xls", "xlsx", "csv"),
    WORD("fa-solid fa-file-word text-primary", "doc", "docx"),
    PPT("fa-solid fa-file-powerpoint text-danger", "ppt", "pptx"),
    PDF("fa-solid fa-file-pdf text-danger", "pdf"),
    IMAGE("fa-solid fa-file-image text-info", "jpg", "jpeg", "png", "gif", "bmp", "svg"),
    ZIP("fa-solid fa-file-zipper text-secondary", "zip", "rar", "7z", "tar", "gz"),
    CODE("fa-solid fa-file-code text-dark", "txt", "java", "js", "html", "css", "xml", "json"),
    MEDIA("fa-solid fa-file-video text-dark", "mp4", "avi", "mov", "mkv", "mp3", "wav"),
    // 기본값 (매칭되는게 없을 때)
    DEFAULT("fa-solid fa-file text-secondary"); 

    private final String iconClass;
    private final List<String> extensions;

    FileIconType(String iconClass, String... extensions) {
        this.iconClass = iconClass;
        this.extensions = Arrays.asList(extensions);
    }

    public String getIconClass() {
        return iconClass;
    }

    // [핵심 로직] 확장자를 받아서 적절한 아이콘 클래스를 찾아주는 메서드
    public static String getIconClassByExtension(String type, String ext) {
        if ("FOLDER".equalsIgnoreCase(type)) {
            return FOLDER.iconClass;
        }
        
        String targetExt = (ext != null) ? ext.toLowerCase() : "";
        
        return Arrays.stream(values())
                .filter(iconType -> iconType != DEFAULT && iconType != FOLDER)
                .filter(iconType -> iconType.extensions.contains(targetExt))
                .findFirst()
                .orElse(DEFAULT) // 없으면 기본 아이콘 반환
                .getIconClass();
    }
}
