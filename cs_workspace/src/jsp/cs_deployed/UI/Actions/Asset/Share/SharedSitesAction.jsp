<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
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
%><%@ page import="com.fatwire.assetapi.data.AssetId"
%><%@ page import="com.openmarket.xcelerate.asset.AssetIdImpl"
%><%@ page import="com.fatwire.services.ServicesManager"
%><%@ page import="com.fatwire.services.AssetService"
%><%@page import="com.fatwire.services.beans.asset.TypeBean"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.services.util.JsonUtil"
%><cs:ftcs><%
try{
	String currentSiteId = ics.GetSSVar("pubid");
	
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );		 
	AssetService assetService = servicesManager.getAssetService();		
	
	List<AssetId> assetIds = GenericUtil.retainDistinctElements(GenericUtil.emptyIfNull(JsonUtil.jsonToIdList(StringUtils.defaultString(request.getParameter("assetData")))));
	
	SiteBean currentSite = new SiteBean();
	currentSite.setId(new Long(currentSiteId));	

	List<SiteBean> selectedSitesList = assetService.getCommonSharedSites(assetIds);
	// remove the current site from list
	if(selectedSitesList != null && selectedSitesList.size() >0)
	{
		selectedSitesList.remove(currentSite);
	}			
	
	// if there is only site and if its id is 0 then it must be shared among "All sites".
	// so  in this case selected list will be all available sites.
	if(selectedSitesList.size() == 1)
	{
		SiteBean site = selectedSitesList.get(0);
		if(site  != null && site.getId() == 0)
		{
			List<SiteBean> availableSiteList = assetService.getCommonEnabledSites(assetIds);
			// remove the current site from list
			if(availableSiteList != null && availableSiteList.size() >0)
			{
				availableSiteList.remove(currentSite);
			}		
			availableSiteList.add(site);
			request.setAttribute("selectedSites", availableSiteList);		
		}
		else
		{
			request.setAttribute("selectedSites", selectedSitesList);					
		}
	}
	else
	{
		request.setAttribute("selectedSites", selectedSitesList);				
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