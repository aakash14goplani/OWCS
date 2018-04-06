<%@page import="com.fatwire.ui.util.SearchUtil"
%><%@page import="com.fatwire.services.SiteService"
%><%@ page import="com.fatwire.services.beans.entity.StartMenuBean"
%><%@ page import="com.fatwire.services.beans.asset.TypeBean"
%><%@ page import="com.fatwire.services.ServicesManager"
%><%@ page import="com.fatwire.ui.util.GenericUtil"
%><%@ page import="com.fatwire.system.Session"
%><%@ page import="java.util.*"
%><%@ page import="java.util.Arrays"
%><%@ page import="com.fatwire.cs.ui.framework.LocalizedMessages"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.ui.beans.UIStartMenuBean"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
	try{
		Session ses = SessionFactory.getSession();
		ServicesManager servicesManager = (ServicesManager) ses.getManager(ServicesManager.class.getName());
		SiteService siteService = servicesManager.getSiteService();
		List<StartMenuBean> searchStartMenuData = siteService.getStartMenus(Arrays.asList(StartMenuBean.Type.SEARCH), GenericUtil.getLoggedInSite(ics));
		searchStartMenuData = GenericUtil.filterStartMenuItems(searchStartMenuData, ics , true);		
		// create the presentation beans
		List<UIStartMenuBean> startMenuBeanList = new ArrayList<UIStartMenuBean>();
		//first add the bean that represents 'All'
		UIStartMenuBean allBn = new UIStartMenuBean();
		allBn.setName(SearchUtil.ALL);
		allBn.setDescription(LocalizedMessages.all.getLocalizedValue(ics));
		allBn.setAssettype(SearchUtil.ALL);
		startMenuBeanList.add(allBn);
		if(searchStartMenuData != null)
		{
			for(int i=0; i<searchStartMenuData.size(); i++)
		    {
		    	UIStartMenuBean bean = new UIStartMenuBean(searchStartMenuData.get(i));	    	
		    	startMenuBeanList.add(bean);
		    }
		}		
		request.setAttribute("searchStartMenuData", startMenuBeanList);
	} catch(Exception e) {
		UIException uie = new UIException(e);
		request.setAttribute(UIException._UI_EXCEPTION_, uie);
		throw uie;
	}
%></cs:ftcs>