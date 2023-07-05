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
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- Required meta tags -->
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

  <!-- Bootstrap CSS v5.2.1 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
    integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.6.0/font/bootstrap-icons.css" />

  <!-- Bootstrap JavaScript Libraries -->
  <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
  integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3" crossorigin="anonymous">
  </script>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.min.js"
  integrity="sha384-7VPbUDkoPSGFnVtYi0QogXtr74QeVeeIs99Qfg5YCF+TidwNdjvaKZX19NZ/e6oz" crossorigin="anonymous">
  </script>
  <script type="text/javascript">
  	window.onload = function(){
  		document.getElementById("new_pwd_btn").onclick = function(){
  			if(document.new_pwd_frm.new_pwd1.value.trim() == ""){
  				alert("새로운 비밀번호를 입력하세요");
  				return false;
  			}
  			if(document.new_pwd_frm.new_pwd1.value.trim() != document.new_pwd_frm.new_pwd2.value.trim()){
  				alert("비밀번호가 일치하지 않습니다");
  				return false;
  			}
  			document.new_pwd_frm.submit();
  		};
  	};
  </script>
</head>
<body>
	<header>
    <!-- 최상단 디자인 -->
      <nav class="navbar navbar-expand-lg navbar-dark bg-dark" aria-label="Eighth navbar example">
        <div class="container">
          <a class="navbar-brand" href="#"><i class="bi bi-house"></i></a>
          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarsExample07" aria-controls="navbarsExample07" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
          </button>
          		<div class="collapse navbar-collapse" id="navbarsExample07">
            		<ul class="navbar-nav me-auto mb-2 mb-lg-0">
                  		<li class="nav-item">
                    		<a class="nav-link" href="#">게임검색</a>
                  		</li>
                  		<li class="nav-item dropdown">
                    		<a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown" aria-expanded="false">커뮤니티</a>
                    		<ul class="dropdown-menu">
                      			<li><a class="dropdown-item" href="#">자유게시판</a></li>
                      			<li><a class="dropdown-item" href="#">모임 게시판</a></li>
                      			<li><a class="dropdown-item" href="#">공지사항</a></li>
                    		</ul>
                  		</li>
                  		<li class="nav-item">
                    		<a class="nav-link" href="#">모임지도</a>
                  		</li>
                  		<li class="nav-item dropdown">
                    		<a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown" aria-expanded="false">관리자</a>
                    		<ul class="dropdown-menu">
                      			<li><a class="dropdown-item" href="#">신고글 목록</a></li>
                      			<li><a class="dropdown-item" href="#">밴유저 관리</a></li>
                      			<li><a class="dropdown-item" href="#">유저 목록</a></li>
                      			<li><a class="dropdown-item" href="#">전체 쪽지 보내기</a></li>
                      			<li><a class="dropdown-item" href="#">문의 관리</a></li>
                    		</ul>
                  		</li>
            		</ul>
            		<form>
                		<a href="/login" class="badge badge-light">로그인</a>
                		<a href="/signup" class="badge badge-light">회원가입</a>
            		</form>
          		</div>
        	</div>
    	</nav>
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
					<button class="btn btn-secondary" id="new_pwd_btn" type="button">
					비밀번호 변경</button>
					</span>
				</form>
			</div>
		</div>
		
	</main>

</body>
</html>