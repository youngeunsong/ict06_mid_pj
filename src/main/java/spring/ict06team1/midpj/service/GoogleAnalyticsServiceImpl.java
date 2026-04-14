package spring.ict06team1.midpj.service;

import java.io.FileInputStream;
import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.google.analytics.data.v1beta.BetaAnalyticsDataClient;
import com.google.analytics.data.v1beta.BetaAnalyticsDataSettings;
import com.google.analytics.data.v1beta.DateRange;
import com.google.analytics.data.v1beta.Dimension;
import com.google.analytics.data.v1beta.Metric;
import com.google.analytics.data.v1beta.OrderBy;
import com.google.analytics.data.v1beta.RunReportRequest;
import com.google.analytics.data.v1beta.RunReportResponse;
import com.google.api.gax.core.FixedCredentialsProvider;
import com.google.auth.oauth2.GoogleCredentials;

/* 유일 Google Analytics Data API 호출 페이지 */
//Google Analytics Data API를 통해 외부 웹 트래픽 데이터 조회
@Service
public class GoogleAnalyticsServiceImpl implements GoogleAnalyticsService {
	
	// [ GA4 연동 ]
    // 1. GA4 Property ID
    private static final String PROPERTY_ID = "529536933";

    // 2. JSON 키 파일 경로
    private static final String KEY_FILE_PATH = "C:/DEV06/기타/secret/midpj-ga-api-f0973d0b1044.json";

    // 3. GA4 API 호출용 클라이언트 생성
    private BetaAnalyticsDataClient createClient() throws IOException {
    	System.out.println("[GoogleAnalyticsServiceImpl - createClient()]");
    	
        GoogleCredentials credentials =
                GoogleCredentials.fromStream(new FileInputStream(KEY_FILE_PATH));

        BetaAnalyticsDataSettings settings =
                BetaAnalyticsDataSettings.newBuilder()
                        .setCredentialsProvider(FixedCredentialsProvider.create(credentials))
                        .build();

        return BetaAnalyticsDataClient.create(settings);
    }

    // [ 금일, 기간 별 트래픽(페이지뷰, 방문자 수) 가져오기 ]
    // 1. 금일 트래픽 합계
    @Override
    public Map<String, Object> getTodayTrafficSummary() {
    	System.out.println("[GoogleAnalyticsServiceImpl - getTodayTrafficSummary()]");
        return getTrafficSummary("today", "today");
    }

    // 2. 기간 별 트래픽 합계
    @Override
    public Map<String, Object> getPeriodTrafficSummary(LocalDate startDate, LocalDate endDate) {
    	System.out.println("[GoogleAnalyticsServiceImpl - getPeriodTrafficSummary()]");
        return getTrafficSummary(startDate.toString(), endDate.toString());
    }

