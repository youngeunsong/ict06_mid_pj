package spring.ict06team1.midpj.dao;

import java.util.List;
import java.util.Map;

import spring.ict06team1.midpj.dto.PlaceDTO;

public interface SearchDAO {

	public List<PlaceDTO> getSearchList(Map<String, Object> map);
}
