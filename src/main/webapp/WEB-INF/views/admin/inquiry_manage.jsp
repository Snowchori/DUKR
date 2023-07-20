<%@page import="com.example.model.inquiry.InquiryTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	ArrayList<InquiryTO> inquiry_list = (ArrayList)request.getAttribute("inquiry_list");

	StringBuilder iqHtml = new StringBuilder();
	
	for(InquiryTO to: inquiry_list) {
		iqHtml.append("<div>");
		iqHtml.append("seq : " + to.getSeq() + "<br>");
		iqHtml.append("senderSeq : " + to.getSenderSeq() + "<br>");
		iqHtml.append("writer : " + to.getWriter() + "<br>");
		iqHtml.append("wdate : " + to.getWdate() + "<br>");
		iqHtml.append("subject : " + to.getSubject() + "<br>");
		iqHtml.append("content : " + to.getContent() + "<br>");
		iqHtml.append("status : " + to.getStatus() + "<br>");
		iqHtml.append("inquiryType : " + to.getInquiryType() + "<br>");
		iqHtml.append("<div>");
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
				$('.check').show();
				$('.complete').show();
			}
			
			function uncheckData() {
				$('.uncheck').show();
				$('.check').hide();
				$('.complete').hide();
			}
						
			function checkData() {
				$('.uncheck').hide();
				$('.check').show();
				$('.complete').hide();
			}
			
			function completeData() {
				$('.uncheck').hide();
				$('.check').hide();
				$('.complete').show();
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
									<li><a class="nav-link" data-bs-toggle="pill" onclick='checkData()'>확인</a></li>
									<li><a class="nav-link" data-bs-toggle="pill" onclick='completeData()'>답변완료</a></li>
								</ul>
								<!-- End Tabs -->
								<!-- Tab Content -->
								<div class="tab-content">
									<div class="tab-pane fade show active">
										<div class="accordion accordion-flush" id="accordionFlushExample">
										  <div class="accordion-item uncheck">
										    <h2 class="accordion-header" id="flush-headingOne">
										      <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapseOne" aria-expanded="false" aria-controls="flush-collapseOne">
										        [미확인] 제목 - 닉네임
										      </button>
										    </h2>
										    <div id="flush-collapseOne" class="accordion-collapse collapse" aria-labelledby="flush-headingOne" data-bs-parent="#accordionFlushExample">
										      <div class="accordion-body">
										      	<form action="" class="row" style="width: 100%;" method="post" name="nfrm">
													<div class="col-md-3 mb-3">
														<label for="subject" class="form-label">문의타입</label>
														<input type="text" class="form-control" name="inquiryType" id="inquiryType" readonly="readonly"/>
													</div>
													<div class="col-md-3 mb-3 ms-auto">
														<label for="content" class="form-label">보낸 시간</label>
														<input type="text" class="form-control" name="wdate" id="wdate" readonly="readonly"/>
													</div>
													<div class="col-12 mb-3">
														<label for="content" class="form-label">내용</label>
														<textarea
															class="form-control"
															name="content"
															id="content"
															rows="10"
															style="resize: none;"
															readonly="readonly"
														></textarea>
													</div>
													<div class="col-12 mb-3">
														<label for="content" class="form-label">답변</label>
														<textarea
															class="form-control"
															name="answer"
															id="answer"
															rows="10"
															placeholder="답변을 입력하세요"
															style="resize: none;"
														></textarea>
													</div>
													<div class="col-12 mb-3">
														<input id="nbtn" type="button" class="btn btn-dark float-end" value="전송"/>
													</div>
												</form>
										      </div>
										    </div>
										  </div>
										  <div class="accordion-item check">
										    <h2 class="accordion-header" id="flush-headingTwo">
										      <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapseTwo" aria-expanded="false" aria-controls="flush-collapseTwo">
										        [확인] 제목 - 닉네임
										      </button>
										    </h2>
										    <div id="flush-collapseTwo" class="accordion-collapse collapse" aria-labelledby="flush-headingTwo" data-bs-parent="#accordionFlushExample">
										      <div class="accordion-body">
										      	<form action="" class="row" style="width: 100%;" method="post" name="nfrm">
													<div class="col-md-3 mb-3">
														<label for="subject" class="form-label">문의타입</label>
														<input type="text" class="form-control" name="inquiryType" id="inquiryType" readonly="readonly"/>
													</div>
													<div class="col-md-3 mb-3 ms-auto">
														<label for="content" class="form-label">보낸 시간</label>
														<input type="text" class="form-control" name="wdate" id="wdate" readonly="readonly"/>
													</div>
													<div class="col-12 mb-3">
														<label for="content" class="form-label">내용</label>
														<textarea
															class="form-control"
															name="content"
															id="content"
															rows="10"
															style="resize: none;"
															readonly="readonly"
														></textarea>
													</div>
													<div class="col-12 mb-3">
														<label for="content" class="form-label">답변</label>
														<textarea
															class="form-control"
															name="answer"
															id="answer"
															rows="10"
															placeholder="답변을 입력하세요"
															style="resize: none;"
														></textarea>
													</div>
													<div class="col-12 mb-3">
														<input id="nbtn" type="button" class="btn btn-dark float-end" value="전송"/>
													</div>
												</form>
										      </div>
										    </div>
										  </div>
										  <div class="accordion-item complete">
										    <h2 class="accordion-header" id="flush-headingThree">
										      <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#flush-collapseThree" aria-expanded="false" aria-controls="flush-collapseThree">
										        [답변완료] 제목 - 닉네임
										      </button>
										    </h2>
										    <div id="flush-collapseThree" class="accordion-collapse collapse" aria-labelledby="flush-headingThree" data-bs-parent="#accordionFlushExample">
										      <div class="accordion-body">
										      	<form action="" class="row" style="width: 100%;" method="post" name="nfrm">
													<div class="col-md-3 mb-3">
														<label for="subject" class="form-label">문의타입</label>
														<input type="text" class="form-control" name="inquiryType" id="inquiryType" readonly="readonly"/>
													</div>
													<div class="col-md-3 mb-3 ms-auto">
														<label for="content" class="form-label">보낸 시간</label>
														<input type="text" class="form-control" name="wdate" id="wdate" readonly="readonly"/>
													</div>
													<div class="col-12 mb-3">
														<label for="content" class="form-label">내용</label>
														<textarea
															class="form-control"
															name="content"
															id="content"
															rows="10"
															style="resize: none;"
															readonly="readonly"
														></textarea>
													</div>
													<div class="col-12 mb-3">
														<label for="content" class="form-label">답변</label>
														<textarea
															class="form-control"
															name="answer"
															id="answer"
															rows="10"
															style="resize: none;"
															readonly="readonly"
														></textarea>
													</div>
												</form>
										      </div>
										    </div>
										  </div>
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