<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	ArrayList<BoardgameTO> reclists = (ArrayList)request.getAttribute("recList");
	ArrayList<BoardgameTO> favlists = (ArrayList)request.getAttribute("favlist");
	ArrayList<BoardgameTO> totallists = (ArrayList)request.getAttribute("totallist");
	ArrayList<BoardgameTO> recently_list = (ArrayList)request.getAttribute("recently_list");
	
	StringBuilder recSB = new StringBuilder();
	StringBuilder favSB = new StringBuilder();
	StringBuilder totalSB = new StringBuilder();
	StringBuilder recentSB = new StringBuilder();
	

	if(reclists.size() > 0) {
		for(BoardgameTO to : reclists){
			recSB.append("<div class='col-lg-4 col-sm-6 mb-4 align-self-center d-flex justify-content-center'>");
			recSB.append("<div class='portfolio-item'>");
			recSB.append("<a class='portfolio-link' href='gameView?seq="+to.getSeq()+"'>");
			recSB.append("<div class='portfolio-hover'>");
			recSB.append("<div class='portfolio-hover-content'>");
			recSB.append(" 제목: "+to.getTitle()+"</br>");
			recSB.append(" 인원: "+to.getMinPlayer()+"~"+to.getMaxPlayer()+"명</br>");
			recSB.append(" 출시년도: "+to.getYearpublished()+"</br>");
			recSB.append(" 플레이타임: "+to.getMinPlaytime()+"-"+to.getMaxPlaytime()+"분</br>");
			recSB.append("</div>");
			recSB.append("</div>");
			recSB.append("<img class='img-fluid game_image' src='"+to.getImageUrl()+"' alt='...' />");
			recSB.append("</a>");
			recSB.append("<div class='portfolio-caption'>");
			recSB.append("<div class='portfolio-caption-heading'>"+to.getTitle()+"</div>");
			recSB.append("</div>");
			recSB.append("</div>");
			recSB.append("</div>");
		}		
	} else {
		recSB.append("<div class='col text-center'>");
		recSB.append("<h3 class='section-subheading text-muted'>현재 추천 보드게임이 없습니다.</h3>");
		recSB.append("</div>");
	}
	
	if(userSeq != null){
		favSB.append("<section class='page-section bg-light' id='portfolio'>");
		favSB.append("<div class='container' id='p2'>");
		favSB.append("<div class='text-center'>");
		favSB.append("<h2 class='section-heading text-uppercase title'>favorite games</h2>");
		favSB.append("<h3 class='section-subheading text-muted'>내가 즐겨찾기 한 보드게임 목록 입니다.</h3>");
		favSB.append("</div>");
		favSB.append("<div class='row d-flex flex-row-reverse my-3'>");
		favSB.append("<div class='col-lg-3 text-end'>");
		if(favlists.size() > 5) {
			favSB.append("<button type='button' class='btn btn-dark text-center' onclick=\"location.href='favgame'\">");
			favSB.append("<i class='bi bi-plus-lg text-white'>더보기</i>");
			favSB.append("</button>");
		}
		favSB.append("</div>");
		favSB.append("</div>");
		favSB.append("<div class='row'>");
		
		if(favlists.size() > 0) {
			for(BoardgameTO to : favlists){
				favSB.append("<div class='col-lg-4 col-sm-6 mb-4 align-self-center d-flex justify-content-center'>");
				favSB.append("<div class='portfolio-item'>");
				favSB.append("<a class='portfolio-link' href='gameView?seq="+to.getSeq()+"'>");
				favSB.append("<div class='portfolio-hover'>");
				favSB.append("<div class='portfolio-hover-content'>");
				favSB.append(" 제목: "+to.getTitle()+"</br>");
				favSB.append(" 인원: "+to.getMinPlayer()+"~"+to.getMaxPlayer()+"명</br>");
				favSB.append(" 출시년도: "+to.getYearpublished()+"</br>");
				favSB.append(" 플레이타임: "+to.getMinPlaytime()+"~"+to.getMaxPlaytime()+"분</br>");
				favSB.append("</div>");
				favSB.append("</div>");
				favSB.append("<img class='img-fluid game_image' src='"+to.getImageUrl()+"' alt='...' />");
				favSB.append("</a>");
				favSB.append("<div class='portfolio-caption'>");
				favSB.append("<div class='portfolio-caption-heading'>"+to.getTitle()+"</div>");
				favSB.append("</div>");
				favSB.append("</div>");
				favSB.append("</div>");
			}
		} else {
			favSB.append("<div class='col text-center'>");
			favSB.append("<h3 class='section-subheading text-muted'>즐겨찾기한 보드게임이 없습니다.</h3>");
			favSB.append("</div>");
		}
		favSB.append("</div>");
		favSB.append("</div>");
		favSB.append("</section>");
	}
	
	totalSB.append("<div class='row d-flex flex-row-reverse my-3'>");
	totalSB.append("<div class='col-lg-3 text-end'>");
	if(totallists.size() > 5) {
		totalSB.append("<button type='button' class='btn btn-dark text-center' onclick=\"location.href='gameSearch'\">");
		totalSB.append("<i class='bi bi-plus-lg text-white'>더보기</i>");
		totalSB.append("</button>");		
	}
	totalSB.append("</div>");
	totalSB.append("</div>");
	totalSB.append("<div class='row'>");

	for(BoardgameTO to : totallists){
		totalSB.append("<div class='col-lg-4 col-sm-6 mb-4 align-self-center d-flex justify-content-center'>");
		totalSB.append("<div class='portfolio-item'>");
		totalSB.append("<a class='portfolio-link' href='gameView?seq="+to.getSeq()+"'>");
		totalSB.append("<div class='portfolio-hover'>");
		totalSB.append("<div class='portfolio-hover-content'>");
		totalSB.append(" 제목: "+to.getTitle()+"</br>");
		totalSB.append(" 인원: "+to.getMinPlayer()+"~"+to.getMaxPlayer()+"명</br>");
		totalSB.append(" 출시년도: "+to.getYearpublished()+"</br>");
		totalSB.append(" 플레이타임: "+to.getMinPlaytime()+"~"+to.getMaxPlaytime()+"분</br>");
		totalSB.append("</div>");
		totalSB.append("</div>");
		totalSB.append("<img class='img-fluid game_image' src='"+to.getImageUrl()+"' alt='...' />");
		totalSB.append("</a>");
		totalSB.append("<div class='portfolio-caption'>");
		totalSB.append("<div class='portfolio-caption-heading'>"+to.getTitle()+"</div>");
		totalSB.append("</div>");
		totalSB.append("</div>");
		totalSB.append("</div>");
	}
	
	totalSB.append("</div>");
	
	if(recently_list.size() > 0) {
		recentSB.append("<ul>");
		recentSB.append("<li>");
		recentSB.append("<div>최근 본<br>보드게임</div>");
		recentSB.append("</li>");
		recentSB.append("<li class='caretup' value='0'>");
		recentSB.append("<i class='bi bi-caret-up-fill' onclick='caretUp()'></i>");
		recentSB.append("</li>");
		int count = 0;
		for(BoardgameTO to : recently_list){
			recentSB.append("<li class='caret" + count + "'>");
			recentSB.append("<div class='container'>");
			recentSB.append("<img class='img-fluid q_image' src='"+ to.getImageUrl()+"' alt='' onclick=\"location.href='gameView?seq=" + to.getSeq() + "'\" />");
			recentSB.append("</div>");
			recentSB.append("</li>");
			count++;
		}
		recentSB.append("<li class='caretdown' value='2'>");
		recentSB.append("<i class='bi bi-caret-down-fill' onclick='caretDown()'></i>");
		recentSB.append("</li>");
		recentSB.append("</ul>");
	}
