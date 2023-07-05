<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	int isRec = (Integer)request.getAttribute("isRec");
	int isFav = (Integer)request.getAttribute("isFav");
	BoardgameTO gameTO = (BoardgameTO)request.getAttribute("gameTO");
	ArrayList<BoardTO> boardList = (ArrayList)request.getAttribute("boardList");
	ArrayList<EvaluationTO> evalList = (ArrayList)request.getAttribute("evalList");
	String seq = gameTO.getSeq();
	String imageUrl = gameTO.getImageUrl();
	String title = gameTO.getTitle();
	String yearpublished = gameTO.getYearpublished();
	String minPlayer = gameTO.getMinPlayer();
	String maxPlayer = gameTO.getMaxPlayer();
	String minPlaytime = gameTO.getMinPlaytime();
	String maxPlaytime = gameTO.getMaxPlaytime();
	String minAge = gameTO.getMinAge();
	String brief = gameTO.getBrief();
	String difficulty = (gameTO.getDifficulty() != null) ? gameTO.getDifficulty() + " / 5" : "데이터없음";
	String rate = (gameTO.getRate() != null) ? gameTO.getRate() + " / 5" : "데이터없음";
	String recCnt = gameTO.getRecCnt().toString();
	String evalCnt = "총 " + gameTO.getEvalCnt() + "건";
	String hit = gameTO.getHit();
	String theme = gameTO.getTheme();
	String genre = gameTO.getGenre();
	
	// 게임 즐겨찾기 추가/해제 버튼
	// 0: 로그인x 1: 해제 2: 추가
	String fav = "<button type='button' class='btn btn-dark' style='float:right;' "
		+ "onclick='updateFav(" + seq + ", " + isFav + ")'>";
	if(isFav == 1) {
		fav += " <i class='bi bi-star-fill'></i> 즐겨찾기 해제"
		+" <i class='bi bi-dash-square'>";
	} else {
		fav += " <i class='bi bi-star'></i> 즐겨찾기 추가"
		+" <i class='bi bi-plus-square'>";
	}
	
	fav += "</i></button>";
	
	// 게임 추천/해제 버튼
	// 0: 로그인x 1: 해제 2: 추가 
	String rec = "<button type='button' class='btn btn-dark' "
			+ "onclick='updateRec(" + seq + ", " + isRec + ")'>";
	if(isRec == 1) {
		rec += "<i class='bi bi-hand-thumbs-up-fill'>";
	} else {
		rec += "<i class='bi bi-hand-thumbs-up'>";
	}
	
	rec += "</i></button> " + recCnt;
	
	// 해당 게임 태그에 맞는 게시글 리스트 
	StringBuilder boardHtml = new StringBuilder();
	
	for(BoardTO list: boardList) {
		if(list.isDel()) {
			boardHtml.append("<tr>");
		} else {
			boardHtml.append("<tr onclick='location.href=\"#\"'>");
		}
		boardHtml.append("<td class='board-img'><i class='bi ");
		if(list.isDel() || !list.isHasFile()) {
			boardHtml.append("bi-file-earmark-excel");
		} else {
			boardHtml.append("bi-card-image");
		}
		boardHtml.append(" h1 icon'></i></td>");
		if(list.isDel()){
			boardHtml.append("<td>삭제된 게시글입니다.");
		} else {
			boardHtml.append("<td><span class='badge bg-secondary'>");
			boardHtml.append(list.getTag());
			boardHtml.append("</span>&nbsp;");
			boardHtml.append(list.getSubject() + " [" + list.getCmtCnt() + "]<br>");
			boardHtml.append("<small>" + list.getWriter() + "&nbsp;" + list.getWdate() + "&nbsp;");
			boardHtml.append("<i class='bi bi-eye-fill icon'></i>" + list.getHit() + "&nbsp;");
			boardHtml.append("<i class='bi bi-hand-thumbs-up-fill icon'></i>" + list.getRecCnt() + "</small>");
		}
		boardHtml.append("</td>");
		boardHtml.append("</tr>");
	}
	
	// 보드게임 평가 리스트
	StringBuilder evalHtml = new StringBuilder();
	
	for(EvaluationTO list: evalList) {
		evalHtml.append("<tr>");
		evalHtml.append("<td class='cmt-left'>");
		evalHtml.append("<div class='circle'>" + list.getRate() + "</div>");
		evalHtml.append("</td>");
		evalHtml.append("<td class='cmt-center'>" + list.getEval() + "<br>");
		evalHtml.append("<small>" + list.getWriter() + "&nbsp;");
		evalHtml.append(list.getWdate() + "</small>");
		evalHtml.append("</td>");
		evalHtml.append("<td class='cmt-right'>");
		
		// 평가글에 대한 추천/해제
		evalHtml.append("<button type='button' class='btn btn-dark cbtn' onclick='updateEvalRec(");
		evalHtml.append(seq + ", " + list.getSeq() + ", " + list.getIsEvalRec() + ")'>");
		
		if(list.getIsEvalRec() == 1) {
			evalHtml.append("<i class='bi bi-hand-thumbs-up-fill'>");
		} else {
			evalHtml.append("<i class='bi bi-hand-thumbs-up'>");
		}
		evalHtml.append("</i></button>");
		evalHtml.append("&nbsp;" + list.getRecCnt());
		evalHtml.append("</td>");
		evalHtml.append("<td class='cmt-right'>");
		if(list.getMemSeq().equals(userSeq)){
			evalHtml.append("<button type='button' class='btn btn-dark cbtn' onclick='deleteEval(");
			evalHtml.append(seq + ", " + list.getSeq() + ")'><i class='bi bi-x-lg'></i></button>");	
		}
		evalHtml.append("</td>");
		evalHtml.append("</tr>");
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
			document.getElementById('rbtn').onclick = function() {
				if(<%= userSeq %> == null) {
					alert("로그인이 필요합니다.");
				} else if(document.rfrm.rate.value.trim() == "") {
					alert("평점을 선택하세요.");
				} else if (document.rfrm.difficulty.value.trim() == "") {
					alert("난이도를 선택하세요.");
				} else if (document.rfrm.eval.value.trim() == "") {
					alert("한줄평을 입력하세요.");
				} else {
					document.rfrm.submit();					
				}
			}
		}
	  
	  function updateFav(seq, isFav) {
		  if (isFav == 0) {
			  alert("로그인이 필요합니다.");
		  } else {
			  location.href='gameFavoriteWriteOk?seq=' + seq + '&isFav=' + isFav;
		  }
	  }
	  
	  function updateRec(seq, isRec) {
		  if (isRec == 0) {
			  alert("로그인이 필요합니다.");
		  } else {
			  location.href='gameRecommendWriteOk?seq=' + seq + '&isRec=' + isRec;
		  }
	  }
	  
	  function updateEvalRec(seq, evalSeq, isEvalRec) {
		  if (isEvalRec == 0) {
			  alert("로그인이 필요합니다.");
		  } else {
			  location.href='evalRecommendWriteOk?seq=' + seq + '&evalSeq=' + evalSeq + '&isEvalRec=' + isEvalRec;
		  }
	  }
	  
	  function deleteEval(seq, evalSeq) {
		  let result = confirm("삭제하시겠습니까?");
		  
		  if(result == true) {
			  location.href='evalDeleteOk?seq=' + seq + '&evalSeq=' + evalSeq;
		  }
	  }
  </script>

