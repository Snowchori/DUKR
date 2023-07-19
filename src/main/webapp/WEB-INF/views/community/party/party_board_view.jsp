<%@page import="com.example.model.party.ApplyTO"%>
<%@page import="com.example.model.comment.CommentTO"%>
<%@page import="com.example.model.comment.CommentListTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf"%>

<%
BoardTO to = (BoardTO) request.getAttribute("to");

String boardSeq = to.getSeq();

String subject = to.getSubject();
String writer = to.getWriter();
String memSeq = to.getMemSeq();
String content = to.getContent();
String wdate = to.getWdate();
String wip = to.getWip();
String hit = to.getHit();
String recCnt = to.getRecCnt();
String cmtCnt = to.getCmtCnt();
%>
<%
CommentListTO commentListTo = new CommentListTO();
commentListTo = (CommentListTO) request.getAttribute("commentListTo");

StringBuilder sbComments = new StringBuilder();
StringBuilder sbScript = new StringBuilder();

for (CommentTO comment : commentListTo.getCommentList()) {
	String cWriter = comment.getWriter();
	String cWdate = comment.getWdate();
	int cRecCnt = comment.getRecCnt();
	String cContent = comment.getContent();
	String cSeq = comment.getSeq();
	String writerSeq = comment.getMemSeq();

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
	sbComments.append("<button id='cmtRecBtn" + cSeq + "' class='btn' style='font-size:14px; color: #4db2b2;' onclick='recommendComment(\"" + writerSeq + "\", \"" + userSeq + "\", \"" + cSeq + "\")'>");
	sbComments.append("<i class='fas fa-thumbs-up'></i>&nbsp;");		
	sbComments.append(cRecCnt);		
	sbComments.append("</button>");	
	sbComments.append("<br>");	
	sbComments.append(cContent);	
	sbComments.append("<hr class='my-2'>");	
}
%>
<%
int status = (int)request.getAttribute("status");
String strApply = "";
boolean isWriter = true;

