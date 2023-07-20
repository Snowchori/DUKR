<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<!doctype html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
		<!-- 자바 스크립트 영역 -->
		<script type="text/javascript">
		</script>
		<style type="text/css">
			@font-face {
				font-family: 'SBAggroB';
				src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2108@1.1/SBAggroB.woff') format('woff');
				font-weight: normal;
				font-style: normal;
			}
			
			.title {
				font-family: SBAggroB;
			}
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
			<div class="container">
				<button type="button" class="btn btn-secondary" style="float: right" onclick="location.href='/adminWrite'">문의글 작성하기</button>
				<table class="table">
					<tr>
						<td style="width: 10px;"><i class="bi bi-check-square h1" onclick="location.href='/adminView?seq=1'"></i></i></td>
						<td onclick="location.href='/adminView?seq=1'">&nbsp&nbsp<span class="badge bg-secondary">신고</span>&nbsp&nbsp 신고글제목</br>
						 	<small>&nbsp&nbsp&nbsp&nbsp 신고자닉네임 &nbsp&nbsp 2023.06.30</small>
						</td>
					</tr>
					<tr>
						<td style="width: 10px;"><i class="bi bi-square h1" onclick="location.href='/adminView?seq=2'"></i></td>
						<td onclick="location.href='/adminView?seq=2'">&nbsp&nbsp<span class="badge bg-secondary">건의</span>&nbsp&nbsp 건의글제목</br>
							<small>&nbsp&nbsp&nbsp&nbsp 신고자닉네임 &nbsp&nbsp 2023.06.30</small>
						</td>
					</tr>
					<tr>
						<td style="width: 10px;"><i class="bi bi-square h1" onclick="location.href='/adminView?seq=3'"></i></td>
						<td onclick="location.href='/adminView?seq=3'">&nbsp&nbsp<span class="badge bg-secondary">버그제보</span>&nbsp&nbsp 버그제보글제목</br>
							<small>&nbsp&nbsp&nbsp&nbsp 신고자닉네임 &nbsp&nbsp 2023.06.30</small>
						</td>
					</tr>
				</table>
				<div class="container text-center">
					<ul class="pagination justify-content-center">
						<li class="page-item"><a class="page-link" href="#">Previous</a></li>
						<li class="page-item"><a class="page-link" href="#">1</a></li>
						<li class="page-item"><a class="page-link" href="#">2</a></li>
						<li class="page-item"><a class="page-link" href="#">3</a></li>
						<li class="page-item"><a class="page-link" href="#">Next</a></li>
					</ul>
				</div>
			</div>
		</main>
		<footer>
	    	<!-- 최하단 디자인 영역 -->
		</footer>
	</body>
</html>