<%@page import="com.fatwire.services.beans.search.BookmarkBean"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.services.SearchService"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@page import="com.fatwire.assetapi.data.AssetId"
%><%@page import="com.fatwire.services.util.JsonUtil"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {
	final AssetId assetId = JsonUtil.jsonToId(ics.GetVar("assetId"));

	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager(ServicesManager.class.getName());
	SearchService searchService = servicesManager.getSearchService();

	// Find out if this asset been bookmarked
	List<BookmarkBean> bookmarks  = GenericUtil.emptyIfNull(searchService.getBookmarks());
	Boolean bookmarked = GenericUtil.some(bookmarks, new GenericUtil.Predicate<BookmarkBean>() {
		public boolean evaluate(BookmarkBean each) {
			return each.getAssetId().equals(assetId);
		}
	}) == null;
	request.setAttribute( "bookmarked", bookmarked);
} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>