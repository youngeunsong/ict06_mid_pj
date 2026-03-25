<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>네이버페이 승인 결과</title>
</head>
<body>
    <h2>네이버페이 승인 결과</h2>

    <p>성공 여부: ${result.success}</p>
    <p>메시지: ${result.msg}</p>
    <p>예약번호: ${result.reservationId}</p>
    <p>결제번호: ${result.paymentId}</p>
    <p>에러: ${result.error}</p>

    <hr>

    <h3>API 응답</h3>
    <p>api success: ${result.apiResponse.success}</p>
    <p>api status: ${result.apiResponse.status}</p>
    <p>api error: ${result.apiResponse.error}</p>
    <pre>${result.apiResponse.body}</pre>
</body>
</html>