package spring.ict06team1.midpj.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.util.DefaultUriBuilderFactory;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import spring.ict06team1.midpj.SearchCriteria.Paging;
import spring.ict06team1.midpj.dao.AdRestaurantDAO;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;

@Service
public class AdRestaurantServiceImpl implements AdRestaurantService {
	
	@Autowired
	private AdRestaurantDAO adResDao;

	//맛집 등록 조회
	@Override
	public void getRestaurant_list(HttpServletRequest request, HttpServletResponse response, Model model) {
	    System.out.println("AdRestaurantServiceImpl - getRestaurant_list()");
	    
	    // parameter값 수집
	    String pageNum = request.getParameter("pageNum");
	    String areaCode = request.getParameter("areaCode");
	    String category = request.getParameter("category");
	    
	    // 페이징 객체 생성
	    Paging paging = new Paging(pageNum);
	    // 지역코드 담을 map 생성
	    Map<String, Object> map = new HashMap<String, Object>();
	    map.put("areaCode", areaCode);
	    map.put("category", category);
	    
	    // 전체 건수 조회
	    int total = adResDao.placeCnt(map); 
	    System.out.println("total : " + total);
	    paging.setTotalCount(total);
	    map.put("start", paging.getStartRow());
	    map.put("end", paging.getEndRow());
	    
	    // List 타입을 Map으로 선택과 목록 조회
	    List<Map<String, Object>> list = adResDao.placeList(map); 
	    System.out.println("list size : " + (list != null ? list.size() : 0));
	    
	    // model에 값을 담아서 jsp로 전달
	    model.addAttribute("list", list);
	    model.addAttribute("paging", paging);
	    model.addAttribute("areaCode", areaCode);
	    model.addAttribute("category", category);
	    model.addAttribute("totalCount", total);
	}
	
