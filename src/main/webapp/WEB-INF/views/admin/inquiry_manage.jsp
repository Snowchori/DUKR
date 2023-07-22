<%@page import="com.example.model.inquiry.InquiryTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	ArrayList<InquiryTO> inquiry_list = (ArrayList)request.getAttribute("inquiry_list");

	StringBuilder iqHtml = new StringBuilder();
	
	for(InquiryTO to: inquiry_list) {
		iqHtml.append("<div class='accordion-item ");
		if(to.getStatus() == 0) {
			iqHtml.append("uncheck");	
		} else {
			iqHtml.append("complete");
		}
		iqHtml.append("'>");
		iqHtml.append("<h2 class='accordion-header' id='flush-heading" + to.getSeq() + "'>");
		iqHtml.append("<button class='accordion-button collapsed' type='button' data-bs-toggle='collapse' data-bs-target='#flush-collapse" + to.getSeq() + "' aria-expanded='false' aria-controls='flush-collapse" + to.getSeq() + "'>");
		if(to.getStatus() == 0) {
			iqHtml.append("[미확인] ");	
		} else {
			iqHtml.append("[답변완료] ");
		}
		iqHtml.append(to.getSubject());
		iqHtml.append(" - ");
		iqHtml.append(to.getWriter());
		iqHtml.append("</button>");
		iqHtml.append("</h2>");
		iqHtml.append("<div id='flush-collapse" + to.getSeq() + "' class='accordion-collapse collapse' aria-labelledby='flush-heading" + to.getSeq() + "' data-bs-parent='#accordionFlushExample'>");
		iqHtml.append("<div class='accordion-body'>");
		iqHtml.append("<form action='' class='row' style='width: 100%;' method='post' name='nfrm" + to.getSeq() + "'>");
		iqHtml.append("<div class='col-md-3 mb-3'>");
		iqHtml.append("<label for='subject' class='form-label'>문의타입</label>");
		iqHtml.append("<input type='text' class='form-control' name='inquiryType' id='inquiryType' readonly='readonly' value='" + to.getInquiryType() + "'/>");
		iqHtml.append("</div>");
		iqHtml.append("<div class='col-md-3 mb-3 ms-auto'>");
		iqHtml.append("<label for='content' class='form-label'>보낸 시간</label>");
		iqHtml.append("<input type='text' class='form-control' name='wdate' id='wdate' readonly='readonly' value='" + to.getWdate() + "' />");
		iqHtml.append("</div>");
		iqHtml.append("<div class='col-12 mb-3'>");
		iqHtml.append("<label for='content' class='form-label'>내용</label>");
		iqHtml.append("<textarea ");
		iqHtml.append("class='form-control' ");
		iqHtml.append("name='content' ");
		iqHtml.append("id='content' ");
		iqHtml.append("rows='10' ");
		iqHtml.append("style='resize: none;' ");
		iqHtml.append("readonly='readonly' ");
		iqHtml.append(">" + to.getContent() + "</textarea>");
		iqHtml.append("</div>");
		iqHtml.append("<div class='col-12 mb-3'>");
		iqHtml.append("<label for='content' class='form-label'>답변</label>");
		iqHtml.append("<textarea ");
		iqHtml.append("class='form-control' ");
		iqHtml.append("name='answer' ");
		iqHtml.append("id='answer" + to.getSeq() + "' ");
		iqHtml.append("rows='10' ");
		if(to.getStatus() == 0) {
			iqHtml.append("placeholder='답변을 입력하세요' ");	
		} else {
			iqHtml.append("readonly='readonly' ");
		}
		iqHtml.append("style='resize: none;' ");
		iqHtml.append(">");
		if(to.getStatus() == 1) {
			iqHtml.append(to.getAnswer());	
		}
		iqHtml.append("</textarea>");
		iqHtml.append("</div>");
		if(to.getStatus() == 0) {
			iqHtml.append("<div class='col-12 mb-3'>");
			iqHtml.append("<input type='button' class='btn btn-dark float-end' value='답변' onclick='insertAnswer(");
			iqHtml.append(to.getSeq() + ", " + to.getSenderSeq());
			iqHtml.append(")'/>");
			iqHtml.append("</div>");
		}
		iqHtml.append("</form>");
		iqHtml.append("</div>");
		iqHtml.append("</div>");
		iqHtml.append("</div>");
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
			  			url:'inquiryAnswerWriteOk',
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
						  				location.href='inquiryManage';
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
		</script>
		<style>
		
		</style>
	</head>
	<body class="bg-secondary text-white">
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title">문의 관리</h1>
					<p class="lead fw-normal text-white-50 mb-0">Inquiry Manage</p>
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
									<li><a class="nav-link" data-bs-toggle="pill" onclick='completeData()'>답변완료</a></li>
								</ul>
								<!-- End Tabs -->
								<!-- Tab Content -->
								<div class="tab-content">
									<div class="tab-pane fade show active">
										<div class="accordion accordion-flush" id="accordionFlushExample">
											<%= iqHtml %>
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