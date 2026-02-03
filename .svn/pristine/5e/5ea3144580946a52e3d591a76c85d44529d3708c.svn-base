package kr.or.ddit.vo;

import java.util.List;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class PaginationInfoVO<T> {

	// 한페이지 screenSize = 10 -> startRow - endRow
	// blockSize(페이지 넘버가 그룹핑 되어있는 곳 = 5로 설정) -> startPage / endPage
	// 총 게시글 수 : totaRecord
	// currentPage 1일때 startRow = 1, endRow = 10 / startPage=1 endPage=5
	// currentPage 2일때 startRow = 11, endRow = 20 / startPage=1 endPage=5
	// currentPage 3일때 startRow = 21, endRow = 30 / startPage=1 endPage=5
	// currentPage 4일때 startRow = 31, endRow = 40 / startPage=1 endPage=5
	// currentPage 5일때 startRow = 41, endRow = 50 / startPage=1 endPage=5
	// currentPage 6일때 startRow = 51, endRow = 60 / startPage=6 endPage=10

	private int totalRecord;			//총 게시글수 
	private int totalPage;				//총 페이지수
	private int currentPage;			//현재 페이지
	private int screenSize = 10;		//페이지 당 게시글 수
	private int blockSize = 5;			//페이지 블록 수
	private int startRow;				//시작 row
	private int endRow;					//끝 row
	private int startPage;				//시작 페이지
	private int endPage;				//끝 페이지
	private List<T> dataList;			//결과를 넣을 데이터 리스트
	private String searchType;			//검색타입(제목 작성자 등)
	private String searchWord;			//검색키워드	
	
	public PaginationInfoVO() {}
	
	public PaginationInfoVO(int screenSize, int blockSize) {
		this.screenSize = screenSize;
		this.blockSize = blockSize;
	}
	
	public void setTotalRecord(int totalRecord) {
		//총 게시글 수 를 저장하고 총 게시글 수를 페이지당 나타래 게시글 수로 나누어 총 페이지수를 구한다.
		this.totalRecord = totalRecord;
		//총 페이지 수 = 총 게시글 수 / 1페이지당 보여줄 글 개수
		//ceil 은 올림
		this.totalPage =(int)Math.ceil(totalRecord/(double)screenSize);
	}
	
	
	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;	//현재 페이지
		//startRow, endRow 는 screenSize 값을 활용해서 공식화
		//끝 row = 현재페이지 * 한 페이지당 게시글 수
		this.endRow = currentPage * screenSize;
		//시작 row = 끝 row - (한페이지당 게시글 수 -1)
		this.startRow = endRow - (screenSize-1);
		
		//startPage, endPage 는 blockSize 의 값을 활용해서 공식화
		//마지막 페이지 = (현재페이지 + (페이지 블록 사이즈 -1)) / 페이지 블록 사이즈 * 페이지 블록 사이즈
		//'/ blockSize * blockSize' 는 1,2,3,4,5,... 페이지마다 정수 계산을 이용한 endPage를 구한다
		this.endPage = (currentPage + (blockSize -1)) / blockSize * blockSize;
		//시작 페이지 = 끝 페이지 - ( 페이지 블록 사이즈 -1)
		this.startPage  = endPage -(blockSize-1);
	}
	
	
	//설정된 블록 사이즈만큼 페이지 번호를 가지고 있는 html 코드를 메서드로 모듈화
	public String getPagingHTML() {
		StringBuffer html = new StringBuffer();
		html.append("<ul class='pagination pagination-sm m-0 float-right'>");
		
		//< 1 2 3 4 5 >
		if(startPage > 1) {
			html.append("<li class='page-item'><a href='' class='page-link' data-page='"+(startPage - blockSize)
					+"'>Prev</a></li>");
		} 
		
		//반복문 내 조건문 총 페이지가 있고 현재 페이지에 따라 endPage 값이 결정됩니다.
		//총 페이지가 14개고 현재 페이지가 9라면 넘어가야 할 페이지가 남 아 있는것이기 때문에 endPage 만큼 반복되고 넘어가야 할 페이지가
		//존재하지 않는 상태라면 마지막 페이지가 포함되어 있는 block 영역이므로 totalPage만큼 반복하게 됩니다
		
		for (int i = startPage; i<=(endPage<totalPage?endPage:totalPage); i++) {
			if(i==currentPage){
				html.append("<li class='page-item active'><span class='page-link'>" + 
						i + "</span></li>");
			} else {
				html.append("<li class='page-item'><a href='' class='page-link' data-page='" +
						i + "'>" + i + "</a></li>");
			}
		}
		if(endPage<totalPage) {
			html.append("<li class='page-item'><a href='' class='page-link' data-page='" + 
					(endPage+1) + "'>Next</a></li>");
		}
		html.append("</ul>");
		return html.toString();
	}
}
