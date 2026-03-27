<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>결제 결과</title>
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
    max-width: 760px;
    margin: 50px auto;
    padding: 0 20px 40px;
  }

  .result-card {
    background: #fff;
    border-radius: 20px;
    box-shadow: 0 10px 28px rgba(0, 0, 0, 0.08);
    overflow: hidden;
  }

  .top {
    padding: 36px 30px 28px;
    text-align: center;
    border-bottom: 1px solid #eee;
  }

  .icon {
    width: 74px;
    height: 74px;
    margin: 0 auto 18px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 34px;
    font-weight: 700;
  }

  .icon.success {
    background: #eafaf1;
    color: #03c75a;
  }

  .icon.notice {
    background: #fff1f1;
    color: #e53935;
  }

  .title {
    margin: 0 0 10px;
    font-size: 30px;
    font-weight: 700;
    color: #111;
  }

  .desc {
    margin: 0;
    font-size: 15px;
    color: #666;
    line-height: 1.6;
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
    column-gap: 12px;
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

  .msg-box {
    padding: 16px 18px;
    border-radius: 12px;
    font-size: 14px;
    line-height: 1.6;
  }

  .msg-box.success {
    background: #eefaf3;
    color: #166534;
  }

  .msg-box.notice {
    background: #fff3f3;
    color: #b42318;
  }

  .btn-area {
    display: flex;
    gap: 12px;
    padding: 30px;
    background: #fafafa;
  }

  .btn {
    flex: 1;
    height: 52px;
    border: none;
    border-radius: 12px;
    font-size: 16px;
    font-weight: 700;
    cursor: pointer;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    justify-content: center;
  }

  .btn-primary {
    background: #03c75a;
    color: #fff;
  }

  .btn-primary:hover {
    background: #02b350;
  }

  .btn-secondary {
    background: #e9edf3;
    color: #333;
  }

  .btn-secondary:hover {
    background: #dfe5ec;
  }

  .api-box {
    margin-top: 14px;
    padding: 14px;
    border-radius: 12px;
    background: #f4f6f8;
    font-size: 13px;
    color: #555;
    overflow-x: auto;
    white-space: pre-wrap;
    word-break: break-word;
  }

  @media (max-width: 640px) {
    .wrap {
      margin: 30px auto;
      padding: 0 14px 30px;
    }

    .top,
    .section,
    .btn-area {
      padding: 22px 18px;
    }

    .title {
      font-size: 25px;
    }

    .info-list {
      grid-template-columns: 1fr;
      row-gap: 8px;
    }

    .btn-area {
      flex-direction: column;
    }
  }
</style>
</head>
<body>

<c:set var="isSuccess" value="${result.success}" />

<div class="wrap">
  <div class="result-card">

    <div class="top">
      <c:choose>
        <c:when test="${isSuccess}">
          <div class="icon success">✓</div>
          <h2 class="title">결제가 완료되었습니다</h2>
          <p class="desc">예약이 정상적으로 확정되었습니다.</p>
        </c:when>
        <c:otherwise>
          <div class="icon notice">!</div>
          <h2 class="title">결제가 완료되지 않았습니다</h2>
          <p class="desc">사용자가 결제를 취소했거나 결제 처리 중 문제가 발생했습니다.</p>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="section">
      <h3 class="section-title">처리 결과</h3>

      <c:choose>
        <c:when test="${isSuccess}">
          <div class="msg-box success">
            <c:choose>
              <c:when test="${not empty result.msg}">
                ${result.msg}
              </c:when>
              <c:otherwise>
                네이버페이 결제가 정상 승인되었습니다.
              </c:otherwise>
            </c:choose>
          </div>
        </c:when>
        <c:otherwise>
          <div class="msg-box notice">
            <c:choose>
              <c:when test="${not empty result.error}">
                ${result.error}
              </c:when>
              <c:when test="${not empty result.msg}">
                ${result.msg}
              </c:when>
              <c:otherwise>
                결제가 취소되었거나 승인 처리에 실패했습니다.
              </c:otherwise>
            </c:choose>
          </div>
        </c:otherwise>
      </c:choose>
    </div>

    <div class="section">
      <h3 class="section-title">기본 정보</h3>
      <div class="info-list">
        <div class="label">예약번호</div>
        <div class="value">
          <c:choose>
            <c:when test="${not empty result.reservationId}">
              ${result.reservationId}
            </c:when>
            <c:otherwise>
              -
            </c:otherwise>
          </c:choose>
        </div>

        <div class="label">결제번호</div>
        <div class="value">
          <c:choose>
            <c:when test="${not empty result.paymentId}">
              ${result.paymentId}
            </c:when>
            <c:otherwise>
              -
            </c:otherwise>
          </c:choose>
        </div>

        <div class="label">처리결과</div>
        <div class="value">
          <c:choose>
            <c:when test="${isSuccess}">성공</c:when>
            <c:otherwise>미완료</c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>

    <c:if test="${not empty result.apiResponse}">
      <div class="section">
        <h3 class="section-title">API 응답</h3>
        <div class="info-list">
          <div class="label">API success</div>
          <div class="value">${result.apiResponse.success}</div>

          <div class="label">API status</div>
          <div class="value">${result.apiResponse.status}</div>

          <div class="label">API error</div>
          <div class="value">
            <c:choose>
              <c:when test="${not empty result.apiResponse.error}">
                ${result.apiResponse.error}
              </c:when>
              <c:otherwise>
                -
              </c:otherwise>
            </c:choose>
          </div>
        </div>

        <c:if test="${not empty result.apiResponse.body}">
          <div class="api-box">${result.apiResponse.body}</div>
        </c:if>
      </div>
    </c:if>

    <div class="btn-area">
      <c:choose>
        <c:when test="${isSuccess}">
          <a href="${pageContext.request.contextPath}/viewReservations.do" class="btn btn-primary">예약 내역 보기</a>
          <a href="${pageContext.request.contextPath}/main.do" class="btn btn-secondary">메인으로 이동</a>
        </c:when>
        <c:otherwise>
          <a href="javascript:history.back();" class="btn btn-primary">이전 페이지로</a>
          <a href="${pageContext.request.contextPath}/main.do" class="btn btn-secondary">메인으로 이동</a>
        </c:otherwise>
      </c:choose>
    </div>

  </div>
</div>

</body>
</html>