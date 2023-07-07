<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
<%
	//0 : 정상 / 1 : 비정상
	int flag = (Integer)request.getAttribute("flag");
	String seq = (String)request.getAttribute("seq");
	int isFav = (Integer)request.getAttribute("isFav");
	
	String str = "";
	
	if(isFav == 1) {
		str = "즐겨찾기 해제";
	} else if (isFav == 2) {
		str = "즐겨찾기 추가";
	}	
	
	String icon = "";
	String title = "";
	String url = "";
	
	if(flag == 0){
		icon = "'success'";
		title = "'" + str + " 성공'";
		url = "location.href='gameView?seq=" + seq + "';";
	} else {
		icon = "'error'";
		title = "'" + str + " 실패'";
		url = "history.back();";
	}
%>
<body>
	<script type='text/javascript'>
		Swal.fire({
			icon: <%= icon %>,
			title: <%= title %>,
			confirmButtonText: "확인",
			willClose: () => {
				<%= url %>
			}
		});
	</script>
</body>	

