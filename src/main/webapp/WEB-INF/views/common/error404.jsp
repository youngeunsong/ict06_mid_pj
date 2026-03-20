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

    * { box-sizing: border-box; }

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

    @media (max-width: 991px){
      .error-card{
        padding:24px 18px 22px;
        border-radius:32px;
      }

      .error-card::before{
        inset:10px;
        border-radius:24px;
      }

      .error-body{
        min-height:470px;
      }

      .mascot-zone{
        min-height:470px;
      }

      .mascot-shadow{
        width:400px;
        height:50px;
        bottom:44px;
      }

      .mascot-img{
        width:640px;
      }

      .q1{ top:58px; margin-left:-268px; font-size:66px; }
      .q2{ top:12px; margin-left:102px; font-size:64px; }
      .q3{ top:60px; margin-left:286px; font-size:62px; }
      .q4{ top:164px; margin-left:196px; font-size:52px; }

      .sweat{
        width:20px;
        height:34px;
      }

      .s1{ top:240px; margin-left:-286px; }
      .s2{ top:388px; margin-left:-252px; }
      .s3{ top:232px; margin-left:286px; }
      .s4{ top:378px; margin-left:306px; }

      .action-row{
        margin-top:-2px;
      }
    }

    @media (max-width: 575px){
      .error-wrap{
        width:94%;
        padding:22px 0;
      }

      .error-card{
        padding:18px 12px 18px;
      }

      .error-body{
        min-height:310px;
      }

      .mascot-zone{
        min-height:310px;
        padding-top:6px;
      }

      .mascot-shadow{
        width:220px;
        height:34px;
        bottom:28px;
      }

      .mascot-img{
        width:340px;
      }

      .q1{ top:44px; margin-left:-140px; font-size:42px; }
      .q2{ top:10px; margin-left:52px; font-size:40px; }
      .q3{ top:42px; margin-left:150px; font-size:40px; }
      .q4{ top:106px; margin-left:102px; font-size:32px; }

      .sweat{
        width:14px;
        height:24px;
        border-width:3px;
      }

      .s1{ top:154px; margin-left:-156px; }
      .s2{ top:246px; margin-left:-136px; }
      .s3{ top:150px; margin-left:152px; }
      .s4{ top:236px; margin-left:164px; }

      .error-btn{
        min-width:140px;
        height:48px;
        font-size:16px;
      }

      .action-row{
        margin-top:0;
      }
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
</body>
</html>