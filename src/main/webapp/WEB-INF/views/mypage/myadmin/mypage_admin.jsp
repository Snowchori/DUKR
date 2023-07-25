<%@page import="com.example.model.inquiry.InquiryTO"%>
<%@page import="com.example.model.inquiry.InquiryListTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	InquiryListTO listTO = (InquiryListTO)request.getAttribute("listTO");

	int cpage = listTO.getCpage();
	int totalRecode = listTO.getTotalRecord();
	int recordPerPage = listTO.getRecordPerPage();
	int totalRecord = listTO.getTotalRecord();
	
	int totalPage = listTO.getTotalPage();
	
	int blockPerPage = listTO.getBlockPerPage();
	int startBlock = listTO.getStartBlock();
	int endBlock = listTO.getEndBlock();
	
	//문의 목록 html
	StringBuilder inquiryHTML = new StringBuilder();
	inquiryHTML.append("<table class='table'>");
	for(InquiryTO inquiryTO : listTO.getInquiryLists()) {
		inquiryHTML.append("<tr onclick='location.href=\"/adminView?seq="+inquiryTO.getSeq()+"\"'>");
		if(inquiryTO.getStatus() == 1) {
			inquiryHTML.append("<td style='width: 10px;'><i class='bi bi-check-square h1'></i></i></td>");
		} else {
			inquiryHTML.append("<td style='width: 10px;'><i class='bi bi-square h1'></i></i></td>");
		}
		inquiryHTML.append("<td>&nbsp&nbsp<span class='badge bg-secondary'>"+inquiryTO.getInquiryType()+"</span>&nbsp&nbsp "+inquiryTO.getSubject()+"</br>");
		inquiryHTML.append("<small>&nbsp&nbsp&nbsp&nbsp "+inquiryTO.getWriter()+" &nbsp&nbsp "+inquiryTO.getWdate()+"</small>");
		inquiryHTML.append("</td></tr>");
	}
	inquiryHTML.append("</table>");
	
	//페이징
	StringBuilder pageHtml = new StringBuilder();
	
	if (startBlock != 1) {
		pageHtml.append("<li class='page-item'>");
		pageHtml.append("<a href='admin?cpage=");
		pageHtml.append(startBlock - blockPerPage);
		pageHtml.append("&recordPerPage=" + recordPerPage + "' ");
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
			pageHtml.append("admin?cpage=" + i);
			pageHtml.append("&recordPerPage=" + recordPerPage + "' ");
			pageHtml.append(">" + i + "</a></li>");
		}
	}
	
	if(endBlock != totalPage) {
		pageHtml.append("<li class='page-item'>");
		pageHtml.append("<a href='admin?cpage=");
		pageHtml.append(startBlock + blockPerPage);
		pageHtml.append("&recordPerPage=" + recordPerPage + "' ");
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
		<!-- 자바 스크립트 영역 -->
		<script type="text/javascript">
		</script>
		<link href="assets/css/style.css" rel="stylesheet">
		<style type="text/css">
			.selection > div > div{
				padding: 5px 0 5px 0;
				border: 1px #cacaca solid;
				box-sizing: border-box;
				cursor: pointer;
			}
			.selection > div > div:hover{
				background-color: #f2f2f2;
			}
		</style>
	</head>
	<body>
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title">마이페이지</h1>
					<p class="lead fw-normal text-white-50 mb-0">MyPage</p>
				</div>
			</div>
		</header>
		<main>
	  		<!-- 버튼 디자인 -->
			<div class="container mt-3">
				<div class="row g-1 text-center selection">
					<div class="col-6 col-lg-3" onClick="location.href='/mypage'"><div>회원 정보 변경</div></div>
					<div class="col-6 col-lg-3" onClick="location.href='/mywrite'"><div>내가 쓴 글</div></div>
					<div class="col-6 col-lg-3" onClick="location.href='/mycomment'"><div>내가 쓴 댓글</div></div>
					<div class="col-6 col-lg-3" onClick="location.href='/favwrite'"><div>좋아요 한 글</div></div>
					<div class="col-6 col-lg-3" onClick="location.href='/favgame'"><div>즐겨찾기 한 게임</div></div>
					<div class="col-6 col-lg-3" onClick="location.href='/mail'"><div>쪽지함</div></div>
					<div class="col-6 col-lg-3" onClick="location.href='/admin'"><div>문의하기</div></div>
					<div class="col-6 col-lg-3" onClick="location.href='/myparty'"><div>참여신청한 모임</div></div>
				</div>
			</div>
			<!-- 버튼 디자인 -->
	  		<!-- 마이페이지 정보페이지 디자인 -->
	  		<div class="container my-4">
    			<div class="d-flex justify-content-end">
        			<div>
						<button type="button" class="btn btn-dark" onclick="location.href='/adminWrite'">문의글 작성하기</button>
        			</div>
    			</div>
			</div>
			<div class="container">
				<%=inquiryHTML %>
			</div>
		</main>
		<footer class="container-fluid d-flex justify-content-center bg-light">
			<div class="container demo mx-5 p-2">
				<nav class="pagination-outer" aria-label="Page navigation">
					<ul class="pagination">
						<%= pageHtml %>
					</ul>
				</nav>
			</div>
		</footer>
	</body>
</html>