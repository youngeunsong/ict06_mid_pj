document.addEventListener("DOMContentLoaded", function () {

  // =========================
  // 1) 리뷰 더보기 / 접기
  // =========================
  const btnMore = document.getElementById("btnMoreReviews");

  if (btnMore) {
    btnMore.dataset.mode = "more";

    btnMore.addEventListener("click", function () {
      if (btnMore.dataset.mode === "collapse") {
        collapseReviews();
        return;
      }
      loadMore();
    });

    function loadMore() {
      const offset = parseInt(btnMore.getAttribute("data-offset") || "0", 10);
      const limit = 5;
      const total = parseInt(btnMore.getAttribute("data-total") || "0", 10);

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
              throw new Error("HTTP " + res.status + ": " + t);
            });
          }
          return res.json();
        })
        .then(function (list) {
          if (!list || list.length === 0) {
            btnMore.textContent = "접기";
            btnMore.dataset.mode = "collapse";
            return;
          }

          const wrap = document.getElementById("reviewList");

          list.forEach(function (rv) {
            const div = document.createElement("div");
            div.className = "review-item border rounded-3 p-3 mb-2";
            div.setAttribute("data-loaded", "1");

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

          const newOffset = offset + list.length;
          btnMore.setAttribute("data-offset", String(newOffset));

          if (total > 0 && newOffset >= total) {
            btnMore.textContent = "접기";
            btnMore.dataset.mode = "collapse";
          }
        })
        .catch(function (err) {
          console.error(err);
        });
    }

    function collapseReviews() {
      const wrap = document.getElementById("reviewList");
      wrap.querySelectorAll('[data-loaded="1"]').forEach(function (el) {
        el.remove();
      });

      btnMore.setAttribute("data-offset", "5");
      btnMore.textContent = "더보기";
      btnMore.dataset.mode = "more";
    }
  }

  // =========================
  // 2) 즐겨찾기(저장) 토글
  // =========================
  const btnFav = document.getElementById("btnFavorite");
  const btnFavSide = document.getElementById("btnFavoriteSide");

  function applyFavoriteState(isOn) {
    [btnFav, btnFavSide].forEach(function (btn) {
      if (!btn) return;

      const icon = btn.querySelector("i");
      if (!icon) return;

      if (isOn) {
        btn.classList.add("is-on");
        icon.classList.remove("fa-regular");
        icon.classList.add("fa-solid");
      } else {
        btn.classList.remove("is-on");
        icon.classList.remove("fa-solid");
        icon.classList.add("fa-regular");
      }
    });
  }

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
            location.href = CTX + "/login.do";
            return;
          }

          if (!data.ok) return;

          applyFavoriteState(data.favorite);
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
  function formatDate(v) {
    if (v === null || v === undefined || v === "") return "";

    let d = new Date(Number(v));
    if (isNaN(d.getTime())) d = new Date(v);
    if (isNaN(d.getTime())) return String(v);

    const y = d.getFullYear();
    const m = String(d.getMonth() + 1).padStart(2, "0");
    const day = String(d.getDate()).padStart(2, "0");
    const hh = String(d.getHours()).padStart(2, "0");
    const mm = String(d.getMinutes()).padStart(2, "0");

    return y + "-" + m + "-" + day + " " + hh + ":" + mm;
  }

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
});