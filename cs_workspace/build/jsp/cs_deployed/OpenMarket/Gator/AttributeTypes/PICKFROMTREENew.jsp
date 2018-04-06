<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="hash" uri="futuretense_cs/hash.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld" %>
<%//
// OpenMarket/Gator/AttributeTypes/PICKFROMTREENew
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
	<tr>		
		<ics:callelement element="OpenMarket/Gator/FlexibleAssets/Common/DisplayAttributeName"/>
		<ics:if condition='<%="true".equals(ics.GetVar("RequiredAttr"))%>'>
		<ics:then>	
			<ics:setvar name="RequireInfo" value='<%="*" + ics.GetVar("cs_SingleInputName") + "*" + ics.GetVar("currentAttrName") + "*ReqTrue*" + ics.GetVar("AttrType") + "*treepick!" %>'/>
		</ics:then>
		<ics:else>
			<ics:setvar name="RequireInfo" value='<%="*" + ics.GetVar("cs_SingleInputName") + "*" + ics.GetVar("currentAttrName") + "*ReqFalse*" + ics.GetVar("AttrType") + "*treepick!" %>'/>
		</ics:else>
		</ics:if>
		<%
		if(!ics.GetVar("AttrTypeID").equals("")){	
			FTValList newArgs = new FTValList();			
			newArgs.setValString("NAME", ics.GetVar("PresInst"));
			newArgs.setValString("VARNAME", "DISPLAYELEMENT");
			ics.runTag("presentation.getdisplayelement", newArgs);
		}
		%>
		<td></td>
		<td> 
			<ics:getproperty name="form.defaultMaxValues" file="futuretense_xcel.ini" output="MAXVALUES" />
			<ics:if condition='<%= !"true".equals(ics.GetVar("overWriteDefaultDisplay"))%>'>
			<ics:then>
				<ics:setvar name="doDefaultDisplay" value='no'/>				
				<%
					FTValList args = new FTValList();			
					args.setValString("NAME", ics.GetVar("PresInst"));
					args.setValString("ATTRIBUTE", "MAXVALUES");
					args.setValString("VARNAME", "MAXVALUES");
					ics.runTag("presentation.getmaxvalues", args);
				%>
			</ics:then>
			</ics:if>
			<assettype:list list="currentAT" >
				<ics:argument name='assettype' value='<%=ics.GetVar("attrassettype")%>' />
			</assettype:list> 
			<xlat:lookup  varname="_XLAT_" key="dvin/AT/Common/Selectassettypefromtree" escape='true'/>
			<xlat:lookup  varname="_XLAT_alt" key="dvin/AT/Common/dvin/AT/Common/Selectassettypefromtree" />
			<!-- If there are restricted subtypes, we have to pass those in a hidden field, so that the selections can be pruned during repost -->
			<ics:setvar name="subtypevalues" value=''/>
			<ics:setvar name="subTypesForLucene" value=''/>
			<%-- <SETVAR NAME="subtypevalues" VALUE="Variables.empty"/> --%>
			<%
				StringBuilder sbTypeLucene = new StringBuilder("");	
				int counter = 0;
			%>	
			<ics:if condition='<%=null != ics.GetList("attrassetsubtypes")%>'>
			<ics:then>
				<ics:if condition='<%=ics.GetList("attrassetsubtypes").hasData()%>'>
				<ics:then>
					<!-- Build a hash of the subtypes we're allowed to take -->
					<hash:create name="subtypehash" list="attrassetsubtypes" column="subtype"/> 
					<!-- Dump the hash table to the string.  Hopefully ; is a safe delimiter -->
					<hash:tostring name="subtypehash" varname="subtypevalues" delim=";" />
					<hash:tostring name="subtypehash" varname="subTypesForLucene" delim="," />
					<%						
						sbTypeLucene.append("{");
					%>
					<ics:listloop listname="attrassetsubtypes">
						<ics:listget listname="attrassetsubtypes" fieldname="subtype" output="subtypeval" />
						<%
							if(counter>0){
								sbTypeLucene.append(",");
							}	
							sbTypeLucene.append("\"" + ics.GetVar("subtypeval"));
							if("single".equals(ics.GetVar("EditingStyle"))){
								sbTypeLucene.append("\":false");
							}			
							else{
								sbTypeLucene.append("\":true");
							}
							counter++;
						%>	
					</ics:listloop>						
					<%
						sbTypeLucene.append("}");
					%>					
				</ics:then>
				</ics:if>
			</ics:then>
			</ics:if>
			
			<%--<span class="small-text"><xlat:stream key="dvin/AT/Forms/SelectTreeHint"></xlat:stream></span>--%>
			<%
				StringBuilder pickAssetVals = new StringBuilder();
				int i = 0;
			%>	
			<input type="hidden" name='<%="TP" + ics.GetList("tmplattrlist").getValue("assetid")%>' value=""/>
			<input type="hidden" name='<%="TPS" + ics.GetList("tmplattrlist").getValue("assetid")%>' value='<%=ics.GetVar("subtypevalues")%>'/>
			<hash:add name="treePickAttrs" value='<%=ics.GetList("tmplattrlist").getValue("assetid")%>' />
			<hash:create name="treePickVals" />
			<ics:listloop listname="AttrValueList">	
				<ics:listget listname="AttrValueList" fieldname="value" output="attrAssetId" />
				<hash:add name="treePickVals" value='<%=ics.GetVar("attrAssetId")%>' />
				<asset:getsubtype type='<%=ics.GetVar("attrassettype")%>' objectid='<%=ics.GetVar("attrAssetId")%>' output="pickAssetSubType" />	
				<asset:list type='<%=ics.GetVar("attrassettype")%>' list="currentAsset" field1="id" value1='<%=ics.GetVar("attrAssetId")%>' /> 	
				<ics:if condition="<%=ics.GetErrno()==0%>">
					<ics:then>
					<%
						if(i>0){
							pickAssetVals.append(";");
						}
						pickAssetVals.append(ics.GetVar("attrassettype"))
							.append(":")
							.append(ics.GetVar("attrAssetId"))
							.append(":")
							.append(ics.GetList("currentAsset").getValue("name"))
							.append(":")
							.append(ics.GetVar("pickAssetSubType"));
						i++;	
					%>				
					</ics:then>
				</ics:if>
			</ics:listloop>
			<ics:clearerrno />
			<hash:tostring name="treePickVals" varname="treePickVals" delim=";" />
			<input type="hidden" name='<%="MS" + ics.GetVar("AttrName")%>' value="yes"/>
			<input type="hidden" name='<%=ics.GetVar("cs_SingleInputName")%>' value='<%=ics.GetVar("treePickVals")%>'/>
			<script type="text/javascript">
				var typeAheadPickAssetSc_<%=ics.GetVar("AttrID")%> = function(args){
					var obj = document.forms[0],						
						arr = args._getValueAttr()
						pickCount = 0
						pickAssetIDs = '';
					var self_source = args._source;
					var strVC = '<%=ics.GetVar("AttrName")+"VC"%>';
					args._source.getAllNodes().forEach(function(node){
						var data = fw.ui.dnd.util.getNormalizedData(self_source, node);
						if(pickCount > 0)
							pickAssetIDs = pickAssetIDs + ';';
						pickAssetIDs = pickAssetIDs + data.id;
						pickCount++;	
					});	
					obj.elements['<string:stream variable="cs_SingleInputName"/>'].value = pickAssetIDs;
					if(obj.elements[strVC])
						obj.elements[strVC].value = args._source.getAllNodes().length;
				};
				
			</script>		
			<%
				StringBuilder pickTypeSB = new StringBuilder();
				pickTypeSB.append("[")
				.append("\""+ ics.GetVar("attrassettype") + "\"")
				.append("]");
				if("TypeAhead".equals(ics.GetVar("AttrEditorName"))){
					ics.SetVar("disInputbox", "true");
				}
				else{
					if("false".equals(ics.GetVar("showSiteTree"))){
						ics.SetVar("disInputbox", "true");
					}
					else{
						ics.SetVar("disInputbox", "false");
					}					
				}
				if("single".equals(ics.GetVar("EditingStyle"))){
					ics.SetVar("isPickMultiple", "false");
				}			
				else{
					ics.SetVar("isPickMultiple", "true");
				}				
			%>				
			
			<%if("TypeAhead".equals(ics.GetVar("AttrEditorName"))){%>
			<div style="display: table;">
				<div style="display:table-cell; vertical-align:middle;" name="typeAheadPickAsset_<%=ics.GetVar("AttrID")%>"> </div>
				<div style="display:table-cell; vertical-align:middle;">
				
					<img border="0" id="_fwTypeAheadHelpImg_<%=ics.GetVar("AttrID")%>" style="margin:2px 4px 4px 4px;" src="<%=ics.GetVar("cs_imagedir")+"/graphics/common/icon/help_new.png"%>"
						alt="Type To Search And Select"/>
					<script type="text/javascript">
						dojo.addOnLoad(function(){
							var displayInfo = {
								'<xlat:stream key="UI/UC1/JS/AcceptedAssetTypes" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': '<%=ics.GetVar("attrassettype")%>' ,
								'<xlat:stream key="UI/UC1/JS/AcceptedSubTypes" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': '<%= "" == ics.GetVar("subTypesForLucene")? "Any": ics.GetVar("subTypesForLucene") %>',
								'<xlat:stream key="UI/UC1/JS/AcceptsMultiple" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': <%=ics.GetVar("isPickMultiple")%>	
							};
							var dijitTooltip = new fw.ui.dijit.HoverableTooltip({
								connectedNodes: ["_fwTypeAheadHelpImg_<%=ics.GetVar("AttrID")%>"], 
								content: fw.util.createHoverableTooltip(displayInfo, false),
								position:'below' /*Only below supported */
							});
						});								
					</script>	
				</div>
			</div>	
			<%}else{%>
			<div style="display: table;">
				<% if(!"ucform".equals(ics.GetVar("cs_environment")) && "true".equals(ics.GetVar("showSiteTree"))){%>
					<div style="display:inline-block; margin-bottom: 10px;">
						<a href="javascript:void(0)" onclick="return SelectFromTreeAndTypeAhead('','','typeAheadPickAsset_<%=ics.GetVar("AttrID")%>')">
						<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton" >
							<ics:argument name="buttonkey" value="UI/Forms/AddSelectedItems" />
						</ics:callelement>					
						</a>
					</div>
				<%}%>
				<div name="typeAheadPickAsset_<%=ics.GetVar("AttrID")%>"> </div>
				<%if(!"ucform".equals(ics.GetVar("cs_environment"))){%>
					<div style="display:inline-block; vertical-align:middle;">
						<img border="0" id="_fwTypeAheadHelpImg_<%=ics.GetVar("AttrID")%>" style="margin:2px 4px 4px 4px;" src="<%=ics.GetVar("cs_imagedir")+"/graphics/common/icon/help_new.png"%>" 
						<% if("true".equals(ics.GetVar("showSiteTree"))){%>
							alt="Select From Tree"/>
						<%}else{%>
							alt="Type To Search And Select"/>
						<%}%>
						<script type="text/javascript">								
							dojo.addOnLoad(function(){
								var displayInfo = {
									'<xlat:stream key="UI/UC1/JS/AcceptedAssetTypes" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': '<%=ics.GetVar("attrassettype")%>' ,
									'<xlat:stream key="UI/UC1/JS/AcceptedSubTypes" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': '<%= "" == ics.GetVar("subTypesForLucene")? "Any": ics.GetVar("subTypesForLucene") %>',
									'<xlat:stream key="UI/UC1/JS/AcceptsMultiple" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': <%=ics.GetVar("isPickMultiple")%>		
								};
								var dijitTooltip = new fw.ui.dijit.HoverableTooltip({
									connectedNodes: ["_fwTypeAheadHelpImg_<%=ics.GetVar("AttrID")%>"], 
									content: fw.util.createHoverableTooltip(displayInfo, false),
									position:'below' /*Only below supported */
								});
							});								
						</script>	
					</div>
				<%}%>
			</div>	
			<%}%>		
				<!--AssetContainer-->
				<!--TypeAhead-->				
			<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/TypeAheadWidget'>		
				<ics:argument name="parentType" value='<%=pickTypeSB.toString()%>'/>
				<ics:argument name="subTypesForWidget" value='<%=sbTypeLucene.toString()%>'/>
				<ics:argument name="subTypesForSearch" value='<%=ics.GetVar("subTypesForLucene")%>'/>
				<ics:argument name="multipleVal" value='<%=ics.GetVar("isPickMultiple")%>'/>
				<ics:argument name="widgetValue" value='<%=pickAssetVals.toString()%>'/>	
				<ics:argument name="funcToRun" value='<%="typeAheadPickAssetSc_" + ics.GetVar("AttrID")%>'/>
				<ics:argument name="widgetNode" value='<%="typeAheadPickAsset_" + ics.GetVar("AttrID")%>'/>
				<ics:argument name="typesForSearch" value='<%=ics.GetVar("attrassettype")%>'/>
				<ics:argument name="multiOrderedAttr" value='true'/>
				<ics:argument name="displaySearchbox" value='<%=ics.GetVar("disInputbox")%>'/>	
				<ics:argument name="maxValsSetting" value='<%=ics.GetVar("MAXVALUES")%>'/>
				<ics:argument name="displayElement" value='<%=ics.GetVar("DISPLAYELEMENT")%>'/>				
			</ics:callelement>
		</td>
	</tr>		

<ics:removevar name="disInputbox"/>
<ics:removevar name="overWriteDefaultDisplay"/>
<ics:removevar name="MAXVALUES"/>
<ics:removevar name="DISPLAYELEMENT"/>
</cs:ftcs>