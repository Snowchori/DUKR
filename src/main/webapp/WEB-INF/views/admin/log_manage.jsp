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
			<!-- ======= About Section ======= -->
			<section id="about" class="about">
				<div class="row m-3 p-4 bg-white text-black rounded-5">
					<div class="container" data-aos="fade-up">
						<div class="row g-4 g-lg-5" data-aos="fade-up" data-aos-delay="200">
							<div class="col-lg-12">
								<!-- Tabs -->
								<ul class="nav nav-pills mb-3">
									<li><a class="nav-link active" data-bs-toggle="pill" href="#tab1">로그인</a></li>
									<li><a class="nav-link" data-bs-toggle="pill" href="#tab2">게임검색</a></li>
								</ul>
								<!-- End Tabs -->
								<!-- Tab Content -->
								<div class="tab-content">
									<div class="tab-pane fade show active" id="tab1">
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
									<!-- End Tab 1 Content -->
									<div class="tab-pane fade show" id="tab2">
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
										      <td>게임검색</td>
										      <td>2023.07.21</td>
										    </tr>
										    <tr>
										      <th scope="row">2</th>
										      <td>test</td>
										      <td>게임검색</td>
										      <td>2023.07.21</td>
										    </tr>
										    <tr>
										      <th scope="row">3</th>
										      <td>test</td>
										      <td>게임검색</td>
										      <td>2023.07.21</td>
										    </tr>
										    <tr>
										      <th scope="row">4</th>
										      <td>tester</td>
										      <td>게임검색</td>
										      <td>2023.07.21</td>
										    </tr>
										  </tbody>
										</table>
									</div>
									<!-- End Tab 2 Content -->
								</div>
							</div>
						</div>
					</div>
				</div>
			</section>
			<!-- End About Section -->
		</main>
		<footer>
			<!-- 최하단 디자인 영역 -->
		</footer>
	</body>
</html>