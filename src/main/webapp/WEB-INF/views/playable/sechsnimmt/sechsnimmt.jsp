<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>6 nimmt!</title>
<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
<script type="text/javascript">
	window.onload = function(){
		
		const socket = new WebSocket('ws://localhost:8080/sechsNimmt');
		
		$('#startBtn').on('click', function(){
			$('#startBtn').html('매칭 대기중');
			socket.send('match request');
		});
		
		let gameID = '';
		let playerID = '';
		let defaultDelayTime = 1000;

		// 수신정보 처리
		socket.onmessage = function(event){
			// 게임 고유번호 수신
			if(event.data.split('@')[0] == 'uuid'){
				gameID = event.data.split('@')[1];
			}
			
			// 클라이언트 고유 구분자 수신
			if(event.data.split('@')[0] == 'playerID'){
				playerID = event.data.split('@')[1];
			}
			
			// 게임 진행정보 수신
			if(event.data.split('@')[0] == 'game'){
				console.log(event.data.split('@')[1]);
				game = JSON.parse(event.data.split('@')[1]);
				
				// 기존 선택자 css 초기화
				$('[selec="true"]').css({
					'background-color' : 'transparent'
				});
				$('[selec="true"]').attr('selec', 'false');
				
				// 손패 
				$('#hand').empty();
				let handTable = '<table><tr>';
				for(let index=0; index<game.hand.length; index++){
					handTable += '<td id="hand' + index + '" tag="hand">' + game.hand[index] + '</td>';
				}
				handTable += '</tr></table>';
				var myHand = $(handTable);
				$('#hand').append(myHand);
				
				// 게임상태
				for(let row=0; row<4; row++){
					for(let col=0; col<6; col++){
						const locID = 'r' + (row + 1) + 'c' + (col + 1);
						if(game.gameStatus[row][col] != 0){
							$('#' + locID).html(game.gameStatus[row][col]);
						}else{
							$('#' + locID).html('');
						}
					}
				}
				
				// 플레이어 목록
				const players = game.players;
				for(let index=0; index<players.length; index++){
					//console.log(players[index]);
				}
				
				// 손패 호버, 클릭이벤트 추가
				for(let index=0; index<10; index++){
					const locID = 'hand' + index;
					
					$('#' + locID).hover(function(){
						$(this).css('background-color', 'lightgreen');
					},  
					function(){
						$(this).css('background-color', 'transparent');
					});
					
					$('#' + locID).click(function(){
						socket.send('gameID@' + gameID + '@pick@' + index);
						$('td[tag="hand"]').off('mouseenter mouseleave click'); 
						$(this).css('background-color', 'red');
						$('#instruction').html('<p>다른 플레이어들의 선택을 기다리는 중입니다</p>');
					});
				}
				
				$('#instruction').html('<p>낼 카드를 선택하세요</p>');
			}
			
			// 플레이어들의 점수정보 수신
			if(event.data.split('@')[0] == 'scoreInfo'){
				const playersAndScores = JSON.parse(event.data.split('@')[1]);
				const players = playersAndScores.players;
				const scores = playersAndScores.scores;
				$('#scoreInfo').empty();
				
				let scoreTable = '<table>';
				for(let index=0; index<players.length; index++){
					scoreTable += '<tr>';
					scoreTable += '<td>' + players[index] + '</td>';
					scoreTable += '<td>' + scores[index] + '</td>';
					scoreTable += '</tr>';
				}
				scoreTable += '</table>';
				
				var scoreInfo = $(scoreTable);
				$('#scoreInfo').append(scoreInfo);
			}
			
			// 플레이어들이 고른 카드정보 수신
			if(event.data.split('@')[0] == 'picks'){
				$('#picksContainer').empty();
				const picks = JSON.parse(event.data.split('@')[1]);
				
				let picksTable = '<table id="picks">';
				let cardNumbers = '<tr cardPlace="true">';
				picksTable += '<tr>';
				for(let index=0; index<picks.players.length; index++){
					console.log(picks.players[index]);
					picksTable += '<td id="picks_player' + index + '">' + picks.players[index] + '</td>';
					cardNumbers += '<td id="picks_pick' + index + '">' + picks.picks[index] + '</td>';
				}
				picksTable += '</tr>';
				picksTable += cardNumbers;
				picksTable += '</tr>';
				picksTable += '</table>';
				
				var showPicks = $(picksTable);
				$('#picksContainer').append(showPicks);
				$('#instruction').html('');
			}
			
			// 카드이동정보 수신
			if(event.data.split('@')[0] == 'picksPointer'){
				const movingCard = event.data.split('@')[1];
				const movingCardNumber = $('#picks_pick' + movingCard).text();
				const target = event.data.split('@')[3];
				const targetRow = target.split('c')[0].replaceAll('r', '');
				const targetCol = target.split('c')[1];
				
				if(event.data.split('@')[2] == ('no_candidate')){
					if(event.data.split('@')[3] == (playerID)){
						// 플레이어가 고른 카드가 놓일 공간이 없는 경우 => 패널티라인 선택 진행
						$('#instruction').html('<p>선택한 카드를 놓을 수 있는 위치가 없습니다. 벌칙으로 모든 카드를 가져갈 행을 선택하십쇼.</p>');
						$('[line="true"]').hover(function(){
							$(this).css('background-color', 'lightgreen');
						},  
						function(){
							$(this).css('background-color', 'transparent');
						});
						
						$('[line="true"]').click(function(){
							const idVal = $(this).attr('id');
							$('[line="true"]').off('mouseenter mouseleave click');
							$(this).css({
								'background-color' : 'transparent'
							});
							socket.send('gameID@' + gameID + '@penaltyLine@' + idVal);
						});
					}else{
						// 다른 플레이어가 고른 카드가 놓일 공간이 없는 경우
						socket.send('gameID@' + gameID + '@next instruction request');
					}
				}else{
					// 이전 선택항목 css 초기화
					$('[selec="true"]').css({
						'background-color' : 'transparent'
					});
					$('[selec="true"]').attr('selec', 'false');
					
					// 새로운 지시사항 적용
					$('#picks_pick' + movingCard).css({
						'background-color' : 'pink'
					});
					$('#picks_pick' + movingCard).attr('selec', 'true');
					$('#' + target).html(movingCardNumber);
					$('#' + target).attr('selec', 'true');
					$('#' + target).css({
						'background-color' : 'pink'
					});
					
					if(event.data.split('@')[4] == 'penaltyPlayer'){
						// 패널티를 받는 플레이어가 존재하는 경우
						if(event.data.split('@')[5] == playerID){
							// 내가 패널티를 받는 경우
							const totalPenalty = event.data.split('@')[7];
							$('#instruction').html('<p>패널티로 총 ' + totalPenalty + '점을 차감합니다</p>');	
						}
						// 패널티라인 css
						delay(1000).then((result) => {
							// 선택자 css 초기화
							$('[selec="true"]').css({
								'background-color' : 'transparent'
							});
							$('[selec="true"]').attr('selec', 'false');
							// 패널티라인 css
							$('#line' + targetRow).css({
								'background-color' : 'red'
							});
							defaultDelayTime = 2000;
							
							delay(1000).then((result) => {
								for(let col=1; col<=6; col++){
									const targetTd = 'r' + targetRow + 'c' + col;
									$('#' + targetTd).html('');
								}
								const newStartPoint = 'r' + targetRow + 'c1';
								$('#' + newStartPoint).html(movingCardNumber);
								$('#line' + targetRow).css({
									'background-color' : 'transparent'
								});
							});
						});
					}
					
					delay(defaultDelayTime).then((result) => {
						socket.send('gameID@' + gameID + '@next instruction request');
						defaultDelayTime = 1000;
					});
				}	
			}
			
			if(event.data == 'picks_clear'){
				console.log('tc');
				$('#picksContainer').empty();
			}
		} 
		
		// 시간지연
		function delay(delayTime){
			return new Promise(function(resolve, reject){
				setTimeout(resolve, delayTime);
			});
		}

	}
