<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String targetType = (String)request.getAttribute("targetType");
	String subject = (String)request.getAttribute("subject");
	String boardSeq = (String)request.getAttribute("boardSeq");
	String commentSeq = (String)request.getAttribute("commentSeq");
	String userSeq = (String)request.getAttribute("userSeq");
	String content = (String)request.getAttribute("content");
	String writer = (String)request.getAttribute("writer");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
<%@ include file="/WEB-INF/views/include/head_setting.jspf" %> 
<script type="text/javascript">
	window.onload = function(){
		document.getElementById('reportSubmitBtn').onclick = function(){
			const reason = $('#reason').val();
			console.log("reason:" + reason);
			
			$.ajax({
				url: '/newReport',
				type: 'POST',
				data: {
					subject: "<%=subject%>",
					memSeq: <%=userSeq %>,
					boardSeq: <%=boardSeq %>,
					commentSeq: <%=commentSeq %>,
					writer: "<%=writer %>",
					reason: reason
				},
				success: function(result){
					Swal.fire({
						icon: 'success',
						title: '신고사항이 접수되었습니다',
						confirmButtonText: '확인',
						//timer : 1500,
						timerProgressBar : true,
						willClose: () => {
							window.close();
						}
					});
				}	
			});
		};
	};
</script>
</head>
<body>
	<br>
	신고
	<hr><br>
	<form name="reportFrm" action="/newReport" method="POST">
		<%if(targetType.equals("board")){ %>
		제목 : <input class="" name="subject" readonly="readonly" value="<%=subject %>"/>
		<br><hr><br>
		<%} %>
		<input type="hidden" name="memSeq" value=<%=userSeq %> />
		<input type="hidden" name="boardSeq" value=<%=boardSeq %> />
		<input type="hidden" name="commentSeq" value=<%=commentSeq %> />
		작성자 : <input class="" name="writer" readonly="readonly" value="<%=writer %>" />
		<br>
		내용<br> 
		<input class="" name="content" readonly="readonly" value="<%=content %>" />
		<br>
		신고사유 <br>
		<input type="text" name="reason" id="reason" style="display: block;" rows="5"/>
		<br>
		<input type="button" id="reportSubmitBtn" value="제출"/>
	</form>
</body>
</html>