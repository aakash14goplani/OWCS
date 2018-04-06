<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%@ page import="com.fatwire.system.SessionFactory"
%><%@ page import="com.fatwire.system.Session"
%><%@ page import="java.util.*"
%><%@ page import="com.fatwire.services.beans.entity.SiteBean"
%><%@ page import="com.fatwire.services.ServicesManager"
%><%@ page import="com.fatwire.services.AssetService"
%><%@ page import="com.fatwire.services.beans.asset.TypeBean"
%><%@ page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.services.util.JsonUtil"
%><%@ page import="com.fatwire.assetapi.data.AssetId"
%>
<%@page import="com.fatwire.ui.util.GenericUtil"%><cs:ftcs><%
try{
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );		 
	
	AssetService assetService = servicesManager.getAssetService();
	List<AssetId> assetIds = GenericUtil.retainDistinctElements(GenericUtil.emptyIfNull(JsonUtil.jsonToIdList(StringUtils.defaultString(request.getParameter("assetData")))));
	
	SiteBean currentSite = new SiteBean();
	currentSite.setId(GenericUtil.getLoggedInSite(ics));

	if( assetIds != null)
	{
		List<SiteBean> availableSiteList = new ArrayList<SiteBean>();				
		availableSiteList = assetService.getCommonEnabledSites(assetIds);		
		
		// remove the current site from list
		availableSiteList.remove(currentSite);
		request.setAttribute("availableSites", availableSiteList);
	}		
} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}
%>

</cs:ftcs>