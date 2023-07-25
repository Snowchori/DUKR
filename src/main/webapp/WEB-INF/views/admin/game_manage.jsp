<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
String seq = (String)request.getParameter("seq");
ArrayList<BoardgameTO> gameList = (ArrayList)request.getAttribute("gameList");
ArrayList<String> gameRecList = (ArrayList)request.getAttribute("gameRecList");
StringBuilder modiHtml = new StringBuilder();
StringBuilder unmodiHtml = new StringBuilder();
StringBuilder recHtml = new StringBuilder();
StringBuilder preRecHtml = new StringBuilder();

String imageUrl = "";
String title = "";
String yearpublished = "";
String minPlayer = "";
String maxPlayer = "";
String minPlaytime = "";
String maxPlaytime = "";
String minAge = "";
String brief = "";
String theme = "";
String genre = "";

// 수정여부에 따라서 수정함, 수정안함 분리
for(BoardgameTO to: gameList) {
	if(to.isModi()){
		modiHtml.append("<li onclick='changeInfo(" + to.getSeq() + ")'>번호 : " + to.getSeq() + ", 제목 : " + to.getTitle() + "</li>");
	} else {
		unmodiHtml.append("<li onclick='changeInfo(" + to.getSeq() + ")'>번호 : " + to.getSeq() + ", 제목 : " + to.getTitle() + "</li>");
	}
	if(to.getSeq().equals(seq)) {
		imageUrl = to.getImageUrl();
		title = to.getTitle();
		yearpublished = to.getYearpublished();
		minPlayer = to.getMinPlayer();
		maxPlayer = to.getMaxPlayer();
		minPlaytime = to.getMinPlaytime();
		maxPlaytime = to.getMaxPlaytime();
		minAge = to.getMinAge();
		brief = to.getBrief();
		theme = to.getTheme();
		genre = to.getGenre();
	}

	if(gameRecList.contains(to.getSeq())) {
		preRecHtml.append("<div class='col-lg-3 m-1 p-1 text-center'>");
		preRecHtml.append("<img class='game_img' src='" + to.getImageUrl() + "'><br/>");
		preRecHtml.append("번호: " + to.getSeq() + ", 제목: " + to.getTitle());
		preRecHtml.append("</div>");
		
	}

	recHtml.append("<div class='col-lg-3 m-1 p-1 text-center'>");
	recHtml.append("<img class='game_img' src='" + to.getImageUrl() + "'><br/>");
	recHtml.append("<input type='checkbox' name='checkedValue' value='" + to.getSeq());
	recHtml.append( "' onclick='getCheckedCnt()'/> ");
	recHtml.append("번호: " + to.getSeq() + ", 제목: " + to.getTitle());
	recHtml.append("</div>");
}

StringBuilder cbtnHtml = new StringBuilder();

if(preRecHtml == null || preRecHtml.toString().equals("")) {
	preRecHtml.append("<div class='col-lg-3 m-1 p-1'>");
	preRecHtml.append("현재 추천 보드게임 없음");
	preRecHtml.append("</div>");
} else {
	preRecHtml.append("<div class='row my-2 d-flex justify-content-end align-items-center'>");
	preRecHtml.append("<div class='col-lg-3'>");
	preRecHtml.append("<button id='cbtn' type='button' class='btn btn-dark cbtn'>초기화</button>");
	preRecHtml.append("</div>");
	preRecHtml.append("</div>");
	
	cbtnHtml.append("document.getElementById('cbtn').onclick = function() {");
	cbtnHtml.append("$.ajax({");
	cbtnHtml.append("url:'recommendgameClear',");
	cbtnHtml.append("type:'get',");
	cbtnHtml.append("success: function(data) {");
	cbtnHtml.append("if(data == 0) {");
	cbtnHtml.append("Swal.fire({");
	cbtnHtml.append("icon: 'success',");
	cbtnHtml.append("title: '초기화 완료',");
	cbtnHtml.append("confirmButtonText: '확인',");
	cbtnHtml.append("timer: 1500,");
	cbtnHtml.append("timerProgressBar : true,");
	cbtnHtml.append("willClose: () => {");
	cbtnHtml.append("location.href='gameManage';");
	cbtnHtml.append("}");
	cbtnHtml.append("});");
	cbtnHtml.append("} else {");
	cbtnHtml.append("Swal.fire({");
	cbtnHtml.append("icon: 'error',");
	cbtnHtml.append("title: '초기화 실패',");
	cbtnHtml.append("confirmButtonText: '확인',");
	cbtnHtml.append("timer: 1500,");
	cbtnHtml.append("timerProgressBar : true");
	cbtnHtml.append("});");
	cbtnHtml.append("}");
	cbtnHtml.append("}");
	cbtnHtml.append("});");
	cbtnHtml.append("}");
}

