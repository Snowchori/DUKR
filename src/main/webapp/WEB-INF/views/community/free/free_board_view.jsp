<%@page import="com.example.model.comment.CommentListTO"%>
<%@page import="com.example.model.comment.CommentTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>

<%
	String memSeq = "null";
	if(session.getAttribute("logged_in_user") != null){
		MemberTO logged_in_user = (MemberTO)session.getAttribute("logged_in_user");
		memSeq = "'" + logged_in_user.getSeq() + "'";
	}
%>
<%
	BoardTO to = (BoardTO)request.getAttribute("to");

	String boardSeq = to.getSeq();

	String subject = to.getSubject();
	String writer = to.getWriter();
	String content = to.getContent();
	String wdate = to.getWdate();
	String wip = to.getWip();
	String hit = to.getHit();
	String recCnt = to.getRecCnt();
	String cmtCnt = to.getCmtCnt();
%>
<%
	CommentListTO commentListTo = new CommentListTO();
	commentListTo = (CommentListTO)request.getAttribute("commentListTo");

	StringBuilder sbComments = new StringBuilder();
	StringBuilder sbScript = new StringBuilder();
	
	for(CommentTO comment : commentListTo.getCommentList()){
		String cSeq = comment.getSeq();
		String writerSeq = comment.getMemSeq();
		String cWriter = comment.getWriter();
		String cWdate = comment.getWdate();
		int cRecCnt = comment.getRecCnt();
		String cContent = comment.getContent();

		sbComments.append("<span class='dropdown'>");	
		sbComments.append("<a href='#' role='button' id='dropdownMenuLinkc' data-bs-toggle='dropdown' aria-expanded='false'>");	
		sbComments.append(cWriter);	
		sbComments.append("</a>");
		sbComments.append("<ul class='dropdown-menu' aria-labelledby='dropdownMenuLinkc'>");
		sbComments.append("<li><a class='dropdown-item' href='/freeBoardList?select=3&search=" + cWriter + "'>게시글 보기</a></li>");	
		sbComments.append("<li><a class='dropdown-item' href='/freeBoardList?'>댓글 보기</a></li>");	
		sbComments.append("</ul>");	
		sbComments.append("</span>&nbsp;");	
		sbComments.append("<span style='color:#888888;'>" + cWdate + "</span>");	
		sbComments.append("<button id='cmtRecBtn" + cSeq + "' class='btn' style='font-size:14px; color: #4db2b2;'>");	
		sbComments.append("<i class='fas fa-thumbs-up'></i>&nbsp;");		
		sbComments.append(cRecCnt);		
		sbComments.append("</button>");	
		sbComments.append("<br>");	
		sbComments.append(cContent);	
		sbComments.append("<hr class='my-2'>");	
		
		sbScript.append("document.getElementById('cmtRecBtn" + cSeq + "').onclick = function(){");
		sbScript.append("$.ajax({");
		sbScript.append("url: '/commentRec',");
		sbScript.append("type: 'post',");
		sbScript.append("data: {");
		sbScript.append("writerSeq: " + writerSeq + ",");
		sbScript.append("memSeq: " + memSeq + ",");
		sbScript.append("cmtSeq: " + cSeq + ",");
		sbScript.append("},");
		sbScript.append("success: function(res){");
		sbScript.append("if(res == 0){");
		sbScript.append("alert('먼저 로그인을 해야합니다');");
		sbScript.append("}else if(res == 1) {");
		sbScript.append("location.href='/freeBoardView?seq=" + boardSeq + "';");
		sbScript.append("}else if(res == 2){");
		sbScript.append("alert('이미 추천한 댓글입니다');");
		sbScript.append("}else{");
		sbScript.append("alert('자신의 댓글은 추천 불가능합니다');");
		sbScript.append("}");
		sbScript.append("}");
		sbScript.append("});");
		sbScript.append("};");
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
			window.onload = function(){
				// 추천하기
				document.getElementById("recBtn").onclick = function(){
					$.ajax({
						url:'/rec',
			  			type:'post',
			  			data: {
			  				boardSeq: <%=boardSeq %>
			  			},
			  			success: function(res){
			  				Swal.fire({
					  			icon: '',
					  			title: res,
					  			confirmButtonText: '확인',
					  			willClose: () => {
					  				location.href='/freeBoardView?seq=<%=boardSeq %>';
				  				}
			  				});
			  			}
					});
				};
				
				// 댓글쓰기
				document.getElementById("cmtWbtn").onclick = function(){
					$.ajax({
						url:'/freeboardCommentWrite',
						type:'post',
						data: {
							boardSeq: <%=boardSeq %>,
							memSeq: <%=memSeq %>,
							content: document.getElementById("cContent").value,
						},
						success: function(res){
							if(res == 1){
								location.href = "/freeBoardView?seq=" + <%=boardSeq %>;
							}else{
								alert("먼저 로그인을 해야합니다");
								console.log(res);
							}
						}
					});
				};
				
				<%=sbScript %>
			};
		</script>
		<style>
		.bottombody{
			max-width: 992px;
		}
		
		.subject_info{
			display: flex;
		}
		.main_info{
			margin-right: auto;
		}
		
		.slash {
			font-size: 15px;
		}
		
		.dropdown {
			display: inline-block;
		}
		
		.disinherit {
			color: black;
		}
		
		img {
			max-width: 100%;
		}
		
		.image{
			display: flex;
			justify-content: center;
		}
		.image.image-style-side{
			display: flex;
			justify-content: flex-end;
		}
		
		@media (max-width: 575px){
			.subject_info{
				font-size: 14px;
			}
		}
		
		@media (min-width: 576px){
			.subject_info{
				font-size: 16px;
			}
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

			<div class="container-fluid bottombody">
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
						<i class="fas fa-comment"></i>&nbsp;<%=commentListTo.getCommentList().size() %>&nbsp;&nbsp;
						<i class="fas fa-thumbs-up"></i>&nbsp;<%=recCnt %>
					</div>
				</div>
		
				<div class="container" style="margin-top: -10px;">
							<hr class="my-4">
				</div>
		
				<div class="container">
					<%=content %>
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
				
						<!-- 댓글영역 -->
						<div name="cmtArea">
							<div>
								<%=sbComments %>
							</div>
										
							<textarea id="cContent" name="cContent" class="form-control" rows="3">
							</textarea>
							<div class="text-lg-end" style="margin-top:10px;">
								<button id="cmtWbtn" class="btn btn-secondary float-right">댓글쓰기</button>
							</div>
						
						</div>
				
				</div>
			</div>
		</main>
		<footer>
		</footer>
	</body>
</html>