	// 맛집 정보 검색
	@Override
	public void getRestaurantSearch(HttpServletRequest request, HttpServletResponse response, Model model) {
		System.out.println("AdRestaurantServiceImpl - getRestaurantSearch()");
		
		//파라미터로 jsp에서 받은 값 전달
		String areaCode = request.getParameter("areaCode");
		String pageNum = request.getParameter("pageNum");
	    
		// \\d+: 숫자(\d)가 하나 이상(+) 반복된다는 뜻
		if (request.getParameter("keyword") != null && request.getParameter("keyword").matches("\\d+")) {
		    // 숫자인 경우 (0~9로만 구성됨)
		    int keyword = Integer.parseInt(request.getParameter("keyword"));
		    System.out.println("keyword"+keyword);
		    
		    // 페이징 객체 생성
		    Paging paging = new Paging(pageNum);
		    
			// 지역코드 담을 map 생성
		    Map<String, Object> map = new HashMap<String, Object>();
		    map.put("intKeyword", keyword);
		    
			// 전체 건수 조회
		    int total = adResDao.placeCnt(map); 
		    System.out.println("total : " + total);
		    paging.setTotalCount(total);
		    map.put("start", paging.getStartRow());
		    map.put("end", paging.getEndRow());
		    
		    // List 타입을 Map으로 선택과 목록 조회
		    List<Map<String, Object>> list = adResDao.getRestaurantSearchInt(map);
		    System.out.println("list=>"+list);
		    model.addAttribute("list",list);
		    model.addAttribute("keyword",keyword);
		    model.addAttribute("paging", paging);
		    model.addAttribute("areaCode",areaCode);
		    model.addAttribute("totalCount", total);
		    model.addAttribute("pageNum", pageNum);
		} else {
		    // 문자가 포함되어 있거나 null인 경우
			String keyword = request.getParameter("keyword");
			System.out.println("keyword"+keyword);
			
			// 페이징 객체 생성
		    Paging paging = new Paging(pageNum);
		    
			// 지역코드 담을 map 생성
		    Map<String, Object> map = new HashMap<String, Object>();
		    map.put("strKeyword", keyword);
		    
			// 전체 건수 조회
		    int total = adResDao.placeCnt(map); 
		    System.out.println("total : " + total);
		    paging.setTotalCount(total);
		    map.put("start", paging.getStartRow());
		    map.put("end", paging.getEndRow());
		    //둘이상 조회될수있기에 list로 담는다
			List<Map<String, Object>> list = adResDao.getRestaurantSearchString(map);
		    System.out.println("list =>"+list);
		    model.addAttribute("list",list);
		    model.addAttribute("keyword",keyword);
		    model.addAttribute("paging", paging);
		    model.addAttribute("areaCode",areaCode);
		    model.addAttribute("totalCount", total);
		    model.addAttribute("pageNum", pageNum);
		}
	}
	//맛집 정보 등록		
	@Override
	public void getRestaurantInsert(MultipartHttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		System.out.println("AdRestaurantServiceImpl - getRestaurantInsert()");
		
		// "pdImg"라는 파라미터 이름으로 전송된 이미지 파일 객체를 꺼내오기
		MultipartFile file = request.getFile("pdImg");
		System.out.println("file : "+ file);
	
		// input 경로- 폴더먼저 생성 후
		String saveDir = request.getSession().getServletContext().getRealPath("/resources/images/admin/restaurant/");//이거는 이 url을 읽는거다
		System.out.println("saveDir : "+saveDir);
		
		// 서버 내 파일이 물리적으로 저장될 경로
		String realDir = "D:\\DV06\\workspace_git_ict06\\ict06_mid_pj\\src\\main\\webapp\\resources\\images\\admin\\restaurant\\";
		System.out.println("realDir : "+realDir);
		
		// 파일 입출력을 위한 스트림 객체 선언 (사용 후 반드시 close 처리 필요)
		FileInputStream fis = null;
		FileOutputStream fos = null;
	
		String p_img1 ="";
		if(file.getOriginalFilename() != null && !file.getOriginalFilename().isEmpty()) {
			
		    // 파일명 중복 방지: 현재 시간을 밀리초 단위로 붙임 (예: 1741570123_스크린샷(4).png)
		    String originalName = file.getOriginalFilename();
		    String saveFileName = System.currentTimeMillis() + "_" + originalName.replace(" ", "_");
		
		    try {
		        // C드라이브(서버 실행 경로)에 저장 - 이름이 다름으로 에러 안 남!
		        File saveFile = new File(saveDir + "/" + saveFileName);
		        file.transferTo(saveFile); 
		
		        // 저장할 대상 파일(원본)을 읽어오기 위한 통로(Stream)를 생성
		        fis = new FileInputStream(saveFile);
		        
		        // 지정된 경로(realDir)에 새 파일 이름(saveFileName)으로 기록하기 위한 통로를 생성
		        fos = new FileOutputStream(new File(realDir + "/" + saveFileName));
		        
		        // 데이터를 한 번에 옮길 바구니(버퍼)를 1KB(1024바이트) 크기로 준비
		        byte[] buffer = new byte[1024];
		        int len;
		        
		        // 원본 파일에서 데이터를 읽어와(read) 버퍼에 담고, 파일 끝(-1)에 도달할 때까지 대상 파일에 쓴다(write).
		        while ((len = fis.read(buffer)) != -1) {
		            fos.write(buffer, 0, len);
	        	}
	        
		        // 서버 상의 웹 애플리케이션 식별 경로(Context Path)를 동적으로 가져옴
		        // ict06_team1_midpj 
		        String contextPath = request.getContextPath(); 
		        // DB에 저장할 최종 이미지 접근 경로(URL)를 조립
		        p_img1 = contextPath + "/resources/images/admin/restaurant/" + saveFileName;
		        System.out.println("새로운 이미지 경로 할당 완료: " + p_img1);
			
			}catch(IOException e) {
				e.printStackTrace();
			}finally {
				if(fis != null) fis.close();
				if(fos != null) fos.close();
			}
		}
		
		// 값 담을 객체 생성과 값 담기
		PlaceDTO pDto = new PlaceDTO();
	    pDto.setPlace_type("rest"); 
	    pDto.setName(request.getParameter("pdName"));
	    
	    // 상세주소와 우편주소 합치기
	    String address_detail = request.getParameter("address_detail");
	    String address = request.getParameter("address");
	    String fullAddress = address;
	    
	    if (address_detail != null && !address_detail.trim().isEmpty()) {
	        fullAddress += " - " + address_detail; 
	    }
	    pDto.setAddress(fullAddress);
	    pDto.setImage_url(p_img1);
	    pDto.setLatitude(Double.parseDouble(request.getParameter("latitude"))); 
	    pDto.setLongitude(Double.parseDouble(request.getParameter("longitude")));
	    
	    RestaurantDTO rDto = new RestaurantDTO();
	    rDto.setPhone(request.getParameter("phone"));
	    rDto.setCategory(request.getParameter("category"));
	    rDto.setDescription(request.getParameter("pdContent"));
	    rDto.setRestdate(request.getParameter("restdate"));
	    rDto.setAreaCode(request.getParameter("areaCode"));
		
		// 부모테이블(PLACE) 먼저 insert
		int placeCnt = adResDao.getPlaceInsert(pDto);
		int insertCnt = 0;
		
		// 부모테이블 insert 성공 여부 확인
		if(placeCnt > 0) {
			//생성된 pk 가져오기
			int place_id = pDto.getPlace_id();
			//자식테이블(restaurant) fk 설정
			rDto.setRestaurant_id(place_id);
			//자식테이블에 데이터 insert
			insertCnt = adResDao.getRestaurantInsert(rDto);
		}
		
		// 페이지번호 model에 담아 jsp에 전달
		String pageNum1 = request.getParameter("pageNum");
		if (pageNum1 == null || pageNum1.trim().isEmpty()) {
	        pageNum1 = "1";
	    }
		int pageNum = Integer.parseInt(pageNum1);
		//jsp에서 받은 areaCode1/ category1/ keyword model에 담기 -> 이전 화면에서 했던 페이지번호, 필터 내용 등록 완료후 다시 목록 화면 돌아갈 시에도 유지하기 위함 
		String areaCode = request.getParameter("areaCode1");
		String category = request.getParameter("category1");
		String keyword = request.getParameter("keyword");
		// model에 각가 값 넣고 jsp로 전달
		model.addAttribute("pageNum",pageNum);
		model.addAttribute("areaCode",areaCode);
		model.addAttribute("insertCnt",insertCnt);
		model.addAttribute("category",category);
		model.addAttribute("keyword",keyword);
		System.out.println("insertCnt"+insertCnt);
	}
	
