<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Footer 시작 -->
<footer class="border-top bg-white">
  <div class="container-fluid px-4 py-4">

    <div class="row g-4 align-items-start">

      <!-- 1) 고객센터 -->
      <div class="col-12 col-md-3">
        <div class="fw-bold mb-2">고객센터</div>

        <div class="d-flex align-items-center gap-2 mb-2">
          <span class="text-success">●</span>
          <div class="fs-5 fw-bold">1544-2222</div>
        </div>

        <div class="small text-secondary mb-2">
          운영시간: 09:00 ~ 18:00 (주말/공휴일 제외)
        </div>

        <div class="d-flex align-items-center gap-2 mb-2">
          <span class="badge text-bg-light border"><a href="${path}/FAQ.do">FAQ</a></span>
          <span class="badge text-bg-light border"><a href="${path}/inquiry.do">1:1문의</a></span>
        </div>
      </div>

      <!-- 2) ARS / 기타 번호 -->
      <div class="col-12 col-md-3">
        <div class="fw-bold mb-2">ARS / 전화번호</div>

        <div class="d-flex justify-content-between py-1 border-bottom small">
          <span>예약/결제 문의</span>
          <span class="fw-semibold">1544-5353</span>
        </div>
        <div class="d-flex justify-content-between py-1 border-bottom small">
          <span>기업/제휴 문의</span>
          <span class="fw-semibold">1661-4873</span>
        </div>
        <div class="d-flex justify-content-between py-1 border-bottom small">
          <span>분실/긴급 문의</span>
          <span class="fw-semibold">1544-6722</span>
        </div>

        <div class="small text-secondary mt-2">
          통화량이 많을 경우 채팅/1:1 문의를 이용해 주세요.
        </div>
      </div>

      <!-- 3) 상담/안내 -->
      <div class="col-12 col-md-3">
        <div class="fw-bold mb-2">상담/예약 안내</div>

        <ul class="small text-secondary mb-0 ps-3">
          <li>예약 확정은 결제 완료 후 진행됩니다.</li>
          <li>취소/환불 규정은 상품별로 상이합니다.</li>
          <li>노쇼/지각 정책은 매장 정책을 따릅니다.</li>
          <li>문의 답변은 영업시간 내 순차 처리됩니다.</li>
        </ul>
      </div>

      <!-- 4) 공지사항 -->
      <div class="col-12 col-md-3">
        <div class="d-flex align-items-center justify-content-between mb-2">
          <div class="fw-bold">공지사항</div>
          <a class="small text-decoration-none" href="${path}/notice.do">더보기 +</a>
        </div>

        <div class="border rounded-3 p-3 bg-light">
          <!-- 공지 3~5개 리스트 -->
          <div class="d-flex justify-content-between small py-1 border-bottom">
            <a class="text-decoration-none text-dark text-truncate" style="max-width: 75%;" href="/notice/1">
              시스템 점검 안내 (02/26)
            </a>
            <span class="text-secondary">02.20</span>
          </div>
          <div class="d-flex justify-content-between small py-1 border-bottom">
            <a class="text-decoration-none text-dark text-truncate" style="max-width: 75%;" href="/notice/2">
              이용약관 개정 사전 공지
            </a>
            <span class="text-secondary">02.18</span>
          </div>
          <div class="d-flex justify-content-between small py-1">
            <a class="text-decoration-none text-dark text-truncate" style="max-width: 75%;" href="/notice/3">
              이벤트 당첨자 발표
            </a>
            <span class="text-secondary">02.10</span>
          </div>
        </div>
      </div>

    </div>

    <!-- 가장 하단 회사 정보 -->
    <div class="pt-3 mt-3 border-top small text-secondary">
      <div class="d-flex flex-wrap gap-3">
        <span>회사명: (주)OOO</span>
        <span>대표: 홍길동</span>
        <span>사업자번호: 123-45-67890</span>
        <span>주소: 서울특별시 OO구 OO로 00</span>
      </div>
      <div class="mt-1">
        <a class="text-secondary text-decoration-none me-2" href="/terms">이용약관</a>
        <a class="text-secondary text-decoration-none me-2" href="/privacy">개인정보처리방침</a>
        <a class="text-secondary text-decoration-none" href="/policy">운영정책</a>
      </div>
    </div>

  </div>
</footer>
<!-- Footer 끝 -->