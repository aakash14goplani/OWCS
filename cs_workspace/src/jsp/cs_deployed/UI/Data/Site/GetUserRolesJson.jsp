<%@page import="org.codehaus.jackson.map.ObjectMapper"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.beans.entity.RoleBean"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {
		List<RoleBean> userRoles = GenericUtil.emptyIfNull((List<RoleBean>)request.getAttribute("user-roles"));
%>{"identifier": "name","items":<%= new ObjectMapper().writeValueAsString(userRoles)%>}<%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>