<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf"%>
<%
	String seq = (String)request.getAttribute("seq");
	String mseq = (String)request.getAttribute("memSeq");
	
	boolean isWriter = false;
	if(userSeq != null && userSeq.equals(mseq)){
		isWriter = true;
	}
%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/views/include/head_setting.jspf"%>
	<!-- Template Main CSS File -->
	<link href="assets/css/style.css" rel="stylesheet">
	<script type="text/javascript">
		let seq = <%= seq %>;
		let isWriter = <%= isWriter %>;
		let users = [];
		let desired = null, participants = null;
		if(!isWriter){
			alert('잘못된 접근입니다.');
			window.close();
		}
		
		const access = "<option value=2>승인</option>", deny = "<option value=-2>거부</option>";
		
		$(() => {
			$.ajax({
				url: '/partyStatus',
				type: 'POST',
				async: false,
				data:{
					seq: seq
				},
				success: function(data){
					desired = parseInt(data.desired);
					participants = parseInt(data.participants);
					
					$('#partyStatus').html( '(' + participants + '/' + desired + ')' );
				}
				
			});
			$.ajax({
				url: '/api/appliers.json',
				type: 'POST',
				data: {
					seq: seq
				},
				success: function(appliers){
					users = appliers;
					for(let applier of appliers){
						$('#tbody').append(`<tr class="\${applier.senderSeq}">`);
						$(`#tbody .\${applier.senderSeq}`).append('<td>' + applier.nickname + '</td>');
						
						switch(applier.status){
							case '2':
								$(`#tbody .\${applier.senderSeq}`).append('<td class="accepted">승인</td>');
								$(`#tbody .\${applier.senderSeq}`).append('<td><div class="manage"><span><select id="sel'+applier.senderSeq+'" name="status" class="form-select">' + deny + '</select></span></div></td>');
								break;
							case '1':
								$(`#tbody .\${applier.senderSeq}`).append('<td>신청중</td>');
								$(`#tbody .\${applier.senderSeq}`).append('<td><div class="manage"><span><select id="sel'+applier.senderSeq+'" name="status" class="form-select">' + access + deny + '</select></span></div></td>');
								break;
							case '-1':
								$(`#tbody .\${applier.senderSeq}`).append('<td>취소</td>');
								break;
							case '-2':
								$(`#tbody .\${applier.senderSeq}`).append('<td class="denied">거부</td>');
								$(`#tbody .\${applier.senderSeq}`).append('<td><div class="manage"><span><select id="sel'+applier.senderSeq+'" name="status" class="form-select">' + access + '</select></span></div></td>');
								break;
						}
						
						if(applier.status !== '-1'){
							$(`#tbody .\${applier.senderSeq} .manage`).append('&nbsp;<button id="btn'+applier.senderSeq+'" class="btn btn-dark" type="submit">확인</button>' );
						}
						
						document.getElementById('btn' + applier.senderSeq).onclick = function(){
							if(participants >= desired){
								alert('모임 인원이 가득찼습니다.');
								return;
							}else{
								$.ajax({
									url: '/changeApply',
									type: 'post',
									data:{
										seq: seq,
										senderSeq: applier.senderSeq,
										status: document.getElementById('sel' + applier.senderSeq).value
									},
									success: function(result){
										if(result == 0){
											location.reload();
										}else{
											alert('요청하신 데이터를 처리하는 중 문제가 발생하였습니다.');
										}
									},
									error: function(xhr, stat, error){
										alert('요청하신 데이터를 처리하는 중 문제가 발생하였습니다.\n[' + stat + ']' + error);
									}
								});
							}
						}
					}
				}, 
				error: function(xhr, stat, err){
					alert('참여정보를 불러오는 중 문제가 발생하였습니다.\n[' + stat + ']' + err);
				}
			});
			
		});
	</script>
</head>
<body>
	<div class="container-fluid">
		<h5 class="mt-3 text-center"><b>참여관리<span id="partyStatus"></span></b></h5>
		<hr>
		<div class="table-responsive">
			<table class="table table-bordered text-center mb-2">
				<thead>
					<tr>
						<th>유저</th>
						<th>상태</th>
						<th>관리</th>
					</tr>
				</thead>
				<tbody id='tbody'>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>