<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->

<!-- 본문 -->
<div class="page-body">
  <div class="container" style="max-width:860px;">

    <!-- 경로 -->
    <div class="breadcrumb-area">
      <a href="#">커뮤니티</a>
      <i class="bi bi-chevron-right" style="font-size:.65rem;"></i>
      <a href="#">자유게시판</a>
      <i class="bi bi-chevron-right" style="font-size:.65rem;"></i>
      <a href="#">게시글 상세</a>
      <i class="bi bi-chevron-right" style="font-size:.65rem;"></i>
      <span class="cur">수정</span>
    </div>

    <!-- 수정 카드 -->
    <div class="write-card">

      <!-- 카드 헤더 -->
      <div class="write-card-header">
        <div class="write-card-header-left">
          <i class="bi bi-pencil-square" style="color:var(--primary);font-size:1.1rem;"></i>
          <h2>게시글 수정</h2>
          <!-- post_id (hidden으로 넘길 값 표시용) -->
          <span class="post-id-badge">No. 42</span>
        </div>
        <span class="original-date">원본 작성일 : 2026.03.09</span>
      </div>

      <!-- 폼 (기존 데이터 pre-fill) -->
      <div class="write-form">

        <!-- 카테고리 : 기존값 pre-check (여행후기) -->
        <div>
          <div class="field-label">카테고리 <span class="required">*</span></div>
          <div class="cat-select-wrap">
            <input type="radio" name="category" id="cat1" class="cat-radio" value="여행후기" checked>
            <label for="cat1" class="cat-label">여행후기</label>
            <input type="radio" name="category" id="cat2" class="cat-radio" value="질문">
            <label for="cat2" class="cat-label">질문</label>
            <input type="radio" name="category" id="cat3" class="cat-radio" value="정보공유">
            <label for="cat3" class="cat-label">정보공유</label>
            <input type="radio" name="category" id="cat4" class="cat-radio" value="동행구해요">
            <label for="cat4" class="cat-label">동행구해요</label>
            <input type="radio" name="category" id="cat5" class="cat-radio" value="맛집추천">
            <label for="cat5" class="cat-label">맛집추천</label>
          </div>
        </div>

        <!-- 제목 : 기존값 pre-fill -->
        <div>
          <div class="field-label">제목 <span class="required">*</span></div>
          <input type="text" id="titleInput" class="input-title"
            value="도쿄 3박 4일 완벽 가이드 – 현지인이 알려주는 숨은 맛집"
            maxlength="200" oninput="countTitle()">
          <div class="char-counter" id="titleCounter">30 / 200</div>
          <div class="err-msg" id="titleErr">제목을 입력해주세요.</div>
        </div>

        <!-- 본문 : 기존값 pre-fill -->
        <div>
          <div class="field-label">내용 <span class="required">*</span></div>
          <textarea id="contentInput" class="textarea-content"
            oninput="countContent()">안녕하세요! 지난달에 도쿄 3박 4일 다녀온 후기 공유드립니다. 현지 친구 덕분에 관광객들이 잘 모르는 숨은 맛집들을 많이 다녀올 수 있었어요 😊

📍 1일차 – 신주쿠 / 시부야
아사쿠사 도착 후 센소지 사원 구경. 아침 일찍 가면 인파가 적어서 좋아요. 점심은 근처 골목에 있는 텐동 전문점 추천드립니다.

📍 2일차 – 아키하바라 / 우에노
전자상가 구경 후 우에노 공원 산책. 벚꽃 시즌이 겹치면 정말 예뻐요.

📍 3일차 – 하라주쿠 / 오모테산도
다케시타도리 구경하고, 오모테산도 힐즈 근처 카페 투어.

