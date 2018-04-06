<%@page import="com.fatwire.services.util.JsonUtil"
%><%@page import="com.fatwire.services.exception.ServiceException"
%><%@page import="COM.FutureTense.Interfaces.ICS"
%><%@page import="com.fatwire.services.AssetService"
%><%@page import="com.fatwire.services.SearchService"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@page import="com.fatwire.assetapi.data.AssetId"
%><%@page import="java.util.List"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.ui.beans.UIBookmarkBean"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {
	List<AssetId> assetIds = GenericUtil.emptyIfNull(JsonUtil.jsonToIdList(StringUtils.defaultString(request.getParameter("assetIds"))));
	//get the search service and add to active list
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager) ses.getManager(ServicesManager.class.getName());
	SearchService searchService = servicesManager.getSearchService();

	// create the pressentaion bean and set as a request attribute
	UIBookmarkBean bookmarkBean = new UIBookmarkBean();
	bookmarkBean.setNumberOfBookmarks(searchService.addBookmarks(assetIds));
	bookmarkBean.setRefreshKeys("Self:ActiveList");
	bookmarkBean.setStatus("true");
	request.setAttribute("bookmarkBean", bookmarkBean);
	
} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>