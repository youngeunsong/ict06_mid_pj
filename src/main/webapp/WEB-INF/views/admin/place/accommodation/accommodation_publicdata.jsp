<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<%@ include file="/WEB-INF/views/common/bootstrapSettings.jsp" %>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>지역기반 숙소 데이터 수집</title>
<%@ include file="/WEB-INF/views/common/adminSetting.jsp" %>
<script type="text/javascript">
$(function(){
	$('#btn').click(function(){
		let areaCodeValue = $('select[name="keyword"]').val(); 
		let pageNoValue = $('input[name="pageNo"]').val(); // input 선택자 문자열로 감싸야 함
		let numOfRowsValue = $('select[name="numOfRows"]').val();
		if(!areaCodeValue) {
			alert("수집할 지역을 선택하세요.");
			return;
		}

		if(!confirm("해당 지역의 데이터를 수집하시겠습니까?")) return;

		$('#loading').show();
		$('#btn').prop('disabled', true);
		$('#display').html("");
	
		$.ajax({
			url: '${path}/startAcc_1_action.adac', 
			type: 'post',
			data: {"keyword": areaCodeValue,
				   "pageNo": pageNoValue,
				   "numOfRows": numOfRowsValue}, 
			success: function(result){
				$('#loading').hide();
				$('#btn').prop('disabled', false);
				
				if(parseInt(result) > 0) {
					alert("총 " + result + "건 저장 성공");
					$('#display').html("<b>✅ 새롭게 저장된 숙소: " + result + " 건</b>");
				} else {
					alert("추가된 데이터가 없습니다.");
					$('#display').html("<b>ℹ️ 이미 모든 데이터가 최신입니다.</b>");
				}
			},
			error: function(){
				$('#loading').hide();
				$('#btn').prop('disabled', false);
				alert('데이터 수집 중 오류가 발생했습니다.');
			}
		});
	});
});
</script>
</head>
<body class="hold-transition sidebar-mini layout-fixed">
	<div class="wrapper">
		<div class="preloader flex-column justify-content-center align-items-center">
			<img src="${path}/resources/admin/dist/img/AdminLTELogo.png" height="60" width="60">
		</div>

		<%@ include file="/WEB-INF/views/common/adminHeader.jsp" %>

		<%@ include file="/WEB-INF/views/common/adminSidebar.jsp" %>

		<div class="content-wrapper">
			<div class="content-header">
				<div class="container-fluid">
					<h1 class="m-0">지역기반 숙소 데이터 수집</h1>
				</div>
			</div>
			
			<div class="container-fluid" style="padding: 20px;">
				<form name="test_main" onsubmit="return false;">
					페이지 번호 :
			    <input type="number" name="pageNo" value="1" min="1">
			    	가져올 개수 :
			    <select name="numOfRows">
			        <option value="10">10개</option>
			        <option value="50">50개</option>
			        <option value="100">100개</option>
			        <option value="1000">1000개</option>
			    </select>
					수집 대상 지역 :
				<select name="keyword" style="padding: 3px;">
					<option value="">-- 지역 선택 --</option>
					<option value="1">서울</option>
					<option value="2">인천</option>
					<option value="3">대전</option>
					<option value="4">대구</option>
					<option value="5">광주</option>
					<option value="6">부산</option>
					<option value="7">울산</option>
					<option value="31">경기</option>
					<option value="39">제주</option>
				</select>
					
					<button type="button" id="btn" style="margin-left: 10px;">수집 시작</button>
				</form>
				<div id="loading" style="display:none; margin-top: 20px; color: red;">
					<b><i class="fas fa-sync-alt fa-spin"></i> 데이터를 저장 중입니다. 잠시만 기다려주세요...</b>
				</div>
				<div id="display" style="margin-top: 20px;"></div>
			</div>
			<hr>
			</div>
			</div>
		<footer class="main-footer text-center py-3">
			<strong>Copyright &copy; 2026</strong>
		</footer>
	</div>
</body>
</html>