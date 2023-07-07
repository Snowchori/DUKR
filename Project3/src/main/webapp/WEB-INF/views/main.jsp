<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<!doctype html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
	    <!--  css 파일 -->
		<link rel="stylesheet" href="assets/css/style2.css" />
	    <!--  jquery cdn -->
	    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js">
	    </script>
	    <!-- 자바 스크립트 영역 -->
	    <script type="text/javascript">
	        $(function() {
	            var $win = $(window);
	            var top = $(window).scrollTop(); // 현재 스크롤바의 위치값을 반환합니다.
	
	            /*사용자 설정 값 시작*/
	            var speed = 500; // 따라다닐 속도 : "slow", "normal", or "fast" or numeric(단위:msec)
	            var easing = 'linear'; // 따라다니는 방법 기본 두가지 linear, swing
	            var $layer = $('.float_sidebar'); // 레이어 셀렉팅
	            var layerTopOffset = 0; // 레이어 높이 상한선, 단위:px
	            $layer.css('position', 'relative').css('z-index', '1');
	            /*사용자 설정 값 끝*/
	
	            // 스크롤 바를 내린 상태에서 리프레시 했을 경우를 위해
	            if (top > 0)
	                $win.scrollTop(layerTopOffset + top);
	            else
	                $win.scrollTop(0);
	
	            //스크롤이벤트가 발생하면
	            $(window).scroll(function() {
	                yPosition = $win.scrollTop() - 1100; //이부분을 조정해서 화면에 보이도록 맞추세요
	                if (yPosition < 0) {
	                    yPosition = 0;
	                }
	                $layer.animate({
	                    "top": yPosition
	                }, {
	                    duration: speed,
	                    easing: easing,
	                    queue: false
	                });
	            });
	        });
	
	        // 퀵메뉴
	        $(document).ready(function() {
	            var currentPosition = parseInt($(".quickmenu").css("top"));
	            $(window).scroll(function() {
	                var position = $(window).scrollTop();
	                $(".quickmenu").stop().animate({
	                    "top": position + currentPosition + "px"
	                }, 700);
	            });
	        });
	    </script>
	    <meta charset="utf-8" />
	    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
	    <meta name="description" content="" />
	    <meta name="author" content="" />
	    <title>DUKrule?</title>
	    <!-- Favicon-->
	    <link rel="icon" type="image/x-icon" href="assets/favicon.ico" />
	    <!-- Font Awesome icons (free version)-->
	    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
	    <!-- Google fonts-->
	    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700" rel="stylesheet" type="text/css" />
	    <link href="https://fonts.googleapis.com/css?family=Roboto+Slab:400,100,300,700" rel="stylesheet" type="text/css" />
	</head>
	<body id="page-top">
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
	    <!-- Masthead-->
	    <header class="masthead">
	        <div class="container">
	            <div class="masthead-subheading">Welcome To DUKR!</div>
	            <div class="masthead-heading text-uppercase">대한민국 보드게임 커뮤니티</div>
	            <a class="btn btn-primary btn-xl text-uppercase" href="#mainNav">더보기</a>
	        </div>
	    </header>
	    <!-- Navigation-->
	    <nav class="navbar navbar-expand-lg navbar-dark" id="mainNav">
	        <div class="container">
	            <a class="navbar-brand" href="#page-top"></a>
	            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
	                Menu
	                <i class="fas fa-bars ms-1"></i>
	            </button>
	            <div class="collapse navbar-collapse" id="navbarResponsive">
	                <ul class="navbar-nav text-uppercase ms-auto py-4 py-lg-0">
	                    <li class="nav-item"><a class="nav-link" href="#p1">추천게임</a></li>
	                    <li class="nav-item"><a class="nav-link" href="#p2">즐겨찾기한게임</a></li>
	                    <li class="nav-item"><a class="nav-link" href="#p3">전체게임</a></li>
	                </ul>
	            </div>
	        </div>
	    </nav>
		<!--  캐러셀 -->
		<div class="container" id="c1">
		    <div id="carouselExampleInterval" class="carousel slide" data-bs-ride="carousel">
		        <div class="carousel-inner">
		            <div class="carousel-item active" data-bs-interval="4000">
		                <img src="/images/game3.jpg" class="d-block w-100" alt="...">
		            </div>
		            <div class="carousel-item" data-bs-interval="4000">
		                <img src="/images/game3.jpg" class="d-block w-100" alt="...">
		            </div>
		            <div class="carousel-item">
		                <img src="/images/game3.jpg" class="d-block w-100" alt="...">
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
	                <h2 class="section-heading text-uppercase">Recommended games</h2>
	                <h3 class="section-subheading text-muted">관리자가 엄선한 추천게임 5종 입니다.</h3>
	            </div>
	            <div class="row">
	                <div class="col-lg-4 col-sm-6 mb-4">
	                    <!-- 추천 목록 -->
	                    <div class="portfolio-item">
	                        <a class="portfolio-link" data-bs-toggle="modal" href="#portfolioModal1">
	                            <div class="portfolio-hover">
	                                <div class="portfolio-hover-content">정보 1</div>
	                            </div>
	                            <img class="img-fluid" src="/images/game1.jpg" alt="..." />
	                        </a>
	                        <div class="portfolio-caption">
	                            <div class="portfolio-caption-heading">게임1</div>
	                            <div class="portfolio-caption-subheading text-muted">게임 내용</div>
	                        </div>
	                    </div>
	                </div>
	                <div class="col-lg-4 col-sm-6 mb-4">
	                    <div class="portfolio-item">
	                        <a class="portfolio-link" data-bs-toggle="modal" href="#portfolioModal2">
	                            <div class="portfolio-hover">
	                                <div class="portfolio-hover-content"><i class="fas fa-plus fa-3x"></i></div>
	                            </div>
	                            <img class="img-fluid" src="/images/game2.jpg" alt="..." />
	                        </a>
	                        <div class="portfolio-caption">
	                            <div class="portfolio-caption-heading">게임2</div>
	                            <div class="portfolio-caption-subheading text-muted">게임 내용</div>
	                        </div>
	                    </div>
	                </div>
	                <div class="col-lg-4 col-sm-6 mb-4">
	                    <div class="portfolio-item">
	                        <a class="portfolio-link" data-bs-toggle="modal" href="#portfolioModal3">
	                            <div class="portfolio-hover">
	                                <div class="portfolio-hover-content"><i class="fas fa-plus fa-3x"></i></div>
	                            </div>
	                            <img class="img-fluid" src="/images/game3.jpg" alt="..." />
	                        </a>
	                        <div class="portfolio-caption">
	                            <div class="portfolio-caption-heading">게임3</div>
	                            <div class="portfolio-caption-subheading text-muted">게임 내용</div>
	                        </div>
	                    </div>
	                </div>
	                <div class="col-lg-4 col-sm-6 mb-4 mb-lg-0">
	                    <div class="portfolio-item">
	                        <a class="portfolio-link" data-bs-toggle="modal" href="#portfolioModal4">
	                            <div class="portfolio-hover">
	                                <div class="portfolio-hover-content"><i class="fas fa-plus fa-3x"></i></div>
	                            </div>
	                            <img class="img-fluid" src="/images/game4.jpg" alt="..." />
	                        </a>
	                        <div class="portfolio-caption">
	                            <div class="portfolio-caption-heading">게임4</div>
	                            <div class="portfolio-caption-subheading text-muted">게임 내용</div>
	                        </div>
	                    </div>
	                </div>
	                <div class="col-lg-4 col-sm-6 mb-4 mb-sm-0">
	                    <div class="portfolio-item">
	                        <a class="portfolio-link" data-bs-toggle="modal" href="#portfolioModal5">
	                            <div class="portfolio-hover">
	                                <div class="portfolio-hover-content"><i class="fas fa-plus fa-3x"></i></div>
	                            </div>
	                            <img class="img-fluid" src="/images/game5.jpg" alt="..." />
	                        </a>
	                        <div class="portfolio-caption">
	                            <div class="portfolio-caption-heading">게임5</div>
	                            <div class="portfolio-caption-subheading text-muted">게임 내용</div>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </section>
	    <!-- 즐겨찾기 헤더-->
	    <section class="page-section bg-light" id="portfolio">
	        <div class="container" id="p2">
	            <div class="text-center">
	                <h2 class="section-heading text-uppercase">favorite games</h2>
	                <h3 class="section-subheading text-muted">내가 즐겨찾기 한 게임 목록 입니다.</h3>
	            </div>
	            <div class="row d-flex flex-row-reverse">
	            	<div class="col-lg-3 text-end">
						<a class="btn btn-primary btn-xl text-uppercase" href="#mainNav">더보기</a>
	            	</div>
	            </div>
	            <div class="row">
	                <div class="col-lg-4 col-sm-6 mb-4">
	                    <!-- 즐겨찾기 목록 -->
	                    <div class="portfolio-item">
	                        <a class="portfolio-link" data-bs-toggle="modal" href="#portfolioModal1">
	                            <div class="portfolio-hover">
	                                <div class="portfolio-hover-content"><i class="fas fa-plus fa-3x"></i></div>
	                            </div>
	                            <img class="img-fluid" src="/images/game1.jpg" alt="..." />
	                        </a>
	                        <div class="portfolio-caption">
	                            <div class="portfolio-caption-heading">게임1</div>
	                            <div class="portfolio-caption-subheading text-muted">게임 내용</div>
	                        </div>
	                    </div>
	                </div>
	                <div class="col-lg-4 col-sm-6 mb-4">
	                    <div class="portfolio-item">
	                        <a class="portfolio-link" data-bs-toggle="modal" href="#portfolioModal2">
	                            <div class="portfolio-hover">
	                                <div class="portfolio-hover-content"><i class="fas fa-plus fa-3x"></i></div>
	                            </div>
	                            <img class="img-fluid" src="/images/game2.jpg" alt="..." />
	                        </a>
	                        <div class="portfolio-caption">
	                            <div class="portfolio-caption-heading">게임2</div>
	                            <div class="portfolio-caption-subheading text-muted">게임 내용</div>
	                        </div>
	                    </div>
	                </div>
	                <div class="col-lg-4 col-sm-6 mb-4">
	                    <div class="portfolio-item">
	                        <a class="portfolio-link" data-bs-toggle="modal" href="#portfolioModal3">
	                            <div class="portfolio-hover">
	                                <div class="portfolio-hover-content"><i class="fas fa-plus fa-3x"></i></div>
	                            </div>
	                            <img class="img-fluid" src="/images/game3.jpg" alt="..." />
	                        </a>
	                        <div class="portfolio-caption">
	                            <div class="portfolio-caption-heading">게임3</div>
	                            <div class="portfolio-caption-subheading text-muted">게임 내용</div>
	                        </div>
	                    </div>
	                </div>
	                <div class="col-lg-4 col-sm-6 mb-4 mb-lg-0">
	                    <div class="portfolio-item">
	                        <a class="portfolio-link" data-bs-toggle="modal" href="#portfolioModal4">
	                            <div class="portfolio-hover">
	                                <div class="portfolio-hover-content"><i class="fas fa-plus fa-3x"></i></div>
	                            </div>
	                            <img class="img-fluid" src="/images/game4.jpg" alt="..." />
	                        </a>
	                        <div class="portfolio-caption">
	                            <div class="portfolio-caption-heading">게임4</div>
	                            <div class="portfolio-caption-subheading text-muted">게임 내용</div>
	                        </div>
	                    </div>
	                </div>
	                <div class="col-lg-4 col-sm-6 mb-4 mb-sm-0">
	                    <div class="portfolio-item">
	                        <a class="portfolio-link" data-bs-toggle="modal" href="#portfolioModal5">
	                            <div class="portfolio-hover">
	                                <div class="portfolio-hover-content"><i class="fas fa-plus fa-3x"></i></div>
	                            </div>
	                            <img class="img-fluid" src="/images/game5.jpg" alt="..." />
	                        </a>
	                        <div class="portfolio-caption">
	                            <div class="portfolio-caption-heading">게임5</div>
	                            <div class="portfolio-caption-subheading text-muted">게임 내용</div>
	                        </div>
	                    </div>
	                </div>
	                <div class="col-lg-4 col-sm-6">
	                    <div class="portfolio-item">
	                        <a class="portfolio-link" data-bs-toggle="modal" href="#portfolioModal6">
	                            <div class="portfolio-hover">
	                                <div class="portfolio-hover-content"><i class="fas fa-plus fa-3x"></i></div>
	                            </div>
	                            <img class="img-fluid" src="/images/game6.jpg" alt="..." />
	                        </a>
	                        <div class="portfolio-caption">
	                            <div class="portfolio-caption-heading">게임6</div>
	                            <div class="portfolio-caption-subheading text-muted">게임 내용</div>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </section>
	    <!-- 전체 헤더-->
	    <section class="page-section bg-light" id="portfolio">
	        <div class="container" id="p3">
	            <div class="text-center">
	                <h2 class="section-heading text-uppercase">whole games</h2>
	                <h3 class="section-subheading text-muted">전체 게임 목록입니다.</h3>
	            </div>
	             <div class="row d-flex flex-row-reverse">
	            	<div class="col-lg-3 text-end">
						<a class="btn btn-primary btn-xl text-uppercase" href="#mainNav">더보기</a>
	            	</div>
	            </div>
	            <div class="row">
	                <div class="col-lg-4 col-sm-6 mb-4">
	                    <!-- 전체 목록 -->
	                    <div class="portfolio-item">
	                        <a class="portfolio-link" data-bs-toggle="modal" href="#portfolioModal1">
	                            <div class="portfolio-hover">
	                                <div class="portfolio-hover-content"><i class="fas fa-plus fa-3x"></i></div>
	                            </div>
	                            <img class="img-fluid" src="/images/game1.jpg" alt="..." />
	                        </a>
	                        <div class="portfolio-caption">
	                            <div class="portfolio-caption-heading">게임1</div>
	                            <div class="portfolio-caption-subheading text-muted">게임 내용</div>
	                        </div>
	                    </div>
	                </div>
	                <div class="col-lg-4 col-sm-6 mb-4">
	                    <div class="portfolio-item">
	                        <a class="portfolio-link" data-bs-toggle="modal" href="#portfolioModal2">
	                            <div class="portfolio-hover">
	                                <div class="portfolio-hover-content"><i class="fas fa-plus fa-3x"></i></div>
	                            </div>
	                            <img class="img-fluid" src="/images/game2.jpg" alt="..." />
	                        </a>
	                        <div class="portfolio-caption">
	                            <div class="portfolio-caption-heading">게임2</div>
	                            <div class="portfolio-caption-subheading text-muted">게임 내용</div>
	                        </div>
	                    </div>
	                </div>
	                <div class="col-lg-4 col-sm-6 mb-4">
	                    <div class="portfolio-item">
	                        <a class="portfolio-link" data-bs-toggle="modal" href="#portfolioModal3">
	                            <div class="portfolio-hover">
	                                <div class="portfolio-hover-content"><i class="fas fa-plus fa-3x"></i></div>
	                            </div>
	                            <img class="img-fluid" src="/images/game3.jpg" alt="..." />
	                        </a>
	                        <div class="portfolio-caption">
	                            <div class="portfolio-caption-heading">게임3</div>
	                            <div class="portfolio-caption-subheading text-muted">게임 내용</div>
	                        </div>
	                    </div>
	                </div>
	                <div class="col-lg-4 col-sm-6 mb-4 mb-lg-0">
	                    <div class="portfolio-item">
	                        <a class="portfolio-link" data-bs-toggle="modal" href="#portfolioModal4">
	                            <div class="portfolio-hover">
	                                <div class="portfolio-hover-content"><i class="fas fa-plus fa-3x"></i></div>
	                            </div>
	                            <img class="img-fluid" src="/images/game4.jpg" alt="..." />
	                        </a>
	                        <div class="portfolio-caption">
	                            <div class="portfolio-caption-heading">게임4</div>
	                            <div class="portfolio-caption-subheading text-muted">게임 내용</div>
	                        </div>
	                    </div>
	                </div>
	                <div class="col-lg-4 col-sm-6 mb-4 mb-sm-0">
	                    <div class="portfolio-item">
	                        <a class="portfolio-link" data-bs-toggle="modal" href="#portfolioModal5">
	                            <div class="portfolio-hover">
	                                <div class="portfolio-hover-content"><i class="fas fa-plus fa-3x"></i></div>
	                            </div>
	                            <img class="img-fluid" src="/images/game5.jpg" alt="..." />
	                        </a>
	                        <div class="portfolio-caption">
	                            <div class="portfolio-caption-heading">게임5</div>
	                            <div class="portfolio-caption-subheading text-muted">게임 내용</div>
	                        </div>
	                    </div>
	                </div>
	                <div class="col-lg-4 col-sm-6">
	                    <div class="portfolio-item">
	                        <a class="portfolio-link" data-bs-toggle="modal" href="#portfolioModal6">
	                            <div class="portfolio-hover">
	                                <div class="portfolio-hover-content"><i class="fas fa-plus fa-3x"></i></div>
	                            </div>
	                            <img class="img-fluid" src="/images/game6.jpg" alt="..." />
	                        </a>
	                        <div class="portfolio-caption">
	                            <div class="portfolio-caption-heading">게임6</div>
	                            <div class="portfolio-caption-subheading text-muted">게임 내용</div>
	                        </div>
	                    </div>
	                    <nav aria-label="Page navigation example">
	                    	<br>
	                    </nav>
	                </div>
	            </div>
	        </div>
	    </section>
	    <!-- Portfolio Modals-->
	    <div class="portfolio-modal modal fade" id="portfolioModal1" tabindex="-1" role="dialog" aria-hidden="true">
	        <div class="modal-dialog">
	            <div class="modal-content">
	                <div class="close-modal" data-bs-dismiss="modal"><img src="assets/img/close-icon.svg" alt="Close modal" /></div>
	                <div class="container">
	                    <div class="row justify-content-center">
	                        <div class="col-lg-8">
	                            <div class="modal-body">
	                                <h2 class="text-uppercase">게임 1</h2>
	                                <p class="item-intro text-muted">전략 시뮬레이션 게임</p>
	                                <img class="img-fluid d-block mx-auto" src="/images/game1.jpg" alt="..." />
	                                <p>간단 설명</p>
	                                <button class="btn btn-primary btn-xl text-uppercase" data-bs-dismiss="modal" type="button">
	                                    <i class="fas fa-xmark me-1"></i>
	                                    닫기
	                                </button>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>
	    <div class="portfolio-modal modal fade" id="portfolioModal2" tabindex="-1" role="dialog" aria-hidden="true">
	        <div class="modal-dialog">
	            <div class="modal-content">
	                <div class="close-modal" data-bs-dismiss="modal"><img src="assets/img/close-icon.svg" alt="Close modal" /></div>
	                <div class="container">
	                    <div class="row justify-content-center">
	                        <div class="col-lg-8">
	                            <div class="modal-body">
	                                <h2 class="text-uppercase">게임 2</h2>
	                                <p class="item-intro text-muted">전략 시뮬레이션 게임</p>
	                                <img class="img-fluid d-block mx-auto" src="/images/game2.jpg" alt="..." />
	                                <p>간단 설명</p>
	                                <button class="btn btn-primary btn-xl text-uppercase" data-bs-dismiss="modal" type="button">
	                                    <i class="fas fa-xmark me-1"></i>
	                                    닫기
	                                </button>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>
	    <div class="portfolio-modal modal fade" id="portfolioModal3" tabindex="-1" role="dialog" aria-hidden="true">
	        <div class="modal-dialog">
	            <div class="modal-content">
	                <div class="close-modal" data-bs-dismiss="modal"><img src="assets/img/close-icon.svg" alt="Close modal" /></div>
	                <div class="container">
	                    <div class="row justify-content-center">
	                        <div class="col-lg-8">
	                            <div class="modal-body">
	                                <h2 class="text-uppercase">게임 3</h2>
	                                <p class="item-intro text-muted">전략 시뮬레이션 게임</p>
	                                <img class="img-fluid d-block mx-auto" src="/images/game3.jpg" alt="..." />
	                                <p>간단 설명</p>
	                                <button class="btn btn-primary btn-xl text-uppercase" data-bs-dismiss="modal" type="button">
	                                    <i class="fas fa-xmark me-1"></i>
	                                    닫기
	                                </button>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>
	    <div class="portfolio-modal modal fade" id="portfolioModal4" tabindex="-1" role="dialog" aria-hidden="true">
	        <div class="modal-dialog">
	            <div class="modal-content">
	                <div class="close-modal" data-bs-dismiss="modal"><img src="assets/img/close-icon.svg" alt="Close modal" /></div>
	                <div class="container">
	                    <div class="row justify-content-center">
	                        <div class="col-lg-8">
	                            <div class="modal-body">
	                                <h2 class="text-uppercase">게임 4</h2>
	                                <p class="item-intro text-muted">전략 시뮬레이션 게임</p>
	                                <img class="img-fluid d-block mx-auto" src="/images/game4.jpg" alt="..." />
	                                <p>간단 설명</p>
	                                <button class="btn btn-primary btn-xl text-uppercase" data-bs-dismiss="modal" type="button">
	                                    <i class="fas fa-xmark me-1"></i>
	                                    닫기
	                                </button>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>
	    <div class="portfolio-modal modal fade" id="portfolioModal5" tabindex="-1" role="dialog" aria-hidden="true">
	        <div class="modal-dialog">
	            <div class="modal-content">
	                <div class="close-modal" data-bs-dismiss="modal"><img src="assets/img/close-icon.svg" alt="Close modal" /></div>
	                <div class="container">
	                    <div class="row justify-content-center">
	                        <div class="col-lg-8">
	                            <div class="modal-body">
	                                <h2 class="text-uppercase">게임 5</h2>
	                                <p class="item-intro text-muted">전략 시뮬레이션 게임</p>
	                                <img class="img-fluid d-block mx-auto" src="/images/game5.jpg" alt="..." />
	                                <p>간단 설명</p>
	                                <button class="btn btn-primary btn-xl text-uppercase" data-bs-dismiss="modal" type="button">
	                                    <i class="fas fa-xmark me-1"></i>
	                                    닫기
	                                </button>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>
	    <div class="portfolio-modal modal fade" id="portfolioModal6" tabindex="-1" role="dialog" aria-hidden="true">
	        <div class="modal-dialog">
	            <div class="modal-content">
	                <div class="close-modal" data-bs-dismiss="modal"><img src="assets/img/close-icon.svg" alt="Close modal" /></div>
	                <div class="container">
	                    <div class="row justify-content-center">
	                        <div class="col-lg-8">
	                            <div class="modal-body">
	                                <h2 class="text-uppercase">게임 6</h2>
	                                <p class="item-intro text-muted">전략 시뮬레이션 게임</p>
	                                <img class="img-fluid d-block mx-auto" src="/images/game6.jpg" alt="..." />
	                                <p>간단 설명</p>
	                                <button class="btn btn-primary btn-xl text-uppercase" data-bs-dismiss="modal" type="button">
	                                    <i class="fas fa-xmark me-1"></i>
	                                    닫기
	                                </button>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </div>
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