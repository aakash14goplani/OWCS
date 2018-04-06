<%@page import="java.util.Collections"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.cs.core.search.data.ResultRow"
%><%@page import="org.apache.commons.collections.CollectionUtils"
%><%@page import="java.util.Arrays"
%><%@page import="com.fatwire.services.beans.entity.StartMenuBean"
%><%@page import="com.fatwire.services.SiteService"
%><%@page import="java.util.ArrayList"
%><%@page import="com.fatwire.services.beans.asset.TypeBean"
%><%@page import="com.fatwire.services.SearchService"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@page import="com.fatwire.ui.util.SearchUtil"
%><%@page import="com.fatwire.cs.core.search.query.SortOrder"
%><%@page import="java.util.List"
%><%@page import="org.apache.commons.lang.math.NumberUtils"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {
	String searchText = ics.GetVar("searchText");
	// we have to replace the search text if it has _quote_ with single quote as
	// it got replace to avoid client side syntax errors.
	searchText = searchText != null ? SearchUtil.replaceSingleQuote(searchText):"";
	
	String searchField = request.getParameter("searchField");	
	String searchOperation = request.getParameter("searchOperation");
	String assetType = request.getParameter("assetType");
	String assetSubType = request.getParameter("assetSubType");	
	int rows = NumberUtils.toInt(request.getParameter("rows"), 1000);
	String sortColumn = request.getParameter("sort");
	String defaultSortColumn = request.getParameter("defaultSortColumn");
	String defaultSortOrder = request.getParameter("defaultSortOrder");
	List<SortOrder> sortList = null;
	SortOrder so = GenericUtil.getSortFields(sortColumn, defaultSortColumn, defaultSortOrder);
	if(so != null){
		sortList = Collections.singletonList(so);
	}	
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager =(ServicesManager)ses.getManager(ServicesManager.class.getName());
	SearchService searchService =  servicesManager.getSearchService();

	long siteId = GenericUtil.getLoggedInSite(ics);
	if (StringUtils.isNotBlank(ics.GetVar("publicationId")))
	{
		siteId = Long.valueOf(ics.GetVar("publicationId"));
	}
	List<TypeBean> assetTypeSubTypeList = new ArrayList<TypeBean>();
	if(StringUtils.isNotBlank(assetType)) {
		if(assetType.contains(",")) {
			String[]  assetTypeArr = assetType.split(",");
			for(String assetTypeEach : assetTypeArr) {
				TypeBean typeBean= new TypeBean();
				typeBean.setType(assetTypeEach);
				assetTypeSubTypeList.add(typeBean);
			}
		} else {
			TypeBean typeBean= new TypeBean();
			typeBean.setType(assetType);
			typeBean.setSubType(assetSubType);
			assetTypeSubTypeList.add(typeBean);
		}
	} else {
		SiteService siteService = servicesManager.getSiteService();
		List<StartMenuBean> smList = siteService.getStartMenus(Arrays.asList(StartMenuBean.Type.SEARCH),siteId);		
		List<StartMenuBean> filteredList = GenericUtil.filterStartMenuItems(smList, ics , true);
		if(CollectionUtils.isNotEmpty(filteredList)) {
 			for(StartMenuBean startMenu : filteredList) {
				TypeBean typeBn= new TypeBean();
				typeBn.setType(startMenu.getAssetType().getType());
				typeBn.setSubType(startMenu.getAssetType().getSubType());
				assetTypeSubTypeList.add(typeBn);
			}
		}
	}
	String searchType = request.getParameter("searchType");
	List<ResultRow> searchResults = null;
	searchResults = searchService.search(siteId, searchText, searchOperation, assetTypeSubTypeList, searchField, rows, sortList);
	request.setAttribute("searchResults", searchResults);
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>