	// 맛집 정보 상세 조회
	@Override
	public void getRestaurantDetail(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		System.out.println("AdRestaurantServiceImpl - getRestaurantDetail()");
		
		// parameter로 place_id와 pageNum 그리고 areaCode값 전달받음 그리고 정수형으로 변환
		int place_id = Integer.parseInt(request.getParameter("place_id"));
		String pageNum1 = request.getParameter("pageNum");
		String category = request.getParameter("category");
		String keyword = request.getParameter("keyword");
		if (pageNum1 == null || pageNum1.trim().isEmpty()) {
	        pageNum1 = "1";
	    }
		int pageNum = Integer.parseInt(pageNum1);
		String areaCode = request.getParameter("areaCode");
		
		// dao쪽 메서드 호출로 place_id값 DB에 전달과 함께 WHERE PLACE_ID = place_id와 일치하는 값들 다시 가져옴 
		PlaceDTO pDto = adResDao.getPlaceDetail(place_id);
		RestaurantDTO rDto = adResDao.getRestaurantDetail(place_id);
		System.out.println("코드"+rDto.getCategory());
		System.out.println("코드"+rDto.getPhone());
		
		//model에 값을 넣어 jsp에 전달
		model.addAttribute("pDto", pDto);
		model.addAttribute("rDto", rDto);
		model.addAttribute("pageNum", pageNum);
		model.addAttribute("areaCode", areaCode);
		model.addAttribute("category",category);
		model.addAttribute("keyword", keyword);
	}
	
