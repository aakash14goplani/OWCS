<%@page import="com.fatwire.ui.util.GenericUtil"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="controller" uri="futuretense_cs/controller.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ page import="org.apache.commons.lang.StringEscapeUtils"
%><cs:ftcs>
<%
	String id = request.getParameter("id");
	String title = request.getParameter("title");
	String storeUrl = GenericUtil.buildControllerURL("UI/Data/DashBoard/Workflow", GenericUtil.JSON);
%><script type="text/javascript">
	if (typeof workflowUpdate === 'undefined') {
		//listen to workflowstatuschanged event
		workflowUpdate = dojo.subscribe("/fw/ui/model/update/workflowStatus", "refreshWorkflow");
	}
	
	//if the context menu already exists, destroy it.
	//leaving it out causes duplicate id during refresh.
	if(dijit.byId('workflowMenu')){
		dijit.byId('workflowMenu').destroyRecursive();
	}

	function finishAssignment(){
		//Summary
        //      this function calls the application controllers onContextMenu
        //      to invoke the 'finishassignment' function for the selected asset in the
        //      workflow grid.
		var assetData = getSelectedAssignment();
		console.debug("[WorkflowHtml] - finishAssignment() asset", assetData);	
		if(assetData) {
			var target = fw.util.buildDocId(assetData);
			SitesApp.event(target, 'finishassignment' );			
		}
	}
	
	function getSelectedAssignment(){
		//Summary
		//    This method returns the selected asset from the workflow grid	
		//returns 
		//		asset{type:assetType, id:assetId, name:assetName}
		var grid = dijit.byId("workFlowGrid");
		var asset, store, assetObj, item;
		if(grid){
			// get the selected items, we are interested in first item
			items = grid.selection.getSelected();
			if(items && items.length == 1){
				store = grid.store;
				item = items[0];
				if(item && store){
					assetObj = store.getValue(item, 'asset');
					// get the selected asset
					asset = {
						"type": assetObj.type[0],
						"id": assetObj.id[0],
						"name": store.getValue(item, 'name')
					};
				}
			}
			else{
				var view = SitesApp.getActiveView();
				view.clearMessage();
				view.warn("<xlat:stream key='UI/UC1/Layout/AssignmentErrorMessage1'/>");
				return;
			}
		}
		return asset;
	}
	
	function refreshWorkflow(){
		//summary 
		//      This method fetches the assignments from the WorkflowAction and
		//      updates the workflow grid's store and refreshes the grid.
		var grid = dijit.byId("workFlowGrid");
		if(grid){
			workFlowStore = new fw.ui.dojox.data.CSItemFileWriteStore({
				url: '<%=storeUrl%>'
			});
			// reset the store for the grid and refresh
			if (grid.store) {
				grid.store.close();
			}
			grid.setStore(workFlowStore);
			//startup grid after the store set.
			grid.startup();
			grid._refresh();
			grid.selection.deselectAll();
		}
	}
</script>
	<div dojoType="fw.dijit.UIMenu" id='workflowMenu' cleanOnClose="true" style="display: none;"></div>

	<div data-dojo-type="dijit.layout.BorderContainer" data-dojo-props="'class':'fwPortletContainer'">
	<span data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'top','class':'portletTitleButtons'">
		<span 
			data-dojo-type="dijit.form.Button"
			data-dojo-props="
				onClick: function() {
					refreshWorkflow();
				}
			"><img src="wemresources/images/ui/ui/dashboard/refreshIcon.png" height="26" width="26" alt="" title=""
		/></span>
		<span id="assignmentPortletHelp" data-dojo-type="dijit.form.Button"
			><img src="wemresources/images/ui/ui/dashboard/helpIcon.png" height="26" width="26" alt="help" title="" 
		/></span>
		<span data-dojo-type="fw.ui.dijit.HoverableTooltip" data-dojo-props="connectedNodes:'assignmentPortletHelp', position:'below','class':'helpTextTooltip'">
			<strong><xlat:stream key="UI/UC1/Layout/HowDoesItWork"/></strong><br />
			<xlat:stream key="UI/UC1/Layout/AssignmentHelpText"/>
		</span>
	</span>
	
	<div data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'center','class':'fwGridContainer'">
		<div 
			id="workFlowStore"
			data-dojo-id="workFlowStore"
			data-dojo-type="fw.ui.dojox.data.CSItemFileWriteStore"
			data-dojo-props="url:'<%=storeUrl%>'">
		</div>
		<table 
			id="workFlowGrid"
			data-dojo-type="fw.ui.dojox.grid.EnhancedGrid"
			data-dojo-props="
				store: workFlowStore,
				noDataMessage: '<span class=gridMessageText><xlat:stream key="UI/UC1/Layout/AssignmentNoDataMessage" escape="true"/></span>',
				sortInfo: 1,
				selectionMode: 'single',
				autoHeight: 10,
				plugins: {
					menus: {rowMenu: 'workflowMenu'}
				}
			">
			
			<script type="dojo/connect" event="onCellContextMenu" args="row">
				dojo.publish('/fw/ui/contextmenu/update', [this, 'workflowMenu', row, 'workflowContextMenus']);
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
					<th field="name" formatter="fw.ui.GridFormatter.nameFormatter" width="100px"><xlat:stream key="dvin/UI/AssetMgt/AssetName"/></th>
					<th field="actionToTake" formatter="fw.ui.GridFormatter.workflowStateFormatter" width="auto"><xlat:stream key="dvin/Common/ActionToTake"/></th>
					<th field="assignedBy" width="80px"><xlat:stream key="dvin/UI/Wf/AssignedBy"/></th>
					<th field="dueDays" formatter="fw.ui.GridFormatter.dueDaysFormatter" width="70px"><xlat:stream key="UI/UC1/Layout/DueDays"/></th>
				</tr>
			</thead>
		</table>
		<div class="buttonContainer">
			<div
				data-dojo-type="fw.ui.dijit.Button"
				data-dojo-props="
					label: '<xlat:stream key="UI/UC1/Layout/FinishAssignments" escape="true"/>',
					onClick: function() {
						finishAssignment();
					}
				">
			</div>
		</div>
	</div> 
</div></cs:ftcs>