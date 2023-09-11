<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	MemberTO to = (MemberTO)request.getAttribute("to");
	String seq = to.getSeq();
%>
<!DOCTYPE html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
		<script type="text/javascript">
		  	window.onload = function(){
		  		document.getElementById("new_pwd_btn").onclick = function(){
		  			if(document.new_pwd_frm.new_pwd1.value.trim() == ""){
		  				Swal.fire("새로운 비밀번호를 입력하세요");
		  				return false;
		  			}
		  			if(document.new_pwd_frm.new_pwd1.value.trim() != document.new_pwd_frm.new_pwd2.value.trim()){
		  				Swal.fire("비밀번호가 일치하지 않습니다");
		  				return false;
		  			}
		  			$.ajax({
			  			url:'newPwdOk',
			  			type:'post',
			  			data: {
			  				seq: document.new_pwd_frm.seq.value,
			  				new_pwd1: document.new_pwd_frm.new_pwd1.value.trim()
			  			},
			  			success: function(data) {
				  			if(data == 0) {
					  			Swal.fire({
						  			icon: 'success',
						  			title: '비밀번호 변경 완료',
						  			confirmButtonText: '확인',
						  			willClose: () => {
						  				location.href='/login';
					  				}
				  				})
				  			} else {
					  			Swal.fire({
						  			icon: 'error',
						  			title: '비밀번호 변경 실패',
						  			confirmButtonText: '확인'
					  			})
				  			}
				  		}
				  	});		
		  		};
		  	};
		</script>
		<link href="assets/css/style.css" rel="stylesheet">
	</head>
	<body>
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="top-margin py-5 backg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title">비밀번호 변경</h1>
					<p class="lead fw-normal text-white-50 mb-0">Change Password</p>
				</div>
			</div>
		</header>
		<main>
			<!-- 비밀번호 변경 -->
			<div class="row justify-content-center align-items-center" style="margin-top: 50px">
				<div class="col-md-6 border p-3">
					<!-- 아이디 찾기 -->
					<strong>비밀번호 변경</strong>
					<br><br>
					<form action="newPwdOk" method="post" name="new_pwd_frm">
						<input type="hidden" value=<%=seq %> name="seq"/>
						<input class="form-control" type="password" name="new_pwd1"
							placeholder="새로운 비밀번호" /><br>
						<input class="form-control" type="password" name="new_pwd2"
							placeholder="비밀번호 확인" /><br>
						<span class="input-group-btn">
							<button class="btn btn-dark" id="new_pwd_btn" type="button">
								비밀번호 변경
							</button>
						</span>
					</form>
				</div>
			</div>
		</main>
	</body>
</html>