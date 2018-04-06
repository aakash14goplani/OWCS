<%@page import="com.fatwire.ui.util.GenericUtil"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ page import="org.apache.commons.lang.StringEscapeUtils"
%><cs:ftcs><%
	String id = GenericUtil.cleanString(request.getParameter("id"));
	String title = request.getParameter("title");
	String storeUrl = GenericUtil.buildControllerURL("UI/Data/DashBoard/SmartList", GenericUtil.JSON);
%><script>
	// unsubscribe to the events, this will unsubscribe if they are already subscribed
	// if we do not unsubscribe, when we refresh the tab, the refresh method getting called twice 	
	dojo.unsubscribe(savesearchupdatedSubscription);
	
	// listening to refreshSmartList event
	// REFACTORING TODO
	var savesearchupdatedSubscription = dojo.subscribe("fw/ui/document/search/savesearchupdated",  "refreshSmartList");
	
	function refreshSmartList(){
		//summary 
		//      This method fetches the smartlist from the SmartListAction and
		//      updates the smartlist grid's store and refreshes the grid.
		var grid = dijit.byId("smartListGrid");
		if (grid) {
			smartListStore = new fw.ui.dojox.data.CSItemFileWriteStore({
				url: '<%=storeUrl%>'
			});
			// reset the store for the grid and refresh
			if (grid.store) {
				grid.store.close();
			}
			grid.setStore(smartListStore);
			grid.startup();
			grid._refresh();
			grid.selection.deselectAll();
		}
	}
	
	function updateSmartListTitle(count){
		//Summary
		//		This method updates the title with the given count
		dijit.byId('<%=StringEscapeUtils.escapeJavaScript(id)%>').set('title', '<%=StringEscapeUtils.escapeJavaScript(title)%>'+' ('+count+')');
	}

	function _getGridStore(){
		//summary
		//		this function gets the store handle of the 'smartLitGrid'
		//return
		//		store obj of the grid
		var grid = dijit.byId("smartListGrid");
		var store;
		if(grid){
			store = grid.store;
		}
		return store;
	}

	function _getSelectedItem(){
		//summary
		//		this method gets the selected item of the smartListGrid's store
		//return
		//		selected item of the grid's store
		var item;
		var grid = dijit.byId("smartListGrid");	
		if(grid){
			items = grid.selection.getSelected();
			if(items && items.length == 1){
				item = items[0];
			}
		}
		return item;
	}
	
	function editSmartList(){
		//summary
		//		This method gets the smartlist grid's selected item's saveSearchId
		//		and publishes topic fw/ui/document/search/editSaveSearch'
		//		with ares [saveSearchId]. The searchcontroller who is listening to this
		//		topic will execute the actual edit.
		var grid = dijit.byId("smartListGrid");
		if(grid){
			items = grid.selection.getSelected();
			if(items && items.length == 1){
				var store = grid.store;
				var item = items[0];
				if(item && store){
					var saveSearchId = store.getValue(item, 'saveSearchId');
					SitesApp.event('search', 'edit-smartlist', saveSearchId); //dojo.publish('fw/ui/document/search/editsavesearch', [saveSearchId]);
				}
			}
			else{
				var view = SitesApp.getActiveView();
				view.clearMessage();
				view.warn("<xlat:stream key='UI/Search/SavedSearchMessage10'/>");
				return;
			}
		}
	}
	
	function deleteSmartList(){
		//summary
		//		This method gets the smartlist grid's selected item's saveSearchId
		//		and publishes topic fw/ui/document/search/deleteSaveSearch'
		//		with ares [saveSearchId]. The searchcontroller who is listening to this
		//		topic will execute the actual delete.
		var grid = dijit.byId("smartListGrid");		
		if(grid){
			items = grid.selection.getSelected();
			if(items && items.length == 1){
				var store = grid.store;
				var item = items[0];
				if(item && store){
					var saveSearchId = store.getValue(item, 'saveSearchId');
					SitesApp.event('search', 'delete-smartlist', saveSearchId);
					//dojo.publish('fw/ui/document/search/deletesavesearch', [saveSearchId]);
				}
			}
			else{
				var view = SitesApp.getActiveView();
				view.clearMessage();
				view.warn("<xlat:stream key='UI/Search/SavedSearchMessage10'/>");
				return;
			}
		}		
	}
