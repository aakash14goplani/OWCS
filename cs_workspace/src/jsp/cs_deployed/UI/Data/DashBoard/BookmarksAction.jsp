<%@page import="com.fatwire.services.beans.search.BookmarkBean"
%><%@page import="com.fatwire.services.SiteService"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.cs.core.search.query.SortOrder"
%><%@page import="COM.FutureTense.Interfaces.ICS"
%><%@page import="com.fatwire.services.ui.beans.UISearchResultBean"
%><%@page import="com.fatwire.assetapi.data.AssetId"
%><%@page import="java.util.*"
%><%@page import="org.apache.commons.collections.CollectionUtils"
%><%@page import="com.fatwire.services.SearchService"
%><%@page import="com.fatwire.services.SearchServiceImpl"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.Session"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.cs.ui.framework.LocalizedMessages"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ page import="com.fatwire.services.constants.ServiceConstants"
%><%@page import="com.fatwire.services.AssetService"
%><%@page import="com.fatwire.assetapi.data.AssetData"
%><%@page import="com.openmarket.xcelerate.interfaces.IAsset"
%><%@page import="com.fatwire.services.util.AssetUtil"
%><cs:ftcs><%
try {
	SortOrder sortOrder = GenericUtil.getSortFields(StringUtils.defaultString(request.getParameter("sort"), "name"));
	long siteId = GenericUtil.getLoggedInSite(ics);
	final String userLocale = LocalizedMessages.getLocaleString(ics);

	// get the search service and add to active list
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager) ses.getManager(ServicesManager.class.getName());
	SearchService searchService = servicesManager.getSearchService();
	AssetService assetService = servicesManager.getAssetService();

	List<BookmarkBean> bns = GenericUtil.emptyIfNull(searchService.getBookmarks());
	if(CollectionUtils.isNotEmpty(bns)) {
		List<UISearchResultBean> bookmarks = new ArrayList<UISearchResultBean>();
		final TimeZone userTimeZone = TimeZone.getTimeZone((String)session.getAttribute("time.zone"));
		for(BookmarkBean each : bns) {
			UISearchResultBean  bookmark = new UISearchResultBean();
			bookmark.addCustomField("asset", each.getAssetId());
			AssetData assetData = assetService.read(each.getAssetId(), Arrays.asList(IAsset.NAME));
			Object nameData = AssetUtil.getAttribute(assetData, IAsset.NAME);
			String name = nameData == null ? "" : String.valueOf(nameData);
			String type = AssetUtil.getAssetTypeDescription(assetData);
			bookmark.addCustomField("name", name);
			bookmark.addCustomField("id", Long.toString(each.getAssetId().getId())+":"+each.getAssetId().getType());
			bookmark.addCustomField("assetTypeDescription", type);
			String dtStr = LocalizedMessages.getLocalizedDatetime(userTimeZone, userLocale, GenericUtil.parseDate(each.getCreatedDate(), ServiceConstants.DB_DATE_FORMAT), null);
			long dtVal = GenericUtil.parseDate(each.getCreatedDate(), ServiceConstants.DB_DATE_FORMAT).getTime();
			bookmark.addCustomField("bookmarkCreateDateStr", dtStr);
			bookmark.addCustomField("bookmarkCreateDate", dtVal);
			bookmarks.add(bookmark);
		}
		request.setAttribute("result", bookmarks);
	}
} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>