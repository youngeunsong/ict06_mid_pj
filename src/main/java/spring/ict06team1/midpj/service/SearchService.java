package spring.ict06team1.midpj.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

public interface SearchService {

	public void getSearchList(HttpServletRequest request, HttpServletResponse response, Model model);
}
