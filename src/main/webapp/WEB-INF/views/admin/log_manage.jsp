<%@page import="com.example.model.logs.LogsTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	ArrayList<LogsTO> logs_list = (ArrayList)request.getAttribute("logs_list");
	
	StringBuilder logHtml = new StringBuilder();
	
	if(logs_list.size() == 0) {
		logHtml.append("로그 정보가 없습니다.");
	} else {
		logHtml.append("<table class='table table-bordered'>");
		logHtml.append("<thead>");
		logHtml.append("<tr>");
		logHtml.append("<th scope='col'>#</th>");
		logHtml.append("<th scope='col'>닉네임</th>");
		logHtml.append("<th scope='col'>로그</th>");
		logHtml.append("<th scope='col'>날짜</th>");
		logHtml.append("<th scope='col'>비고</th>");
		logHtml.append("</tr>");
		logHtml.append("</thead>");
		
		for(LogsTO to: logs_list) {
			logHtml.append("<tr class='log" + to.getLogType() + "'>");
			logHtml.append("<th scope='row'>" + to.getSeq() + "</th>");
			logHtml.append("<td>" + to.getNickname() + "</td>");
			logHtml.append("<td>" + to.getLog() + "</td>");
			logHtml.append("<td>" + to.getLdate() + "</td>");
			logHtml.append("<td>" + to.getRemarks() + "</td>");
			logHtml.append("</tr>");
		}
		
		logHtml.append("</tbody>");
		logHtml.append("</table>");
	}
%>
<!doctype html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
		<!-- Template Main CSS File -->
		<link href="assets/css/style.css" rel="stylesheet">
		<!-- 자바 스크립트 영역 -->
		<script type="text/javascript" >
			function total() {
				$('.log1').show();
				$('.log2').show();
			}
		
			function login() {
				$('.log1').show();
				$('.log2').hide();
			}
			
			function gameSearch() {
				$('.log1').hide();
				$('.log2').show();
			}
			
			function search() {
				(async () => {
					const {value: getName} = await Swal.fire({
						title: '유저 검색',
						input: 'text',
						inputAttributes: {
							autocapitalize: 'off'
						},
						inputPlaceholder: '유저 닉네임',
						showDenyButton: true,
						confirmButtonText: '검색',
						denyButtonText: `취소`
					})
					
					location.href='logManage?keyWord=' + getName;
					
				})()
			}
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
								<div class="my-3 p-2">
									<button type='button' class='btn btn-dark cbtn float-end' onclick='search()'><i class="bi bi-search"></i></button>
								</div>
								<!-- Tabs -->
								<ul class="nav nav-pills mb-3">
									<li><a class="nav-link active" data-bs-toggle="pill" onclick='total()'>전체</a></li>
									<li><a class="nav-link" data-bs-toggle="pill" onclick='login()'>로그인</a></li>
									<li><a class="nav-link" data-bs-toggle="pill" onclick='gameSearch()'>게임검색</a></li>
								</ul>
								<!-- End Tabs -->
								<!-- Tab Content -->
								<div class="tab-content">
									<div class="tab-pane fade show active">
										<%= logHtml %>
									</div>
									<!-- End Tab 1 Content -->
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