<%@page import="com.fatwire.services.SiteService"
%><%@ page import="com.fatwire.services.beans.entity.StartMenuBean"
%><%@ page import="com.fatwire.services.ServicesManager"
%><%@ page import="com.fatwire.ui.util.SearchUtil"
%><%@ page import="com.fatwire.ui.util.GenericUtil"
%><%@ page import="com.fatwire.system.SessionFactory"
%><%@ page import="com.fatwire.system.Session"
%><%@ page import="java.util.*"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.ui.beans.UIStartMenuBean"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try{
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager) ses.getManager(ServicesManager.class.getName());	
	SiteService siteService = servicesManager.getSiteService();	
	List<StartMenuBean> newStartMenuData =  siteService.getStartMenus(Arrays.asList(StartMenuBean.Type.INSITE,StartMenuBean.Type.FORM), GenericUtil.getLoggedInSite(ics));
	newStartMenuData = GenericUtil.filterStartMenuItems(newStartMenuData, ics , false);
	
	//create UI beans
	List<UIStartMenuBean> startMenuBeanList = new ArrayList<UIStartMenuBean>();
	if(newStartMenuData != null)
	{
		for(int i=0; i<newStartMenuData.size(); i++)
	    {
	    	UIStartMenuBean bean = new UIStartMenuBean(newStartMenuData.get(i));
	    	startMenuBeanList.add(bean);
	    }
	}		
	request.setAttribute("newStartMenuData", startMenuBeanList);
	} catch(Exception e) {
		UIException uie = new UIException(e);
		request.setAttribute(UIException._UI_EXCEPTION_, uie);
		throw uie;
	}
%></cs:ftcs>