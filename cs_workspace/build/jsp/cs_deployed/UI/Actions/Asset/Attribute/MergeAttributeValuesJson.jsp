<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="org.codehaus.jackson.map.ObjectMapper"
%><%@ page import="java.util.*"
%><%@ page import="com.fatwire.assetapi.data.AssetId"
%><cs:ftcs><%
try {
	List<AssetId> assetAttributes = (List<AssetId>)request.getAttribute("values");
	ObjectMapper mapper = new ObjectMapper();
	String json = mapper.writeValueAsString(assetAttributes);
	%>{ "value": <%=json%> }<%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>