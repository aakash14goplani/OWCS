<%@page import="com.fatwire.ui.util.GenericUtil"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="controller" uri="futuretense_cs/controller.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ page import="org.apache.commons.lang.StringEscapeUtils"
%><cs:ftcs><%
	String id = request.getParameter("id");
	String title = request.getParameter("title");
	String storeUrl = GenericUtil.buildControllerURL("UI/Data/DashBoard/Checkouts", GenericUtil.JSON);
%><script type="text/javascript">
	// unsubscribe to the events, this will unsubscribe if they are already subscribed
	// if we do not unsubscribe, when we refresh the tab, the refresh method getting called twice
	if (typeof checkoutsUpdate === 'undefined') {
		// listens to update in the versioningStatus field of any document
		// TODO rewire when sync issue is found...
		checkoutsUpdate = dojo.subscribe('/fw/ui/model/update/versioningStatus', refreshCheckouts);
		checkoutcontextmenuSubscription = dojo.subscribe("fw/ui/dashboard/checkoutcontextmenu",  "checkoutContextMenu");
	}
	
	//if the context menu already exists, destroy it.
	//leaving it out causes duplicate id during refresh.
	if(dijit.byId('checkoutMenu')){
		dijit.byId('checkoutMenu').destroyRecursive();
	}
	
	function checkoutContextMenu(args) {
		// summary
		//		this function calls the application controller's onContextMenu
		//		to invoke the  function  specified in the function id.
		// args
		//		{label: 'label', functionid: 'functionId'} 
		var assets = getSelectedCheckedoutAssets();
		if (!assets) {
			var view = SitesApp.getActiveView();
			view.clearMessage();
			view.warn("<xlat:stream key='UI/UC1/Layout/CheckoutInfoMessage1' escape='true'/>");
			return;
		}
		else{
			// publish the generic 'oncontext' event
			//TODO this has to be fixed for handling multiple selections once onContextMenu() handles multiple assets
			// the following line should basically be 
			//dojo.publish('/fw/ui/app/oncontext', [{functionid: args.functionid, asset:assets}]);
			dojo.publish('/fw/ui/app/oncontext', [{functionid: args.functionid, asset:assets[0]}]);
		}
	}
	
	function checkin(){
		//Summary
		//	This function brings up the checkin in dialog and prompting for chekin
		//  Calls the versioning service to checkin the selected assets and refreshes the checkout 
		//  grid.
		var assets = getSelectedCheckedoutAssets(),self=this;		
		if(assets.length === 0){
			var view = SitesApp.getActiveView();
			view.clearMessage();
			view.warn("<xlat:stream key='UI/UC1/Layout/CheckoutInfoMessage1' escape='true' />");
			return;
		}
		var requestService = fw.ui.ObjectFactory.createServiceObject('request');
		// load the checkin html so show the checkin UI.
		requestService.sendControllerRequest({ 
			elementName:'UI/Layout/CenterPane/DashBoard/CheckIn',
			responseType: 'html',
			requestType : 'post'
		}).then(function(response){
			var dialogManager = fw.ui.ObjectFactory.createManagerObject('dialog');
			var cp = new dijit.layout.ContentPane();
			cp.setContent(response);
			dialogManager.openDialogPane(cp,
			{
				buttonList: [
					{
						label: "<xlat:stream key='UI/UC1/Layout/Checkin' escape='true'/>",
						type: 'OK',
						action: function(){
							var versioningService = fw.ui.ObjectFactory.createServiceObject("versioning");
							var comment = dojo.byId("checkinComment").value;
							var keepCheckedOut = dojo.byId("keepCheckedOut").checked;
							var assetIds = [];
							dojo.forEach(assets, function(asset){
								assetIds.push(asset.type + ":" + asset.id);
							});
							
							versioningService.invoke(assetIds, 'checkin', {
								"keepCheckedOut": keepCheckedOut,
								"comment": comment
							}).then(function(response){
								self.reloadCheckoutGrid();
								SitesApp.getActiveView().info("<xlat:stream key='UI/UC1/Layout/CheckinSuccess' escape='true' />");
							},
							function(err){
								SitesApp.onError(error);
							});
							var dlg = dialogManager.getEnclosingDialog(this.domNode);
							if(dlg) dlg.destroyRecursive();
						}
					},
					{
						label: "<xlat:stream key='dvin/UI/Cancel' escape='true'/>",
						type: 'Cancel',
						action: function() {
							var dlg = dialogManager.getEnclosingDialog(this.domNode);
							if(dlg) dlg.destroyRecursive();
						}
					}
				]
			});			
		},
		function(err){
			console.error("[CheckoutHtml] - checkin - Error during checkin", err);
			fw.ui.app.onError(err);
		});
	}
	

	function getSelectedCheckedoutAssets() {
		//Summary
		//    This method returns the selected assets from the chekout grid	
		//returns 
		//		assets [{type:assetType, id:assetId, name:assetName}, {}...]
		var grid = dijit.byId("checkoutGrid");
		var asset, store, assets = [], items;
		if(grid){
			items = grid.selection.getSelected();
			store = grid.store;
			if (items.length > 0) {
				// Iterate through the list of selected items to get asset ids and type 
				dojo.forEach(items, function(selectedItem) {
					if (selectedItem !== null) {
						var selectedAsset = store.getValue(selectedItem, 'asset')
						asset = {
							"type": selectedAsset.type[0],
							"id": selectedAsset.id[0],
							"name":store.getValue(selectedItem, 'name')
						};
						assets.push(asset);
					}
				});
			}
		}
		return assets;
	}
	
	function reloadCheckoutGrid(){
		var grid = dijit.byId("checkoutGrid");
		
		if (grid) {
			checkoutStore = new fw.ui.dojox.data.CSItemFileWriteStore({
				url: '<%=storeUrl%>'
			});
			// reset the store for the grid and refresh
			if (grid.store) {
				grid.store.close();
			}
			
			// TODO this blows up in some conditions without the setTimeout
			// some sync issue...don't we need to wait for the store to load???
			//setTimeout(function() {
				grid.setStore(checkoutStore);
				//startup grid after the store set.
				grid.startup();
				grid._refresh();
				grid.selection.deselectAll();
			//}, 0);
		}		
	}
	
	function refreshCheckouts(doc, oldValue, newValue){
		//summary 
		//      This method fetches the chekouts from the chekoutAction and
		//      updates the chekout grid's store and refreshes the grid.
		if(doc){
			if(doc.tracked === true){
				var item = checkoutStore._getItemByIdentity(doc.id.getId());
				// if the item is in the grid, its already checked out, so it has to update
				// if the newValues checkedOut property is false.
				if(item){
					var currentValue = checkoutStore.getValue(item, 'checkedOut');
					if(newValue && newValue.checkedOut === false){      
						reloadCheckoutGrid();
					}
				}
				else{
					// on the other hand the item corresponding the doc id is 
					// not in the grid, so in this case if the newValues's checked out property is true, the
					// grid needs a refresh.
					if(newValue && newValue.checkedOut === true){
						reloadCheckoutGrid();
					}
				}
			}
		}
		// this is for bulk checkins, there is not doc associated with these notifications
		else{
			reloadCheckoutGrid();
		}
	}
	
	function handleCheckoutContextMenu(grid, row){
		if(!grid){
			return;
		}
		grid.selection.setSelected(row.rowIndex,1);
		var menu = dijit.byId('checkoutMenu');
		var children = menu.getChildren();
		var isLink = true, item;
		items = grid.selection.getSelected();
		if (items.length > 0) {
			// Iterate through the list of selected items and set the 'isLink' flag to false 
			// if any of the row has 'fwLink' false. in other words isLink is true if all of the 
			// selected rows  'fwLink' property is true 
			var selectionCount = items.length;	
			for(var i=0; i<selectionCount; i++){
				item = items[i];
				if(!grid.store.getValue(item, 'fwlink')){
					isLink = false;
					break;
				}
			}
		}
		
		//if the selection count is more than 1, we have to consider 
		//bulk operation and isLink property 
		if (selectionCount > 1) {
			for(var i=0, len = children.length; i<len; i++){
				var child = children[i];
				if(child.bulkoperation === 'yes'){
					if(isLink === true){
						child.set('disabled', false);
					}else{
						child.set('disabled', true);
					}
				}
				else{
					child.set('disabled', true);
				}
			}
		}		
		//if the selection count is 1, we have to consider the isLink property alone
		if(selectionCount == 1){
			if(isLink === false){
				for(var i=0, len = children.length; i<len; i++){
					var child = children[i];
					child.set('disabled', true);
				}
			}
			else{
				for(var i=0, len = children.length; i<len; i++){
					var child = children[i];
					child.set('disabled', false);
				}
			}
		}
	}