    // 1,2번 내부 공통 메서드
    private Map<String, Object> getTrafficSummary(String startDate, String endDate) {
    	System.out.println("[GoogleAnalyticsServiceImpl - getTrafficSummary()]");

        Map<String, Object> result = new HashMap<String, Object>();
        
        // 초기값 설정
        int viewCount = 0;
        int visitorCount = 0;
        
        /* GA4 Data API 라이브러리 클래스/객체
         * dimension: 데이터를 나누는 기준
         * metric: 숫자로 측정하는 값 */ 
        try (
    		// GA4 API 호출용 클라이언트 호출
    		BetaAnalyticsDataClient client = createClient()) {
        	
        	// 어떤 데이터, 어떤 기간, 어떤 GA4 속성에서 읽을지 결정
            RunReportRequest request = RunReportRequest.newBuilder()
            		// PROPERTY_ID 호출
                    .setProperty("properties/" + PROPERTY_ID)
                    // 조회 기간을 지정 (today~today / startDate~endDate)
                    .addDateRanges(
                            DateRange.newBuilder()
                                    .setStartDate(startDate)
                                    .setEndDate(endDate)
                                    .build()
                    )
                    // 가져올 지표 설정
                    .addMetrics(Metric.newBuilder().setName("screenPageViews").build()) // 페이지뷰
                    .addMetrics(Metric.newBuilder().setName("activeUsers").build()) // 방문자 수
                    .build();
            
            // Google Analytics Data API 호출
            RunReportResponse response = client.runReport(request);

            // 
            if (response.getRowsCount() > 0) {
                viewCount = Integer.parseInt(response.getRows(0).getMetricValues(0).getValue()); // getMetricValues(0) => viewCount
                visitorCount = Integer.parseInt(response.getRows(0).getMetricValues(1).getValue()); // getMetricValues(1) => visitorCount
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        //Map<String, Object> result에 put
        result.put("viewCount", viewCount);
        result.put("visitorCount", visitorCount);

        return result;
    }
    
    // [ 금일, 기간 별 트래픽 가져오기 ]
    // 기간별 트래픽 추이 데이터 호출 (날짜별로 쪼개진 리스트 데이터) => 받아온 시작/끝 날짜 String형으로 가져오기
    @Override
    public List<Map<String, Object>> getTrafficTrend(LocalDate startDate, LocalDate endDate) {
        return getTrafficTrendByDateRange(startDate.toString(), endDate.toString());
    }


    // - 관리자 홈 ECharts line chart 데이터 소스로 사용
    // 기간별 트래픽 추이 데이터 실행
    private List<Map<String, Object>> getTrafficTrendByDateRange(String startDate, String endDate) {
    	
    	// 결과값 담을 List 선언
        List<Map<String, Object>> rawList = new ArrayList<Map<String, Object>>();

        try (
    		// GA4 API 호출용 클라이언트 호출
    		BetaAnalyticsDataClient client = createClient()) {
        	
        	// 어떤 데이터, 어떤 기간, 어떤 GA4 속성에서 읽을지 결정
            RunReportRequest request = RunReportRequest.newBuilder()
                    .setProperty("properties/" + PROPERTY_ID)
                    .addDimensions(Dimension.newBuilder().setName("date").build()) // 데이터 구분 기준 : data 라고 설정
                    .addMetrics(Metric.newBuilder().setName("activeUsers").build()) // 방문자 수
                    .addMetrics(Metric.newBuilder().setName("screenPageViews").build()) // 페이지뷰
                    .addDateRanges(
                            DateRange.newBuilder()
                                    .setStartDate(startDate) // 시작일
                                    .setEndDate(endDate) // 종료일
                                    .build()
                    )
                    .addOrderBys(
                            OrderBy.newBuilder()
                            		// 응답 시 날짜순으로 정렬
                                    .setDimension(
                                            OrderBy.DimensionOrderBy.newBuilder()
                                                    .setDimensionName("date")
                                                    .build()
                                    )
                                    .build()
                    )
                    .build();

            // Google Analytics Data API 호출
            RunReportResponse response = client.runReport(request);

            for (int i = 0; i < response.getRowsCount(); i++) {
                String rawDate = response.getRows(i).getDimensionValues(0).getValue(); // 날짜(date)
                int visitorCount = Integer.parseInt(response.getRows(i).getMetricValues(0).getValue()); // 방문자 수
                int viewCount = Integer.parseInt(response.getRows(i).getMetricValues(1).getValue()); // 페이지뷰

                // row에 날짜, 방문자 수, 페이지뷰 넣기
                Map<String, Object> row = new HashMap<String, Object>();
                row.put("date", formatGaDate(rawDate)); // yyyyMMdd → yyyy-MM-dd 변경 
                row.put("visitorCount", visitorCount);
                row.put("viewCount", viewCount);

                // rawList에 생선 된 모든 row 넣기
                rawList.add(row);
            }

        } catch (Exception e) {
            System.out.println("=== GA TRAFFIC TREND ERROR START ===");
            e.printStackTrace();
            System.out.println("=== GA TRAFFIC TREND ERROR END ===");
        }

        // -------------------------------------------------
        // 선택 기간 전체 날짜 생성 후, 없는 날짜는 0으로 채움
        // -------------------------------------------------
        // row : 1건/ rawList : row 다건/ rawMap : key(날짜) : value(row(날짜, 방문자 수, 페이지뷰)) 다건
        Map<String, Map<String, Object>> rawMap = new HashMap<String, Map<String, Object>>();
        for (Map<String, Object> row : rawList) {
            rawMap.put((String) row.get("date"), row);
        }

        // 최종 return을 위한 List 생성
        List<Map<String, Object>> filledList = new ArrayList<Map<String, Object>>();
        
        LocalDate start = LocalDate.parse(startDate);
        LocalDate end = LocalDate.parse(endDate);

        // 시작일~종류일까지의 정보 
        // isAfter() => d가 end보다 시간상으로 뒤인지 비교
        for (LocalDate d = start; !d.isAfter(end); d = d.plusDays(1)) {
            String dateKey = d.toString();

            Map<String, Object> row = new HashMap<String, Object>();
            row.put("date", dateKey);

            // rawMap에 값이 존재하면서 존재하는 데이터 넣기
            if (rawMap.containsKey(dateKey)) { // 키 존재여부 확인
                row.put("visitorCount", rawMap.get(dateKey).get("visitorCount"));
                row.put("viewCount", rawMap.get(dateKey).get("viewCount"));
            }
            // rawMap에 값이 존재하지 않으면 0 넣기
            else {
                row.put("visitorCount", 0);
                row.put("viewCount", 0);
            }

            // 존재하는 실존 데이터 + 없는데이터 0으로 치환한 데이터 총합
            filledList.add(row);
        }

        System.out.println("GA trafficTrendList => " + filledList);
        return filledList;
    }

    // **yyyyMMdd → yyyy-MM-dd 변경 
    private String formatGaDate(String rawDate) {
        if (rawDate == null || rawDate.length() != 8) {
            return rawDate;
        }

        String year = rawDate.substring(0, 4);
        String month = rawDate.substring(4, 6);
        String day = rawDate.substring(6, 8);

        return year + "-" + month + "-" + day;
    }
}