%>
<!doctype html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
	     <!--  css 파일 -->
		<link rel="stylesheet" href="assets/css/style.css" />
	    <!--  jquery cdn -->
	    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js">
	    </script>
	    <!-- 자바 스크립트 영역 -->
	    <script type="text/javascript">
		    $(document).ready(function() {
	            // 퀵 메뉴를 따라다니도록 설정
	            var quickMenu = $("#quickmenu1");
	            var offset = quickMenu.offset();
	            var topPadding = 20;
	            $(window).scroll(function() {
	                if ($(window).scrollTop() > offset.top) {
	                    quickMenu.stop().animate({
	                        marginTop: $(window).scrollTop() - offset.top + topPadding
	                    });
	                } else {
	                    quickMenu.stop().animate({
	                        marginTop: 0
	                    });
	                }
	            });
        	});
		    
		    var count = <%= recently_list.size() %>
		    
		    window.onload = function() {
		    	$(".caretup").hide();
		    	if(count > 3) {
		    		for(let i=3; i<count; i++) {
		    			$(".caret" + i).hide();
		    		}
		    	} else {
		    		$(".caretdown").hide();
		    	}
		    }
		    
		    function caretUp() {
		    	var index = $(".caretup").val();
		    	if(index > 0) {
		    		if(index-1 == 0) {
		    			$(".caretup").hide();
		    		}
		    		if(count > 3) {
		    			$(".caretdown").show();
		    		}
		    		$(".caret" + (index-1)).show();
		    		$(".caret" + (index+2)).hide();
		    		$(".caretup").val(index-1);
		    		$(".caretdown").val(index+1);
		    	}
		    }
		    
			function caretDown() {
				var index = $(".caretdown").val();
		    	if(index < count) {
		    		if(index+1 == count-1) {
		    			$(".caretdown").hide();
		    		}
		    		if(index-1 > 0) {
		    			$(".caretup").show();
		    		}
		    		$(".caret" + (index-2)).hide();
		    		$(".caret" + (index+1)).show();
		    		$(".caretup").val(index-1);
		    		$(".caretdown").val(index+1);
		    	}
		    }
	    </script>
	    
	    <meta charset="utf-8" />
	    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
	</head>
	<body>
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
	    <!-- Masthead-->
	    <header class="bg-secondary">
	        <div class="container d-flex justify-content-center">
	            <img class="main_image" src="assets/img/logos/boardgame.png">
	        </div>
	    </header>
		<!--  캐러셀 -->
		<div class="container my-5" id="c1">
		    <div id="carouselExampleInterval" class="carousel slide" data-bs-ride="carousel">
		        <div class="carousel-inner">
		            <div class="carousel-item active" data-bs-interval="4000">
		                <img src="assets/img/carousel/carousel1.jpg" class="d-block w-100" alt="...">
		            </div>
		            <div class="carousel-item" data-bs-interval="4000">
		                <img src="assets/img/carousel/carousel2.jpg" class="d-block w-100" alt="...">
		            </div>
		            <div class="carousel-item">
		                <img src="assets/img/carousel/carousel3.jpg" class="d-block w-100" alt="...">
		            </div>
		        </div>
		        <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleInterval" data-bs-slide="prev">
		            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
		            <span class="visually-hidden">Previous</span>
		        </button>
		        <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleInterval" data-bs-slide="next">
		            <span class="carousel-control-next-icon" aria-hidden="true"></span>
		            <span class="visually-hidden">Next</span>
		        </button>
		    </div>
		</div>
	    <!-- 추천 헤더-->
	    <section class="page-section bg-light" id="portfolio">
	        <div class="container" id="p1">
	            <div class="text-center">
	                <h2 class="section-heading text-uppercase title">Recommended games</h2>
	                <h3 class="section-subheading text-muted">관리자가 엄선한 추천게임입니다.</h3>
	            </div>
	            <div class="row">
	                <%=recSB %>
	            </div>
	        </div>
	    </section>
	    <!-- 즐겨찾기 헤더-->
	    <%=favSB %>
	    <!-- 전체 헤더-->
	    <section class="page-section bg-light" id="portfolio">
	        <div class="container" id="p3">
	            <div class="text-center">
	                <h2 class="section-heading text-uppercase title">whole games</h2>
	                <h3 class="section-subheading text-muted">전체 게임 목록입니다.</h3>
	            </div>
            	<%=totalSB %>
	        </div>
	    </section>
	    
	    <!--  퀵메뉴  -->
	    <div class="quickmenu" id="quickmenu1">
	    	<%= recentSB %>
		</div>
	    <!-- Core theme JS-->
	    <script src="assets/js/scripts.js"></script>
	    <!-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *-->
	    <!-- * *                               SB Forms JS                               * *-->
	    <!-- * * Activate your form at https://startbootstrap.com/solution/contact-forms * *-->
	    <!-- * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *-->
		<script src="https://cdn.startbootstrap.com/sb-forms-latest.js"></script>
	</body>
</html>