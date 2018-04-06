<%@page import="com.fatwire.services.beans.asset.PermissionBean"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@page import="com.fatwire.services.SiteService"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%@page import="com.fatwire.services.ui.beans.UIInitBean"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.ui.util.InsiteUtil"
%><cs:ftcs><%
	try
	{
		//create UI bean and set values.
		UIInitBean initBean = new UIInitBean();
		//set whether or not site preview enabled
		initBean.setSitePreviewInstalled(ftMessage.cm.equals(ics.GetProperty(ftMessage.cssitepreview, "futuretense.ini", true)));
		//set whether or not insite  enabled
		initBean.setInsiteEnabled(new Boolean(ics.GetProperty("xcelerate.enableinsite", "futuretense_xcel.ini", true)));
		Session ses = SessionFactory.getSession();
		ServicesManager servicesManager = (ServicesManager)ses.getManager(ServicesManager.class.getName());
		SiteService siteService = servicesManager.getSiteService();
		boolean enabled = siteService.isPreviewEnabled(GenericUtil.getLoggedInSite(ics));
		//set whether or not preview enabled
		initBean.setPreviewEnabled(enabled);
		//set the token
		initBean.setToken(InsiteUtil.getUploadToken(ics));
		//set session id.
		initBean.setSessionid(session.getId());	
		request.setAttribute( "initBean", initBean);
	} catch(Exception e) {
		UIException uie = new UIException(e);
		request.setAttribute(UIException._UI_EXCEPTION_, uie);
		throw uie;
	}
%></cs:ftcs>