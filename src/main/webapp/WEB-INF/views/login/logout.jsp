<%@page import="ch.qos.logback.core.recovery.ResilientSyslogOutputStream"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	if(session.getAttribute("logged_in_user") != null){
		session.removeAttribute("logged_in_user");
	}
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
			Kakao.init('<%=kakaoApiLoginKey %>'); // 카카오 초기화
			console.log(Kakao.isInitialized());
			
			Kakao.Auth.logout();
			console.log("social logout");
			
			location.href = document.referrer;
		</script>
	</head>
	<body>
	</body>
</html>