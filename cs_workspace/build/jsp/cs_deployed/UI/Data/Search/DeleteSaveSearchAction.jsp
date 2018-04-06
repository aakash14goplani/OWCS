<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.SearchService"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@page import="org.apache.commons.lang.math.NumberUtils"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {
	String strSaveSearchId = StringUtils.defaultString(request.getParameter("saveSearchId"));
	if(StringUtils.isNotBlank(strSaveSearchId)) {
		Session ses = SessionFactory.getSession();
		ServicesManager servicesManager =(ServicesManager)ses.getManager(ServicesManager.class.getName());
		SearchService searchService =  servicesManager.getSearchService();
		boolean status = searchService.deleteSmartList(NumberUtils.toLong(strSaveSearchId));
		request.setAttribute("status", new Boolean(status));
	}
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>