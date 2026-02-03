package kr.or.ddit.dashboard.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.ddit.common.WidgetType;
import kr.or.ddit.dashboard.mapper.ITodoMapper;
import kr.or.ddit.dashboard.service.ITodoService;
import kr.or.ddit.dashboard.service.IWidgetUpdateService;
import kr.or.ddit.vo.TodoVO;

@Service
public class TodoServiceImpl implements ITodoService {

	@Autowired
	private ITodoMapper todoMapper;
	
	// 위젯 갱신 서비스
    @Autowired
    private IWidgetUpdateService widgetUpdateService;
	
	@Override
	public List<TodoVO> selectTodoList(TodoVO todoVO) {
		return todoMapper.selectTodoList(todoVO);
	}

	@Override
	public int insertTodo(TodoVO todoVO) {
		int result = todoMapper.insertTodo(todoVO);
		if(result > 0) {			
			widgetUpdateService.sendWidgetUpdate(todoVO.getMemberNo(), WidgetType.TODO);
		}
		return result;
	}

	@Override
	public int updateTodoStatus(TodoVO todoVO) {
		int result = todoMapper.updateTodoStatus(todoVO);
		if(result > 0) {
			widgetUpdateService.sendWidgetUpdate(todoVO.getMemberNo(), WidgetType.TODO);
		}
		return result;
	}
	
	@Override
    public int updateTodoContent(TodoVO todoVO) {
		int result = todoMapper.updateTodoContent(todoVO);
		if(result > 0) {
			widgetUpdateService.sendWidgetUpdate(todoVO.getMemberNo(), WidgetType.TODO);
		}
        return result;
    }

	@Override
	public int deleteTodo(TodoVO todoVO) {
		int result = todoMapper.deleteTodo(todoVO);
		if(result > 0) {
			widgetUpdateService.sendWidgetUpdate(todoVO.getMemberNo(), WidgetType.TODO);
		}
		return result;
	}
	
}
