<%@page import="com.example.model.report.ReportTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	ArrayList<ReportTO> report_list = (ArrayList)request.getAttribute("report_list");

	StringBuilder rpHtml = new StringBuilder();
	
	for(ReportTO to: report_list) {
		rpHtml.append("<div class='accordion-item ");
		if(to.getStatus() == 0) {
			rpHtml.append("uncheck");			
		} else {
			rpHtml.append("complete");
		}
		rpHtml.append("'>");
		rpHtml.append("<h2 class='accordion-header' id='flush-heading" + to.getSeq() + "'>");
		rpHtml.append("<button class='accordion-button collapsed' type='button' data-bs-toggle='collapse' data-bs-target='#flush-collapse" + to.getSeq() + "' aria-expanded='false' aria-controls='flush-collapse" + to.getSeq() + "'>");
		if(to.getStatus() == 0) {
			rpHtml.append("[미확인] ");			
		} else {
			rpHtml.append("[처리완료] ");
		}
		rpHtml.append("게시글신고 - " + to.getWriter());
		rpHtml.append("</button>");
		rpHtml.append("</h2>");
		rpHtml.append("<div id='flush-collapse" + to.getSeq() + "' class='accordion-collapse collapse' aria-labelledby='flush-heading" + to.getSeq() + "' data-bs-parent='#accordionFlushExample'>");
		rpHtml.append("<div class='accordion-body'>");
		rpHtml.append("<form action='' class='row' style='width: 100%;' method='post' name='nfrm" + to.getSeq() + "'>");
		if(to.getStatus() == 0) {
			if(!to.isBoardDel()) {
				rpHtml.append("<div class='col-md-3 mb-3'>");
				rpHtml.append("<input type='button' class='btn btn-dark' value='게시글보기'  onclick=\"location.href='boardView?seq=" + to.getBoardSeq() + "'\"/>");
				rpHtml.append("</div>");
			}
		} else {
			rpHtml.append("<div class='col-md-3 mb-3'>");
			rpHtml.append("<label for='subject' class='form-label'>처리</label>");
			rpHtml.append("<input type='text' class='form-control' name='inquiryType' id='inquiryType' readonly='readonly' value='" + to.getProcessType() + "'/>");
			rpHtml.append("</div>");
		}
		rpHtml.append("<div class='col-md-3 mb-3 ms-auto'>");
		rpHtml.append("<label for='content' class='form-label'>보낸 시간</label>");
		rpHtml.append("<input type='text' class='form-control' name='wdate' id='wdate' readonly='readonly' value='" + to.getRdate() + "' />");
		rpHtml.append("</div>");
		rpHtml.append("<div class='col-12 mb-3'>");
		rpHtml.append("<label for='content' class='form-label'>내용</label>");
		rpHtml.append("<textarea ");
		rpHtml.append("class='form-control' ");
		rpHtml.append("name='content' ");
		rpHtml.append("id='content' ");
		rpHtml.append("rows='10' ");
		rpHtml.append("style='resize: none;' ");
		rpHtml.append("readonly='readonly' ");
		rpHtml.append(">" + to.getContent() + "</textarea>");
		rpHtml.append("</div>");
		rpHtml.append("<div class='col-12 mb-3'>");
		rpHtml.append("<label for='content' class='form-label'>답변</label>");
		rpHtml.append("<textarea ");
		rpHtml.append("class='form-control' ");
		rpHtml.append("name='answer' ");
		rpHtml.append("id='answer" + to.getSeq() + "' ");
		rpHtml.append("rows='10' ");
		if(to.getStatus() == 0) {
			rpHtml.append("placeholder='답변을 입력하세요' ");			
		} else {
			rpHtml.append("readonly='readonly' ");
		}
		rpHtml.append("style='resize: none;' ");
		rpHtml.append(">");
		if(to.getStatus() == 1) {
			rpHtml.append(to.getAnswer());			
		} else if(to.isBoardDel()) {
			rpHtml.append("이미 삭제된 게시글입니다.");
		}
		rpHtml.append("</textarea>");
		rpHtml.append("</div>");
		if(to.getStatus() == 0) {
			rpHtml.append("<div class='col-12 mb-3'>");
			rpHtml.append("<input type='button' class='btn btn-dark float-end mx-2' value='답변' onclick='insertAnswer(");
			rpHtml.append(to.getSeq() + ", " + to.getMemSeq());
			rpHtml.append(")'/>");
			if(!to.isBoardDel()) {
				rpHtml.append("<input type='button' class='btn btn-dark float-end mx-2' value='게시글삭제' onclick='deleteBoard(");
				rpHtml.append(to.getSeq() + ", " + to.getMemSeq() + ", " + to.getBoardSeq());
				rpHtml.append(")'/>");
				rpHtml.append("<input type='button' class='btn btn-dark float-end mx-2' value='ip밴' onclick='ipBan(");
				rpHtml.append(to.getSeq() + ", " + to.getMemSeq() + ", " + to.getBoardSeq());
				rpHtml.append(")'/>");
			}
			rpHtml.append("</div>");
		}
		rpHtml.append("</form>");
		rpHtml.append("</div>");
		rpHtml.append("</div>");
		rpHtml.append("</div>");
	}
