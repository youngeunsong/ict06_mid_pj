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
	    
	    //parameter값 수집
	    String pageNum = request.getParameter("pageNum");
	    String areaCode = request.getParameter("areaCode");
	    
	    //페이징 객체 생성
	    Paging paging = new Paging(pageNum);
	    
	    //지역코드 담을 map 생성
	    Map<String, Object> map = new HashMap<String, Object>();
	    map.put("areaCode", areaCode);
	    
	    //전체 건수 조회
	    int total = adResDao.placeCnt(map); 
	    System.out.println("total : " + total);
	    paging.setTotalCount(total);
	    map.put("start", paging.getStartRow());
	    map.put("end", paging.getEndRow());
	    
	    // [수정] List 타입을 Map으로 선택과 목록 조회
	    List<Map<String, Object>> list = adResDao.placeList(map); 
	    System.out.println("list size : " + (list != null ? list.size() : 0));
	    
	    //model에 값을 담아서 jsp로 전달
	    model.addAttribute("list", list);
	    model.addAttribute("paging", paging);
	    model.addAttribute("areaCode", areaCode);
	    
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
		String saveDir = request.getSession().getServletContext().getRealPath("/resources/upload/");//이거는 이 url을 읽는거다
		System.out.println("saveDir : "+saveDir);
		
		// 서버 내 파일이 물리적으로 저장될 경로
		String realDir = "D:\\DV06\\workspace_git_ict06\\ict06_mid_pj\\src\\main\\webapp\\resources\\upload\\";
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
	        
		        // 서버 상의 웹 애플리케이션 식별 경로(Context Path)를 동적으로 가져옵
		        // ict06_team1_midpj 
		        String contextPath = request.getContextPath(); 
		        // DB에 저장할 최종 이미지 접근 경로(URL)를 조립
		        p_img1 = contextPath + "/resources/upload/" + saveFileName;
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
		String areaCode = request.getParameter("areaCode");
		
		// model에 각가 값 넣고 jsp로 전달
		model.addAttribute("pageNum",pageNum);
		model.addAttribute("areaCode",areaCode);
		model.addAttribute("insertCnt",insertCnt);
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
		String areaCode = request.getParameter("areaCode");
		System.out.println("hiddenPageNum : "+hiddenPageNum);
		System.out.println("oldImg : "+oldImg);
		System.out.println("areaCode : "+areaCode);
		
		// 수정한이미지 객체 MultipartFile로 받기 
		MultipartFile file = request.getFile("pdImg");
		System.out.println("file : "+file);
		
		// input 경로- 폴더먼저 생성 후
		String saveDir = request.getSession().getServletContext().getRealPath("/resources/upload/");//이거는 이 url을 읽는거다
		System.out.println("saveDir : "+saveDir);
		
		// 서버 내 파일이 물리적으로 저장될 경로
		String realDir = "D:\\DV06\\workspace_git_ict06\\ict06_mid_pj\\src\\main\\webapp\\resources\\upload";
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
		        p_img1 = contextPath + "/resources/upload/" + saveFileName;
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
		 
	    int updateCntP = adResDao.getPlaceUpdateAction(pDto);
		int updateCntR = adResDao.getRestaurantUpdateAction(rDto);
		
		
		//부모테이블(PLACE) 먼저 insert
		//부모테이블 insert 성공 여부 확인
		
		model.addAttribute("updateCnt",updateCntR);
		model.addAttribute("hiddenPageNum",hiddenPageNum);
		model.addAttribute("areaCode",areaCode);
		System.out.println("수정 후 areaCode 확인 : " + areaCode);
		System.out.println("전달된 맛집 이름: " + pDto.getName());
		System.out.println("전달된 상세 설명: " + rDto.getDescription());
		System.out.println("전달된 장소 ID: " + pDto.getPlace_id());
	}
			
	@Override
	public void getRestaurantDeleteAction(HttpServletRequest request, HttpServletResponse response, Model model)
	        throws ServletException, IOException {
	    System.out.println("AdRestaurantServiceImpl - getRestaurantDeleteAction()");
	    
	    // 1. 파라미터를 먼저 문자열로 다 받는다.
	    String strPlace_id = request.getParameter("place_id");
	    String pageNum = request.getParameter("pageNum");
	    String areaCode = request.getParameter("areaCode");
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
	}

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
	                + "&MobileOS=ETC&MobileApp=AppTest&_type=json&numOfRows=100"
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
	                if (adResDao.checkDuplicate(contentId) > 0) continue;

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
	                rdto.setAreaCode(item.path("areacode").asText("")); 

	                // 2️⃣ 공통 상세 정보 호출 (개요, 카테고리 등)
	                testRegisterDetail(contentId, rdto);
	                testRegisterIntro(contentId, rdto);
	                
	                if (adResDao.testInsertPlace(pdto) > 0) {
	                    successCountPlace++;
	                }
	                
	                if(adResDao.testInsertRes(rdto)> 0) {
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
	        	String restdate = item.path("restdatefood").asText("");
	            
	            if (restdate == null || restdate.isEmpty()) restdate = null ;

	            // 1. 핵심 키워드 축약 (부피 줄이기)
	            String compressed = restdate.replaceAll("\\s+", "")  // 공백 제거
		                                    .replace("요일", "")      // 월요일 -> 월
		                                    .replace("매주", "")      // 매주 월 -> 월
		                                    .replace("연중무휴", "무휴")
		                                    .replace("공휴일", "공휴")
		                                    .replace("마지막주", "막주")
		                                    .replace("첫째주", "1주")
		                                    .replace("둘째주", "2주");

	            // 2. 30바이트 단위로 안전하게 자르기 (한글 깨짐 방지)
	            int maxByte = 30;
	            StringBuilder sb = new StringBuilder();
	            int currentByte = 0;

	            for (char c : compressed.toCharArray()) {
	                try {
	                    // DB 인코딩에 맞춰 바이트 계산 (보통 UTF-8 3바이트)
	                    int charByte = String.valueOf(c).getBytes("UTF-8").length;
	                    
	                    if (currentByte + charByte <= maxByte) {
	                        sb.append(c);
	                        currentByte += charByte;
	                    } else {
	                        break; // 30바이트를 넘기지 않음
	                    }
	                } catch (java.io.UnsupportedEncodingException e) {
	                    break;
	                }
	            }
	            rdto.setRestdate(sb.toString());
	            System.out.println(">>> " + contentId + " 소개 정보(영업/주차) 수집 완료");
	        }else {
	            rdto.setRestdate("");
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
	
}