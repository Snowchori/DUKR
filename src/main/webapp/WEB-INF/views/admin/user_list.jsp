<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	ArrayList<MemberTO> user_list = (ArrayList)request.getAttribute("user_list");
	
	StringBuilder userHtml = new StringBuilder();
	
	if(user_list.size() > 0) {
		userHtml.append("<div class='accordion accordion-flush' id='accordionFlushExample'>");
		for(MemberTO to: user_list) { 
			userHtml.append("<div class='accordion-item'>");
			userHtml.append("<h2 class='accordion-header' id='flush-heading" + to.getSeq() + "'>");
			userHtml.append("<button class='accordion-button collapsed' type='button' ");
			userHtml.append("data-bs-toggle='collapse' data-bs-target='#flush-collapse" + to.getSeq());
			userHtml.append("' aria-expanded='false' aria-controls='flush-collapse" + to.getSeq() + "'>");
			userHtml.append(to.getNickname());
			userHtml.append("</button>");
			userHtml.append("</h2>");
			userHtml.append("<div id='flush-collapse" + to.getSeq() + "' class='accordion-collapse collapse' ");
			userHtml.append("aria-labelledby='flush-heading" + to.getSeq() + "' data-bs-parent='#accordionFlushExample'>");
			userHtml.append("<div class='accordion-body'>");
			userHtml.append("<div class='row'>");
			userHtml.append("<div class='col-3'>");
			userHtml.append("번호 : " + to.getSeq());
			userHtml.append("</div>");
			userHtml.append("<div class='col-3'>");
			userHtml.append("아이디 : " + to.getId());
			userHtml.append("</div>");
			userHtml.append("</div>");
			userHtml.append("<div class='row'>");
			userHtml.append("<div class='col-3'>");
			userHtml.append("이메일 : " + to.getEmail());
			userHtml.append("</div>");
			userHtml.append("<div class='col-3'>");
			userHtml.append("점수 : " + to.getRate());
			userHtml.append("</div>");
			userHtml.append("</div>");
			userHtml.append("</div>");
			userHtml.append("</div>");
			userHtml.append("</div>");
		}
		userHtml.append("</div>");
	} else {
		userHtml.append("<div class='col'>");
		userHtml.append("현재 회원이 없습니다.");
		userHtml.append("</div>");
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
					<h1 class="title">유저 목록</h1>
					<p class="lead fw-normal text-white-50 mb-0">User List</p>
				</div>
			</div>
		</header>
		<main>
			<!-- ======= gameInfo Section ======= -->
			<section id="gameInfo" class="gameInfo p-3 mb-2">
				<div class="row m-3 p-4 bg-white text-black">
					<%= userHtml %>
				</div>
			</section>
			<!-- End gameInfo Section -->
		</main>
		<footer>
			<!-- 최하단 디자인 영역 -->
		</footer>
	</body>
</html>