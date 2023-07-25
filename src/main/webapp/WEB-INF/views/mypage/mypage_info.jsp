<%@page import="ch.qos.logback.core.recovery.ResilientSyslogOutputStream"%>
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

<%  
	StringBuilder sbSocialButtons = new StringBuilder();
	StringBuilder sbSocialOption = new StringBuilder();
	if(userType == 0){
		sbSocialButtons.append("<img src='./assets/img/logos/google.png' class='rounded-circle float-start' style='width:100px; height:100px;' alt='Cinque Terre' onclick='javascript:loginWithGoogle()'>");
		sbSocialButtons.append("<img src='./assets/img/logos/kakao.png' class='rounded-circle' style='width:100px; height:100px;' alt='Cinque Terre' onclick='javascript:loginWithKakao()'>");
		sbSocialButtons.append("<img src='./assets/img/logos/naver.png' class='rounded-circle float-end' style='width:100px; height:100px;' alt='Cinque Terre' onclick='javascript:loginWithNaver()'>");
		sbSocialOption.append("소셜 인증하기");
	}else{
		sbSocialButtons.append("<h2><i class='fas fa-check green-check'></i> 소셜 인증을 완료했습니다</h2>");
	}
%>

<!doctype html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<style>
	.swal2-popup {
		width: 700px !important;
	}
	.green-check {
      color: green;
    }
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
		if(userType == 2) {
			$('#id').remove();
			$('#idlabel').remove();
			$('#password').remove();
			$('#passwordlabel').remove();
		}
		
		//정보수정버튼 기능
		$('#infoUpdate').on('click', function() {
			if(userType != 2) {
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
						$.ajax({
							url: "mypageEdit",
		                    type: "post",
		                    data: {
		                    	nickname : $('#nickname').val().trim(),
		                    	id : $('#id').val().trim(),
		                        email : $('#email').val().trim(),
		                        password : $('#password').val().trim(),
		                        newpassword : $('#newpassword').val().trim()
							},
							success : function(data) {
							//0 성공 / 1 오류 및 실패 / 2 비밀번호 오류
								if(data == 0) {
									Swal.fire({
										title : '회원정보 변경',
										text  : '정보변경 성공하였습니다',
										icon  : 'success',
										showCancelButton : false,
										confirmButtonText : '확인',
										timer : 1500,
										timerProgressBar : true,
										willClose : () => {
										window.location.href = '/mypage';
										}
									});
								} else if (data == 1) {
									Swal.fire({
										title : '회원정보 변경',
										text  : '정보변경 실패하였습니다',
										icon  : 'error',
										showCancelButton : false,
										confirmButtonText : '확인',
										timer : 1500,
										timerProgressBar : true,
										willClose : () => {
										window.location.href = '/mypage';
										}
		                        	});
								} else {
									Swal.fire({
										title : '회원정보 변경',
										text  : '비밀번호가 일치하지않습니다',
										icon  : 'error',
										showCancelButton : false,
										confirmButtonText : '확인',
										timer : 1500,
										timerProgressBar : true,
										willClose : () => {
										window.location.href = '/mypage';
										}
			                        });
								}
							}
		                })
					}
				});
			} else {
				Swal.fire({
					  title: '정말 변경하시겠습니까?',
					  icon: 'question',
					  showCancelButton: true,
					  confirmButtonText: '확인',
					  cancelButtonText: '취소'
				}).then((result) => {
					if (result.isConfirmed) {
						$.ajax({
							url: "mypageEdit",
		                    type: "post",
		                    data: {
		                    	nickname : $('#nickname').val().trim(),
		                        email : $('#email').val().trim(),
		                        newpassword : ''
		                    },
							success : function(data) {
								//0 성공 / 1 오류 및 실패 / 2 비밀번호 오류
								if(data == 0) {
									Swal.fire({
			                            title : '회원정보 변경',
			                            text  : '정보변경 성공하였습니다',
			                            icon  : 'success',
			                            showCancelButton : false,
			                            confirmButtonText : '확인',
			                            timer : 1500,
			                            timerProgressBar : true,
			                            willClose : () => {
			                            window.location.href = '/mypage';
			                            }
		                            });
								} else {
									Swal.fire({
			                            title : '회원정보 변경',
			                            text  : '정보변경 실패하였습니다',
			                            icon  : 'error',
			                            showCancelButton : false,
			                            confirmButtonText : '확인',
			                            timer : 1500,
			                            timerProgressBar : true,
			                            willClose : () => {
			                            window.location.href = '/mypage';
			                            }
		                            });
								}
							}
						})
					}
				});
			}
		});
	});
