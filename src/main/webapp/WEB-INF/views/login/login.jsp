<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<!doctype html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
		<!-- Jquery -->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
		<!-- 카카오 로그인 -->
		<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.2.0/kakao.min.js" integrity="sha384-x+WG2i7pOR+oWb6O5GV5f1KN2Ko6N7PTGPS7UlasYWNxZMKQA63Cj/B2lbUmUfuC" crossorigin="anonymous"></script>
		<script>
			Kakao.init('a987d1929430749f2fdae0e54a73dbf3'); // 카카오 초기화
			console.log(Kakao.isInitialized());
			
			function loginWithKakao() {
		    	Kakao.Auth.authorize({
		    		redirectUri: 'http://localhost:8080/loginKakao',
		     		state: 'userme',
		    	});
		  	}	
		</script>
		<!-- 자바 스크립트 영역 -->
		<script type="text/javascript">
			window.onload = function(){
				document.getElementById("login_submit").onclick = function(){
					if(document.login_frm.id.value.trim() == ""){
						Swal.fire('아이디를 입력하세요');
						return false;
					}
					if(document.login_frm.password.value.trim() == ""){
						Swal.fire('비밀번호를 입력하세요');
						return false;
					}
					$.ajax({
			  			url:'loginOk',
			  			type:'post',
			  			data: {
			  				id: document.login_frm.id.value.trim(),
			  				password: document.login_frm.password.value.trim()
			  			},
			  			success: function(data) {
				  			if(data == 0) {
					  			Swal.fire({
						  			icon: 'success',
						  			title: '로그인 완료',
						  			confirmButtonText: '확인',
						  			willClose: () => {
						  				location.href='/';
					  				}
				  				});
				  			} else {
					  			Swal.fire({
						  			icon: 'error',
						  			title: '로그인 실패',
						  			confirmButtonText: '확인'
					  			});
				  			}
				  		}
				  	});
				};
				
				document.getElementById("logoutBtn").onclick = function(){
					location.href = "/logout";
				};
			};
		</script>
		<style type="text/css">
			@font-face {
				font-family: 'SBAggroB';
				src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2108@1.1/SBAggroB.woff') format('woff');
				font-weight: normal;
				font-style: normal;
			}
	
			.title {
				font-family: SBAggroB;
			}
		</style>
	</head>
	<body>
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title">로그인</h1>
					<p class="lead fw-normal text-white-50 mb-0">LogIn</p>
				</div>
			</div>
		</header>
		<main>
			<div name="login-wrap" class="container" align="center">
				<div class="col-md-3 mt-3">
					<form action="loginOk" method="post" name="login_frm">
		    			<input class="form-control" type="email" name="id" placeholder="아이디" /><br> 
		    			<input class="form-control" type="password" name="password" placeholder="비밀번호" />
					    <%
							// login_ok 에서 아이디/비밀번호 오류로 회귀한 경우 - 폼에 글자띄우기
							if(request.getAttribute("error") != null && request.getAttribute("error").equals("error")){
								out.println("<h6 style='color:red'>아이디 또는 비밀번호를 확인하세요</h6>");
							}else{
								out.println("<br>");
							}
						%>	
		    			<div class="d-flex justify-content-between align-items-center">
		        			<div class="form-check form-switch">
		           				<input class="form-check-input" type="checkbox" id="auto_login">
		            			<label class="form-check-label" for="auto_login">자동 로그인</label>
		        			</div>
		        			<a href="/find">아이디/비밀번호 찾기</a>
		    			</div>
		    			<br><br>		
		    			<div class="d-grid gap-2">
		        			<input class="btn btn-primary btn-lg" type="button" id="login_submit" value="로그인" />
		    			</div>
		    		</form>
		    		<br>
					<div class="d-grid gap-2">
		    			<a class="btn btn-primary btn-lg" href="/signup">회원가입</a>
					</div>
		    	</div>
		    	<br>
		    	<div align="center">
					<a id="kakao-login-btn" href="javascript:loginWithKakao()">
						<img src="https://k.kakaocdn.net/14/dn/btroDszwNrM/I6efHub1SN5KCJqLm1Ovx1/o.jpg"
							height="auto" alt="카카오 로그인 버튼" />
					</a>
				</div>
			</div>
		</main>
		<footer>
			<!-- 최하단 디자인 영역 -->
		</footer>
	</body>
</html>