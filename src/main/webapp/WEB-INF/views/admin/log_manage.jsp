<%@page import="com.example.model.logs.LogListTO"%>
<%@page import="com.example.model.logs.LogsTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	LogListTO listTO = (LogListTO)request.getAttribute("listTO");
	
	int cpage = listTO.getCpage();
	int totalRecode = listTO.getTotalRecord();
	int recordPerPage = listTO.getRecordPerPage();
	int totalRecord = listTO.getTotalRecord();

	int totalPage = listTO.getTotalPage();

	int blockPerPage = listTO.getBlockPerPage();
	int startBlock = listTO.getStartBlock();
	int endBlock = listTO.getEndBlock();
	
	StringBuilder navHtml = new StringBuilder();
	
	navHtml.append("<li><a class='nav-link ");
	if(listTO.getLogType().equals("1")) {
		navHtml.append("active");		
	}
	navHtml.append("' data-bs-toggle='pill' onclick='location.href=\"logManage?logType=1\"'>로그인</a></li>");
	
	navHtml.append("<li><a class='nav-link ");
	if(listTO.getLogType().equals("2")) {
		navHtml.append("active");		
	}	
	navHtml.append("' data-bs-toggle='pill' onclick='location.href=\"logManage?logType=2\"'>게임검색</a></li>");
	
	StringBuilder logHtml = new StringBuilder();
	
	if(listTO.getLogLists().size() == 0) {
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
		
		for(LogsTO to: listTO.getLogLists()) {
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
	
	StringBuilder pageHtml = new StringBuilder();
	String searchCondition = "&keyWord=" + listTO.getKeyWord() + "&logType=" + listTO.getLogType();
	
	if (startBlock != 1) {
		pageHtml.append("<li class='page-item'>");
		pageHtml.append("<a href='logManage?cpage=");
		pageHtml.append(startBlock - blockPerPage);
		pageHtml.append("&recordPerPage=" + recordPerPage + searchCondition + "' ");
		pageHtml.append("class='page-link' aria-label='Previous'>");
		pageHtml.append("<span aria-hidden='true'>«</span>");
		pageHtml.append("</a>");
		pageHtml.append("</li>");
	}
	
	for(int i=startBlock; i<=endBlock; i++) {
		if(i == cpage) {
			pageHtml.append("<li class='page-item active'><a class='page-link'>" + i + "</a></li>");
		} else {
			pageHtml.append("<li class='page-item'><a class='page-link' href='");
			pageHtml.append("logManage?cpage=" + i);
			pageHtml.append("&recordPerPage=" + recordPerPage + searchCondition + "' ");
			pageHtml.append(">" + i + "</a></li>");
		}
	}
	
	if(endBlock != totalPage) {
		pageHtml.append("<li class='page-item'>");
		pageHtml.append("<a href='logManage?cpage=");
		pageHtml.append(startBlock + blockPerPage);
		pageHtml.append("&recordPerPage=" + recordPerPage + searchCondition + "' ");
		pageHtml.append("class='page-link' aria-label='Next'>");
		pageHtml.append("<span aria-hidden='true'>»</span>");
		pageHtml.append("</a>");
		pageHtml.append("</li>");
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
					
					location.href='logManage?keyWord=' + getName + '&logType=<%= listTO.getLogType() %>';
					
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
									<%= navHtml %>
								</ul>
								<!-- End Tabs -->
								<!-- Tab Content -->
								<div class="tab-content">
									<div class="mt-3 p-2">
										총 <%= totalRecord %>건
									</div>
									<div class="tab-pane fade show active">
										<%= logHtml %>
									</div>
									<!-- End Tab 1 Content -->
									<div class="container p-2">
										<nav class="pagination-outer" aria-label="Page navigation">
											<ul class="pagination">
												<%= pageHtml %>
											</ul>
										</nav>
									</div>
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