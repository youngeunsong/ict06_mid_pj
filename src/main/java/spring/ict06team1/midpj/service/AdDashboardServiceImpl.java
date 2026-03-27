package spring.ict06team1.midpj.service;

import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.kennycason.kumo.WordFrequency;
import com.kennycason.kumo.image.AngleGenerator;
import com.kennycason.kumo.palette.ColorPalette;

import spring.ict06team1.midpj.SearchCriteria.Paging;
import spring.ict06team1.midpj.dao.AdDashboardDAO;
import spring.ict06team1.midpj.dto.InquiryDTO;
import spring.ict06team1.midpj.dto.SurveyDTO;

import java.awt.Dimension;
import java.awt.Font;
import java.awt.GraphicsEnvironment;
import java.awt.image.BufferedImage;
import com.kennycason.kumo.font.KumoFont;

import com.kennycason.kumo.CollisionMode;
import com.kennycason.kumo.WordCloud;
import com.kennycason.kumo.bg.RectangleBackground;

/*
 * @author 김다솜/ 송혜진 / 송영은
 * 최초작성일: 2026-03-23
 * 최종수정일: 2026-03-25
 * 참고 코드: None
 * ----------------------------------
 * v260325
 * 기간내 사용자 만족도 표 조회 기능 추가 (송영은)
 * ----------------------------------
 */

@Service
public class AdDashboardServiceImpl implements AdDashboardService {

    @Autowired
    private AdDashboardDAO dao;

    @Autowired
    private GoogleAnalyticsService googleAnalyticsService;
    
    // 워드클라우드 설정
    private static final int WORDCLOUD_WIDTH = 900;
    private static final int WORDCLOUD_HEIGHT = 520;

    // 가장 안전한 한글 폰트 경로
    private static final String WORDCLOUD_FONT_PATH = "C:/Windows/Fonts/malgun.ttf";

