<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="hash" uri="futuretense_cs/hash.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="assettype" uri="futuretense_cs/assettype.tld" %>
<%//
// OpenMarket/Xcelerate/Actions/AssetMgt/AssetChildrenFormTypeAhead
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
<%@ page import="com.openmarket.xcelerate.association.AssocNamedManager"%>
<%@ page import="com.openmarket.xcelerate.interfaces.IAssocNamedManager" %>
<%@ page import="com.openmarket.xcelerate.interfaces.AssocNamedManagerFactory" %>
<%@ page import="java.util.*"%>
<cs:ftcs>
<%!
Comparator<String> CCmpartr;	
Comparator getComparator()
{
	if(null != CCmpartr)
		return CCmpartr;
	else{	
		CCmpartr = new Comparator<String>() {
			
			public int compare(String arg0, String arg1) {
				int i1 = Integer.parseInt(arg0.substring(arg0.lastIndexOf(":") + 1, arg0.length()));
				int i2 = Integer.parseInt(arg1.substring(arg1.lastIndexOf(":") + 1, arg1.length()));
				if(i1 > i2)
					return 1;
				else if(i1 == i2)
					return 0;
				else
					return -1;
			}
		};
		return CCmpartr;
	}	
}
%>
<xlat:lookup  varname="noneString" key="dvin/Common/PnoneP"/>

<!-- This hidden signals to the gather element that it must expect data that has been posted from this element -->
<INPUT TYPE="hidden" NAME="AssetChildrenFormNew" VALUE="true"/>


<ics:if condition='<%=null == ics.GetVar("AssetChildrenFormNew")%>'>
<ics:then>
	<ics:setvar name='AssetChildrenFormNew' value='false>'/>
</ics:then>
</ics:if>

<%
	ics.SetVar("EmptyStr", "");
	ics.SetVar("NoneStr", "(none)");	
%>

<SCRIPT LANGUAGE="Javascript">
function setRelatedAsset(id,str,targ,val)
{
	document.forms[0].elements[targ].value = val;
	document.forms[0].elements[id].value = str;
}
</SCRIPT>
<%
	IAssocNamedManager anm = AssocNamedManagerFactory.make(ics);
%>
<!-- Get the list of possible child associations for this asset for all children or a single child assettype  -->
<!-- Find Any subtype associated with this asset type -->
<asset:getsubtype name="theCurrentAsset"/>
<ics:if condition='<%=null != ics.GetVar("childassettype")%>'>
<ics:then>
	<%
	IList associations = anm.getList(ics.GetVar("AssetType"),ics.GetVar("childassettype"),ics.GetVar("subtype"),Long.parseLong(ics.GetSSVar("pubid")),null,null,"name desc");
	ics.RegisterList("NamedAssociations",associations);	
	%>
</ics:then>
<ics:else>
	<%
	IList associations = anm.getList(ics.GetVar("AssetType"),null,ics.GetVar("subtype"),Long.parseLong(ics.GetSSVar("pubid")),null,null,"childassettype, name desc");
	ics.RegisterList("NamedAssociations",associations);
	%>
