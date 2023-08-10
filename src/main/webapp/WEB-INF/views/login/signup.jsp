<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>

<!DOCTYPE html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
		<!-- jQuery -->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
		<!-- javascript -->
		<%@ include file="/WEB-INF/views/include/agreement.jspf" %>
		<script type="text/javascript">
			window.onload = function(){
				$('#agreement').html(agreement);
				
				document.getElementById("signup_submit").onclick = function(){
					if(document.signup_frm.id.value.trim() == ""){
						Swal.fire('아이디를 입력해주세요');
						return false;
					} else if(document.signup_frm.isDupl.value.trim() != "0"){
						Swal.fire('아이디 중복확인을 해주세요');
						return false;
					} else if(document.signup_frm.password.value.trim() != document.signup_frm.c_password.value.trim()){
						Swal.fire('비밀번호가 일치하지 않습니다');
						return false;
					} else if(document.signup_frm.nickname.value.trim() == ""){
						Swal.fire('닉네임을 입력하세요');
						return false;
					} else if(document.signup_frm.isNicknameDupl.value.trim() == 1){
						Swal.fire('닉네임 중복확인을 해주세요');
						return false;
					} else if(document.signup_frm.password.value.trim() == ""){
						Swal.fire('비밀번호를 입력하세요');
						return false;
					} else if(document.signup_frm.email.value.trim() != "" && document.signup_frm.isEmailValid.value.trim() == "0"){
						Swal.fire('이메일을 인증해주세요');
						return false;
					} else if(document.signup_frm.hintSeq.value == 0){
						Swal.fire('비밀번호 힌트를 선택하세요');
						return false;
					} else if(document.signup_frm.answer.value.trim() == ""){
						Swal.fire('힌트 답변을 작성하세요');
						return false;
					} else if(!$('#agreementCheck').is(':checked')){
						Swal.fire('약관에 동의해야 합니다');
						return false;
					} else {
						$.ajax({
				  			url:'signupOk',
				  			type:'post',
				  			data: {
				  				id: document.signup_frm.id.value.trim(),
				  				nickname: document.signup_frm.nickname.value.trim(),
				  				password: document.signup_frm.password.value.trim(),
				  				email: document.signup_frm.email.value.trim(),
				  				hintSeq: document.signup_frm.hintSeq.value,
				  				answer: document.signup_frm.answer.value.trim()
				  			},
				  			success: function(data) {
					  			if(data == 0) {
						  			Swal.fire({
							  			icon: 'success',
							  			title: '회원가입 완료',
							  			confirmButtonText: '확인',
							  			willClose: () => {
							  				location.href='/';
						  				}
					  				});
					  			} else {
						  			Swal.fire({
							  			icon: 'error',
							  			title: '회원가입 실패',
							  			confirmButtonText: '확인'
						  			});
					  			}
					  		}
					  	});
					}
				};
				
				// 아이디 중복확인
				document.getElementById("duplCheck").onclick = function(){
					if(document.signup_frm.id.value.trim() == ""){
						Swal.fire('아이디를 입력하세요');
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
			          			Swal.fire('이미 등록된 아이디 입니다');
			          		}else{
			          			Swal.fire('사용 가능한 아이디 입니다');
			          			console.log(res);
			          			document.getElementById('isDupl').value = "0";
			          		}
			          	},
			          	error: function(xhr) {
			          		console.log("아이디 중복조회 오류");
			          	}
			        });
				};
				
				// 아이디와 이메일, 닉네임 인증후 내용 변경시 다시 인증 무효처리
				document.getElementById("id").oninput = function(){
					document.getElementById('isDupl').value = 1;
				};
				document.getElementById("email").oninput = function(){
					document.getElementById('isEmailValid').value = 0;
				};
				document.getElementById("nickname").oninput = function(){
					document.getElementById('isNicknameDupl').value = 1;
				};
				
				// 이메일 중복확인
				document.getElementById("emailCheck").onclick = function(){
					if(document.getElementById("email").value.trim() == ""){
						Swal.fire('이메일을 입력하세요');
						return false;
					}
					
					$.ajax({
			        	url: '/emailDuplCheck',
			          	type: 'POST',
			          	data: {
			            	email: document.signup_frm.email.value.trim()
			          	},
			          	success: function(res) {
			          		if(res == "impossible"){
			          			Swal.fire('이미 등록된 이메일 입니다');
			          		}else{
			          			Swal.fire('입력한 이메일로 인증코드를 발송했습니다');
			          			document.getElementById("emailCodeFrm").style.display = "";
			          			console.log(res);
			          		}
			          	},
			          	error: function(xhr) {
			          		Swal.fire('이메일 인증 오류');
			          		console.log("이메일 인증 오류");
			          	}
			        });
				};
				
				// 이메일 인증코드 확인
				document.getElementById('codeCheck').onclick = function(){
					$.ajax({
			        	url: '/emailCodeCheck',
			          	type: 'POST',
			          	data: {
			            	emailCode: document.signup_frm.emailCode.value.trim()
			          	},
			          	success: function(res) {
			          		if(res == "valid"){
			          			document.getElementById('isEmailValid').value = "1";
			          			Swal.fire('이메일이 성공적으로 인증되었습니다');
			          			document.getElementById("emailCodeFrm").style.display = "none";
			          			$('#emailCode').val('');
			          		}else if(res == 'invalid') {
			          			Swal.fire('인증코드가 일치하지 않습니다');
			          		}else{
			          			Swal.fire('');
			          		}
			          	},
			          	error: function(xhr) {
			          		Swal.fire('이메일 인증 오류');
			          		console.log("이메일 인증 오류");
			          	}
			        });
				};
				
				// 닉네임 중복확인
				document.getElementById('nicknameCheck').onclick = function(){
					$.ajax({
			        	url: '/nicknameCheck',
			          	type: 'POST',
			          	data: {
			            	nickname: document.signup_frm.nickname.value.trim()
			          	},
			          	success: function(res) {
							if(res == 'possible'){
								Swal.fire('사용 가능한 닉네임 입니다');
								document.signup_frm.isNicknameDupl.value = 0;
							}else{
								Swal.fire('이미 사용중인 닉네임 입니다');
							}
			          	},
			          	error: function(xhr) {
			          		console.log('닉네임 중복확인 오류');
			          	}
			        });
				};
				
			};
			
		</script>
		<link href="assets/css/style.css" rel="stylesheet">
	</head>
	<body>
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="mt-5 py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title">회원가입</h1>
					<p class="lead fw-normal text-white-50 mb-0">SignUp</p>
				</div>
			</div>
		</header>
		<main>
			<!-- 회원가입 양식 -->
			<br>
			<div class="container" align="center">
				<form action="/signupOk" method="post" name="signup_frm">
					<input type="hidden" name="isDupl" id="isDupl" value="1"/>
					<div class="col-md-3 my-5">
						<div class="input-group">
							<input class="form-control" type="email" id="id" name="id" placeholder="아이디"> &nbsp;
							<span class="input-group-btn">
								<button class="btn btn-secondary" type="button" id="duplCheck">중복확인</button>
							</span>
						</div>	
						<br>
						<div class="input-group">
							<input class="form-control" type="email" id="nickname" name="nickname" placeholder="닉네임"> &nbsp;
							<span class="input-group-btn">
								<button class="btn btn-secondary" type="button" id="nicknameCheck">중복확인</button>
							</span>
						</div>
						<input type="hidden" name="isNicknameDupl" id="isNicknameDupl" value="1"/>
						<br> 
						<input class="form-control" type="password" name="password" placeholder="비밀번호" /> <br> 
						<input class="form-control" type="password" name="c_password" placeholder="비밀번호 확인" /><br>
						<div class="input-group">
							<div class="dropdown">
								<select name="hintSeq" class="form-select">
									<option value="0" disabled selected>비밀번호 힌트</option>
	    							<option value="1">힌트1</option>
	    							<option value="2">힌트2</option>
	    							<option value="3">힌트3</option>
	  							</select>
							</div>
							&nbsp;
							<input class="form-control" type="email" name="answer" placeholder="힌트 답변"/> &nbsp;
						</div>
						<br>
						<div class="input-group">
							<input class="form-control" type="email" id="email" name="email" placeholder="이메일" />&nbsp;
							<span class="input-group-btn">
								<button class="btn btn-secondary" type="button" id="emailCheck">이메일 인증</button>
							</span>
						</div>
						<br>
						<!-- 이메일 인증코드 -->
						<div class="input-group" id="emailCodeFrm"  style='display:none'>
							<input class="form-control" type="email" id="emailCode" name="emailCode" placeholder="인증코드"/>&nbsp;
							<span class="input-group-btn">
								<button class="btn btn-secondary" type="button" id="codeCheck">확인</button>
							</span>
						</div>
						<br>	
						<input type="hidden" name='isEmailValid' id="isEmailValid" value="0"/>
						
						<!-- 이용약관 -->
						<textarea id='agreement' class='form-control' rows="3" readonly="readonly"></textarea>
						<br>
						<label for="agreementCheck">약관 동의</label>
						<input type="checkbox" id="agreementCheck">
						<br><br>
						
						<div class="d-grid gap-2">
							<input class="btn btn-dark btn-lg" id="signup_submit" type="button" value="가입하기" />
						</div>
					</div>
				</form>
			</div>
		</main>
	</body>
</html>