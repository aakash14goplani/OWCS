<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Gator/AttributeTypes/RenderDisplayTooltip
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
<%!
private String getElementPath(ICS ics, String dndAssetType, String elementName){
	
	String  assetTypePath = "CustomElements/"+ ics.GetSSVar("PublicationName") + "/" + dndAssetType  + "/",
			sitePath = "CustomElements/"+ ics.GetSSVar("PublicationName") + "/",
			attrEditorName = "TypeAhead".equals(ics.GetVar("AttrEditorName"))? "TYPEAHEAD" : "PICKASSET",
			defaultPath = "OpenMarket/Gator/AttributeTypes/" + attrEditorName + "/",
			elementPath;
	
	if(ics.IsElement(assetTypePath + defaultPath + elementName)){
		elementPath = assetTypePath + defaultPath;
	} else if(ics.IsElement(sitePath + defaultPath + elementName)){
		elementPath = sitePath + defaultPath;
	} else { 
		elementPath = defaultPath;
	}
	
	return elementPath + elementName;
}
%>
<%
if (Utilities.goodString(ics.GetVar("widgetValue"))) {
	String[]  searchSubTypeArr = ics.GetVar("widgetValue").split(";");
	String	multiple = "true",
			acceptedSubtypes = ics.GetVar("subTypesForWidget");
	
	if (null != ics.GetVar("multipleVal") && "false".equals(ics.GetVar("multipleVal"))) {
		multiple = "false";
	}
	
	if (!Utilities.goodString(ics.GetVar("subTypesForWidget")) || "*".equals(ics.GetVar("subTypesForWidget"))) {
		acceptedSubtypes = "Any";
	} else if(acceptedSubtypes.startsWith("{")){
		acceptedSubtypes = acceptedSubtypes.substring( 2, acceptedSubtypes.indexOf("\":"));
	}
	
	for(String str: searchSubTypeArr)
	{
		String[]  values = str.split(":");
		String uniqueId = ics.GetVar("AssetType") + ics.GetVar("id") + values[1];
%>
		<div id='<%= "de_" + ics.GetVar("widgetNode") + "_" + uniqueId %>' style='display:none;'>
			<ics:callelement element='<%= getElementPath(ics, values[0], "DisplayHtml") %>'>
				<ics:argument name="assetType" value='<%= ics.GetVar("AssetType")%>'/>
				<ics:argument name="assetId" value='<%= ics.GetVar("id")%>'/>
				<ics:argument name="dndAssetType" value='<%= values[0] %>'/>
				<ics:argument name="dndId" value='<%= values[1]%>'/>
				<ics:argument name="dndName" value='<%= values[2] %>'/>
				<ics:argument name="dndSubtype" value='<%= values.length > 3 ? values[3] : ""%>'/>
				<ics:argument name="multiple" value='<%= multiple %>'/>
				<ics:argument name="acceptedSubtypes" value='<%= acceptedSubtypes %>'/>
			</ics:callelement>		
		</div>
		<div id='<%= "te_" + ics.GetVar("widgetNode") + "_" + uniqueId %>' style='display:none;'>
			<ics:callelement element='<%= getElementPath(ics, values[0], "TooltipHtml") %>'>
				<ics:argument name="assetType" value='<%= ics.GetVar("AssetType")%>'/>
				<ics:argument name="assetId" value='<%= ics.GetVar("id")%>'/>
				<ics:argument name="dndAssetType" value='<%= values[0] %>'/>
				<ics:argument name="dndId" value='<%= values[1]%>'/>
				<ics:argument name="dndName" value='<%= values[2] %>'/>
				<ics:argument name="dndSubtype" value='<%= values.length > 3 ? values[3] : ""%>'/>
				<ics:argument name="multiple" value='<%= multiple %>'/>
				<ics:argument name="acceptedSubtypes" value='<%= acceptedSubtypes %>'/>
			</ics:callelement>		
		</div>
<%
	}
}
%>
</cs:ftcs>