<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>

<%
	BoardTO to = (BoardTO)request.getAttribute("to");
	
	String boardSeq = "'" + to.getSeq() + "'";
	
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
  			table img {
    			max-width: 50%;
  			}
  			table {
   				border-collapse: collapse;
  			}
  			table tr, table th, table td {
    			border: 1px solid black;
  			}
  			
  			.slash{
  				font-size: 15px;
  			}
  			
  			.dropdown{
  				display: inline-block;
  			}
  			
  			.disinherit{
  				color: black;
  			}
  			
  			.container.content{
  				
  				border-top: 1px black solid;
  				border-bottom: 1px black solid;
  			}
		</style>

	</head>
	<body>
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title">모임게시판</h1>
					<p class="lead fw-normal text-white-50 mb-0">Free Board</p>
				</div>
			</div>
		</header>
		<main>

			<div class="container content mt-4" >
				<div class="container text-left mt-4" style="font-size: 20px;">
					<b><%=subject %></b>
					<div style="text-align: left; font-size: 16px; margin-top: 8px; color: #888888;">
						<div class="dropdown">
							<a href="#" class="disinherit" role="button" id="dropdownMenuLink" data-bs-toggle="dropdown" aria-expanded="false">
 								<%=writer %>
							</a>
							<span>(<%= wip %>)</span>
							<ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
  								<li><a class="dropdown-item" href="/freeBoardList?select=3&search=<%=writer%>">게시글 보기</a></li>
  								<li><a class="dropdown-item" href="/freeBoardList?">댓글 보기</a></li>
							</ul>
						</div>
						<span class="slash">|</span>
						<span class="disinherit"><%=wdate %></span>&nbsp;&nbsp;
						<i class="fas fa-eye"></i>&nbsp;<%=hit %>&nbsp;&nbsp;
						<i class="fas fa-comment"></i>&nbsp;<%=cmtCnt %>&nbsp;&nbsp;
						<i class="fas fa-thumbs-up"></i>&nbsp;<%=recCnt %>
					</div>
				</div>
				
  					<hr class="my-4">
				
				<div class="container text-left">
					<div class="row">
						<div class="col-md-6">
							<%=content %>	
						</div>		
					</div>
				</div>
				
  				<div class="row justify-content-center">
    				<div class="col-md-6 text-center">
      					<button id="recBtn" class="btn btn-primary">
        					<i class="fas fa-thumbs-up"></i> 추천
      					</button>
    				</div>
  				</div>
  					<hr class="my-4">
			</div>
		</main>
		<footer>
		</footer>
	</body>
</html>