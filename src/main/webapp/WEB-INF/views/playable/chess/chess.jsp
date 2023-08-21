<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
<script type="text/javascript">
	window.onload = function(){
		
		const socket = new WebSocket('ws://localhost:8080/chess');
		
		// 매칭버튼
		$('#matchBtn').on('click', function(){
			$('#matchBtn').text('상대를 찾고 있습니다');
			socket.send('match request');	
		});
		
		// 웹소켓 수신
		socket.onmessage = function(event){
			const opponent = event.data;
			$('#opponent').val(opponent);
			
			// 수신한 정보가 흑/백 진영 배정 정보일 경우
			if(event.data.split('@')[0] == 'camp'){
				$('#startingComponents').css({
					'display': 'none'
				})
				
				const myCamp = event.data.split('@')[1];
				$('#myCamp').val(myCamp);
				
				// 흑/백에 따른 체스보드 랜더링
				let strBoardRenderer = "<table>";
				if(myCamp == 'black'){
					for(let i=1; i<=8; i++){
						strBoardRenderer += '<tr>';
						for(let j=8; j>=1; j--){
							let locID = 'l' + (i*10 + j);
							strBoardRenderer += '<td id="' + locID + '"></td>';
						}
						strBoardRenderer += '</tr>';
					}
				}else if(myCamp == 'white'){
					for(let i=8; i>=1; i--){
						strBoardRenderer += '<tr>';
						for(let j=1; j<=8; j++){
							let locID = 'l' + (i*10 + j);
							strBoardRenderer += '<td id="' + locID + '"></td>';
						}
						strBoardRenderer += '</tr>';
					}
				}
				strBoardRenderer += '</table>';
				
				var newChessBoard = $(strBoardRenderer);
				$("#chessBoardContainer").append(newChessBoard);
			}
			
			// 수신한 정보가 보드상태 정보일 경우
			if(event.data.split('@')[0] == 'turn'){
				const turn = JSON.parse(event.data.split('@')[1]);
				const boardStatus = JSON.parse(event.data.split('@')[3]);
				
				// 나의 턴인지 여부 판별
				let isMyTurn = false;
				let bw = 'true';
				const myCamp = $('#myCamp').val();
				if(myCamp == 'white'){
					bw = 'false';
				}
				const turnModTwo = turn % 2;
				if( (turnModTwo == 1 && myCamp == 'white') || (turnModTwo == 0 && $('#myCamp').val() == 'black') ){
					isMyTurn = true;
				}
				
				// 흑/백 진영에 따른 랜더링 스위치값 설정
				let rowRenderingCounter = 1;
				let colRenderingCounter = 1;
				if(myCamp == 'white'){
					rowRenderingCounter = 8;
					colRenderingCounter = 8;
				}
				
				// 이전에 클릭된 기물로 활성화된 css 제거
				$("td").css({
					'background-color': 'transparent'
				});
				// 기존 기물 랜더링 및 클릭이벤트 제거
				$("td").off('click');
				$("td").text("");
				
				// 이전턴에 선택된 기물 및 이동 가능지점의 속성값 제거
				$("td[selec='true']").attr('selec', 'false');
				$("td[selec='candidate']").attr('selec', 'false');

				// 기물 랜더링 및 클릭이벤트 추가
				for(let i=1; i<=8; i++){
					for(let j=1; j<=8; j++){
						const key = i*10 + j;
						const locationID = 'l' + key;

						if(boardStatus[key] != 'null'){
							// 기물 표시
							const grade = boardStatus[key].grade;
							const pieceBw = boardStatus[key].bw;
							const chessPieceID = pieceBw + grade;
							let strChessPiece = '';
							
							if(chessPieceID == 'true0'){
								// 흑 폰
								strChessPiece = '&#9823;';
							}else if(chessPieceID == 'true1'){
								// 흑 나이트
								strChessPiece = '&#9822;';
							}else if(chessPieceID == 'true2'){
								// 흑 비숍
								strChessPiece = '&#9821;';
							}else if(chessPieceID == 'true3'){
								// 흑 룩
								strChessPiece = '&#9820;';
							}else if(chessPieceID == 'true4'){
								// 흑 퀸
								strChessPiece = '&#9819;';
							}else if(chessPieceID == 'true5'){
								// 흑 킹
								strChessPiece = '&#9818;';
							}else if(chessPieceID == 'false0'){
								// 백 폰
								strChessPiece = '&#9817;';
							}else if(chessPieceID == 'false1'){
								// 백 나이트
								strChessPiece = '&#9816;';
							}else if(chessPieceID == 'false2'){
								// 백 비숍
								strChessPiece = '&#9815;';
							}else if(chessPieceID == 'false3'){
								// 백 룩
								strChessPiece = '&#9814;';
							}else if(chessPieceID == 'false4'){
								// 백 퀸
								strChessPiece = '&#9813;';
							}else if(chessPieceID == 'false5'){
								// 백 킹
								strChessPiece = '&#9812;';
							}
							
							$('#' + locationID).html(strChessPiece);	
							
							// 기물에 이동 가능지점 표시기능(클릭 이벤트) 추가
							if(isMyTurn && boardStatus[key].bw == bw){
								const possibleMoves = boardStatus[key].possibleMoves;
							
								$('#' + locationID).click(function(){
									pieceSelected(locationID, possibleMoves);
								});
							}
						}else{
							$('#' + locationID).html('&nbsp;');
						}
					}
				}	
			}
			
		};
		
		// 기물 클릭이벤트 처리
		function pieceSelected(selectedPiece, possibleMoves){
			possibleMovesArr = possibleMoves.split('/');

			// 이전에 클릭된 기물로 활성화된 css 제거
			$("td[selec='true']").css({
				'background-color': 'transparent'
			});
			$("td[selec='candidate']").css({
				'background-color': 'transparent'
			});
			
			// 이전에 클릭으로 추가된 이동 가능지점의 클릭이벤트 제거
			$("td[selec='candidate']").off('click');
			
			// 선택된 기물 및 이동 가능지점의 속성값 제거
			$("td[selec='true']").attr('selec', 'false');
			$("td[selec='candidate']").attr('selec', 'false');
			
			// 클릭된 기물 css 활성화, 선택 속성값 추가
			$('#' + selectedPiece).css({
				'background-color': '#D9E5FF'
			});			
			$('#' + selectedPiece).attr('selec', 'true');
			
			// 클릭된 기물의 이동 가능한 위치 표시, 기물 이동 이벤트 추가
			for(let index=0; index<possibleMovesArr.length; index++){
				const possibleLocationID = 'l' + possibleMovesArr[index];
				
				$('#' + possibleLocationID).css({
					'background-color': 'yellow'
				});
				
				$('#' + possibleLocationID).attr('selec', 'candidate');
				
				$('#' + possibleLocationID).click(function(){
					move(selectedPiece.replace('l', ''), possibleMovesArr[index]);
				});
			}
			
		}
		
		// 기물 이동 함수
		function move(curPosition, nextPosition){
			socket.send('move@' + curPosition + 'to' + nextPosition);
		}
		
	};
	
	
