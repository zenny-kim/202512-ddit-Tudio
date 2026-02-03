package kr.or.ddit.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

import org.springframework.stereotype.Component;

@Component
public class DateFormatUtil {

	private static final DateTimeFormatter KOR = DateTimeFormatter.ofPattern("M월 d일(E요일)", Locale.KOREAN);

	private DateFormatUtil() {
	} // new 방지

	public static String formatKorean(LocalDateTime dt) {
		if (dt == null)
			return "";
		return dt.format(KOR);
	}
}