if(!memSeq.equals(userSeq)){
	strApply = "&nbsp;<button id='appBtn' class='btn btn-success'><i id='appIcon' class='bi bi-patch-check'></i>&nbsp;<span id='appText'>참여신청</span></button>";
	isWriter = false;
}
%>
<!doctype html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf"%>
		<!-- Template Main CSS File -->
		<link href="assets/css/style.css" rel="stylesheet">
		<!-- 자바 스크립트 영역 -->
		<script type="text/javascript">
			window.onload = function() {
				const bseq = <%= boardSeq %>, useq = <%= userSeq %>, isWriter = <%= isWriter %>;
				let status = <%= status %>;
				
				function loggedin(){
					if (useq !== null) {
						return true;
					} else {
						Swal.fire({
							icon : 'warning',
							title : '로그인 필요'
						});
						return false;
					}
				}
				
				document.getElementById("recBtn").onclick = function() {
					$.ajax({
						url : '/rec',
						type : 'post',
						data : {
							boardSeq : bseq
						},
						success : function(res) {
							alert(res);
						}
					});
				};
		
				// 댓글쓰기
				document.getElementById("cmtWbtn").onclick = function() {
					$.ajax({
						url : '/freeboardCommentWrite',
						type : 'post',
						data : {
							boardSeq : <%=boardSeq %>,
							memSeq : <%=userSeq %>,
							content : document.getElementById("cContent").value,
						},
						success : function(res) {
							if (res != "") {
								$('#comments').html(res);
								$('#cContent').val('');
							} else {
								alert("먼저 로그인 해야합니다");
								console.log(res);
							}
						}
					});
				};

				let appIcon = null;
				let appText = null;
				if(!isWriter){
					appIcon = document.getElementById("appIcon");
					appText = document.getElementById("appText");
					
					if(status == 1){
						appText.innerText = '신청완료';
						appIcon.className = "bi bi-patch-check-fill";
					}else if(status == 2){
						appText.innerText = '승인완료';
						appIcon.className = "bi bi-person-check-fill";
					}
					
					document.getElementById("appBtn").onclick = function() {
						if(loggedin()){
							if(status == 0){
								$.ajax({
									url : '/partyApplyOk',
									type: 'post',
									data: {
										boardSeq : bseq,
										memSeq : useq,
										status : status
									},
									success: function(result){
										status = 1;
										appIcon.className = "bi bi-patch-check-fill";
									}
								});
							}else{
								let tmp = 0;
								if(status > 0){
									tmp = -1;
								}else{
									tmp = 1;
								}
								$.ajax({
									url : '/partyToggleOk',
									type: 'post',
									data: {
										boardSeq : bseq,
										memSeq : useq,
										status : tmp
									},
									success: function(result){
										status = tmp;
										if(status == -1){
											appText.innerText = '참여신청';
											appIcon.className = "bi bi-patch-check";
										}else{
											appText.innerText = '신청완료';
											appIcon.className = "bi bi-patch-check-fill";
										}
									}
								});
							}
						}
					}
				}else{
					
				}

			};
			
			// 댓글 추천함수
			function recommendComment(wSeq, mSeq, cSeq){
				$.ajax({
					url: '/commentRec',
					type: 'POST',
					data:{
						writerSeq: wSeq,
						memSeq: mSeq,
						cmtSeq: cSeq,
					},
					success: function(res){
						if(res == 0){
							alert('먼저 로그인 해야합니다');
						}else if(res == 1){
							let btnId = 'cmtRecBtn' + cSeq;
							let btnHtml = $('#' + btnId).html();
							const curRec = btnHtml.replace('<i class="fas fa-thumbs-up" aria-hidden="true"></i>&nbsp;', '');
							const newRec = parseInt(curRec) + 1;

							$('#' + btnId).html('<i class="fas fa-thumbs-up" aria-hidden="true"></i>&nbsp;' + newRec);
						}else if(res == 2){
							alert('이미 추천한 댓글입니다');
						}else if(res == 3){
							alert('본인의 댓글은 추천할수 없습니다');
						}
					},
				});
			}
		</script>
	<style>
		.bottombody{
			max-width: 992px;
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
			.phone{
				display: inline;
			}
		}
	</style>
	
	</head>
	<body>
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf"%>
		<header class="py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title">모임게시판</h1>
					<p class="lead fw-normal text-white-50 mb-0">Party Board</p>
				</div>
			</div>
		</header>
		<main>
			<div class="container-fluid bottombody">
				<hr class="my-4">

				<div class="subject">
					<b><%=subject%></b>
					<div class="mt-2" style="font-size: 16px; color: #888888;">
						<div class="dropdown">
							<a href="#" role="button" id="dropdownMenuLink" data-bs-toggle="dropdown"> <b><%=writer%></b>
							</a>
							<ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
								<li><a class="dropdown-item" href="/freeBoardList?select=3&search=<%=writer%>">게시글 보기</a></li>
								<li><a class="dropdown-item" href="/freeBoardList?">댓글 보기</a></li>
							</ul>
						</div>
						<span class="slash">|</span>
						<%=wdate%>&nbsp;&nbsp;
						<br class="phone" style="display: none;">
						<i class="fas fa-eye"></i>&nbsp;<%=hit%>&nbsp;&nbsp;
						<i class="fas fa-comment"></i>&nbsp;<%=cmtCnt%>&nbsp;&nbsp; 
						<i class="fas fa-thumbs-up"></i>&nbsp;<%=recCnt%>
					</div>
				</div>

				<hr class="my-4">

				<div class="content">
					<%=content%>
				</div>
				
				<div class="mt-5 pt-5 d-flex justify-content-center">
					<button id="recBtn" class="btn btn-primary">
						<i class="fas fa-thumbs-up"></i> 추천
					</button>
					<%= strApply %>
				</div>

				<b style="font-size: 20px;">댓글</b>
				<hr class="my-2">

				<!-- 댓글영역 -->
				<div id="cmtArea">
					<div id='comments'>
						<%=sbComments%>
					</div>
					
					<textarea id="cContent" name="cContent" class="form-control" rows="3" style="resize: none;"></textarea>
					<div class="text-lg-end" style="margin-top: 10px;">
						<button id="cmtWbtn" class="btn btn-secondary float-right">댓글쓰기</button>
					</div>
				</div>
			</div>
		</main>
		<footer></footer>
	</body>
</html>