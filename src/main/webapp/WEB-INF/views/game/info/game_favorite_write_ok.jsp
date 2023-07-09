<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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