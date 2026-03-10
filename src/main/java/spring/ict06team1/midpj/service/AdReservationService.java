package spring.ict06team1.midpj.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

public interface AdReservationService {
	
	public void getReservationList(HttpServletRequest request, HttpServletResponse response, Model model);

	public void getReservationDetail(HttpServletRequest request, HttpServletResponse response, Model model);

	public void modifyReservation(HttpServletRequest request, HttpServletResponse response, Model model);

	public void cancelReservation(HttpServletRequest request, HttpServletResponse response, Model model);

	public void getDashboard(HttpServletRequest request, HttpServletResponse response, Model model);

}
