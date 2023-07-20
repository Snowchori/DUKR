<%@page import="com.example.model.report.ReportTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	ArrayList<ReportTO> report_list = (ArrayList)request.getAttribute("report_list");

	StringBuilder rpHtml = new StringBuilder();
	
	for(ReportTO to: report_list) {
		rpHtml.append("<div>");
		rpHtml.append("seq : " + to.getSeq() + "<br>");
		rpHtml.append("boardSeq : " + to.getBoardSeq() + "<br>");
		rpHtml.append("memSeq : " + to.getMemSeq() + "<br>");
		rpHtml.append("writer : " + to.getWriter() + "<br>");
		rpHtml.append("content : " + to.getContent() + "<br>");
		rpHtml.append("status : " + to.getStatus() + "<br>");
		rpHtml.append("rdate : " + to.getRdate() + "<br>");
		rpHtml.append("<div>");
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

		</script>
		<style>
		
		</style>
	</head>
	<body class="bg-secondary text-white">
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title">신고글 목록</h1>
					<p class="lead fw-normal text-white-50 mb-0">Report List</p>
				</div>
			</div>
		</header>
		<main>
			<!-- ======= gameInfo Section ======= -->
			<section id="gameInfo" class="gameInfo p-3 mb-2">
				<div class="row m-3 p-4 bg-white text-black rounded-5">
					
				</div>
			</section>
			<!-- End gameInfo Section -->
		</main>
		<footer>
			<!-- 최하단 디자인 영역 -->
		</footer>
	</body>
</html>