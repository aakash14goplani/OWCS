<%@page import="org.apache.commons.lang.BooleanUtils"
%><%@page import="org.apache.commons.collections.CollectionUtils"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.services.SiteService"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@ page import="org.apache.commons.configuration.beanutils.ConfigurationDynaBean"
%><%@ page import="com.fatwire.ui.util.SearchUtil"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="controller" uri="futuretense_cs/controller.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@page import="com.fatwire.cs.ui.framework.LocalizedMessages"
%><cs:ftcs><%
try {
	ConfigurationDynaBean configBean = (ConfigurationDynaBean) request.getAttribute("thumbnailviewconfig");
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
	String sort = GenericUtil.cleanString(request.getParameter("sort"));

	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager) ses.getManager(ServicesManager.class.getName());
	SiteService siteService = servicesManager.getSiteService();
	List<String> localeList = siteService.getLocales(GenericUtil.getLoggedInSite(ics));
	boolean dimensionEnabled = CollectionUtils.isNotEmpty(localeList);
	String allString = LocalizedMessages.all.getLocalizedValue(ics);
	String pageStepSize = configBean.containsKey("pagestepsize") ? String.valueOf(configBean.get("pagestepsize")) : "\"10\", \"25\", \"50\", \"100\", \""+allString+"\"";
	String itemsperpage = StringUtils.defaultString(request.getParameter("pageSize"), String.valueOf(configBean.get("numberofitemsperpage")));
	String defaultsortfield = String.valueOf(configBean.get("defaultsortfield"));
	String defaultsortorder = String.valueOf(configBean.get("defaultsortorder"));
	String formatter = String.valueOf(configBean.get("formatter"));
	String query = BooleanUtils.toBoolean(browse) ? SearchUtil.buildBrowseQuery(request, configBean, "thumbnail") : SearchUtil.buildSearchQuery(ics, request, configBean, "thumbnail");
	%><%-- Load context menu --%>
	<div dojoType="fw.dijit.UIMenu" id='listRowMenu' cleanOnClose="true" style="display: none;"></div>
	
	<div data-dojo-type="<%=storeType %>"
		 data-dojo-id="thumbnailViewStore"
		 data-dojo-props="
			url: '<%=actionUrl%>',
			requestMethod: 'post'
		 ">
	</div>
	<div data-dojo-type="dijit.layout.BorderContainer" style="height:auto;width:auto;position:absolute;bottom:0;top:0;left:0;right:0;border:1px solid #ddd;padding:1px;background:#fff;">
		<div data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'top'">
			<!-- Load tp bar -->
			<controller:callelement elementname="UI/Layout/CenterPane/Search/View/SearchTopBar">
				<controller:argument name="sort" value="<%=sort%>" /> 
				<controller:argument name="select" value="true" />
				<controller:argument name="viewType" value="thumbnail" />
				<controller:argument name="defaultSortField" value="<%= defaultsortfield%>" />
				<controller:argument name="defaultSortOrder" value="<%= defaultsortorder%>" />
				<controller:argument name="searchType" value="<%=searchType%>" />
				<controller:argument name="browse" value="<%=browse%>" />
				<controller:argument name="assetTypeParam" value='<%=GenericUtil.cleanString(request.getParameter("assetType"))%>' />
			</controller:callelement>
		</div>
	
		<div data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'center','class':'thumbnailViewContainer thumbnailFullView'">
			<table
				id="searchGrid"
				data-dojo-type="fw.ui.dojox.grid.EnhancedGrid"
				data-dojo-props='
					store: thumbnailViewStore,
					query: <%=query%>,
					noDataMessage: "<span class=gridMessageText><xlat:stream key='UI/UC1/Layout/SearchInfo1' escape='true'/></span>",
					errorMessage: "<xlat:stream key='UI/UC1/Layout/defaultSearchErrorMessage' escape='true'/>",
					rowsPerPage: <%= itemsperpage%>,
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
			
			<script type="dojo/connect" event="startup">
				this.layout.cells[0].defaultValue = "";

				if(!fw.ui.GridFormatter.imageViewDialog) {
					var dlg = fw.ui.GridFormatter.imageViewDialog = new fw.dijit.UILightbox;
					dlg.startup();
				}

				dojo.connect(this.viewsNode, 'onclick', this, function(evt) {
					var closest = dojo.query(evt.target).closest(dojo.query('.dojoxGridRow'));
					if(!closest.length) {
						this.selection.deselectAll();
					}
				});
				// extending scrollIntoView method in dojox Grid's focusManager
				//		to fix automatic scroll when we select an item in grid view
				dojo.safeMixin(this.focus, {
					scrollIntoView: function(){
						var info = (this.cell ? this._scrollInfo(this.cell) : null);
						if(!info || !info.s){
							return null;
						}
						var rt = this.grid.scroller.findScrollTop(this.rowIndex);
						// place cell within horizontal view
						if(info.n && info.sr){
							if(info.n.offsetLeft + info.n.offsetWidth > info.sr.l + info.sr.w){
								info.s.scrollLeft = info.n.offsetLeft + info.n.offsetWidth - info.sr.w;
							}else if(info.n.offsetLeft < info.sr.l){
								info.s.scrollLeft = info.n.offsetLeft;
							}
						}
						// place cell within vertical view
						if(info.r && info.sr){
							if(rt + info.r.offsetHeight > info.sr.t + info.sr.h){
								//this.grid.setScrollTop(rt + info.r.offsetHeight - info.sr.h);
							}else if(rt < info.sr.t){
								this.grid.setScrollTop(rt);
							}
						}

						return info.s.scrollLeft;
					}
				});
			</script>
			<script type="dojo/connect" event="onCellContextMenu" args="row">
				dojo.publish('/fw/ui/contextmenu/update', [this, 'listRowMenu', row]);
			</script>
			<script type="dojo/connect" event="_onFetchComplete">
				SitesApp.searchController.preSelectRow();
				SitesApp.searchController.updateNumItems(this.store._numRows);
			</script>
			<script type="dojo/connect" event="onFetchError" args="error">
				error.message = "<xlat:stream key='UI/UC1/Layout/SearchErrorMessage'/>";
				SitesApp.onError(error);
			</script>
			
			<script type="dojo/connect" event="onRowDblClick" args="row">
				var store = this.store;
				var item = this.getItem(row.rowIndex);
				var asset = store.getValue(item, 'asset');
				var isLink = store.getValue(item, 'fwlink');
				var docId = store.getValue(item, 'document-id') || fw.util.getId(asset);
				var docType = store.getValue(item, 'document-type') || fw.util.getType(asset);
				if(isLink === true){
						fw.ui.GridFormatter.open(docType, docId);	
				}				
			</script>
			<thead>
				<tr>
					<th field="name" formatter="<%= formatter%>" cellStyles="height:100px;" width="auto"></th>
				</tr>
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