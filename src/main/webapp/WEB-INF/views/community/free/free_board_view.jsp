<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>

<%
	BoardTO to = (BoardTO)request.getAttribute("to");
	
	String subject = to.getSubject();
	String writer = to.getWriter();
	String content = to.getContent();
	String wdate = to.getWdate();
	String wip = to.getWip();
	String hit = to.getHit();
	String recCnt = to.getRecCnt();
	String cmtCnt = to.getCmtCnt();
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
  			img {
  				width: 100%;
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
  				
				<div class="container text-left" style="margin-top: -10px; font-size: 20px;">
					<b><%=subject %></b>
					<div style="text-align: left; font-size: 16px; margin-top: 5px; color: #888888;">
						<b><%=writer %></b>&nbsp;&nbsp;
						<%=wdate %>&nbsp;&nbsp;
						<i class="fas fa-eye"></i>&nbsp;<%=hit %>&nbsp;&nbsp;
						<i class="fas fa-comment"></i>&nbsp;<%=cmtCnt %>&nbsp;&nbsp;
						<i class="fas fa-thumbs-up"></i>&nbsp;<%=recCnt %>
					</div>
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
				
  				<hr class="my-4">
  				
			</div>
		</main>
		<footer>
		</footer>
	</body>
</html>