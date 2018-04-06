<%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="org.codehaus.jackson.map.ObjectMapper"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.ui.beans.UIDeleteBean"
%><%@page import="java.util.List"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {
	List<UIDeleteBean> result = GenericUtil.emptyIfNull((List<UIDeleteBean>) request.getAttribute("result"));
	%>{"status":<%= new ObjectMapper().writeValueAsString(result)%>}<%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>