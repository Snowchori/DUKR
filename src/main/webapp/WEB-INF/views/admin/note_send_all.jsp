<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<!doctype html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
		<!-- Template Main CSS File -->
		<link href="assets/css/style.css" rel="stylesheet">
		<!-- 자바 스크립트 영역 -->
		<script type="text/javascript" >
			window.onload = function() {
				document.getElementById('nbtn').onclick = function() {
					if(document.nfrm.subject.value.trim() == "") {
						Swal.fire({
							icon: 'error',
							title: '제목을 입력하세요.',
							showConfirmButton: false,
							timer: 1500
						})
					} else if (document.nfrm.content.value.trim() == "") {
						Swal.fire({
							icon: 'error',
							title: '내용을 입력하세요.',
							showConfirmButton: false,
							timer: 1500
						})
					} else {
						$.ajax({
				  			url:'noteSendAllOk',
				  			type:'post',
				  			data: {
				  				seq: '<%= userSeq %>',
				  				subject: document.nfrm.subject.value.trim(),
				  				content: document.nfrm.content.value.trim()
				  			},
				  			success: function(data) {
					  			if(data == 0) {
						  			Swal.fire({
							  			icon: 'success',
							  			title: '전송 완료',
							  			confirmButtonText: '확인',
							  			timer: 1500,
							  			timerProgressBar : true,
							  			willClose: () => {
							  				location.href='noteSendAll';
						  				}
					  				});
					  			} else {
						  			Swal.fire({
							  			icon: 'error',
							  			title: '전송 실패',
							  			confirmButtonText: '확인',
							  			timer: 1500,
							  			timerProgressBar : true
						  			});
					  			}
					  		}
					  	});
					}
				}
			}
		</script>
		<style>
		
		</style>
	</head>
	<body class="bg-secondary text-white">
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title">전제 쪽지 보내기</h1>
					<p class="lead fw-normal text-white-50 mb-0">Send Premise Note</p>
				</div>
			</div>
		</header>
		<main>
			<!-- ======= gameInfo Section ======= -->
			<section id="gameInfo" class="gameInfo p-3 mb-2">
				<div class="container-fluid d-flex justify-content-center bottombody">
					<div class="container d-flex justify-content-around bg-light rounded-5 formframe">
						<form action="" class="row" style="width: 100%;" method="post" name="nfrm">
							<div class="col-md-12 mb-3">
								<label for="subject" class="form-label">제목</label>
								<input type="text" class="form-control" placeholder="제목을 입력하세요" name="subject" id="subject"/>
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
								<input id="nbtn" type="button" class="btn btn-dark float-end" value="전송"/>
							</div>
						</form>
					</div>
				</div>
			</section>
			<!-- End gameInfo Section -->
		</main>
		<footer>
			<!-- 최하단 디자인 영역 -->
		</footer>
	</body>
</html>