</script>
<style type="text/css">
	@font-face {
    	font-family: 'chessPiece';
    	src: local('./assets/font/DejaVuSans.ttf') format('truetype'); 
  	}

	body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
    }
	
	chessBoardContainer {
		align: center;
		border-collapse: collapse;
    	border: 1px solid black;
    	width:400px;
    	height:400px;
	}
	
	table {
		border: 3px solid black;
		background-image: url('./assets/img/playable/chess/chessboard2.png');
    	background-size: cover;
    	background-repeat: no-repeat;
    	background-position: right top;
	}
	
	td {
		color: black;
		text-align: center;
		align: center;
		font-size: 30px;
		min-width: 50px;
		height: 50px;
		font-family: "chessPiece", sans-serif;
	}
		
	tr{
		color: black;
	}
	
	.message-area {
		height: 300px;
      	overflow-y: auto; 
    }
</style>
</head>
<body>	
	<div id='startingComponents'>
		<!-- 매칭 버튼 -->
		<button id="matchBtn">매칭 시작</button>
		<input type='hidden' id='opponent' />	
		<!-- 배정된 흑/백 진영 -->
	</div>
	<input type="hidden" id="myCamp" value="" /> 
	
	<!-- 채팅창 -->
	<div id="chatBox">
		<div class="container mt-5">
			<div class="row">
				<div class="col-md-12 offset-md-1">
      				<div class="card">
        				<div class="card-header">
        					채팅
        				</div>
        				<div class="card-body message-area" style="height: 300px; overflow-y: auto;">
          					<ul class="list-unstyled">
            					<li class="media">
              						<div class="media-body">
                						<h5 class="mt-0 mb-1">플레이어 1</h5>
                						하이
              						</div>
            					</li>
           	 				<!-- 추가적인 대화 메시지는 이곳에 추가 가능 -->
          					</ul>
        				</div>
        				<div class="card-footer">
          					<div class="input-group">
            					<input type="text" class="form-control flex-grow-1 mr-2" placeholder="메시지 입력">
            					<button class="btn btn-primary">전송</button>
          					</div>
        				</div>
      				</div>
    			</div>
  			</div>
		</div>
	</div>
	
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	
	<!-- 체스보드 -->
	<div id='chessBoardContainer'></div>
	
</body>
</html>