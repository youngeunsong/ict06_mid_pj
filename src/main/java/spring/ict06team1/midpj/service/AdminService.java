package spring.ict06team1.midpj.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

@Service
public interface AdminService {

	public void getReservationList(HttpServletRequest request, HttpServletResponse response, Model model);

	public void getReservationDetail(HttpServletRequest request, HttpServletResponse response, Model model);

	public void modifyReservationStatus(HttpServletRequest request, HttpServletResponse response, Model model);

	public void cancelReservation(HttpServletRequest request, HttpServletResponse response, Model model);

	public void getReservationStatistics(HttpServletRequest request, HttpServletResponse response, Model model);

}
