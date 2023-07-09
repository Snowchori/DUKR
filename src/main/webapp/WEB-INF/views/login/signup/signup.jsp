<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
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
<!-- jQuery -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<!-- javascript -->
<script type="text/javascript">
	function changeDropdownItem(item) {
		document.getElementById('dropdownMenuButton1').innerHTML = item;
	}
	
	window.onload = function(){
		document.getElementById("signup_submit").onclick = function(){
			if(document.signup_frm.id.value.trim() == ""){
				alert('아이디를 입력하세요');
				return false;
			} else if(document.signup_frm.isDupl.value.trim() != "0"){
				alert('아이디 중복확인을 해주세요');	
				return false;
			} else if(document.signup_frm.password.value.trim() != document.signup_frm.c_password.value.trim()){
				alert('비밀번호가 일치하지 않습니다');
				return false;
			} else if(document.signup_frm.nickname.value.trim() == ""){
				alert('닉네임을 입력하세요');
				return false;
			} else if(document.signup_frm.password.value.trim() == ""){
				alert('비밀번호를 입력하세요');
				return false;
			} else if(document.signup_frm.email.value.trim() == ""){
				alert('이메일을 입력하지 않으면 아이디 분실 시 복구가 불가능할 수 있습니다');
			} else if(document.signup_frm.hintSeq.value == 0){
				alert('비밀번호 힌트를 선택하세요');
				return false;
			} else if(document.signup_frm.answer.value.trim() == ""){
				alert('힌트 답변을 작성하세요');
				return false;
			} else {
				document.signup_frm.submit();				
			}
		};
		
		// 아이디 중복확인
		document.getElementById("duplCheck").onclick = function(){
			if(document.signup_frm.id.value.trim() == ""){
				alert('아이디를 입력하세요');
				return false;
			}
			
			$.ajax({
	        	url: '/duplCheck',
	          	type: 'POST',
	          	data: {
	            	id: document.signup_frm.id.value.trim()
	          	},
	          	success: function(res) {
	          		if(res == "impossible"){
	          			alert('이미 등록된 아이디 입니다');
	          		}else{
	          			alert('사용 가능한 아이디 입니다');
	          			console.log(res);
	          			document.getElementById('isDupl').value = "0";
	          		}
	          	},
	          	error: function(xhr) {
	          		console.log("아이디 중복조회 오류");
	          	}
	        });
			
		};
		
		document.getElementById("id").oninput = function(){
			document.getElementById('isDupl').value = 1;
		};
		
	};
</script>
</head>
<body>
<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>

	<main>
		<!-- 회원가입 양식 -->
		<br>
		<div class="container" align="center">
			<img src="./images/logo.png" height="80">
			<h2>회원가입</h2>
			<form action="/signupOk" method="post" name="signup_frm">
			<input type="hidden" name="isDupl" id="isDupl" value="1"/>
				<div class="col-md-3 mt-3">
					<div class="input-group">
						<input class="form-control" type="email" id="id" name="id" placeholder="아이디"> &nbsp;
						<br>
						<span class="input-group-btn">
							<button class="btn btn-secondary" type="button" id="duplCheck">중복확인</button>
						</span>
					</div>	
					<br>
					<input class="form-control" type="email" name="nickname" placeholder="닉네임"> <br> 
					<input class="form-control" type="password" name="password" placeholder="비밀번호" /> <br> 
					<input class="form-control" type="password" name="c_password" placeholder="비밀번호 확인" /><br> 
					<input class="form-control" type="email" name="email" placeholder="이메일" /><br>
					<div class="input-group">
						<div class="dropdown">
							<select name="hintSeq" class="form-select">
								<option value="0" disabled selected>비밀번호 힌트</option>
    							<option value="1">힌트1</option>
    							<option value="2">힌트2</option>
    							<option value="3">힌트3</option>
  							</select>
						</div>&nbsp;
						<input class="form-control" type="email" name="answer" placeholder="힌트 답변"/> <br> &nbsp;
					</div>
					<br> <br>
					<div class="d-grid gap-2">
						<input class="btn btn-primary btn-lg" id="signup_submit" type="button" value="가입하기" />
					</div>
				</div>
			</form>
		</div>
	</main>
	
</body>
</html>