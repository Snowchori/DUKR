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
<meta charset="UTF-8">
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
<style type="text/css">
	img {
		width: 100%;
	}
</style>
</head>
<body>
	<br>
	<legend style="text-align:center;"><b>신고하기</b></legend> 
	<hr>
	<%if(targetType.equals("board")){ %>
	<b style="padding-left: 40px">제목</b> : <%=subject %>
	<br><hr>
	<%} %>
	<b style="padding-left: 40px">작성자</b> : <%=writer %> 
	<br><br>
	<div style="display:block; background-color:#f0f0f0;">
		<br>
		<b style="padding-left: 40px">내용</b>
		<br><br>
		<div style="padding-left: 40px">
			<%=content %>
		</div>
		<br>
	</div>
	<br>
	<b style="padding-left: 40px;">신고사유</b> <br>
	<div class="container">
  		<div class="row justify-content-center">
    		<div class="col-14">
      			<textarea name="reason" id="reason" class="form-control" rows="4"></textarea>
      			<br>
      			<div class="float-end me-8">
      			<input type="button" class="btn btn-dark" id="reportSubmitBtn" value="제출"/>
      			</div>
    		</div>
  		</div>
	</div>
</body>
</html>