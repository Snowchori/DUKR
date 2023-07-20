<%@page import="com.example.model.inquiry.InquiryTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	ArrayList<InquiryTO> inquiry_list = (ArrayList)request.getAttribute("inquiry_list");

	StringBuilder iqHtml = new StringBuilder();
	
	for(InquiryTO to: inquiry_list) {
		iqHtml.append("<div>");
		iqHtml.append("seq : " + to.getSeq() + "<br>");
		iqHtml.append("senderSeq : " + to.getSenderSeq() + "<br>");
		iqHtml.append("writer : " + to.getWriter() + "<br>");
		iqHtml.append("wdate : " + to.getWdate() + "<br>");
		iqHtml.append("subject : " + to.getSubject() + "<br>");
		iqHtml.append("content : " + to.getContent() + "<br>");
		iqHtml.append("status : " + to.getStatus() + "<br>");
		iqHtml.append("inquiryType : " + to.getInquiryType() + "<br>");
		iqHtml.append("<div>");
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
					<h1 class="title">문의 관리</h1>
					<p class="lead fw-normal text-white-50 mb-0">Inquiry Manage</p>
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