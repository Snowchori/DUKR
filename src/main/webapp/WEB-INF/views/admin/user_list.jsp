<%@page import="com.example.model.member.MemberListTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	MemberListTO listTO = (MemberListTO)request.getAttribute("listTO");
	
	int cpage = listTO.getCpage();
	int totalRecode = listTO.getTotalRecord();
	int recordPerPage = listTO.getRecordPerPage();
	int totalRecord = listTO.getTotalRecord();
	
	int totalPage = listTO.getTotalPage();
	
	int blockPerPage = listTO.getBlockPerPage();
	int startBlock = listTO.getStartBlock();
	int endBlock = listTO.getEndBlock();
	
	StringBuilder userHtml = new StringBuilder();
	
	if(listTO.getMemberLists().size() > 0) {
		userHtml.append("<div class='accordion accordion-flush' id='accordionFlushExample'>");
		for(MemberTO to: listTO.getMemberLists()) { 
			userHtml.append("<div class='accordion-item'>");
			userHtml.append("<h2 class='accordion-header' id='flush-heading" + to.getSeq() + "'>");
			userHtml.append("<button class='accordion-button collapsed' type='button' ");
			userHtml.append("data-bs-toggle='collapse' data-bs-target='#flush-collapse" + to.getSeq());
			userHtml.append("' aria-expanded='false' aria-controls='flush-collapse" + to.getSeq() + "'>");
			userHtml.append("닉네임 : " + to.getNickname());
			if(to.isAdmin()) {
				userHtml.append(" [관리자]");	
			}
			userHtml.append("</button>");
			userHtml.append("</h2>");
			userHtml.append("<div id='flush-collapse" + to.getSeq() + "' class='accordion-collapse collapse' ");
			userHtml.append("aria-labelledby='flush-heading" + to.getSeq() + "' data-bs-parent='#accordionFlushExample'>");
			userHtml.append("<div class='accordion-body'>");
			userHtml.append("<div class='row py-2'>");
			userHtml.append("<div class='col-3'>");
			userHtml.append("번호 : " + to.getSeq());
			userHtml.append("</div>");
			userHtml.append("<div class='col-3'>");
			userHtml.append("아이디 : " + to.getId());
			userHtml.append("</div>");
			userHtml.append("<div class='col-3'>");
			if(!to.isAdmin()){
				userHtml.append("<button type='button' class='btn btn-dark' onclick='changeNickname(");
				userHtml.append(to.getSeq() + ", \"" + to.getNickname() + "\"");
				userHtml.append(")'>닉네임 강제변경</button>");
			}
			userHtml.append("</div>");
			userHtml.append("</div>");
			userHtml.append("<div class='row py-2'>");
			userHtml.append("<div class='col-3'>");
			userHtml.append("이메일 : " + to.getEmail());
			userHtml.append("</div>");
			userHtml.append("<div class='col-3'>");
			userHtml.append("점수 : " + to.getRate());
			userHtml.append("</div>");
			userHtml.append("<div class='col-3'>");
			if(!to.isAdmin()){
				userHtml.append("<button type='button' class='btn btn-dark' onclick='deleteUser(");
				userHtml.append(to.getSeq());
				userHtml.append(")'>강제 회원탈퇴</button>");
			}
			userHtml.append("</div>");
			userHtml.append("</div>");
			userHtml.append("</div>");
			userHtml.append("</div>");
			userHtml.append("</div>");
		}
		userHtml.append("</div>");
	} else {
		userHtml.append("<div class='col'>");
		userHtml.append("현재 회원이 없습니다.");
		userHtml.append("</div>");
	}
	
	StringBuilder pageHtml = new StringBuilder();
	String searchCondition = "&keyWord=" + listTO.getKeyWord();
	
	if (startBlock != 1) {
		pageHtml.append("<li class='page-item'>");
		pageHtml.append("<a href='userList?cpage=");
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
			pageHtml.append("userList?cpage=" + i);
			pageHtml.append("&recordPerPage=" + recordPerPage + searchCondition + "' ");
			pageHtml.append(">" + i + "</a></li>");
		}
	}
	
	if(endBlock != totalPage) {
		pageHtml.append("<li class='page-item'>");
		pageHtml.append("<a href='userList?cpage=");
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
			function changeNickname(seq, nickname) {
				(async () => {
					const {value: getName} = await Swal.fire({
						title: '닉네임 변경',
						text: '현재 닉네임 : ' + nickname,
						input: 'text',
						inputAttributes: {
							autocapitalize: 'off'
						},
						inputPlaceholder: '새로운 닉네임',
						showDenyButton: true,
						confirmButtonText: '변경',
						denyButtonText: `취소`
					})
					
					if(getName) {
						$.ajax({
				  			url:'nicknameChangeOk',
				  			type:'post',
				  			data: {
				  				seq: seq,
				  				nickname: getName
				  			},
				  			success: function(data) {
					  			if(data == 0) {
						  			Swal.fire({
							  			icon: 'success',
							  			title: '변경 완료',
							  			confirmButtonText: '확인',
							  			timer: 1500,
							  			timerProgressBar : true,
							  			willClose: () => {
							  				location.href='userList';
						  				}
					  				});
					  			} else if (data == -1){
						  			Swal.fire({
							  			icon: 'error',
							  			title: '이미 존재하는 닉네임입니다.',
							  			confirmButtonText: '확인',
							  			timer: 1500,
							  			timerProgressBar : true
						  			});
					  			} else {
						  			Swal.fire({
							  			icon: 'error',
							  			title: '변경 실패',
							  			confirmButtonText: '확인',
							  			timer: 1500,
							  			timerProgressBar : true
						  			});
					  			}
					  		}
					  	});
					}
				})()
			}
			
			function deleteUser(seq) {
				Swal.fire({
					title: '강제탈퇴하시겠습니까?',
					showDenyButton: true,
					confirmButtonText: '네',
					denyButtonText: `아니오`,
				}).then((result) => {
					if (result.isConfirmed) {
						$.ajax({
				  			url:'userDeleteOk',
				  			type:'post',
				  			data: {
				  				seq: seq
				  			},
				  			success: function(data) {
					  			if(data == 0) {
						  			Swal.fire({
							  			icon: 'success',
							  			title: '강제탈퇴 완료',
							  			confirmButtonText: '확인',
							  			timer: 1500,
							  			timerProgressBar : true,
							  			willClose: () => {
							  				location.href='userList';
						  				}
					  				});
					  			} else {
						  			Swal.fire({
							  			icon: 'error',
							  			title: '강제탈퇴 실패',
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
			
			function search() {
				(async () => {
					const {value: getName} = await Swal.fire({
						title: '유저 검색',
						input: 'text',
						inputAttributes: {
							autocapitalize: 'off'
						},
						inputPlaceholder: '유저 닉네임',
						showDenyButton: true,
						confirmButtonText: '검색',
						denyButtonText: `취소`
					})
					
					location.href='userList?keyWord=' + getName;
					
				})()
			}
		</script>
	</head>
	<body class="bg-secondary text-white">
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title"><span class="hover" onclick="location.href='userList'">유저 목록</span></h1>
					<p class="lead fw-normal text-white-50 mb-0">User List</p>
				</div>
			</div>
		</header>
		<main>
			<!-- ======= gameInfo Section ======= -->
			<section id="gameInfo" class="gameInfo p-3 mb-2">
				<div class="row m-3 p-4 bg-white text-black rounded-5">
					<div class="mt-3 p-2">
						총 <%= totalRecord %>명
						<button type='button' class='btn btn-dark cbtn float-end' onclick='search()'><i class="bi bi-search"></i></button>
					</div>
					<%= userHtml %>
					<div class="container p-2">
						<nav class="pagination-outer" aria-label="Page navigation">
							<ul class="pagination">
								<%= pageHtml %>
							</ul>
						</nav>
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