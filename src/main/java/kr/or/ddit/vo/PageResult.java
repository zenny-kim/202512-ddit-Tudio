package kr.or.ddit.vo;

import java.util.Collections;
import java.util.List;

import lombok.Data;

@Data
public class PageResult<T> {
	private List<T> dataList;	// 목록 데이터
	private Object pageInfo;	// 페이징 정보
	
	public PageResult(List<T> dataList, Object pageInfo) {
		if(dataList == null) {
			this.dataList = Collections.emptyList();
		}else {
			this.dataList = dataList;
		}
		
		this.pageInfo = pageInfo;
	}
}
