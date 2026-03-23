package spring.ict06team1.midpj.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.ui.Model;

import spring.ict06team1.midpj.dto.FestivalDTO;

public interface ReservationService {
	
	//1. 축제 티켓 리스트 불러오기
	public FestivalDTO getFestivalTickets(int place_id);
	
	//2. 예약+결제 처리(Transaction)
	public void createReservation(HttpServletRequest request, HttpServletResponse response, Model model);
}
