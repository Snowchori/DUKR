<%@ page import="ch.qos.logback.core.recovery.ResilientSyslogOutputStream"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	String code = "'" + request.getParameter("code") + "'";
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
			
			function requestKakaoLoginApiKey(){
				return new Promise(function(resolve, reject){
					$.ajax({
						url: '/kakaoApiLoginKey',
						type: 'POST',
						success: function(res){
							resolve(res);
						}
					});
				});
			}

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

		        		resolve(userInf);
					}).catch(function(err) {
		      			reject('failed to request user information: ' + JSON.stringify(err));
		      		});
				});
			}
			
			requestKakaoLoginApiKey()
			.then(function(clientID){
				
				Kakao.init(clientID);

				$.ajax({
					type: "POST",
					url: 'https://kauth.kakao.com/oauth/token',
					data: {
						grant_type: 'authorization_code',
					    client_id: clientID,
					    redirect_uri: 'http://54.180.57.106:8080/loginKakao',
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
					        
					        // 로그인 성공 후 이동
							window.location.href = document.referrer;
	       
						}).catch(function(err) {
							console.error('Failed to request user information: ' + err);
						});
					},
						error: function(jqXHR, error) {
							console.log('err :' + clientID);
					    console.log('토큰 실패');
					}
				});
			});
			
		</script>
	</head>
	<body>
	</body>
</html>