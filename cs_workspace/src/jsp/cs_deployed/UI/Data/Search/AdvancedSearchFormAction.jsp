<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="java.util.Arrays"
%><%@page import="com.fatwire.services.SearchService"
%><%@page import="com.fatwire.services.SiteService"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.ui.util.SearchUtil"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@ page import="com.fatwire.services.beans.entity.StartMenuBean"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try{
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );		 
	SiteService siteService = servicesManager.getSiteService();
	
	long siteId = GenericUtil.getLoggedInSite(ics);
	request.setAttribute("locale", siteService.getLocales(siteId));
	request.setAttribute("author", siteService.getSiteUsers(siteId));	
	List<StartMenuBean> filteredList = GenericUtil.filterStartMenuItems(siteService.getStartMenus(Arrays.asList(StartMenuBean.Type.SEARCH), siteId), ics , true);
	request.setAttribute("assetType", filteredList);	
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>