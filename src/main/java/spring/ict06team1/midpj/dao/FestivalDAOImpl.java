package spring.ict06team1.midpj.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class FestivalDAOImpl implements FestivalDAO {
	
	@Autowired
	private SqlSession session;

}
