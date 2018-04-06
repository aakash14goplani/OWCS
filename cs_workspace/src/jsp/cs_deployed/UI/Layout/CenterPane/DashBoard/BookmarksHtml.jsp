<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="controller" uri="futuretense_cs/controller.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ page import="org.apache.commons.lang.StringEscapeUtils"
%><cs:ftcs><%
try {
	String id = request.getParameter("id");
	String title = request.getParameter("title");	
	String storeUrl = GenericUtil.buildControllerURL("UI/Data/DashBoard/Bookmarks", GenericUtil.JSON);
%><script type="text/javascript">
	// subscribe to bookmark updates, if we're not already
	if (typeof bookmarksUpdate === 'undefined') {
		// listens to bookmark updates
		bookmarksUpdate = dojo.subscribe('/fw/ui/tree/refresh', 'refreshBookmarks');
	}
	
	//if the context menu already exists, destroy it.
	//leaving it out causes duplicate id during refresh.
	if(dijit.byId('bookmarkMenu')){
		dijit.byId('bookmarkMenu').destroyRecursive();
	}
	
	
	function unbookmark() {
		var grid = dijit.byId('bookmarkGrid');
		var selectedItems = grid.getSelectedDocuments();
		if (selectedItems.length > 0) {
			SitesApp.event('bulk', 'unbookmark', {selection: selectedItems});
		} else {
			var view = SitesApp.getActiveView();
			view.clearMessage();
			view.warn("<xlat:stream key='UI/UC1/Layout/BookmarkInfoMessage3'/>");
			return;
		}	
	}
	
	
	function refreshBookmarks(args){
		//summary 
		//		This method fetches the bookmarks from the BookmarkAction and
		//		updates the bookmarks grid's store and refreshes the grid.
		var grid, refreshKeys;
		
		if (args) {
			refreshKeys = args.refreshKeys;
			if (refreshKeys !== 'Root:ActiveList' && refreshKeys !== 'Self:ActiveList') {
				return;
			}
		}
		
		grid = dijit.byId("bookmarkGrid");
		if (grid) {
			bookmarkStore = new fw.ui.dojox.data.CSItemFileWriteStore({
				url: '<%=storeUrl%>'
			});
			// reset the store for the grid and refresh
			if (grid.store) {
				grid.store.close();
			}
			grid.setStore(bookmarkStore);
			//startup grid after the store set.
			grid.startup();
			grid._refresh();
			grid.selection.deselectAll();
		}
	}
</script>
<div dojoType="fw.dijit.UIMenu" id='bookmarkMenu' cleanOnClose="true" style="display: none;"></div>
<div data-dojo-type="dijit.layout.BorderContainer" data-dojo-props="'class':'fwPortletContainer'">
	<span data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'top','class':'portletTitleButtons'">
		<span 
			data-dojo-type="dijit.form.Button"
			data-dojo-props="
				onClick: function() {
					refreshBookmarks();
				}
			"><img src="wemresources/images/ui/ui/dashboard/refreshIcon.png" height="26" width="26" alt="" title=""
		/></span>
		<span id="bookmarkPortletHelp" data-dojo-type="dijit.form.Button"
			><img src="wemresources/images/ui/ui/dashboard/helpIcon.png" height="26" width="26" alt="help" title="" 
		/></span>
		<span data-dojo-type="fw.ui.dijit.HoverableTooltip" data-dojo-props="connectedNodes:'bookmarkPortletHelp', position:'below','class':'helpTextTooltip'">
			<strong><xlat:stream key="UI/UC1/Layout/HowDoesItWork"/></strong><br />
			<xlat:stream key="UI/UC1/Layout/BookmarkHelpText"/>
		</span>
	</span>
	<div data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'center','class':'fwGridContainer'">
		<div 
			id="bookmarkStore"
			data-dojo-id="bookmarkStore"
			data-dojo-type="fw.ui.dojox.data.CSItemFileWriteStore"
			data-dojo-props="url:'<%= storeUrl%>'">
		</div>
		<table 
			id="bookmarkGrid"
			data-dojo-type="fw.ui.dojox.grid.EnhancedGrid"
			data-dojo-props="
				store: bookmarkStore,
				noDataMessage: '<span class=gridMessageText><xlat:stream key="UI/UC1/Layout/BookmarkNoDataMessage" escape="true"/></span>',
				sortInfo: 1,
				autoHeight: 10,
				plugins: {
					menus: {rowMenu: 'bookmarkMenu'}
				}
			">
			<script type="dojo/connect" event="onCellContextMenu" args="row">
				dojo.publish('/fw/ui/contextmenu/update', [this, 'bookmarkMenu', row, 'bookmarkContextMenus']);
			</script>
			<script type="dojo/connect" event="_onFetchComplete">
				var size = this.get('rowCount');
				var existingTitle = dijit.byId('<%=id%>').get('title').split(' (');
				dijit.byId('<%=id%>').set('title', existingTitle[0]+' ('+size+')');
				if(this.store._errMsg && this.store._errMsg !== ''){
					this.showMessage("<xlat:stream key='UI/UC1/Layout/ErrorMessage1'/>");
				}
			</script>
			<script type="dojo/connect" event="onFetchError" args="error">
					SitesApp.onError(error);
			</script>
			<thead>
				<tr>
					<th field="name" formatter="fw.ui.GridFormatter.nameFormatter" width="auto"><xlat:stream key="dvin/UI/AssetMgt/AssetName"/></th>
					<th field="assetTypeDescription" width="120px"><xlat:stream key="dvin/Common/AssetType"/></th>
					<th field="bookmarkCreateDate" dataType="Number" width="120px" formatter="fw.ui.GridFormatter.bookmarkDateFormatter"><xlat:stream key="UI/UC1/Layout/BookmarkedOn"/></th>
				</tr>
			</thead>
		</table>
		<div class="buttonContainer">
			<div 
				data-dojo-type="fw.ui.dijit.Button"
				data-dojo-props="
					label:'<xlat:stream key="UI/UC1/Layout/DeleteBookmarkButtonText" escape="true"/>',
					onClick: function() {
						unbookmark();
					}
				">
			</div>
		</div>
	</div> 
</div><%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>