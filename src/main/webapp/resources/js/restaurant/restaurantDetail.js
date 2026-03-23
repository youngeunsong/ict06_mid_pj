// [맛집 상세 페이지 초기 설정]
// 리뷰 더보기, 즐겨찾기 토글 등 상세 페이지에서 사용하는 동적 기능을 연결하기 위해 사용
document.addEventListener("DOMContentLoaded", function () {

  // =========================
  // 1) 리뷰 더보기 / 접기
  // =========================
  const btnMore = document.getElementById("btnMoreReviews");

  // [리뷰 더보기 버튼 초기화]
  // 리뷰가 있는 경우에만 더보기/접기 상태를 버튼의 dataset으로 관리하기 위해 사용
  if (btnMore) {
    btnMore.dataset.mode = "more"; // 초기 상태는 "더보기"

    btnMore.addEventListener("click", function () {
      if (btnMore.dataset.mode === "collapse") {
        collapseReviews(); // 접기 상태일 때는 추가 리뷰 제거
        return;
      }
      loadMore(); // 기본 상태에서는 리뷰 추가 조회
    });

    // [리뷰 추가 조회]
    // 상세 페이지 첫 진입 시 보이지 않는 다음 리뷰를 AJAX로 가져와 목록 뒤에 붙이기 위해 사용
    function loadMore() {
      const offset = parseInt(btnMore.getAttribute("data-offset") || "0", 10); // 현재까지 출력한 리뷰 수
      const limit = 5; // 한 번에 추가할 리뷰 개수
      const total = parseInt(btnMore.getAttribute("data-total") || "0", 10); // 전체 리뷰 개수

      if (!PLACE_ID) {
        console.error("PLACE_ID is empty");
        return;
      }

      const url = CTX + "/restaurantReviewMore.rs"
        + "?place_id=" + encodeURIComponent(PLACE_ID)
        + "&offset=" + encodeURIComponent(offset)
        + "&limit=" + encodeURIComponent(limit);

      fetch(url)
        .then(function (res) {
          if (!res.ok) {
            return res.text().then(function (t) {
              throw new Error("HTTP " + res.status + ": " + t); // 서버 응답 오류 내용까지 같이 확인
            });
          }
          return res.json();
        })
        .then(function (list) {
          if (!list || list.length === 0) {
            btnMore.textContent = "접기";
            btnMore.dataset.mode = "collapse"; // 더 불러올 리뷰가 없으면 버튼 동작을 접기로 전환
            return;
          }

          const wrap = document.getElementById("reviewList");

          list.forEach(function (rv) {
            const div = document.createElement("div");
            div.className = "review-item border rounded-3 p-3 mb-2";
            div.setAttribute("data-loaded", "1"); // 더보기로 추가된 리뷰만 따로 구분해서 접기 시 제거하기 위해 사용

            div.innerHTML =
                '<div class="d-flex justify-content-between align-items-center">'
              +   '<div class="fw-bold">' + escapeHtml(rv.user_id || "") + '</div>'
              +   '<div style="color:#22c55e; font-weight:700;">'
              +     '<i class="fa-solid fa-star"></i> ' + (rv.rating || 0)
              +   '</div>'
              + '</div>'
              + '<div class="text-muted" style="font-size:12px;">' + formatDate(rv.reviewDate) + '</div>'
              + '<div class="mt-2">' + escapeHtml(rv.content || "") + '</div>';

            wrap.appendChild(div);
          });

          const newOffset = offset + list.length; // 실제로 추가된 개수만큼 다음 시작 위치 갱신
          btnMore.setAttribute("data-offset", String(newOffset));

          if (total > 0 && newOffset >= total) {
            btnMore.textContent = "접기";
            btnMore.dataset.mode = "collapse"; // 전체 리뷰를 다 불러오면 버튼을 접기 모드로 전환
          }
        })
        .catch(function (err) {
          console.error(err);
        });
    }

    // [리뷰 접기]
    // 더보기로 추가된 리뷰만 제거하고, 처음에 서버에서 렌더링된 리뷰 목록 상태로 되돌리기 위해 사용
    function collapseReviews() {
      const wrap = document.getElementById("reviewList");
      wrap.querySelectorAll('[data-loaded="1"]').forEach(function (el) {
        el.remove(); // 더보기로 추가된 리뷰만 삭제
      });

      btnMore.setAttribute("data-offset", "5"); // 초기 리뷰 5개 기준으로 offset 복원
      btnMore.textContent = "더보기";
      btnMore.dataset.mode = "more";
    }
  }

  // =========================
  // 2) 즐겨찾기(저장) 토글
  // =========================
  const btnFav = document.getElementById("btnFavorite");
  const btnFavSide = document.getElementById("btnFavoriteSide");

  // [즐겨찾기 버튼 상태 반영]
  // 상단 저장 버튼과 우측 저장 버튼의 상태를 항상 동일하게 맞추기 위해 공통 함수로 처리
  function applyFavoriteState(isOn) {
    [btnFav, btnFavSide].forEach(function (btn) {
      if (!btn) return;

      const icon = btn.querySelector("i");
      if (!icon) return;

      if (isOn) {
        btn.classList.add("is-on");
        icon.classList.remove("fa-regular");
        icon.classList.add("fa-solid"); // 저장된 상태는 꽉 찬 하트 아이콘 사용
      } else {
        btn.classList.remove("is-on");
        icon.classList.remove("fa-solid");
        icon.classList.add("fa-regular"); // 저장 해제 상태는 빈 하트 아이콘 사용
      }
    });
  }

  // [즐겨찾기 버튼 이벤트 연결]
  // 버튼 위치와 상관없이 같은 토글 로직을 재사용하기 위해 버튼별로 공통 함수에 바인딩
  function bindFavoriteButton(btn) {
    if (!btn) return;

    btn.addEventListener("click", function () {
      if (!PLACE_ID) {
        console.error("PLACE_ID is empty");
        return;
      }

      fetch(CTX + "/favoriteToggle.rs?place_id=" + encodeURIComponent(PLACE_ID))
        .then(function (res) {
          if (!res.ok) {
            return res.text().then(function (t) {
              throw new Error("HTTP " + res.status + ": " + t);
            });
          }
          return res.json();
        })
        .then(function (data) {
          if (data.needLogin) {
            alert("로그인이 필요합니다.");
            location.href = CTX + "/login.do"; // 비로그인 상태면 로그인 페이지로 이동
            return;
          }

          if (!data.ok) return;

          applyFavoriteState(data.favorite); // 서버에서 반환한 최종 상태값으로 버튼 UI 동기화
        })
        .catch(function (err) {
          console.error(err);
        });
    });
  }

  bindFavoriteButton(btnFav);
  bindFavoriteButton(btnFavSide);

  // =========================
  // util
  // =========================

  // [날짜 포맷 변환]
  // 서버에서 받은 날짜값을 리뷰 목록에서 보기 쉬운 yyyy-MM-dd HH:mm 형식으로 맞추기 위해 사용
  function formatDate(v) {
    if (v === null || v === undefined || v === "") return "";

    let d = new Date(Number(v)); // timestamp 숫자 형태 먼저 시도
    if (isNaN(d.getTime())) d = new Date(v); // 실패 시 문자열 날짜로 재시도
    if (isNaN(d.getTime())) return String(v); // 둘 다 실패하면 원본 그대로 반환

    const y = d.getFullYear();
    const m = String(d.getMonth() + 1).padStart(2, "0");
    const day = String(d.getDate()).padStart(2, "0");
    const hh = String(d.getHours()).padStart(2, "0");
    const mm = String(d.getMinutes()).padStart(2, "0");

    return y + "-" + m + "-" + day + " " + hh + ":" + mm;
  }

  // [문자열 이스케이프 처리]
  // 리뷰 내용과 작성자 아이디를 HTML로 삽입할 때 특수문자 해석을 막기 위해 사용
  function escapeHtml(s) {
    return String(s).replace(/[&<>"']/g, function (c) {
      return {
        "&": "&amp;",
        "<": "&lt;",
        ">": "&gt;",
        '"': "&quot;",
        "'": "&#39;"
      }[c];
    });
  }
  
    // =========================
  // 3) 예약 가능 일정 UI
  // =========================
  const dateSlider = document.getElementById("reserveDateSlider");
  const timeSlotsWrap = document.getElementById("reserveTimeSlots");
  const selectedReserveDateInput = document.getElementById("selectedReserveDate");
  const selectedVisitTimeInput = document.getElementById("selectedVisitTime");

  if (dateSlider && timeSlotsWrap && selectedReserveDateInput && selectedVisitTimeInput) {
    const DAYS_TO_SHOW = 7;

    // 예시 시간 슬롯
    const baseSlots = [
      { start: "10:00", end: "11:50" },
      { start: "12:00", end: "13:50" },
      { start: "14:00", end: "15:50" },
      { start: "17:00", end: "18:50" },
      { start: "19:00", end: "20:50" }
    ];

    const dayLabels = ["일", "월", "화", "수", "목", "금", "토"];

    // 오늘부터 +7일 생성
    const reserveDates = [];
    const today = new Date();

    for (let i = 0; i < DAYS_TO_SHOW; i++) {
      const d = new Date(today);
      d.setDate(today.getDate() + i);

      const yyyy = d.getFullYear();
      const mm = String(d.getMonth() + 1).padStart(2, "0");
      const dd = String(d.getDate()).padStart(2, "0");
      const day = dayLabels[d.getDay()];

      reserveDates.push({
        value: yyyy + "-" + mm + "-" + dd,
        labelTop: mm + "/" + dd,
        labelBottom: "(" + day + ")"
      });
    }

    let activeDate = reserveDates[0].value;

    renderDateButtons();
    renderTimeSlots(activeDate);

    function renderDateButtons() {
      dateSlider.innerHTML = "";

      reserveDates.forEach(function (item) {
        const btn = document.createElement("button");
        btn.type = "button";
        btn.className = "r-dateChip" + (item.value === activeDate ? " is-active" : "");
        btn.innerHTML =
            '<div class="r-dateTop">' + item.labelTop + '</div>'
          + '<div class="r-dateBottom">' + item.labelBottom + '</div>';

        btn.addEventListener("click", function () {
			  if (activeDate === item.value) {
			    activeDate = "";
			    selectedReserveDateInput.value = "";
			    selectedVisitTimeInput.value = "";
			
			    renderDateButtons();
			    renderTimeSlots("");
			    return;
			  }
			
			  activeDate = item.value;
			  selectedReserveDateInput.value = item.value;
			  selectedVisitTimeInput.value = "";
			
			  renderDateButtons();
			  renderTimeSlots(item.value);
			});
			
			dateSlider.appendChild(btn);
	      });

      selectedReserveDateInput.value = activeDate;
    }

    function renderTimeSlots(dateValue) {
	  timeSlotsWrap.innerHTML = "";
	
	  if (!dateValue) {
	    return;
	  }

      // 임시 예시 비활성화 규칙
      // 날짜 인덱스와 슬롯 인덱스를 조합해서 일부 슬롯을 회색 처리
      const dateIndex = reserveDates.findIndex(function (d) {
        return d.value === dateValue;
      });

      baseSlots.forEach(function (slot, idx) {
        const btn = document.createElement("button");
        btn.type = "button";
        btn.className = "r-timeSlot";

        const isDisabled =
          (dateIndex === 0 && idx === 1) ||
          (dateIndex === 2 && idx === 3) ||
          (dateIndex === 4 && idx === 0) ||
          (dateIndex === 6 && idx === 4);

        if (isDisabled) {
          btn.classList.add("is-disabled");
          btn.disabled = true;
        }

        btn.textContent = slot.start + " ~ " + slot.end;

        btn.addEventListener("click", function () {
		  if (btn.disabled) return;
		
		  const alreadySelected = btn.classList.contains("is-selected");
		
		  timeSlotsWrap.querySelectorAll(".r-timeSlot").forEach(function (el) {
		    el.classList.remove("is-selected");
		  });
		
		  if (alreadySelected) {
		    selectedVisitTimeInput.value = "";
		    return;
		  }
		
		  btn.classList.add("is-selected");
		  selectedVisitTimeInput.value = slot.start;
		});

        timeSlotsWrap.appendChild(btn);
      });
    }
  }
});