</head>

<body>
<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
  <main>
<!-- ======= gameInfo Section ======= -->
    <section id="gameInfo" class="gameInfo p-3 mb-2 bg-secondary text-white">
      <div class="container" data-aos="fade-up">
      	<div class="row">
      		<div class="col text-center">
      			<h1 class="title"><%= title %></h1>
      		</div>
      		</div>
    		<div class="row my-2 d-flex justify-content-end">
          	<div class="col-lg-3 text-end">
          		조회수 : <%= hit %>
          	</div>
		</div>
        <div class="row">
          <div class="col-lg-3">
            <img src="<%= imageUrl %>" class="img-fluid" alt="">
          </div>
          <div class="col-lg-6 pt-4 pt-lg-0 content align-self-center">
            <div class="row ginfo">
              <div class="col-lg-6">
                <ul>
                  <li><strong>인원:</strong> <span><%= minPlayer %>-<%= maxPlayer %>명</span></li>
                  <li><strong>연령:</strong> <span><%= minAge %>세 이상</span></li>
                  <li><strong>평점:</strong> <span><%= rate %></span></li>
                </ul>
              </div>
              <div class="col-lg-6">
                <ul>
                  <li><strong>출시년도:</strong> <span><%= yearpublished %></span></li>
                  <li><strong>플레이 시간:</strong> <span><%= minPlaytime %>-<%= maxPlaytime %>분</span></li>
                  <li><strong>난이도:</strong> <span><%= difficulty %></span></li>
                </ul>
              </div>
            </div>
          </div>
	      <div class="col-lg-3 my-2">
	      	<%= fav %>
          </div>
          <div class="d-flex flex-row-reverse">
          	<div class="col-lg-2 text-end">
          		<%= rec %>
          	</div>
          </div>
        </div>

      </div>
    </section><!-- End gameInfo Section -->
    
     <!-- ======= About Section ======= -->
    <section id="about" class="about">
      <div class="container" data-aos="fade-up">

        <div class="row g-4 g-lg-5" data-aos="fade-up" data-aos-delay="200">

          <div class="col-lg-12">
            <!-- Tabs -->
            <ul class="nav nav-pills mb-3">
              <li><a class="nav-link active" data-bs-toggle="pill" href="#tab1">주요정보</a></li>
              <li><a class="nav-link" data-bs-toggle="pill" href="#tab2">평가</a></li>
              <li><a class="nav-link" data-bs-toggle="pill" href="#tab3">커뮤니티</a></li>
            </ul><!-- End Tabs -->

            <!-- Tab Content -->
            <div class="tab-content">

              <div class="tab-pane fade show active" id="tab1">
                <div class="d-flex align-items-center mt-4">
                  <i class="bi bi-check2"></i>
                  <h4>장르</h4>
                </div>
                <p><%= genre %></p>

                <div class="d-flex align-items-center mt-4">
                  <i class="bi bi-check2"></i>
                  <h4>테마</h4>
                </div>
                <p><%= theme %></p>

                <div class="d-flex align-items-center mt-4">
                  <i class="bi bi-check2"></i>
                  <h4>간단설명</h4>
                </div>
                <p><%= brief %></p>

              </div><!-- End Tab 1 Content -->

              <div class="tab-pane fade show" id="tab2">
              
              	<div>
              		<%= evalCnt %>
              	</div>
              	<table class="table">
					<%= evalHtml %>
				</table>
				
				<form action="evalWriteOk" method="post" name="rfrm">
				<input type="hidden" name="gameSeq" value="<%= seq %>">
				<div class="row">
					<div class="col-lg-6">
						<label for="input-4" class="control-label">평점</label>
						<input id="rate" name="rate" class="rating rating-loading" data-show-clear="false" data-show-caption="true">
					</div>
					<div class="col-lg-6">
						<label for="input-4" class="control-label">난이도</label>
						<input id="difficulty" name="difficulty" class="rating rating-loading" data-show-clear="false" data-show-caption="true">
					</div>
				</div>
				<div class="row align-items-center">
					<div class="col">
						<input type="text" class="input-text" name="eval" placeholder="한줄평">
					</div>
					<div class="col-3">
						<button type='button' class='btn btn-dark' id="rbtn">등록</button>
					</div>
				</div>
				</form>
              </div><!-- End Tab 2 Content -->

              <div class="tab-pane fade show" id="tab3">
              
              <table class="table">
			<%= boardHtml %>
		</table>
              </div><!-- End Tab 3 Content -->

            </div>

          </div>

        </div>

      </div>
    </section><!-- End About Section -->
  </main>
  <footer>
    <!-- 최하단 디자인 영역 -->
  </footer>
</body>

</html>