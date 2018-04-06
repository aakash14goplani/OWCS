<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.ui.beans.UITreeBean"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {
	String history = ics.GetSSVar("_history_");
	String status = "true" ;
	String refreshKey = "Root:History";
	ics.RemoveSSVar("_history_");
	UITreeBean treeBn = new UITreeBean();
	treeBn.setRefreshKeys(refreshKey);
	treeBn.setStatus(status);
	request.setAttribute("treeBean", treeBn);
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>