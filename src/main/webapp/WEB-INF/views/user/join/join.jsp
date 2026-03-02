<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %> <!-- ${path} 정의 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>회원가입</title>

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>
<link rel="stylesheet" href="${path}/resources/css/user/join.css">

<script src="${path}/resources/js/user/join.js" defer></script>

</head>
<body>
   <div class="wrap">
      <%@ include file="../../common/header.jsp" %>
      
      <hr>
      
      <div id="container">
         <div id="contents">
            <div id="section1">
               <div class="step_indicator" style="display: flex; justify-content: center; margin: 40px 0; font-size: 1.2em;">
                   <span id="dot1" style="color: #f91a32; font-weight: bold; margin: 0 15px;">01 계정 설정</span>
                   <span style="color: #ccc;"> &gt; </span>
                   <span id="dot2" style="color: #ccc; margin: 0 15px;">02 개인 정보</span>
               </div>
            </div>

            <div id="section2">
               <div id="s2_inner">
                  <div class="join">
                     <form name="inputform" action="${path}/joinAction.do" method="post" onsubmit="return signInCheck()">
                        
                        <div id="step_div1">
                           <h3 align="center" style="margin-bottom:20px;">필수 계정 정보</h3>
                           <table align="center" class="join_table">
                              <tr>
                                 <th> * 아이디 </th>
                                 <td>
                                    <div style="display: flex; align-items: center;">
                                       <input type="text" class="input" name="user_id" id="user_id" placeholder="6~20자 영문, 숫자" required autofocus>
                                       <input type="button" class="btn_overlap" value="중복확인" style="margin-left:10px" onclick="confirmId()">
                                    </div>
                                    <input type="hidden" name="hiddenUserId" value="0">
                                    <div id="idMessage" style="font-size: 12px; margin-top: 5px;"></div>
                                 </td>
                              </tr>
                              <tr>
                                 <th> * 비밀번호 </th>
                                 <td><input type="password" class="input" name="user_password" id="user_password" placeholder="영문/숫자/특수문자 조합" required></td>
                              </tr>
                              <tr>
                                 <th> * 비밀번호 확인 </th>
                                 <td>
                                    <input type="password" class="input" name="re_password" id="re_password" placeholder="비밀번호 재입력" required>
                                    <div id="pwdMessage" style="font-size: 12px; margin-top: 5px;"></div>
                                 </td>
                              </tr>
                           </table>
                           <div align="center" style="margin-top: 30px;">
                              <input type="button" class="btn_next" value="다음 단계로" onclick="nextStep(2)" 
                                     style="padding: 10px 40px; background-color: #f91a32; color: white; border: none; cursor: pointer;">
                           </div>
                        </div>

                        <div id="step_div2" style="display: none;">
                           <h3 align="center" style="margin-bottom:20px;">상세 개인 정보</h3>
                           <table align="center" class="join_table">
                              <tr>
                                 <th> * 이름 </th>
                                 <td><input type="text" class="input" name="user_name" id="user_name" placeholder="실명을 입력하세요" required></td>
                              </tr>
                              <tr>
                                 <th> * 성별 </th>
                                 <td>
                                    <input type="radio" name="gender" value="M" id="male" checked> 
                                    <label for="male" style="margin-right: 20px;"> 남성</label>
                                    <input type="radio" name="gender" value="F" id="female"> 
                                    <label for="female"> 여성</label>
                                 </td>
                              </tr>
                              <tr>
                                 <th> * 생년월일 </th>
                                 <td><input type="date" class="input" name="birth_date" required></td>
                              </tr>
                              <tr>
                                 <th> * 연락처 </th>
                                 <td>
                                    <input type="text" name="phone1" class="input" style="width:50px" maxlength="3"> -
                                    <input type="text" name="phone2" class="input" style="width:70px" maxlength="4"> -
                                    <input type="text" name="phone3" class="input" style="width:70px" maxlength="4">
                                 </td>
                              </tr>
                              <tr>
                                 <th> * 이메일 </th>
                                 <td>
                                    <input type="text" name="user_email1" id="user_email1" class="input" style="width:100px" required> @
                                    <input type="text" name="user_email2" id="user_email2" class="input" style="width:100px" required>
                                    <select class="input" name="user_email3" onchange="selectEmail()">
                                       <option value="0">직접입력</option>
                                       <option value="naver.com">네이버</option>
                                       <option value="google.com">구글</option>
                                       <option value="daum.net">다음</option>
                                    </select>
                                 </td>
                              </tr>
                              <tr>
                                 <th> * 주소 </th>
                                 <td><input type="text" class="input" name="address" size="50" placeholder="주소를 입력하세요" required></td>
                              </tr>
                           </table>
                           <div align="center" style="margin-top: 30px;">
                              <input type="button" class="btn_prev" value="이전으로" onclick="nextStep(1)" style="padding: 10px 40px; margin-right: 10px; cursor: pointer;">
                              <input type="submit" class="btn_submit" value="회원가입 완료" style="padding: 10px 40px; background-color: #f91a32; color: white; border: none; cursor: pointer;">
                           </div>
                        </div>

                     </form>
                  </div>
               </div>
            </div>
         </div>
      </div>
      
      <!-- 관련 SQL -->
      SQL 쿼리 : 이메일 중복 체크 
  	<pre><code>
	SELECT *
	FROM MEMBER
	WHERE user_id = #${'{'}userId}
	</code></pre>
	
     SQL 쿼리 : 회원 정보 insert
  	<pre><code>
  	INSERT INTO MEMBER (
	    user_id, password, name, birth_date, email, phone, address, gender
	  ) VALUES (
	    #${'{'}user_id, jdbcType=VARCHAR},
	    #${'{'}password, jdbcType=VARCHAR},
	    #${'{'}name, jdbcType=VARCHAR},
	    #${'{'}birth_date, jdbcType=DATE},
	    #${'{'}email, jdbcType=VARCHAR},
	    #${'{'}phone, jdbcType=VARCHAR},
	    #${'{'}address, jdbcType=VARCHAR},
	    #${'{'}gender, jdbcType=CHAR}
	  )
	</code></pre>
      
      <%@ include file="../../common/footer.jsp" %>
   </div>
</body>
</html>