	// 맛집 정보 수정
	@Override
	public void getRestaurantUpdateAction(MultipartHttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
		System.out.println("AdRestaurantServiceImpl - getRestaurantUpdateAction()");
		
		// parameter로 jsp의 값 전달 받기
		String pageNum = request.getParameter("pageNum");
		int hiddenPageNum = Integer.parseInt(request.getParameter("pageNum")); 
		String oldImg = request.getParameter("oldImg");
		String areaCode1 = request.getParameter("areaCode1");
		String category1 = request.getParameter("category1");
		String keyword = request.getParameter("keyword");
		System.out.println("hiddenPageNum : "+hiddenPageNum);
		System.out.println("oldImg : "+oldImg);
		System.out.println("areaCode1 : "+areaCode1);
		System.out.println("category1 : "+category1);
		System.out.println("keyword : "+keyword);
		
		// 수정한이미지 객체 MultipartFile로 받기 
		MultipartFile file = request.getFile("pdImg");
		System.out.println("file : "+file);
		
		// input 경로- 폴더먼저 생성 후
		String saveDir = request.getSession().getServletContext().getRealPath("/resources/images/admin/restaurant/");//이거는 이 url을 읽는거다
		System.out.println("saveDir : "+saveDir);
		
		// 서버 내 파일이 물리적으로 저장될 경로
		String realDir = "D:\\DV06\\workspace_git_ict06\\ict06_mid_pj\\src\\main\\webapp\\resources\\images\\admin\\restaurant\\";
		System.out.println("realDir : "+realDir);
		
		// 파일 입출력을 위한 스트림 객체 선언 (사용 후 반드시 close 처리 필요)
		FileInputStream fis = null;
		FileOutputStream fos = null;
		
		String p_img1 ="";
		//상세페이지에 있는 이미지를 수정할 경우
		if(file.getOriginalFilename() != null && !file.getOriginalFilename().isEmpty()) {
			
		    // 파일명 중복 방지: 현재 시간을 밀리초 단위로 붙임 (예: 1741570123_스크린샷(4).png)
		    String originalName = file.getOriginalFilename();
		    String saveFileName = System.currentTimeMillis() + "_" + originalName.replace(" ", "_");
		    try {
		        // C드라이브(서버 실행 경로)에 저장 - 이름이 다름으로 에러 안 남!
		        File saveFile = new File(saveDir + "/" + saveFileName);
		        file.transferTo(saveFile); 
		        // D드라이브(워크스페이스)로 복사
		        fis = new FileInputStream(saveFile);
		        fos = new FileOutputStream(new File(realDir + "/" + saveFileName));
		        // 데이터를 한 번에 옮길 바구니(버퍼)를 1KB(1024바이트) 크기로 준비
		        byte[] buffer = new byte[1024];
		        int len;
		        // 원본 파일에서 데이터를 읽어와(read) 버퍼에 담고, 파일 끝(-1)에 도달할 때까지 대상 파일에 쓴다(write).
		        while ((len = fis.read(buffer)) != -1) {
		            fos.write(buffer, 0, len);
		        }
		        String contextPath = request.getContextPath(); // /ict06_team1_midpj 
		        p_img1 = contextPath + "/resources/images/admin/restaurant/" + saveFileName;
		        System.out.println("새로운 이미지 경로 할당 완료: " + p_img1);
		}catch(IOException e) {
			e.printStackTrace();
		}finally {
			if(fis != null) fis.close();
			if(fos != null) fos.close();
		}
	}
		
	// 기존 이미지를 가지고 수정한다면
	else {
		p_img1= oldImg;
		System.out.println("p_img1 : "+p_img1);
	}
		// 객체 생성해서 jsp에서의 값 전달받음
		PlaceDTO pDto = new PlaceDTO();
		RestaurantDTO rDto = new RestaurantDTO();
		
		// 맛집등록
		pDto.setPlace_id(Integer.parseInt((request.getParameter("place_id"))));
	    pDto.setPlace_type("rest"); 
	    pDto.setName(request.getParameter("pdName"));
	    String address_detail = request.getParameter("address_detail");
	    String address = request.getParameter("address");
	    // 상세주소와 우편주소 합치기
	    String fullAddress = address;
	    if (address_detail != null && !address_detail.trim().isEmpty()) {
	        fullAddress += " - " + address_detail; 
	    }
	    pDto.setAddress(fullAddress);
	    pDto.setImage_url(p_img1);
	    pDto.setLatitude(Double.parseDouble(request.getParameter("latitude"))); 
	    pDto.setLongitude(Double.parseDouble(request.getParameter("longitude")));
	    pDto.setView_count(0); 
	    
	    rDto.setRestaurant_id(Integer.parseInt((request.getParameter("place_id"))));
	    rDto.setPhone(request.getParameter("phone"));
	    rDto.setCategory(request.getParameter("category"));
	    rDto.setDescription(request.getParameter("pdContent"));
	    rDto.setRestdate(request.getParameter("restdate"));
	    rDto.setAreaCode(request.getParameter("areaCode"));
	    rDto.setStatus("open");
		
	    // updateCntP = 1 인 경우, 즉 수정 성공 할 경우 레스토랑 업데이트 진행
	    int updateCntP = adResDao.getPlaceUpdateAction(pDto);
	    int updateCntR = 0;
	    if(updateCntP >0) {
	    	updateCntR = adResDao.getRestaurantUpdateAction(rDto);
	    }
	    // 각각의 값들 model에 담아서 jsp로 전달
		model.addAttribute("updateCnt",updateCntR);
		model.addAttribute("hiddenPageNum",hiddenPageNum);
		model.addAttribute("areaCode1",areaCode1);
		model.addAttribute("category1",category1);
		model.addAttribute("keyword",keyword);
		
		System.out.println("수정 후 areaCode 확인 : " + areaCode1);
		System.out.println("전달된 맛집 이름: " + pDto.getName());
		System.out.println("전달된 상세 설명: " + rDto.getDescription());
		System.out.println("전달된 장소 ID: " + pDto.getPlace_id());
	}
	
