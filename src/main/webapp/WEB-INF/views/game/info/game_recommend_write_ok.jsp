<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
//0 : 정상 / 1 : 비정상
int flag = (Integer)request.getAttribute("flag");
String seq = (String)request.getAttribute("seq");
int isRec = (Integer)request.getAttribute("isRec");
String str = "";

if(isRec == 1) {
	str = "추천 해제";
} else if (isRec == 2) {
	str = "추천";
}

out.println("<script type='text/javascript'>");
if (flag == 0) {
	out.println("alert('" + str + " 성공')");
	out.println("location.href='gameView?seq=" + seq + "';");
} else {
	out.println("alert('" + str + " 실패')");
	out.println("history.back();");
}
out.println("</script>");
%>