<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<!doctype html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
		<!-- Template Main CSS File -->
		<link href="assets/css/style.css" rel="stylesheet">
		<!-- 자바 스크립트 영역 -->
		<script type="text/javascript" >
			
		</script>
		<style>
		
		</style>
	</head>
	<body class="bg-secondary text-white">
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title">로그 관리</h1>
					<p class="lead fw-normal text-white-50 mb-0">Log Manage</p>
				</div>
			</div>
		</header>
		<main>
			<!-- ======= gameInfo Section ======= -->
			<section id="gameInfo" class="gameInfo p-3 mb-2">
				<div class="row m-3 p-4 bg-white text-black rounded-5">
					<table class="table table-striped">
					  <thead>
					    <tr>
					      <th scope="col">#</th>
					      <th scope="col">닉네임</th>
					      <th scope="col">로그</th>
					      <th scope="col">날짜</th>
					    </tr>
					  </thead>
					  <tbody>
					    <tr>
					      <th scope="row">1</th>
					      <td>tester</td>
					      <td>로그인</td>
					      <td>2023.07.21</td>
					    </tr>
					    <tr>
					      <th scope="row">2</th>
					      <td>test</td>
					      <td>로그인</td>
					      <td>2023.07.21</td>
					    </tr>
					    <tr>
					      <th scope="row">3</th>
					      <td>test</td>
					      <td>로그아웃</td>
					      <td>2023.07.21</td>
					    </tr>
					    <tr>
					      <th scope="row">4</th>
					      <td>tester</td>
					      <td>로그아웃</td>
					      <td>2023.07.21</td>
					    </tr>
					  </tbody>
					</table>
				</div>
			</section>
			<!-- End gameInfo Section -->
		</main>
		<footer>
			<!-- 최하단 디자인 영역 -->
		</footer>
	</body>
</html>