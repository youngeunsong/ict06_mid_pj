package spring.ict06team1.midpj.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import org.springframework.stereotype.Component;

/*
 * 작성자: 송영은
 * 최초작성일: 2026-03-16
 * 수정일: 2026-03-17
 * 
 * 전국문화축제표준데이터 오픈 API를 이용하여 데이터를 DB에 넣는 코드입니다. 
 * 하루에 최대 1000건까지 다운로드 제한이 있으니 실행 시 주의해주세요
 * */

@Component
public class FestivalApiClient {

    private static final String SERVICE_KEY = "d7db7b7765d36202abf82894066af507d09c4e72ba858c461e82332456e5a105";

    public String callApi(int pageNo, int numOfRows) throws Exception {

        String urlStr =
                "http://api.data.go.kr/openapi/tn_pubr_public_cltur_fstvl_api"
                + "?serviceKey=" + SERVICE_KEY
                + "&pageNo=" + pageNo
                + "&numOfRows=" + numOfRows
                + "&type=json";

        URL url = new URL(urlStr);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        conn.setRequestProperty("User-Agent", "Mozilla/5.0");

        // Timeout 없으면 오류 발생
        conn.setConnectTimeout(30000); // 연결 timeout 10초
        conn.setReadTimeout(30000);    // 응답 대기 timeout 15초

        BufferedReader rd;

        if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(
                    new InputStreamReader(conn.getInputStream()));
        } else {
            rd = new BufferedReader(
                    new InputStreamReader(conn.getErrorStream()));
        }

        StringBuilder sb = new StringBuilder();
        String line;

        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }

        rd.close();
        conn.disconnect();

        return sb.toString();
    }
}
