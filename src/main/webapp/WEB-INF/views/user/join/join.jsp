<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>회원가입</title>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- F12시 reading 'fn'오류 -->

<!-- 부트스트랩 선언 + 헤더/푸터 -->
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>

<link rel="stylesheet" href="${path}/resources/css/common/header.css">
<link rel="stylesheet" href="${path}/resources/css/common/footer.css">
<link rel="stylesheet" href="${path}/resources/css/user/join.css">

<script src="https://kit.fontawesome.com/648e5e962b.js" crossorigin="anonymous"></script>
<%-- <script src="${path}/resources/js/common/main.js" defer></script> --%>
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
								            <input type="text" class="input" name="user_id" id="user_id" required autofocus>
								            <input type="button" class="btn_overlap" value="중복확인" style="margin-left:10px" onclick="confirmId()">
								        </div>
								        <div id="id_guide" style="font-size: 12px; margin-top: 5px; color: #666;">6~20자 영문, 숫자</div>
								        <input type="hidden" name="hiddenUserId" value="0">
								        <div id="idMessage" style="font-size: 12px; margin-top: 5px;"></div>
								    </td>
								</tr>
								
								<tr>
								    <th> * 비밀번호 </th>
								    <td>
								        <div class="pwd_container" style="position: relative; display: flex; align-items: center;">
								            <input type="password" class="input" name="password" id="user_password" required style="width: 100%; padding-right: 40px;">
								            <i class="fa-solid fa-eye-slash togglePwd" data-target="user_password" style="position: absolute; right: 10px; cursor: pointer;"></i>
								        </div>
								        <div id="pwd_guide_wrapper" style="font-size: 12px; margin-top: 8px;">
								            <div id="pwd_default_txt" style="color: #666;">영문/숫자/특수문자 포함 8~20자</div>
								            <div id="pwd_check_list" style="color: #ccc; display: none;">
								                <span id="check_eng">✓ 영문</span> 
								                <span id="check_num">✓ 숫자</span> 
								                <span id="check_spe">✓ 특수문자</span> 
								                <span id="check_len">✓ 8~20자</span>
								            </div>
								        </div>
								    </td>
								</tr>
								
								<tr>
								    <th> * 비밀번호 확인 </th>
								    <td>
								        <div class="pwd_container" style="position: relative; display: flex; align-items: center;">
								            <input type="password" class="input" name="re_password" id="re_password" required style="width: 100%; padding-right: 40px;">
								            <i class="fa-solid fa-eye-slash togglePwd" data-target="re_password" style="position: absolute; right: 10px; cursor: pointer;"></i>
								        </div>
								        <div id="pwdMatchMessage" style="font-size: 12px; margin-top: 8px; color: #ccc;">비밀번호를 한 번 더 입력해주세요.</div>
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

                                 <td><input type="text" class="input" name="name" placeholder="실명을 입력하세요" required></td>

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
                                    <input type="text" name="phone1" class="input" style="width:50px" maxlength="3" required> -
                                    <input type="text" name="phone2" class="input" style="width:70px" maxlength="4" required> -
                                    <input type="text" name="phone3" class="input" style="width:70px" maxlength="4" required>
                                 </td>
                              </tr>
                              <tr>
                                 <th> * 이메일 </th>
                                 <td>

                                    <input type="text" name="email1" class="input" style="width:100px" required> @
                                    <input type="text" name="email2" id="user_email2" class="input" style="width:100px" required>
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
       SQL 쿼리 : 아이디 중복 체크 
  	<pre><code>
  	<c:out value="
        SELECT COUNT(*)
        FROM MEMBER
        WHERE user_id = #${'{'}user_id}
  		" />
	</code></pre>
      
      SQL 쿼리 : 이메일 중복 체크 
  		<pre>
			<code>
			<c:out escapeXml="true" value="
		        SELECT COUNT(*)
		        FROM MEMBER
		        WHERE user_id = #${'{'}user_id}
			" />
			</code> 
		</pre>
	
     SQL 쿼리 : 회원 정보 insert
  	<pre>
			<code>
			<c:out escapeXml="true" value="
		        INSERT INTO MEMBER (
            user_id, password, email, name, birth_date, 
            gender, phone, address, point_balance, 
            role, status, joinDate
        ) VALUES (
            #${'{'}user_id}, #${'{'}password}, #${'{'}email}, #${'{'}name}, #${'{'}birth_date},
            #${'{'}gender}, #${'{'}phone}, #${'{'}address}, 
            NVL(#${'{'}point_balance}, 0), 
            NVL(#${'{'}role}, 'USER'), 
            NVL(#${'{'}status}, 'ACTIVE'), 
            CURRENT_TIMESTAMP
        )
			" />
			</code> 
		</pre>
      
   <%@ include file="../../common/footer.jsp" %>
   </div>

   <script type="text/javascript">
       window.onload = function() {
           // 서버에서 전달받은 insertCnt(1, -1, -2, -3 등)를 자바스크립트 변수에 할당
           const result = "${insertCnt}"; 

           // 값이 비어있지 않을 때만 실행 (처음 회원가입 페이지에 들어왔을 때는 실행 안 됨)
           if (result !== "") {
               if (result === "-1") {
                   alert("보안 위반: 아이디는 6자 이상이어야 합니다.");
                   history.back(); 
               } else if (result === "-2") {
                   alert("이미 사용 중인 아이디입니다. 다시 확인해주세요.");
                   history.back();
               } else if (result === "-3") {
                   alert("보안 위반: 비밀번호는 8자 이상이어야 합니다.");
                   history.back();
               } else if (result === "1") {
                   alert("회원가입을 축하드립니다!");
                   location.href = "${path}/login.do"; // 가입 성공 시 로그인 이동
               } else if (result === "0") {
                   alert("회원가입 실패! 입력 정보를 다시 확인해주세요.");
                   history.back();
               }
           }
       };
   </script>

</body>
</html>