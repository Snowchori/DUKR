<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
//0 : 정상 / 1 : 비정상
int flag = (Integer)request.getAttribute("flag");
String seq = (String)request.getAttribute("seq");

out.println("<script type='text/javascript'>");
if (flag == 0) {
	out.println("alert('평가등록 성공')");
	out.println("location.href='gameView?seq=" + seq + "';");
} else {
	out.println("alert('평가등록 실패')");
	out.println("history.back();");
}
out.println("</script>");
%>