총 경비는 항공포함 70만원 초반대였고, 환전은 한국에서 미리 해가는 게 훨씬 이득이었어요. 궁금한 거 댓글로 질문 주세요! 🙌</textarea>
          <div class="char-counter" id="contentCounter">0자</div>
          <div class="err-msg" id="contentErr">내용을 입력해주세요.</div>
        </div>

        <!-- 이미지 관리 (기존 IMAGE_STORE + 새 업로드) -->
        <div>
          <div class="img-section-label">
            <i class="bi bi-images" style="color:#adb5bd;"></i>
            이미지 관리
            <span class="img-section-sub">(최대 5장 · 기존 이미지 삭제 / 새 이미지 추가 가능)</span>
          </div>

          <!-- 기존 이미지 (IMAGE_STORE에서 가져온 imageList) -->
          <div style="font-size:.72rem;color:#adb5bd;margin-bottom:7px;">
            ● 기존 이미지 <span id="existCount">4</span>장
            &nbsp;·&nbsp; ★ 클릭으로 대표 이미지 변경 &nbsp;·&nbsp; ✕ 삭제
          </div>
          <div class="existing-grid" id="existingGrid">

            <div class="exist-item rep" id="exist_0">
              <img src="https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?w=200&q=70" alt="">
              <div class="rep-badge">대표</div>
              <div class="exist-actions">
                <button class="btn-img-act btn-img-del" onclick="deleteExist(0)" title="삭제">
                  <i class="bi bi-x"></i>
                </button>
              </div>
            </div>

            <div class="exist-item" id="exist_1">
              <img src="https://images.unsplash.com/photo-1528360983277-13d401cdc186?w=200&q=70" alt="">
              <div class="exist-actions">
                <button class="btn-img-act btn-img-rep" onclick="setRep(1)" title="대표로 설정">
                  <i class="bi bi-star"></i>
                </button>
                <button class="btn-img-act btn-img-del" onclick="deleteExist(1)" title="삭제">
                  <i class="bi bi-x"></i>
                </button>
              </div>
            </div>

            <div class="exist-item" id="exist_2">
              <img src="https://images.unsplash.com/photo-1513407030348-c983a97b98d8?w=200&q=70" alt="">
              <div class="exist-actions">
                <button class="btn-img-act btn-img-rep" onclick="setRep(2)" title="대표로 설정">
                  <i class="bi bi-star"></i>
                </button>
                <button class="btn-img-act btn-img-del" onclick="deleteExist(2)" title="삭제">
                  <i class="bi bi-x"></i>
                </button>
              </div>
            </div>

            <div class="exist-item" id="exist_3">
              <img src="https://images.unsplash.com/photo-1536098561742-ca998e48cbcc?w=200&q=70" alt="">
              <div class="exist-actions">
                <button class="btn-img-act btn-img-rep" onclick="setRep(3)" title="대표로 설정">
                  <i class="bi bi-star"></i>
                </button>
                <button class="btn-img-act btn-img-del" onclick="deleteExist(3)" title="삭제">
                  <i class="bi bi-x"></i>
                </button>
              </div>
            </div>

          </div>

          <!-- 변경사항 요약 -->
          <div class="change-summary" id="changeSummary"></div>

          <!-- 새 이미지 추가 업로드 -->
          <div style="font-size:.72rem;color:#adb5bd;margin:12px 0 7px;">
            ● 새 이미지 추가
          </div>
          <div class="upload-area" id="uploadArea"
            onclick="document.getElementById('fileInput').click()"
            ondragover="onDragOver(event)" ondragleave="onDragLeave(event)" ondrop="onDrop(event)">
            <i class="bi bi-cloud-upload upload-icon"></i>
            <div class="upload-text">
              클릭하거나 <strong>드래그&드롭</strong>으로 이미지를 추가하세요
            </div>
            <div class="upload-hint" id="uploadHint">현재 4장 · 최대 5장까지 가능 (1장 더 추가 가능)</div>
          </div>
          <input type="file" id="fileInput" accept="image/jpeg,image/png" multiple
            onchange="handleFiles(this.files)">
          <div class="new-preview-grid" id="newPreviewGrid"></div>
        </div>

        <!-- 유의사항 -->
        <div class="notice-box">
          <strong>⚠️ 수정 시 유의사항</strong>
          <ul>
            <li>수정 후에는 게시글에 <b>수정됨</b> 표시가 함께 노출됩니다.</li>
            <li>삭제 표시한 이미지는 저장 시 실제로 삭제되며 복구할 수 없습니다.</li>
            <li>욕설·비방·홍보성 내용은 관리자에 의해 삭제될 수 있습니다.</li>
          </ul>
        </div>

      </div><!-- /write-form -->

      <!-- 하단 버튼 -->
      <div class="write-footer">
        <a href="#" class="btn-cancel"
          onclick="if(!confirm('수정을 취소하고 상세 페이지로 돌아가시겠습니까?')) return false;">
          <i class="bi bi-arrow-left me-1"></i>돌아가기
        </a>
        <button class="btn-submit" onclick="submitForm()">
          <i class="bi bi-check-lg" style="font-size:.9rem;"></i> 수정 완료
        </button>
      </div>

    </div><!-- /write-card -->
  </div>
</div>
