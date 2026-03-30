<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>예약 확인</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<style>
  * {
    box-sizing: border-box;
  }

  body {
    margin: 0;
    font-family: "Noto Sans KR", Arial, sans-serif;
    background: #f5f7fb;
    color: #222;
  }

  .wrap {
    max-width: 780px;
    margin: 50px auto;
    padding: 0 20px 40px;
  }

  .page-title {
    text-align: center;
    margin-bottom: 28px;
  }

  .page-title h2 {
    margin: 0 0 10px;
    font-size: 30px;
    font-weight: 700;
    color: #111;
  }

  .page-title p {
    margin: 0;
    color: #666;
    font-size: 15px;
  }

  .card {
    background: #fff;
    border-radius: 18px;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
    overflow: hidden;
  }

  .section {
    padding: 28px 30px;
    border-bottom: 1px solid #eee;
  }

  .section:last-child {
    border-bottom: none;
  }

  .section-title {
    margin: 0 0 18px;
    font-size: 20px;
    font-weight: 700;
    color: #222;
  }

  .info-list {
    display: grid;
    grid-template-columns: 140px 1fr;
    row-gap: 14px;
    column-gap: 10px;
    align-items: center;
  }

  .label {
    font-weight: 600;
    color: #555;
  }

  .value {
    color: #222;
    word-break: break-word;
  }

  .amount {
    font-size: 24px;
    font-weight: 700;
    color: #03c75a;
  }

  .status-badge {
    display: inline-block;
    padding: 6px 12px;
    border-radius: 999px;
    background: #eef7ff;
    color: #2374e1;
    font-size: 14px;
    font-weight: 700;
  }

  .point-row {
    display: flex;
    align-items: center;
    gap: 8px;
    flex-wrap: wrap;
  }

  .point-input {
    width: 180px;
    height: 40px;
    padding: 0 12px;
    border: 1px solid #d9dfe8;
    border-radius: 10px;
    font-size: 15px;
  }

  .point-btn {
    height: 40px;
    padding: 0 14px;
    border: none;
    border-radius: 10px;
    background: #e9edf3;
    color: #333;
    font-weight: 600;
    cursor: pointer;
  }

  .point-btn:hover {
    background: #dfe5ec;
  }

  .btn-area {
    padding: 30px;
    background: #fafafa;
  }

  .btn-group {
    display: flex;
    gap: 12px;
  }

  .btn {
    flex: 1;
    height: 54px;
    border: none;
    border-radius: 12px;
    font-size: 17px;
    font-weight: 700;
    cursor: pointer;
    transition: background 0.2s ease;
  }

  .back-btn {
    background: #e9edf3;
    color: #333;
  }

  .back-btn:hover {
    background: #dfe5ec;
  }

  .pay-btn {
    background: #03c75a;
    color: #fff;
  }

  .pay-btn:hover {
    background: #02b350;
  }

  .pay-btn:disabled {
    background: #b8b8b8;
    cursor: not-allowed;
  }

  .notice {
    margin-top: 14px;
    font-size: 13px;
    color: #777;
    text-align: center;
    line-height: 1.5;
  }

  @media (max-width: 640px) {
    .wrap {
      margin: 30px auto;
      padding: 0 14px 30px;
    }

    .section {
      padding: 22px 18px;
    }

    .info-list {
      grid-template-columns: 1fr;
      row-gap: 8px;
    }

    .label {
      margin-top: 8px;
    }

    .page-title h2 {
      font-size: 24px;
    }

    .btn-group {
      flex-direction: column;
    }

    .point-input {
      width: 100%;
    }
  }
</style>
</head>
<body>

