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

// 로그인x -> 버튼 비활성화
String disable = "";
if(seq == null || seq.equals("")) {
	disable = "disabled";
}
if(preRecHtml == null || preRecHtml.toString().equals("")) {
	preRecHtml.append("<div class='col-lg-3 m-1 p-1'>");
	preRecHtml.append("현재 추천 게임 없음");
	preRecHtml.append("</div>");
}
%>
<!doctype html>
<html>

<!-- java 영역 -->

<head>
  <!-- 페이지 제목 -->
  <title>DUKrule?</title>

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
  
  <!-- default styles -->
	<link href="https://cdn.jsdelivr.net/gh/kartik-v/bootstrap-star-rating@4.1.2/css/star-rating.min.css" media="all" rel="stylesheet" type="text/css" />

	<!-- with v4.1.0 Krajee SVG theme is used as default (and must be loaded as below) - include any of the other theme CSS files as mentioned below (and change the theme property of the plugin) -->
	<link href="https://cdn.jsdelivr.net/gh/kartik-v/bootstrap-star-rating@4.1.2/themes/krajee-svg/theme.css" media="all" rel="stylesheet" type="text/css" />

	<!-- important mandatory libraries -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://cdn.jsdelivr.net/gh/kartik-v/bootstrap-star-rating@4.1.2/js/star-rating.min.js" type="text/javascript"></script>

	<!-- with v4.1.0 Krajee SVG theme is used as default (and must be loaded as below) - include any of the other theme JS files as mentioned below (and change the theme property of the plugin) -->
	<script src="https://cdn.jsdelivr.net/gh/kartik-v/bootstrap-star-rating@4.1.2/themes/krajee-svg/theme.js"></script>

	<!-- optionally if you need translation for your language then include locale file as mentioned below (replace LANG.js with your own locale file) -->
	<script src="https://cdn.jsdelivr.net/gh/kartik-v/bootstrap-star-rating@4.1.2/js/locales/LANG.js"></script>
  
    <!-- Template Main CSS File -->
  <link href="assets/css/style.css" rel="stylesheet">

  <!-- 자바 스크립트 영역 -->
  <script type="text/javascript" >
	  window.onload = function() {
			document.getElementById('mbtn').onclick = function() {
				if(document.mfrm.genre.value.trim() == "") {
					alert("장르를 입력하세요.");
				} else if(document.mfrm.theme.value.trim() == "") {
					alert("테마를 입력하세요.");
				} else if (document.mfrm.brief.value.trim() == "") {
					alert("간단설명을 입력하세요.");
				} else {
					document.mfrm.submit();					
				}
			}
			
			document.getElementById('rbtn').onclick = function() {
				const query = 'input[name="checkedValue"]:checked';
			  	const selectedElements = 
			      	document.querySelectorAll(query);
			  
			  	const selectedElementsCnt =
			        selectedElements.length;
			  	
			  	if(selectedElementsCnt >= 2 && selectedElementsCnt <= 5) {
			  		document.rfrm.submit();
			  	} else {
			  		alert("2-5개 선택하세요.");
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
  
  <style>
ul, #myUL {
  list-style-type: none;
}

#myUL {
  margin: 0;
  padding: 0;
}

.caret {
  cursor: pointer;
  -webkit-user-select: none; /* Safari 3.1+ */
  -moz-user-select: none; /* Firefox 2+ */
  -ms-user-select: none; /* IE 10+ */
  user-select: none;
}

.caret::before {
  content: "\25B6";
  color: black;
  display: inline-block;
  margin-right: 6px;
}

.caret-down::before {
  -ms-transform: rotate(90deg); /* IE 9 */
  -webkit-transform: rotate(90deg); /* Safari */'
  transform: rotate(90deg);  
}

.nested {
  display: none;
}

.active {
  display: block;
}

.coment_input_text { 
	border:1px solid #bbb;
	width:100%;
	height:100px;
}

.game_img {
    max-width:200px;
    max-height:200px;
}

</style>

</head>

<body class="bg-secondary text-white">
<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
  <main>
<!-- ======= gameInfo Section ======= -->
    <section id="gameInfo" class="gameInfo p-3 mb-2">
		<h1 class="title">보드게임 관리</h1>
		<div class="row m-3 p-4 bg-white text-black">
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
		<div class="row m-3 p-4 bg-white text-black">
          <div class="col-lg-3">
            <img src="<%= imageUrl %>" class="img-fluid" alt="">
          </div>
          <div class="col-lg-6 pt-4 pt-lg-0 content align-self-center">
          <form action="gameModifyOk" method="post" name="mfrm">
          <input type="hidden" name="seq" value="<%= seq %>">
            <div class="row ginfo">
              <div class="col-lg-6">
                <ul>
                <li><strong>제목:</strong> <span><%= title %></span></li>
                  <li><strong>인원:</strong> <span><%= minPlayer %>-<%= maxPlayer %>명</span></li>
                  <li><strong>연령:</strong> <span><%= minAge %>세 이상</span></li>
                </ul>
              </div>
              <div class="col-lg-6">
                <ul>
                  <li><strong>출시년도:</strong> <span><%= yearpublished %></span></li>
                  <li><strong>플레이 시간:</strong> <span><%= minPlaytime %>-<%= maxPlaytime %>분</span></li>
                </ul>
              </div>
            </div>
            <div class="row ginfo">
	            <div class="row">
	            	<div class="col-lg-3">
	            		<ul>
	            			<li><strong>장르:</strong></li>
	            		</ul>
	            	</div>
	            	<div class="col">
	            		<ul>
	            			<li><textarea name="genre" cols="" rows="" class="coment_input_text"><%= genre %></textarea></li>
	            		</ul>
	            	</div>
	            </div>
	            <div class="row">
	            	<div class="col-lg-3">
	            		<ul>
	            			<li><strong>테마:</strong></li>
	            		</ul>
	            	</div>
	            	<div class="col">
	            		<ul>
	            			<li><textarea name="theme" cols="" rows="" class="coment_input_text"><%= theme %></textarea></li>
	            		</ul>
	            	</div>
	            </div>
				<div class="row">
	            	<div class="col-lg-3">
	            		<ul>
	            			<li><strong>간단설명:</strong></li>
	            		</ul>
	            	</div>
	            	<div class="col">
	            		<ul>
	            			<li><textarea name="brief" cols="" rows="" class="coment_input_text"><%= brief %></textarea></li>
	            		</ul>
	            	</div>
	            </div>
            </div>
            <div class="row my-2 d-flex justify-content-end">
          	<div class="col-lg-3">
          		<button id="mbtn" type='button' class='btn btn-dark cbtn' <%= disable %>>수정</button>
          	</div>
		</div>
		</form>
          </div>
		</div>
		<div class="row m-3 p-4 bg-white text-black">
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
    </section><!-- End gameInfo Section -->
    
  </main>
  <footer>
    <!-- 최하단 디자인 영역 -->
  </footer>
</body>

</html>