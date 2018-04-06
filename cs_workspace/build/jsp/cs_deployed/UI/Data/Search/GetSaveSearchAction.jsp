<%@page import="com.fatwire.services.ui.beans.UISaveSearchBean"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="org.apache.commons.lang.math.NumberUtils"
%><%@page import="com.fatwire.services.SearchService"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.Session"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%>
<%@page import="com.fatwire.system.SessionFactory"%>
<%@page import="com.fatwire.services.beans.search.SmartList"%><cs:ftcs><%
try {
	String strSmartListId = StringUtils.defaultString(request.getParameter("saveSearchId"));
	if(StringUtils.isNotBlank(strSmartListId)) {
		Session ses = SessionFactory.getSession();
		ServicesManager servicesManager =(ServicesManager)ses.getManager(ServicesManager.class.getName());
		SearchService searchService =  servicesManager.getSearchService();
		SmartList saveSearch = searchService.getSmartList(NumberUtils.toLong(strSmartListId));
		if(saveSearch != null) {
			UISaveSearchBean uiBean = new UISaveSearchBean(saveSearch);
			request.setAttribute("saveSearch", uiBean);
		}
	}
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>