    /*
     * [변수 역할 정리]
     *
     * 1) todayKpi
     * - JSP에 최종 전달되는 오늘용 KPI Map
     * - DB 집계값 + GA 집계값을 합친 최종 결과
     *
     * 2) periodKpi
     * - JSP에 최종 전달되는 기간용 KPI Map
     * - DB 집계값 + GA 집계값을 합친 최종 결과
     *
     * 3) todayGa
     * - GA API에서 "오늘 트래픽"만 따로 받아온 임시 Map
     * - todayKpi에 합치기 전 중간 저장용
     *
     * 4) periodGa
     * - GA API에서 "선택 기간 트래픽"만 따로 받아온 임시 Map
     * - periodKpi에 합치기 전 중간 저장용
     *
     * 5) todayMap / periodMap
     * - DAO / Mapper에 전달할 조회 조건 Map
     * - todayMap   : 오늘 00:00:00 ~ 내일 00:00:00
     * - periodMap  : 선택 시작일 00:00:00 ~ 선택 종료일 + 1일 00:00:00
     *
     * [최종 흐름]
     * DB today summary  + GA today summary   = todayKpi
     * DB period summary + GA period summary  = periodKpi
     */
    @Override
    public void getAdminHomeDashboard(HttpServletRequest request, HttpServletResponse response, Model model) {
        System.out.println("[AdDashboardServiceImpl - getAdminHomeDashboard()]");

        // 기간 설정 파라미터 (startDate / endDate 값 없을 시, 기본값 = 최근 1개월)
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        LocalDate today = LocalDate.now();
        LocalDate startDate;
        LocalDate endDate;

        if (startDateStr == null || startDateStr.trim().isEmpty()
                || endDateStr == null || endDateStr.trim().isEmpty()) {
            startDate = today.minusMonths(1).plusDays(1);
            endDate = today;
        } else {
            startDate = LocalDate.parse(startDateStr);
            endDate = LocalDate.parse(endDateStr);
        }

        // 2. 조회 범위를 Timestamp로 변환
        // - todayStart / todayEnd   : 금일 KPI 전용
        // - periodStart / periodEnd : 기간 KPI / 차트 전용
        Timestamp todayStart = Timestamp.valueOf(today.atStartOfDay());
        Timestamp todayEnd = Timestamp.valueOf(today.plusDays(1).atStartOfDay()); // "해당 날짜 23:59:59" 대신 "다음날 00:00:00 미만" 개념

        Timestamp periodStart = Timestamp.valueOf(startDate.atStartOfDay());
        Timestamp periodEnd = Timestamp.valueOf(endDate.plusDays(1).atStartOfDay());

        // - todayMap = 금일 KPI는 
        // - periodMap = 기간 KPI / 차트 / 워드클라우드
        Map<String, Object> todayMap = new HashMap<String, Object>();
        Map<String, Object> periodMap = new HashMap<String, Object>();

        todayMap.put("startDate", todayStart);
        todayMap.put("endDate", todayEnd);

        periodMap.put("startDate", periodStart);
        periodMap.put("endDate", periodEnd);

        /* 4. DB 전용 KPI 요약 조회
           - todayKpi  : 금일 DB 요약
           - periodKpi : 기간 DB 요약

           [DB 전용] - 6개
           신규 회원 수/ 맛집 등록 수/ 예약 수/ 댓글 수/ 결제 수/ 만족도조사 참여자 수 */
        Map<String, Object> todayKpi = dao.getTodayKpiSummary(todayMap);
        Map<String, Object> periodKpi = dao.getPeriodKpiSummary(periodMap);

        // null 방어 : DAO 결과가 null이어도 이후 put()에서 NPE 나지 않도록 보정
        if (todayKpi == null) todayKpi = new HashMap<String, Object>();
        if (periodKpi == null) periodKpi = new HashMap<String, Object>();

        // 5. DB KPI 초기화 (기본값 0 설정)
        putDefault(todayKpi, "newMemberCount", 0);
        putDefault(todayKpi, "newRestaurantCount", 0);
        putDefault(todayKpi, "reservationCount", 0);
        putDefault(todayKpi, "commentCount", 0);
        putDefault(todayKpi, "paymentCount", 0);
        putDefault(todayKpi, "surveyParticipantCount", 0);

        putDefault(periodKpi, "newMemberCount", 0);
        putDefault(periodKpi, "newRestaurantCount", 0);
        putDefault(periodKpi, "reservationCount", 0);
        putDefault(periodKpi, "commentCount", 0);
        putDefault(periodKpi, "paymentCount", 0);
        putDefault(periodKpi, "surveyParticipantCount", 0);

        /* 6. 기간 기준 차트 / 통계 / 보조 데이터 조회

        [DB 전용] - 6개
        만족도 시계열/ NPS 분포/ 만족도 핵심 통계/ 워드클라우드용 서술형 응답/ 미답변 문의 최근 10건 / 만족도 조사 결과 표 (서술형 응답 제외) */
        List<Map<String, Object>> trendList = dao.getSatisfactionTrend(periodMap);
        List<Map<String, Object>> npsDistribution = dao.getNpsDistribution(periodMap);
        List<Map<String, Object>> statsList = dao.getSatisfactionStats(periodMap);

        List<String> subjectiveAnswers = dao.getSubjectiveSurveyAnswers(periodMap);
        List<InquiryDTO> pendingInquiryList = dao.getPendingInquiryTop10(); // 1:1문의 미처리

        /* 7. GA 전용 트래픽 데이터 조회
           - visitorCount : 방문자 수(activeUsers)
           - viewCount    : 페이지뷰(screenPageViews)

           [GA 전용]
           todayGa  : 오늘 트래픽 / periodGa : 선택 기간 트래픽 */
        Map<String, Object> todayGa = googleAnalyticsService.getTodayTrafficSummary();
        Map<String, Object> periodGa = googleAnalyticsService.getPeriodTrafficSummary(startDate, endDate);

        System.out.println("GA API 오늘 트래픽(todayGa) => " + todayGa);
        System.out.println("GA API 기간 트래픽(periodGa) => " + periodGa);

        // 8. 최종 KPI Map에 GA 값 merge
        // - DB KPI Map + GA 트래픽 값을 합쳐서 JSP에 전달
        // =========================================================
        todayKpi.put("visitorCount", todayGa.get("visitorCount"));
        todayKpi.put("viewCount", todayGa.get("viewCount"));

        periodKpi.put("visitorCount", periodGa.get("visitorCount"));
        periodKpi.put("viewCount", periodGa.get("viewCount"));

        System.out.println("최종 오늘 KPI(todayKpi) => " + todayKpi);
        System.out.println("최종 기간 KPI(periodKpi) => " + periodKpi);

        // =========================================================
        // 9. JSP 전달
        // =========================================================
        model.addAttribute("todayKpi", todayKpi);
        model.addAttribute("periodKpi", periodKpi);
        model.addAttribute("trendList", trendList);
        model.addAttribute("npsDistribution", npsDistribution);
        model.addAttribute("statsList", statsList);
        model.addAttribute("subjectiveAnswers", subjectiveAnswers);
        model.addAttribute("pendingInquiryList", pendingInquiryList); // 1:1문의 미처리
        model.addAttribute("startDate", startDate.toString());
        model.addAttribute("endDate", endDate.toString());
        model.addAttribute("today", today.toString());
        
        // =========================================================
        // 8-1. GA 기간별 트래픽 추이 조회
        // - 관리자 홈 line chart 용
        // - 일자별 방문자 수 / 페이지뷰
        // =========================================================
        List<Map<String, Object>> trafficTrendList = googleAnalyticsService.getTrafficTrend(startDate, endDate);
     	System.out.println("GA trafficTrendList => " + trafficTrendList);
     	
     	model.addAttribute("trafficTrendList", trafficTrendList);
     	
     	// 10. 기간 내 사용자 만족도 조사 표 조회 위한 함수 호출
     	getSatisfactionList(periodMap, request, response, model); 
    }
    
