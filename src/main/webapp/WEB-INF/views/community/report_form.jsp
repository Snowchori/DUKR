<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
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
<script type="text/javascript">
	window.onload = function(){
		document.getElementById('reportSubmitBtn').onclick = function(){
			document.reportFrm.submit();
			//window.close(); 
		};
	};
</script>
</head>
<body>
	<br>
	�Ű�
	<hr><br>
	<form name="reportFrm" action="/newReport" method="POST">
		<%if(targetType.equals("board")){ %>
		���� : <input class="" name="subject" readonly="readonly" value="<%=subject %>"/>
		<br><hr><br>
		<%} %>
		<input type="hidden" name="memSeq" value=<%=userSeq %>/>
		<input type="hidden" name="boardSeq" value=<%=boardSeq %>/>
		<input type="hidden" name="commentSeq" value=<%=commentSeq %>/>
		�ۼ��� : <input class="" name="writer" readonly="readonly" value="<%=writer %>"/>
		<br>
		����<br> 
		<input class="" name="content" readonly="readonly" value="<%=content %>"/>
		<br>
		�Ű���� <br>
		<input type="text" name="reason" style="display: block;" rows="5"/>
		<br>
		<input type="button" id="reportSubmitBtn" value="����"/>
	</form>
</body>
</html>