</ics:else>
</ics:if>
<assettype:load name="masterAsset" field="assettype" value='<%=ics.GetVar("AssetType")%>'/>
<assettype:get name="masterAsset" field="id" output="masterAssetId"/>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
<ics:if condition='<%=null != ics.GetList("NamedAssociations")%>'>
<ics:then>
	<ics:if condition='<%=ics.GetList("NamedAssociations").hasData()%>'>
	<ics:then>
		<%
			int i = 1;
		%>
		<ics:listloop listname="NamedAssociations">
		    <%--<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>--%>
			<ics:listget listname="NamedAssociations" fieldname="childassettype" output="childAssocAssetType" />
			<ics:listget listname="NamedAssociations" fieldname="name" output="assocName" />
			<ics:listget listname="NamedAssociations" fieldname="description" output="description" />
			<ics:listget listname="NamedAssociations" fieldname="multivalued" output="assocmultivalued" />
						<ics:if condition='<%=!(ics.GetVar("childAssocAssetType").equals(ics.GetVar("childAtype")))%>'>
						<ics:then>
							<ics:if condition='<%=!"*".equals(ics.GetVar("childAssocAssetType"))%>'>
							<ics:then>
								<assettype:load name="child" field="assettype" value='<%=ics.GetVar("childAssocAssetType")%>'/>
								<assettype:get name="child" field="description" output="childatdescription"/>
								<assettype:get name="child" field="assettype" output="childAssocAssetType"/>
								<assettype:get name="child" field="plural" output="childatplural"/>
							</ics:then>
							<ics:else>
								<xlat:lookup key="dvin/AT/Common/GenericAsset" varname='childatdescription'/>
								<ics:setvar name='childAssocAssetType' value='*'/>
							</ics:else>
							</ics:if>
							<ics:setvar name='childAtype' value='<%=ics.GetVar("childAssocAssetType")%>'/>
						</ics:then>
						</ics:if>
				<%
					StringBuilder childTypeSB = new StringBuilder();
					childTypeSB.append("[");
					int counterType = 0;
				%>
				<TR>
					<TD class="form-label-text"><% if ("-".equals(ics.GetVar("assocName"))) { %> <xlat:stream key='dvin/Common/AT/Contains'/>: <% } else if(ics.GetVar("description")!=null) { %>
				<%=ics.GetVar("description")%>:  <% } else { %> <%=ics.GetVar("assocName")%>: <%} %></TD>
					<TD ><BR/></TD>
					<TD class="form-inset">
						<TABLE CELLPADDING="0" BORDER="0">
						<TR>
							<TD align="left" NOWRAP="" VALIGN="MIDDLE">
								<ics:if condition='<%=!"*".equals(ics.GetVar("childAssocAssetType"))%>'>
								<ics:then>
									<ics:setvar name='legalchildassettypes' value='<%=ics.GetVar("childAssocAssetType")%>'/>
									<%
										childTypeSB.append("\"" + ics.GetVar("childAssocAssetType") + "\"");
									%>
								</ics:then>
								<ics:else>
									<ics:if condition='<%=null != ics.GetVar("childtypeslist")%>'>
									<ics:then>
										<ics:setvar name='legalchildassettypes' value='<%=ics.GetVar("childtypeslist")%>'/>
										<%
											childTypeSB.append("\"*\"");
										%>		
									</ics:then>
									<ics:else>
										<!-- We don't have the child types list hanging around, so assemble it -->
										<ics:setvar name='childtypeslist' value='<%=ics.GetVar("EmptyStr")%>'/>	
										<!--DoUBT RAJ
										<SETVAR NAME="childtypeslist" VALUE="Variables.empty"/>-->
										<!-- Find the enabled assets-->
										<ics:callelement element='OpenMarket/Xcelerate/Actions/AssetMgt/EnableAssetTypePub'> 
											<ics:argument name="upcommand" value='ListEnabledAssetTypes'/>
											<ics:argument name="list" value='potential_list'/>								
											<ics:argument name="pubid" value='<%=ics.GetSSVar("pubid")%>'/>	
										</ics:callelement>
										<ics:listloop listname="potential_list">
											<ics:listget listname="potential_list" fieldname="canbechild" output="canbechild" />
											<ics:listget listname="potential_list" fieldname="assettype" output="assettype" />
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
									</ics:else>	
									</ics:if>
								</ics:else>
								</ics:if>
								<%
									childTypeSB.append("]");
								%>
								
								
								<ics:if condition='<%="T".equals(ics.GetVar("assocmultivalued"))%>'>
								<ics:then>	
									
									<%
										StringBuilder sbMultChild = new StringBuilder();
									%>	
									<!-- Multivalued association -->
													
									<!-- The appropriate data can come in either in scatter form as "ContentDetails:xxx" (which is what happens
										on the first display)
									-->
									
									<!-- Build a hash of the already-selected asset id's, and a list of them too. -->
									<hash:create name="selectedContents"/>
									<listobject:create name="listobj" columns="otype,oid"/>
									<!-- Form the list from the scattered contentdetails stuff.  Unfortunately, we need to sort it first,
										and the only way to do that in XML-land is by a modified selection sort, because I haven't built a recursive
										sort element yet.  -->
									<!-- Some forms, on asset create, don't scatter, so make sure a value is created that works -->
									<ics:if condition='<%=null != ics.GetVar("ContentDetails:Association-named:"+ics.GetVar("assocName")+":Total")%>'> 
									<ics:then>
										<ics:setvar name='totalCount' value='<%=ics.GetVar("ContentDetails:Association-named:"+ics.GetVar("assocName")+":Total")%>'/>
									</ics:then>
									<ics:else>
										<ics:setvar name='totalCount' value='0'/>
									</ics:else>
									</ics:if>
									<ics:if condition='<%=!"0".equals(ics.GetVar("totalCount"))%>'>
									<ics:then>						
									<%	
										List<String> rList = new LinkedList<String>();
										for(int k = 0; k < Integer.parseInt(ics.GetVar("totalCount")) ; k++ )
										{
											rList.add("ContentDetails:Association-named:" + ics.GetVar("assocName") + ":" + String.valueOf(k) + ":" + ics.GetVar("ContentDetails:Association-named:" + ics.GetVar("assocName") + ":" + String.valueOf(k) + ":rank"));
										}										
										Collections.sort(rList, getComparator());
										Iterator iterator = rList.iterator();
										int counter = 0;
										while(iterator.hasNext())
										{
											String entry = (String) iterator.next();
											entry = entry.substring(0, entry.lastIndexOf(":"));
											%>
											<asset:getsubtype 
											type='<%=ics.GetVar(entry + ":ref_type")%>'
											objectid='<%=ics.GetVar(entry + ":ref")%>' output="anAssetChildMultSub" />
											
											<asset:list list="anAssetMultChild"
											field1="id" 
											value1='<%=ics.GetVar(entry  + ":ref")%>'  
											type='<%=ics.GetVar(entry + ":ref_type")%>'/> 
											<%
											if (counter != 0)
											{
												sbMultChild.append(";");
											}
											sbMultChild.append(ics.GetVar(entry + ":ref_type"))
												.append(":")
												.append(ics.GetVar(entry + ":ref"))
												.append(":")
												.append(ics.GetList("anAssetMultChild").getValue("name"))
												.append(":")
												.append(ics.GetVar("anAssetChildMultSub"));										
											counter++;
										}
									%>						
									</ics:then>
									</ics:if>
									<INPUT TYPE="hidden" NAME="Associates" VALUE='<string:stream value='<%=ics.GetVar("assocName")%>'/>'/>
									<INPUT TYPE="hidden" NAME="relMultiTag<%=i%>" VALUE=''/>
									<script type="text/javascript">
										var selectDnDAssocsMult_<%=ics.GetVar("masterAssetId") + "_" + i%> = function(args){
											var obj = document.forms[0],						
												arr = args._getValueAttr(), self_source = args._source, typeId = '', num = 0;
											// name
											// id
											//	type	
											args._source.getAllNodes().forEach(function(node){
												var data = fw.ui.dnd.util.getNormalizedData(self_source, node);
												if(arr.length > 0)
												{
													if(num > 0)
														typeId = typeId + ';';
														
													typeId = typeId + data.type + ',' + data.id;
													
													num++;
												}							
											});
											obj.elements['relMultiTag<%=i%>'].value = typeId;
										}
									</script>									
									<div>										
										<% if(!"ucform".equals(ics.GetVar("cs_environment")) && "true".equals(ics.GetVar("showSiteTree"))){%>
										<div style="display:inline-block; margin-bottom:10px;">
											<a href="javascript:void(0)" onclick="return SelectFromTreeAssocTAMult('<%="typeAheadAssocMult_" + ics.GetVar("masterAssetId") + "_" + i%>','<%=ics.GetVar("legalchildassettypes")%>')">
											<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/AddSelectedItems"/></ics:callelement></a>
										</div>	
										<%}%>
										<div name='typeAheadAssocMult_<%=ics.GetVar("masterAssetId") + "_" + i%>'></div>
										<%if(!"ucform".equals(ics.GetVar("cs_environment"))){%>
										<div style="display:inline-block; vertical-align:middle;">
											<img border="0" id="_fwTypeAheadHelpImg_<%=ics.GetVar("masterAssetId") + "_" + i%>" src="<%=ics.GetVar("cs_imagedir")+"/graphics/common/icon/help_new.png"%>" 
											<% if("true".equals(ics.GetVar("showSiteTree"))){%>
												alt="Select From Tree" />
											<%}else{%>
												alt="Type To Search And Select" />
											<%}%>
											<script type="text/javascript">
												dojo.addOnLoad(function(){
													var displayInfo = {
														'<xlat:stream key="UI/UC1/JS/AcceptedAssetTypes" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': '<%=ics.GetVar("legalchildassettypes")%>'.replace(/,/g, ", ") ,
														'<xlat:stream key="UI/UC1/JS/AcceptedSubTypes" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': 'Any',
														'<xlat:stream key="UI/UC1/JS/AcceptsMultiple" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': true	
													};
													var dijitTooltip = new fw.ui.dijit.HoverableTooltip({
														connectedNodes: ["_fwTypeAheadHelpImg_<%=ics.GetVar("masterAssetId") + "_" + i%>"], 
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
										<ics:argument name="funcToRun" value='<%="selectDnDAssocsMult_" + ics.GetVar("masterAssetId") + "_" + i%>'/>
										<ics:argument name="widgetNode" value='<%="typeAheadAssocMult_" + ics.GetVar("masterAssetId") + "_" + i%>'/>	
										<ics:argument name="typesForSearch" value='<%=ics.GetVar("legalchildassettypes")%>'/>
										<ics:argument name="displaySearchbox" value='<%=ics.GetVar("displayInputbox")%>'/>	
										<ics:argument name="multiOrderedAttr" value='true'/>	
										</ics:callelement>	
								</ics:then>
								<ics:else>
									
									<xlat:lookup key='dvin.Common/Edit' varname="_XLAT_" escape='true' />
									<ics:setvar name='assoc' value='<%=ics.GetVar("EmptyStr")%>'/>
									
									
									<!-- if there is no such variable, treat it the same as empty -->
									<ics:if condition='<%=(ics.GetVar("ContentDetails:Association-named:"+ics.GetVar("assocName"))!=null)%>'>
									<ics:then>
										<ics:setvar name='assoc' value='<%=ics.GetVar("ContentDetails:Association-named:"+ics.GetVar("assocName"))%>'/>
									</ics:then>
									</ics:if>
									<ics:setvar name='assoc_type' value='<%=ics.GetVar("EmptyStr")%>'/>
									
									<!-- if there is no such variable, treat it the same as empty -->
									<ics:if condition='<%=(ics.GetVar("ContentDetails:Association-named:"+ics.GetVar("assocName")+"_type")!=null)%>'>
									<ics:then>
										<ics:setvar name='assoc_type' value='<%=ics.GetVar("ContentDetails:Association-named:"+ics.GetVar("assocName")+"_type")%>'/>
									</ics:then>
									</ics:if>
													
									<%
										StringBuilder sbChild = new StringBuilder();
									%>					
									<ics:if condition='<%=!ics.GetVar("EmptyStr").equals(ics.GetVar("assoc"))%>'>
									<ics:then>
										<asset:list list="anAssetChild" field1="id" value1='<%=ics.GetVar("assoc")%>' type='<%=ics.GetVar("assoc_type")%>'/>
										<ics:if condition='<%=null != ics.GetList("anAssetChild")%>'>
										<ics:then>
											<ics:listloop listname="anAssetChild">
												<ics:listget listname="anAssetChild" fieldname="name" output="anAssetChildName" />
											</ics:listloop>	
											<ics:setvar name='name' value='<%=ics.GetVar("anAssetChildName")%>'/>
											<asset:getsubtype type='<%=ics.GetVar("assoc_type")%>' objectid='<%=ics.GetVar("assoc")%>' output="anAssetChildSub" />	
											
											<%
												sbChild.append(ics.GetVar("assoc_type"))
													.append(":")
													.append(ics.GetVar("assoc"))
													.append(":")
													.append(ics.GetVar("anAssetChildName"))
													.append(":")
													.append(ics.GetVar("anAssetChildSub"));
											%>
										</ics:then>
										<ics:else>
											<ics:setvar name='name' value='<%=ics.GetVar("NoneStr")%>'/>
											<ics:setvar name='assoc' value='<%=ics.GetVar("EmptyStr")%>'/>
											<ics:setvar name='assoc_type' value='<%=ics.GetVar("EmptyStr")%>'/>
										</ics:else>
										</ics:if>
									</ics:then>						
									<ics:else>
										<ics:setvar name='name' value='<%=ics.GetVar("NoneStr")%>'/>
										<ics:setvar name='assoc' value='<%=ics.GetVar("EmptyStr")%>'/>
										<ics:setvar name='assoc_type' value='<%=ics.GetVar("EmptyStr")%>'/>
									</ics:else>
									</ics:if>
									
									<!-- This hidden contains the id of the child asset -->
									
									<INPUT TYPE="hidden" VALUE='' NAME='<%=ics.GetVar("AssetType")+":Association-named:"+ics.GetVar("assocName")%>'/>
									<INPUT TYPE="hidden" NAME='<%=ics.GetVar("AssetType")+":Association-named:"+ics.GetVar("assocName")+"_type"%>' VALUE=''/>
									<INPUT TYPE="hidden" NAME="relatedTag<%=i%>" VALUE=''/>						
									<INPUT TYPE="hidden" NAME="Associates" VALUE='<string:stream value='<%=ics.GetVar("assocName")%>'/>'/>
									

									<script type="text/javascript">
										var selectDnDAssocs_<%=ics.GetVar("masterAssetId") + "_" + i%> = function(args){
											var obj = document.forms[0],						
												arr = args._getValueAttr();
											var self_source = args._source;
											// name
											// id
											//	type
											obj.elements['relatedTag<%=i%>'].value = '';
											obj.elements['<%=ics.GetVar("AssetType")+":Association-named:"+ics.GetVar("assocName")%>'].value = '';
											obj.elements['<%=ics.GetVar("AssetType")+":Association-named:"+ics.GetVar("assocName")+"_type"%>'].value = '';
											
											args._source.getAllNodes().forEach(function(node){
												var data = fw.ui.dnd.util.getNormalizedData(self_source, node);
												if(arr.length > 0)
												{
													obj.elements['relatedTag<%=i%>'].value = data.name;
													obj.elements['<%=ics.GetVar("AssetType")+":Association-named:"+ics.GetVar("assocName")%>'].value = data.id;
													obj.elements['<%=ics.GetVar("AssetType")+":Association-named:"+ics.GetVar("assocName")+"_type"%>'].value = data.type;
												}																
											});
										};
										
									</script>
									<div>										
										<% if(!"ucform".equals(ics.GetVar("cs_environment")) && "true".equals(ics.GetVar("showSiteTree"))){%>
										<div style="display:inline-block; margin-bottom:10px;">									
											<a href="javascript:void(0)" onclick="return SelectFromTreeAssocTypeAhead('typeAheadAssoc_<%=ics.GetVar("masterAssetId") + "_" + i%>','<%=ics.GetVar("legalchildassettypes")%>' , 'single')">
											<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/AddSelectedItems"/></ics:callelement></a>										
										</div>		
										<%}%>
										<div name='typeAheadAssoc_<%=ics.GetVar("masterAssetId") + "_" + i%>'></div>
										<%if(!"ucform".equals(ics.GetVar("cs_environment"))){%>
										<div style="display:inline-block; vertical-align:middle;">
											<img border="0" id="_fwTypeAheadHelpImg_<%=ics.GetVar("masterAssetId") + "_" + i%>" src="<%=ics.GetVar("cs_imagedir")+"/graphics/common/icon/help_new.png"%>" 
											<% if("true".equals(ics.GetVar("showSiteTree"))){%>
												alt="Select From Tree" />
											<%}else{%>
												alt="Type To Search And Select" />
											<%}%>
											<script type="text/javascript">
												dojo.addOnLoad(function(){
													var displayInfo = {
														'<xlat:stream key="UI/UC1/JS/AcceptedAssetTypes" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': '<%=ics.GetVar("legalchildassettypes")%>' ,
														'<xlat:stream key="UI/UC1/JS/AcceptedSubTypes" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': 'Any',
														'<xlat:stream key="UI/UC1/JS/AcceptsMultiple" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': false	
													};
													var dijitTooltip = new fw.ui.dijit.HoverableTooltip({
														connectedNodes: ["_fwTypeAheadHelpImg_<%=ics.GetVar("masterAssetId") + "_" + i%>"], 
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
										<ics:argument name="multipleVal" value="false"/>
										<ics:argument name="widgetValue" value="<%=sbChild.toString()%>"/>	
										<ics:argument name="funcToRun" value='<%="selectDnDAssocs_" + ics.GetVar("masterAssetId") + "_" +  i%>'/>
										<ics:argument name="widgetNode" value='<%="typeAheadAssoc_" + ics.GetVar("masterAssetId") + "_" + i%>'/>
										<ics:argument name="typesForSearch" value='<%=ics.GetVar("legalchildassettypes")%>'/>
										<ics:argument name="displaySearchbox" value='<%=ics.GetVar("displayInputbox")%>'/>	
										<ics:argument name="multiOrderedAttr" value='false'/>
									</ics:callelement>	
								</ics:else>
								</ics:if>				
				
							</TD>
						</TR>
						</TABLE>
					</TD>
				</TR> 
				<%
					i++;
				%>				
		</ics:listloop>		
	</ics:then>
	</ics:if>
</ics:then>
</ics:if>
</cs:ftcs>