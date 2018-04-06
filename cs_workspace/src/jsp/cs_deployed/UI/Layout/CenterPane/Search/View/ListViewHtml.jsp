<%@page import="com.fatwire.services.beans.asset.basic.DimensionBean"
%><%@page import="org.apache.commons.collections.CollectionUtils"
%><%@page import="com.fatwire.services.SiteService"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="java.util.List"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.services.ui.beans.UISearchResultField"
%><%@page import="org.apache.commons.lang.BooleanUtils"
%><%@ page import="org.apache.commons.configuration.beanutils.ConfigurationDynaBean"
%><%@ page import="com.fatwire.ui.util.SearchUtil"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="controller" uri="futuretense_cs/controller.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@page import="com.fatwire.cs.ui.framework.LocalizedMessages"
%><cs:ftcs><%try {
	ConfigurationDynaBean configBean = (ConfigurationDynaBean) request.getAttribute("listviewconfig");
	String browse = StringUtils.defaultString(GenericUtil.cleanString(request.getParameter("browse")));
	String storeElement;
	String storeType;
	if (configBean.containsKey("storeElement") && StringUtils.isNotBlank(String.valueOf(configBean.get("storeElement")))) {
		storeElement = String.valueOf(configBean.get("storeElement"));
	}
	else {				
		storeElement = BooleanUtils.toBoolean(browse) ? "UI/Data/Search/Browse" : "UI/Data/Search/Search";
	}
	if (configBean.containsKey("storeType")) {
		storeType = String.valueOf(configBean.get("storeType"));
	}
	else {
		storeType = "fw.ui.dojox.data.CSQueryReadStore";
	}
	
	String actionUrl = GenericUtil.buildControllerURL(storeElement, GenericUtil.JSON);
	String searchType = StringUtils.defaultString(GenericUtil.cleanString(request.getParameter("searchType")));	
	String sortField = StringUtils.defaultString(GenericUtil.cleanString(request.getParameter("sort")));

	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager) ses.getManager(ServicesManager.class.getName());
	SiteService siteService = servicesManager.getSiteService();
	List<String> enabledTypes = siteService.getEnabledTypes(GenericUtil.getLoggedInSite(ics));
	boolean dimensionEnabled = CollectionUtils.isNotEmpty(enabledTypes) && enabledTypes.contains(DimensionBean.DIMENSION);

	String numberofitemsperpage = String.valueOf(configBean.get("numberofitemsperpage"));
	String allString = LocalizedMessages.all.getLocalizedValue(ics);
	String pageStepSize = configBean.containsKey("pagestepsize") ? String.valueOf(configBean.get("pagestepsize")) : "\"10\", \"25\", \"50\", \"100\", \""+allString+"\"";
	String sortInfo = SearchUtil.getSortInfo(ics, configBean, dimensionEnabled, sortField);
	String query = BooleanUtils.toBoolean(browse) ? SearchUtil.buildBrowseQuery(request, configBean, "list") : SearchUtil.buildSearchQuery(ics, request, configBean, "list");
	boolean isSingleColumn = (configBean != null && configBean.containsKey("columns.column.fieldname") && (configBean.get("columns.column.fieldname") instanceof String));
	List<UISearchResultField> columnsToDisplay = SearchUtil.getColumnList(ics, configBean, dimensionEnabled);%><%-- Load the context menu --%>
	
	<div dojoType="fw.dijit.UIMenu" id='listRowMenu' cleanOnClose="true" style="display: none;"></div>	
	
	<div data-dojo-type="<%=storeType %>"
		data-dojo-id="listViewStore"
		data-dojo-props="
			url: '<%=actionUrl%>',
			requestMethod: 'post'
		">
	</div>

	<div data-dojo-type="dijit.layout.BorderContainer" style="height:auto;width:auto;position:absolute;bottom:0;top:0;left:0;right:0;border:1px solid #ddd;padding:1px;background:#fff;">
		<div data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'top'">
			<controller:callelement elementname="UI/Layout/CenterPane/Search/View/SearchTopBar">
				<controller:argument name="viewType" value="list" />
				<controller:argument name="searchType" value="<%= searchType%>" />
				<controller:argument name="browse" value="<%= browse%>" />
				<controller:argument name="assetTypeParam" value='<%=GenericUtil.cleanString(request.getParameter("assetType"))%>' />
			</controller:callelement>
		</div>
		<div data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'center'">
			<table 
				id="searchGrid"
				data-dojo-type="fw.ui.dojox.grid.EnhancedGrid"
				data-dojo-props='
					store:listViewStore,
					query:<%=query%>,
					noDataMessage: "<span class=gridMessageText><xlat:stream key='UI/UC1/Layout/SearchInfo1' escape='true'/></span>",
					errorMessage: "<xlat:stream key='UI/UC1/Layout/defaultSearchErrorMessage' escape='true'/>",
					rowsPerPage: <%=numberofitemsperpage%>,
					sortInfo: <%=sortInfo%>,
					plugins: {
						menus: { rowMenu: "listRowMenu" },
						pagination: {
							pageSizes: [<%=pageStepSize%> ],
							
							description: true,
							sizeSwitch: true,
							pageStepper: true,
							gotoButton: false,
							maxPageStep: 7,
							position: "bottom"
						}
					}
				'>
				<script type="dojo/connect" event="onCellContextMenu" args="row">
					dojo.publish('/fw/ui/contextmenu/update', [this, 'listRowMenu', row]);
				</script>
				<script type="dojo/connect" event="startup">
					SitesApp.searchController.sort(this);
				</script>
				<script type="dojo/connect" event="onHeaderClick">
					SitesApp.searchController.sort(this);
				</script>
				<script type="dojo/connect" event="_onFetchComplete">
					SitesApp.searchController.preSelectRow();
					SitesApp.searchController.updateNumItems(this.store._numRows);
				</script>
				<script type="dojo/connect" event="onFetchError" args="error">
					error.message = "<xlat:stream key='UI/UC1/Layout/SearchErrorMessage'/>";
					SitesApp.onError(error);
				</script>
				<thead>
					<tr><%
						for(UISearchResultField column : columnsToDisplay) {
					%><th field='<%= column.getFieldname()%>' formatter='<%= column.getFormatter()%>' width='<%= column.getWidth()%>'><%= column.getDisplayname()%></th><%
					}%></tr>
				</thead>
			</table>
		</div>
	</div>
<%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>