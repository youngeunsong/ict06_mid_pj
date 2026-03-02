package spring.ict06team1.midpj.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import spring.ict06team1.midpj.dao.CommunityDAO;

@Service
public class CommunityServiceImpl implements CommunityService {
	
	@Autowired
	private CommunityDAO dao;

}
