<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
		<!-- 자바 스크립트 영역 -->
		<script type="text/javascript">
		function adminWrite(){
			$.ajax({
				url: "adminWriteOK",
                   type: "post",
                   data: {
                       subject : $('#subject').val(),
                       content : $('#content').val(),
                       inquiryType : $('#inquirySelect').val()
                   },
				success : function(data) {
					//0 성공 / 1 오류 및 실패
					if(data == 0) {
						Swal.fire({
                            title : '문의 작성 성공',
                            text  : '최대한 빠른시간안에 답변드겠습니다 감사합니다',
                            icon  : 'success',
                            showCancelButton : false,
                            confirmButtonText : '확인',
                            timer : 1500,
                            timerProgressBar : true,
                            willClose : () => {
                            	window.location.href = '/admin';
                            }
                        });
					} else {
						Swal.fire({
                            title : '문의 작성 실패',
                            text  : '문의 작성에 실패하였습니다',
                            icon  : 'error',
                            showCancelButton : false,
                            confirmButtonText : '확인',
                            timer : 1500,
                            timerProgressBar : true,
                            willClose : () => {
                                window.location.href = '/admin';
                            }
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
		<header class="mt-5 py-5 bg-secondary">
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
			<div class="container-fluid mt-5 pt-5 d-flex justify-content-center bottombody">
				<div class="container d-flex justify-content-around bg-light rounded-5 formframe">
					<form action="" class="row" style="width: 100%;" method="post">
						<div class="col-md-6 mb-3">
							<label for="subject" class="form-label">문의 제목</label>
							<input type="text" class="form-control" placeholder="제목을 입력하세요" name="subject" id="subject"/>
						</div>
						<div class="col-md-6 mb-3">
							<label for="content" class="form-label">문의 사항</label>
							<select class="form-select" id="inquirySelect">
								<option value="신고">신고</option>
								<option value="건의">건의</option>
								<option value="버그제보">버그제보</option>
							</select>
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
							<input type="button" class="btn btn-dark float-end" value="전송" onclick="adminWrite()"/>
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