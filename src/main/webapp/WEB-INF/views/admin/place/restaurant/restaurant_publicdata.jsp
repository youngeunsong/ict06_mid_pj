<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/setting.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="${path}/resources/js/admin/request.js"></script>
<script type="text/javascript">

$(function(){
	$('#btn').click(function(){
        let areaCodeValue = $('select[name="keyword"]').val(); 
        
        if(!areaCodeValue) {
            alert("수집할 지역을 선택하세요.");
            return;
        }

        if(!confirm("해당 지역의 데이터를 수집하시겠습니까?")) return;

        $('#loading').show();
        $('#btn').prop('disabled', true);
        $('#display').html("");
    
        $.ajax({
            url: '${path}/start_1_test.ad', 
            type: 'post',
            data: { "keyword": areaCodeValue }, 
            success: function(result){
                $('#loading').hide();
                $('#btn').prop('disabled', false);
                
                // 2. 결과 처리 로직
                if(parseInt(result) > 0) {
                    alert("총 " + result + "건 저장 성공");
                    $('#display').html("<b>✅ 새롭게 저장된 맛집: " + result + " 건</b>");
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
</head> <body>

    <h3>📍 지역기반 맛집 데이터 수집 매니저</h3>
    
    <p>안내: 선택한 지역의 맛집 정보를 가져와 DB에 저장합니다.</p>

    <form name="test_main">
        <div>
            <label>수집 대상 지역 선택</label><br>
            <select name="keyword">
			    <option value="">-- 수집 지역 선택 (전국) --</option>
			    <option value="1">서울특별시</option>
			    <option value="2">인천광역시</option>
			    <option value="3">대전광역시</option>
			    <option value="4">대구광역시</option>
			    <option value="5">광주광역시</option>
			    <option value="6">부산광역시</option>
			    <option value="7">울산광역시</option>
			    <option value="31">경기</option>
			    <option value="39">제주도</option>
			</select>
        </div>
        <br>
        <button type="button" id="btn">수집 시작</button>
    </form>
    
    <div id="loading" style="display:none; margin-top: 20px; color: red;">
        <b>데이터를 저장 중입니다. 잠시만 기다려주세요...</b>
    </div>

    <div id="display" style="margin-top: 20px;"></div>

</body>
</html>