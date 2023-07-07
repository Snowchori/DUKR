<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	out.println("<script type='text/javascript'>");
	out.println("alert('비밀번호 변경 완료')");
	out.println("location.href='/login';");
	out.println("</script>");
%>