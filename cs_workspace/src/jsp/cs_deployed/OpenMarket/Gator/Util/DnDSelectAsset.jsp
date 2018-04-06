<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Gator/Util/DnDSelectAsset
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

<xlat:lookup key='dvin/AT/Common/SelectFromTree' varname="SelectFromTree"/>
<div>
	<div name="typeAheadSpecial_<%=ics.GetVar("id") + "_" + ics.GetVar("nameSuffix")%>"> </div>	
	
	<% if ("true".equals(ics.GetVar("showTypeAheadInputBox"))) {%>
	<div style="display:inline-block; vertical-align:top; float:left">
		<img border="0" id="_fwTypeAheadHelpImg_<%=ics.GetVar("id") + "_" + ics.GetVar("nameSuffix")%>" src="<%=ics.GetVar("cs_imagedir")+"/graphics/common/icon/help_new.png"%>" 
		<% if("ucform".equals(ics.GetVar("cs_environment"))){%>
			alt="Type To Search And Select" title="Type To Search And Select"/>
		<%}else{%>
			alt="Type To Search And Select" title="Type To Search And Select"/>
		<%}%>
		<script type="text/javascript">
			dojo.addOnLoad(function(){
				var displayInfo = {
					'<xlat:stream key="UI/UC1/JS/AcceptedAssetTypes" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': '<%= Utilities.goodString(ics.GetVar("assetTypeToSearch")) ? ics.GetVar("assetTypeToSearch") : "Any" %>',
					'<xlat:stream key="UI/UC1/JS/AcceptsMultiple" locale='<%=ics.GetVar("locale")%>'></xlat:stream>': false	
				};
				var dijitTooltip = new fw.ui.dijit.HoverableTooltip({
					connectedNodes: ["_fwTypeAheadHelpImg_<%=ics.GetVar("id") + "_" + ics.GetVar("nameSuffix")%>"], 
					content: fw.util.createHoverableTooltip(displayInfo),
					position:'below' /*Only below supported */
				});
			});								
		</script>
	</div>
	
	<% } else { %>
		<%--<div><xlat:stream key="UI/UC1/JS/DragProducts" locale='<%=ics.GetVar("locale")%>'></xlat:stream></div>--%>
	<% } %>	
</div>

<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/TypeAheadWidget'>			
	<ics:argument name="parentType" value='<%= Utilities.goodString(ics.GetVar("assetTypeToSearch")) ? "[\'" + ics.GetVar("assetTypeToSearch") + "\']" : "[\'*\']" %>'/>
	<ics:argument name="subTypesForWidget" value='*'/>
	<ics:argument name="subTypesForSearch" value=''/>
	<ics:argument name="multipleVal" value="true"/>
	<ics:argument name="widgetValue" value=""/>	
	<ics:argument name="funcToRun" value='<%="selectDnDSpecial_" + ics.GetVar("id") + "_" + ics.GetVar("nameSuffix") %>'/>
	<ics:argument name="widgetNode" value='<%="typeAheadSpecial_" + ics.GetVar("id") + "_" + ics.GetVar("nameSuffix")%>'/>
	<ics:argument name="typesForSearch" value='<%= Utilities.goodString(ics.GetVar("assetTypeToSearch")) ? ics.GetVar("assetTypeToSearch") : "" %>'/>	
	<ics:argument name="displaySearchbox" value='<%= "true".equals(ics.GetVar("showTypeAheadInputBox")) ? "true" : "false" %>'/>
	<ics:argument name="multiOrderedAttr" value='true'/>				
</ics:callelement>
</cs:ftcs>