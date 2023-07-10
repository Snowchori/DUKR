<%@ page import="ch.qos.logback.core.recovery.ResilientSyslogOutputStream"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String code = "'" + request.getParameter("code") + "'";
	System.out.println(code);
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<!-- 카카오 로그인 -->
		<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.2.0/kakao.min.js"
			integrity="sha384-x+WG2i7pOR+oWb6O5GV5f1KN2Ko6N7PTGPS7UlasYWNxZMKQA63Cj/B2lbUmUfuC"
			crossorigin="anonymous"></script>
		<!-- jQuery -->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
		<script type="text/javascript">
			Kakao.init('a987d1929430749f2fdae0e54a73dbf3'); // 카카오 초기화
			console.log(Kakao.isInitialized());
		
			// 유저 정보 요청 함수 - 비동기
			function requestUserInfo() {
				return new Promise(function(resolve, reject) {
					Kakao.API.request({
			      		url: '/v2/user/me',
			      	}).then(function(res) {
		        		const email = res.kakao_account.email;
		        		const id = res.id;
		        		const nickname = res.properties.nickname;
		        	
		        		const userInf = id + '/' + nickname + '/' + email;
		        		//console.log(userInf);
		        	
		        		resolve(userInf);
					}).catch(function(err) {
		      			reject('failed to request user information: ' + JSON.stringify(err));
		      		});
				});
			}
			
			$.ajax({
				type: "POST",
				url: 'https://kauth.kakao.com/oauth/token',
				data: {
					grant_type: 'authorization_code',
				    client_id: 'a987d1929430749f2fdae0e54a73dbf3',
				    redirect_uri: 'http://localhost:8080/loginKakao',
					code: <%=code%>
				},
				contentType: 'application/x-www-form-urlencoded;charset=utf-8',
				dataType: 'JSON',
				success: function(response) {
					Kakao.Auth.setAccessToken(response.access_token);
		
				    console.log('토큰획득 성공');
		
					requestUserInfo()
					.then(function(userInfo) {
						console.log("userinf " + userInfo);
		
				        // 컨트롤러단에 POST 방식으로 액세스토큰 및 유저정보 전송 => 컨트롤러에서 httpSession에 저장
				        $.ajax({
				        	url: '/saveToken',
				          	type: 'POST',
				          	data: {
				            	token: response.access_token,
				            	userInfo: userInfo
				          	},
				          	success: function(res) {
				            	console.log('토큰 - 세션에 저장 성공');
				          	},
				          	error: function(xhr) {
				            	console.log('토큰 - 세선에 저장 실패');
				          	}
				        });  
				        
				        // 로그인 성공 후 메인페이지로 이동
						location.href = "/";
				        
					}).catch(function(err) {
						console.error('Failed to request user information: ' + err);
					});
				},
					error: function(jqXHR, error) {
				    console.log('토큰 실패');
				}
			});
		</script>
	</head>
	<body>
	</body>
</html>