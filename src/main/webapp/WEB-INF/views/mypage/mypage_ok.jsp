<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
<%
	//0 성공 / 1 오류 및 실패 / 2 비밀번호 오류
	int flag = (int)request.getAttribute("flag");
	String title;
	String text;
	String icon;
	String link;
	if(flag == 0) {
		title = "'회원정보 변경'";
		text = "'정보변경 성공하였습니다'"; 
		icon = "'success'";
		link = "'/'";
	} else if (flag == 1) {
		title = "'회원정보 변경'";
		text = "'정보변경 실패하였습니다'"; 
		icon = "'error'";
		link = "'/'";
	} else {
		title = "'회원정보 변경'";
		text = "'비밀번호가 일치하지않습니다'"; 
		icon = "'error'";
		link = "'/mypage'";
	}
%>
<body>
    <script type="text/javascript">
        Swal.fire({
            title : <%=title%>,
            text  : <%=text%>,
            icon  : <%=icon%>,
            showCancelButton : false,
            confirmButtonText : '확인',
            timer : 1500,
            timerProgressBar : true,
            willClose : () => {
                window.location.href = <%=link%>;
            }
        });
    </script>    
</body>