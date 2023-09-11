<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	request.setCharacterEncoding("utf-8");
	
	//검색 조건을 유지하기 위해 파라미터 저장
	String sort = "yearpublished";
	String genre = "";
	String players = "";
	String stx = "";
	
	if( request.getParameter("sort") != null ){
		sort = request.getParameter("sort");
	}
	if( request.getParameter("genre") != null ){
		genre = request.getParameter("genre");
	}
	if( request.getParameter("players") != null ){
		players = request.getParameter("players");
	}
	if( request.getParameter("stx") != null ){
		stx = request.getParameter("stx");
	}

	boolean chkSearch = (boolean)request.getAttribute("chkSearch");
	ArrayList<BoardgameTO> lists = (ArrayList)request.getAttribute("lists");
	
	StringBuilder sbHtml = new StringBuilder();
	for(BoardgameTO gameInfo : lists){		
		sbHtml.append("<div class='col-lg-2 col-sm-6 mb-4'>");
		sbHtml.append("		<div class='portfolio-item'>");
		sbHtml.append("			<div class='image-container text-center'>");
		sbHtml.append("				<a href='gameView?seq="+ gameInfo.getSeq() +"'>");
		sbHtml.append("					<img class='img-fluid game_img w-100 shadow-1-strong' src="+  gameInfo.getImageUrl() +" alt='...'>");
		sbHtml.append("				</a>");	
		sbHtml.append("			</div>");
		sbHtml.append(" 		<div class='caption'>");
		sbHtml.append("				<div id='gameTitle'>"+ gameInfo.getTitle() +"</div>");
		sbHtml.append("			</div>");
		sbHtml.append("		</div>");
		sbHtml.append("</div>");
	}
