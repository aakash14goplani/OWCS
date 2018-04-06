<%@page import="java.util.*"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ taglib prefix="publication" uri="futuretense_cs/publication.tld"%>
<%//
// OpenMarket/Xcelerate/WebRefPattern/PatternUIFront
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@page import="org.apache.commons.lang.StringUtils,com.fatwire.ui.util.GenericUtil"%>
<%@page import="com.openmarket.xcelerate.asset.WebReferencePatternBean"%>
<%@page import="com.openmarket.xcelerate.asset.WebReferencesPattern"%>
<%@page import="java.util.*"%>
<%@ page import="com.openmarket.basic.interfaces.AssetException" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@page import="com.fatwire.mobility.util.MobilityUtils"%>
<%@page import="com.fatwire.mobility.beans.DeviceGroupBean"%>
<%@ page import="com.fatwire.assetapi.util.AssetUtil"%>
<%@ page import="com.openmarket.gator.page.Page"%>
<%!
	private static final Log _log = LogFactory.getLog(ftMessage.GENERIC_DEBUG);
%>
<cs:ftcs>
<ics:callelement element="OpenMarket/Xcelerate/Scripts/ValidateInputForXSS" />
<ics:callelement element="OpenMarket/Xcelerate/WebRefPattern/PatternUICSS" />
<ics:callelement element="OpenMarket/Xcelerate/WebRefPattern/PatternUIJavaScript" />
<%
	if ("details".equalsIgnoreCase(ics.GetVar("action")) || "copy".equalsIgnoreCase(ics.GetVar("action")))
	{
		List<WebReferencePatternBean> patternlist = null;
		try 
		{		
			WebReferencesPattern webReferencesPattern = new WebReferencesPattern(ics);
			patternlist = webReferencesPattern.getForType(ics.GetVar("assettype"));
		} 
		catch (AssetException e) 
		{
			_log.error("Unable to get pattern for given asset type: " + e.getMessage());
		}
		if (patternlist!= null && patternlist.size() > 0) {
			for (WebReferencePatternBean bean : patternlist) 
			{
				if (bean.getId() == Long.valueOf(ics.GetVar("urlPatternId")))
				{
%>				
					<script>
						dojo.addOnLoad(function(){
							var publicationSelect = dijit.byId("pubSelect");
							<% if ("details".equalsIgnoreCase(ics.GetVar("action"))) { %>
								dojo.byId("patternID").value =  '<%=bean.getId()%>';
							<% } %>
							dijit.byId("patternName").set("value", '<%=bean.getName()%>');
							publicationSelect.set("displayedValue", '<%=bean.getPublication()%>');
							dijit.byId("vanityURL").set("value", '<%=bean.getPattern()%>');
							<%if (StringUtils.isNotBlank(bean.getParams()) && bean.getParams().contains("content-disposition=attachment")) { %>
								dojo.byId("isDownloadable").checked = true;
							<% } else { %>
								dojo.byId("isDownloadable").checked = false;
							<% } %>
							<%
								String blobHeaders = "";
								if (StringUtils.isNotBlank(bean.getField()) && StringUtils.isNotBlank(bean.getParams())){
									String[] headerArr = bean.getParams().split(",");
									for(int i = 0; i < headerArr.length; i++){
										if (!"content-disposition=attachment".equalsIgnoreCase(headerArr[i])) {
											if(i != 0)
												blobHeaders = blobHeaders + ",";
											blobHeaders = blobHeaders + headerArr[i];
										}
									}
								}							
							%>
							<%if (StringUtils.isNotBlank(bean.getField())) { %>
								dijit.byId("blobHeaders").set("value", '<%=blobHeaders%>');
							<% } %>	
							<% if (StringUtils.isNotBlank(bean.getField())) { %>
								dojo.query('input[name=FieldType]').forEach(function(node){
									if (node.value === "Blob") node.checked = true;
								});									
								showBlobPatternFields();
								hideAssetPatternFields();									
							<% } %>							
							var hostSelect = dijit.byId('hostSelect');
							hostSelect.set('query', {'publicationId': publicationSelect.get('displayedValue')});
							hostSelect.store.close();
							hostSelect.reset();
							var wrapperSelect = dijit.byId('wrapperSelect');
							wrapperSelect.set('query', {'publicationId': publicationSelect.get('value')});
							wrapperSelect.store.close();
							wrapperSelect.reset();
							var subtypeSelect = dijit.byId('subtypeSelect');
							subtypeSelect.set('query', {
								'publicationId': publicationSelect.get('value')
								<% if (StringUtils.isNotBlank(bean.getField())) { %>
									, isBlobURLType: "true",
								<% } %>	
							});
							subtypeSelect.store.close();
							subtypeSelect.reset();
							hostSelect.store.fetch({
								query: {
									'publicationId': publicationSelect.get('displayedValue') 
								},
								onComplete: function(items) {
									hostSelect.set("value", '<%=bean.getWebroot()%>');								
								}
							});						
															
							wrapperSelect.store.fetch({
								query: {
									'publicationId': publicationSelect.get('value') 
								},
								onComplete: function(items) {
									wrapperSelect.set("value", '<%=bean.getWrapper()%>');								
								}
							});							
								
							subtypeSelect.store.fetch({
								publicationId: publicationSelect.get('value'),
								<% if (StringUtils.isNotBlank(bean.getField())) { %>
									isBlobURLType: "true",
								<% } %>	
								onComplete: function(items) {									
									subtypeSelect.set("value", '<%=bean.getSubtype()%>');
									getAssetAttributes(subtypeSelect); 
									dijit.byId('assetID').set('query', {
										'assetSubType': '<%=bean.getSubtype()%>',
										'publicationId': publicationSelect.get('value')
									});																	
								}
							});
							if ('<%=bean.getDgroup()%>') dijit.byId('deviceGroupSelect').set("value", '<%=bean.getDgroup()%>');
							var queryObject = {},
								templateSelect = dijit.byId("templateSelect")
								templateStore = templateSelect.store,
								params = '<%=StringUtils.isNotBlank(bean.getParams()) ? bean.getParams() : ""%>',
								paramsKeyValObj = {};
							if (dojo.trim(params) !== "") {
								paramsKeyValObj = dojo.queryToObject(params);
							}
							queryObject.subtype = '<%=bean.getSubtype()%>';
							queryObject.publicationId = publicationSelect.get('value');
							queryObject.publicationName = publicationSelect.get('displayedValue');
							templateSelect.set('query', queryObject);
							templateStore.close();
							templateSelect.reset();							
							templateStore.fetch({
								query: queryObject,
								onComplete: function(items) {
									templateSelect.set("value", '<%=bean.getTemplate()%>');
									showArguments(templateSelect, paramsKeyValObj);
								}
							});
														
							var queryObj = {},
								fieldSelect = dijit.byId("fieldSelect")
								fieldStore = fieldSelect.store;
							queryObj.subtype = '<%=bean.getSubtype()%>';
							queryObj.publicationId = publicationSelect.get('value');
							queryObj.publicationName = publicationSelect.get('displayedValue');
							fieldSelect.set('query', queryObj);
							fieldStore.close();
							fieldSelect.reset();							
							fieldStore.fetch({
								query: queryObj,
								onComplete: function(items) {
									fieldSelect.set("value", '<%=bean.getField()%>');
								}
							});
						});
					</script>
<%					
					break;
				}
			}
		}
	}
