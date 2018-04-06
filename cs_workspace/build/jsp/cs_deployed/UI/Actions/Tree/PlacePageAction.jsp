<%@page import="com.fatwire.services.SiteService"%>
<%@page import="com.fatwire.services.beans.asset.basic.PageBean"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld" %>
<%@page import="com.fatwire.services.ui.beans.UITreeBean"%>
<%@page  import="java.util.*"%>
<%@ page import="com.fatwire.assetapi.data.AssetId"%>
<%@ page import="com.fatwire.services.TreeService"%>
<%@ page import="com.fatwire.services.ServicesManager"%>
<%@ page import="com.openmarket.xcelerate.asset.AssetIdImpl"%>
<%@ page import="com.fatwire.system.SessionFactory"%>
<%@ page import="com.fatwire.system.Session"%>
<%@page import="com.fatwire.cs.ui.framework.UIException"%>
<%@page import="org.codehaus.jackson.map.ObjectMapper"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.fatwire.services.beans.entity.SitePlanNodeBean"%>
<%@page import="com.fatwire.services.ui.beans.UISitePlanPlace"%>
<%@page import="com.fatwire.services.util.JsonUtil"%>
<%@page import="com.fatwire.assetapi.data.AssetId"%>
<%@page import="org.apache.commons.lang.StringUtils"%>

<cs:ftcs>
<%
try
{	
	// Get the SPN DND  Node Players OBJECT 
	// parameter key = spnDNDPlace 
	// site plan node's  dnd players (  child, previous,target )  			 
	String spnJSON = (String)request.getParameter("spnDNDPlace");
	
	// Deserilize into a SitePlan Place represents the encaspulation  
	// DND  Node Players  Object 	
	UISitePlanPlace spn = new ObjectMapper().readValue(spnJSON, UISitePlanPlace.class);
	
	// Get the list of children reordering
	String json = ics.GetVar("assets");
		
	List<AssetId> assetIds = new ArrayList<AssetId>() ; 
	
	if (StringUtils.isNotBlank(json)) {
		 assetIds = JsonUtil.jsonToIdList(json);		
	}
	 	
	// get handle to tree data service
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );
	SiteService siteService = servicesManager.getSiteService();
	
	boolean status = false;
	
	// Build the list of children Pages to Place 
	List<AssetId> children = new ArrayList<AssetId>();
		
   	// Place / Move the DND child page in SitePlan 
    status = siteService.placePagesSPN( spn.getChild(), spn.getTarget(), assetIds, spn.getPrevious() ) ; 						  
 	
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
%></cs:ftcs>