	//맛집 정보 삭제
	@Override
	public void getRestaurantDeleteAction(HttpServletRequest request, HttpServletResponse response, Model model)
	        throws ServletException, IOException {
	    System.out.println("AdRestaurantServiceImpl - getRestaurantDeleteAction()");
	    
	    // 1. 파라미터를 먼저 문자열로 다 받는다.
	    String strPlace_id = request.getParameter("place_id");
	    String pageNum = request.getParameter("pageNum");
	    String areaCode = request.getParameter("areaCode");
	    String category = request.getParameter("category");
	    String keyword = request.getParameter("keyword");
	    int deleteCnt = 0;

	    // 2. [오류 해결 포인트] place_id가 있을 때만 삭제 로직 실행
	    if (strPlace_id != null && !strPlace_id.trim().isEmpty()) {
	        int place_id = Integer.parseInt(strPlace_id); // 이제 여기서 null 에러 안 납니다.
	        deleteCnt = adResDao.getRestaurantDeleteAction(place_id);
	    }
	    
	    // 3. 기본값 설정 (null 방지)
	    if (pageNum == null || pageNum.isEmpty()) pageNum = "1";
	    if (areaCode == null) areaCode = "";

	    // 4. 모델에 담기 (컨트롤러에서 redirect 시 꺼내 쓸 수 있게 함)
	    model.addAttribute("deleteCnt", deleteCnt);
	    model.addAttribute("pageNum", pageNum);
	    model.addAttribute("areaCode", areaCode);
	    model.addAttribute("category", category);
	    model.addAttribute("keyword",keyword);
	}
	