%>
<!doctype html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
 		<link rel="stylesheet" href="assets/css/style.css" />
		
		<!-- Font Awesome icons (free version)-->
	    <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
	    <!-- Google fonts-->
	    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700" rel="stylesheet" type="text/css" />
	    <link href="https://fonts.googleapis.com/css?family=Roboto+Slab:400,100,300,700" rel="stylesheet" type="text/css" />
		
	    <script type="text/javascript">	    
		    $(document).ready(function() {
	            var topBtn = $("#topBtn");
	            
	            $(window).scroll(function() {
	                if ($(window).scrollTop() > 20) {
	                	topBtn.show();
	                } else {
	                	topBtn.hide();
	                }
	            });
        	});
		    
			function topFunction() {
				document.body.scrollTop = 0; // For Safari
				document.documentElement.scrollTop = 0; // For Chrome, Firefox, IE and Opera
			}
	    </script>
		
		<style type="text/css">
		    
		    /* 전체 버튼 */
		    .btn {
				border-radius: 3px;
				-webkit-box-shadow: none;
				box-shadow: none;
				border: 1px solid transparent;
			}
		    
		   	/* 선택되지 않은 버튼 */
		    .btn-default {
				background-color: #f4f4f4;
				color: #444444;
				border-color: #ddd;
			}
 										
	        #list-wrap {
			    width: 100%;
			    display: flex;
			    flex-direction: column;
			    gap: 20px;
			}
	        
			#result {
			    background-color: #fff;
			    padding: 10px 20px;
			    border-radius: 12px;
			    box-shadow: 0 2px 30px 0 rgba(0, 0, 0, 0.06);
			}
			
			.portfolio-item{
				text-align: center;
			}
					    
		    .game_img {
			    max-width:200px;
			    max-height:200px;
			    object-fit: cover;		    
			} 
			
			#gameTitle{
				display: block;
				white-space: nowrap;
				overflow: hidden;
				text-overflow: ellipsis;
				
				font-weight: 700;
				
				max-width:200px;
			  	padding: 1.5rem;
			  	margin: 0 auto;
			  	background-color: #fff;
			}
		</style>
	</head>
	<body>
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="top-margin py-5 backg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title">보드게임 검색</h1>
					<p class="lead fw-normal text-white-50 mb-0">Boardgame Search</p>
				</div>
			</div>
		</header>
		<main style="gap: 20px;">
			<div id="content_wrapper"  class="content-wrapper">
				<!--  검색 조건 블록 -->
				<div style="text-align:center;">
					<div class="list-tsearch" >
						<div class="container-fluid py-5 bg-light" style="border-radius: 1em" >
							<div class="container-fluid d-flex justify-content-center">
								<form name="fhsearch" method="get" role="form" class="form" action="gameSearch">
									<!--  Data Transfer Line -->
									<input type="hidden" name="sort" value="yearpublished">	<!-- 정렬 기본값 최신순 -->
									<input type="hidden" name="genre" value="">
									<input type="hidden" name="players" value="">
									
									<table width="100%" class="table-responsive">
										<tbody>
											<tr>
												<th width="50">이름</th>
												<td>
													<input type="text" name="stx" value="<%=stx %>" id="stx" class="form-control input-sm" maxlength="20" placeholder="검색어 입력...">
												</td>
											</tr>
											<tr>
								                <th>인원</th>
								                <td id="players">
													<span class="btn button-primary btn-xs s-players s-all" data-value="">전체</span>
													<span class="btn btn-default btn-xs s-players" data-value="2">2인</span>
		                                            <span class="btn btn-default btn-xs s-players" data-value="3">3인</span>
		                                            <span class="btn btn-default btn-xs s-players" data-value="4">4인</span>
		                                            <span class="btn btn-default btn-xs s-players" data-value="5">5인</span>
		                                            <span class="btn btn-default btn-xs s-players" data-value="6">6인 이상</span>
												</td>
											</tr>
											<tr>
								                <th>장르</th>
								                <td id="genre">
			                    					<span class="btn button-primary btn-xs s-genre s-all" data-value="">전체</span>
		                                            <span class="btn btn-default btn-xs s-genre" data-value="전략">전략</span>
		                                            <span class="btn btn-default btn-xs s-genre" data-value="두뇌">두뇌</span>
		                                            <span class="btn btn-default btn-xs s-genre" data-value="순발력">순발력</span>
		                                            <span class="btn btn-default btn-xs s-genre" data-value="가족">가족</span>
		                                            <span class="btn btn-default btn-xs s-genre" data-value="카드">카드</span>                                            
								                </td>
								            </tr>
											<tr>
								           		
							            	</tr>
											<tr>
								                <th>정렬</th>
								                <td id="sort">
								                    <span class="btn button-primary btn-xs s-sort" data-value="yearpublished">최신순</span>
								                    <span class="btn btn-default btn-xs s-sort" data-value="hit">조회수</span>
								                    <span class="btn btn-default btn-xs s-sort" data-value="recCnt">추천순</span>
								                </td>
								            </tr>
											<tr>
								                <td colspan="3" style="text-align: center">
								                    <button id="sbtn" class="btn btn-dark btn-sm" style="width: 100%;" type="submit">검색</button>
								                </td>
								            </tr>
			        					</tbody>
			        				</table>
						    	</form>
						    </div>
					    </div>
					</div> 
				</div>
								
				<!-- 버튼 이벤트 -->
				<script type="text/javascript" >								
					// 정렬 버튼
					var sorts = document.querySelectorAll('span.s-sort');
					
					[].forEach.call(sorts, function(sort){
						  sort.addEventListener("click" , sortClick , false );
					});
				
					function sortClick(e) {
						var selectedButton = e.target;
						var data = selectedButton.getAttribute('data-value');
						
						 // 어떤정렬인지 알려주기 위한 data를 input[name=sort]로 값을 보내주어야 함.		 
						 document.querySelector('input[name=sort]').value = data;
						 
						 // 버튼 선택을 표현하기 위해 버튼클래스 변경
						 sorts.forEach(function(i) {
							 i.classList.replace('button-primary', 'btn-default');
						 });
				
						 selectedButton.classList.add('button-primary');
						 selectedButton.classList.remove('btn-default');
					}
					
					// 장르 버튼
					var genres = document.querySelectorAll('span.s-genre');
					
					[].forEach.call(genres, function(genre) {
						  genre.addEventListener("click" , genreClick , false );
					});
					
					function genreClick(e){
						var selectedGenre = [];
						var allButton = document.querySelector('span.s-genre.s-all');
						// (전체) 버튼
						var selectedButton = e.target;
						var data = selectedButton.getAttribute('data-value');
						
						if(data == ''){
							// (전체) 버튼 클릭시
							genres.forEach(function(i){
								i.classList.replace('button-primary', 'btn-default');
							});
							selectedButton.classList.remove('btn-default');
							selectedButton.classList.add('button-primary');
							document.querySelector('input[name=genre]').value = '';			
				
						} else{	
							// (전체) 이외의 버튼 클릭시			
							allButton.classList.remove('button-primary');
							// (전체) 버튼 비활성화
							allButton.classList.add('btn-default');
							
							selectedButton.classList.toggle('button-primary');
							// 선택된 버튼 반대 상태로 전환
							selectedButton.classList.toggle('btn-default');
				
							// 선택된 장르 값들 저장.
							selectedButtons = document.querySelectorAll('span.s-genre.button-primary');
							selectedButtons.forEach(function(i){
								if(i.getAttribute('data-value') == ''){
									return true;
								}
								selectedGenre.push(i.getAttribute('data-value'));
							});
							
							if(selectedGenre.length == 0){
								// 선택된 버튼이 없으면, (전체) 버튼 활성화
								allButton.classList.replace('btn-default', 'button-primary');
								document.querySelector('input[name=genre]').value = '';			
							} else {
								document.querySelector('input[name=genre]').value = selectedGenre.join(',');
							}
						}
					}
					// 인원 버튼
					var players = document.querySelectorAll('span.s-players');
					
					[].forEach.call(players, function(player){
						player.addEventListener("click" , playersClick , false );
					});
					
					function playersClick(e){
						var selectedPlayers = [];
						var allButton = document.querySelector('span.s-players.s-all');
						// (전체) 버튼
						var selectedButton = e.target;
						var data = selectedButton.getAttribute('data-value');
						
						if(data == ''){	
							// (전체) 버튼 클릭시
							players.forEach(function(i){
								 i.classList.replace('button-primary', 'btn-default');
							});
							selectedButton.classList.remove('btn-default');
							selectedButton.classList.add('button-primary');
							
							// input[name=players]에 전체값 저장
							document.querySelector('input[name=players]').value = '';	
						} else {
							// (전체) 이외의 버튼 클릭시			
							allButton.classList.remove('button-primary');
							// (전체) 버튼 비활성화
							allButton.classList.add('btn-default');
							
							selectedButton.classList.toggle('button-primary');
							// 선택된 버튼 반대 상태로 전환
							selectedButton.classList.toggle('btn-default');
				
							// 선택된 인원 값들 저장.
							selectedButtons = document.querySelectorAll('span.s-players.button-primary');
							selectedButtons.forEach(function(i){
								if(i.getAttribute('data-value') == ''){
									return true;
								}
								selectedPlayers.push(i.getAttribute('data-value'));
							});
							
							if(selectedPlayers.length == 0){
								// 선택된 버튼이 없으면, (전체) 버튼 활성화
								allButton.classList.replace('btn-default', 'button-primary');
							
								// input[name=players]에 전체값 저장
								document.querySelector('input[name=players]').value = '';			
							} else {
								// 선택된 값들 input[name=players]에 저장
								document.querySelector('input[name=players]').value = selectedPlayers.join(',');	
							}
						}
					}
					
					// 검색 버튼 클릭 시 검색결과로 스크롤 이동
					window.onload = function() {
						
						if(<%=chkSearch%>){
							const targetPosition = 500; // 스크롤할 위치 (픽셀 단위로 지정)
							
						    // 스크롤 이동 애니메이션 설정 (optional)
						    const scrollOptions = {
						        top: targetPosition,
						        behavior: 'smooth' // 부드럽게 스크롤
						    };
				
						    // 스크롤 이동 실행
						    window.scrollTo(scrollOptions);
						}
						
					}
				</script>
				
				<!-- 검색 조건 유지 -->
				<script type="text/javascript">
					
					// 정렬 조건 유지
					function keepSort(){
						var searchedSort = "<%=sort%>";	// 이전에 검색했던 정렬 조건 값
						var sorts = document.querySelectorAll('span.s-sort');
																
						// 버튼 초기화 ( 모든 정렬 버튼이 선택되지 않은 상태 )
						document.querySelector('span.s-sort.button-primary').classList.replace('button-primary', 'btn-default');
						
						sorts.forEach(function(i){
							var data = i.getAttribute('data-value');
							
							if(data == searchedSort){
								// 선택된 버튼 표현
								i.classList.add('button-primary');
								i.classList.remove('btn-default');
							}
						});
						
						// 어떤정렬인지 알려주기 위한 data를 input[name=sort]로 값을 보내주어야 함.		 
						document.querySelector('input[name=sort]').value = searchedSort;
					}
					
					// 인원 조건 유지
					function keepPlayers(){
						var searchedPlayers = "<%=players%>".split(',');	// 이전에 검색했던 인원 조건 값
						var players = document.querySelectorAll('span.s-players');

						// 버튼 초기화 ( 모든 정렬 버튼이 선택되지 않은 상태 )
						document.querySelector('span.s-players.button-primary').classList.replace('button-primary', 'btn-default');

						players.forEach(function(i){
							var data = i.getAttribute('data-value');

							searchedPlayers.forEach(function(j){
								if(data == j){
									// 선택된 버튼 표현
									i.classList.add('button-primary');
									i.classList.remove('btn-default');
								}
							});							
						});
						
						// 선택된 값들 input[name=players]에 저장
						document.querySelector('input[name=players]').value = searchedPlayers.join(',');
					}
					
					// 장르 조건 유지
					function keepGenre(){
						var searchedGenre = "<%=genre%>".split(',');	// 이전에 검색했던 장르 조건 값
						var genres = document.querySelectorAll('span.s-genre');

						// 버튼 초기화 ( 모든 정렬 버튼이 선택되지 않은 상태 )
						document.querySelector('span.s-genre.button-primary').classList.replace('button-primary', 'btn-default');

						genres.forEach(function(i){
							var data = i.getAttribute('data-value');

							searchedGenre.forEach(function(j){
								if(data == j){

									// 선택된 버튼 표현
									i.classList.add('button-primary');
									i.classList.remove('btn-default');
								}
							});							
						});
						
						// 선택된 값들 input[name=genre]에 저장
						document.querySelector('input[name=genre]').value = searchedGenre.join(',');
					}
					
					keepGenre();				
					keepPlayers();
					keepSort();
				</script>
				
				<!-- 조건에 맞는 게임 리스트 -->				
				<section class="page-section bg-light" id="portfolio">
			        <div class="container" id="p1">
			            <div class="text-center">
			                <h2 class="searchResult section-heading text-uppercase">검색 결과</h2>
			                <h3 class="section-subheading text-muted"></h3>
			            </div>
			            
			            <div class="row">
			            	 	            
			           		<%=sbHtml %>
			                    
			            </div>
			        </div>
	   		 	</section>				
			</div>
		</main>
		<footer>
	    	<!-- 최하단 디자인 영역 -->
		</footer>
		<button type='button' class='btn btn-dark' id="topBtn" onclick="topFunction()"><i class="bi bi-arrow-up-circle"></i></button>
		<script>
			window.onload = function() {
	    		$("#topBtn").hide();
	    	}
		</script>
	</body>
</html>