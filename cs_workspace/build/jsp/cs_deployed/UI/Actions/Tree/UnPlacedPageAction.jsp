<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@page  import="java.util.*"
%><%@ page import="com.openmarket.basic.interfaces.IListObject"
%><%@ page import="com.openmarket.basic.interfaces.ListObjectFactory"
%><%@ page import="com.fatwire.assetapi.data.AssetId"
%><%@ page import="com.fatwire.services.SiteService"
%><%@ page import="com.fatwire.services.ServicesManager"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="com.openmarket.xcelerate.asset.AssetIdImpl"
%><%@ page import="com.fatwire.insite.utils.AssetIdConverter"
%><%@ page import="com.fatwire.system.SessionFactory"
%><%@ page import="com.fatwire.system.Session"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.ui.beans.UITreeBean"%>
<%@page import="com.fatwire.services.beans.asset.basic.PageBean"%>
<%@page import="org.codehaus.jackson.map.ObjectMapper"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.fatwire.services.beans.entity.SitePlanNodeBean"%>
<%@page import="com.fatwire.services.ui.beans.UISitePlanPlace"%>
<%@page import="com.fatwire.services.util.JsonUtil"%>
<%@page import="com.fatwire.assetapi.data.AssetId"%>
<%@page import="org.apache.commons.lang.StringUtils"%>

<cs:ftcs>
<%
try{
	//Get the Parent and associated children list 
	String spnJSON = (String)request.getParameter("spnDNDPlace");
	
	// Deserilize into a SitePlan Place represents the encaspulation  
	// DND  Node Players  Object 
	
	UISitePlanPlace spn = new ObjectMapper().readValue(spnJSON, UISitePlanPlace.class);
	
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );
	SiteService siteService = servicesManager.getSiteService();
	
	boolean status = true;
		   	  	
 	// Get the list of children reordering
	String json = ics.GetVar("assets");
	
	List<AssetId> assetIds = new ArrayList<AssetId>() ; 	
	if (StringUtils.isNotBlank(json)) {
		  assetIds = JsonUtil.jsonToIdList(json);		
	}
	
	// Validate and Unplace the Child page from previous parent
	status = siteService.unPlacePagesSPN(spn.getChild(),spn.getPrevious(),spn.getTarget(),assetIds) ;
	
	UITreeBean treeBn = new UITreeBean();
	treeBn.setStatus(Boolean.toString(status));	
	request.setAttribute("treeBean", treeBn);
		
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