<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String gcapikey = (String)request.getAttribute("gcapikey");
	String prvcode = (String)request.getAttribute("prvcode");
	
	StringBuilder url = new StringBuilder("https://api.vworld.kr/req/data?key=").append(gcapikey)
	.append("&domain=com.example.project&")
	.append("version=2.0&request=getfeature&format=json&size=1000&page=1&")
	.append("geometry=false&crs=EPSG:3857&")
	.append("geomfilter=BOX(13663271.680031825,3894007.9689600193,14817776.555251127,4688953.0631258525)&");
	
	if(prvcode.length() == 0){
		url.append("data=LT_C_ADSIDO_INFO");
	} else {
		url.append("data=LT_C_ADSIGG_INFO&attrfilter=sig_cd:like:").append(prvcode);
	}
%>
<c:import var="xmldata" url="<%=url.toString()%>" />
${ xmldata }