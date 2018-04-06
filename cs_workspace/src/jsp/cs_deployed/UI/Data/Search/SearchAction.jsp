<%@page import="java.util.Collections"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.beans.search.SearchCriteria"
%><%@page import="com.fatwire.services.beans.search.SmartList"
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
%><%@ page import="org.apache.commons.configuration.beanutils.ConfigurationDynaBean"
%><%@page import="com.fatwire.services.SiteService"
%><%@page import="com.fatwire.services.ui.beans.UISearchResultBean"
%><%@page import="com.fatwire.services.beans.asset.basic.DimensionBean"
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
	//if its runSaveSearch
	if(StringUtils.equalsIgnoreCase(searchType, "runSaveSearch")) {
		long ssId = NumberUtils.toLong(StringUtils.defaultString(request.getParameter("saveSearchId")));
		SmartList savedSearch = searchService.getSmartList(ssId);
		if(savedSearch != null) {
			SearchCriteria searchCriteria = savedSearch.getSearchCriteria();
			searchResults = searchService.search(searchCriteria, rows, sortList);
		}
	}
	// advanced search goes here
	else if(StringUtils.equalsIgnoreCase(searchType, "advanced")) {
		SearchCriteria  searchCriteria = SearchUtil.buildSearchCriteria(ics, request, siteId);
		searchResults = searchService.search(searchCriteria, rows, sortList);
	}
	//its the regular search
	else {
		searchResults = searchService.search(siteId, searchText, searchOperation, assetTypeSubTypeList, searchField, rows, sortList);
	}
	SiteService siteService = servicesManager.getSiteService();
	List<String> enabledTypes = siteService.getEnabledTypes(GenericUtil.getLoggedInSite(ics));
	boolean dimensionEnabled = CollectionUtils.isNotEmpty(enabledTypes) && enabledTypes.contains(DimensionBean.DIMENSION);
	
	// based on the view type (list ot thumbnail) build the results, as the building results involes the use of the
	// respective configuration object, so we need to do it for list and thumbnail seperately.
	String view = request.getParameter("searchView");
	List<UISearchResultBean> results = new ArrayList<UISearchResultBean>();
	if("thumbnail".equalsIgnoreCase(view)){
		ConfigurationDynaBean configBean = (ConfigurationDynaBean) request.getAttribute("thumbnailviewconfig");		
		results = SearchUtil.buildThumbnailData(ics, searchResults, configBean, dimensionEnabled);
	}
	else{		
		ConfigurationDynaBean configBean = (ConfigurationDynaBean) request.getAttribute("listviewconfig");		
		results = SearchUtil.buildListData(ics, searchResults, configBean, dimensionEnabled);
	}
	request.setAttribute("results", results);
	
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>