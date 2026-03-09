package spring.ict06team1.midpj.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import spring.ict06team1.midpj.dao.FestivalDAO;

@Service
public class FestivalServiceImpl implements FestivalService {

	@Autowired
	private FestivalDAO dao;
}
