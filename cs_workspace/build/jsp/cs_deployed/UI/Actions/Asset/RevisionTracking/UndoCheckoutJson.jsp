<%@page import="org.codehaus.jackson.map.ObjectMapper"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.services.ui.beans.UIVersionBean"
%><%@page import="java.util.List"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {
	List<UIVersionBean> result = GenericUtil.emptyIfNull((List<UIVersionBean>) request.getAttribute("result"));
	%>{status:<%= new ObjectMapper().writeValueAsString(result)%>}<%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>
