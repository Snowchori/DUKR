<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>

<%
	BoardTO to = (BoardTO)request.getAttribute("to");
	
	String subject = to.getSubject();
	String writer = to.getWriter();
	String content = to.getContent();
%>
<!doctype html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
		<!-- Template Main CSS File -->
		<link href="assets/css/style.css" rel="stylesheet">
		<!-- 자바 스크립트 영역 -->
		<script type="text/javascript" >
		</script>
		<style>
  			table img {
    			max-width: 50%;
  			}
  			table {
   				border-collapse: collapse;
  			}
  			table tr, table th, table td {
    			border: 1px solid black;
  			}
		</style>

	</head>
	<body>
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title">자유게시판</h1>
					<p class="lead fw-normal text-white-50 mb-0">Free Board</p>
				</div>
			</div>
		</header>
		<main>

			<div class="container" >
  				<hr class="my-4">
			</div>
			<div class="container text-left" style="margin-top: -10px; font-size: 20px;">
				<b><%=subject %></b>
			</div>
			<div class="container" style="margin-top: -10px;">
  				<hr class="my-4">
			</div>
			<div class="container text-left">
				<div class="row">
					<div class="col-md-6">
						<%=content %>	
					</div>		
				</div>
			</div>
			<div class="container">
  				<hr class="my-4">
			</div>
			
		</main>
		<footer>
		</footer>
	</body>
</html>