	//공공데이터 활용 맛집 정보 내려받기(place 테이블쪽)
	@Override
	public void testRegister(HttpServletRequest request, HttpServletResponse response, Model model) 
	        throws ServletException, IOException {
	    // 1. 요청 파라미터에서 지역 코드(keyword)를 가져옴
	    String areaCode = request.getParameter("keyword");
	    int pageNo = 1; // 기본 페이지 번호 설정
	    
	    // 2. 지역 코드가 없으면 기본값 "1"(서울)로 설정
	    if (areaCode == null || areaCode.isEmpty()) areaCode = "1";
	    
	    // 3. 특정 조건("1-1")인 경우 서울의 2페이지 데이터를 가져오도록 설정
	    if(areaCode.equals("1-1")) {
	        areaCode = "1";
	        pageNo = 2;
	    }
	    
	    // 4. 성공 횟수를 저장할 카운터 변수 초기화
	    int successCountRes = 0;   // 맛집 정보 저장 성공 횟수
	    int successCountPlace = 0; // 장소 정보 저장 성공 횟수
	    
	    // 5. 공공데이터포털 API 서비스 키
	    String serviceKey = "526ab31ed6f40d4a2fded084267086cc0cab748473a9be6448f06b8d14cc9c23";

	    // 6. 외부 API 호출을 위한 RestTemplate과 JSON 파싱을 위한 ObjectMapper 생성
	    RestTemplate restTemplate = new RestTemplate();
	    ObjectMapper mapper = new ObjectMapper();

	    try {
	        // 7. [1단계] 지역 기반 관광 정보 목록 조회 API URL 생성 (음식점 타입: contentTypeId=39)
	        String url = "https://apis.data.go.kr/B551011/KorService2/areaBasedList2?serviceKey=" + serviceKey
	                + "&areaCode=" + areaCode
	                + "&contentTypeId=39"
	                + "&MobileOS=ETC&MobileApp=AppTest&_type=json&numOfRows=100"
	                + "&pageNo="+pageNo;

	        // 8. API 호출 및 JSON 응답 받기
	        String jsonResponse = restTemplate.getForObject(url, String.class);
	        
	        // 9. 응답받은 JSON에서 실제 아이템 목록(item) 노드까지 접근
	        JsonNode items = mapper.readTree(jsonResponse).path("response").path("body").path("items").path("item");

	        // 10. 아이템 목록이 배열 형태인지 확인 후 반복문 실행
	        if (items.isArray()) {
	            for (JsonNode item : items) {
	                // 11. 각 아이템의 콘텐츠 ID와 대표 이미지 URL 추출
	                String contentId = item.path("contentid").asText().trim();
	                String imageUrl = item.path("firstimage").asText("");
	                
	                // 12. [필터링] 이미지가 없는 장소는 우리 서비스 품질을 위해 저장하지 않고 건너뜀
	                if (imageUrl == null || imageUrl.trim().isEmpty()) {
	                    System.out.println(">>> [건너뛰기] 이미지 정보가 없는 장소입니다.");
	                    continue; 
	                }
	                
	                // 13. [중복 체크] 이미 DB에 존재하는 contentId인지 확인하여 중복 저장 방지
	                if (adResDao.checkDuplicate(contentId) > 0) continue;

	                // 14. DTO 객체 생성 및 기본 정보 세팅 (Place: 공통 정보, Restaurant: 음식점 전용)
	                RestaurantDTO rdto = new RestaurantDTO();
	                PlaceDTO pdto = new PlaceDTO();
	                
	                pdto.setPlace_id(Integer.parseInt(contentId));
	                rdto.setRestaurant_id(Integer.parseInt(contentId));
	                pdto.setName(item.path("title").asText("")); // 가게명
	                pdto.setAddress(item.path("addr1").asText()); // 주소
	                pdto.setImage_url(imageUrl); // 이미지 경로
	                pdto.setLongitude(item.path("mapx").asDouble()); // 경도
	                pdto.setLatitude(item.path("mapy").asDouble());  // 위도
	                rdto.setPhone(item.path("tel").asText("")); // 전화번호
	                rdto.setAreaCode(item.path("areacode").asText("")); // 지역 코드

	                // 15. [2단계] 공통 상세 정보(카테고리 등) 수집을 위한 추가 메서드 호출
	                testRegisterDetail(contentId, rdto);
	                
	                // 16. [3단계] 소개 정보(개요 등) 수집을 위한 추가 메서드 호출
	                testRegisterIntro(contentId, rdto);
	                
	                // 17. PLACE 테이블에 기본 정보 저장 후 카운트 증가
	                if (adResDao.testInsertPlace(pdto) > 0) {
	                    successCountPlace++;
	                }
	                
	                // 18. RESTAURANT 테이블에 상세 정보 저장 후 카운트 증가
	                if(adResDao.testInsertRes(rdto)> 0) {
	                    successCountRes++;
	                }
	            }
	        }
	        
	        // 19. 수집 결과 로그 출력
	        System.out.println("🚩 place 수집 완료 : " + successCountPlace + "건");
	        System.out.println("🚩 RESTAURANT 수집 완료 : " + successCountRes + "건");

	    } catch (Exception e) {
	        // 20. 에러 발생 시 스택 트레이스 출력
	        e.printStackTrace();
	    }
	    
	    // 21. 화면(JSP)에 수집된 결과 건수를 보여주기 위해 모델에 저장
	    model.addAttribute("countPlace", successCountPlace);
	    model.addAttribute("countRes", successCountRes);
	}
	
