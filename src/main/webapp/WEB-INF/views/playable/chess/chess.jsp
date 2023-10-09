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
		
		const socket = new WebSocket('ws://54.180.57.106:8080/chess');
		//const socket = new WebSocket('ws://localhost:8080/chess');
		let promotableLoc = '';
		
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
				});
				
				$('#informations').css({
					'display': 'flex'
				});
				
				$('#chatBox').css({
					'display': 'flex'
				});
				
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
				$("#chessBoardContainer td").css({
					'background-color': 'transparent'
				});
				// 기존 기물 랜더링 및 클릭이벤트 제거
				$("#chessBoardContainer td").off('click');
				$("#chessBoardContainer td").text("");
				
				// 이전턴에 선택된 기물 및 이동 가능지점의 속성값 제거
				$("td[selec='true']").attr('selec', 'false');
				$("td[selec='candidate']").attr('selec', 'false');
				
				// 프로모션 선택지 숨김
				$("#whitePromoteOptions").css({
					'display' : 'none'
				});
				$("#blackPromoteOptions").css({
					'display' : 'none'
				});

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
				
				// 폰 프로모션
				if(event.data.split('@')[4] == 'promotable'){
					const promotablePiece = 'l' + event.data.split('@')[5];
					console.log('pl : ' + event.data.split('@')[5]);
					promotableLoc = event.data.split('@')[5];

					$('#' + promotablePiece).css({
						'background-color': '#7851A9'	
					});
					
					if(myCamp == 'white'){
						$('#whitePromoteOptions').css({
							'display' : ''
						});
					}else{
						$('#blackPromoteOptions').css({
							'display' : ''
						});
					}
					
					$("#chessBoardContainer td").off('click');
				}
				
				// 타이머 동작 제어
				if(isMyTurn){
					pauseOpTimer();
					startMyTimer();
				}else if(!isMyTurn){
					pauseMyTimer();
					startOpTimer();
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
	
		// 폰 프로모션 요청
		function promotePawn(grade){
			console.log('prom LOC : ' + promotableLoc);
			console.log('p grade ' + grade);
			socket.send('promote@' + promotableLoc + '@grade@' + grade);
		}
		
		// 프로모션 선택지 클릭 이벤트
		$('#whiteQueen').click(function(){ promotePawn(4) });
		$('#whiteRook').click(function(){ promotePawn(3) });
		$('#whiteBishop').click(function(){ promotePawn(2) });
		$('#whiteKnight').click(function(){ promotePawn(1) });
		$('#blackQueen').click(function(){ promotePawn(4) });
		$('#blackRook').click(function(){ promotePawn(3) });
		$('#blackBishop').click(function(){ promotePawn(2) });
		$('#blackKnight').click(function(){ promotePawn(1) });
		
		// 내 타이머
		let myTime = 600;
		
		function myTimer(){
			let min = Math.floor(myTime / 60);
			let sec = myTime % 60;
			if(sec < 10){
				sec = "0" + sec;
			}
			let result = '<i class="fas fa-clock"></i> &nbsp; ' + min + " : " + sec;
			
			$('#timer-me').html(result);
			myTime --;
			
			if(myTime < 0){
				pauseMyTimer();
			}
		}
		
		let mt;
		function startMyTimer(){
			mt = setInterval(myTimer, 1000);
		}
		
		function pauseMyTimer(){
			clearInterval(mt);
		}
		
		// 상대방 타이머
		let opTime = 600;

		function opTimer(){
			let min = Math.floor(opTime / 60);
			let sec = opTime % 60;
			if(sec < 10){
				sec = "0" + sec;
			}
			let result = '<i class="fas fa-clock"></i> &nbsp; ' + min + " : " + sec;
			
			$('#timer-opponent').html(result);
			opTime --;
			
			if(opTime < 0){
				pauseOpTimer();
			}
		}
		
		let ot;
		function startOpTimer(){
			ot = setInterval(opTimer, 1000);
		}
		
		function pauseOpTimer(){
			clearInterval(ot);
		}
		
	};
	
