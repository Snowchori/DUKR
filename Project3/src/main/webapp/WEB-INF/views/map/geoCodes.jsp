<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String loccode = (String)request.getAttribute("loccode");
	
	String url = "https://api.vworld.kr/req/data?key=F0BF08ED-5687-3016-ACA2-CB1B04D54708&domain=com.example.project&"
		+ "version=2.0&request=getfeature&format=json&size=1000&page=1&"
		+ "geometry=false&crs=EPSG:3857&"
		+ "geomfilter=BOX(13663271.680031825,3894007.9689600193,14817776.555251127,4688953.0631258525)&";
	
	if(loccode.length() == 0){
		url = url.concat("data=LT_C_ADSIDO_INFO");
	} else {
		url = url.concat("data=LT_C_ADSIGG_INFO&attrfilter=sig_cd:like:" + loccode);
	}
%>
<c:import var="xmldata" url="<%=url%>" />
${ xmldata }