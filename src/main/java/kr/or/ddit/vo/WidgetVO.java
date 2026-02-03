package kr.or.ddit.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WidgetVO {
	private int widgetNo;			// 위젯번호
    private int memberNo;			// 회원번호
    private String widgetType;		// 위젯타입
    private int width;        		// GridStack: w
    private int height;       		// GridStack: h
    private String widgetStatus;	// 위젯사용여부
    private int locationNo;   		// 위치 번호
    
    private int x;
    private int y;
    
    public int getW() { return this.width; }
    public int getH() { return this.height; }
    public void setW(int w) { this.width = w; }
    public void setH(int h) { this.height = h; }
    
    public static WidgetVO createDefault(int memberNo, String type, int x, int y, int w, int h, String status) {
    	return WidgetVO.builder().memberNo(memberNo)
    			.widgetType(type)
    			.x(x).y(y)
    			.width(w).height(h)
    			.locationNo((y * 12) + x)
    			.widgetStatus(status)
    			.build();
    }
}
