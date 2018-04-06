<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="hash" uri="futuretense_cs/hash.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld" %>
<%//
// OpenMarket/Gator/FlexibleAssets/Common/AssetListDnD
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
<cs:ftcs>
<ics:if condition='<%=null != ics.GetVar("recname")%>'>
<ics:then>
	<!--<span class="form-label-text"><string:stream variable="recname"/></span> -->
	<string:stream variable="recname"/>
		<!-- replace the following spacer gif with a space -->
		<img height="1" width="5" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif" />
		<span class="small-text">
			<xlat:stream key="dvin/FlexibleAssets/Common/Recommendation" />
		</span>
</ics:then>
</ics:if>
<%StringBuilder sbMultRec = new StringBuilder();%>
<table border="0" cellpadding="0" cellspacing="5">
<ics:setvar name="total" value='<%=ics.GetVar(ics.GetVar("list") + ":Total")%>' />
	<ics:if condition='<%="0" != ics.GetVar("total")%>'>
	<ics:then>		
		<%
			int assetcounter = 0;
			int curRel = 0;
			int aCounter = 0;
			
			for(int i = 1; i <= Integer.parseInt(ics.GetVar("total")); i++){
				ics.SetVar("currentRelid", ics.GetVar(ics.GetVar("list") + ":" + curRel + ":relid"));
				if(ics.GetVar("currentRelid").equals(ics.GetVar("recid"))){
					%>
						<asset:list list="AssetList" field1="id" value1='<%=ics.GetVar(ics.GetVar("list") + ":" + curRel + ":asset")%>' type='<%=ics.GetVar(ics.GetVar("list") + ":" + curRel + ":asset_type")%>'/> 
						<ics:if condition='<%="input".equals(ics.GetVar("displaytype"))%>' >
						<ics:then>
							
							<INPUT TYPE="hidden" NAME="<%="d" + ics.GetList("AssetList").getValue("id") + ics.GetVar("recid")%>" VALUE="" />
						
							<%-- <string:stream list="AssetList" column="name"/>  --%>
							
							<!-- replace the spacer gif with just a space -->
							
							<ics:setvar name="uglyAT" value='<%=ics.GetVar(ics.GetVar("list") + ":" + curRel + ":asset_type")%>' />
							<assettype:load name="ATinst" field="assettype" value='<%=ics.GetVar("uglyAT")%>'/>
							<assettype:get name="ATinst" field="description" output="aDesc"/>
							<%-- (<string:stream value='<%=ics.GetVar("aDesc")%>'/>)&nbsp; --%>
							
							<ics:setvar name="currentConf" value='<%= ics.GetVar(ics.GetVar("list") + ":" + curRel + ":confidence") %>' />
							<ics:setvar name="currentval" value='<%=ics.GetVar("currentConf")%>' />
							<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/IntDecConversion">
								<ics:argument name="OPtype" value='DecToInt'/>
								<ics:argument name="currentval" value='<%=ics.GetVar("currentConf")%>'/>
							</ics:callelement>
							<%--
							<xlat:stream key="dvin/AT/AdvCols/Confidence"/> &nbsp;=&nbsp;
							
							<INPUT TYPE="Text" NAME="<%=ics.GetVar("currentRelid") + "newconf" + assetcounter%>" SIZE="3" maxlength="3" VALUE="<%=ics.GetVar("NewConfidence")%>" />%&nbsp;
							
							<ics:setvar name="ConfidenceName" value='<%=ics.GetVar("ConfidenceName") + "*" + ics.GetVar("currentRelid") + "newconf" + assetcounter + "!"%>' />
							
							--%>
							<asset:getsubtype type='<%=ics.GetVar(ics.GetVar("list") + ":" + curRel + ":asset_type")%>' objectid='<%=ics.GetVar(ics.GetVar("list") + ":" + curRel + ":asset")%>' output="recAssetSub" />
							<%
								if (aCounter != 0)
								{
									sbMultRec.append(";");
								}
								sbMultRec.append(ics.GetVar(ics.GetVar("list") + ":" + curRel + ":asset_type"))
									.append(":")
									.append(ics.GetVar(ics.GetVar("list") + ":" + curRel + ":asset"))
									.append(":")
									.append(ics.GetList("AssetList").getValue("name"))
									.append(":")
									.append(ics.GetVar("recAssetSub"))
									.append(":")
									.append(ics.GetVar("NewConfidence"));	;										
								aCounter ++;
							
							%>
							<!--INPUT TYPE="hidden" NAME="dAssetList.idRecList.id" VALUE="" REPLACEALL="AssetList.id,RecList.id"/-->
						</ics:then>
						<ics:else>
							<tr>
								<td></td>
								<td colspan="2">
								<!-- [2009-01-05 KGF #13180] Make assets in recommendations immediately inspectable -->
								<ics:setvar name="uglyAT" value='<%=ics.GetVar(ics.GetVar("list") + curRel + ":asset_type")%>' />
								<xlat:lookup key='dvin/Common/InspectThisItem' varname="_XLAT_"  />
								<xlat:lookup key='dvin/Common/InspectThisItem' varname="mouseover" escape='true' />
								
								<ics:callelement element="OpenMarket/Xcelerate/Util/GenerateLink">
									<ics:argument name="assettype" value='<%=ics.GetVar("uglyAT")%>'/>
									<ics:argument name="assetid" value='<%=ics.GetList("AssetList").getValue("id")%>'/>
									<ics:argument name="varname" value='urlInspectItem'/>
									<ics:argument name="function" value='inspect'/>
								</ics:callelement>
								<A HREF="<%=ics.GetVar("urlInspectItem")%>"
									onmouseover="window.status='<%=ics.GetVar("mouseover")%>';return true;"
									onmouseout="return window.status='';return true;"
									title="<%=ics.GetVar("_XLAT_")%>">
									<string:stream list="AssetList" column="name"/>
								</A>
								<span class="small-text">
								<ics:setvar name="currentval" value='<%= ics.GetVar(ics.GetVar("list") + ":" + curRel + ":confidence") %>' />
								<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/IntDecConversion">
									<ics:argument name="OPtype" value='DecToInt'/>
								</ics:callelement>

								<img height="1" width="5" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif" />
								<assettype:load name="ATinst" field="assettype" value='<%=ics.GetVar("uglyAT")%>'/>
								<assettype:get name="ATinst" field="description" output="aDesc"/>
								(<string:stream value='<%=ics.GetVar("aDesc")%>'/>)</span>&nbsp; <xlat:stream key="dvin/AT/AdvCols/Confidence"/>&nbsp;=&nbsp;<string:stream variable="NewConfidence"/>%</td>
								<ics:setvar name='<%=ics.GetVar("varconfidence")%>' value='<%= ics.GetVar(ics.GetVar("list") + ":" + curRel + ":confidence") %>' />
							</tr>
						</ics:else>
						</ics:if>
					<%
					assetcounter ++;
				}				
				curRel ++;			
			}		
		%>
	</ics:then>
	<ics:else>
		<tr>
			<td></td>
			<td colspan="2"><span class="small-text">
			<xlat:stream key="dvin/FlexibleAssets/Common/NoRelatedItems" />
			</span></td>
		</tr>
	</ics:else>
	</ics:if>
	<ics:if condition='<%="input".equals(ics.GetVar("displaytype"))%>' >
	<ics:then>
		<INPUT TYPE="hidden" NAME="<%=ics.GetVar("varname")%>" VALUE="" />
		 <tr>
			<script type="text/javascript">
				var selectDnDLocalReco_<%=ics.GetVar("recid")%> = function(args){
					publishLocalRecoAssetsGather_<%=ics.GetVar("recid")%>();
				};
				function SelectFromTreeRecoDndMult(widgetName)
				{
					var id,name,type, subtype, selValue={};
					var EncodedString = parent.frames["XcelTree"].document.TreeApplet.exportSelections()+'';
					var idArray = EncodedString.split(',');
					var assetcheck = unescape(idArray[0]);
					var nodes= [];
					nodes = dojo.query('div[name='+widgetName+']');
					if(nodes.length === 0)
						nodes = dojo.query('input[name='+widgetName+']');
					var typeWidgetIns = dijit.getEnclosingWidget(nodes[0]);	
					if (assetcheck.indexOf('assettype=')!=-1 && assetcheck.indexOf('id=')!=-1)
					{
						var test = new String(EncodedString);
						var allNodes = test.split(":");
						if (allNodes.length==1)
						{
							alert('<xlat:stream key="dvin/UI/Error/Nonodesareselectedinthetree" encode="false" escape="true"/>');
							return;
						}
						var currentNode = 0;
						for (currentNode = 0;currentNode<allNodes.length-1;currentNode++)
						{
							var nameVal = allNodes[currentNode].split(",");					
							var i = 0;
							for (i=0;i<nameVal.length;i+=2)
							{
								id = unescape(nameVal[i]);
								var splitid = id.split(',');
								if (splitid.length==1)
								{
									var xlatstr='<xlat:stream key="dvin/UI/Error/Nodeidisnotavalidselection" encode="false" escape="true"/>';
									var replacestr=/Variables.id/;
									xlatstr = xlatstr.replace(replacestr,id);
									alert(xlatstr);
									return;
								}
									
								var splitpair = splitid[1].split("=");
								
								id = (splitid[0].split('='))[1];
								type = (splitid[1].split('='))[1];
								subtype = (splitid[3].split('='))[1];
								name = nameVal[i+1].replace(/\+/g,' ');
								name = DecodeUTF8(name.substr(0, name.length));
								subtype = subtype.replace(/\+/g," ");
								type = type.replace(/\+/g," ");	
							}			

							selValue = {
								'id':id,
								'name':name,
								'subtype':subtype,
								'type':type
							};
							typeWidgetIns.setSelectedValue(selValue);
						}
					}
					else
					{
					 alert('<xlat:stream key="dvin/UI/PleaseSelectAssetFromTree" encode="false" escape="true"/>');
					}
				}
				
				var subscription_<%=ics.GetVar("recid")%> = dojo.subscribe("typeAhead/Ready", function(typeAheadInstance){
										
					if(typeAheadInstance.name === '<%="typeAheadReco_" + ics.GetVar("recid")%>') {
						var self_source = typeAheadInstance._source;
						dojo.connect(self_source, "onConfidenceChange", function(){
							prepareConfidenceValue_<%=ics.GetVar("recid")%>();
						});
						dojo.unsubscribe(subscription_<%=ics.GetVar("recid")%>);	
					}						
				});
					
				var prepareConfidenceValue_<%=ics.GetVar("recid")%> = function(){
					var nodes= [];
						nodes = dojo.query('div[name=<%="typeAheadReco_" + ics.GetVar("recid")%>]');
					if(nodes.length === 0)
						nodes = dojo.query('input[name=<%="typeAheadReco_" + ics.GetVar("recid")%>]');
					var typeWidgetIns = dijit.getEnclosingWidget(nodes[0]);	
					var self_source = typeWidgetIns._source;
					var aC = 0;
					self_source.getAllNodes().forEach(function(node){
						var widgets = dijit.findWidgets(node);						
						var ndNewConf = '<%=ics.GetVar("recid")%>newconf' + aC;
						obj.elements[ndNewConf].value = widgets[0].confWidget.get('value');
						aC++
					});	
				};
				
				var publishLocalRecoAssetsGather_<%=ics.GetVar("recid")%> = function(){
					var nodes= [];
						nodes = dojo.query('div[name=<%="typeAheadReco_" + ics.GetVar("recid")%>]');
					if(nodes.length === 0)
						nodes = dojo.query('input[name=<%="typeAheadReco_" + ics.GetVar("recid")%>]');
					var typeWidgetIns = dijit.getEnclosingWidget(nodes[0]);	
					var self_source = typeWidgetIns._source;
					var aC = 0;
					var obj = document.forms[0];
					var basePlaceNode = dojo.query("input[name=numberRecommendations]")[0],						
						ndNumAssets = '<%=ics.GetVar("recid")%>numassets';
					if(obj.elements['uniqueRecids_<%=ics.GetVar("recid")%>'])
						obj.elements['uniqueRecids_<%=ics.GetVar("recid")%>'] = '';
					else
						dojo.place('<input type="hidden" name="uniqueRecids_<%=ics.GetVar("recid")%>"   value="" />', basePlaceNode, 'before');
					if(self_source.getAllNodes().length > 0){
						obj.elements['uniqueRecids_<%=ics.GetVar("recid")%>'].value = '<%=ics.GetVar("recid")%>';
						uniqueRecsFunc_<%=ics.GetVar("recid")%>('<%=ics.GetVar("recid")%>');
					}
					if(obj.elements['ConfidenceName_<%=ics.GetVar("recid")%>'])
						obj.elements['ConfidenceName_<%=ics.GetVar("recid")%>'].value = '';
					else
						dojo.place('<input type="hidden" name="ConfidenceName_<%=ics.GetVar("recid")%>"   value="" />', basePlaceNode, 'before');
					self_source.getAllNodes().forEach(function(node){
						var data = fw.ui.dnd.util.getNormalizedData(self_source, node);
						var widgets = dijit.findWidgets(node);
						var 
							ndAssetId = '<%=ics.GetVar("recid")%>assetid' + aC,
							ndAssetType = '<%=ics.GetVar("recid")%>assettype' + aC,
							ndConf = '<%=ics.GetVar("recid")%>conf' + aC,
							ndNewConf = '<%=ics.GetVar("recid")%>newconf' + aC,
							buildCName = '*<%=ics.GetVar("recid")%>newconf' + aC + '!';						
						if(obj.elements[ndAssetId])
							obj.elements[ndAssetId].value = '';
						else
							dojo.place('<input type="hidden" name="' + ndAssetId + '"   value="" />', basePlaceNode, 'before');
						if(obj.elements[ndAssetType])
							obj.elements[ndAssetType].value = '';
						else
							dojo.place('<input type="hidden" name="' + ndAssetType + '"   value="" />', basePlaceNode, 'before');
						if(obj.elements[ndConf])
							obj.elements[ndConf].value = '';
						else
							dojo.place('<input type="hidden" name="' + ndConf + '"   value="" />', basePlaceNode, 'before');
						if(obj.elements[ndNewConf])
							obj.elements[ndNewConf].value = '';
						else
							dojo.place('<input type="hidden" name="' + ndNewConf + '"   value="" />', basePlaceNode, 'before');
						
						obj.elements[ndAssetId].value = data.id;						
						obj.elements[ndAssetType].value = data.type;
						obj.elements[ndConf].value = widgets[0].get('value') / 100;											
						if(aC > 0)
							obj.elements["ConfidenceName_<%=ics.GetVar("recid")%>"].value = obj.elements["ConfidenceName_<%=ics.GetVar("recid")%>"].value + buildCName;
						else
							obj.elements["ConfidenceName_<%=ics.GetVar("recid")%>"].value = buildCName;
						obj.elements[ndNewConf].value = widgets[0].get('value');							
						aC++;
					});
					if(!obj.elements[ndNumAssets])
						dojo.place('<input type="hidden" name="' + ndNumAssets + '"   value="" />', basePlaceNode, 'before');	
					obj.elements[ndNumAssets].value = self_source.getAllNodes().length;					
					confNameFunc_<%=ics.GetVar("recid")%>('<%=ics.GetVar("recid")%>newconf', obj.elements["ConfidenceName_<%=ics.GetVar("recid")%>"].value);
					prepareConfidenceValue_<%=ics.GetVar("recid")%>();			
					if(this.multiple && aC > 0){
						var 
							ndAssetId = '<%=ics.GetVar("recid")%>assetid' + aC,
							ndAssetType = '<%=ics.GetVar("recid")%>assettype' + aC,
							ndConf = '<%=ics.GetVar("recid")%>conf' + aC,
							ndNewConf = '<%=ics.GetVar("recid")%>newconf' + aC;
						dojo.query("input[name="+ndAssetId+"]").forEach(function(delNode){
							dojo.destroy(delNode);
						});	
						dojo.query("input[name="+ndAssetType+"]").forEach(function(delNode){
							dojo.destroy(delNode);
						});
						dojo.query("input[name="+ndConf+"]").forEach(function(delNode){
							dojo.destroy(delNode);
						});
						dojo.query("input[name="+ndNewConf+"]").forEach(function(delNode){
							dojo.destroy(delNode);
						});
					}
				};			
				var confNameFunc_<%=ics.GetVar("recid")%> = function(idstub, val)
				{
					var oldVal = obj.elements["ConfidenceName"].value;
					
					// need to trim any old entries out of the string before we add "val".
					
					var reg = new RegExp("\\*" + idstub + "\\d*\\!", "g"); 
					oldVal = oldVal.replace(reg, "");
					
					obj.elements["ConfidenceName"].value = oldVal + val;
				};
				
				if(document.forms[0].elements['uniqueRecids'])
					document.forms[0].elements['uniqueRecids'].value = '';
					
				var uniqueRecsFunc_<%=ics.GetVar("recid")%> = function(val){
					if(!obj.elements['uniqueRecids'])
						dojo.place('<input type="hidden" name="uniqueRecids"   value="" />', dojo.query("input[name=numberRecommendations]")[0], 'before');
					if(val && obj.elements["ConfidenceName"].value != '')
						obj.elements['uniqueRecids'].value = obj.elements['uniqueRecids'].value + ',' + val;
					else if(val)
						obj.elements['uniqueRecids'].value = val;
				};
			</script>
			
            <!--<SETVAR NAME="currentUniqueID" VALUE="CS.UniqueID"/>-->
            <div class='relateditems'>
			<ics:callelement element='OpenMarket/Xcelerate/AssetType/AdvCols/DnDSelectHTML'>
				<ics:argument name="dnDTitle" value=""/>
				<ics:argument name="appendStr" value='<%=ics.GetVar("recid")%>'/>				
			</ics:callelement>
			</div>			
			<%
				if("false".equals(ics.GetVar("showSiteTree"))){
					ics.SetVar("displaySearchInputbox", "true");
				}
				else{
					ics.SetVar("displaySearchInputbox", "false");
				}
			%>
			<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/TypeAheadWidget'>
				<ics:argument name="parentType" value="['*']"/>
				<ics:argument name="subTypesForWidget" value='*'/>
				<ics:argument name="subTypesForSearch" value=''/>
				<ics:argument name="multipleVal" value="true"/>
				<ics:argument name="widgetValue" value="<%=sbMultRec.toString()%>"/>	
				<ics:argument name="funcToRun" value='<%="selectDnDLocalReco_" + ics.GetVar("recid")%>'/>
				<ics:argument name="widgetNode" value='<%="typeAheadReco_" + ics.GetVar("recid")%>'/>
				<ics:argument name="typesForSearch" value=''/>	
				<ics:argument name="displaySearchbox" value='<%=ics.GetVar("displaySearchInputbox")%>'/>
				<ics:argument name="multiOrderedAttr" value='true'/>
				<ics:argument name="isConfRequired" value='true'/>				
			</ics:callelement>			
		</tr>
	</ics:then>
	</ics:if>	
</table>
<br/>
</cs:ftcs>