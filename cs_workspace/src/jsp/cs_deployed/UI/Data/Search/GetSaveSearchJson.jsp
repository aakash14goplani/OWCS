<%@page import="org.codehaus.jackson.map.ObjectMapper"
%><%@page import="com.fatwire.services.ui.beans.UISaveSearchBean"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%>
<%@page import="com.fatwire.cs.ui.framework.UIException"%><cs:ftcs><%
try {
	UISaveSearchBean uiBean = (UISaveSearchBean) request.getAttribute("saveSearch");
%><%= new ObjectMapper().writeValueAsString(uiBean)%><%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>