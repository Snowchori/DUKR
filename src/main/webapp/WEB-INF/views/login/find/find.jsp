<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	// 에러코드를 가지고 회귀하는경우 처리
	StringBuilder sbIdError = new StringBuilder();
	StringBuilder sbPwdError = new StringBuilder();
	
	if(request.getAttribute("error") != null){
		if(request.getAttribute("error").equals("id_error")){
			sbIdError.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style='color:red'>해당 이메일로 등록된 아이디가 존재하지 않습니다</span>");
		}else{
			sbPwdError.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style='color:red'>입력한 정보가 올바르지 않습니다</span>");
		}
	}
	
	if((Integer)request.getAttribute("success") != null && (Integer)request.getAttribute("success") == 1){
		sbIdError.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style='color:blue'>해당 이메일로 아이디를 발송했습니다</span>");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS v5.2.1 -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT"
	crossorigin="anonymous">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.6.0/font/bootstrap-icons.css" />

<!-- Bootstrap JavaScript Libraries -->
<script
	src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
	integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3"
	crossorigin="anonymous">
	
</script>

<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.min.js"
	integrity="sha384-7VPbUDkoPSGFnVtYi0QogXtr74QeVeeIs99Qfg5YCF+TidwNdjvaKZX19NZ/e6oz"
	crossorigin="anonymous">
</script>
<script type="text/javascript">
	function changeDropdownItem(item) {
    	document.getElementById('dropdownMenuButton1').innerHTML = item;
 	}
</script>
<style type="text/css">
.border {
	border-radius: 10px;
	border-style: solid;
}

.custom-container {
	display: flex;
	justify-content: center;
	align-items: center;
}
</style>
	<!-- java script -->
	<script type="text/javascript">
	window.onload = function(){
		// 아이디찾기 - submit
		document.getElementById("find_id").onclick = function(){
			if(document.fid_frm.email.value.trim() == ""){
				alert("이메일을 입력하세요");
				return false;
			}
			//$.ajax
			document.fid_frm.submit();
		};
		// 비밀번호찾기 - submit
		document.getElementById("find_password").onclick = function(){
			if(document.fpwd_frm.id.value.trim() == ""){
				alert("아이디를 입력하세요");
				return false;
			}
			if(document.fpwd_frm.hintSeq.value.trim() == 0){
				alert("힌트를 선택하세요");
				return false;
			}
			if(document.fpwd_frm.hint_ans.value.trim() == ""){
				alert("힌트 답변을 입력하세요");
				return false;
			}
			document.fpwd_frm.submit();
		};
	};
	
	</script>
</head>
<body>
<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
	<main>

		<!-- 아이디/비밀번호 찾기 양식 -->
		<br><br>
		<div class="custom-container">
			<div class="container justify-content-center">
				<div class="row justify-content-center align-items-center">
					<div class="col-md-8 border p-3">
						<!-- 아이디 찾기 -->
						<strong>아이디 찾기</strong><%=sbIdError %> 
						<br><br>
						<form action="/findId" method="post" name="fid_frm">
							<div class="input-group">
								<input class="form-control" type="email" name="email"
									placeholder="찾을 아이디에 등록된 이메일을 입력하세요" /> &nbsp; <span
									class="input-group-btn">
									<button class="btn btn-secondary" id="find_id" type="button">
									이메일로 아이디 발송</button>
								</span>
							</div>
						</form>
					</div>
				</div>
				<br>
				<br>
				<div class="row justify-content-center align-items-center">
					<div class="col-md-8 border p-3">
						<!-- 비밀번호 찾기 -->
						<strong>비밀번호 찾기</strong><%=sbPwdError %> 
						<br><br>
						<form action="/findPassword" method="post" name="fpwd_frm">
							<input class="form-control" type="email" name="id" placeholder="아이디" /> <br>
							<div class="input-group">
								<div class="input-group">
									<div class="dropdown">
										<select name="hintSeq" class="form-select">
											<option value="0" disabled selected>비밀번호 힌트</option>
    										<option value="1">힌트1</option>
    										<option value="2">힌트2</option>
    										<option value="3">힌트3</option>
  										</select>
									</div>&nbsp;
									<input class="form-control" type="email" name="hint_ans" placeholder="힌트 답변"/>
									<button class="btn btn-primary" type="button" id="find_password">비밀번호 변경하기</button>
								</div>&nbsp; 
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		
	</main>
</body>
</html>