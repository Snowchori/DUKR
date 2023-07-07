<%@page import="ch.qos.logback.core.recovery.ResilientSyslogOutputStream"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String client_id = "a987d1929430749f2fdae0e54a73dbf3";
	String logout_redirect_uri = "https://www.naver.com";
	String logoutUrl = "'" + "https://kauth.kakao.com/oauth/logout?client_id=" + client_id + "&logout_redirect_uri=" + logout_redirect_uri + "';";

	if(session.getAttribute("logged_in_user") != null){
		session.removeAttribute("logged_in_user");
	}
	System.out.println("logout.jsp");
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<!-- jQuery -->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
		<!-- 카카오 로그아웃 -->
		<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.2.0/kakao.min.js" integrity="sha384-x+WG2i7pOR+oWb6O5GV5f1KN2Ko6N7PTGPS7UlasYWNxZMKQA63Cj/B2lbUmUfuC" crossorigin="anonymous"></script>
		<script>
			Kakao.init('a987d1929430749f2fdae0e54a73dbf3'); // 카카오 초기화
			console.log(Kakao.isInitialized());
			
			Kakao.Auth.logout();
			console.log("social logout");
			
			location.href = "/";
		</script>
	</head>
	<body>
	</body>
</html>