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
				<!-- 
				<table class="table">
					<tr>
						<td onClick="location.href='/mypage'" >회원 정보 변경</td>
						<td onClick="location.href='/mywrite'">내가 쓴 글</td>
						<td onClick="location.href='/mycomment'">내가 쓴 댓글</td>
						<td onClick="location.href='/favwrite'">좋아요 한 글</td>
					</tr>
					<tr>
						<td onClick="location.href='/favgame'">즐겨찾기 한 게임</td>
						<td onClick="location.href='/mail'">쪽지함</td>
						<td onClick="location.href='/admin'">문의하기</td>
						<td onClick="location.href='/myparty'">참여신청한 모임</td>
					</tr>
				</table>
				 -->
				<div class="row py-5 mapframe">
					<div id="map" class="col mb-3 border border-5" style="width:1000px;height:600px;">
						<div id="roadviewControl" data-bs-toggle="modal" data-bs-target="#myModal"></div>
					</div>
					<div id="map-side" class="col-lg-4 align-self-center">
						<form action="" class="row">
							<div class="mb-3 col-sm-6 col-lg-12">
								<label for="dosel" class="form-label">도(시)</label>
								<select id="dosel" name="dosel" class="form-select" disabled>
									<option value="0">전국</option>
								</select>
							</div>
							<div class="mb-3 col-sm-6 col-lg-12">
								<label for="sisel" class="form-label">시/군(구)</label>
								<select id="sisel" name="sisel" class="form-select" disabled>
									<option value="0">전체</option>
								</select>
							</div>
						</form>
						<div class="d-flex">
							<button class="btn btn-primary" id="rbtn"><i class='bi bi-arrow-clockwise'></i></button>&nbsp;
							<input type="button" class="btn btn-primary" id="sbtn" value="검색" style="width: 100%" disabled/>
						</div>
					</div>
				</div>
			</div>
			<!-- 버튼 디자인 -->
	  		<!-- 마이페이지 정보페이지 디자인 -->
		</main>
		<footer>
	    	<!-- 최하단 디자인 영역 -->
		</footer>
	</body>
</html>