<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>정보 수정</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>

<link rel="stylesheet" href="${path}/resources/css/common/header.css">
<link rel="stylesheet" href="${path}/resources/css/common/footer.css">
<style>
    .modify_wrap { width: 700px; margin: 50px auto; padding: 40px; border: 1px solid #ddd; background: #fff; }
    .modify_title { border-bottom: 2px solid #333; padding-bottom: 10px; margin-bottom: 20px; font-size: 24px; }
    .modify_table { width: 100%; border-spacing: 0; border-top: 1px solid #eee; }
    .modify_table th { text-align: left; padding: 15px; background: #fbfbfb; border-bottom: 1px solid #eee; width: 180px; color: #333; }
    .modify_table td { padding: 12px; border-bottom: 1px solid #eee; }
    .input_full { width: 95%; padding: 10px; border: 1px solid #ccc; border-radius: 3px; }
    .point_text { color: #f91a32; font-weight: bold; }
    .btn_center { text-align: center; margin-top: 40px; display: flex; justify-content: center; gap: 10px; }
    .btn_submit { padding: 15px 50px; background: #f91a32; color: #fff; border: none; font-weight: bold; cursor: pointer; }
    .btn_cancel { padding: 15px 50px; background: #999; color: #fff; border: none; font-weight: bold; cursor: pointer; }
</style>

<script type="text/javascript">
    // 비밀번호 일치 실시간 체크
    function validateForm() {
        const pw = document.getElementById("password").value;
        const pwConfirm = document.getElementById("password_confirm").value;
        
        if (pw !== pwConfirm) {
            alert("변경할 비밀번호가 서로 일치하지 않습니다.");
            document.getElementById("password_confirm").focus();
            return false;
        }
        return true;
    }
</script>
</head>
<body>
<div class="wrap">
    <%@ include file="../../common/header.jsp" %>
    
    <div id="container">
        <c:choose>
            <c:when test="${selectCnt == 1}">

                <div class="modify_wrap">
                    <h2 class="modify_title">회원정보 관리</h2>
                    <form action="${path}/modifyUserAction.do" method="post" onsubmit="return validateForm();">
                        <table class="modify_table">
                            <%-- 1. 기본 정보 (수정불가) --%>
                            <tr>
                                <th>아이디</th>
                                <td><strong>${dto.user_id}</strong><input type="hidden" name="user_id" value="${dto.user_id}"></td>
                            </tr>
                            <tr>
                                <th>현재 포인트</th>
                                <td class="point_text">${dto.point_balance} P</td>
                            </tr>
                            

                            <%-- 2. 비밀번호 수정 --%>
                            <tr>
                                <th>새 비밀번호</th>
                                <td><input type="password" name="password" id="password" class="input_full" placeholder="변경할 비밀번호 입력" required></td>
                            </tr>
                            <tr>
                                <th>새 비밀번호 확인</th>
                                <td><input type="password" id="password_confirm" class="input_full" placeholder="한번 더 입력해주세요" required></td>
                            </tr>

                            <%-- 3. 개인 신상 정보 [cite: 2026-02-24] --%>
                            <tr>
                                <th>이름</th>
                                <td><input type="text" name="name" value="${dto.name}" class="input_full"></td>
                            </tr>
                            <tr>
                                <th>이메일</th>
                                <td><input type="email" name="email" value="${dto.email}" class="input_full"></td>
                            </tr>
                            <tr>
                                <th>휴대폰 번호</th>
                                <td><input type="text" name="phone" value="${dto.phone}" class="input_full"></td>
                            </tr>
                            <tr>
                                <th>주소</th>
                                <td><input type="text" name="address" value="${dto.address}" class="input_full"></td>
                            </tr>
                            <tr>
                                <th>생년월일</th>
                                <td><input type="date" name="birth_date" value="${dto.birth_date}" class="input_full"></td>
                            </tr>
                            <tr>
                                <th>성별</th>
                                <td>
                                    <input type="radio" name="gender" value="M" ${dto.gender == 'M' ? 'checked' : ''}> 남성
                                    <input type="radio" name="gender" value="F" ${dto.gender == 'F' ? 'checked' : ''} style="margin-left: 20px;"> 여성
                                </td>
                            </tr>
                            <tr>
                                <th>가입일</th>
                                <td>${dto.joinDate}</td>
                            </tr>
                        </table>

                        <div class="btn_center">
                            <button type="submit" class="btn_submit">수정하기</button>
                            <button type="button" class="btn_cancel" onclick="location.href='${path}/main.do'">취소</button>
                        	<button type="button" class="btn_cancel" onclick="if(confirm('정말 회원탈퇴 하시겠습니까?')) location.href='${path}/deleteUser.do'">
						        회원탈퇴
						    </button>
						    
		                </div>
                    </form>
                </div>
            </c:when>
            
            <c:otherwise>
                <script>alert("인증에 실패했습니다."); history.back();</script>
            </c:otherwise>
        </c:choose>
    </div>
						    
                  
    <!-- 관련 SQL -->
    SQL 쿼리 : 회원 상세 정보 가져오기
   	<pre><code>
     SELECT 
           user_id, name, email, phone, 
           role, status, joinDate, point_balance
       FROM MEMBER
       ORDER BY joinDate DESC
	</code></pre>
    
    SQL 쿼리 : 회원 정보 수정 
   		<pre>
			<code>
			<c:out escapeXml="true" value="
     UPDATE MEMBER
        SET email = #${'{'}email},
            phone = #${'{'}phone},
            address = #${'{'}address},
            name = #${'{'}name}
        WHERE user_id = #${'{'}user_id}
			" />
			</code> 
		</pre>
    <!-- 관련 SQL -->     
    <%@ include file="../../common/footer.jsp" %>
</div>
</body>
</html>