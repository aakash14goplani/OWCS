<%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.services.beans.search.BookmarkBean"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><%@ page import="java.util.*"
%><%@ page import="com.fatwire.services.beans.entity.TreeNodeBean"
%><%@ page import="com.fatwire.assetapi.data.*"
%><%@ page import="com.openmarket.xcelerate.asset.AssetIdImpl"
%><%@ page import="com.fatwire.services.dao.helper.Tags"
%><%@ page import="com.fatwire.system.*"
%><%@ page import="com.fatwire.services.dao.helper.asset.AssetDataHelper"
%><%@ page import="com.openmarket.xcelerate.interfaces.*"
%><%@ page import="com.fatwire.services.*"
%><%@ page import="com.fatwire.services.ServicesManager"
%><%@ page import="com.fatwire.cs.ui.framework.UIException"
%><cs:ftcs><%
try{
	List<TreeNodeBean> nodeList = new LinkedList<TreeNodeBean>();

	// get the search service and add to active list
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager =(ServicesManager)ses.getManager(ServicesManager.class.getName());
	SearchService searchService =  servicesManager.getSearchService();
	List<BookmarkBean> bookmarks =  searchService.getBookmarks();
	for (BookmarkBean each : bookmarks) {
		// TODO: Replace with Asset service
		AssetData assetData =  AssetDataHelper.getAssetData(ics, each.getAssetId());
		if( assetData != null ) {
			String name = (String)assetData.getAttributeData(IAsset.NAME).getData();
			// Generate the Node 
			TreeNodeBean node = new TreeNodeBean(String.valueOf(asset.getId()), asset.getType(), name);
			node.setNodeType("asset"); // TODO remove hardcoded string
			// Set the OkAction (Right-click operations ) 
			// TODO don't harcode functions
			
			node.setOkFunctions("viewstatus;inspect;edit;preview;delete;treerefresh");
			// Execute my function inspect 
			node.setExecuteFunction("inspect") ; 

			nodeList.add(node);
		}
	}
	ics.setAttribute("nodeList", nodeList);
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
