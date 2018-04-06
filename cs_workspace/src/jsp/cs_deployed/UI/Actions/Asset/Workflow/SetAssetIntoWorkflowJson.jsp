<%@page import="com.fatwire.cs.ui.framework.UIException"%>
<%@page import="org.apache.commons.lang.BooleanUtils"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {
	String success = String.valueOf(BooleanUtils.toBoolean(String.valueOf(request.getAttribute("success"))));
%>{"startWorkflowStatusForAsset":<%= success%>}<%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>