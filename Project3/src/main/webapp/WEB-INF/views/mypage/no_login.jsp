<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	out.println("<script type='text/javascript'>");
	out.println("alert('로그인이 필요합니다.')");
	out.println("history.back();");
	out.println("</script>");
%>