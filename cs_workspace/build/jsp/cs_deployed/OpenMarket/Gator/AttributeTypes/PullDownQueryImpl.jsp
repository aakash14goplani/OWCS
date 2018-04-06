<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%//
// OpenMarket/Gator/AttributeTypes/PullDownQueryImpl
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.DateFormat"%>
<cs:ftcs>

<satellite:link pagename="OpenMarket/Gator/AttributeTypes/PullDownQueryResults" assembler="query" outstring="pullDownUrl">
	<satellite:argument name="numberOfResults" value='-1'/>
	<satellite:argument name="queryAssetName" value='<%=ics.GetVar("queryAssetName")%>'/>
	<satellite:argument name="attribType" value='<%=ics.GetVar("AttrType")%>'/>
</satellite:link>

<div>
	<div id='PullDown_<%=ics.GetVar("AttrID")%>'></div>
	<div id='PullDownWrapper_<%=ics.GetVar("AttrID")%>'></div>
</div>

<ics:if condition='<%="single".equalsIgnoreCase(ics.GetVar("EditingStyle"))%>'>
<ics:then>
<%
	String savedValue = ics.GetVar("MyAttrVal");
	if ("date".equals(ics.GetVar("AttrType")) && Utilities.goodString(savedValue)) {
		DateFormat simpleFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date convDate = new Date();
		convDate = (Date) simpleFormat.parse(savedValue);
		savedValue = simpleFormat.format(convDate);
	}
