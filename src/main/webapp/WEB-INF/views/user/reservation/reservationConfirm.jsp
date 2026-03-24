<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<h2>예약 확인 페이지</h2>
<p>예약번호: ${reservation.reservation_id}</p>
<p>장소명: ${reservation.placeDTO.name}</p>
<p>주소: ${reservation.placeDTO.address}</p>
<p>방문일: ${reservation.check_in}</p>
<p>인원수: ${reservation.guest_count}</p>
<p>요청사항: ${reservation.request_note}</p>
<p>예약상태: ${reservation.status}</p>
<p>결제 금액: ${reservation.amount}원</p>
</body>
<button type="button" id="naverPayBtn">네이버페이 테스트 결제</button>

<script src="https://nsp.pay.naver.com/sdk/js/naverpay.min.js"></script>
<script>
  const oPay = Naver.Pay.create({
    mode: "development",
    payType: "normal",
    clientId: "${naverPayClientId}",
    chainId: "${naverPayChainId}"
  });

  document.getElementById("naverPayBtn").addEventListener("click", function() {
    oPay.open({
      merchantPayKey: "${reservation.reservation_id}",
      merchantPayTransactionKey: "${reservation.reservation_id}_T1",
      merchantUserKey: "${reservation.user_id}",
      productName: "${reservation.placeDTO.name}",
      productCount: 1,
      totalPayAmount: ${reservation.amount},
      taxScopeAmount: ${reservation.amount},
      taxExScopeAmount: 0,
      returnUrl: "${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/naverPayReturn.rv?reservation_id=${reservation.reservation_id}"
    });
  });
</script>
</html>