    // 기간 내 설문 조사 결과 표 조회 : getAdminHomeDashboard 에서 호출하여 사용
    public void getSatisfactionList(Map<String, Object> periodMap, HttpServletRequest request, HttpServletResponse response, Model model) {
    	System.out.println("[AdDashboardServiceImpl - getSatisfactionList()]");

        // =========================================================
        // 기간내 만족도 상세 페이지 페이징 처리
        // =========================================================
        int pageSize = 5;
        int pageBlock = 5;

        String pageNum = request.getParameter("pageNum");
        if (pageNum == null || pageNum.trim().isEmpty()) {
            pageNum = "1";
        }

        int currentPage = Integer.parseInt(pageNum);

        Map<String, Object> map = new HashMap<String, Object>();

        int totalCount = dao.getSurveyCount(periodMap);
        // System.out.println("totalCount : " + totalCount);

        Paging paging = new Paging(pageNum);
        paging.setCurrentPage(currentPage);
        paging.setPageSize(pageSize);
        paging.setPageBlock(pageBlock);
        paging.setTotalCount(totalCount);

        periodMap.put("start", paging.getStartRow());
        periodMap.put("end", paging.getEndRow());

        List<Map<String, Object>> satisfactionList = dao.getSatisfactionList(periodMap); // 기간 내 만족도 조사 결과 표

        model.addAttribute("satisfactionList", satisfactionList); // 기간 내 사용자 만족도 조사 결과 표
        model.addAttribute("totalCount", totalCount);
        model.addAttribute("paging", paging);
    }

    // 해당 메서드 미사용/ 추후 작업 중 필요 시 사용하기 위해 파일만 유지
    @Override
    public void getTodaySurveyStatus(HttpServletRequest request, HttpServletResponse response, Model model) {
        System.out.println("[AdDashboardServiceImpl - getTodaySurveyStatus()]");

        // =========================================================
        // 금일 만족도 상세 페이지 페이징 처리
        // =========================================================
        int pageSize = 10;
        int pageBlock = 5;

        String pageNum = request.getParameter("pageNum");
        if (pageNum == null || pageNum.trim().isEmpty()) {
            pageNum = "1";
        }

        int currentPage = Integer.parseInt(pageNum);

        Map<String, Object> map = new HashMap<String, Object>();

        int totalCount = dao.getTodaySurveyCount(map);

        Paging paging = new Paging(pageNum);
        paging.setCurrentPage(currentPage);
        paging.setPageSize(pageSize);
        paging.setPageBlock(pageBlock);
        paging.setTotalCount(totalCount);

        map.put("start", paging.getStartRow());
        map.put("end", paging.getEndRow());

        List<SurveyDTO> surveyList = dao.getTodaySurveyList(map);

        model.addAttribute("surveyList", surveyList);
        model.addAttribute("surveyCnt", totalCount);
        model.addAttribute("paging", paging);
    }

