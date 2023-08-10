<%@page import="com.example.model.board.BanTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	ArrayList<BanTO> ban_list = (ArrayList)request.getAttribute("ban_list");

	StringBuilder bHtml = new StringBuilder();

	if(ban_list.size() > 0) {
		bHtml.append("<div class='row p-3 justify-content-between'>");
		bHtml.append("<div class='col-3'>");
		bHtml.append("<h3>밴 IP</h3>");
		bHtml.append("</div>");
		bHtml.append("<div class='col-3'>");
		bHtml.append("<h3>밴 날짜</h3>");
		bHtml.append("</div>");
		bHtml.append("<div class='col-3'>");
		bHtml.append("</div>");
		bHtml.append("</div>");
		for(BanTO to: ban_list) {
			bHtml.append("<div class='row p-3 justify-content-between'>");
			bHtml.append("<div class='col-3'>");
			bHtml.append(to.getBip());
			bHtml.append("</div>");
			bHtml.append("<div class='col-3'>");
			bHtml.append(to.getBdate());
			bHtml.append("</div>");
			bHtml.append("<div class='col-3'>");
			bHtml.append("<button type='button' class='btn btn-dark' onclick='deleteBan(");
			bHtml.append(to.getSeq());
			bHtml.append(")'>해제</button>");
			bHtml.append("</div>");
			bHtml.append("</div>");
		}
	} else {
		bHtml.append("<div class='col'>");
		bHtml.append("현재 밴 IP가 없습니다.");
		bHtml.append("</div>");
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
			function deleteBan(seq) {
				Swal.fire({
					title: '해제하시겠습니까?',
					showDenyButton: true,
					confirmButtonText: '네',
					denyButtonText: `아니오`,
				}).then((result) => {
					if (result.isConfirmed) {
						$.ajax({
				  			url:'banDeleteOk',
				  			type:'post',
				  			data: {
				  				seq: seq
				  			},
				  			success: function(data) {
					  			if(data == 0) {
						  			Swal.fire({
							  			icon: 'success',
							  			title: '해제 완료',
							  			confirmButtonText: '확인',
							  			timer: 1500,
							  			timerProgressBar : true,
							  			willClose: () => {
							  				location.href='banUserManage';
						  				}
					  				});
					  			} else {
						  			Swal.fire({
							  			icon: 'error',
							  			title: '해제 실패',
							  			confirmButtonText: '확인',
							  			timer: 1500,
							  			timerProgressBar : true
						  			});
					  			}
					  		}
					  	});
					}
				})
			}
		</script>
	</head>
	<body class="bg-secondary text-white">
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="mt-5 py-5 bg-secondary">
			<div class="container-fluid px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title"><span class="hover" onclick="location.href='banUserManage'">밴유저 관리</span></h1>
					<p class="lead fw-normal text-white-50 mb-0">Ban User Manage</p>
				</div>
			</div>
		</header>
		<main>
			<!-- ======= gameInfo Section ======= -->
			<section id="gameInfo" class="gameInfo p-3 mb-2">
				<div class="container-fluid bottombody_manage">
					<div class="row m-3 p-4 bg-white text-black rounded-5">
						<%= bHtml %>
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