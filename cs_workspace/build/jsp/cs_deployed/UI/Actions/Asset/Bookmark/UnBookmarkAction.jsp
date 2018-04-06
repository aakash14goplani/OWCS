<%@page import="org.apache.commons.collections.CollectionUtils"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ page import="com.fatwire.services.ServicesManager"
%><%@ page import="com.fatwire.services.SearchService"
%><%@ page import="com.fatwire.system.*"
%><%@ page import="java.util.*"
%><%@ page import="com.fatwire.services.util.*"
%><%@ page import="com.fatwire.assetapi.data.AssetId"
%><%@page import="com.fatwire.services.ui.beans.UIBookmarkBean"
%><cs:ftcs><%
try {
	List<AssetId> assetIds = GenericUtil.emptyIfNull(JsonUtil.jsonToIdList(ics.GetVar("assetIds")));
	
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager(ServicesManager.class.getName());
	SearchService searchService = servicesManager.getSearchService();
	
	// remove the assets from the bookmarks
	boolean status = false;
	if(CollectionUtils.isNotEmpty(assetIds)) {
		status = searchService.removeBookmarks(assetIds);
	}
	
	// create the presentaion bean and set as a request attribute
	UIBookmarkBean bookmarkBean = new UIBookmarkBean();	
	bookmarkBean.setRefreshKeys("Root:ActiveList");
	bookmarkBean.setStatus(String.valueOf(status));
	request.setAttribute("bookmarkBean", bookmarkBean);	
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>