<div class="wrap">
  <div class="page-title">
    <h2>예약 확인</h2>
    <p>입력하신 예약 정보를 확인한 뒤 결제를 진행해주세요.</p>
  </div>

  <div class="card">

    <div class="section">
      <h3 class="section-title">장소 정보</h3>
      <div class="info-list">
        <div class="label">예약번호</div>
        <div class="value">${reservation.reservation_id}</div>

        <div class="label">장소명</div>
        <div class="value">${reservation.placeDTO.name}</div>

        <div class="label">주소</div>
        <div class="value">${reservation.placeDTO.address}</div>
      </div>
    </div>

    <div class="section">
      <h3 class="section-title">예약 정보</h3>
      <div class="info-list">

        <c:choose>
          <c:when test="${reservation.placeDTO.place_type eq 'STAY'}">
            <div class="label">체크인</div>
            <div class="value">${reservation.check_in}</div>

            <div class="label">체크아웃</div>
            <div class="value">${reservation.check_out}</div>
          </c:when>

          <c:when test="${reservation.placeDTO.place_type eq 'REST'}">
            <div class="label">방문일</div>
            <div class="value">${reservation.check_in}</div>

            <div class="label">방문시간</div>
            <div class="value">${reservation.visit_time}</div>
          </c:when>

          <c:when test="${reservation.placeDTO.place_type eq 'FEST'}">
            <div class="label">방문일</div>
            <div class="value">${reservation.check_in}</div>

            <div class="label">티켓번호</div>
            <div class="value">${reservation.ticket_id}</div>
          </c:when>

          <c:otherwise>
            <div class="label">방문일</div>
            <div class="value">${reservation.check_in}</div>
          </c:otherwise>
        </c:choose>

        <div class="label">인원수</div>
        <div class="value">${reservation.guest_count}명</div>

        <div class="label">요청사항</div>
        <div class="value">
          <c:choose>
            <c:when test="${not empty reservation.request_note}">
              ${reservation.request_note}
            </c:when>
            <c:otherwise>
              없음
            </c:otherwise>
          </c:choose>
        </div>

        <div class="label">예약상태</div>
        <div class="value">
          <span class="status-badge">${reservation.status}</span>
        </div>
      </div>
    </div>

    <div class="section">
      <h3 class="section-title">포인트 사용</h3>
      <div class="info-list">
        <div class="label">예약자</div>
        <div class="value">${memberName}</div>

        <div class="label">사용 가능 포인트</div>
        <div class="value"><span id="availablePointText">${availablePoint}</span>P</div>

        <div class="label">사용할 포인트</div>
        <div class="value">
          <div class="point-row">
            <input type="number" id="usedPoint" class="point-input" value="0" min="0" />
            <button type="button" id="useAllPointBtn" class="point-btn">전액 사용</button>
          </div>
        </div>
      </div>
    </div>

    <div class="section">
      <h3 class="section-title">결제 정보</h3>
      <div class="info-list">
        <div class="label">원래 금액</div>
        <div class="value"><span id="originAmount">${reservation.amount}</span>원</div>

        <div class="label">포인트 차감</div>
        <div class="value"><span id="usedPointText">0</span>P</div>

        <div class="label">최종 결제 금액</div>
        <div class="value amount"><span id="finalAmount">${reservation.amount}</span>원</div>
      </div>
    </div>

    <div class="btn-area">
      <div class="btn-group">
        <button type="button" class="btn back-btn" onclick="history.back();">
          이전 페이지로
        </button>

        <button
          type="button"
          id="naverPayBtn"
          class="btn pay-btn"
          <c:if test="${reservation.status eq 'RESERVED'}">disabled</c:if>>
          <c:choose>
            <c:when test="${reservation.status eq 'RESERVED'}">
              이미 예약 완료됨
            </c:when>
            <c:otherwise>
              네이버페이로 결제하기
            </c:otherwise>
          </c:choose>
        </button>
      </div>

      <p class="notice">
        <c:choose>
          <c:when test="${reservation.status eq 'RESERVED'}">
            이미 예약이 완료된 상태입니다.
          </c:when>
          <c:otherwise>
            내용을 수정하려면 이전 페이지로 돌아가고, 그대로 진행하려면 결제를 눌러주세요.
          </c:otherwise>
        </c:choose>
      </p>
    </div>

  </div>
</div>

<script src="https://nsp.pay.naver.com/sdk/js/naverpay.min.js"></script>
<script>
  const reservationStatus = "${reservation.status}";
  const originalAmount = Number("${reservation.amount}");
  const availablePoint = Number("${availablePoint}");

  const usedPointInput = document.getElementById("usedPoint");
  const useAllPointBtn = document.getElementById("useAllPointBtn");
  const usedPointText = document.getElementById("usedPointText");
  const finalAmountText = document.getElementById("finalAmount");

  function updateFinalAmount() {
    let usedPoint = Number(usedPointInput.value || 0);

    if (usedPoint < 0 || isNaN(usedPoint)) {
      usedPoint = 0;
    }

    if (usedPoint > availablePoint) {
      usedPoint = availablePoint;
    }

    if (usedPoint > originalAmount) {
      usedPoint = originalAmount;
    }

    usedPointInput.value = usedPoint;
    usedPointText.textContent = usedPoint;
    finalAmountText.textContent = originalAmount - usedPoint;
  }

  usedPointInput.addEventListener("input", updateFinalAmount);

  useAllPointBtn.addEventListener("click", function() {
    const maxUsablePoint = Math.min(availablePoint, originalAmount);
    usedPointInput.value = maxUsablePoint;
    updateFinalAmount();
  });

  const oPay = Naver.Pay.create({
    mode: "development",
    payType: "normal",
    clientId: "${naverPayClientId}",
    chainId: "${naverPayChainId}"
  });

  document.getElementById("naverPayBtn").addEventListener("click", function() {
    if (reservationStatus === "RESERVED") {
      alert("이미 예약이 완료된 상태입니다.");
      return;
    }

    const usedPoint = Number(usedPointInput.value || 0);
    const finalAmount = originalAmount - usedPoint;

    if (finalAmount < 0) {
      alert("결제 금액이 올바르지 않습니다.");
      return;
    }

    oPay.open({
      merchantPayKey: "${reservation.reservation_id}",
      merchantPayTransactionKey: "${reservation.reservation_id}_T1",
      merchantUserKey: "${reservation.user_id}",
      productName: "${reservation.placeDTO.name}",
      productCount: 1,
      totalPayAmount: finalAmount,
      taxScopeAmount: finalAmount,
      taxExScopeAmount: 0,
      returnUrl: "${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/naverPayReturn.rv?reservation_id=${reservation.reservation_id}&usedPoint=" + usedPoint
    });
  });

  updateFinalAmount();
</script>

</body>
</html>