package spring.ict06team1.midpj.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class AccommodationDAOImpl implements AccommodationDAO {
	
	@Autowired
	private SqlSession sqlSession;

}
