<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>404 - 페이지를 찾을 수 없습니다</title>

  <style>
    :root{
      --e-bg1:#f7fbf5;
      --e-bg2:#eef8ed;
      --e-line:#cfe9cf;
      --e-main:#2f9f67;
      --e-main-dark:#1d7d4f;
      --e-text:#2f3b34;
      --e-blue:#75c8ef;
      --e-shadow:0 20px 45px rgba(71, 132, 91, .12);
    }

    * { box-sizing:border-box; }

    body{
      margin:0;
      min-height:100vh;
      font-family:"Malgun Gothic","맑은 고딕","Apple SD Gothic Neo",sans-serif;
      background:
        radial-gradient(circle at top left, #f1faef 0, #f1faef 18%, transparent 18.2%) no-repeat,
        radial-gradient(circle at right 15% top 8%, #edf7ec 0, #edf7ec 7%, transparent 7.2%) no-repeat,
        linear-gradient(180deg, var(--e-bg1) 0%, var(--e-bg2) 100%);
      color:var(--e-text);
    }

    .error-wrap{
      width:min(1180px, 92%);
      margin:0 auto;
      min-height:100vh;
      display:flex;
      align-items:center;
      justify-content:center;
      padding:40px 0;
    }

    .error-card{
      position:relative;
      width:100%;
      max-width:1080px;
      background:rgba(255,255,255,.82);
      backdrop-filter:blur(2px);
      border:4px solid var(--e-line);
      border-radius:42px;
      box-shadow:var(--e-shadow);
      padding:28px 28px 24px;
      overflow:hidden;
    }

    .error-card::before{
      content:"";
      position:absolute;
      inset:12px;
      border:3px dashed #d8edd8;
      border-radius:32px;
      pointer-events:none;
    }

    .error-body{
      position:relative;
      margin-top:6px;
      min-height:620px;
      z-index:1;
    }

    .mascot-zone{
      position:relative;
      min-height:620px;
      display:flex;
      align-items:center;
      justify-content:center;
      padding-top:18px;
    }

    .mascot-shadow{
      position:absolute;
      left:50%;
      transform:translateX(-50%);
      bottom:54px;
      width:600px;
      height:68px;
      background:rgba(116, 182, 128, .18);
      border-radius:50%;
      filter:blur(1px);
      z-index:1;
    }

    .mascot-img{
      position:relative;
      width:920px;
      max-width:100%;
      z-index:2;
      user-select:none;
      pointer-events:none;
      filter:drop-shadow(0 10px 16px rgba(76, 141, 94, .15));
    }

    .question{
      position:absolute;
      color:#88c97e;
      font-weight:900;
      line-height:1;
      text-shadow:0 2px 0 rgba(255,255,255,.7);
      animation:floatQ 2.6s ease-in-out infinite;
      z-index:3;
      user-select:none;
    }

    .q1{ left:50%; top:58px;  margin-left:-382px; font-size:82px; animation-delay:0s; }
    .q2{ left:50%; top:8px;   margin-left:160px;  font-size:80px; animation-delay:.25s; }
    .q3{ left:50%; top:68px;  margin-left:410px;  font-size:78px; animation-delay:.5s; }
    .q4{ left:50%; top:198px; margin-left:282px;  font-size:66px; animation-delay:.75s; }

    @keyframes floatQ{
      0%,100%{ transform:translateY(0); }
      50%{ transform:translateY(-10px); }
    }

    .sweat{
      position:absolute;
      width:24px;
      height:42px;
      border:4px solid var(--e-blue);
      border-top:none;
      border-radius:50% 50% 60% 60%;
      transform:rotate(-8deg);
      background:rgba(255,255,255,.28);
      z-index:3;
      animation:drip 1.9s ease-in-out infinite;
    }

    .s1{ left:50%; top:278px; margin-left:-406px; }
    .s2{ left:50%; top:486px; margin-left:-360px; animation-delay:.2s; }
    .s3{ left:50%; top:266px; margin-left:418px; }
    .s4{ left:50%; top:474px; margin-left:446px; animation-delay:.35s; }

    @keyframes drip{
      0%,100%{ transform:translateY(0) rotate(-8deg); }
      50%{ transform:translateY(5px) rotate(-4deg); }
    }

    .egg-hitbox{
      position:absolute;
      left:50%;
      top:50%;
      transform:translate(-50%, -50%);
      width:220px;
      height:240px;
      margin-left:-205px;
      margin-top:88px;
      z-index:4;
      background:transparent;
      cursor:pointer;
      border-radius:28px;
    }

    .egg-bubble{
      position:absolute;
      left:50%;
      top:50%;
      transform:translateX(-50%) translateY(8px);
      min-width:300px;
      max-width:480px;
      padding:14px 20px;
      border-radius:24px;
      background:#ffffff;
      border:3px solid #11a4cf;
      color:var(--e-main-dark);
      font-size:20px;
      font-weight:800;
      line-height:1.45;
      text-align:center;
      box-shadow:0 14px 24px rgba(78, 139, 95, .16);
      z-index:10;
      opacity:0;
      pointer-events:none;
      margin-left:-170px;
      margin-top:-128px;
      transition:opacity .25s ease, transform .25s ease;
    }

    .egg-bubble.show{
      opacity:1;
      transform:translateX(-50%) translateY(0);
    }

    .egg-bubble::after{
      content:"";
      position:absolute;
      left:95px;
      bottom:-14px;
      width:24px;
      height:24px;
      background:#ffffff;
      border-right:3px solid #11a4cf;
      border-bottom:3px solid #11a4cf;
      transform:rotate(45deg);
    }

    .action-row{
      position:relative;
      z-index:2;
      display:flex;
      justify-content:center;
      gap:14px;
      margin-top:-10px;
      flex-wrap:wrap;
    }

    .error-btn{
      display:inline-flex;
      align-items:center;
      justify-content:center;
      min-width:180px;
      height:56px;
      padding:0 24px;
      border:none;
      border-radius:999px;
      font-size:18px;
      font-weight:800;
      text-decoration:none;
      transition:.2s ease;
      box-shadow:0 10px 18px rgba(78, 139, 95, .13);
    }

    .error-btn.home{
      background:#7ed957;
      color:#ffffff;
    }

    .error-btn.back{
      background:#ffffff;
      color:var(--e-main-dark);
      border:2px solid #cfe8cf;
    }

    .error-btn:hover{
      transform:translateY(-2px);
      text-decoration:none;
      color:inherit;
    }

    .bg-pin{
      position:absolute;
      width:38px;
      height:38px;
      border:7px solid rgba(207,233,207,.7);
      border-radius:50% 50% 50% 0;
      transform:rotate(-45deg);
      opacity:.55;
      z-index:0;
    }

    .bg-pin::after{
      content:"";
      position:absolute;
      width:12px;
      height:12px;
      background:rgba(207,233,207,.8);
      border-radius:50%;
      top:6px;
      left:6px;
    }

    .bg1{ left:-10px; top:230px; }
    .bg2{ right:42px; top:52px; transform:rotate(-45deg) scale(1.1); }
    .bg3{ right:140px; top:24px; transform:rotate(-45deg) scale(.85); }

    /* ===== 별 찾기 이벤트 ===== */
    .map-trigger{
      position:absolute;
      left:50%;
      top:50%;
      transform:translate(-50%, -50%);
      width:32px;
      height:25px;
      margin-left:160px;
      margin-top:58px;
      z-index:8;
      cursor:pointer;
      border-radius:50%;
      background:transparent;
    }

    .star-play-area{
      position:absolute;
      left:50%;
      top:50%;
      transform:translate(-50%, -50%);
      width:840px;
      height:500px;
      margin-left:0;
      margin-top:-6px;
      z-index:6;
      pointer-events:none;
      overflow:hidden;
    }

    .star-play-area.active{
      pointer-events:auto;
    }

    .star-collector{
      position:absolute;
      right:38px;
      bottom:16px;
      width:124px;
      padding:10px 10px 8px;
      border-radius:18px;
      background:rgba(255,255,255,.96);
      border:2px solid #cfe8cf;
      box-shadow:0 10px 20px rgba(78, 139, 95, .12);
      z-index:9;
      display:none;
    }

    .star-collector.show{
      display:block;
    }

    .collector-title{
      display:none;
    }

    .collector-count{
      font-size:12px;
      font-weight:800;
      color:#6b8b74;
      text-align:center;
      margin-top:6px;
    }

    .collector-slots{
      display:grid;
      grid-template-columns:repeat(3, 1fr);
      gap:6px;
    }

    .collector-slot{
      width:30px;
      height:30px;
      border-radius:10px;
      background:#f5faf4;
      border:2px dashed #d8edd8;
      display:flex;
      align-items:center;
      justify-content:center;
      margin:0 auto;
      font-size:16px;
      transition:.2s ease;
    }

    .collector-slot.filled{
      border-style:solid;
      background:#ffffff;
      transform:scale(1.05);
    }

    .event-star{
      position:absolute;
      width:38px;
      height:38px;
      display:flex;
      align-items:center;
      justify-content:center;
      font-size:34px;
      line-height:1;
      cursor:pointer;
      user-select:none;
      opacity:0;
      transform:scale(.6);
      animation:starPop .22s ease forwards, starFloat 1.2s ease-in-out infinite;
      filter:drop-shadow(0 0 8px rgba(255,255,255,.85));
    }

    .event-star.collected{
      pointer-events:none;
      animation:none;
      opacity:0 !important;
      transform:scale(.2) !important;
      transition:.15s ease;
    }

    @keyframes starPop{
      to{
        opacity:1;
        transform:scale(1);
      }
    }

    @keyframes starFloat{
      0%,100%{ transform:translateY(0) scale(1); }
      50%{ transform:translateY(-6px) scale(1.04); }
    }
  </style>
</head>
<body>
  <div class="error-wrap">
    <section class="error-card">
      <span class="bg-pin bg1"></span>
      <span class="bg-pin bg2"></span>
      <span class="bg-pin bg3"></span>

      <div class="error-body">
        <div class="mascot-zone">
          <div class="mascot-shadow"></div>

          <span class="question q1">?</span>
          <span class="question q2">?</span>
          <span class="question q3">?</span>
          <span class="question q4">?</span>

          <span class="sweat s1"></span>
          <span class="sweat s2"></span>
          <span class="sweat s3"></span>
          <span class="sweat s4"></span>

          <div id="eggBubble" class="egg-bubble"></div>
          <div id="eggHitbox" class="egg-hitbox" aria-label="숨겨진 심볼 클릭 영역"></div>

          <div id="mapTrigger" class="map-trigger" aria-label="별 찾기 시작"></div>

          <div id="starPlayArea" class="star-play-area"></div>

          <div id="starCollector" class="star-collector">
            <div class="collector-title">숨겨진 별 찾기</div>
            <div class="collector-slots" id="collectorSlots">
              <div class="collector-slot"></div>
              <div class="collector-slot"></div>
              <div class="collector-slot"></div>
              <div class="collector-slot"></div>
              <div class="collector-slot"></div>
              <div class="collector-slot"></div>
            </div>
            <div class="collector-count" id="collectorCount">0 / 6</div>
          </div>

          <img
            class="mascot-img"
            src="${path}/resources/images/common/error-symbol.png"
            alt="길을 잃은 심볼 캐릭터">
        </div>
      </div>

      <div class="action-row">
        <a href="${path}/main.do" class="error-btn home">홈으로 가기</a>
        <a href="javascript:history.back();" class="error-btn back">이전 페이지</a>
      </div>
    </section>
  </div>

  <script>
    (function () {
      const hitbox = document.getElementById("eggHitbox");
      const bubble = document.getElementById("eggBubble");

      const mapTrigger = document.getElementById("mapTrigger");
      const starPlayArea = document.getElementById("starPlayArea");
      const starCollector = document.getElementById("starCollector");
      const collectorSlots = document.querySelectorAll(".collector-slot");
      const collectorCount = document.getElementById("collectorCount");

      let clickCount = 0;
      let hideTimer = null;

      let starEventMode = false;
      let collectedCount = 0;
      let collectedFlags = [false, false, false, false, false, false];

      const starColors = [
        "#8a2be2",
        "#ffd84d",
        "#000080",
        "#FF1493",
        "#00BFFF",
        "#A7FC00"
      ];

      function showBubble(message, duration) {
        bubble.textContent = message;
        bubble.classList.add("show");

        if (hideTimer) {
          clearTimeout(hideTimer);
        }

        hideTimer = setTimeout(function () {
          bubble.classList.remove("show");
        }, duration || 2400);
      }

      function updateCollector() {
        collectorCount.textContent = collectedCount + " / 6";
      }

      function resetCollector() {
        collectorSlots.forEach(function (slot) {
          slot.textContent = "";
          slot.style.color = "";
          slot.classList.remove("filled");
        });

        collectedCount = 0;
        collectedFlags = [false, false, false, false, false, false];
        updateCollector();
      }

      function fillCollectorSlot(index, color) {
        const slot = collectorSlots[index];
        if (!slot) return;

        slot.textContent = "★";
        slot.style.color = color;
        slot.classList.add("filled");
      }

      function randomBetween(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
      }

      function getSpawnRange() {
        return {
          minX: 80,
          maxX: 770,
          minY: 28,
          maxY: 360
        };
      }

      function createStar(index, color) {
        if (!starEventMode) return;
        if (collectedFlags[index]) return;

        const range = getSpawnRange();

        const star = document.createElement("div");
        star.className = "event-star";
        star.textContent = "★";
        star.style.color = color;
        star.style.left = randomBetween(range.minX, range.maxX) + "px";
        star.style.top = randomBetween(range.minY, range.maxY) + "px";

        let removed = false;

        function removeStarAndRespawn() {
          if (removed) return;
          removed = true;

          if (star.parentNode) {
            star.remove();
          }

          if (starEventMode && !collectedFlags[index]) {
            setTimeout(function () {
              createStar(index, color);
            }, 300);
          }
        }

        star.addEventListener("click", function () {
          if (removed) return;
          if (collectedFlags[index]) return;

          removed = true;
          collectedFlags[index] = true;

          fillCollectorSlot(collectedCount, color);
          collectedCount++;
          updateCollector();

          star.classList.add("collected");

          setTimeout(function () {
            if (star.parentNode) {
              star.remove();
            }
          }, 150);

          if (collectedCount === 6) {
            finishStarEvent();
          }
        });

        starPlayArea.appendChild(star);

        setTimeout(function () {
          if (!collectedFlags[index]) {
            removeStarAndRespawn();
          }
        }, 1000);
      }

      function spawnStars() {
        starColors.forEach(function (color, index) {
          setTimeout(function () {
            createStar(index, color);
          }, index * 180);
        });
      }

      function startStarEvent() {
        if (starEventMode) {
          showBubble("이미 뭔가 반짝이고 있어요!", 1600);
          return;
        }

        starEventMode = true;
        starPlayArea.innerHTML = "";
        resetCollector();

        hitbox.style.pointerEvents = "none";
        starCollector.classList.add("show");
        starPlayArea.classList.add("active");

        showBubble("어? 뭔가 반짝였어요!", 2000);

        setTimeout(function () {
          spawnStars();
        }, 350);
      }

      function finishStarEvent() {
        showBubble("와! 별을 모두 찾았어요!", 2400);

        setTimeout(function () {
          starEventMode = false;
          hitbox.style.pointerEvents = "auto";
        }, 300);
      }

      hitbox.addEventListener("click", function () {
        if (starEventMode) return;

        clickCount++;

        if (clickCount === 5) {
          showBubble("심볼이 몰래 길을 찾고 있어요!");
        } else if (clickCount === 10) {
          showBubble("앗, 찾았다! ... 앗... 아직 아니에요..");
          clickCount = 0;
        }
      });

      mapTrigger.addEventListener("click", function () {
        startStarEvent();
      });
    })();
  </script>
</body>
</html>