%>
	<input type="hidden" name='<%=ics.GetVar("cs_SingleInputName")%>' 
		   value='<%= Utilities.goodString(savedValue) ? savedValue : "" %>' />
	
	<script type="text/javascript">
	
		dojo.addOnLoad(function() {
			var nodeName = '<%=ics.GetVar("cs_SingleInputName")%>',
				attributeType = '<%= "asset".equalsIgnoreCase( ics.GetVar("AttrType") ) ? "asset" : ""%>',
				pullDownStore_<%=ics.GetVar("AttrID")%> = new dojox.data.QueryReadStore({
					doClientPaging:true,
					doClientSorting:true,
					url:'<%=ics.GetVar("pullDownUrl")%>',
					getIdentity: function(/* item */ item){
						//	summary:
						//		Method is overridden
						var identifier = null;
						if(this._identifier === Number){						
							identifier = item.i[this._labelAttr]; // Overridden line
						}else{
							identifier = item.i[this._identifier];
						}
						return identifier;
					},
					fetchItemByIdentity: function ( /* Object */ keywordArgs){
						//	summary:
						//		Method is overridden
						if(this._itemsByIdentity){
							var item = this._itemsByIdentity[keywordArgs.identity];
							if(!(item === undefined)){
								if(keywordArgs.onItem){
									var scope = keywordArgs.scope ? keywordArgs.scope : dojo.global;
									keywordArgs.onItem.call(scope, {i:item, r:this});
								}
								return;
							}
						}
				
						// Otherwise we need to go remote
						// Set up error handler
						var _errorHandler = function(errorData, requestObject){
							var scope = keywordArgs.scope ? keywordArgs.scope : dojo.global;
							if(keywordArgs.onError){
								keywordArgs.onError.call(scope, errorData);
							}
						};
						
						// Set up fetch handler
						var _fetchHandler = function(items, requestObject){
							var scope = keywordArgs.scope ? keywordArgs.scope : dojo.global;
							try{
								// There is supposed to be only one result
								var item = null;
								if(items && items.length == 1){
									item = items[0];
								}
								else if (items && items.length > 1) {
									item = items[0];
								}
								
								// If no item was found, item is still null and we'll
								// fire the onItem event with the null here
								if(keywordArgs.onItem){
									keywordArgs.onItem.call(scope, item);
								}
							}catch(error){
								if(keywordArgs.onError){
									keywordArgs.onError.call(scope, error);
								}
							}
						};
						
						// Construct query
						var request = {serverQuery:{value: keywordArgs.identity}}; // Overridden line
						if (attributeType === "asset")
							this._identifier = "assetid";
						// Dispatch query
						this._fetchItems(request, _fetchHandler, _errorHandler);				
					}
				});
			
			var pullDownNode = dojo.byId('PullDown_<%=ics.GetVar("AttrID")%>'),
				pullDownWid_<%=ics.GetVar("AttrID")%> = new fw.dijit.UISimpleSelect({
					value: '<%= Utilities.goodString(savedValue) ? savedValue : "" %>',
					store: pullDownStore_<%=ics.GetVar("AttrID")%>,
					searchAttr: 'value',
					labelAttr: 'value',
					hasDownArrow: true,
					clearButton: false,
					pageSize: <%= Utilities.goodString(ics.GetVar("PAGESIZE")) ? ics.GetVar("PAGESIZE") : 10 %>,
					cs_environment: '<%= "ucform".equalsIgnoreCase("cs_enviroment") ? "ucform" : "" %>',
					maxVals: -1,
					name:'_<%=ics.GetVar("cs_SingleInputName")%>',
					onChange: function(){
						var	valueStr = "",
							valueNode = dojo.query("input[name=" + nodeName + "]")[0],
							selectedItem = this.item;
						if(valueNode && attributeType === 'asset' && selectedItem && selectedItem !== null)	
							valueNode.value = this.store.getValue(selectedItem, "assetid");
						else if(selectedItem && selectedItem !== null)
							valueNode.value = this.store.getValue(selectedItem, "value");
					}
				}, pullDownNode);
				
			dojo.connect(pullDownWid_<%=ics.GetVar("AttrID")%>, 'startup', function() {
				dojo.addClass(this.domNode, 'defaultFormStyle');
			});	
			
			pullDownWid_<%=ics.GetVar("AttrID")%>.startup();
			
			var refreshbutton_<%=ics.GetVar("AttrID")%> = new fw.ui.dijit.form.RefreshButton({}, 'PullDownWrapper_<%=ics.GetVar("AttrID")%>', 'last');
			
			dojo.connect(refreshbutton_<%=ics.GetVar("AttrID")%>, "onIconClick", pullDownWid_<%=ics.GetVar("AttrID")%>,  function(){
				this.store._lastServerQuery = null;			
				//this.reset();
				this.loadDropDown();
				var loadingCompleteHandler = dojo.connect(pullDownWid_<%=ics.GetVar("AttrID")%>, "_openResultList", function() {
					var selectedItem = this.item;					
					refreshbutton_<%=ics.GetVar("AttrID")%>.loadingComplete();
					
					if (selectedItem && selectedItem !== null) {
						selectedValue = attributeType === 'asset' ? this.store.getValue(selectedItem, "assetid") : 
																	this.store.getValue(selectedItem, "value");
						this.set('value', selectedValue);					
					}
					this.closeDropDown();
					dojo.disconnect(loadingCompleteHandler);
				});
			});	
				
		});		
		
	</script>
	
</ics:then>
<ics:else>
<%	
	StringBuilder builder = new StringBuilder("");
	if ("date".equals(ics.GetVar("AttrType"))) {
		DateFormat simpleFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date convDate = new Date();
		IList attrValueList = ics.GetList("AttrValueList");
		int numOfAttrValues = attrValueList.numRows();		
		String currValue = "";
		for (int i = 0; i < numOfAttrValues; i++) {
			currValue = attrValueList.getValue("value");
			if (Utilities.goodString(currValue)) {			
				convDate = (Date) simpleFormat.parse(currValue);
				if(i != 0)
					builder.append(",");
				builder.append(simpleFormat.format(convDate));
			}
			attrValueList.moveToRow(IList.next, i);	
		}
	}
	else
		builder = (StringBuilder) ics.GetObj("strAttrValues");