    /*
     * 최소 기본값 0을 채워두는 안전장치 메서드
     *
     * [필요한 이유]
     * - DAO / Mapper 결과 Map에 특정 key가 없을 수 있음
     * - 값이 null이면 JSP에서 공백처럼 보일 수 있음
     * - 화면단에서 숫자 KPI는 0으로 보이는 편이 더 안전함
     *
     * [방어 대상]
     * - map 자체가 null
     * - key가 null
     * - key가 빈 문자열
     * - map 안의 해당 key 값이 null
     *
     * [동작]
     * - 기존 값이 있으면 유지
     * - 값이 없거나 null이면 defaultValue 삽입
     */
    private void putDefault(Map<String, Object> map, String key, Object defaultValue) {
        if (map == null || key == null || key.trim().isEmpty()) {
            return;
        }

        Object value = map.get(key);

        if (value == null) {
            map.put(key, defaultValue);
        }
    }
    
    // 워드클라우드
    @Override
    public String generateWordCloud(String text) {

        try {
            if (text == null || text.trim().isEmpty()) {
                return "";
            }

            String normalizedText = text
                    .replace("\r", " ")
                    .replace("\n", " ")
                    .replaceAll("[^가-힣a-zA-Z0-9\\s]", " ")
                    .replaceAll("\\s+", " ")
                    .trim();

            if (normalizedText.isEmpty()) {
                return "";
            }

            if (normalizedText.length() > 2000) {
                normalizedText = normalizedText.substring(0, 2000);
            }

            List<WordFrequency> wordFrequencies = buildWordFrequencies(normalizedText);

            if (wordFrequencies.isEmpty()) {
                return "";
            }

            java.io.File fontFile = new java.io.File(WORDCLOUD_FONT_PATH);
            if (!fontFile.exists()) {
                System.out.println("워드클라우드 폰트 파일 없음 => " + WORDCLOUD_FONT_PATH);
                return "";
            }

            Font font = Font.createFont(Font.TRUETYPE_FONT, fontFile).deriveFont(Font.PLAIN, 28f);

            GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
            ge.registerFont(font);

            WordCloud wordCloud = new WordCloud(
                    new Dimension(WORDCLOUD_WIDTH, WORDCLOUD_HEIGHT),
                    CollisionMode.PIXEL_PERFECT
            );

            wordCloud.setPadding(5);
            wordCloud.setBackgroundColor(new Color(248, 249, 250)); // 연한 회색 배경
            wordCloud.setBackground(new RectangleBackground(
                    new Dimension(WORDCLOUD_WIDTH, WORDCLOUD_HEIGHT)
            ));

            wordCloud.setKumoFont(new KumoFont(font));
            
            // 세로/회전 단어 삭제 = 전부 가로 방향
            wordCloud.setAngleGenerator(new AngleGenerator(0));
            
            // 형태 위주로 안정감 있게
            wordCloud.setFontScalar(new StepFontScalar(96, 72, 52, 36, 24));

            // 색상 수를 줄여서 통일감 있게
            wordCloud.setColorPalette(new ColorPalette(
                    new Color(1, 210, 129),    // 포인트 그린
                    new Color(24, 160, 251),   // 포인트 블루
                    new Color(95, 99, 104)     // 중성 그레이
            ));

            wordCloud.build(wordFrequencies);

            BufferedImage image = wordCloud.getBufferedImage();

            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(image, "png", baos);

            byte[] imageBytes = baos.toByteArray();
            String base64Image = Base64.getEncoder().encodeToString(imageBytes);

            System.out.println("Kumo wordcloud byte size => " + imageBytes.length);
            System.out.println("Kumo wordcloud word count => " + wordFrequencies.size());

            return "data:image/png;base64," + base64Image;

        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }
    
    // 워드클라우드 예외처리
    private List<WordFrequency> buildWordFrequencies(String text) {
        Map<String, Integer> freqMap = new HashMap<String, Integer>();

        String[] tokens = text.split("\\s+");
        for (String token : tokens) {
            String word = token == null ? "" : token.trim();

            if (word.isEmpty()) continue;

            // 길이 제한
            if (word.length() < 2) continue;
            if (word.length() > 8) continue;

            // 불용어 제거
            if (isStopWord(word)) continue;

            // 조사/어미 1차 정리
            word = normalizeWord(word);

            if (word.isEmpty()) continue;
            if (word.length() < 2) continue;
            if (word.length() > 8) continue;
            if (isStopWord(word)) continue;

            freqMap.put(word, freqMap.getOrDefault(word, 0) + 1);
        }

        // 2회 이상 나온 단어만 사용
        List<Map.Entry<String, Integer>> entries = new ArrayList<Map.Entry<String, Integer>>();
        for (Map.Entry<String, Integer> entry : freqMap.entrySet()) {
            if (entry.getValue() >= 2) {
                entries.add(entry);
            }
        }

        // 빈도수 내림차순 정렬
        entries.sort((a, b) -> Integer.compare(b.getValue(), a.getValue()));

        // 상위 50개만 사용
        List<WordFrequency> result = new ArrayList<WordFrequency>();
        
        // 단어 수
        int limit = Math.min(entries.size(), 70);

        for (int i = 0; i < limit; i++) {
            Map.Entry<String, Integer> entry = entries.get(i);
            result.add(new WordFrequency(entry.getKey(), entry.getValue()));
        }

        return result;
    }
    
    // 워드클라우드 단어 정규화 메서드
    private String normalizeWord(String word) {
        if (word == null) return "";

        String result = word.trim();

        // 자주 붙는 조사/어미 제거
        String[] suffixes = {
            "입니다", "있습니다", "좋습니다", "했습니다", "됩니다",
            "이었어요", "였어요", "했어요", "있어요", "좋아요",
            "였습니다", "있었어요", "좋았어요", "보였어요",
            "입니다", "합니다", "같아요", "같습니다",
            "으로", "에서", "에게", "처럼", "보다",
            "까지", "부터", "이라", "라서", "네요",
            "어요", "아요", "네요", "습니다", "였다",
            "에서", "으로", "하고", "이며", "인데",
            "하는", "했던", "되어", "되었", "해서",
            "하고", "이용", "사용"
        };

        for (String suffix : suffixes) {
            if (result.endsWith(suffix) && result.length() > suffix.length() + 1) {
                result = result.substring(0, result.length() - suffix.length());
                break;
            }
        }

        return result.trim();
    }
    
    //워드클라우드 불용어를 더 많이 추가
    private boolean isStopWord(String word) {
        if (word == null) return true;

        switch (word) {
            case "정말":
            case "너무":
            case "매우":
            case "아주":
            case "조금":
            case "다만":
            case "그리고":
            case "그냥":
            case "이번":
            case "다음":
            case "전체적":
            case "전체적으로":
            case "전반적으로":
            case "생각":
            case "부분":
            case "정도":
            case "경우":
            case "느낌":
            case "관련":
            case "대한":
            case "모든":
            case "진짜":
            case "약간":
            case "조금은":
            case "또한":
            case "역시":
            case "매번":
            case "처음":
            case "나중":
            case "이후":
            case "이전":
            case "사실":
            case "기본":
            case "전혀":
            case "거의":
            case "조용":
            case "만족":
            case "만족스러":
            case "좋았":
            case "좋았어":
            case "좋았어요":
            case "좋습":
            case "좋았습":
            case "있었":
            case "있습":
            case "보였":
            case "되어":
            case "되었":
            case "했어":
            case "했습":
            case "공간":
            case "시설":
            case "이용":
            case "사용":
            case "장소":
            case "부분적":
            case "상태":
            case "환경":
            case "사진":
                return true;
            default:
                return false;
        }
    }
    
    private static class StepFontScalar implements com.kennycason.kumo.font.scale.FontScalar {
        private final int[] steps;

        public StepFontScalar(int... steps) {
            this.steps = steps;
        }

        @Override
        public float scale(int frequency, int minFrequency, int maxFrequency) {
            if (steps == null || steps.length == 0) {
                return 24;
            }

            if (maxFrequency <= minFrequency) {
                return steps[steps.length - 1];
            }

            double ratio = (double) (frequency - minFrequency) / (double) (maxFrequency - minFrequency);

            if (ratio >= 0.80) return steps[0];
            if (ratio >= 0.60) return steps[Math.min(1, steps.length - 1)];
            if (ratio >= 0.40) return steps[Math.min(2, steps.length - 1)];
            if (ratio >= 0.20) return steps[Math.min(3, steps.length - 1)];
            return steps[Math.min(4, steps.length - 1)];
        }
    }

    
}