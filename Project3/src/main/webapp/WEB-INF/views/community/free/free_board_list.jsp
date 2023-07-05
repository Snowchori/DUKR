<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<!doctype html>
<html>

<!-- java 영역 -->

<head>
  <!-- 페이지 제목 -->
  <title>DUKrule?</title>

  <!-- Required meta tags -->
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

  <!-- Bootstrap CSS v5.2.1 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
    integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.6.0/font/bootstrap-icons.css" />

  <!-- Bootstrap JavaScript Libraries -->
  <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
  integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3" crossorigin="anonymous">
  </script>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.min.js"
  integrity="sha384-7VPbUDkoPSGFnVtYi0QogXtr74QeVeeIs99Qfg5YCF+TidwNdjvaKZX19NZ/e6oz" crossorigin="anonymous">
  </script>
  
  <!-- default styles -->
	<link href="https://cdn.jsdelivr.net/gh/kartik-v/bootstrap-star-rating@4.1.2/css/star-rating.min.css" media="all" rel="stylesheet" type="text/css" />

	<!-- with v4.1.0 Krajee SVG theme is used as default (and must be loaded as below) - include any of the other theme CSS files as mentioned below (and change the theme property of the plugin) -->
	<link href="https://cdn.jsdelivr.net/gh/kartik-v/bootstrap-star-rating@4.1.2/themes/krajee-svg/theme.css" media="all" rel="stylesheet" type="text/css" />

	<!-- important mandatory libraries -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://cdn.jsdelivr.net/gh/kartik-v/bootstrap-star-rating@4.1.2/js/star-rating.min.js" type="text/javascript"></script>

	<!-- with v4.1.0 Krajee SVG theme is used as default (and must be loaded as below) - include any of the other theme JS files as mentioned below (and change the theme property of the plugin) -->
	<script src="https://cdn.jsdelivr.net/gh/kartik-v/bootstrap-star-rating@4.1.2/themes/krajee-svg/theme.js"></script>

	<!-- optionally if you need translation for your language then include locale file as mentioned below (replace LANG.js with your own locale file) -->
	<script src="https://cdn.jsdelivr.net/gh/kartik-v/bootstrap-star-rating@4.1.2/js/locales/LANG.js"></script>
  
    <!-- Template Main CSS File -->
  <link href="assets/css/style.css" rel="stylesheet">

  <!-- 자바 스크립트 영역 -->
  <script type="text/javascript" >
  
  </script>
  <style>

  </style>

</head>

<body>
<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
  <header class="py-5 bg-secondary">
		<div class="container px-4 px-lg-5 my-5">
			<div class="text-center text-white">
				<h1 class="title">자유게시판</h1>
			</div>
		</div>
	</header>
  <main>
  
  <div class="row mx-5 mu-5 p-2">
	<table class="table">
		<tr onclick='location.href="#"'>
			<td class='board-img'><i class='bi bi-card-image h1 icon'></i></td>
			<td><span class='badge bg-secondary'>카탄</span>&nbsp;
			제목 [1]<br><small>작성자&nbsp;2023.07.05&nbsp;
			<i class='bi bi-eye-fill icon'></i>3&nbsp;
			<i class='bi bi-hand-thumbs-up-fill icon'></i>5</small>
			</td>
		</tr>
		<tr onclick='location.href="#"'>
			<td class='board-img'><i class='bi bi-file-earmark-excel h1 icon'></i></td>
			<td><span class='badge bg-secondary'>카탄</span>&nbsp;
			제목 [1]<br><small>작성자&nbsp;2023.07.05&nbsp;
			<i class='bi bi-eye-fill icon'></i>3&nbsp;
			<i class='bi bi-hand-thumbs-up-fill icon'></i>5</small>
			</td>
		</tr>
		<tr onclick='location.href="#"'>
			<td class='board-img'><i class='bi bi-card-image h1 icon'></i></td>
			<td><span class='badge bg-secondary'>카탄</span>&nbsp;
			제목 [1]<br><small>작성자&nbsp;2023.07.05&nbsp;
			<i class='bi bi-eye-fill icon'></i>3&nbsp;
			<i class='bi bi-hand-thumbs-up-fill icon'></i>5</small>
			</td>
		</tr>
		<tr onclick='location.href="#"'>
			<td class='board-img'><i class='bi bi-file-earmark-excel h1 icon'></i></td>
			<td><span class='badge bg-secondary'>카탄</span>&nbsp;
			제목 [1]<br><small>작성자&nbsp;2023.07.05&nbsp;
			<i class='bi bi-eye-fill icon'></i>3&nbsp;
			<i class='bi bi-hand-thumbs-up-fill icon'></i>5</small>
			</td>
		</tr>
		<tr onclick='location.href="#"'>
			<td class='board-img'><i class='bi bi-card-image h1 icon'></i></td>
			<td><span class='badge bg-secondary'>카탄</span>&nbsp;
			제목 [1]<br><small>작성자&nbsp;2023.07.05&nbsp;
			<i class='bi bi-eye-fill icon'></i>3&nbsp;
			<i class='bi bi-hand-thumbs-up-fill icon'></i>5</small>
			</td>
		</tr>
		<tr onclick='location.href="#"'>
			<td class='board-img'><i class='bi bi-file-earmark-excel h1 icon'></i></td>
			<td><span class='badge bg-secondary'>카탄</span>&nbsp;
			제목 [1]<br><small>작성자&nbsp;2023.07.05&nbsp;
			<i class='bi bi-eye-fill icon'></i>3&nbsp;
			<i class='bi bi-hand-thumbs-up-fill icon'></i>5</small>
			</td>
		</tr>
	</table>
	</div>
	<div class="row mx-5 p-2 d-flex flex-row-reverse">
		<div class="col-lg-3 text-end">
			<button type='button' class='btn btn-dark' id="wbtn">글쓰기</button>
		</div>
	</div>
  </main>
  <footer>
    <div class="demo mx-5 p-2">
    <nav class="pagination-outer" aria-label="Page navigation">
        <ul class="pagination">
            <li class="page-item">
                <a href="#" class="page-link" aria-label="Previous">
                    <span aria-hidden="true">«</span>
                </a>
            </li>
            <li class="page-item"><a class="page-link" href="#">1</a></li>
            <li class="page-item"><a class="page-link" href="#">2</a></li>
            <li class="page-item active"><a class="page-link" href="#">3</a></li>
            <li class="page-item"><a class="page-link" href="#">4</a></li>
            <li class="page-item"><a class="page-link" href="#">5</a></li>
            <li class="page-item">
                <a href="#" class="page-link" aria-label="Next">
                    <span aria-hidden="true">»</span>
                </a>
            </li>
        </ul>
    </nav>
</div>
  </footer>
</body>

</html>