<%@page import="com.example.model.inquiry.InquiryListTO"%>
<%@page import="com.example.model.inquiry.InquiryTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	InquiryListTO listTO = (InquiryListTO)request.getAttribute("listTO");
	
	int cpage = listTO.getCpage();
	int totalRecode = listTO.getTotalRecord();
	int recordPerPage = listTO.getRecordPerPage();
	int totalRecord = listTO.getTotalRecord();
	
	int totalPage = listTO.getTotalPage();
	
	int blockPerPage = listTO.getBlockPerPage();
	int startBlock = listTO.getStartBlock();
	int endBlock = listTO.getEndBlock();
	
	StringBuilder navHtml = new StringBuilder();
	
	navHtml.append("<li><a class='nav-link ");
	if(listTO.getStatus().equals("")) {
		navHtml.append("active");		
	}
	navHtml.append("' data-bs-toggle='pill' onclick='location.href=\"inquiryManage?status=\"'>전체</a></li>");
	
	navHtml.append("<li><a class='nav-link ");
	if(listTO.getStatus().equals("0")) {
		navHtml.append("active");		
	}	
	navHtml.append("' data-bs-toggle='pill' onclick='location.href=\"inquiryManage?status=0\"'>미확인</a></li>");
	
	navHtml.append("<li><a class='nav-link ");
	if(listTO.getStatus().equals("1")) {
		navHtml.append("active");		
	}	
	navHtml.append("' data-bs-toggle='pill' onclick='location.href=\"inquiryManage?status=1\"'>처리완료</a></li>");

	StringBuilder iqHtml = new StringBuilder();
	
	for(InquiryTO to: listTO.getInquiryLists()) {
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
	
	StringBuilder pageHtml = new StringBuilder();
	String searchCondition = "&status=" + listTO.getStatus();
	
	if (startBlock != 1) {
		pageHtml.append("<li class='page-item'>");
		pageHtml.append("<a href='inquiryManage?cpage=");
		pageHtml.append(startBlock - blockPerPage);
		pageHtml.append("&recordPerPage=" + recordPerPage + searchCondition + "' ");
		pageHtml.append("class='page-link' aria-label='Previous'>");
		pageHtml.append("<span aria-hidden='true'>«</span>");
		pageHtml.append("</a>");
		pageHtml.append("</li>");
	}
	
	for(int i=startBlock; i<=endBlock; i++) {
		if(i == cpage) {
			pageHtml.append("<li class='page-item active'><a class='page-link'>" + i + "</a></li>");
		} else {
			pageHtml.append("<li class='page-item'><a class='page-link' href='");
			pageHtml.append("inquiryManage?cpage=" + i);
			pageHtml.append("&recordPerPage=" + recordPerPage + searchCondition + "' ");
			pageHtml.append(">" + i + "</a></li>");
		}
	}
	
	if(endBlock != totalPage) {
		pageHtml.append("<li class='page-item'>");
		pageHtml.append("<a href='inquiryManage?cpage=");
		pageHtml.append(startBlock + blockPerPage);
		pageHtml.append("&recordPerPage=" + recordPerPage + searchCondition + "' ");
		pageHtml.append("class='page-link' aria-label='Next'>");
		pageHtml.append("<span aria-hidden='true'>»</span>");
		pageHtml.append("</a>");
		pageHtml.append("</li>");
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
	</head>
	<body class="backg-quinary text-white">
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="top-margin py-5 backg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title"><span class="hover" onclick="location.href='inquiryManage'">문의 관리</span></h1>
					<p class="lead fw-normal text-white-50 mb-0">Inquiry Manage</p>
				</div>
			</div>
		</header>
		<main>
			<!-- ======= about Section ======= -->
			<section id="about" class="about p-3 mb-2">
				<div class="container-fluid bottombody_manage">
					<div class="row m-3 p-4 bg-white text-black rounded-5">
						<div class="container" data-aos="fade-up">
							<div class="row g-4 g-lg-5" data-aos="fade-up" data-aos-delay="200">
								<div class="col-lg-12">
									<!-- Tabs -->
									<ul class="nav nav-pills mb-3">
										<%= navHtml %>
									</ul>
									<!-- End Tabs -->
									<!-- Tab Content -->
									<div class="tab-content">
										<div class="mt-3 p-2">
											총 <%= totalRecord %>건
										</div>
										<div class="tab-pane fade show active">
											<div class="accordion accordion-flush" id="accordionFlushExample">
												<%= iqHtml %>
											</div>
										</div>
										<!-- End Tab 1 Content -->
										<div class="container p-2">
											<nav class="pagination-outer" aria-label="Page navigation">
												<ul class="pagination">
													<%= pageHtml %>
												</ul>
											</nav>
										</div>
									</div>
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