</script>
<style type="text/css">

	body {
		display: flex;
		flex-direction: column;
	}
	
	#gameStatus{
		display: flex;
	}
	
	#gameStatus td {
		width: 80px;
		height: 130px;
		text-align: center;
		border-width: 1px;	
		border-style: solid;
	}
	
	[penalty="true"] {
		background-image: url('./assets/img/playable/sechsnimmt/sechsnimmt_skull.png');
		background-size: contain;
  		background-repeat: no-repeat; 
  		background-position: center;
	}
	
	#spaceBetweenPublicAndPicksContainer {
		width: 400px;
	}
	
	#picksContainer {
		display: flex;
		flex-direction: column;
		justify-content: center;
        align-items: center;
	}
	
	#hand {
		display: flex;
		justify-content: center;
        align-items: center;
	}
	
	#hand td {
		width: 100px;
		height: 162px;
		text-align: center;
		border-width: 1px;	
		border-style: solid;
	}
	
	#instruction {
		display: flex;
		justify-content: center;
        align-items: center;
        height: 50px;
	}
	
	#instruction p {
		font-weight: bold;
		color: blue;
	}
	
	[cardPlace='true'] {
		font-weight: bold;
		font-size: 44px;
		color: #FF5733;
		text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
	}
	
	#scoreInfo {
		margin-left: auto;
	}
	
	#scoreInfo table {
		height: 500px;
		font-size: 20px;
	}
	
</style>
</head>
<body>
	
	<!-- 시작요소 -->
	<div id="start">
		<button id="startBtn">게임 시작</button>
	</div>

	<div id="gameStatus">
		<table id="public" cardPlace="true">
			<tr id="line1" line="true">
				<td id="r1c1"></td><td id="r1c2"></td><td id="r1c3"></td><td id="r1c4"></td><td id="r1c5"></td><td id="r1c6" penalty="true"></td>
			</tr>
			<tr id="line2" line="true">
				<td id="r2c1"></td><td id="r2c2"></td><td id="r2c3"></td><td id="r2c4"></td><td id="r2c5"></td><td id="r2c6" penalty="true"></td>
			</tr>
			<tr id="line3" line="true">
				<td id="r3c1"></td><td id="r3c2"></td><td id="r3c3"></td><td id="r3c4"></td><td id="r3c5"></td><td id="r3c6" penalty="true"></td>
			</tr>
			<tr id="line4" line="true">
				<td id="r4c1"></td><td id="r4c2"></td><td id="r4c3"></td><td id="r4c4"></td><td id="r4c5"></td><td id="r4c6" penalty="true"></td>
			</tr>
		</table>
		
		<div id="spaceBetweenPublicAndPicksContainer"></div>
		
		<div id="picksContainer"></div>
		
		<div id="spaceBetweenPicksContainerAndScoreInfo"></div>
		
		<div id="scoreInfo"></div>
	</div>
	
	<br/><hr/><br/>
	
	<!-- 지시사항 -->
	<div id="instruction"></div>
		
	<!-- 손패 -->
	<div id="hand" cardPlace="true"></div>

</body>
</html>