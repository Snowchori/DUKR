<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	String nickname = (String)request.getAttribute("nickname");
	String email = (String)request.getAttribute("email");
	String id = (String)request.getAttribute("id");
	int userType = (int)request.getAttribute("userType");
	int rate = (int)request.getAttribute("rate");
%>

<!-- 소셜로그인 추가 -->

<!doctype html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<style>
	.swal2-popup {
		width: 700px !important;
	}
</style>
		
		<script type="text/javascript">
		    $(document).ready( function() {
		        //아이디 변경불가 alert
				$('#id').click(function () {
					Swal.fire({
						icon : 'error',
						title : '아이디는 변경 불가합니다',
						timer : 1500
					})
				});
		        const userType = <%=userType%>;
		        if(userType == 0) {
		            //아무작업도 하지않음
		        } else if (userType == 1) {
		            $('#snsImage').empty();
		            $('<i>소셜인증이 완료되었습니다</i>').appendTo('#snsImage');
		        } else {
		            $('#id').remove();
		            $('#idlabel').remove();
		            $('#password').remove();
		            $('#passwordlabel').remove();
		            $('#snsImage').empty();
		            $('<i>소셜인증이 완료되었습니다</i>').appendTo('#snsImage');
		            $('#userinfo').submit
		        }
		        //정보수정버튼 기능
		        $('#userinfo').submit(function(event) {
		            if(userType != 2) {
		                event.preventDefault(); // 폼 기본 제출 동작 막기
		                Swal.fire({
		                title: '회원정보 변경을 위해 비밀번호를 입력하세요',
		                html:
		                     '<div>비밀번호 변경을 원치않으시면 새로운 비밀번호란에</br> 기존 비밀번호를 입력해주세요</div>' +
		                     '<input type="password" id="swal-currentPassword" class="swal2-input" placeholder="기존 비밀번호">' +
		                     '<input type="password" id="swal-newPassword" class="swal2-input" placeholder="새로운 비밀번호">' +
		                     '<input type="password" id="swal-confirmPassword" class="swal2-input" placeholder="새로운 비밀번호 확인">',
		                showCancelButton: true,
		                confirmButtonText: '회원정보 변경',
		                cancelButtonText: '취소',
		                preConfirm: () => {
		                    const currentPassword = Swal.getPopup().querySelector('#swal-currentPassword').value;
		                    const newPassword = Swal.getPopup().querySelector('#swal-newPassword').value;
		                    const confirmPassword = Swal.getPopup().querySelector('#swal-confirmPassword').value;
		
		                       if (!currentPassword || !newPassword || !confirmPassword) {
		                        Swal.showValidationMessage('모든 필드를 입력해주세요');
		                       } else if (newPassword !== confirmPassword) {
		                        Swal.showValidationMessage('새로운 비밀번호가 일치하지 않습니다');
		                    }
		
		                    return {
		                        currentPassword: currentPassword,
		                        newPassword: newPassword,
		                        confirmPassword: confirmPassword
		                        };
		                    }
		                }).then((result) => {
		                    if (result.isConfirmed) {
		                        const { currentPassword, newPassword } = result.value;
		                            $('#password').val(currentPassword);
		                            $('#newpassword').val(newPassword);
		                            $('#userinfo').unbind('submit').submit(); // 폼 제출
		                      }
		                });
		            } else {
		                event.preventDefault(); // 폼 기본 제출 동작 막기
		                Swal.fire({
		                      title: '정말 변경하시겠습니까?',
		                      icon: 'question',
		                      showCancelButton: true,
		                      confirmButtonText: '확인',
		                      cancelButtonText: '취소'
		                }).then((result) => {
		                      if (result.isConfirmed) {
		                             $('#userinfo').unbind('submit').submit(); // 폼 제출
		                      }
		                });
		            }
		        });
		    });
		</script>
		<style type="text/css">	
			@font-face {
				font-family: 'SBAggroB';
				src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2108@1.1/SBAggroB.woff') format('woff');
				font-weight: normal;
				font-style: normal;
			}
			
			.title {
				font-family: SBAggroB;
			}
		</style>
	</head>
	<body>
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title">마이페이지</h1>
					<p class="lead fw-normal text-white-50 mb-0">MyPage</p>
				</div>
			</div>
		</header>
		<main>
	  		<!-- 버튼 디자인 -->
			<div class="container mt-3 text-center">
				<table class="table table-bordered">
					<thead>
						<tr>
							<td onClick="location.href='/mypage'" >회원 정보 변경</td>
							<td onClick="location.href='/mywrite'">내가 쓴 글</td>
							<td onClick="location.href='/mycomment'">내가 쓴 댓글</td>
							<td onClick="location.href='/favwrite'">좋아요 한 글</td>
						</tr>
					</thead>
					<tbody>	
						<tr>
							<td onClick="location.href='/favgame'">즐겨찾기 한 게임</td>
							<td onClick="location.href='/mail'">쪽지함</td>
							<td onClick="location.href='/admin'">문의하기</td>
							<td onClick="location.href='/myparty'">참여신청한 모임</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 버튼 디자인 -->
		  	<!-- 마이페이지 정보페이지 디자인 -->
			<div class="container mt-3" id="result">
				<div class="row">
					<div class="col-sm-6">
						<form action="/mypageEdit" name="userinfo" id="userinfo">
							<div class="mb-3 mt-3">
		    					<label class="form-label">닉네임:</label>
		   						<input type="text" class="form-control" id="nickname" name="nickname" value="<%=nickname%>"><br>
		    					<label class="form-label" id="idlabel">아이디:</label>
		   						<input type="text" class="form-control" id="id" name="id" value="<%=id%>" readonly="readonly"><br>
		    					<label class="form-label" id="passwordlabel">비밀번호:</label>
		   						<input type="text" class="form-control" id="password" name="password" value="" placeholder="비밀번호는 보이지 않습니다" readonly="readonly"><br>
		    					<label class="form-label">이메일:</label>
		   						<input type="email" class="form-control" id="email" name="email" value="<%=email%>"><br>
		   						<button type="submit" id="infoUpdate" class="btn btn-primary">정보수정</button>
		   						<input type="text" class="form-control visually-hidden" id="newpassword" name="newpassword" value=""><br>
		 					</div>
						</form>		
					</div>
					<div class="col-sm-6 text-center">
						<br><br>
						현재 내점수
						<div class="progress" style="height:30px">
		   					 <div class="progress-bar" style="width:<%=rate%>%;"><%=rate%>점</div>
		  				</div>
		  				<br><br><br>
		  				소셜 인증 하기<br><br><br>
		  				<div id="snsImage">
		  					<img src="./assets/img/logos/google.png" class="rounded-circle float-start" style="width:100px; height:100px;" alt="Cinque Terre" onclick="">
		  					<img src="./assets/img/logos/kakao.png" class="rounded-circle" style="width:100px; height:100px;" alt="Cinque Terre" onclick="">
		  					<img src="./assets/img/logos/naver.png" class="rounded-circle float-end" style="width:100px; height:100px;" alt="Cinque Terre" onclick="">
		  				</div>
					</div>
				</div>
			</div>
		</main>
		<footer>
			<!-- 최하단 디자인 영역 -->
		</footer>
	</body>
</html>