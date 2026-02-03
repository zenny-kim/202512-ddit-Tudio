package kr.or.ddit.dashboard.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.ddit.vo.TodoVO;

@Mapper
public interface ITodoMapper {	
	
	// 1. 사용자 to do list 조회
	public List<TodoVO> selectTodoList(TodoVO todoVO);
	
	// 2. 할 일 목록 추가
	public int insertTodo(TodoVO todoVO);
	
	// 3. 할 일 완료 (상태변경)
	public int updateTodoStatus(TodoVO todoVO);
	
	// 4. 할 일 수정
	public int updateTodoContent(TodoVO todoVO); 

	// 5. 할 일 삭제
	public int deleteTodo(TodoVO todoVO);
	
	// 6. 자동 삭제 스케줄러 : 완료된 항목 삭제 (기준: 어제 이전)
	// public void deleteCompletedTodo();
	
   
}
