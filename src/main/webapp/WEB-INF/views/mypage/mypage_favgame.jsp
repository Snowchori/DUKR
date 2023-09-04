<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	ArrayList<BoardgameTO> list = (ArrayList<BoardgameTO>)request.getAttribute("myfavBoardGame");
	
	//보드게임 목록 html
	StringBuilder boardhtml = new StringBuilder();
	for(BoardgameTO data : list) {
		
		boardhtml.append("<div class='col'>");
		boardhtml.append("<div class='card shadow-sm'>");
		boardhtml.append("<img class='card-img-top' width='100%' height='225' alt='Card image' src='"+data.getImageUrl()+"'></img>");
		boardhtml.append("<div class='card-body'>");
		boardhtml.append("<p class='card-text'>"+data.getTitle()+"</p>");
		boardhtml.append("<div class='d-flex justify-content-between align-items-center'>");
		boardhtml.append("<div class='btn-group'>");
		boardhtml.append("<button type='button' class='btn btn-sm btn-outline-secondary' onclick='location.href=\"gameView?seq=" + data.getSeq() + "\"'>게임 정보 보기</button>");
		boardhtml.append("<button type='button' class='btn btn-sm btn-outline-secondary' onclick='location.href=\"freeBoardList?select=4&search="+data.getTitle()+"\"'>관련 글 보기</button>");
		boardhtml.append("<button type='button' class='btn btn-sm btn-outline-secondary' onclick='updateFav("+data.getSeq()+",1)'>즐겨찾기 해제</button>");
		boardhtml.append("</div></div></div></div></div>");
		
	}
%>
<!doctype html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
		<!-- 자바 스크립트 영역 -->
		<script type="text/javascript">
			function updateFav(seq, isFav) {
				$.ajax({
					url:'gameFavoriteWriteOk',
					 type:'post',
					data: {
						seq: seq,
						isFav: isFav
					},
					success: function(data) {
						if(data == 0) {
							Swal.fire({
								icon: 'success',
								title: '추천해제 완료',
								confirmButtonText: '확인',
								timer : 1500,
								timerProgressBar : true,
								willClose: () => {
								location.href='/favgame';
								}
							});
						} else {
							Swal.fire({
								icon: 'error',
								title: '에러',
								timer : 1500,
								timerProgressBar : true,
								confirmButtonText: '확인'
							});
						}
					}
				});
			}
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
		<header class="top-margin py-5 backg-secondary">
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
			<div class="album py-5 bg-body-tertiary">
				<div class="container">
					<div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
					
						<%=boardhtml %>
						
					</div>
				</div>
			</div>
		</main>
		<footer>
	    	<!-- 최하단 디자인 영역 -->
		</footer>
	</body>
</html>