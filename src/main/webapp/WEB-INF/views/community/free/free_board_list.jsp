<%@page import="ch.qos.logback.core.recovery.ResilientSyslogOutputStream"%>
<%@page import="com.example.model.board.BoardListTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	ArrayList<BoardTO> announceList = (ArrayList)request.getAttribute("announceList");
	BoardListTO listTO = (BoardListTO)request.getAttribute("listTO");
	
	String search = (request.getParameter("search") != null) ? request.getParameter("search") : "";
	String select = (request.getParameter("select") != null) ? request.getParameter("select") : "0";
	
	int cpage = listTO.getCpage();
	int totalRecode = listTO.getTotalRecord();
	int recordPerPage = listTO.getRecordPerPage();
	int totalRecord = listTO.getTotalRecord();

	int totalPage = listTO.getTotalPage();

	int blockPerPage = listTO.getBlockPerPage();
	int startBlock = listTO.getStartBlock();
	int endBlock = listTO.getEndBlock();

	//해당 게임 태그에 맞는 게시글 리스트 
	StringBuilder boardHtml = new StringBuilder();
	
	for(BoardTO list: announceList) {
		boardHtml.append("<tr onclick='location.href=\"announceBoardView?seq=" + list.getSeq() + "\"'>");
		boardHtml.append("<td class='board-img'><i class='bi bi-megaphone h1 icon'></i></td>");
		boardHtml.append("<td><span class='badge bg-secondary'>");
		boardHtml.append(list.getTag());
		boardHtml.append("</span>&nbsp;");
		boardHtml.append(list.getSubject() + " [" + list.getCmtCnt() + "]<br>");
		boardHtml.append("<small>" + list.getWriter() + "&nbsp;" + list.getWdate() + "&nbsp;");
		boardHtml.append("<i class='bi bi-eye-fill icon'></i>" + list.getHit() + "&nbsp;");
		boardHtml.append("<i class='bi bi-hand-thumbs-up-fill icon'></i>" + list.getRecCnt() + "</small>");
		boardHtml.append("</td>");
		boardHtml.append("</tr>");
	}
	
	for(BoardTO list: listTO.getBoardLists()) {
		boardHtml.append("<tr onclick='location.href=\"freeBoardView?seq=" + list.getSeq() + "\"'>");
		boardHtml.append("<td class='board-img'><i class='bi ");
		if(!list.isHasFile()) {
			boardHtml.append("bi-file-earmark-excel");
		} else {
			boardHtml.append("bi-card-image");
		}
		boardHtml.append(" h1 icon'></i></td>");
		boardHtml.append("<td><span class='badge bg-secondary'>");
		boardHtml.append(list.getTag());
		boardHtml.append("</span>&nbsp;");
		boardHtml.append(list.getSubject() + " [" + list.getCmtCnt() + "]<br>");
		boardHtml.append("<small>" + list.getWriter() + "&nbsp;" + list.getWdate() + "&nbsp;");
		boardHtml.append("<i class='bi bi-eye-fill icon'></i>" + list.getHit() + "&nbsp;");
		boardHtml.append("<i class='bi bi-hand-thumbs-up-fill icon'></i>" + list.getRecCnt() + "</small>");
		boardHtml.append("</td>");
		boardHtml.append("</tr>");
	}
	
	StringBuilder pageHtml = new StringBuilder();
	
	if (startBlock != 1) {
		pageHtml.append("<li class='page-item'>");
		pageHtml.append("<a href='freeBoardList?select=" + select + "&search=" + search + "&cpage=");
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
			pageHtml.append("freeBoardList?select=" + select + "&search=" + search + "&cpage=" + i);
			pageHtml.append("&recordPerPage=" + recordPerPage + "' ");
			pageHtml.append(">" + i + "</a></li>");
		}
	}
	
	if(endBlock != totalPage) {
		pageHtml.append("<li class='page-item'>");
		pageHtml.append("<a href='freeBoardList?select=" + select + "&search=" + search + "&cpage=");
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
		<!-- Template Main CSS File -->
		<link href="assets/css/style.css" rel="stylesheet">
		<!-- 자바 스크립트 영역 -->
		<script type="text/javascript" >
			window.onload = function() {
				document.getElementById('sbtn').onclick = function() {
					if(document.sfrm.select.value.trim() != "0" && document.sfrm.search.value.trim() == "") {
						Swal.fire({
							icon: 'error',
							title: '검색어를 입력하세요.',
							showConfirmButton: false,
							timer: 1500
						})
					} else {
						document.sfrm.submit();
					}
				}
			}
		</script>
		<style>
			.search_select {
				width: 150px;
				float: left;
			}
			
			.search_input {
				width: 250px;
				float: left;
			}
			
			main, footer {
				max-width: 1920px;
			}
		</style>
	</head>
	<body class="bg-light">
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title">자유게시판</h1>
					<p class="lead fw-normal text-white-50 mb-0">Free Board</p>
				</div>
			</div>
		</header>
		<main class="container-fluid d-flex justify-content-center">
			<div class="container d-flex justify-content-center row bottombody">
				<div class="col-12 mt-3 p-2">
					총 <%= totalRecord %>건
					<button type='button' class='btn btn-dark float-end' data-bs-toggle="modal" data-bs-target="#searchModal" id="wbtn"><i class="bi bi-search"></i></button>
				</div>
				<div class="col-12 p-2 row boardlist">
					<table class="table">
						<%= boardHtml %>
					</table>
				</div>
				<div class="col-12 p-2">
					<button type='button' class='btn btn-dark float-end' onclick="location.href='freeBoardWrite?cpage=<%=cpage%>'">글쓰기</button>
				</div>
			</div>
			<div class="modal fade" id="searchModal">
				<div class="modal-dialog modal-sm">
					<div class="modal-content">
						<div class="modal-body">
							<div class="modalHead text-center">
								<h4><i class="bi bi-search"></i> Search</h4>
							</div>
							<form action="freeBoardList" id="sfrm" name="sfrm" method="get" class="form mt-3">
								<select name="select" id="select" class="form-select mb-3">
									<option value="0">전체</option>
									<option value="1">제목</option>
									<option value="2">제목 + 내용</option>
									<option value="3">작성자</option>
									<option value="4">태그</option>
								</select>
								<input type="text" name="search" id="search" class="form-control mb-3" maxlength="20" placeholder="검색어">
								<div class="col-12 btn-group btn-group ">
									<button type="button" id="sbtn" class="btn btn-danger"><i class="bi bi-check"></i></button>
									<button type="button" class="btn btn-dark" data-bs-dismiss="modal"><i class="bi bi-x"></i></button>
								</div>
							</form>
						</div>
					</div>
				</div>
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