<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.SiteService"
%><%@page import="com.fatwire.services.beans.entity.RoleBean"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );
	SiteService siteService = servicesManager.getSiteService();	
	request.setAttribute("roles", siteService.getAllRoles());
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>