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
			<div class="container mt-3 text-center">
				<table class="table table-bordered">
					<thead>
						<tr>
							<td onClick="location.href='/mypage'" >회원 정보 변경</td>
							<td onClick="location.href='/mywrite'">내가 쓴 글</td>
							<td onClick="location.href='/mycomment'">내가 쓴 댓글</td>
							<td onClick="location.href='/favwrite'">좋아요 한 글</td>
						</tr>
					</thead>
					<tbody>	
						<tr>
							<td onClick="location.href='/favgame'">즐겨찾기 한 게임</td>
							<td onClick="location.href='/mail'">쪽지함</td>
							<td onClick="location.href='/admin'">문의하기</td>
							<td onClick="location.href='/myparty'">참여신청한 모임</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 버튼 디자인 -->
		  	<!-- 마이페이지 정보페이지 디자인 -->
			<div class="container mt-3">
				<table class="table">
					<tr>
						<th></th><th>내가 쓴글</th>
					</tr>
					<tr>
						<td style="width: 10px;"><i class="bi bi-card-image h1" onclick="location.href='#'"></i></td>
						<td onclick="location.href='#'">&nbsp&nbsp<span class="badge bg-secondary">카탄</span>&nbsp&nbsp 카탄 너무 재미있네요</br>
							<small>&nbsp&nbsp&nbsp&nbsp 카탄매니아유저 &nbsp&nbsp&nbsp <i class="bi bi-eye-fill"></i>130 &nbsp <i class="bi bi-hand-thumbs-up-fill"></i>5</small>
						</td>
					</tr>
					<tr>
						<td style="width: 10px;"><i class="bi bi-file-earmark-excel h1" onclick="location.href='#'"></i></td>
						<td onclick="location.href='#'">&nbsp&nbsp<span class="badge bg-secondary">카탄</span>&nbsp&nbsp 카탄 너무 재미있네요</br>
							<small>&nbsp&nbsp&nbsp&nbsp 카탄매니아유저 &nbsp&nbsp&nbsp <i class="bi bi-eye-fill"></i>130 &nbsp <i class="bi bi-hand-thumbs-up-fill"></i>5</small>
						</td>
					</tr>
					<tr>
						<td style="width: 10px;"><i class="bi bi-card-image h1" onclick="location.href='#'"></i></td>
						<td onclick="location.href='#'">&nbsp&nbsp<span class="badge bg-secondary">카탄</span>&nbsp&nbsp 카탄 너무 재미있네요</br>
							<small>&nbsp&nbsp&nbsp&nbsp 카탄매니아유저 &nbsp&nbsp&nbsp <i class="bi bi-eye-fill"></i>130 &nbsp <i class="bi bi-hand-thumbs-up-fill"></i>5</small>
						</td>
					</tr>
					<tr>
						<td style="width: 10px;"><i class="bi bi-card-image h1" onclick="location.href='#'"></i></td>
						<td onclick="location.href='#'">&nbsp&nbsp<span class="badge bg-secondary">카탄</span>&nbsp&nbsp 카탄 너무 재미있네요</br>
							<small>&nbsp&nbsp&nbsp&nbsp 카탄매니아유저 &nbsp&nbsp&nbsp <i class="bi bi-eye-fill"></i>130 &nbsp <i class="bi bi-hand-thumbs-up-fill"></i>5</small>
						</td>
					</tr>
					<tr>
						<td style="width: 10px;"><i class="bi bi-card-image h1" onclick="location.href='#'"></i></td>
						<td onclick="location.href='#'">&nbsp&nbsp<span class="badge bg-secondary">카탄</span>&nbsp&nbsp 카탄 너무 재미있네요</br>
							<small>&nbsp&nbsp&nbsp&nbsp 카탄매니아유저 &nbsp&nbsp&nbsp <i class="bi bi-eye-fill"></i>130 &nbsp <i class="bi bi-hand-thumbs-up-fill"></i>5</small>
						</td>
					</tr>
					<tr>
						<td style="width: 10px;"><i class="bi bi-card-image h1" onclick="location.href='#'"></i></td>
						<td onclick="location.href='#'">&nbsp&nbsp<span class="badge bg-secondary">카탄</span>&nbsp&nbsp 카탄 너무 재미있네요</br>
							<small>&nbsp&nbsp&nbsp&nbsp 카탄매니아유저 &nbsp&nbsp&nbsp <i class="bi bi-eye-fill"></i>130 &nbsp <i class="bi bi-hand-thumbs-up-fill"></i>5</small>
						</td>
					</tr>
					<tr>
						<td style="width: 10px;"><i class="bi bi-card-image h1" onclick="location.href='#'"></i></td>
						<td onclick="location.href='#'">&nbsp&nbsp<span class="badge bg-secondary">카탄</span>&nbsp&nbsp 카탄 너무 재미있네요</br>
							<small>&nbsp&nbsp&nbsp&nbsp 카탄매니아유저 &nbsp&nbsp&nbsp <i class="bi bi-eye-fill"></i>130 &nbsp <i class="bi bi-hand-thumbs-up-fill"></i>5</small>
						</td>
					</tr>
					<tr>
						<td style="width: 10px;"><i class="bi bi-card-image h1" onclick="location.href='#'"></i></td>
						<td onclick="location.href='#'">&nbsp&nbsp<span class="badge bg-secondary">카탄</span>&nbsp&nbsp 카탄 너무 재미있네요</br>
							<small>&nbsp&nbsp&nbsp&nbsp 카탄매니아유저 &nbsp&nbsp&nbsp <i class="bi bi-eye-fill"></i>130 &nbsp <i class="bi bi-hand-thumbs-up-fill"></i>5</small>
						</td>
					</tr>
					<tr>
						<td style="width: 10px;"><i class="bi bi-card-image h1" onclick="location.href='#'"></i></td>
						<td onclick="location.href='#'">&nbsp&nbsp<span class="badge bg-secondary">카탄</span>&nbsp&nbsp 카탄 너무 재미있네요</br>
							<small>&nbsp&nbsp&nbsp&nbsp 카탄매니아유저 &nbsp&nbsp&nbsp <i class="bi bi-eye-fill"></i>130 &nbsp <i class="bi bi-hand-thumbs-up-fill"></i>5</small>
						</td>
					</tr>
					<tr>
						<td style="width: 10px;"><i class="bi bi-card-image h1" onclick="location.href='#'"></i></td>
						<td onclick="location.href='#'">&nbsp&nbsp<span class="badge bg-secondary">카탄</span>&nbsp&nbsp 카탄 너무 재미있네요</br>
							<small>&nbsp&nbsp&nbsp&nbsp 카탄매니아유저 &nbsp&nbsp&nbsp <i class="bi bi-eye-fill"></i>130 &nbsp <i class="bi bi-hand-thumbs-up-fill"></i>5</small>
						</td>
					</tr>
				</table>
			</div>
			<div class="container text-center">
				<ul class="pagination justify-content-center">
					<li class="page-item"><a class="page-link" href="#">Previous</a></li>
					<li class="page-item"><a class="page-link" href="#">1</a></li>
					<li class="page-item"><a class="page-link" href="#">2</a></li>
					<li class="page-item"><a class="page-link" href="#">3</a></li>
					<li class="page-item"><a class="page-link" href="#">Next</a></li>
				</ul>
			</div>
	  	</main>
		<footer>
	    	<!-- 최하단 디자인 영역 -->
		</footer>
	</body>
</html>