%>
<!doctype html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
		<!-- Template Main CSS File -->
		<link href="assets/css/style.css" rel="stylesheet">
		<!-- 자바 스크립트 영역 -->
		<script type="text/javascript" >
			function totalData() {
				$('.uncheck').show();
				$('.complete').show();
			}
			
			function uncheckData() {
				$('.uncheck').show();
				$('.complete').hide();
			}
			
			function completeData() {
				$('.uncheck').hide();
				$('.complete').show();
			}
			
			function insertAnswer(seq, senderSeq) {
				let answer = $('#answer' + seq).val();
				if(answer == "") {
					Swal.fire({
			  			icon: 'error',
			  			title: '답변을 입력하세요.',
			  			confirmButtonText: '확인',
			  			timer: 1500,
			  			timerProgressBar : true
		  			});
				} else {
					$.ajax({
			  			url:'reportAnswerWriteOk',
			  			type:'post',
			  			data: {
			  				seq: seq,
			  				answer: answer,
			  				senderSeq: senderSeq
			  			},
			  			success: function(data) {
				  			if(data == 0) {
					  			Swal.fire({
						  			icon: 'success',
						  			title: '답변 완료',
						  			confirmButtonText: '확인',
						  			timer: 1500,
						  			timerProgressBar : true,
						  			willClose: () => {
						  				location.href='reportList';
					  				}
				  				});
				  			} else {
					  			Swal.fire({
						  			icon: 'error',
						  			title: '답변 실패',
						  			confirmButtonText: '확인',
						  			timer: 1500,
						  			timerProgressBar : true
					  			});
				  			}
				  		}
				  	});
				}
			}
			
			function deleteBoard(seq, senderSeq, boardSeq) {
				let answer = $('#answer' + seq).val();
				if(answer == "") {
					Swal.fire({
			  			icon: 'error',
			  			title: '답변을 입력하세요.',
			  			confirmButtonText: '확인',
			  			timer: 1500,
			  			timerProgressBar : true
		  			});
				} else {
					Swal.fire({
						title: '게시글만 삭제합니다',
						showDenyButton: true,
						confirmButtonText: '네',
						denyButtonText: `아니오`,
					}).then((result) => {
						if (result.isConfirmed) {
							$.ajax({
					  			url:'deleteBoardOk',
					  			type:'post',
					  			data: {
					  				seq: seq,
					  				senderSeq: senderSeq,
					  				answer: answer,
					  				boardSeq: boardSeq
					  			},
					  			success: function(data) {
						  			if(data == 0) {
							  			Swal.fire({
								  			icon: 'success',
								  			title: '삭제 완료',
								  			confirmButtonText: '확인',
								  			timer: 1500,
								  			timerProgressBar : true,
								  			willClose: () => {
								  				location.href='reportList';
							  				}
						  				});
						  			} else {
							  			Swal.fire({
								  			icon: 'error',
								  			title: '삭제 실패',
								  			confirmButtonText: '확인',
								  			timer: 1500,
								  			timerProgressBar : true,
							  			});
						  			}
						  		}
						  	});
						}
					})
				}
			}
			
			function ipBan(seq, senderSeq, boardSeq) {
				let answer = $('#answer' + seq).val();
				if(answer == "") {
					Swal.fire({
			  			icon: 'error',
			  			title: '답변을 입력하세요.',
			  			confirmButtonText: '확인',
			  			timer: 1500,
			  			timerProgressBar : true
		  			});
				} else {
					Swal.fire({
						title: '게시글을 삭제하고 게시글의 ip를 밴합니다.',
						showDenyButton: true,
						confirmButtonText: '네',
						denyButtonText: `아니오`,
					}).then((result) => {
						if (result.isConfirmed) {
							$.ajax({
					  			url:'ipBanOk',
					  			type:'post',
					  			data: {
					  				seq: seq,
					  				senderSeq: senderSeq,
					  				answer: answer,
					  				boardSeq: boardSeq
					  			},
					  			success: function(data) {
						  			if(data == 0) {
							  			Swal.fire({
								  			icon: 'success',
								  			title: '삭제&ip밴 완료',
								  			confirmButtonText: '확인',
								  			timer: 1500,
								  			timerProgressBar : true,
								  			willClose: () => {
								  				location.href='reportList';
							  				}
						  				});
						  			} else {
							  			Swal.fire({
								  			icon: 'error',
								  			title: '삭제&ip밴 실패',
								  			confirmButtonText: '확인',
								  			timer: 1500,
								  			timerProgressBar : true,
							  			});
						  			}
						  		}
						  	});
						}
					})
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
					<h1 class="title">신고글 목록</h1>
					<p class="lead fw-normal text-white-50 mb-0">Report List</p>
				</div>
			</div>
		</header>
		<main>
			<!-- ======= about Section ======= -->
			<section id="about" class="about p-3 mb-2">
				<div class="row m-3 p-4 bg-white text-black rounded-5">
					<div class="container" data-aos="fade-up">
						<div class="row g-4 g-lg-5" data-aos="fade-up" data-aos-delay="200">
							<div class="col-lg-12">
								<!-- Tabs -->
								<ul class="nav nav-pills mb-3">
									<li><a class="nav-link active" data-bs-toggle="pill" onclick='totalData()'>전체</a></li>
									<li><a class="nav-link" data-bs-toggle="pill" onclick='uncheckData()'>미확인</a></li>
									<li><a class="nav-link" data-bs-toggle="pill" onclick='completeData()'>처리완료</a></li>
								</ul>
								<!-- End Tabs -->
								<!-- Tab Content -->
								<div class="tab-content">
									<div class="tab-pane fade show active">
										<div class="accordion accordion-flush" id="accordionFlushExample">
											<%= rpHtml %>
										</div>
									</div>
									<!-- End Tab 1 Content -->
								</div>
							</div>
						</div>
					</div>
				</div>
			</section>
			<!-- End about Section -->
		</main>
		<footer>
			<!-- 최하단 디자인 영역 -->
		</footer>
	</body>
</html>