%>
	<script type="text/javascript">
	
		dojo.addOnLoad(function() {
			var nodeName = '<%=ics.GetVar("cs_SingleInputName")%>',
				attributeType = '<%= "asset".equalsIgnoreCase( ics.GetVar("AttrType") ) ? "asset" : ""%>',
				pullDownStore_<%=ics.GetVar("AttrID")%> = new dojox.data.QueryReadStore({
					doClientPaging:true,
					doClientSorting:true,
					url:'<%=ics.GetVar("pullDownUrl")%>'
				}),
				pullDownNode = dojo.byId('PullDown_<%=ics.GetVar("AttrID")%>'),
				pullDownWid_<%=ics.GetVar("AttrID")%> = new fw.dijit.UITransferBox({
					value: '<%= builder.toString() %>',
					store: pullDownStore_<%=ics.GetVar("AttrID")%>,
					size: <%= Utilities.goodString(ics.GetVar("PAGESIZE")) ? ics.GetVar("PAGESIZE") : 10 %>,
					cs_environment: '<%= "ucform".equalsIgnoreCase("cs_enviroment") ? "ucform" : "" %>',
					maxVals: -1,
					queryExpr: '<%= "${0}" %>',
					storeStructure: <%= "asset".equalsIgnoreCase( ics.GetVar("AttrType") ) ? "{title: 'value', value: 'assetid'}" : "{title: 'value', value: 'value'}" %>,
					name: "_" + nodeName,
					title1: fw.util.getString('fatwire/wem/admin/common/Available'),
					title2: fw.util.getString('fatwire/wem/admin/common/Selected')
				}, pullDownNode);
			/* Save Logic */
			dojo.connect(pullDownWid_<%=ics.GetVar("AttrID")%>, 'onChange', function(){
				var	divNode = dojo.byId('pullDownInputWrapper_<%=ics.GetVar("AttrID")%>'),
					valueStr = "",
					i = 0,
					values = this.get('value');
					
				dojo.query("input[name=" + nodeName + "]").forEach(dojo.destroy);
				
				if (values.length === 0) values = [''];
				
				dojo.forEach(values, function(v){
					dojo.create('input', { type: 'hidden', name: nodeName, value: v}, divNode);
				});
			});	
			var conn = dojo.connect(pullDownWid_<%=ics.GetVar("AttrID")%>, '_populateSelected', function(){
				var	divNode = dojo.byId('pullDownInputWrapper_<%=ics.GetVar("AttrID")%>'),
					valueStr = "",
					i = 0,
					values = this.get('value');
					
				dojo.query("input[name=" + nodeName + "]").forEach(dojo.destroy);
				if (values.length === 0) values = [''];
				dojo.forEach(values, function(v){
					dojo.create('input', { type: 'hidden', name: nodeName, value: v}, divNode);
				});
				dojo.disconnect(conn);
			});
			
			pullDownWid_<%=ics.GetVar("AttrID")%>.startup();
			
			var refreshbutton_<%=ics.GetVar("AttrID")%> = new fw.ui.dijit.form.RefreshButton({
				}, dojo.create('div', {}, pullDownWid_<%=ics.GetVar("AttrID")%>.rightColumn, 'after'));
				
			dojo.connect(refreshbutton_<%=ics.GetVar("AttrID")%>, "onIconClick", pullDownWid_<%=ics.GetVar("AttrID")%>,  function(){
				this.store._lastServerQuery = null;
				this.loadItems();
			});
			
			dojo.connect(pullDownWid_<%=ics.GetVar("AttrID")%>, "onChange",  function(){
				refreshbutton_<%=ics.GetVar("AttrID")%>.loadingComplete();
				if(this.searchTimer){
					clearTimeout(this.searchTimer);
					this.searchTimer = null;
				}
			});
		});
		
	</script>
	
	<div id="pullDownInputWrapper_<%=ics.GetVar("AttrID")%>"></div>
</ics:else>
</ics:if>

<ics:removevar name="queryAssetName"/>
<ics:removevar name="AttributeType"/>
<ics:removevar name="pullDownUrl"/>
<ics:removevar name="numberOfResults"/>
</cs:ftcs>