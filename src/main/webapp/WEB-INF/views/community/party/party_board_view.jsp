<%@page import="org.springframework.beans.factory.annotation.Autowired"%>
<%@page import="com.example.model.comment.CommentDAO"%>
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
	String comments = (String)request.getAttribute("comments");
%>
<%
int status = (int)request.getAttribute("status");
String strApply = "";
boolean isWriter = true;

if(!memSeq.equals(userSeq)){
	strApply = "&nbsp;<button id='appBtn' class='btn btn-success'><i id='appIcon' class='bi bi-patch-check'></i>&nbsp;<span id='appText'>참여신청</span></button>";
	isWriter = false;
}

boolean didUserRec = (boolean)request.getAttribute("didUserRec");
String recBtnColor = "btn-dark";
if(didUserRec){
	recBtnColor = "btn-primary";
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
				
				// 글 추천하기
				document.getElementById("recBtn").onclick = function() {
					$.ajax({
						url : '/rec',
						type : 'post',
						data : {
							boardSeq: bseq,
							userSeq: useq,
							isWriter: isWriter
						},
						success : function(result) {
							const res = (result % 10);
							const updatedRecCnt = Math.floor(result / 10);
							
							if(res == 2){
								alert('먼저 로그인 해야합니다');
							}else if(res == 3){
								$('#viewRecCnt').html(updatedRecCnt);
								$('#recBtn').removeClass('btn-primary').addClass('btn-dark');

								alert('게시글 추천을 취소했습니다');
							}else if(res == 0){
								alert('알 수 없는 추천 오류');
							}else{
								$('#viewRecCnt').html(updatedRecCnt);
								$('#recBtn').removeClass('btn-dark').addClass('btn-primary');

								alert('글을 추천했습니다');
							}
						}
					});
				};
		
				// 댓글쓰기
				document.getElementById("cmtWbtn").onclick = function() {
					$.ajax({
						url : '/freeboardCommentWrite',
						type : 'post',
						data : {
							boardSeq : bseq,
							memSeq : useq,
							content : document.getElementById("cContent").value,
						},
						success : function(res) {
							if (res != "") {
								$('#comments').html(res);
								$('#cContent').val('');
								
								let numberOfComments = res.split("<span class='dropdown'").length - 1;
								$('#viewCmtCnt').html(numberOfComments);	
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
						boardSeq: <%=boardSeq %>
					},
					success: function(result){
						const res = parseInt(result.substring(0, 1));
						const updatedComments = result.substring(1);

						if(res == 0){
							alert('먼저 로그인 해야합니다');
						}else if(res == 1){
							$('#comments').html(updatedComments);
						}else if(res == 2){
							$('#comments').html(updatedComments);
						}
					},
				});
			}
			
			// 댓글 삭제함수
			function deleteComment(cSeq){
				$.ajax({
					url: "/commentDelete",
					type: "POST", 
					data: {
						boardSeq: <%=boardSeq %>,
						commentSeq: cSeq,
						userSeq: <%=userSeq %>
					},
					success: function(res){
						$('#comments').html(res);
						
						let numberOfComments = res.split("<span class='dropdown'").length - 1;
						$('#viewCmtCnt').html(numberOfComments);
					}
				});
			}
			
			// 댓글 수정함수
			function modifyComment(cSeq){
				const cmtId = 'cmtContent' + cSeq;
				let curContent = $('#' + cmtId).html();
				let options = 'cmtOptions' + cSeq;
				
				$('#' + options).html('<button class="btn float-end" onclick="modifyCommentOk(' + cSeq + ')"><i class="far fa-check-circle"></i></button>');
				$('#' + cmtId).html('<textArea id="modifiedCmt' + cSeq + '" class="form-control" rows="3" style="resize: none;">' + curContent + '</textArea>');
			}
			
			// 댓글 수정완료함수
			function modifyCommentOk(cmtSeq){
				const cmtId = 'modifiedCmt' + cmtSeq;
				const modifiedContent = $('#' + cmtId).val();
				//console.log(modifiedContent);
				$.ajax({
					url: '/modifyComment',
					type: 'POST',
					data: {
						cSeq: cmtSeq,
						userSeq: <%=userSeq %>,
						boardSeq: <%=boardSeq %>,
						content: modifiedContent
					},
					success: function(result){
						$('#comments').html(result);
					}
				});
			}
			
			// 신고
			function report(seq, type){
				if(<%=userSeq%> == null){
					alert('먼저 로그인 해야합니다');
				}else{
					let url = '/report?targetType=' + type + '&seq=' + seq;
					const pageName = 'DUKR - report';
					// 팝업 위치설정
					const screenWidth = window.screen.width;
					const screenHeight = window.screen.height;
					const popupLeft = (screenWidth / 2) - 300;
					const popupTop = (screenHeight / 2) - 400;
					const spec = 'width=600, height=800, left=' + popupLeft + ', top=' + popupTop;
					
					let popup = window.open(url, pageName, spec);
					
					if(!popup) {
						alert('팝업이 차단되었습니다. 팝업 차단을 해제해주세요');
		            }
				} 
			}
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
					<div class="subject_info mt-2" style="color: #888888;">
						<div class="main_info">
							<div class="dropdown">
								<a href="#" role="button" id="dropdownMenuLink" data-bs-toggle="dropdown"> <b><%=writer%></b>
								</a>
								<ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
									<li><a class="dropdown-item" href="/partyBoardList?select=3&search=<%=writer%>">게시글 보기</a></li>
									<li><a class="dropdown-item" href="/partyBoardList?">댓글 보기</a></li>
								</ul>
							</div>
							<span class="slash">|</span>
							<%=wdate%>
						</div>
						<div class="extra_info">
							<i class="fas fa-eye"></i>&nbsp;<%=hit%>&nbsp;&nbsp;
							<i class="fas fa-comment"></i>
							<span id='viewCmtCnt'><%=cmtCnt%></span>&nbsp;&nbsp; 
							<i class="fas fa-thumbs-up"></i>
							<span id='viewRecCnt'><%=recCnt%></span>
						</div>
					</div>
				</div>

				<hr class="my-4">

				<div class="content">
					<%=content%>
				</div>
				
				<div class="mt-5 pt-5 d-flex justify-content-center">
					<button id="recBtn" class="btn <%=recBtnColor %>">
						<i class="fas fa-thumbs-up"></i> 추천
					</button>
					<%= strApply %>
				</div>
				
				<div class="d-flex">
					<button class="btn btn-dark" style="margin-right: auto;" onclick="location.href='partyBoardList?cpage='">목록</button>
					
					<div class="d-flex">
						<%if(isWriter){ %>	
						<button class="btn btn-dark mx-3" style="margin-left: auto;" onclick='freeBoardDelete("<%=boardSeq%>")'>삭제</button>											
						<button class="btn btn-dark" style="margin-left: auto;" onclick="location.href='partyBoardModify?seq=<%=boardSeq %>'">수정</button>				
						<%}else{%>
						<button class="btn btn-dark mx-3" style="margin-left: auto;" onclick='report("<%=boardSeq%>", "board")'>신고</button>
						<%} %>
					</div>
				</div>
				<hr class="my-2">

				<b style="font-size: 20px;">댓글</b>

				<!-- 댓글영역 -->
				<div class="mt-2 mb-3" id="cmtArea">
					<div id="comments">
						<%=comments%>
					</div>
					
					<textarea id="cContent" name="cContent" class="form-control" rows="3" style="resize: none;"></textarea>
					<div class="d-flex" style="margin-top: 10px;">
						<button id="cmtWbtn" class="btn btn-dark" style="margin-left: auto;">댓글쓰기</button>
					</div>
				</div>
			</div>
		</main>
		<footer></footer>
	</body>
</html>