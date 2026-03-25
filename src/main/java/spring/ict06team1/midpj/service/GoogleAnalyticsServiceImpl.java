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
@Service
public class GoogleAnalyticsServiceImpl implements GoogleAnalyticsService {
	
    // GA4 Property ID
    private static final String PROPERTY_ID = "529536933";

    // JSON 키 파일 경로
    private static final String KEY_FILE_PATH = "C:/DEV06/기타/secret/midpj-ga-api-f0973d0b1044.json";

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

    // 금일 트래픽
    @Override
    public Map<String, Object> getTodayTrafficSummary() {
    	System.out.println("[GoogleAnalyticsServiceImpl - getTodayTrafficSummary()]");
        return getTrafficSummary("today", "today");
    }

    // 기간 별 트래픽
    @Override
    public Map<String, Object> getPeriodTrafficSummary(LocalDate startDate, LocalDate endDate) {
    	System.out.println("[GoogleAnalyticsServiceImpl - getPeriodTrafficSummary()]");
        return getTrafficSummary(startDate.toString(), endDate.toString());
    }

    private Map<String, Object> getTrafficSummary(String startDate, String endDate) {
    	System.out.println("[GoogleAnalyticsServiceImpl - getTrafficSummary()]");

        Map<String, Object> result = new HashMap<String, Object>();
        int viewCount = 0;
        int visitorCount = 0;

        try (BetaAnalyticsDataClient client = createClient()) {

            RunReportRequest request = RunReportRequest.newBuilder()
                    .setProperty("properties/" + PROPERTY_ID)
                    .addDateRanges(
                            DateRange.newBuilder()
                                    .setStartDate(startDate)
                                    .setEndDate(endDate)
                                    .build()
                    )
                    .addMetrics(Metric.newBuilder().setName("screenPageViews").build())
                    .addMetrics(Metric.newBuilder().setName("activeUsers").build())
                    .build();

            RunReportResponse response = client.runReport(request);

            if (response.getRowsCount() > 0) {
                viewCount = Integer.parseInt(response.getRows(0).getMetricValues(0).getValue());
                visitorCount = Integer.parseInt(response.getRows(0).getMetricValues(1).getValue());
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        //result.put
        result.put("viewCount", viewCount);
        result.put("visitorCount", visitorCount);

        return result;
    }
    
    @Override
    public List<Map<String, Object>> getTrafficTrend(LocalDate startDate, LocalDate endDate) {
        return getTrafficTrendByDateRange(startDate.toString(), endDate.toString());
    }

    /*
     * [GA 트래픽 추이 조회]
     * - 차원(date) 기준으로 일자별 방문자 수 / 페이지뷰 조회
     * - visitorCount : activeUsers
     * - viewCount    : screenPageViews
     * - 관리자 홈 ECharts line chart 데이터 소스로 사용
     */
    private List<Map<String, Object>> getTrafficTrendByDateRange(String startDate, String endDate) {

        List<Map<String, Object>> rawList = new ArrayList<Map<String, Object>>();

        try (BetaAnalyticsDataClient client = createClient()) {

            RunReportRequest request = RunReportRequest.newBuilder()
                    .setProperty("properties/" + PROPERTY_ID)
                    .addDimensions(Dimension.newBuilder().setName("date").build())
                    .addMetrics(Metric.newBuilder().setName("activeUsers").build())
                    .addMetrics(Metric.newBuilder().setName("screenPageViews").build())
                    .addDateRanges(
                            DateRange.newBuilder()
                                    .setStartDate(startDate)
                                    .setEndDate(endDate)
                                    .build()
                    )
                    .addOrderBys(
                            OrderBy.newBuilder()
                                    .setDimension(
                                            OrderBy.DimensionOrderBy.newBuilder()
                                                    .setDimensionName("date")
                                                    .build()
                                    )
                                    .build()
                    )
                    .build();

            RunReportResponse response = client.runReport(request);

            for (int i = 0; i < response.getRowsCount(); i++) {
                String rawDate = response.getRows(i).getDimensionValues(0).getValue(); // yyyyMMdd
                int visitorCount = Integer.parseInt(response.getRows(i).getMetricValues(0).getValue());
                int viewCount = Integer.parseInt(response.getRows(i).getMetricValues(1).getValue());

                Map<String, Object> row = new HashMap<String, Object>();
                row.put("date", formatGaDate(rawDate));
                row.put("visitorCount", visitorCount);
                row.put("viewCount", viewCount);

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
        Map<String, Map<String, Object>> rawMap = new HashMap<String, Map<String, Object>>();
        for (Map<String, Object> row : rawList) {
            rawMap.put((String) row.get("date"), row);
        }

        List<Map<String, Object>> filledList = new ArrayList<Map<String, Object>>();
        LocalDate start = LocalDate.parse(startDate);
        LocalDate end = LocalDate.parse(endDate);

        for (LocalDate d = start; !d.isAfter(end); d = d.plusDays(1)) {
            String dateKey = d.toString();

            Map<String, Object> row = new HashMap<String, Object>();
            row.put("date", dateKey);

            if (rawMap.containsKey(dateKey)) {
                row.put("visitorCount", rawMap.get(dateKey).get("visitorCount"));
                row.put("viewCount", rawMap.get(dateKey).get("viewCount"));
            } else {
                row.put("visitorCount", 0);
                row.put("viewCount", 0);
            }

            filledList.add(row);
        }

        System.out.println("GA trafficTrendList => " + filledList);
        return filledList;
    }

    /*
     * GA date 차원값(yyyyMMdd)을 화면용 yyyy-MM-dd 로 변환
     * 예: 20260324 -> 2026-03-24
     */
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