StringBuilder infoHtml = new StringBuilder();

if(seq != null && !seq.equals("")) {
	infoHtml.append("<div class='col-lg-3'>");
	infoHtml.append("<img src=" + imageUrl + " class='img-fluid' alt=''>");
	infoHtml.append("</div>");
	infoHtml.append("<div class='col-lg-6 pt-4 pt-lg-0 content align-self-center'>");
	infoHtml.append("<form action='gameModifyOk' method='post' name='mfrm'>");
	infoHtml.append("<input type='hidden' name='seq' value=" + seq + ">");
	infoHtml.append("<div class='row ginfo'>");
	infoHtml.append("<div class='col-lg-6'>");
	infoHtml.append("<ul>");
	infoHtml.append("<li><strong>제목:</strong> <span>" + title + "</span></li>");
	infoHtml.append("<li><strong>인원:</strong> <span>" + minPlayer + "-" + maxPlayer + "명</span></li>");
	infoHtml.append("<li><strong>연령:</strong> <span>" + minAge + "세 이상</span></li>");
	infoHtml.append("</ul>");
	infoHtml.append("</div>");
	infoHtml.append("<div class='col-lg-6'>");
	infoHtml.append("<ul>");
	infoHtml.append("<li><strong>출시년도:</strong> <span>" + yearpublished + "</span></li>");
	infoHtml.append("<li><strong>플레이 시간:</strong> <span>" + minPlaytime + "-" + maxPlaytime + "분</span></li>");
	infoHtml.append("</ul>");
	infoHtml.append("</div>");
	infoHtml.append("</div>");
	infoHtml.append("<div class='row ginfo'>");
	infoHtml.append("<div class='row'>");
	infoHtml.append("<div class='col-lg-3'>");
	infoHtml.append("<ul>");
	infoHtml.append("<li><strong>장르:</strong></li>");
	infoHtml.append("</ul>");
	infoHtml.append("</div>");
	infoHtml.append("<div class='col'>");
	infoHtml.append("<ul>");
	infoHtml.append("<li><textarea name='genre' cols='' rows='' class='coment_input_text'>" + genre + "</textarea></li>");
	infoHtml.append("</ul>");
	infoHtml.append("</div>");
	infoHtml.append("</div>");
	infoHtml.append("<div class='row'>");
	infoHtml.append("<div class='col-lg-3'>");
	infoHtml.append("<ul>");
	infoHtml.append("<li><strong>테마:</strong></li>");
	infoHtml.append("</ul>");
	infoHtml.append("</div>");
	infoHtml.append("<div class='col'>");
	infoHtml.append("<ul>");
	infoHtml.append("<li><textarea name='theme' cols='' rows='' class='coment_input_text'>" + theme + "</textarea></li>");
	infoHtml.append("</ul>");
	infoHtml.append("</div>");
	infoHtml.append("</div>");
	infoHtml.append("<div class='row'>");
	infoHtml.append("<div class='col-lg-3'>");
	infoHtml.append("<ul>");
	infoHtml.append("<li><strong>간단설명:</strong></li>");
	infoHtml.append("</ul>");
	infoHtml.append("</div>");
	infoHtml.append("<div class='col'>");
	infoHtml.append("<ul>");
	infoHtml.append("<li><textarea name='brief' cols='' rows='' class='coment_input_text'>" + brief + "</textarea></li>");
	infoHtml.append("</ul>");
	infoHtml.append("</div>");
	infoHtml.append("</div>");
	infoHtml.append("</div>");
	infoHtml.append("<div class='row my-2 d-flex justify-content-end'>");
	infoHtml.append("<div class='col-lg-3'>");
	infoHtml.append("<button id='mbtn' type='button' class='btn btn-dark cbtn'>수정</button>");
	infoHtml.append("</div>");
	infoHtml.append("</div>");
	infoHtml.append("</form>");
	infoHtml.append("</div>");
} else {
	infoHtml.append("<div class='col text-center'>");
	infoHtml.append("선택된 보드게임이 없습니다.");
	infoHtml.append("</div>");
}

