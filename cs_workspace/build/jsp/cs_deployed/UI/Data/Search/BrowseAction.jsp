<%@page import="com.fatwire.services.beans.search.SearchCriteria"
%><%@page import="java.util.Collections"
%><%@page import="com.openmarket.xcelerate.asset.AssetIdImpl"
%><%@page import="com.fatwire.services.TreeService"
%><%@page import="com.fatwire.cs.core.search.query.SortOrder"
%><%@page import="org.apache.commons.lang.math.NumberUtils"
%><%@page import="com.fatwire.cs.core.search.data.ResultRow"
%><%@page import="com.fatwire.services.util.AssetUtil"
%><%@page import="com.fatwire.assetapi.data.AssetId"
%><%@page import="org.apache.commons.lang.BooleanUtils"
%><%@page import="java.util.Map"
%><%@page import="java.net.URLDecoder"
%><%@page import="com.fatwire.services.SearchService"
%><%@page import="com.fatwire.services.SearchServiceImpl"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@page import="org.apache.commons.collections.CollectionUtils"
%><%@page import="java.util.List"
%><%@page import="java.util.ArrayList"
%><%@page import="com.fatwire.ui.util.SearchUtil"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="controller" uri="futuretense_cs/controller.tld"
%><%@ page import="org.apache.commons.configuration.beanutils.ConfigurationDynaBean"
%><%@page import="com.fatwire.services.SiteService"
%><%@page import="com.fatwire.services.ui.beans.UISearchResultBean"
%><%@page import="com.fatwire.services.beans.asset.basic.DimensionBean"
%><%@page import="com.fatwire.services.beans.entity.TreeNodeBean"
%><cs:ftcs><%
try {
	String browseUrl = (String)request.getParameter("browseUrl");
	List<ResultRow> searchResults = null;
		
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager( ServicesManager.class.getName() );
	
	if(StringUtils.isNotBlank(browseUrl)) {
		long siteId = GenericUtil.getLoggedInSite(ics);
		int rows = NumberUtils.toInt(request.getParameter("rows"), 1000);
		
		// get the sort information to build the SortOrder 
		String sortColumn = StringUtils.defaultIfEmpty(request.getParameter("sort"), request.getParameter("sortField"));
		String defaultSortColumn = StringUtils.defaultString(request.getParameter("defaultSortColumn"));
		String defaultSortOrder = StringUtils.defaultString(request.getParameter("defaultSortOrder"));
		List<SortOrder> sortList = null;
		SortOrder sortOrder = GenericUtil.getSortFields(sortColumn, defaultSortColumn, defaultSortOrder);
		if(sortOrder != null){
			sortList = Collections.singletonList(sortOrder);
		}
		
		SearchService searchService =  servicesManager.getSearchService();
		int index = URLDecoder.decode(browseUrl).indexOf("?");
		String queryString = URLDecoder.decode(browseUrl).substring(index+1);
		
		Map<String, String> paramMap = GenericUtil.toParamMap(queryString);
		boolean browse = paramMap.containsKey("browse") && BooleanUtils.toBoolean(paramMap.get("browse"));
		// when the browse is true we are not searching for immediate children rather 
		// we get the list of asset ids from tree service and call search tree node to get details from lucene
		if(browse) {
			TreeService treeDataService = servicesManager.getTreeService();
			// Query for the Immediate List of Asset Children Nodes associated
			// for this parent node that needs to be disclosed
			List<TreeNodeBean> nodes = treeDataService.getChildren(browseUrl, null, 0, false);
			List<AssetId> childrenList = new ArrayList<AssetId>();
			if (nodes.size() != 0) {
				for (TreeNodeBean node : nodes) {
					if (node.getAssetType() != null && node.getId() != null) {
						childrenList.add(new AssetIdImpl(node.getAssetType(), Long.parseLong(node.getId())));
					}
				}
			}
			//call search service to search the asset ids from lucene where we pass the optimum maxQueryNum as 200
			searchResults = SearchServiceImpl.searchTreeNode(ics, siteId, childrenList, 200, rows, sortOrder);
		} else {
			String assetType = paramMap.get("AssetType");
			String assetId = paramMap.get("assetid");
			if(StringUtils.isNotBlank(assetType)) {
				// if the assetid is null and if its not flex asset then it should be 
				// basic so just search for given assettype.
				if(StringUtils.isBlank(assetId) && !AssetUtil.isFlexAsset(ics, assetType)) {
					SearchCriteria sc = new SearchCriteria(assetType);
					sc.setSiteId(siteId);
					searchResults = searchService.search(sc, rows, sortList);
				}
				// else search for immediate children of the given assetid
				if(StringUtils.isNotBlank(assetId)) {
					AssetId parentId = new AssetIdImpl(assetType, NumberUtils.toLong(assetId));
					SearchCriteria sc = new SearchCriteria(parentId);
					sc.setSiteId(siteId);
					searchResults = searchService.search(sc, rows, sortList);
				}
			}
	    }
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