<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="com.fatwire.services.ui.beans.LabelValueBean"
%><%@ page import="com.fatwire.services.AssetService"
%><%@ page import="com.fatwire.services.ServicesManager"
%><%@ page import="com.fatwire.services.beans.asset.TypeBean"
%><%@ page import="com.fatwire.services.beans.entity.SiteBean"
%><%@ page import="com.fatwire.services.SiteService"
%><%@ page import="com.fatwire.system.Session"
%><%@ page import="com.fatwire.system.SessionFactory"
%><%@ page import="java.util.*"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><cs:ftcs><%
try{
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );		 
	AssetService assetService = servicesManager.getAssetService();	

	String assetType = request.getParameter("assetType");
	String siteId = ics.GetSSVar("pubid");	
	List<LabelValueBean> subtypeList = new ArrayList<LabelValueBean>();	
	if(assetType != null) {
		List<String> subTypes = assetService.getSubtypes(assetType, Long.parseLong(siteId));
		if(subTypes != null) {
			for(String s : subTypes) {
				subtypeList.add(new LabelValueBean(s,s));
			}
		}
	}
	request.setAttribute("subType", subtypeList);
} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}
%></cs:ftcs>