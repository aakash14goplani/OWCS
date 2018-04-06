<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="hash" uri="futuretense_cs/hash.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld" %>
<%//
// OpenMarket/AssetMaker/BuildUnnamedAssociations
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
<ics:callelement element='OpenMarket/Xcelerate/UIFramework/Util/RowSpacer' />
<INPUT TYPE="HIDDEN" NAME="has_unnamed_associations" VALUE="true"/>
<INPUT TYPE="HIDDEN" NAME="_unnamed_associations" VALUE=""/>
<!-- Beginning of Group 5 -->
			<!--<callelement NAME="OpenMarket/Xcelerate/UIFramework/Util/RowSpacerBar"/>-->
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer" />
			<tr>
				<td valign="top" class="form-label-text"><xlat:stream key="dvin/Common/AT/Contains"/> :</td>
				<td></td>
				<td class="form-inset">
					<table border="0" cellpadding="0" cellspacing="0">
					<%
						StringBuilder childTypeSB = new StringBuilder();
						childTypeSB.append("[");
						int counter = 0;
						StringBuilder sbMultChild = new StringBuilder();
						ics.SetVar("EmptyStr", "");
					%>
						<!-- Find the cookies for enabled assets that can be childrem -->
						<ics:callelement element='OpenMarket/Xcelerate/Actions/AssetMgt/EnableAssetTypePub'> 
							<ics:argument name="upcommand" value='ListEnabledAssetTypes'/>
							<ics:argument name="list" value='EnabledAssetTypes'/>								
							<ics:argument name="pubid" value='<%=ics.GetSSVar("pubid")%>'/>	
						</ics:callelement>
						<ics:setvar name='childtypeslist' value=''/>
					    <ics:listloop listname="EnabledAssetTypes">
							<ics:listget listname="EnabledAssetTypes" fieldname="canbechild" output="canbechild" />
							<ics:listget listname="EnabledAssetTypes" fieldname="assettype" output="assettype" />
							<ics:if condition='<%="T".equals(ics.GetVar("canbechild"))%>'>
							<ics:then>
								<ics:if condition='<%=ics.GetVar("EmptyStr").equals(ics.GetVar("childtypeslist"))%>'>
								<ics:then>
									<ics:setvar name='childtypeslist' value='<%=ics.GetVar("assettype")%>'/>
									<%
										childTypeSB.append("\"" + ics.GetVar("assettype") + "\"");
									%>
								</ics:then>
								<ics:else>
									<ics:setvar name='childtypeslist' value='<%=ics.GetVar("childtypeslist")+","+ics.GetVar("assettype")%>'/>
									<%
										childTypeSB.append(",\"" + ics.GetVar("assettype") + "\"");
									%>
								</ics:else>
								</ics:if>
							</ics:then>
							</ics:if>
						</ics:listloop>
						<ics:setvar name='legalchildassettypes' value='<%=ics.GetVar("childtypeslist")%>'/>
						<%
							childTypeSB.append("]");
						%>
						<ics:if condition='<%=null == ics.GetList("EnabledAssetTypes")%>'>
						<ics:then>
							<ics:if condition='<%=!ics.GetList("EnabledAssetTypes").hasData()%>'>
							<ics:then>
							<tr>
							<td>
							<xlat:lookup key="dvin/UI/Admin/Noassettypesenabledforthissite" varname="msgtext"/>
							<ics:callelement element='OpenMarket/Xcelerate/UIFramework/Util/ShowMessage'> 
								<ics:argument name="msgtext" value='<%=ics.GetVar("msgtext")%>'/>
								<ics:argument name="severity" value='error'/>
							</ics:callelement>
							</td>
							</tr>
							</ics:then>
							</ics:if>
						</ics:then>
						</ics:if>
						<tr>
						<asset:children name="theCurrentAsset" code="-" order="nrank asc"  list="theContents"/>	
							
							<td></td>							
							<td valign="top" align="left">
							
							<ics:if condition='<%=null != ics.GetList("theContents")%>'>
							<ics:then>
								<ics:if condition='<%=ics.GetList("theContents").hasData()%>'>
								<ics:then>
									<ics:listloop listname="theContents">
									<ics:listget listname="theContents" fieldname="otype" output="otype" />
									<ics:listget listname="theContents" fieldname="oid" output="oid" />
									<asset:load name="anAsset" type='<%=ics.GetVar("otype")%>' objectid='<%=ics.GetVar("oid")%>' />
									<asset:get name="anAsset" field="name" output="anAssetName"/>
									<assettype:load name="childAssetType" field="assettype" value='<%=ics.GetVar("otype")%>'/>
									<assettype:get name="childAssetType" field="description" output="atdescription"/>
									<asset:getsubtype type='<%=ics.GetVar("otype")%>' objectid='<%=ics.GetVar("oid")%>' output="anAssetChildMultSub" />
									<%
											if (counter != 0)
											{
												sbMultChild.append(";");
											}
											sbMultChild.append(ics.GetVar("otype"))
												.append(":")
												.append(ics.GetVar("oid"))
												.append(":")
												.append(ics.GetVar("anAssetName"))
												.append(":")
												.append(ics.GetVar("anAssetChildMultSub"));										
											counter++;
									%>
									</ics:listloop>
								</ics:then>
								<ics:else>
									<!-- -->
								</ics:else>
								</ics:if>
							</ics:then>
							</ics:if>
							<script type="text/javascript">
										var _selectDnDUnnamedAssocs_ = function(args){
											var obj = document.forms[0],						
												arr = args._getValueAttr(), self_source = args._source, typeId = '', num = 0;
											args._source.getAllNodes().forEach(function(node){
												var data = fw.ui.dnd.util.getNormalizedData(self_source, node);
												if(arr.length > 0)
												{														
													typeId = typeId + data.type + ',' + data.id;
													typeId = typeId + ';';
													num++;
												}							
											});
											obj.elements['_unnamed_associations'].value = typeId;
										}
									</script>									
									<div>										
										<% if(!"ucform".equals(ics.GetVar("cs_environment")) && "true".equals(ics.GetVar("showSiteTree"))){%>
										<div style="display:inline-block;">
											<a href="javascript:void(0)" onclick="return SelectFromTreeAssocTAMult('_typeAheadUnnamedAssoc_','<%=ics.GetVar("legalchildassettypes")%>')">
											<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/AddSelectedItems"/></ics:callelement></a>
										</div>	
										<%}%>
										<div name='_typeAheadUnnamedAssoc_'></div>
										<%if(!"ucform".equals(ics.GetVar("cs_environment"))){%>
										<div style="display:inline-block; vertical-align:middle;">
											<img border="0" id="_fwTypeAheadHelpImgUnAssoc_" src="<%=ics.GetVar("cs_imagedir")+"/graphics/common/icon/help_new.png"%>" 
											<% if("true".equals(ics.GetVar("showSiteTree"))){%>
												alt="Select From Tree" title="Select From Tree"/>
											<%}else{%>
												alt="Type To Search And Select" title="Type To Search And Select"/>												
											<%}%>
											<script type="text/javascript">
												dojo.addOnLoad(function(){
													var displayInfo = {
														'<xlat:stream key="UI/UC1/JS/AcceptedAssetTypes" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': '<%=ics.GetVar("legalchildassettypes")%>'.replace(/,/g, ", ") ,
														'<xlat:stream key="UI/UC1/JS/AcceptedSubTypes" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': 'Any',
														'<xlat:stream key="UI/UC1/JS/AcceptsMultiple" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': true	
													};
													var dijitTooltip = new fw.ui.dijit.HoverableTooltip({
														connectedNodes: ["_fwTypeAheadHelpImgUnAssoc_"], 
														content: fw.util.createHoverableTooltip(displayInfo),
														position:'below' /*Only below supported */
													});
												});								
											</script>											
										</div>
										<%}%>
									</div>
									<br/>
									<%
										if("false".equals(ics.GetVar("showSiteTree"))){
											ics.SetVar("displayInputbox", "true");
										}
										else{
											ics.SetVar("displayInputbox", "false");
										}
									%>
									<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/TypeAheadWidget'> 
										<ics:argument name="parentType" value='<%=childTypeSB.toString()%>'/>
										<ics:argument name="subTypesForWidget" value='*'/>
										<ics:argument name="subTypesForSearch" value=''/>
										<ics:argument name="multipleVal" value="true"/>
										<ics:argument name="widgetValue" value="<%=sbMultChild.toString()%>"/>	
										<ics:argument name="funcToRun" value='<%="_selectDnDUnnamedAssocs_"%>'/>
										<ics:argument name="widgetNode" value='<%="_typeAheadUnnamedAssoc_"%>'/>	
										<ics:argument name="typesForSearch" value='<%=ics.GetVar("legalchildassettypes")%>'/>
										<ics:argument name="displaySearchbox" value='<%=ics.GetVar("displayInputbox")%>'/>	
										<ics:argument name="multiOrderedAttr" value='true'/>	
									</ics:callelement>		      	
							</td>
						</tr>						
					</table>
				</td>
			</tr>

</cs:ftcs>