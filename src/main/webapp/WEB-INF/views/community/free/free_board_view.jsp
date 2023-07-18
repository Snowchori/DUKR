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
			window.onload = function(){
				document.getElementById("recBtn").onclick = function(){
					$.ajax({
						url:'/rec',
			  			type:'post',
			  			data: {
			  				boardSeq: <%=boardSeq %>
			  			},
			  			success: function(res){
			  				alert(res);
			  			}
					});
				};
			};
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

			<div class="container">
				<div class="row justify-content-center">
    				<div class="col-lg-8">
			
  						<hr class="my-4">
  				
						<div class="container text-left"> 
							<b><%=subject %></b>
							<div style="text-align: left; font-size: 16px; margin-top: 8px; color: #888888;">
								<b>
									<span class="dropdown">
  										<a href="#" role="button" id="dropdownMenuLink" data-bs-toggle="dropdown" aria-expanded="false">
    										<%=writer %>
  										</a>
  										<ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
    										<li><a class="dropdown-item" href="/freeBoardList?select=3&search=<%=writer%>">게시글 보기</a></li>
    										<li><a class="dropdown-item" href="/freeBoardList?">댓글 보기</a></li>
  										</ul>
									</span>
								</b>&nbsp;
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
				
						<br>
  						<div class="row justify-content-center">
    						<div class="col-md-6 text-center">
      							<button id="recBtn" class="btn btn-primary">
        							<i class="fas fa-thumbs-up"></i> 추천
      							</button>
    						</div>
  						</div>
				
						<br>
						<b style="font-size: 20px;">댓글</b>
  						<hr class="my-2">
  				
  						<div name="cmtArea">
  							<div>
  								<b>testwriter</b>&nbsp; 
  								<span style="color:#888888;">2023-07-18</span>
  								<button class="btn" style="font-size:14px; color: #4db2b2;">
  									<i class="fas fa-thumbs-up"></i>
  									10
  								</button>
  								<br>
  								test comment1
  								<hr class="my-2">
  					
  								<b>testwriter</b>&nbsp; 
  								<span style="color:#888888;">2023-07-18</span>
  								<button class="btn" style="font-size:14px; color: #4db2b2;">
  									<i class="fas fa-thumbs-up"></i>
  									10
  								</button>
  								<br>
  								test comment1
  								<hr class="my-2">
  							</div>
  				
  							<form action="" method="post" name="cmtWriteFrm">
  								<textarea id="comment" name="comment" class="form-control" rows="3" placeholder="댓글">
  								</textarea>
  								<div class="text-lg-end" style="margin-top:10px;">
  									<button class="btn btn-secondary float-right">댓글쓰기</button>
  								</div>
  							</form>	
  					
  						</div>
  				
  					</div>
  				</div>
			</div>
		</main>
		<footer>
		</footer>
	</body>
</html>