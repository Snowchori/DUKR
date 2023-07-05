<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<!doctype html>
<html>

<!-- java 영역 -->
<%
	request.setCharacterEncoding("utf-8");
	ArrayList<Map<String, String>> lists = (ArrayList)request.getAttribute("lists");
	
	StringBuilder sbHtml = new StringBuilder();
	for(Map<String, String> gameInfo : lists){
		
		sbHtml.append("<div class='col-lg-2 mb-4 mb-lg-0'>");
		sbHtml.append("<a href='gameView?seq="+ gameInfo.get("gameId") +"'>");
		sbHtml.append("    <img");
		sbHtml.append("      src=" + gameInfo.get("thumbnail") + "");
		sbHtml.append("      class='w-100 shadow-1-strong rounded mb-4'");
		sbHtml.append("    />");
		sbHtml.append("</div>");
	}
%>
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
  
	<style type="text/css">
		
		
		
		
	    .list-tsearch {
			display:inline-block;
	    }
	
	    .list-tsearch table {
	        border: none;
	    }
	
	    .list-tsearch table td, .list-tsearch table th {
	    	width: min-content;
	        padding: 3px 5px;
	        line-height: 30px;
	    }
	    
	    
	    .list-tsearch th {
			text-align:center;
		}
	    .list-tsearch .btn-danger {
	        color: #ffffff;
	    }
	    
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
		
		#content_wrapper {
		    width: 100%;
		    display: flex;
		    flex-direction: column;
		    gap: 20px;
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
		
		
		/* photoList */
    #gameList .items {
        gap: 20px;
    }
    
    #gameList .item {
        display: flex;
        flex-direction: column;
        border-radius: 8px;
        background-color: #fff;
        box-shadow: var(--box-shadow);
    }
    
    [data-theme='dark'] #photoList .item {
        color: rgba(255, 255, 255, 0.7);
        background-color: rgba(255, 255, 255, 0.1);
    }
    
    #gameList .item .image {
        position: relative;
        width: 100%;
        padding-bottom: 78.43%;
    }
    
    #gameList .item .image img {
        position: absolute;
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-top-left-radius: 8px;
        border-top-right-radius: 8px;
    }
    
    #gameList .item .image .none {
        position: absolute;
        width: 100%;
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 0.9em;
        color: #C4C4C7;
        background-color: #F5F6F9;
        border-top-left-radius: 8px;
        border-top-right-radius: 8px;
    }
    
    #gameList .item .info {
        display: flex;
        flex-direction: column;
        gap: 6px;
        padding: 20px;
        border-bottom-left-radius: 8px;
        border-bottom-right-radius: 8px;
    }
    
    #gameList .item .info .title {
        display: -webkit-box;
        -webkit-line-clamp: 1;
        -webkit-box-orient: vertical;
        overflow: hidden;
        text-overflow: ellipsis;
        word-break: break-all;
    }
    
    #gameList .item .info .etc {
        display: flex;
        justify-content: space-between;
        gap: 10px;
        color: var(--second-color);
        font-size: 0.8em;
    }
    
    #gameList .item .info .etc .nickName {
        width: 100%;
    }
    
    #gameList .item .info .etc .nickName .text {
        width: 100%;
        display: -webkit-box;
        -webkit-line-clamp: 1;
        -webkit-box-orient: vertical;
        overflow: hidden;
        text-overflow: ellipsis;
        word-break: break-all;
    }
    
}
		
	</style>

  <!-- 자바 스크립트 영역 -->
	<script type="text/javascript">
	window.onload = function() {
		document.getElementById( 'sbtn' ).onclick = function() {


			if( document.fhsearch.stx.value.trim() == '' ) {
				alert( '1자 이상 입력해주세요.' );
				return false;
			}
			document.fhsearch.submit();
		};
	};
	</script>
</head>

<body>
<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
  
  <main style="gap: 20px;">

<div id="content_wrapper"  class="content-wrapper">