StringBuilder mbtnHtml = new StringBuilder();

if(seq != null && !seq.equals("")) {
	mbtnHtml.append("document.getElementById('mbtn').onclick = function() {");
	mbtnHtml.append("if(document.mfrm.genre.value.trim() == '') {");
	mbtnHtml.append("Swal.fire({");
	mbtnHtml.append("icon: 'error',");
	mbtnHtml.append("title: '장르를 입력하세요.',");
	mbtnHtml.append("showConfirmButton: false,");
	mbtnHtml.append("timer: 1500");
	mbtnHtml.append("})");
	mbtnHtml.append("} else if(document.mfrm.theme.value.trim() == '') {");
	mbtnHtml.append("Swal.fire({");
	mbtnHtml.append("icon: 'error',");
	mbtnHtml.append("title: '테마를 입력하세요.',");
	mbtnHtml.append("showConfirmButton: false,");
	mbtnHtml.append("timer: 1500");
	mbtnHtml.append("})");
	mbtnHtml.append("} else if (document.mfrm.brief.value.trim() == '') {");
	mbtnHtml.append("Swal.fire({");
	mbtnHtml.append("icon: 'error',");
	mbtnHtml.append("title: '간단설명을 입력하세요.',");
	mbtnHtml.append("showConfirmButton: false,");
	mbtnHtml.append("timer: 1500");
	mbtnHtml.append("})");
	mbtnHtml.append("} else {");
	mbtnHtml.append("$.ajax({");
	mbtnHtml.append("url:'gameModifyOk',");
	mbtnHtml.append("type:'post',");
	mbtnHtml.append("data: {");
	mbtnHtml.append("seq: '" + seq + "',");
	mbtnHtml.append("brief: document.mfrm.brief.value.trim(),");
	mbtnHtml.append("genre: document.mfrm.genre.value.trim(),");
	mbtnHtml.append("theme: document.mfrm.theme.value.trim()");
	mbtnHtml.append("},");
	mbtnHtml.append("success: function(data) {");
	mbtnHtml.append("if(data == 0) {");
	mbtnHtml.append("Swal.fire({");
	mbtnHtml.append("icon: 'success',");
	mbtnHtml.append("title: '정보 수정 완료',");
	mbtnHtml.append("confirmButtonText: '확인',");
	mbtnHtml.append("timer: 1500,");
	mbtnHtml.append("timerProgressBar : true,");
	mbtnHtml.append("willClose: () => {");
	mbtnHtml.append("location.href='gameManage?seq=" + seq + "';");
	mbtnHtml.append("}");
	mbtnHtml.append("});");
	mbtnHtml.append("} else {");
	mbtnHtml.append("Swal.fire({");
	mbtnHtml.append("icon: 'error',");
	mbtnHtml.append("title: '정보 수정 실패',");
	mbtnHtml.append("confirmButtonText: '확인',");
	mbtnHtml.append("timer: 1500,");
	mbtnHtml.append("timerProgressBar : true");
	mbtnHtml.append("});");
	mbtnHtml.append("}");
	mbtnHtml.append("}");
	mbtnHtml.append("});");
	mbtnHtml.append("}");
	mbtnHtml.append("}");
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
			window.onload = function() {
				<%= mbtnHtml %>
				
				<%= cbtnHtml %>
				
				document.getElementById('rbtn').onclick = function() {
					const query = 'input[name="checkedValue"]:checked';
				  	const selectedElements = 
				      	document.querySelectorAll(query);
				  
				  	const selectedElementsCnt =
				        selectedElements.length;
				  	
				  	var checkboxValues = [];
				  	$("input[name='checkedValue']:checked").each(function(i) {
				        checkboxValues.push($(this).val());
				    });
				  	
				  	if(selectedElementsCnt >= 2 && selectedElementsCnt <= 5) {
				  		$.ajax({
				  			url:'recommendgameWriteOk',
				  			type:'post',
				  			data: {
				  				checkedValue: checkboxValues
				  			},
				  			success: function(data) {
					  			if(data == 0) {
						  			Swal.fire({
							  			icon: 'success',
							  			title: '등록 완료',
							  			confirmButtonText: '확인',
							  			timer: 1500,
							  			timerProgressBar : true,
							  			willClose: () => {
							  				location.href='gameManage';
						  				}
					  				});
					  			} else {
						  			Swal.fire({
							  			icon: 'error',
							  			title: '등록 실패',
							  			confirmButtonText: '확인',
							  			timer: 1500,
							  			timerProgressBar : true
						  			});
					  			}
					  		}
					  	});
				  	} else {
				  		Swal.fire({
							icon: 'error',
							title: '2-5개 선택하세요.',
							showConfirmButton: false,
							timer: 1500
						})
				  	}
				}
			}
		
			function changeInfo(seq) {
				location.href='gameManage?seq=' + seq;
			}
			
			function getCheckedCnt() {
				  const query = 'input[name="checkedValue"]:checked';
				  const selectedElements = 
				      document.querySelectorAll(query);
				  
				  const selectedElementsCnt =
				        selectedElements.length;
				  
				  document.getElementById('result').innerText
				    = selectedElementsCnt + "개 선택";
			}
		</script>
	</head>
	<body class="bg-secondary text-white">
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title"><span class="hover" onclick="location.href='gameManage'">보드게임 관리</span></h1>
					<p class="lead fw-normal text-white-50 mb-0">Boardgame Manage</p>
				</div>
			</div>
		</header>
		<main>
			<!-- ======= gameInfo Section ======= -->
			<section id="gameInfo" class="gameInfo p-3 mb-2">
				<div class="container-fluid bottombody_manage">
					<div class="row m-3 p-4 bg-white text-black rounded-5">
						<h2>게임 정보 관리</h2>
						<ul id="myUL">
				  			<li><span class="caret">보드게임 목록</span>
						    	<ul class="nested">
						      		<li><span class="caret">수정한 보드게임</span>
										<ul class="nested">
											<%= modiHtml %>
										</ul>
						      		</li>
									<li><span class="caret">수정하지 않은 보드게임</span>
							      		<ul class="nested">
											<%= unmodiHtml %>
										</ul>
									</li> 
								</ul>
							</li>
						</ul>
					</div>
					<!-- gameInfo -->
					<div class="row m-3 p-4 bg-white text-black rounded-5">
						<%= infoHtml %>
					</div>
					<div class="row m-3 p-4 bg-white text-black rounded-5">
						<h2>게임 추천 관리</h2>
						<h5>현재 추천 게임</h5>
						<div class="row my-3 align-items-center">
							<%= preRecHtml %>
						</div>
						<h5>추천 게임을 선택해주세요 (2-5개)</h5>
						<form action="recommendgameWriteOk" method="post" name="rfrm">
							<div class="row my-3 align-items-center">
								<%= recHtml %>
							</div>
							<div class="row my-2 d-flex justify-content-end align-items-center">
								<div id="result" class="col-lg-2">
									0개 선택
								</div>
								<div class="col-lg-3">
									<button id="rbtn" type='button' class='btn btn-dark cbtn'>등록</button>
								</div>
							</div>
						</form>
					</div>
					<!-- gameList tree -->
					<script>
						var toggler = document.getElementsByClassName("caret");
						var i;
						
						for (i = 0; i < toggler.length; i++) {
						  toggler[i].addEventListener("click", function() {
						    this.parentElement.querySelector(".nested").classList.toggle("active");
						    this.classList.toggle("caret-down");
						  });
						}
					</script>
				</div>
			</section>
			<!-- End gameInfo Section -->
		</main>
		<footer>
			<!-- 최하단 디자인 영역 -->
		</footer>
	</body>
</html>