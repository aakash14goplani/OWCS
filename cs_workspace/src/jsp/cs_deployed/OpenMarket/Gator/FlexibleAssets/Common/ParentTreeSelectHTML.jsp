<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Gator/FlexibleAssets/Common/ParentTreeSelectHTML
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
<tr>
<script type="text/javascript">
	var selectDnDParent_ta_<%=ics.GetVar("parentDefID")%> = function(args){
		var obj = document.forms[0],						
			arr = args._getValueAttr(), DecodedString = {}, self =args, i=1, parDefs, parDef;		
		parDefs = args._source.accept_definition;
		var self_source = args._source;
		for(parDef in parDefs){
			if(parDef != '*')
				obj.elements['_ParentDef_'+parDef+'_HasParents_'].value = false;
		}
		args._source.getAllNodes().forEach(function(node){
			var data = fw.ui.dnd.util.getNormalizedData(self_source, node);
			if (parDefs.hasOwnProperty(data.subtype)) {
				if(!parDefs['*']){
					if(arr.length > 0){
						obj.elements['_ParentDef_'+data.subtype+'_HasParents_'].value = true;									
					}
					else
						obj.elements['_ParentDef_'+data.subtype+'_HasParents_'].value = false;
				}		
			}							
		});
		selectDnDParent();
	}
</script>


<td class="form-label-text">
	<ics:if condition='<%=ics.GetVar("parentReq").equals("true")%>'>
	<ics:then>
		<span class="alert-color">*</span><%=ics.GetVar("parentDefNameDesc")%>:
	</ics:then>
	<ics:else>
		<%=ics.GetVar("parentDefNameDesc")%>:
	</ics:else>
	</ics:if>
</td>
<td></td>
<td>		
<%if("A".equals(ics.GetVar("parentselectStyle"))){%>
	<div style="display: table;">
		<div name="typeAheadParent_<%=ics.GetVar("parentDefID")%>"> </div>
		<div style="display:table-cell; vertical-align:middle;">
			<img style="margin:2px 4px 4px 4px;" border="0" id="_fwTypeAheadHelpImg_<%=ics.GetVar("parentDefID")%>" src="<%=ics.GetVar("cs_imagedir")+"/graphics/common/icon/help_new.png"%>" 
				alt="Type To Search And Select" title=""/>
			<script type="text/javascript">
				dojo.addOnLoad(function(){
					var displayInfo = {
						'<xlat:stream key="UI/UC1/JS/AcceptedAssetTypes" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': '<%=ics.GetVar("grouptype")%>',
						'<xlat:stream key="UI/UC1/JS/AcceptedSubTypes" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': '<%=ics.GetVar("parentDefName")%>',
						'<xlat:stream key="UI/UC1/JS/AcceptsMultiple" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': <%=ics.GetVar("parentMult")%>	
					};
					var dijitTooltip = new fw.ui.dijit.HoverableTooltip({
						connectedNodes: ["_fwTypeAheadHelpImg_<%=ics.GetVar("parentDefID")%>"], 
						content: fw.util.createHoverableTooltip(displayInfo),
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
				<a href="javascript:void(0)" onclick="return SelectFromTreeAndTypeAhead('<%=ics.GetVar("TemplateChosen")%>','ParentSelect','typeAheadParent_<%=ics.GetVar("parentDefID")%>')"
					onmouseover="window.status='<%=ics.GetVar("SelectParentFromTreeEsc")%>'; return true;" onmouseout="window.status=' ';return true;">
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/AddSelectedItems"/><ics:argument name="sign" value="+"/></ics:callelement></a>
			</div>		
			<%}%>
			<div name="typeAheadParent_<%=ics.GetVar("parentDefID")%>"> </div>	
			<%if(!"ucform".equals(ics.GetVar("cs_environment"))){%>
			<div style="display:inline-block; vertical-align:middle;">
				<img border="0" id="_fwTypeAheadHelpImg_<%=ics.GetVar("parentDefID")%>" style="margin:2px 4px 4px 4px;" src="<%=ics.GetVar("cs_imagedir")+"/graphics/common/icon/help_new.png"%>" 
				<% if("true".equals(ics.GetVar("showSiteTree"))){%>
					alt="Select From Tree" title=""/>
				<%}else{%>
					alt="Type To Search And Select" title=""/>
				<%}%>
				<script type="text/javascript">
					dojo.addOnLoad(function(){
						var displayInfo = {
							'<xlat:stream key="UI/UC1/JS/AcceptedAssetTypes" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': '<%=ics.GetVar("grouptype")%>',
							'<xlat:stream key="UI/UC1/JS/AcceptedSubTypes" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': '<%=ics.GetVar("parentDefName")%>',
							'<xlat:stream key="UI/UC1/JS/AcceptsMultiple" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': <%=ics.GetVar("parentMult")%>	
						};
						var dijitTooltip = new fw.ui.dijit.HoverableTooltip({
							connectedNodes: ["_fwTypeAheadHelpImg_<%=ics.GetVar("parentDefID")%>"], 
							content: fw.util.createHoverableTooltip(displayInfo),
							position:'below' /*Only below supported */
						});
					});								
				</script>	
			</div>
			<%}%>
		</div>	
	<%}%>
	</td>
</tr>	
</cs:ftcs>