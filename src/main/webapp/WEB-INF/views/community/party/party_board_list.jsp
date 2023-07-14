<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf"%>
<!doctype html>
<html>
	<head>
	
		<%@ include file="/WEB-INF/views/include/head_setting.jspf"%>
		<!-- Template Main CSS File -->
		<link href="assets/css/style.css" rel="stylesheet">
		<!-- 자바 스크립트 영역 -->
		<script type="text/javascript">
		</script>
		
		<style>
			@font-face {
				font-family: 'SBAggroB';
				src:
					url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2108@1.1/SBAggroB.woff')
					format('woff');
				font-weight: normal;
				font-style: normal;
			}
			
			.title {
				font-family: SBAggroB;
			}
			
			a {
				text-decoration: none;
			}
			
			main, footer {
				max-width: 1920px;
			}
		</style>
	
	</head>
	
	<body class="bg-light">
	
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf"%>
		<header class="py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title">모임게시판</h1>
					<p class="lead fw-normal text-white-50">Parties Board</p>
				</div>
			</div>
		</header>
	
		<main class="container-fluid d-flex justify-content-center">
			<div class="container d-flex justify-content-center row bottombody">
				<div class="col-12 mt-3 p-2">
						총 0건
						<button type='button' class='btn btn-dark float-end' data-bs-toggle="modal" data-bs-target="#searchModal" id="wbtn"><i class="bi bi-search"></i></button>
					</div>
				<div class="col-12 mt-3 p-2 row boardlist">
					<table class="table">
						<tr onclick='location.href="#"'>
							<td class='board-img'><i class='bi bi-card-image h1 icon'></i></td>
							<td><span class='badge bg-secondary'>카탄</span>&nbsp; 제목 [1]<br>
								<small>작성자&nbsp;2023.07.05&nbsp; <i
									class='bi bi-eye-fill icon'></i>3&nbsp; <i
									class='bi bi-hand-thumbs-up-fill icon'></i>5
							</small></td>
						</tr>
					</table>
				</div>
				<div class="col-12 p-2">
					<button type='button' class='btn btn-dark float-end' id="wbtn" onclick="location.href='partyBoardRegister'">글쓰기</button>
				</div>
			</div>
			<div class="modal fade" id="searchModal">
				<div class="modal-dialog modal-sm">
					<div class="modal-content">
						<div class="modal-body">
							<div class="modalHead text-center">
								<h4><i class="bi bi-search"></i> Search</h4>
							</div>
							<form action="" id="sfrm" name="sfrm" method="get" class="form mt-3">
								<!-- 게시판 타입 hidden 입력 -->
								<input type="hidden" name="btype" value="">
								<select name="stype" id="stype" class="form-select mb-3">
									<option value="1">제목</option>
									<option value="2">내용</option>
									<option value="3">제목+내용</option>
									<option value="4">작성자</option>
									<option value="5">태그</option>
								</select>
								<input type="text" name="sword" id="sword" class="form-control mb-3" maxlength="20" placeholder="검색어">
								<div class="col-12 btn-group btn-group ">
									<button type="submit" class="btn btn-danger"><i class="bi bi-check"></i></button>
									<button type="button" class="btn btn-dark" data-bs-dismiss="modal"><i class="bi bi-x"></i></button>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</main>
		<footer class="container-fluid bg-light">
			<div class="container demo p-2 pb-5">
				<nav class="pagination-outer" aria-label="Page navigation">
					<ul class="pagination">
						<li class="page-item"><a href="#" class="page-link"
							aria-label="Previous"> <span aria-hidden="true">«</span>
						</a></li>
						<li class="page-item"><a class="page-link" href="#">1</a></li>
						<li class="page-item"><a class="page-link" href="#">2</a></li>
						<li class="page-item active"><a class="page-link" href="#">3</a></li>
						<li class="page-item"><a class="page-link" href="#">4</a></li>
						<li class="page-item"><a class="page-link" href="#">5</a></li>
						<li class="page-item"><a href="#" class="page-link"
							aria-label="Next"> <span aria-hidden="true">»</span>
						</a></li>
					</ul>
				</nav>
			</div>
		</footer>
		
	</body>
</html>