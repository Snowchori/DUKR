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
		
		// 수신정보 처리
		socket.onmessage = function(event){
			// 게임 고유번호 수신
			if(event.data.split('@')[0] == 'uuid'){
				gameID = event.data.split('@')[1];
			}
			
			// 게임 진행정보 수신
			if(event.data.split('@')[0] == 'game'){
				console.log(event.data.split('@')[1]);
				game = JSON.parse(event.data.split('@')[1]);
				
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
						socket.send('gameID@' + gameID + '@' + 'pick@' + index);
						$('td[tag="hand"]').off('mouseenter mouseleave click'); 
						$(this).css('background-color', 'red');
						$('#instruction').html('<p>다른 플레이어들의 선택을 기다리는 중입니다</p>');
					});
				}
				
				$('#instruction').html('<p>낼 카드를 선택하세요</p>');
			}
			
			// 플레이어들이 고른 카드정보 수신
			if(event.data.split('@')[0] == 'picks'){
				$('#picksContainer').empty();
				const picks = JSON.parse(event.data.split('@')[1]);
				
				let picksTable = '<table id="picks">';
				let cardNumbers = '<tr>';
				picksTable += '<tr>';
				for(let index=0; index<picks.players.length; index++){
					console.log(picks.players[index]);
					picksTable += '<td>' + picks.players[index] + '</td>';
					cardNumbers += '<td>' + picks.picks[index] + '</td>';
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
				console.log('transfer // ' + event.data.split('@')[1]);
			}
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
		width: 100px;
		height: 162px;
		text-align: center;
		border-width: 1px;	
		border-style: solid;
	}
	
	[penalty="true"] {
		background-color: yellow;
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
</style>
</head>
<body>
	
	<!-- 시작요소 -->
	<div id="start">
		<button id="startBtn">게임 시작</button>
	</div>

	<div id="gameStatus">
		<table id="public">
			<tr>
				<td id="r1c1"></td><td id="r1c2"></td><td id="r1c3"></td><td id="r1c4"></td><td id="r1c5"></td><td id="r1c6" penalty="true"></td>
			</tr>
			<tr>
				<td id="r2c1"></td><td id="r2c2"></td><td id="r2c3"></td><td id="r2c4"></td><td id="r2c5"></td><td id="r2c6" penalty="true"></td>
			</tr>
			<tr>
				<td id="r3c1"></td><td id="r3c2"></td><td id="r3c3"></td><td id="r3c4"></td><td id="r3c5"></td><td id="r3c6" penalty="true"></td>
			</tr>
			<tr>
				<td id="r4c1"></td><td id="r4c2"></td><td id="r4c3"></td><td id="r4c4"></td><td id="r4c5"></td><td id="r4c6" penalty="true"></td>
			</tr>
		</table>
		
		<div id="spaceBetweenPublicAndPicksContainer"></div>
		
		<div id="picksContainer"></div>
	</div>
	
	<br/><hr/><br/>
	
	<!-- 지시사항 -->
	<div id="instruction"></div>
		
	<!-- 손패 -->
	<div id="hand"></div>

</body>
</html>