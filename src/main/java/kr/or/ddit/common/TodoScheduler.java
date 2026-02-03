package kr.or.ddit.common;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import kr.or.ddit.dashboard.mapper.ITodoMapper;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class TodoScheduler {
	
	@Autowired
	private ITodoMapper todoMapper;
	
	// 매일 자정에 실행
	@Scheduled(cron = "0 0 0 * * *")
	public void autoDeleteTodo() {
		log.info("autoDeleteTodo() 실행...!");
		
		// todoMapper.deleteCompletedTodo();
		System.out.println("완료된 to do 삭제");
	}
}
