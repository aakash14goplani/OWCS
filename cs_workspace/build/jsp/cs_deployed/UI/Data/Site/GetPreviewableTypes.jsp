<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><%@ page import="com.fatwire.ui.util.GenericUtil"
%><%@ page import="com.fatwire.services.ServicesManager"
%><%@ page import="com.fatwire.system.SessionFactory"
%><%@ page import="com.fatwire.system.Session"
%><%@ page import="com.fatwire.services.SiteService"
%><%@ page import="java.util.*"
%><%@ page import="com.fatwire.assetapi.def.*"
%><cs:ftcs>
<%
	//determines the full list of asset types previewable for the site
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager(ServicesManager.class.getName());
	SiteService siteService = servicesManager.getSiteService();
	// determines the full list of asset types enabled for the site
	List<String> enabledTypes = siteService.getEnabledTypes(GenericUtil.getLoggedInSite(ics));
	List<String> previewableTypes = new ArrayList<String>();
	
	// for the enabled assets types, find out which ones are previewable.
	for(String assetType:enabledTypes){
		AssetTypeDefManager mgr = (AssetTypeDefManager) ses.getManager(AssetTypeDefManager.class.getName());
		AssetTypeDef def = mgr.findByName(assetType, null);
		if(def != null){
			AssetTypeDefProperties props = def.getProperties();
			if(props != null){
				if(props.isCanPreview()){
					previewableTypes.add(assetType);
				}
			}
		}
	}
	request.setAttribute("previewableTypes", previewableTypes);	
%>
</cs:ftcs>