%>
<div data-dojo-type="dijit.layout.BorderContainer" style="height:100%;width:100%;position:absolute;bottom:0;top:0;left:0;right:0;padding:0;background:#fff;" class="webRefPattern">
	<div dojoType="dijit.layout.ContentPane" region="top">
		<div class='toolbarContent AdvForms'>
			<xlat:lookup  key="dvin/UI/Save" varname="_ALT_"/>
			<A HREF="javascript:void(0)" ONCLICK="createWebRefPattern('vanityURL', 'hostSelect', 'subtypeSelect', 'templateSelect', 'wrapperSelect', 'deviceGroupSelect', 'patternName', 'pubSelect', 'blobHeaders', 'fieldSelect');">
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ToolBarButton">
					<ics:argument name="buttonImage" value="save.png" />
					<ics:argument name="toolbartitle" value='<%= ics.GetVar("_ALT_") %>' />
				</ics:callelement>
			</A>
		</div>		
		<div class="toolbarBorder"></div>
	</div>
	<div data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'center'">
		<div class="form" style="padding: 20px;">
			<div id="msgBoxWrapper" class="msgBoxWrapper message-error">
				<span class="icon-img"></span>
				<div id="msgBoxForPattern" class="msg-txt"></div>
				<div class="right close-img" onclick="closeMessage();"></div>
			</div>
			<h3><xlat:stream key='UI/Forms/UrlPatternForm'/></h3>
			<input type="hidden" id="patternID" value="" style="width:20em"/> 
			<div style="padding: 0 0 0 240px; display: inline">
				<input type="radio" name="FieldType" value="Asset" checked="yes" style="width:3em" onchange="showRelevantFormFields(this.value)"/>
				<font style="font-weight:bold;font-size:15px; font-color: #566D73">Asset</font>
			</div>	
			<div style="padding: 0 0 0 50px; display: inline">
				<input type="radio" name="FieldType" value="Blob" style="width:3em" onchange="showRelevantFormFields(this.value)"/>
				<font style="font-weight:bold;font-size:15px;font-color: #566D73">Blob</font>
			</div>
			<div class="row">
				<label><xlat:stream key="dvin/Common/Name"/>:</label>
				<div dojoType="fw.dijit.UIInput" id="patternName" value="" style="width:20em" showErrors="false"></div>				
			</div>
	
			<publication:list list="ActivePub" order="name"/>
		
			<div class="row">
				<label><xlat:stream key="dvin/Common/Site"/>:</label>		
				<select dojotype="fw.dijit.UISimpleSelect" id="pubSelect" style="width:20em" placeHolder="<xlat:stream key='dvin/Common/Select'/>" showErrors="false">
					<script type="dojo/connect" event="_selectOption">
						var subtypeSelect = dijit.byId('subtypeSelect');
						subtypeSelect.set('query', {'publicationId': this.get('value')});
						subtypeSelect.store.close();
						subtypeSelect.reset();		
						subtypeSelect.store.fetch({
							query: {
								'publicationId': this.get('value') 
							},
							onComplete: function(items) {
								if (items.length > 0) 
								{
									subtypeSelect.set("value", subtypeSelect.store.getValue(items[0], 'value'));
								}								
							}
						});
						var wrapperSelect = dijit.byId('wrapperSelect');
						wrapperSelect.set('query', {'publicationId': this.get('value')});
						wrapperSelect.store.close();
						wrapperSelect.reset();
						var hostSelect = dijit.byId('hostSelect');
						hostSelect.set('query', {'publicationId': this.get('displayedValue')});
						hostSelect.store.close();
						hostSelect.reset();
						dijit.byId('assetID').set('query', {
							'assetSubType': subtypeSelect.get('value') && subtypeSelect.get('value') !== 'Any' ? subtypeSelect.get('value') : '',
							'publicationId': this.get('value')
						});
					</script>
					<script type="dojo/connect" event="startup">
						var subtypeSelect = dijit.byId('subtypeSelect');
						subtypeSelect.set('query', {'publicationId': this.get('value')});
						var wrapperSelect = dijit.byId('wrapperSelect');
						wrapperSelect.set('query', {'publicationId': this.get('value')});
						var hostSelect = dijit.byId('hostSelect');
						hostSelect.set('query', {'publicationId': this.get('displayedValue')});
					</script>
					<ics:if condition='<%=ics.GetList("ActivePub")!=null && ics.GetList("ActivePub").hasData()%>' >
					<ics:then>
						<ics:listloop listname="ActivePub">
							<ics:listget listname="ActivePub" fieldname="id" output="publicationID"/>
							<ics:listget listname="ActivePub" fieldname="name" output="publicationName"/>
							<ics:callelement element="OpenMarket/Xcelerate/Actions/AssetMgt/EnableAssetTypePub">
								<ics:argument name="upcommand" value="IsAssetTypeEnabled"/>
								<ics:argument name="pubid" value='<%=ics.GetVar("publicationID")%>'/>
							</ics:callelement>
							<ics:if condition='<%="true".equalsIgnoreCase(ics.GetVar("IsAuthorized"))%>' >
							<ics:then>
								<option value='<%=ics.GetVar("publicationID")%>'><%=ics.GetVar("publicationName")%></option>
							</ics:then>
							</ics:if>
						</ics:listloop>
						<%
							ics.RemoveVar("pubid");
						%>
					</ics:then>
					</ics:if>
				</select>
			</div>
			<satellite:link pagename="OpenMarket/Xcelerate/WebRefPattern/SelectHost" assembler="query" outstring="hostSelectURL">
				<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
				<satellite:argument name="assetType" value='<%=ics.GetVar("assettype")%>'/>
			</satellite:link>
			<div data-dojo-type="fw.ui.dojox.data.CSQueryReadStore" data-dojo-id="hostStore" 
				data-dojo-props="
					requestMethod: 'post',
					doClientPaging:true,
					doClientSorting:true,
					url:'<%=ics.GetVar("hostSelectURL")%>'
			">
			</div>
			<div class="row">
				<label><xlat:stream key='UI/Forms/Host'/>:</label>
				<span>
					<select dojotype="fw.dijit.UISimpleSelect" id="hostSelect" style="width:20em" placeHolder="<xlat:stream key='dvin/Common/Select'/>" hasDownArrow="true" store="hostStore"
						pageSize="10" searchAttr='label' showErrors="false">
						<script type="dojo/connect" event="startup">
							var self = this;
							this.store.fetch({
								query: {
									'publicationId': dijit.byId('pubSelect').get('displayedValue') 
								},
								onComplete: function(items) {
									if (items.length > 0) self.set("value", self.store.getValue(items[0], 'value'));			
								}
							});
						</script>
					</select>
				</span>
			</div>
				
				
			<satellite:link pagename="OpenMarket/Xcelerate/WebRefPattern/SelectSubtype" assembler="query" outstring="subtypeSelectURL">
				<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
				<satellite:argument name="assetType" value='<%=ics.GetVar("assettype")%>'/>
			</satellite:link>
			<div data-dojo-type="fw.ui.dojox.data.CSQueryReadStore" data-dojo-id="subtypeStore" 
				data-dojo-props="
					requestMethod: 'post',
					doClientPaging:true,
					doClientSorting:true,
					url:'<%=ics.GetVar("subtypeSelectURL")%>'
			">
			</div>
			<div class="row" <%= AssetUtil.isFlexAsset(ics, ics.GetVar("assettype")) || Page.STANDARD_TYPE_NAME.equals(ics.GetVar("assettype"))? "" : "style='display:none'"%>>
				<label><xlat:stream key="dvin/Common/Subtype"/>:</label>		
				<select dojotype="fw.dijit.UISimpleSelect" id="subtypeSelect" style="width:20em" placeHolder="<xlat:stream key='dvin/Common/Select'/>" hasDownArrow="true" store="subtypeStore" labelType="html" pageSize="10" searchAttr='label' showErrors="false">
					<script type="dojo/connect" event="_selectOption">
						getAssetAttributes(this); 
						dijit.byId('assetID').set('query', {
							'assetSubType': this.get('value') && this.get('value') !== 'Any' ? this.get('value') : '',
							'publicationId': dijit.byId('pubSelect').get('value')
						});
						refreshTemplateSelect(this, dijit.byId('templateSelect'), dijit.byId('pubSelect'));
						refreshFieldSelect(this, dijit.byId('fieldSelect'), dijit.byId('pubSelect'));						
					</script>
					<script type="dojo/method" event="_setItemAttr" args="item, priorityChange, displayedValue">
						if(displayedValue)
							displayedValue = displayedValue.replace(/&#39;/g, "'");
						else
							displayedValue = this.store.getValue(item, this.searchAttr).replace(/&#39;/g, "'");
						var value = this._getValueField() != this.searchAttr? this.store.getIdentity(item) : displayedValue;
						this._set("item", item);
						dijit.form.ComboBox.superclass._setValueAttr.call(this, value, priorityChange, displayedValue);
						this.valueNode.value = this.value;
						this._lastDisplayedValue = this.textbox.value;			
					</script>
					<script type="dojo/method" event="_announceOption" args="node">						
						if(!node) return;
						if(!node.item) return;
						node.item.i["label"] = node.item.i["label"].replace(/&#39;/g, "'");
						this.inherited("_announceOption", arguments);		
					</script>
					<% if ("new".equalsIgnoreCase(ics.GetVar("action"))) { %>
						<script type="dojo/connect" event="startup">
							var self = this;
							this.store.fetch({
								query: {
									'publicationId': dijit.byId('pubSelect').get('value')
								},
								onComplete: function(items) {
									if (items.length > 0) self.set("value", self.store.getValue(items[0], 'value'));			
								}
							});
							dijit.byId('assetID').set('query', {
								'assetSubType': this.get('value') && this.get('value') !== 'Any' ? this.get('value') : '',
								'publicationId': dijit.byId('pubSelect').get('value')
							});
						</script>
					<% } %>				
				</select>
			</div>
		
			<!-- Device group -->		
			<div class="row">
				<label><xlat:stream key='dvin/UI/Admin/DeviceGroup'/>:</label>
				<select dojotype="fw.dijit.UISimpleSelect" id="deviceGroupSelect" placeHolder="<xlat:stream key='dvin/Common/Select'/>" style="width:20em">
				
				<%	
					List<DeviceGroupBean> deviceGroupList = MobilityUtils.getDeviceGroups(ics);
					Collections.reverse(deviceGroupList);	
					Map<String,List<String>> deviceGroupMap = new HashMap<String,List<String>>();
					for(DeviceGroupBean deviceGroup:deviceGroupList)
					{
						String deviceSuffix = deviceGroup.getDeviceGroupSuffix();
						if(deviceGroupMap.get(deviceSuffix) == null)
						{
							deviceGroupMap.put(deviceSuffix, new LinkedList<String>());
						}
						deviceGroupMap.get(deviceSuffix).add(deviceGroup.getName());
					}
					if(deviceGroupMap.size() >0) {
						for(String deviceSuffix:deviceGroupMap.keySet()) {
							List<String> deviceGroupNameList = deviceGroupMap.get(deviceSuffix);											
				%>
							<option value='<%=deviceSuffix%>'><%=StringUtils.join(deviceGroupNameList,", ")%></option>
				<% 
						} 
					}
				%>
				</select>
			</div>	
		
			<satellite:link pagename="OpenMarket/Xcelerate/WebRefPattern/SelectTemplate" assembler="query" outstring="templateStoreURL">
				<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
				<satellite:argument name="assetType" value='<%=ics.GetVar("assettype")%>'/>
			</satellite:link>
			<div data-dojo-type="fw.ui.dojox.data.CSQueryReadStore" data-dojo-id="templateStore" 
				data-dojo-props="
					requestMethod: 'post',
					doClientPaging:true,
					doClientSorting:true,
					url:'<%=ics.GetVar("templateStoreURL")%>'
			">
			</div>
			<div class="row">
				<label><xlat:stream key='dvin/UI/Template'/>:</label>	
				<select dojotype="fw.dijit.UISimpleSelect" id="templateSelect" style="width:20em" placeHolder="<xlat:stream key='dvin/Common/Select'/>" hasDownArrow="true" store="templateStore"
					pageSize="10" searchAttr='label' showErrors="false">
					<script type="dojo/connect" event="_selectOption">
						showArguments(this);
					</script>
					<script type="dojo/connect" event="onChange">
						if (this.get("value") === "__defaultassettemplate__")
							dojo.addClass(this.textbox, "defaultMenuItem");
						else 
							dojo.removeClass(this.textbox, "defaultMenuItem");
					</script>
					<script type="dojo/connect" event="_openResultList">
						if(this.dropDown != null){
							dojo.query('li.dijitMenuItem.dijitReset', this.dropDown.domNode).forEach(function(eachNode){
								if(eachNode.innerHTML === "defaultassettemplate")
									dojo.addClass(eachNode, "defaultMenuItem");
							});
						}
					</script>				
					<% if ("new".equalsIgnoreCase(ics.GetVar("action"))) { %>
						<script type="dojo/connect" event="startup">
							var self = this;
							this.set('query', {
								'subtype': dijit.byId('subtypeSelect').get('value'),
								'publicationId': dijit.byId('pubSelect').get('value'),
								'publicationName': dijit.byId('pubSelect').get('displayedValue')
							});
							this.store.fetch({
								query: {
									'subtype': dijit.byId('subtypeSelect').get('value'),
									'publicationId': dijit.byId('pubSelect').get('value'),
									'publicationName': dijit.byId('pubSelect').get('displayedValue')
								},
								onComplete: function(items) {
									if (items.length > 0) self.set("value", self.store.getValue(items[0], 'value'));
									showArguments(self);										
								}
							});					
						</script>
					<% } %>
				</select>	
			</div>
			
			<div id="argumentContentPane" class="argContentPane" data-dojo-type="dijit.layout.ContentPane"></div>
		
			<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/WebRefPattern/SelectWrapper" outstring="wrapperStoreURL">
				<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
				<satellite:argument name="assetType" value='<%=ics.GetVar("assettype")%>'/>
			</satellite:link>
			<div data-dojo-type="fw.ui.dojox.data.CSQueryReadStore" data-dojo-id="wrapperStore" 
				data-dojo-props="
					requestMethod: 'post',
					doClientPaging:true,
					doClientSorting:true,
					url:'<%=ics.GetVar("wrapperStoreURL")%>'
			">
			</div>
			
			<div class="row">
				<label><xlat:stream key='dvin/UI/Wrapper'/>:</label>	
				<select dojotype="fw.dijit.UISimpleSelect" id="wrapperSelect" style="width:20em" placeHolder="<xlat:stream key='dvin/Common/Select'/>" hasDownArrow="true" store="wrapperStore"
					pageSize="10" searchAttr='label' showErrors="false">
					<script type="dojo/connect" event="startup">
						var self = this;
						this.store.fetch({
							query: {
								'publicationId': dijit.byId('pubSelect').get('value') 
							},
							onComplete: function(items) {
								if (items.length > 0) self.set("value", self.store.getValue(items[0], 'value'));			
							}
						});
					</script>
				</select>
			</div>
			
			<satellite:link pagename="OpenMarket/Xcelerate/WebRefPattern/SelectBlobField" assembler="query" outstring="subtypeSelectURL">
				<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
				<satellite:argument name="assetType" value='<%=ics.GetVar("assettype")%>'/>
			</satellite:link>
			<div data-dojo-type="fw.ui.dojox.data.CSQueryReadStore" data-dojo-id="fieldStore" 
				data-dojo-props="
					requestMethod: 'post',
					doClientPaging:true,
					doClientSorting:true,
					url:'<%=ics.GetVar("subtypeSelectURL")%>'
			">
			</div>
			<div class="row" style="display: none">
				<label><xlat:stream key="dvin/Common/Field"/>:</label>		
				<select dojotype="fw.dijit.UISimpleSelect" id="fieldSelect" style="width:20em" placeHolder="<xlat:stream key='dvin/Common/Select'/>" hasDownArrow="true" store="fieldStore"
					pageSize="10" searchAttr='label' showErrors="false">
					<% if ("new".equalsIgnoreCase(ics.GetVar("action"))) { %>
						<script type="dojo/connect" event="startup">
							var self = this;
							this.set('query', {
								'subtype': dijit.byId('subtypeSelect').get('value'),
								'publicationId': dijit.byId('pubSelect').get('value'),
								'publicationName': dijit.byId('pubSelect').get('displayedValue')
							});
							this.store.fetch({
								query: {
									'subtype': dijit.byId('subtypeSelect').get('value'),
									'publicationId': dijit.byId('pubSelect').get('value'),
									'publicationName': dijit.byId('pubSelect').get('displayedValue')
								},
								onComplete: function(items) {
									if (items.length > 0) self.set("value", self.store.getValue(items[0], 'value'));	
								}
							});
						</script>
					<% } %>				
				</select>
				<div style="display:inline;">
					<input type="checkbox" id="isDownloadable" checked="false" style="width:2em"/>
					<font style="font-weight:bold;font-size:15px; font-color: #566D73"><xlat:stream key="UI/Forms/IsDownloadable"/></font>
				</div>
			</div>
			
			<div class="row" style="display: none">
				<label><xlat:stream key="UI/Forms/BlobHeaders"/>:</label>
				<div dojoType="fw.dijit.UITextarea" id="blobHeaders" value="" showErrors="false" rows="3" style="width:400px"></div>
				<div style="padding: 0 0 0 195px;" class="helptext">
					<%="(e.g. Last-Modified=${updateddate})"%>
				</div>				
			</div>
			
			<div class="row">
				<label><xlat:stream key='UI/Forms/Pattern'/>:</label>
				<div dojoType="fw.dijit.UITextarea" id="vanityURL" value="" showErrors="false" rows="3" style="width:400px"></div>
				<div style="padding: 0 0 0 195px;" id="assetPatternHelpText" class="helptext">
					<%="(e.g. " + ics.GetVar("assettype") + "/${name}/${f:formatDate(updateddate,\"yy/MM/dd\")}/${description.toLowerCase()} )"%>
				</div>
				<div style="padding: 0 0 0 195px;display:none;" id="blobPatternHelpText" class="helptext">
					<%="(e.g. " + ics.GetVar("assettype") + "/${f:getFileName(BLOB_ATTRIBUTE)} )"%>
				</div>
			</div>		
			
			<satellite:link pagename="fatwire/ui/util/TypeAheadSearchResults" assembler="query" outstring="typeAheadUrl">
				<satellite:argument name="searchField" value='name'/>
				<satellite:argument name="searchOperation" value='STARTS_WITH'/>
				<satellite:argument name="assetType" value='<%=ics.GetVar("assettype")%>'/>
				<satellite:argument name="sort" value='name'/>
				<satellite:argument name="rows" value='1000'/>	
			</satellite:link>
			<div data-dojo-type="fw.ui.dojox.data.CSQueryReadStore" data-dojo-id="assetSearchStore" 
				data-dojo-props="
					requestMethod: 'post',
					doClientPaging:true,
					doClientSorting:true,
					url:'<%=ics.GetVar("typeAheadUrl")%>'
			">
			</div>
			<br /><br /><br />

			<h3><xlat:stream key='UI/Forms/EvaluateUrlPattern'/></h3>
			<div class="row">
				<label><xlat:stream key='dvin/UI/Asset'/>:</label>
				<select dojotype="fw.dijit.UIFilteringSelect" id="assetID" placeHolder="<xlat:stream key='dvin/Common/Select'/>" store="assetSearchStore" pageSize="10" clearButton="true" 
					hasDownArrow="true" disableTypeAhead="false" searchAttr='name' style="width:28em" queryExpr='<%="${0}"%>'
					onClearInput="this.set('displayedValue', '');dojo.byId('vanityURLEval').innerHTMl = '';dojo.byId('evalBlobHeader').innerHTML = '';"
				>
				<script type="dojo/connect" event="_selectOption">
					createWebreferencePattern('vanityURL', 'hostSelect', 'subtypeSelect', 'templateSelect', 'wrapperSelect', 'deviceGroupSelect', 'assetID', 'patternName', 'pubSelect', 'blobHeaders', 'fieldSelect');
				</script>
				<script type="dojo/connect" event="_onKey" args="evt">
					if (evt.charOrCode === dojo.keys.ENTER)
						createWebreferencePattern('vanityURL', 'hostSelect', 'subtypeSelect', 'templateSelect', 'wrapperSelect', 'deviceGroupSelect', 'assetID', 'patternName', 'pubSelect', 'blobHeaders', 'fieldSelect');
				</script>
				<script type="dojo/method" event="_setDisplayedValueAttr">
					if(arguments[0] === null || arguments[0] === '') this.textbox.value = '';
					else this.inherited("_setDisplayedValueAttr", arguments);
				</script>
				</select>
			</div>
			
			<div class="row" style="display: none;">
				<label><xlat:stream key='UI/Forms/EvaluatedBlobHeaders'/>:</label>
				<div id="evalBlobHeader" style="display:inline-block;min-height:18px;width:392px;background-color:#eee;padding:6px 5px;line-height:1.3;"></div>
			</div>
			
			<div class="row">
				<label><xlat:stream key='UI/Forms/EvaluatedPattern'/>:</label>
				<div id="vanityURLEval" style="display:inline-block;min-height:18px;min-width:392px;background-color:#eee;padding:6px 5px;line-height:1.3;"></div>
			</div>	
		</div>
	</div>
	<div data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'right'"  class="searchContainer fwGridContainer" style="width:300px">
		<ics:callelement element="OpenMarket/Xcelerate/WebRefPattern/PatternHelper" />
	</div>
</div>
</cs:ftcs>