</script>
<style type="text/css">

	@font-face {
    	font-family: 'chessPiece';
    	src: local('./assets/font/DejaVuSans.ttf') format('truetype'); 
  	}

	#flexContainer {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0 auto;
    }
    
    #playElements {
    	display: flex;
    	margin: 0 auto;
    	position: relative;
    }
    
    #promoteOptions {
    	display:flex;
    	justify-content: center;
  		align-items: center; 
    }
    
    .promoteOptions {
    	color: black;	
		text-align: center;
		align: center;
		font-size: 30px;
		min-width: 50px;
		height: 50px;
		font-family: "chessPiece", sans-serif;
    }
	
	#chessBoardContainer table {
		border: 3px solid black;
		background-image: url('./assets/img/playable/chess/chessboard2.png');
    	background-size: cover;
    	background-repeat: no-repeat;
    	background-position: right top;
	}
	
	#chessBoardContainer td {
		color: black;	
		text-align: center;
		align: center;
		font-size: 60px;
		min-width: 100px;
		height: 100px;
		font-family: "chessPiece", sans-serif;
	}

	#game {
		display : flex;
		flex-direction: column;
		margin: 0 auto;
	}
	
	#informations {
		display : none;
		flex-direction: column;
		height: 800px;
		margin: 0 10px;
	}
	
	#info-opponent {
		display : flex;
		flex-direction: column;
		justify-content: flex-start;
		height: 50vh;
	}
	
	#info-me {
		display : flex;
		flex-direction: column;
		justify-content: flex-end;
		height: 50vh;
	}
	
    .timer {
    	width: 240px;
    	height: 100px;
    	background-color: black;
    	color: white;
    	border-radius: 10px;
    	display: flex;
    	justify-content: center;
    	align-items: center;
    	font-size: 40px;
    	font-weight: bold;
    }
    
    #chatBox {
    	display: none;
    	margin-right: 0px;
    	flex-direction: column;
    	background-color: lightblue;
    	height: 100vh;
    	width: 400px;
    }
    
    #startingComponents {
    	display: flex;
    	justify-content: center;
    	align-items: center;
    	height: 100vh;
    }
    
    .matchBtn {
    	background-color: #4CAF50; 
    	border: none; 
    	color: white; 
    	padding: 10px 20px;
    	text-align: center; 
    	text-decoration: none; 
    	display: inline-block;
    	font-size: 16px; 
    	border-radius: 5px; 
    	cursor: pointer;
    	font-size: 30px;
    	font-weight: bold;
  	}
    
</style>
</head>
<body>	
	<!-- myCamp -->
	<input type="hidden" id="myCamp" value="" />
	<!-- opponent --> 
	<input type='hidden' id='opponent' />

	<!-- 시작 요소 -->
	<div id='startingComponents'>
		<button id="matchBtn" class="matchBtn">Rapid - 10분<br>매칭 시작</button>	
	</div>

	<div id='flexContainer'>
		
		<!-- 채팅창 -->
		<div id="chatBox">
			<div>
				chatbox
			</div>
		</div>
		
		<div id="playElements">
			<div id="game">
				<div id="promoteOptions">
					<!-- 폰 프로모션 선택지(백) -->
					<div id="whitePromoteOptions" style="display:none;">
						<table class="promoteOptions">
							<tr>
								<td id="whiteQueen">&#9813;</td>
								<td id="whiteRook">&#9814;</td>
								<td id="whiteBishop">&#9815;</td>
								<td id="whiteKnight">&#9816;</td>
							</tr>
						</table>
					</div>
					<!-- 폰 프로모션 선택지(흑) -->
					<div id="blackPromoteOptions" style="display:none;">
						<table class="promoteOptions">
							<tr>
								<td id="blackQueen">&#9819;</td>
								<td id="blackRook">&#9820;</td>
								<td id="blackBishop">&#9821;</td>
								<td id="blackKnight">&#9822;</td>
							</tr>
						</table>
					</div>
				</div>
				<!-- 체스보드 -->
				<div id='chessBoardContainer' class='chessBoardContainer'></div>
			</div>
			
			<!-- 타이머 -->
			<div id="informations">
				<div id="info-opponent">
					<div id="timer-opponent" class="timer">
						<i class="fas fa-clock"></i> &nbsp; 10 : 00
					</div>
				</div>
				<div id="info-me">
					<div id="timer-me" class="timer">
						<i class="fas fa-clock"></i> &nbsp; 10 : 00
					</div>
				</div>
			</div>
			
		</div>
	</div>

</body>
</html>