	// [메서드 추가] 소개 정보 조회 (영업시간, 휴무일, 주차시설 등)
	@Override
	public void testRegisterIntro(String contentId, RestaurantDTO rdto) {
	    
	    // 1. API 접근을 위한 인증키 설정
	    String serviceKey = "526ab31ed6f40d4a2fded084267086cc0cab748473a9be6448f06b8d14cc9c23";
	    
	    // 2. 외부 API 호출을 위한 RestTemplate 설정
	    RestTemplate restTemplate = new RestTemplate();
	    DefaultUriBuilderFactory factory = new DefaultUriBuilderFactory();
	    
	    // 3. 서비스 키에 포함된 특수문자(%, + 등)가 변형되지 않도록 인코딩 모드를 NONE으로 설정
	    factory.setEncodingMode(DefaultUriBuilderFactory.EncodingMode.NONE); 
	    restTemplate.setUriTemplateHandler(factory);

	    // 4. 소개 정보 전용 API(detailIntro2) URL 생성 (음식점 타입인 39번 필수 지정)
	    String url = "https://apis.data.go.kr/B551011/KorService2/detailIntro2?serviceKey=" + serviceKey
	            + "&contentId=" + contentId
	            + "&contentTypeId=39"
	            + "&MobileOS=ETC&MobileApp=AppTest&_type=json";

	    try {
	        ObjectMapper mapper = new ObjectMapper();
	        // 5. API로부터 JSON 응답 문자열을 받아옴
	        String res = restTemplate.getForObject(url, String.class);
	        
	        // 6. JSON 트리 구조에서 item 노드를 찾아감
	        JsonNode itemNode = mapper.readTree(res).path("response").path("body").path("items").path("item");

	        // 7. API 응답이 배열 형태인 경우 첫 번째 요소를 가져오고, 아니면 바로 노드를 선택
	        JsonNode item = itemNode.isArray() ? itemNode.get(0) : itemNode;

	        // 8. 수집된 데이터가 유효한지 확인
	        if (item != null && !item.isMissingNode()) {
	            // 9. 음식점 전용 필드인 '휴무일(restdatefood)' 정보 추출
	            String restdate = item.path("restdatefood").asText("");
	            
	            // 10. 값이 비어있을 경우 null로 처리하여 후속 로직 오류 방지
	            if (restdate == null || restdate.isEmpty()) restdate = null ;

	            // 11. [전처리] DB 컬럼 크기에 맞추기 위해 불필요한 단어들을 짧게 축약 (부피 줄이기)
	            // 예: "매주 월요일" -> "월", "연중무휴" -> "무휴"
	            String compressed = restdate.replaceAll("\\s+", "")  // 모든 공백 제거
	                                    .replace("요일", "")      // '요일' 삭제
	                                    .replace("매주", "")      // '매주' 삭제
	                                    .replace("연중무휴", "무휴")
	                                    .replace("공휴일", "공휴")
	                                    .replace("마지막주", "막주")
	                                    .replace("첫째주", "1주")
	                                    .replace("둘째주", "2주");

	            // 12. [안전 장치] DB의 VARCHAR2(30) 등 한정된 크기를 넘지 않도록 30바이트 단위 절삭
	            int maxByte = 30;
	            StringBuilder sb = new StringBuilder();
	            int currentByte = 0;

	            // 13. 문자열을 한 글자씩 돌면서 바이트 수 계산 (한글 깨짐 방지 로직)
	            for (char c : compressed.toCharArray()) {
	                try {
	                    // 14. UTF-8 기준으로 한글은 3바이트, 영어/숫자는 1바이트로 계산
	                    int charByte = String.valueOf(c).getBytes("UTF-8").length;
	                    
	                    // 15. 현재 누적 바이트가 30바이트 이하일 때만 결과 문자열에 추가
	                    if (currentByte + charByte <= maxByte) {
	                        sb.append(c);
	                        currentByte += charByte;
	                    } else {
	                        // 16. 30바이트를 초과하게 되면 반복 중단 (데이터 유실 최소화하며 절단)
	                        break; 
	                    }
	                } catch (java.io.UnsupportedEncodingException e) {
	                    break;
	                }
	            }
	            
	            // 17. 최종 가공된 휴무일 정보를 DTO에 저장
	            rdto.setRestdate(sb.toString());
	            System.out.println(">>> " + contentId + " 소개 정보(영업/주차) 수집 완료");
	        } else {
	            // 18. 데이터가 아예 없는 경우 빈 문자열 세팅
	            rdto.setRestdate("");
	        }
	    } catch (Exception e) {
	        // 19. 네트워크 장애나 파싱 오류 발생 시 에러 메시지 출력
	        System.err.println("소개 정보 수집 에러: " + e.getMessage());
	    }
	}

