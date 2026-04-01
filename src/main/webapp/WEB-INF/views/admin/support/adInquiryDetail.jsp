<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %> 
<!DOCTYPE html>
<html lang="ko">
<head>
<fmt:setTimeZone value="Asia/Seoul"/>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="${path}/resources/css/admin/ad_reservation.css">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>관리자 | 1:1문의 상세내역</title>

<script src="${path}/resources/js/admin/adInquiryDetail.js" defer></script>

<style>
    .content-box { min-height: 200px; white-space: pre-wrap; line-height: 1.6; vertical-align: top; }
    .reply-box { background-color: #fff; border: 1px solid #ced4da; border-radius: 4px; padding: 15px; width: 100%; height: 250px; }
    .section-header { border-left: 4px solid #007bff; padding-left: 10px; margin-bottom: 20px; font-weight: bold; }
</style>
</head>
<body class="hold-transition sidebar-mini layout-fixed">
    <div class="wrapper">

        <!-- Preloader -->
	    <div class="preloader flex-column justify-content-center align-items-center">
	       <img src="${path}/resources/admin/dist/img/AdminLTELogo.png" height="60" width="60">
	    </div>
		<!-- ================= HEADER ================= -->
        <%@ include file="/WEB-INF/views/common/adminHeader.jsp" %>
        <!-- ================= SIDEBAR ================= -->
        <%@ include file="/WEB-INF/views/common/adminSidebar.jsp" %>
		<!-- ================= CONTENT ================= -->
		<!--begin::content 헤더-->
        <div class="content-wrapper">
            <section class="content-header">
                <div class="container-fluid">
                    <div class="row mb-2">
                        <div class="col-sm-6">
                            <h1>1:1 문의 상세 내역</h1>
                        </div>
                    </div>
                </div>
            </section>

            <section class="content">
                <div class="container-fluid">
                    <div class="card card-primary card-outline">
                        <div class="card-body">
                            
                            <div class="section-header">문의 내용 확인</div>
                            <table class="table">
                                <tbody>
                                    <tr>
                                        <th class="detail-th">문의 ID</th>
                                        <td class="text-primary"><strong>${dto.inquiry_id}</strong></td>
                                        <th class="detail-th">작성자 아이디</th>
                                        <td>${dto.user_id}</td>
                                    </tr>
                                    <tr>
                                        <th class="detail-th">문의 제목</th>
                                        <td colspan="3" style="font-weight: bold;">[${dto.category}] ${dto.title}</td>
                                    </tr>
                                    <tr>
                                        <th class="detail-th">문의 일시</th>
                                        <td colspan="3">
                                            <%-- 날짜 형식을 '년-월-일 시:분'으로 --%>
                                            <fmt:formatDate value="${dto.inquiryDate}" pattern="yyyy-MM-dd HH:mm"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="detail-th">문의 내용</th>
                                        <td colspan="3" class="content-box">${dto.content}</td>
                                    </tr>
                                    <%-- 답변이 달린 경우에만 답변 날짜 --%>
                                    <c:if test="${not empty dto.answerDate}">
                                    <tr>
                                        <th class="detail-th">최종 답변 일시</th>
                                        <td colspan="3" class="text-muted">
                                            <fmt:formatDate value="${dto.answerDate}" pattern="yyyy-MM-dd HH:mm"/>
                                        </td>
                                    </tr>
                                    </c:if>
                                </tbody>
                            </table>

                            <hr class="my-4">

                            <div class="reply-area">
                                <div class="section-header">관리자 답변 작성</div>
                                
                                <form id="replyForm">
                                <%-- 어떤 글에 답변을 다는지 알아야 하므로  글 번호(inquiry_id)를 hidden --%> 
                                    <input type="hidden" id="inquiry_id" name="inquiry_id" value="${dto.inquiry_id}">
                                    
                                    <div class="form-group">
                                        <textarea id="admin_reply" name="admin_reply" class="reply-box" 
                                                  placeholder="사용자에게 전달할 답변 내용을 상세히 입력하세요.">${dto.admin_reply}</textarea>
                                    </div>
									<%-- 하단 컨트롤 버튼: FAQ의 색상과 라운드 스타일을 그대로 적용 --%>
									<div class="d-flex justify-content-center mt-4 mb-5" style="gap: 15px;">
									    
									    <%-- 1. 취소/목록 버튼 --%>
									    <button type="button" 
									            class="btn btn-pill btn-light border" 
									            style="border-radius: 50px; min-width: 120px; padding: 10px 20px; font-weight: 500;"
									            onclick="location.href='${path}/adInquiryList.adsp'">
									        취소하기
									    </button>
									    
									    <%-- 2. 임시저장 버튼 (진행중) --%>
									    <button type="button" 
									            class="btn btn-pill btn-info text-white" 
									            style="border-radius: 50px; min-width: 120px; padding: 10px 20px; font-weight: 500; background-color: #17a2b8; border: none;"
									            onclick="saveReply('${path}', 'PROGRESS')">
									        임시저장
									    </button>
									    
									    <%-- 3. 답변 등록 버튼 (완료) --%>
									    <button type="button" 
									            class="btn btn-pill" 
									            style="border-radius: 50px; min-width: 150px; padding: 10px 20px; font-weight: 500; background-color: #00c9a7; color: white; border: none;"
									            onclick="saveReply('${path}', 'ANSWERED')">
									        답변 등록하기
									    </button>
									</div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
		<!-- ================= FOOTER ================= -->
        <footer class="main-footer">
            <strong>Copyright &copy; 2026</strong>
        </footer>
        <!-- 관련 SQL 시작 -->
		<div align="center">SQL 쿼리 : 1:1 문의 상세 조회</div>
		
			<!-- 작성 요령 : 몇몇 특수문자를 화면에 제대로 출력하기 위해 아래와 같이 사용 필요-->
			<!-- #${'{'} : #과 { 표시 -->
			<!-- &lt; : < 표시 -->
			<!-- &gt; : > 표시 -->
			<div>
				<pre><code>
				  SELECT * FROM INQUIRY 
   				   WHERE inquiry_id = #${'{'}inquiry_id}				
				</code></pre>
			</div>
		<!-- 관련 SQL 끝 -->
    </div>
</body>
</html>