</script>

	
<!-- Load the context menu -->
<div dojoType="fw.dijit.UIMenu" id='checkoutMenu' cleanOnClose="true" style="display: none;"></div>

<div data-dojo-type="dijit.layout.BorderContainer" data-dojo-props="'class':'fwPortletContainer'">
	<span data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'top','class':'portletTitleButtons'">
		<span 
			data-dojo-type="dijit.form.Button"
			data-dojo-props="
				onClick: function() {
					reloadCheckoutGrid();
				}
			"><img src="wemresources/images/ui/ui/dashboard/refreshIcon.png" height="26" width="26" alt="" title=""
		/></span>
		<span id="checkoutPortletHelp" data-dojo-type="dijit.form.Button"
			><img src="wemresources/images/ui/ui/dashboard/helpIcon.png" height="26" width="26" alt="help" title="" 
		/></span>
		<span data-dojo-type="fw.ui.dijit.HoverableTooltip" data-dojo-props="connectedNodes:'checkoutPortletHelp', position:'below','class':'helpTextTooltip'">
			<strong><xlat:stream key="UI/UC1/Layout/HowDoesItWork"/></strong><br />
			<xlat:stream key="UI/UC1/Layout/CheckoutHelpText"/>
		</span>
	</span>
	
	<div data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'center','class':'fwGridContainer'">
		<div
			id="checkoutStore"
			data-dojo-id="checkoutStore"
			data-dojo-type="fw.ui.dojox.data.CSItemFileWriteStore"
			data-dojo-props="url:'<%=storeUrl%>'">
		</div>	
		<table 
			id="checkoutGrid"
			data-dojo-type="fw.ui.dojox.grid.EnhancedGrid"
			data-dojo-props="
				store: checkoutStore,
				noDataMessage: '<span class=gridMessageText><xlat:stream key="UI/UC1/Layout/CheckoutsNoDataMessage" escape="true"/></span>',
				sortInfo: 1,
				autoHeight: 10,
				plugins: {
					menus: {rowMenu: 'checkoutMenu'}
				}
			">
			
			<script type="dojo/connect" event="onCellContextMenu" args="row">
				dojo.publish('/fw/ui/contextmenu/update', [this, 'checkoutMenu', row, 'checkoutContextMenus']);
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
				console.error('An error occurred while fetching data for the checkout widget', error);
			</script>
				
			<thead>
				<tr>
					<th field="name" formatter="fw.ui.GridFormatter.nameFormatter" width="auto"><xlat:stream key="dvin/UI/AssetMgt/AssetName"/></th>
					<th field="type" width="120px"><xlat:stream key="dvin/UI/AssetType"/></th>
					<th field="daysCheckedOut" formatter="fw.ui.GridFormatter.dayDiffFormatter" width="120px"><xlat:stream key="UI/UC1/Layout/DaysCheckedOut"/></th>
				</tr>
			</thead>
		</table>
		
		<div class="buttonContainer">
			<div 
				data-dojo-type="fw.ui.dijit.Button"
				data-dojo-props="
					label:'<xlat:stream key="UI/UC1/Layout/Checkin" escape="true"/>',
					onClick: function() {
						checkin();
					}
				">
			</div>
		</div>
	</div>
</div></cs:ftcs>