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

import spring.ict06team1.midpj.dao.AdminDAOImpl;
import spring.ict06team1.midpj.dto.PlaceDTO;
import spring.ict06team1.midpj.dto.RestaurantDTO;
import spring.ict06team1.midpj.page.Paging;

@Service
public class AdminServiceImpl implements AdminService {

	@Autowired
	private AdminDAOImpl admindao;
	
	//------------------------------------------------------------------------------------------
	//맛집 기본데이터 등록
	@Override
	public void testRegister(HttpServletRequest request, HttpServletResponse response, Model model) 
			throws ServletException, IOException {
	    String areaCode = request.getParameter("keyword");
	    int pageNo = 1;
	    if (areaCode == null || areaCode.isEmpty()) areaCode = "1";
	    if(areaCode.equals("1-1")) {
	    	areaCode = "1";
	    	pageNo = 2;
	    }
	    int successCountRes = 0;
	    int successCountPlace = 0;
	    String serviceKey = "526ab31ed6f40d4a2fded084267086cc0cab748473a9be6448f06b8d14cc9c23";

	    RestTemplate restTemplate = new RestTemplate();
	    ObjectMapper mapper = new ObjectMapper();

	    try {
	        //1. 지역 기반 목록 조회
	        String url = "https://apis.data.go.kr/B551011/KorService2/areaBasedList2?serviceKey=" + serviceKey
	                + "&areaCode=" + areaCode
	                + "&contentTypeId=39"
	                + "&MobileOS=ETC&MobileApp=AppTest&_type=json&numOfRows=1000"
	                + "&pageNo="+pageNo;

	        String jsonResponse = restTemplate.getForObject(url, String.class);
	        JsonNode items = mapper.readTree(jsonResponse).path("response").path("body").path("items").path("item");

	        if (items.isArray()) {
	            for (JsonNode item : items) {
	                String contentId = item.path("contentid").asText().trim();
	                String imageUrl = item.path("firstimage").asText("");
	                
	                // 1. 이미지가 없거나 비어있는 경우 저장하지 않고 다음 아이템으로 건너뜀
	                if (imageUrl == null || imageUrl.trim().isEmpty()) {
	                    System.out.println(">>> [건너뛰기] 이미지 정보가 없는 장소입니다.");
	                    continue; 
	                }
	                // 중복 체크
	                if (admindao.checkDuplicate(contentId) > 0) continue;

	                RestaurantDTO rdto = new RestaurantDTO();
	                PlaceDTO pdto = new PlaceDTO();
	                pdto.setPlace_id(Integer.parseInt(contentId));
	                rdto.setRestaurant_id(Integer.parseInt(contentId));
	                pdto.setName(item.path("title").asText(""));
	                pdto.setAddress(item.path("addr1").asText());
	                pdto.setImage_url(imageUrl);
	                pdto.setLongitude(item.path("mapx").asDouble());
	                pdto.setLatitude(item.path("mapy").asDouble());
	                rdto.setPhone(item.path("tel").asText(""));
	                rdto.setAreaCode(item.path("areaCode").asText("")); 

	                // 2️⃣ 공통 상세 정보 호출 (개요, 카테고리 등)
	                testRegisterDetail(contentId, rdto);
	                testRegisterIntro(contentId, rdto);
	                
	                if (admindao.testInsertPlace(pdto) > 0) {
	                    successCountPlace++;
	                }
	                
	                if(admindao.testInsertRes(rdto)> 0) {
	                    successCountRes++;
	                }

	                
	            }
	        }
	        System.out.println("🚩 place 수집 완료 : " + successCountPlace + "건");
	        System.out.println("🚩 RESTAURANT 수집 완료 : " + successCountRes + "건");

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    model.addAttribute("countPlace", successCountPlace);
	    model.addAttribute("countRes", successCountRes);
	}
	
	// [메서드 추가] 소개 정보 조회 (영업시간, 휴무일, 주차시설 등)
	@Override
	public void testRegisterIntro(String contentId, RestaurantDTO rdto) {
		
	    String serviceKey = "526ab31ed6f40d4a2fded084267086cc0cab748473a9be6448f06b8d14cc9c23";
	    
	    RestTemplate restTemplate = new RestTemplate();
	    DefaultUriBuilderFactory factory = new DefaultUriBuilderFactory();
	    factory.setEncodingMode(DefaultUriBuilderFactory.EncodingMode.NONE); 
	    restTemplate.setUriTemplateHandler(factory);

	    // detailIntro1 오퍼레이션 사용 (contentTypeId=39 필수)
	    String url = "https://apis.data.go.kr/B551011/KorService2/detailIntro2?serviceKey=" + serviceKey
	            + "&contentId=" + contentId
	            + "&contentTypeId=39"
	            + "&MobileOS=ETC&MobileApp=AppTest&_type=json";

	    try {
	        ObjectMapper mapper = new ObjectMapper();
	        String res = restTemplate.getForObject(url, String.class);
	        JsonNode itemNode = mapper.readTree(res).path("response").path("body").path("items").path("item");

	        JsonNode item = itemNode.isArray() ? itemNode.get(0) : itemNode;

	        if (item != null && !item.isMissingNode()) {
	            // 음식점(39) 전용 필드 매핑
	            rdto.setOpentime(item.path("opentimefood").asText("")); // 영업시간
	            rdto.setRestdate(item.path("restdatefood").asText("")); // 쉬는날
	            rdto.setParking(item.path("parkingfood").asText(""));   // 주차시설
	            
	            System.out.println(">>> " + contentId + " 소개 정보(영업/주차) 수집 완료");
	        }
	    } catch (Exception e) {
	        System.err.println("소개 정보 수집 에러: " + e.getMessage());
	    }
	}

	// 2. 수정된 공통 상세 정보 메서드 (YN 파라미터 모두 제거)
	@Override
	public void testRegisterDetail(String contentId, RestaurantDTO rdto) {
	    String serviceKey = "526ab31ed6f40d4a2fded084267086cc0cab748473a9be6448f06b8d14cc9c23";
	    
	    RestTemplate restTemplate = new RestTemplate();
	    DefaultUriBuilderFactory factory = new DefaultUriBuilderFactory();
	    factory.setEncodingMode(DefaultUriBuilderFactory.EncodingMode.NONE); 
	    restTemplate.setUriTemplateHandler(factory);

	    // 중요: 최신 매뉴얼 규격에 따라 모든 YN 파라미터를 삭제했습니다.
	    String url = "https://apis.data.go.kr/B551011/KorService2/detailCommon2?serviceKey=" + serviceKey
	            + "&contentId=" + contentId
	            + "&MobileOS=ETC&MobileApp=AppTest&_type=json";

	    try {
	        ObjectMapper mapper = new ObjectMapper();
	        String res = restTemplate.getForObject(url, String.class);
	        JsonNode itemNode = mapper.readTree(res).path("response").path("body").path("items").path("item");

	        JsonNode item = itemNode.isArray() ? itemNode.get(0) : itemNode;

	        if (!item.isMissingNode()) {
	            rdto.setDescription(item.path("overview").asText(""));
	            rdto.setCategory(item.path("cat3").asText(""));
	            System.out.println(">>> " + contentId + " 공통 상세 수집 완료");
	        }
	    } catch (Exception e) {
	        System.err.println("공통 상세 에러: " + e.getMessage());
	    }
	}
	//4.맛집 관리
	//4-1.맛집 목록 전체 조회
	
	@Override
	public void getRestaurant_list(HttpServletRequest request, HttpServletResponse response, Model model) {
	    System.out.println("AdminServiceImpl - getRestaurant_list()");
	    
	    String pageNum = request.getParameter("pageNum");
	    String areaCode = request.getParameter("areaCode");

	    Paging paging = new Paging(pageNum);
	    
	    Map<String, Object> map = new HashMap();
	    map.put("areaCode", areaCode);

	    int total = admindao.placeCnt(map); 
	    System.out.println("total : " + total);
	    
	    paging.setTotalCount(total);
	    
	    map.put("start", paging.getStartRow());
	    map.put("end", paging.getEndRow());
	    
	    // [수정] List 타입을 PlaceDTO에서 Map으로 변경
	    List<Map<String, Object>> list = admindao.placeList(map); 
	    System.out.println("list size : " + (list != null ? list.size() : 0));
	    
	    model.addAttribute("list", list);
	    model.addAttribute("paging", paging);
	    model.addAttribute("areaCode", areaCode);
	}
	
	
	@Override
	public void getRestaurantInsert(MultipartHttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		
		System.out.println("AdminServiceImpl - getRestaurantInsert()");
		MultipartFile file = request.getFile("pdImg");
		System.out.println("file : "+ file);
		
		//input 경로- 폴더먼저 생성 후
		String saveDir = request.getSession().getServletContext().getRealPath("/resources/upload/");//이거는 이 url을 읽는거다
		System.out.println("saveDir : "+saveDir);
		
		String realDir = "D:\\DV06\\workspace_git_ict06\\ict06_mid_pj\\src\\main\\webapp\\resources\\upload\\";
		
		System.out.println("realDir : "+realDir);
		
		FileInputStream fis = null;
		FileOutputStream fos = null;
		
		String p_img1 ="";
		
		//상세페이지에 있는 이미지를 수정할 경우
		if(file.getOriginalFilename() != null && !file.getOriginalFilename().isEmpty()) {
		    
		    // [핵심] 파일명 중복 방지: 현재 시간을 밀리초 단위로 붙임 (예: 1741570123_스크린샷(4).png)
		    String originalName = file.getOriginalFilename();
		    String saveFileName = System.currentTimeMillis() + "_" + originalName.replace(" ", "_");
		

		    try {
		        // 1. C드라이브(서버 실행 경로)에 저장 - 이름이 다르므로 에러 안 남!
		        File saveFile = new File(saveDir + "/" + saveFileName);
		        file.transferTo(saveFile); 

		        // 2. D드라이브(워크스페이스)로 복사
		        fis = new FileInputStream(saveFile);
		        fos = new FileOutputStream(new File(realDir + "/" + saveFileName));
		        
		        byte[] buffer = new byte[1024];
		        int len;
		        while ((len = fis.read(buffer)) != -1) {
		            fos.write(buffer, 0, len);
		        }
		        String contextPath = request.getContextPath(); // /ict06_team1_midpj 
		        p_img1 = contextPath + "/resources/upload/" + saveFileName;
		        
		        System.out.println("새로운 이미지 경로 할당 완료: " + p_img1);
			
		} catch(IOException e) {
			e.printStackTrace();
		} finally {
			if(fis != null) fis.close();
			if(fos != null) fos.close();
		}
	}

			PlaceDTO pDto = new PlaceDTO();
		    pDto.setPlace_type("rest"); // 고정값
		    pDto.setName(request.getParameter("pdName"));
		    String address_detail = request.getParameter("address_detail");
		    String address = request.getParameter("address");
		    String fullAddress = address;
		    if (address_detail != null && !address_detail.trim().isEmpty()) {
		        fullAddress += " - " + address_detail; // "주소 상세주소" 형태로 합쳐짐
		    }
		    pDto.setAddress(fullAddress);
		    pDto.setImage_url(p_img1);
		    pDto.setLatitude(Double.parseDouble(request.getParameter("latitude"))); 
		    pDto.setLongitude(Double.parseDouble(request.getParameter("longitude")));
		    RestaurantDTO rDto = new RestaurantDTO();
		    rDto.setPhone(request.getParameter("phone"));
		    rDto.setCategory(request.getParameter("category"));
		    rDto.setDescription(request.getParameter("pdContent"));
		    rDto.setOpentime(request.getParameter("opentime"));
		    rDto.setRestdate(request.getParameter("restdate"));
		    rDto.setParking(request.getParameter("parking"));
		    rDto.setAreaCode(request.getParameter("areaCode"));
		    rDto.setStatus("open"); // 기본 상태

	    	Map<String, Object>map = new HashMap();
	    	map.put("pDto", pDto);
	    	map.put("rDto", rDto);
	    	
			//5단계. 상품 등록
	    	//부모테이블(PLACE) 먼저 insert
	    	int placeCnt = admindao.getPlaceInsert(pDto);
	    	int insertCnt = 0;
	    	
	    	//부모테이블 insert 성공 여부 확인
			if(placeCnt > 0) {
				//생성된 pk 가져오기
				int generatedId = pDto.getPlace_id();
				//자식테이블(restaurant) fk 설정
				rDto.setRestaurant_id(generatedId);
				
				//자식테이블에 데이터 insert
				insertCnt = admindao.getRestaurantInsert(rDto);
			}
			
			//6단계. jsp로 처리결과 전달
			String pageNum1 = request.getParameter("pageNum");
			if (pageNum1 == null || pageNum1.trim().isEmpty()) {
		        pageNum1 = "1";
		    }
			int pageNum = Integer.parseInt(pageNum1);
			String areaCode = request.getParameter("areaCode");
			model.addAttribute("pageNum",pageNum);
			model.addAttribute("areaCode",areaCode);
			model.addAttribute("insertCnt",insertCnt);
			System.out.println("insertCnt"+insertCnt);
		
	}
	
	@Override
	public void getRestaurantDetail(HttpServletRequest request, HttpServletResponse response, Model model)
			throws ServletException, IOException {
		
		System.out.println("AdminServiceImpl - getRestaurantDetail()");
		
		int place_id = Integer.parseInt(request.getParameter("place_id"));
		
		String pageNum1 = request.getParameter("pageNum");
		if (pageNum1 == null || pageNum1.trim().isEmpty()) {
	        pageNum1 = "1";
	    }
		int pageNum = Integer.parseInt(pageNum1);
		PlaceDTO pdto = admindao.getPlaceDetail(place_id);
		RestaurantDTO rdto = admindao.getRestaurantDetail(place_id);
		String areaCode = request.getParameter("areaCode");
		System.out.println("코드"+rdto.getCategory());
		System.out.println("코드"+rdto.getPhone());
		model.addAttribute("pdto", pdto);
		model.addAttribute("rdto", rdto);
		model.addAttribute("pageNum", pageNum);
		model.addAttribute("areaCode", areaCode);
		
	}

	@Override
	public void getRestaurantUpdateAction(MultipartHttpServletRequest request, HttpServletResponse response,
			Model model) throws ServletException, IOException {
		
		System.out.println("AdminServiceImpl - getRestaurantUpdateAction()");
		//3단계 화면에서 입력한 값 및 hidden으로 넘긴 값을 가져오자!!!
		String pageNum = request.getParameter("pageNum");
		int hiddenPageNum = Integer.parseInt(request.getParameter("pageNum")); 
		String oldImg = request.getParameter("oldImg");
		
		System.out.println("hiddenPageNum : "+hiddenPageNum);
		System.out.println("oldImg : "+oldImg);
		//-------------------------------------------------
		
		MultipartFile file = request.getFile("pdImg");//수정한 이미지
		System.out.println("file : "+file);
		//-----------------------------------붙여넣기한거다
		//input 경로- 폴더먼저 생성 후
		String saveDir = request.getSession().getServletContext().getRealPath("/resources/upload/");//이거는 이 url을 읽는거다
		System.out.println("saveDir : "+saveDir);
		
		String realDir = "D:\\DV06\\workspace_git_ict06\\ict06_mid_pj\\src\\main\\webapp\\resources\\upload";
		System.out.println("realDir : "+realDir);
		
		FileInputStream fis = null;
		FileOutputStream fos = null;
		
		String p_img1 ="";
		
		//상세페이지에 있는 이미지를 수정할 경우
		if(file.getOriginalFilename() != null && !file.getOriginalFilename().isEmpty()) {
		    
		    // [핵심] 파일명 중복 방지: 현재 시간을 밀리초 단위로 붙임 (예: 1741570123_스크린샷(4).png)
		    String originalName = file.getOriginalFilename();
		    String saveFileName = System.currentTimeMillis() + "_" + originalName.replace(" ", "_");

		    try {
		        // 1. C드라이브(서버 실행 경로)에 저장 - 이름이 다르므로 에러 안 남!
		        File saveFile = new File(saveDir + "/" + saveFileName);
		        file.transferTo(saveFile); 

		        // 2. D드라이브(워크스페이스)로 복사
		        fis = new FileInputStream(saveFile);
		        fos = new FileOutputStream(new File(realDir + "/" + saveFileName));
		        
		        byte[] buffer = new byte[1024];
		        int len;
		        while ((len = fis.read(buffer)) != -1) {
		            fos.write(buffer, 0, len);
		        }
		        String contextPath = request.getContextPath(); // /ict06_team1_midpj 
		        p_img1 = contextPath + "/resources/upload/" + saveFileName;
		        
		        System.out.println("새로운 이미지 경로 할당 완료: " + p_img1);
			
		}catch(IOException e) {
			e.printStackTrace();
		}finally {
			if(fis != null) fis.close();
			if(fos != null) fos.close();
		}
	}
		
	//추가-----------------------
	else {
		//기존 이미지 사용(이미지 사용 안할 경우)
		p_img1= oldImg;
		System.out.println("p_img1 : "+p_img1);
	}
		
		
	//-------------------------------------
		//3단계. 화면에서 입력한 값을 가져와라 dto에 setter로 값을 담아라
		//3-1. RestaurantDTO 생성
		PlaceDTO pDto = new PlaceDTO();
		RestaurantDTO rDto = new RestaurantDTO();
		
		//5단계. 맛집등록
		pDto.setPlace_id(Integer.parseInt((request.getParameter("place_id"))));
	    pDto.setPlace_type("rest"); // 고정값
	    pDto.setName(request.getParameter("pdName"));
	    
	    String address_detail = request.getParameter("address_detail");
	    String address = request.getParameter("address");
	    String fullAddress = address;
	    if (address_detail != null && !address_detail.trim().isEmpty()) {
	        fullAddress += " - " + address_detail; // "주소 상세주소" 형태로 합쳐짐
	    }
	    pDto.setAddress(fullAddress);
	    pDto.setImage_url(p_img1);
	    pDto.setLatitude(Double.parseDouble(request.getParameter("latitude"))); 
	    pDto.setLongitude(Double.parseDouble(request.getParameter("longitude")));
	    pDto.setView_count(0); // 초기값
	    
	    rDto.setRestaurant_id(Integer.parseInt((request.getParameter("place_id"))));
	    rDto.setPhone(request.getParameter("phone"));
	    rDto.setCategory(request.getParameter("category"));
	    rDto.setDescription(request.getParameter("pdContent"));
	    rDto.setOpentime(request.getParameter("opentime"));
	    rDto.setRestdate(request.getParameter("restdate"));
	    rDto.setParking(request.getParameter("parking"));
	    rDto.setAreaCode(request.getParameter("areaCode"));
	    rDto.setStatus("open"); // 기본 상태
		
		//5단계. 
	    int updateCntP = admindao.getPlaceUpdateAction(pDto);
		int updateCntR = admindao.getRestaurantUpdateAction(rDto);
		int updateCnt = 0;
		
		//5단계. 상품 등록
    	//부모테이블(PLACE) 먼저 insert
    	//부모테이블 insert 성공 여부 확인
		if(updateCntP + updateCntR == 2) {
			updateCnt = 1;
		}
		else {
			updateCnt = 0;
		}
		//6단계. 
		
		String areaCode = request.getParameter("areaCode");
		model.addAttribute("updateCnt",updateCnt);
		model.addAttribute("hiddenPageNum",hiddenPageNum);
		model.addAttribute("areaCode",areaCode);
		System.out.println("수정 후 areaCode 확인 : " + areaCode);
		}
	
	@Override
	public void getRestaurantDeleteAction(HttpServletRequest request, HttpServletResponse response, Model model)
	        throws ServletException, IOException {
	    
	    System.out.println("AdminServiceImpl - getRestaurantDeleteAction()");
	    
	    // 1. 파라미터를 먼저 문자열로 다 받습니다.
	    String strPlace_id = request.getParameter("place_id");
	    String pageNum = request.getParameter("pageNum");
	    String areaCode = request.getParameter("areaCode");
	    
	    int deleteCnt = 0;

	    // 2. [오류 해결 포인트] place_id가 있을 때만 삭제 로직 실행
	    if (strPlace_id != null && !strPlace_id.trim().isEmpty()) {
	        int place_id = Integer.parseInt(strPlace_id); // 이제 여기서 null 에러 안 납니다.
	        deleteCnt = admindao.getRestaurantDeleteAction(place_id);
	    }
	    
	    // 3. 기본값 설정 (null 방지)
	    if (pageNum == null || pageNum.isEmpty()) pageNum = "1";
	    if (areaCode == null) areaCode = "";

	    // 4. 모델에 담기 (컨트롤러에서 redirect 시 꺼내 쓸 수 있게 함)
	    model.addAttribute("deleteCnt", deleteCnt);
	    model.addAttribute("pageNum", pageNum);
	    model.addAttribute("areaCode", areaCode);
	}
}