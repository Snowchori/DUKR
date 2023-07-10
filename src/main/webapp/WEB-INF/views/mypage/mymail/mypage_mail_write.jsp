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
			<div class="container-fluid mt-5 pt-5 d-flex justify-content-center bottombody">
				<div class="container d-flex justify-content-around bg-light rounded-5 formframe">
					<form action="" class="row" style="width: 100%;" method="post">
						<div class="col-md-6 mb-3">
							<label for="subject" class="form-label">제목</label>
							<input type="text" class="form-control" placeholder="제목을 입력하세요" name="subject" id="subject"/>
						</div>
						<div class="col-md-6 mb-3">
							<label for="content" class="form-label">유저 닉네임</label>
							<input type="text" class="form-control" placeholder="닉네임을 입력하세요" name="subject" id="nickname"/>
						</div>
						<div class="col-12 mb-3">
							<label for="content" class="form-label">내용</label>
							<textarea
								class="form-control"
								name="content"
								id="content"
								rows="15"
								placeholder="내용을 입력하세요"
								style="resize: none;"
							></textarea>
						</div>
						<div class="col-12 mb-3">
							<input type="button" class="btn btn-primary float-end" value="전송" onclick=""/>
						</div>
					</form>
				</div>
			</div>
		</main>
		<footer>
	    	<!-- 최하단 디자인 영역 -->
		</footer>
	</body>
</html>