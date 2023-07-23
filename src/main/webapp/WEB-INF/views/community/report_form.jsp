<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%
	String targetType = (String)request.getAttribute("targetType");
	String subject = (String)request.getAttribute("subject");
	String seq = (String)request.getAttribute("seq");
	String userSeq = (String)request.getAttribute("userSeq");
	String content = (String)request.getAttribute("content");
	String writer = (String)request.getAttribute("writer");
	
	out.println("targetType : " + targetType);
	out.println("subject : " + subject);
	out.println("seq : " + seq);
	out.println("userSeq : " + userSeq);
	out.println("content : " + content);
	out.println("writer : " + writer);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>

</body>
</html>