</script>
<div data-dojo-type="dijit.layout.BorderContainer" data-dojo-props="'class':'fwPortletContainer'">
	<span data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'top','class':'portletTitleButtons'">
		<span 
			data-dojo-type="dijit.form.Button"
			data-dojo-props="
				onClick: function() {
					refreshSmartList();
				}
			"><img src="wemresources/images/ui/ui/dashboard/refreshIcon.png" height="26" width="26" alt="" title=""
		/></span>
		<span id="smartListPortletHelp" data-dojo-type="dijit.form.Button"
			><img src="wemresources/images/ui/ui/dashboard/helpIcon.png" height="26" width="26" alt="help" title="" 
		/></span>
		<span data-dojo-type="fw.ui.dijit.HoverableTooltip" data-dojo-props="connectedNodes:'smartListPortletHelp', position:'below','class':'helpTextTooltip'">
			<strong><xlat:stream key="UI/UC1/Layout/HowDoesItWork"/></strong><br />
			<xlat:stream key="UI/Search/SavedSearchHelpText"/>
		</span>
	</span>

	<div data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'center','class':'fwGridContainer'">
		<div
			id="smartListStore"
			data-dojo-id="smartListStore"
			data-dojo-type="fw.ui.dojox.data.CSItemFileWriteStore"
			data-dojo-props="url:'<%=storeUrl%>'">
		</div>
		
		<table 
			id="smartListGrid"
			data-dojo-type="fw.ui.dojox.grid.EnhancedGrid"
			data-dojo-props="
				store: smartListStore,
				noDataMessage: '<span class=gridMessageText><xlat:stream key="UI/Search/SavedSearchMessage6" escape="true"/></span>',
				sortInfo: 1,
				selectionMode: 'single',
				autoHeight: 10
			">
			
			<script type="dojo/connect" event="_onFetchComplete">
				var size = this.get('rowCount');
				var existingTitle = dijit.byId('<%=StringEscapeUtils.escapeJavaScript(id)%>').get('title').split(' (');
				dijit.byId('<%=StringEscapeUtils.escapeJavaScript(id)%>').set('title', existingTitle[0]+' ('+size+')');
				if(this.store._errMsg && this.store._errMsg !== ''){
					this.showMessage("<xlat:stream key='UI/Search/SavedSearchMessage11'/>");
				}
			</script>
			
			<script type="dojo/connect" event="onFetchError" args="error">
				fw.ui.app.onError(error);
			</script>
			
			<thead>
				<tr>
					<th field="name" formatter="fw.ui.GridFormatter.executeSavedSearchFormatter" width="auto"><xlat:stream key="UI/UC1/Layout/SmartListName"/></th>
					<th field="shareStatus" width="120px"><xlat:stream key="UI/UC1/Layout/ShareStatus"/></th>
				</tr>
			</thead>
		</table>
		
		<div class="buttonContainer">
			<div 
				data-dojo-type="fw.ui.dijit.Button"
				data-dojo-props="
					label:'<xlat:stream key="dvin/Common/Edit" escape="true"/>',
					onClick: function() {
						editSmartList();
					}
				">
			</div>
			<div 
				data-dojo-type="fw.ui.dijit.Button"
				data-dojo-props="
					label:'<xlat:stream key="UI/Search/DeleteSavedSearch" escape="true"/>',
					onClick: function() {
						deleteSmartList();
					}
				">
			</div>
		</div>
	</div> 
</div></cs:ftcs>