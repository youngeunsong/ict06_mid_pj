<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<style>
  .big-rest-card{
    border:1px solid #e5e7eb;
    border-radius:22px;
    background:#fff;
    padding:16px;
    transition:.18s ease;
  }

  .big-rest-card:hover{
    transform:translateY(-2px);
    box-shadow:0 10px 24px rgba(17,24,39,.06);
  }

  .big-rest-card__link{
    display:block;
  }

  .big-rest-card__thumb-wrap{
    position:relative;
    height:180px;
    border-radius:18px;
    overflow:hidden;
    background:#f3f4f6;
  }

  .big-rest-card__thumb{
    width:100%;
    height:100%;
    object-fit:cover;
    display:block;
  }

  .big-rest-card__rank{
    position:absolute;
    top:12px;
    left:12px;
    padding:7px 12px;
    border-radius:999px;
    background:rgba(17,24,39,.82);
    color:#fff;
    font-size:13px;
    font-weight:800;
    line-height:1;
  }

  .big-rest-card__rank.top1{ background:#f59e0b; }
  .big-rest-card__rank.top2{ background:#9ca3af; }
  .big-rest-card__rank.top3{ background:#f87171; }

  .big-rest-card__bookmark{
    position:absolute;
    top:12px;
    right:12px;
    width:40px;
    height:40px;
    border:none;
    border-radius:50%;
    background:rgba(255,255,255,.92);
    color:#6b7280;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:18px;
    box-shadow:0 4px 10px rgba(0,0,0,.08);
  }

  .big-rest-card__title{
    font-size:28px;
    font-weight:900;
    letter-spacing:-0.02em;
    line-height:1.2;
  }

  .big-rest-card__badge{
    padding:7px 12px;
    border-radius:999px;
    border:1px solid #e5e7eb;
    background:#f9fafb;
    color:#6b7280;
    font-size:13px;
    font-weight:700;
  }

  .big-rest-card__address{
    color:#6b7280;
    font-size:14px;
  }

  .big-rest-card__meta{
    color:#4b5563;
    font-size:15px;
    font-weight:700;
  }

  .big-rest-card__meta .fa-star{
    color:#f59e0b;
  }

  .big-rest-card__desc{
    color:#4b5563;
    font-size:15px;
    line-height:1.7;
  }

  @media (max-width: 991.98px){
    .big-rest-card__thumb-wrap{
      height:220px;
      margin-bottom:12px;
    }

    .big-rest-card__title{
      font-size:24px;
    }
  }

  @media (max-width: 575.98px){
    .big-rest-card{
      padding:14px;
    }

    .big-rest-card__title{
      font-size:21px;
    }
  }
</style>

<div class="big-rest-card">
  <a href="${path}/restaurantDetail.rs?place_id=${place.place_id}" class="big-rest-card__link text-decoration-none text-dark">
    <div class="row g-3 align-items-center">

      <!-- 이미지 -->
      <div class="col-lg-3">
        <div class="big-rest-card__thumb-wrap">
          <img src="${place.image_url}" alt="${place.name}" loading="lazy" class="big-rest-card__thumb"/>

          <span class="big-rest-card__rank ${rank == 1 ? 'top1' : rank == 2 ? 'top2' : rank == 3 ? 'top3' : ''}">
            ${rank}위
          </span>

          <button type="button"
                  class="big-rest-card__bookmark"
                  data-place-id="${place.place_id}"
                  onclick="toggleBookmark(event, this)">
            <i class="${favoritePlaceIds.contains(place.place_id) ? 'fa-solid' : 'fa-regular'} fa-bookmark"></i>
          </button>
        </div>
      </div>

      <!-- 내용 -->
      <div class="col-lg-9">
        <div class="d-flex flex-wrap align-items-center gap-2 mb-2">
          <div class="big-rest-card__title">${place.name}</div>
          <span class="big-rest-card__badge">실시간 인기</span>
        </div>

        <div class="big-rest-card__address mb-2">
          <i class="bi bi-geo-alt-fill text-danger"></i>
          ${place.address}
        </div>

        <div class="big-rest-card__meta d-flex flex-wrap gap-3 mb-2">
          <span><i class="fa-solid fa-star"></i> ${avgRatingMap[place.place_id]}</span>
          <span><i class="fa-regular fa-eye"></i> ${place.view_count}</span>
          <span><i class="fa-regular fa-comment"></i> ${reviewCountMap[place.place_id]}</span>
        </div>

        <div class="big-rest-card__desc">
          ${empty place.description ? '분위기 좋은 인기 맛집입니다.' : place.description}
        </div>
      </div>

    </div>
  </a>
</div>