<!-- 
 * @author 송혜진
 * 최초작성일: 2026-02-26
 * 최종수정일: 2026-03-02
 
-->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Footer 시작 -->
<footer class="border-top bg-white">
  <div class="container px-4 py-5"> <div class="row g-5 align-items-start"> <div class="col-12 col-md-4">
        <div class="fw-bold mb-3 fs-5">고객센터</div> <div class="d-flex align-items-center gap-2 mb-2">
          <span class="text-success" style="font-size: 0.8rem;">●</span>
          <div class="fs-4 fw-bold text-dark">1544-2222</div>
        </div>

        <div class="small text-secondary mb-3">
          운영시간: 09:00 ~ 18:00 (주말/공휴일 제외)
        </div>

        <div class="d-flex align-items-center gap-2">
          <a href="${path}/FAQ.do" class="btn btn-sm btn-outline-secondary py-0 px-2" style="font-size: 0.75rem;">FAQ</a>
          <a href="${path}/inquiry.do" class="btn btn-sm btn-outline-secondary py-0 px-2" style="font-size: 0.75rem;">1:1문의</a>
        </div>
      </div>

      <div class="col-12 col-md-4">
        <div class="fw-bold mb-3 fs-5">ARS / 전화번호</div>

        <div class="d-flex justify-content-between py-2 border-bottom small">
          <span class="text-secondary">예약/결제 문의</span>
          <span class="fw-bold">1544-5353</span>
        </div>
        <div class="d-flex justify-content-between py-2 border-bottom small">
          <span class="text-secondary">기업/제휴 문의</span>
          <span class="fw-bold">1661-4873</span>
        </div>
        <div class="d-flex justify-content-between py-2 border-bottom small">
          <span class="text-secondary">분실/긴급 문의</span>
          <span class="fw-bold">1544-6722</span>
        </div>

        <div class="small text-muted mt-2">
          통화량이 많을 경우 채팅/1:1 문의를 이용해 주세요.
        </div>
      </div>

      <div class="col-12 col-md-4">
        <div class="fw-bold mb-3 fs-5">상담/예약 안내</div>

        <ul class="small text-secondary mb-0 ps-3" style="line-height: 1.8;">
          <li>예약 확정은 결제 완료 후 진행됩니다.</li>
          <li>취소/환불 규정은 상품별로 상이합니다.</li>
          <li>노쇼/지각 정책은 매장 정책을 따릅니다.</li>
          <li>문의 답변은 영업시간 내 순차 처리됩니다.</li>
        </ul>
      </div>

    </div> <div class="pt-4 mt-5 border-top small text-secondary">
      <div class="d-flex flex-wrap gap-3 mb-2">
        <span>회사명: (주)맛침내</span>
        <span>대표: 홍길동</span>
        <span>사업자번호: 123-45-67890</span>
        <span>주소: 서울특별시 OO구 OO로 00</span>
      </div>
      <div class="d-flex gap-3">
        <a class="text-secondary text-decoration-none fw-bold" href="/terms">이용약관</a>
        <a class="text-secondary text-decoration-none fw-bold" href="/privacy">개인정보처리방침</a>
        <a class="text-secondary text-decoration-none" href="/policy">운영정책</a>
      </div>
    </div>

  </div>
</footer>
<!-- Footer 끝 -->