	// 2. 수정된 공통 상세 정보 메서드 (YN 파라미터 모두 제거)
	@Override
	public void testRegisterDetail(String contentId, RestaurantDTO rdto) {
	    
	    // 1. 공공데이터 API 호출을 위한 인증키(Service Key) 설정
	    String serviceKey = "526ab31ed6f40d4a2fded084267086cc0cab748473a9be6448f06b8d14cc9c23";
	    
	    // 2. Spring에서 제공하는 HTTP 통신 객체 RestTemplate 생성
	    RestTemplate restTemplate = new RestTemplate();
	    
	    // 3. API 요청 URL 빌더 팩토리 생성
	    DefaultUriBuilderFactory factory = new DefaultUriBuilderFactory();
	    
	    // 4. [매우 중요] 인증키 내의 특수문자가 인코딩되어 API 호출이 실패하는 것을 방지하기 위해 
	    // 인코딩 모드를 NONE(인코딩 하지 않음)으로 설정
	    factory.setEncodingMode(DefaultUriBuilderFactory.EncodingMode.NONE); 
	    restTemplate.setUriTemplateHandler(factory);

	    // 5. [API 요청 URL 구성] detailCommon2 오퍼레이션을 사용
	    // 최신 공공데이터 매뉴얼 규격에 맞춰 불필요한 YN(Yes/No) 파라미터들을 모두 제거하여 호출 최적화
	    String url = "https://apis.data.go.kr/B551011/KorService2/detailCommon2?serviceKey=" + serviceKey
	            + "&contentId=" + contentId
	            + "&MobileOS=ETC&MobileApp=AppTest&_type=json";

	    try {
	        // 6. JSON 파싱을 위한 Jackson 라이브러리의 ObjectMapper 객체 생성
	        ObjectMapper mapper = new ObjectMapper();
	        
	        // 7. 구성된 URL로 GET 요청을 보내 응답 결과를 String 형태로 수신
	        String res = restTemplate.getForObject(url, String.class);
	        
	        // 8. JSON 응답 결과에서 실제 데이터가 담긴 item 노드까지 경로 추적
	        JsonNode itemNode = mapper.readTree(res).path("response").path("body").path("items").path("item");

	        // 9. 결과 데이터가 리스트(Array) 형태면 첫 번째 요소를 가져오고, 단일 객체면 그대로 선택
	        JsonNode item = itemNode.isArray() ? itemNode.get(0) : itemNode;

	        // 10. 노드가 존재하고 유효한 데이터가 있는지 확인
	        if (!item.isMissingNode()) {
	            
	            // 11. 'overview' 필드에서 맛집의 전체적인 개요(상세 설명)를 가져와 DTO에 저장
	            rdto.setDescription(item.path("overview").asText(""));
	            
	            // 12. 'cat3' 필드에서 소분류 카테고리 코드(예: 한식, 중식 등)를 가져와 DTO에 저장
	            rdto.setCategory(item.path("cat3").asText(""));
	            
	            // 13. 콘솔에 수집 성공 여부 출력
	            System.out.println(">>> " + contentId + " 공통 상세 수집 완료");
	        }
	    } catch (Exception e) {
	        // 14. 통신 오류나 데이터 파싱 중 에러 발생 시 에러 메시지 출력
	        System.err.println("공통 상세 에러: " + e.getMessage());
	    }
	}
}