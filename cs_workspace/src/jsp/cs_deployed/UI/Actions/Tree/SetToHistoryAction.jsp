<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="COM.FutureTense.Util.ftErrors"
%><%@ page import="COM.FutureTense.Util.ftMessage"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.services.ui.beans.UITreeBean"
%><cs:ftcs>
<%
	// Get the Asset opened and loaded in workspace tab 
	String assettype = request.getParameter("AssetType");
	String id = request.getParameter("id");
	String name = request.getParameter("name");
	long siteId = GenericUtil.getLoggedInSite(ics);

	// Set the history parameter with postfix the logged in user's 
	// site id  	
	String siteHistory = "_history_"+GenericUtil.getLoggedInSite(ics)+"_"; 
	String history = ics.GetSSVar(siteHistory);
	
	String status  = "true" ; 
	
	if (history == null || history.length()==0) {
			ics.SetSSVar(siteHistory, id + "," + assettype);
	} else {
		String currentAsset = id + "," + assettype;
		// Is the asset tracked in site history
		if (history.indexOf(currentAsset) == -1) {
			String newHistory = currentAsset + ";" + history;
			ics.SetSSVar(siteHistory, newHistory);
		}
		else {
			// Its already history tracked and 
			// has already been added to site history 
			status = "true" ; 
		}
	}
	
	history = ics.GetSSVar(siteHistory);
	String refreshKey = "Root:History" ; 	
	UITreeBean treeBn = new UITreeBean();
	//treeBn.setTreeid("systemTree");
	treeBn.setRefreshKeys(refreshKey);
	treeBn.setStatus(status);
	request.setAttribute("treeBean", treeBn);
%>
</cs:ftcs>