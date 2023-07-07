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
			<!-- Tabs -->
			<div class="container">
				<ul class="nav nav-pills mb-3">
	                <li><a class="nav-link active" data-bs-toggle="pill" href="#tab1">받은 쪽지함</a></li>
	                <li><a class="nav-link" data-bs-toggle="pill" href="#tab2">보낸 쪽지함</a></li>
	                <li class="ms-auto"><a class="btn btn-secondary"onclick="func1()">쪽지 삭제</a></li>
	                <li class="ms-2"><a class="btn btn-secondary" onclick="location.href='/mailWrite'">쪽지 보내기</a></li>
	            </ul>
				<!-- End Tabs -->
				<!-- Tab Content -->
				<div class="tab-content">
					<div class="tab-pane fade show active" id="tab1">
						<table class="table">
							<tr>
								<td>
									<div class="form-check">
										<input class="form-check-input" type="checkbox">
										<label class="form-check-label" onclick="location.href='/mailGetview?seq=1'">보낸사람 : 제목</label>
									</div>
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
					<!-- End Tab 1 Content -->
					<div class="tab-pane fade show" id="tab2">
						<table class="table">
							<tr>
								<td>
									<div class="form-check">
										<input class="form-check-input" type="checkbox">
										<label class="form-check-label" onclick="location.href='/mailSendview?seq=2'">받은사람 : 제목</label>
									</div>
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
					<!-- End Tab 2 Content -->
				</div>
			</div>
		</main>
		<footer>
	    	<!-- 최하단 디자인 영역 -->
		</footer>
	</body>
</html>