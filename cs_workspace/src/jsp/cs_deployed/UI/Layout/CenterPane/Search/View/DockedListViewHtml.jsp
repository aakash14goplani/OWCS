<%@page import="org.apache.commons.lang.BooleanUtils"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.ui.beans.UISearchResultField"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.services.beans.asset.basic.DimensionBean"
%><%@page import="org.apache.commons.collections.CollectionUtils"
%><%@page import="com.fatwire.services.SiteService"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@page import="com.fatwire.ui.util.GenericUtil"
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
	String allString = LocalizedMessages.all.getLocalizedValue(ics);
	String pageStepSize = configBean.containsKey("pagestepsize") ? String.valueOf(configBean.get("pagestepsize")) : "\"10\", \"25\", \"50\", \"100\", \""+allString+"\"";
	String numberofitemsperpage = String.valueOf(configBean.get("numberofitemsperpage"));
	String defaultsortfield = String.valueOf(configBean.get("defaultsortfield"));
	String defaultsortorder = String.valueOf(configBean.get("defaultsortorder"));
	String query = BooleanUtils.toBoolean(browse) ? SearchUtil.buildBrowseQuery(request, configBean, "list") : SearchUtil.buildSearchQuery(ics, request, configBean, "list");
	String sort = StringUtils.defaultString(GenericUtil.cleanString(request.getParameter("sort")));

	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager) ses.getManager(ServicesManager.class.getName());
	SiteService siteService = servicesManager.getSiteService();
	List<String> enabledTypes = siteService.getEnabledTypes(GenericUtil.getLoggedInSite(ics));
	boolean dimensionEnabled = CollectionUtils.isNotEmpty(enabledTypes) && enabledTypes.contains(DimensionBean.DIMENSION);

	List<UISearchResultField> listToDisplay = SearchUtil.getColumnList(ics, configBean, dimensionEnabled);
%><%-- Load the context menu --%>
	<div dojoType="fw.dijit.UIMenu" id='listRowMenu' cleanOnClose="true" style="display: none;"></div>
	<!--  
        XSS - updates the Search Tab grid's store filter and 
        encode store's json response search result items 
    -->
	<div data-dojo-type="<%=storeType%>"
		 data-dojo-id="dockListViewStore"
		 data-dojo-props="
			url: '<%=actionUrl%>',
			requestMethod: 'post'
		">
	</div>	
	<div data-dojo-type="dijit.layout.BorderContainer" style="height:auto;width:auto;position:absolute;bottom:0;top:0;left:0;right:0;border:1px solid #ddd;padding:1px;background:#fff;">
		<div data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'top'">
			<!-- Load top bar -->
			<controller:callelement elementname="UI/Layout/CenterPane/Search/View/SearchTopBar">
				<controller:argument name="close" value="true" />
				<controller:argument name="viewType" value="list" />
				<controller:argument name="browse" value="<%=browse%>" />
				<controller:argument name="sort" value="<%=sort%>" />
				<controller:argument name="dock" value="true" />
				<controller:argument name="defaultSortField" value="<%= defaultsortfield%>" />
				<controller:argument name="defaultSortOrder" value="<%= defaultsortorder%>" />
				<controller:argument name="select" value="true" />
				<controller:argument name="assetTypeParam" value='<%=GenericUtil.cleanString(request.getParameter("assetType"))%>' />
			</controller:callelement>
		</div>
		<div data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'center','class':'dockListView'">
			<table
				id="searchGrid"
				data-dojo-type="fw.ui.dojox.grid.EnhancedGrid"
				data-dojo-props='
					store: dockListViewStore,
					query: <%=query%>,
					canSort: function(){return false;},
					selectionMode:"single",
					noDataMessage: "<span class=gridMessageText><xlat:stream key='UI/UC1/Layout/SearchInfo1' escape='true'/></span>",
					errorMessage: "<xlat:stream key='UI/UC1/Layout/defaultSearchErrorMessage' escape='true'/>",
					rowsPerPage: <%=numberofitemsperpage%>,
					plugins: {
						menus: { rowMenu: "listRowMenu" },
						dnd:{
							copyOnly: true,
							dndConfig: {
								row: {
									within: false,
									out: true
								},
								col: false,
								cell: false
							}
						},
						pagination: {
							pageSizes: [<%=pageStepSize %>],
							description: true,
							sizeSwitch: false,
							pageStepper: true,
							gotoButton: false,
							maxPageStep: 0,
							position: "bottom"
						}
					}
				'>
			<script type="dojo/connect" event="startup">
				dojo.connect(this.viewsNode, 'onmouseenter', function() {
					SitesApp.searchController.showTooltipRowIndex = -1;
					SitesApp.searchController.hideTooltipRowIndex = -1;
				});
			</script>
			<script type="dojo/connect" event="onCellMouseOver" args="row">
				var param = [];
				var showTooltip = false;
				var asset, type, item = this.getItem(row.rowIndex);
				asset = this.store.getValue(item, 'asset');
				type = asset.type;
				<%for(UISearchResultField column : listToDisplay) {%>
					var label = '<%=column.getDisplayname()%>';
					var field = '<%=column.getFieldname()%>';
					var visible = <%=column.getDisplayintooltip()%>;
					var value = this.store.getValue(item, field);
					param.push({"label":label, "value":value, "visible":visible});
					if(visible) {
						showTooltip = true;
					}
				<%}%>
				// show the tooltip if there is data and visible flag is true
				if(param.length > 0 && showTooltip) {
					SitesApp.searchController.displayTooltip(param, row, type);
				}
			</script>
			<script type="dojo/connect" event="onCellMouseOut" args="row">
				dijit.hideTooltip(row.cellNode);
				SitesApp.searchController.hideTooltipRowIndex = row.rowIndex;
			</script>
			<script type="dojo/connect" event="onCellContextMenu" args="row">
				dojo.publish('/fw/ui/contextmenu/update', [this, 'listRowMenu', row]);
			</script>
			<script type="dojo/connect" event="_onFetchComplete">
				SitesApp.searchController.preSelectRow();
			</script>
			<script type="dojo/connect" event="onFetchError" args="error">
				error.message = "<xlat:stream key='UI/UC1/Layout/SearchErrorMessage'/>";
				SitesApp.onError(error);
			</script>
			<thead>
				<tr><%
					// Display only first column
						if(CollectionUtils.isNotEmpty(listToDisplay)) {
							UISearchResultField column0 = listToDisplay.get(0);
				%><th field='<%= column0.getFieldname()%>' formatter='<%= column0.getFormatter()%>' width='auto'><%= column0.getDisplayname()%></th><%
				}%></tr>
			</thead>
			</table>
		</div>
	</div><%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>