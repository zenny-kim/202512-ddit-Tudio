package kr.or.ddit.dashboard.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class DashboardViewController {

    @GetMapping("/tudio/dashboard") 
    public String dashboard() {
        return "dashboard"; 
    }
}