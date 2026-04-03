package spring.ict06team1.midpj.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.SocketException;
import java.net.URL;
import java.net.URLEncoder;

import org.springframework.stereotype.Component;

/*
 * 작성자: 송영은
 * 최초작성일: 2026-03-16
 * 최종수정일: 2026-04-01
 * 
 * 전국문화축제표준데이터 오픈 API를 이용하여 데이터를 DB에 넣는 코드입니다. 
 * 하루에 최대 1000건까지 다운로드 제한이 있으니 실행 시 주의해주세요
 * */

@Component
public class FestivalApiClient {

    private static final String SERVICE_KEY = "d7db7b7765d36202abf82894066af507d09c4e72ba858c461e82332456e5a105"; // TODO: API용 키. 추후 깃허브 메인에 올리기 전에 이 라인을 다른 방식으로 처리할 것.
    
    public String callAPI(int pageNo, int numOfRows) throws IOException {
        StringBuilder urlBuilder = new StringBuilder("http://api.data.go.kr/openapi/tn_pubr_public_cltur_fstvl_api"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("serviceKey","UTF-8") + "=" + URLEncoder.encode(SERVICE_KEY, "UTF-8")); /*Service Key*/
        urlBuilder.append("&" + URLEncoder.encode("pageNo","UTF-8") + "=" + URLEncoder.encode(Integer.toString(pageNo), "UTF-8")); /*페이지 번호*/
        urlBuilder.append("&" + URLEncoder.encode("numOfRows","UTF-8") + "=" + URLEncoder.encode(Integer.toString(numOfRows), "UTF-8")); /*한 페이지 결과 수*/
        urlBuilder.append("&" + URLEncoder.encode("type","UTF-8") + "=" + URLEncoder.encode("JSON", "UTF-8")); /*XML/JSON 여부*/
//        urlBuilder.append("&" + URLEncoder.encode("fstvlNm","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*축제명*/
//        urlBuilder.append("&" + URLEncoder.encode("opar","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*개최장소*/
//        urlBuilder.append("&" + URLEncoder.encode("fstvlStartDate","UTF-8") + "=" + URLEncoder.encode(fstvlStartDate, "UTF-8")); /*축제시작일자*/
//        urlBuilder.append("&" + URLEncoder.encode("fstvlEndDate","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*축제종료일자*/
//        urlBuilder.append("&" + URLEncoder.encode("fstvlCo","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*축제내용*/
//        urlBuilder.append("&" + URLEncoder.encode("mnnstNm","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*주관기관명*/
//        urlBuilder.append("&" + URLEncoder.encode("auspcInsttNm","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*주최기관명*/
//        urlBuilder.append("&" + URLEncoder.encode("suprtInsttNm","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*후원기관명*/
//        urlBuilder.append("&" + URLEncoder.encode("phoneNumber","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*전화번호*/
//        urlBuilder.append("&" + URLEncoder.encode("homepageUrl","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*홈페이지주소*/
//        urlBuilder.append("&" + URLEncoder.encode("relateInfo","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*관련정보*/
//        urlBuilder.append("&" + URLEncoder.encode("rdnmadr","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*소재지도로명주소*/
//        urlBuilder.append("&" + URLEncoder.encode("lnmadr","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*소재지지번주소*/
//        urlBuilder.append("&" + URLEncoder.encode("latitude","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*위도*/
//        urlBuilder.append("&" + URLEncoder.encode("longitude","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*경도*/
//        urlBuilder.append("&" + URLEncoder.encode("referenceDate","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*데이터기준일자*/
//        urlBuilder.append("&" + URLEncoder.encode("instt_code","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*제공기관코드*/
//        urlBuilder.append("&" + URLEncoder.encode("instt_nm","UTF-8") + "=" + URLEncoder.encode("", "UTF-8")); /*제공기관기관명*/
        try {
        	System.out.println("API URL: " + urlBuilder.toString());
        	URL url = new URL(urlBuilder.toString());
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Content-type", "application/json");
            
            // 타임아웃 에러 발생 방지
            conn.setConnectTimeout(30000);
            conn.setReadTimeout(60000);
            
            // System.out.println("Response code: " + conn.getResponseCode());
            BufferedReader rd;
            if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
                rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            } else {
                rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
            }
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = rd.readLine()) != null) {
                sb.append(line);
            }
            rd.close();
            conn.disconnect();
            System.out.println(sb.toString());
            
            return sb.toString();
        }
        catch (SocketException e) {
        	System.out.println("API 연결 끊김");
            return "";
        }
    }

//    public String callApi(int pageNo, int numOfRows) throws Exception {
//
//        String urlStr =
//                "http://api.data.go.kr/openapi/tn_pubr_public_cltur_fstvl_api"
//                + "?serviceKey=" + SERVICE_KEY
//                + "&pageNo=" + pageNo
//                + "&numOfRows=" + numOfRows
//                + "&type=json";
//
//        URL url = new URL(urlStr);
//        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
//
//        conn.setRequestMethod("GET");
//        conn.setRequestProperty("Content-type", "application/json");
//        conn.setRequestProperty("User-Agent", "Mozilla/5.0");
//
//        // Timeout 없으면 오류 발생
//        conn.setConnectTimeout(30000); // 연결 timeout 10초
//        conn.setReadTimeout(30000);    // 응답 대기 timeout 15초
//
//        BufferedReader rd;
//
//        if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
//            rd = new BufferedReader(
//                    new InputStreamReader(conn.getInputStream()));
//        } else {
//            rd = new BufferedReader(
//                    new InputStreamReader(conn.getErrorStream()));
//        }
//
//        StringBuilder sb = new StringBuilder();
//        String line;
//
//        while ((line = rd.readLine()) != null) {
//            sb.append(line);
//        }
//
//        rd.close();
//        conn.disconnect();
//
//        return sb.toString();
//    }
}