<!--  검색 조건 블록 -->
<div style="text-align:center;">
	<div class="list-tsearch" >
		<div class="container-fluid py-5 bg-light" style="border-radius: 1em" >
			<div class="container-fluid d-flex justify-content-center">
			<form name="fhsearch" method="get" role="form" class="form" action="gameSearch">
		
		<!--  Data Transfer Line -->
				<input type="hidden" name="sort" value="">	<!-- 정렬 기본값 최신순 -->
				<input type="hidden" name="genre" value="">
				<input type="hidden" name="players" value="">
				
		        <table width="100%" class="table-responsive">
		            <tbody>
		            
		            <tr>
		                <th width="50">이름</th>
		                
		                <td>
		                    <input type="text" name="stx" value="" id="stx" class="form-control input-sm" maxlength="20" placeholder="검색어 입력...">
		                </td>
		                
		                
		            </tr>


		            <tr>
		                <th>인원</th>
		                <td id="players">
		                    <span class="btn btn-danger btn-xs s-players s-all" data-value="">전체</span>
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
		                    <span class="btn btn-danger btn-xs s-genre s-all" data-value="">전체</span>
		                                            <span class="btn btn-default btn-xs s-genre" data-value="전략">전략</span>
		                                            <span class="btn btn-default btn-xs s-genre" data-value="두뇌">두뇌</span>
		                                            <span class="btn btn-default btn-xs s-genre" data-value="순발력">순발력</span>
		                                            <span class="btn btn-default btn-xs s-genre" data-value="가족">가족</span>
		                                            <span class="btn btn-default btn-xs s-genre" data-value="카드">카드</span>                                            
		                </td>
		            </tr>
		            
		            <tr>
		           		<th>튜토리얼</th>
		           		<td>
			            	<div class="form-check">	            		
								<input class="form-check-input" type="checkbox" value="" id="check-tutorial" />
							</div>
						</td>
		            </tr>
		            
		            <tr>
		                <th>정렬</th>
		                <td id="sort">
		                    <span class="btn btn-danger btn-xs s-sort" data-value="yearpublished">최신순</span>
		                    <span class="btn btn-default btn-xs s-sort" data-value="hit">조회수</span>
		                    <span class="btn btn-default btn-xs s-sort" data-value="recCtn">추천순</span>
		                    <span class="btn btn-default btn-xs s-sort" data-value="difficulty">난이도순</span>
		                </td>
		            </tr>
		            <tr>
		            	<td/>
		                <td colspan="3" style="text-align: center">
		                    <button id="sbtn" class="btn btn-sm btn-primary" style="width: 100%;" type="submit">검색</button>
		                </td>
		            </tr>
		        </tbody></table>
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

	function sortClick(e){
		var selectedButton = e.target;
		var data = selectedButton.getAttribute('data-value');
		
		 // 어떤정렬인지 알려주기 위한 data를 input[name=sst]로 값을 보내주어야 함.		 
		 document.querySelector('input[name=sort]').value = data;
		 
		 // 버튼 선택을 표현하기 위해 버튼클래스 변경
		 sorts.forEach(function(i){
			 i.classList.replace('btn-danger', 'btn-default');
		 });

		 selectedButton.classList.add('btn-danger');
		 selectedButton.classList.remove('btn-default');

	}
	
	// 장르 버튼
	var genres = document.querySelectorAll('span.s-genre');
	
	[].forEach.call(genres, function(genre){
		  genre.addEventListener("click" , genreClick , false );
	});
	
	function genreClick(e){
		var selectedGenre = [];
		var allButton = document.querySelector('span.s-genre.s-all');	// (전체) 버튼
		var selectedButton = e.target;
		var data = selectedButton.getAttribute('data-value');
		
		if(data == ''){		// (전체) 버튼 클릭시
			genres.forEach(function(i){
				 i.classList.replace('btn-danger', 'btn-default');
			 });
			selectedButton.classList.remove('btn-default');
			selectedButton.classList.add('btn-danger');
			document.querySelector('input[name=genre]').value = '';			

		}
		
		else{				// (전체) 이외의 버튼 클릭시			
			allButton.classList.remove('btn-danger');	// (전체) 버튼 비활성화
			allButton.classList.add('btn-default');
			
			selectedButton.classList.toggle('btn-danger');	// 선택된 버튼 반대 상태로 전환
			selectedButton.classList.toggle('btn-default');

			// 선택된 장르 값들 저장.
			selectedButtons = document.querySelectorAll('span.s-genre.btn-danger');
			selectedButtons.forEach(function(i){
				if(i.getAttribute('data-value') == ''){
					return true;
				}
				selectedGenre.push(i.getAttribute('data-value'));
			});
			
			if(selectedGenre.length == 0){	// 선택된 버튼이 없으면, (전체) 버튼 활성화
				allButton.classList.replace('btn-default', 'btn-danger');
				document.querySelector('input[name=genre]').value = '';			
			} 
			
			else{
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
		var allButton = document.querySelector('span.s-players.s-all');	// (전체) 버튼
		var selectedButton = e.target;
		var data = selectedButton.getAttribute('data-value');
		
		if(data == ''){		// (전체) 버튼 클릭시
			players.forEach(function(i){
				 i.classList.replace('btn-danger', 'btn-default');
			 });
			selectedButton.classList.remove('btn-default');
			selectedButton.classList.add('btn-danger');
			
			// input[name=headcount]에 전체값 저장
			document.querySelector('input[name=players]').value = '';	
		}
		
		else{				// (전체) 이외의 버튼 클릭시			
			allButton.classList.remove('btn-danger');	// (전체) 버튼 비활성화
			allButton.classList.add('btn-default');
			
			selectedButton.classList.toggle('btn-danger');	// 선택된 버튼 반대 상태로 전환
			selectedButton.classList.toggle('btn-default');

			// 선택된 인원 값들 저장.
			selectedButtons = document.querySelectorAll('span.s-players.btn-danger');
			selectedButtons.forEach(function(i){
				if(i.getAttribute('data-value') == ''){
					return true;
				}
				selectedPlayers.push(i.getAttribute('data-value'));
			});
			
			if(selectedPlayers.length == 0){	// 선택된 버튼이 없으면, (전체) 버튼 활성화
				allButton.classList.replace('btn-default', 'btn-danger');
			
				// input[name=headcount]에 전체값 저장
				document.querySelector('input[name=players]').value = '';			
			}
			
			else{
				// 선택된 값들 input[name=headcount]에 저장
				document.querySelector('input[name=players]').value = selectedPlayers.join(',');	
			}
		}
	}
	   

  </script>

	<!-- 조건에 맞는 게임 리스트 -->
	
	<div id="list-wrap" class="container-fluid">
		<section id="result">
	        <h1 style="font-family: 'Noto Sans KR';">검색결과</h1>
	    </section>
	    
	    
	    
		<section id="gameList">
			<div class="items container-fluid">
			
			<!-- Gallery -->
				<div class='row'>
					<%=sbHtml %>
				</div>
			<!-- Gallery -->
			
				
				
			</div>
			
			
			
		</section>
	
	</div>
	
</div>
 
 
  </main>
  <footer>
    <!-- 최하단 디자인 영역 -->
  </footer>
</body>

</html>