</script>
		
		<!-- 카카오 소셜인증 -->
		<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.2.0/kakao.min.js" integrity="sha384-x+WG2i7pOR+oWb6O5GV5f1KN2Ko6N7PTGPS7UlasYWNxZMKQA63Cj/B2lbUmUfuC" crossorigin="anonymous"></script>
		<script type="text/javascript">
			Kakao.init('a987d1929430749f2fdae0e54a73dbf3'); // 카카오 초기화
			
			function loginWithKakao() {
		    	Kakao.Auth.authorize({
		    		redirectUri: 'http://localhost:8080/mypage',
		     		state: 'userme',
		    	});
		  	}
			
			function loginWithGoogle(){
				Swal.fire({
					title : '죄송합니다',
                    text  : '해당기능은 미구현상태입니다',
                    icon  : 'error',
                    timer : 1500,
                    timerProgressBar : true,
                    willClose : () => {
                    	window.location.href = '/mypage';
                    }
				})
			}
			
			function loginWithNaver(){
				Swal.fire({
					title : '죄송합니다',
                    text  : '해당기능은 미구현상태입니다',
                    icon  : 'error',
                    timer : 1500,
                    timerProgressBar : true,
                    willClose : () => {
                    	window.location.href = '/mypage';
                    }
				})
			}
			
			function requestUserInfo() {
				return new Promise(function(resolve, reject) {
					Kakao.API.request({
		      			url: '/v2/user/me',
		      		}).then(function(res) {
		    			const email = res.kakao_account.email;
		    			const id = res.id;
		    			const nickname = res.properties.nickname;
		    	
		    			const userInf = id + '/' + nickname + '/' + email;
		    	
		    			resolve(userInf);
					}).catch(function(err) {
		  				reject('failed to request user information: ' + JSON.stringify(err));
		  			});
				});
			}
		</script>
<%
	if(request.getParameter("code") != null){
		String code = "'" + request.getParameter("code") + "'";
%>
		<script type="text/javascript">
			$.ajax({
				type: "POST",
				url: 'https://kauth.kakao.com/oauth/token',
				data: {
					grant_type: 'authorization_code',
			    	client_id: 'a987d1929430749f2fdae0e54a73dbf3',
			    	redirect_uri: 'http://localhost:8080/mypage',
					code: <%=code%>
				},
				contentType: 'application/x-www-form-urlencoded;charset=utf-8',
				dataType: 'JSON',
				success: function(response) {
					Kakao.Auth.setAccessToken(response.access_token);

					requestUserInfo()
					.then(function(userInfo) {

			        	// 컨트롤러단에 POST 방식으로 유저정보 전송 
			        	$.ajax({
			        		url: '/kakaoCertifyOk',
			          		type: 'POST',
			          		data: {
			            		userInfo: userInfo
			          		},
			          		success: function(res) {
			          			Swal.fire({
			    					title : '소셜인증',
			                        text  : '인증완료되었습니다',
			                        icon  : 'sucess',
			                        timer : 1500,
			                        timerProgressBar : true,
			                        willClose : () => {
			                        	window.location.href = '/mypage';
			                        }
			    				})
			          		},
			          		error: function(xhr) {
			          			Swal.fire({
			    					title : '소셜인증',
			                        text  : '인증 실패하였습니다',
			                        icon  : 'error',
			                        timer : 1500,
			                        timerProgressBar : true,
			                        willClose : () => {
			                        	window.location.href = '/mypage';
			                        }
			    				})
			          		}
			        	});  

					}).catch(function(err) {
						console.error('Failed to request user information: ' + err);
					});
				},
					error: function(jqXHR, error) {
			    	console.log('토큰 실패');
				}
			});
<%
	}
%>
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
			<div class="container mt-3" id="result">
				<div class="row">
					<div class="col-sm-6">
						<form name="userinfo" id="userinfo">
							<div class="mb-3 mt-3">
		    					<label class="form-label">닉네임:</label>
		   						<input type="text" class="form-control" id="nickname" name="nickname" value="<%=nickname%>"><br>
		    					<label class="form-label" id="idlabel">아이디:</label>
		   						<input type="text" class="form-control" id="id" name="id" value="<%=id%>" readonly="readonly"><br>
		    					<label class="form-label" id="passwordlabel">비밀번호:</label>
		   						<input type="text" class="form-control" id="password" name="password" value="" placeholder="비밀번호는 보이지 않습니다" readonly="readonly"><br>
		    					<label class="form-label">이메일:</label>
		   						<input type="email" class="form-control" id="email" name="email" value="<%=email%>"><br>
		   						<button type="button" id="infoUpdate" class="btn btn-dark">정보수정</button>
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
		  				<%=sbSocialOption %><br><br><br>
		  				<div id="snsImage">
		  					<%=sbSocialButtons %>
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