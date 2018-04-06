<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>

<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>

<cs:ftcs>

<!-- OpenMarket/Xcelerate/AssetType/AdvCols/DetailStaticRec
-
-	Detail tab core for mode = Recommendation, type = Static List
-
- INPUT
-
- DisplayOnly
-
- OUTPUT
-
-->

	<!-- ASSUME that this is the EDIT view... deal with layering the "Inspect" view later -->

	<!--New Segment Selection-->
	<ics:callelement element="OpenMarket/Xcelerate/AssetType/AdvCols/SegmentKeyLookup"/>
	
	<ics:sql sql="select distinct assetattr from FlexAssetTypes ORDER BY assetattr" listname= "SortAssetTypeList" table="FlexAssetTypes"/>

	<xlat:lookup key="dvin/AT/Common/Special" varname="SpStrH"/>

	<!-- Prepare for the Dynamic element selection  typeAhead -->
	<satellite:link pagename="fatwire/ui/util/TypeAheadSearchResults" assembler="query" outstring="typeAheadUrl">
		<satellite:argument name="searchField" value='name'/>
		<satellite:argument name="searchOperation" value='STARTS_WITH'/>
		<satellite:argument name="assetType" value='CSElement'/>
		<satellite:argument name="assetSubType" value=''/>
		<satellite:argument name="sort" value='name'/>
		<satellite:argument name="rows" value='1000'/>	
	</satellite:link>

<% 
{
	// =============================================================================
	// JS/JSON data representing a set of asset types and attributes - used for Sort
	// =============================================================================

	ics.StreamText("<script type='text/javascript'>\r\n");
	ics.StreamText("sortAssetData = [\r\n");

	IList assetTypeList = ics.GetList("SortAssetTypeList"); 
	int nTypes = assetTypeList.numRows();

	FTValList args = new FTValList();

	for (int type=0; type < nTypes; type++)
	{
		assetTypeList.moveTo(type+1);

		String assetType = assetTypeList.getValue("assetattr");

		// <ATM.LOCATE TYPE=typeName varname="AMGR"/>
		args.removeAll();
		args.setValString("TYPE", assetType);
		args.setValString("VARNAME", "AMGR");
		ics.runTag("atm.locate", args);				
	
		// <COMPLEXASSETS.GETALLASSETS NAME="AMGR" LISTVARNAME="AllAttr" SITE="SessionVariables.pubid"/>
		args.removeAll();
		args.setValString("NAME", "AMGR");
		args.setValString("LISTVARNAME", "AllAttr");
		args.setValString("SITE", ics.GetSSVar("pubid"));
		ics.runTag("complexassets.getallassets", args);
	
		IList attrList = ics.GetList("AllAttr"); 
		int nAttrs = attrList.numRows();

		if (type != 0)
			ics.StreamText(",");
		
		ics.StreamText("{name:'" + assetType + "',\r\n");
		
		args.removeAll();
		args.setValString("LIST", "thisAssetType");
		args.setValString("FIELD1", "assettype");
		args.setValString("VALUE1", assetType);
		ics.runTag("ASSETTYPE.LIST", args);

		IList thisAssetType = ics.GetList("thisAssetType");
		ics.StreamText(" desc:'" + thisAssetType.getValue("description") + "',\r\n");
		
		ics.StreamText(" attributes: [ ");
		
		for (int attr = 0; attr < nAttrs; attr++)
		{
			attrList.moveTo(attr+1);
			
			String attrId = attrList.getValue("assetid");			

			args.removeAll();
			args.setValString("TYPE", assetType);
			args.setValString("LIST", "AttrInst");
			args.setValString("FIELD1", "id");
			args.setValString("VALUE1", attrId);
			ics.runTag("ASSET.LIST", args);
			
			IList attrInst = ics.GetList("AttrInst");

			if (attr != 0)
				ics.StreamText(",");
			
			ics.StreamText("'" + attrInst.getValue("name") + "'");
		}
		
		ics.StreamText(" ]\r\n");
		ics.StreamText("}\r\n");
	}
		
	// add the "special" asset and attributes
	ics.StreamText(", {name:'" + ics.GetVar("SpStrH") + "', desc:'" + ics.GetVar("SpStrH") + "',attributes: ['_ASSETTYPE_', '_CONFIDENCE_', '_RATING_' ]}");
	
	ics.StreamText("] \r\n");	// close "assetData" array
	ics.StreamText("</script>\r\n");
}
%>

<% 
{
	// =========================================================
	// JS/JSON data representing the full list of known segments
	// =========================================================

	// <ATM.LOCATE TYPE="Segments" varname="segmgr"/>
	FTValList args = new FTValList();
	
	args.removeAll();
	args.setValString("TYPE", "Segments");
	args.setValString("VARNAME", "segmgr");
	ics.runTag("atm.locate", args);				

	// <COMPLEXASSETS.GETALLASSETS NAME="segmgr" LISTVARNAME="SegList" SITE="SessionVariables.pubid"/>
	args.removeAll();
	args.setValString("NAME", "segmgr");
	args.setValString("LISTVARNAME", "SegList");
	args.setValString("SITE", ics.GetSSVar("pubid"));
	ics.runTag("complexassets.getallassets", args);

	IList segList = ics.GetList("SegList"); 
	int nSegs = segList.numRows();
	int seg = 0;
	
	ics.StreamText("<script type='text/javascript'>\r\n");
	ics.StreamText("segmentData = [\r\n");
	
	for (seg=0; seg < nSegs; seg++)
	{
		segList.moveTo(seg+1);

		if (seg != 0)
			ics.StreamText(",");
		
		String assetid = segList.getValue("assetid");

		args.removeAll();
		args.setValString("TYPE", "Segments");
		args.setValString("LIST", "SegInst");
		args.setValString("FIELD1", "id");
		args.setValString("VALUE1", assetid);
		ics.runTag("ASSET.LIST", args);
		
		IList segInst = ics.GetList("SegInst");
		
		ics.StreamText("{name:'" + segInst.getValue("name") + "'");
		ics.StreamText(",key:'" + Utilities.genID() + "'");
		ics.StreamText(",id:'" + assetid + "'}");
	}
		
	ics.StreamText("] \r\n");	// close "segmentData" array
	ics.StreamText("</script>\r\n");
}
%>

<%
{
	// =============================================================
	// JS/JSON data representing the RECOMMENDATION 
	// (mode + type + options + sort + select + segments +  assets) 
	// =============================================================
	
	ics.StreamText("<script type='text/javascript'>\r\n");
	ics.StreamText("listData = {\r\n");
	
	ics.StreamText("mode:'" + ics.GetVar("AdvColMode") + "',\r\n");
	ics.StreamText("type:'" + ics.GetVar("advcoltype") + "',\r\n");

	// ===========================
	
	String selection = ics.GetVar("ContentDetails:style");
	
	if (selection == null || selection.isEmpty())
		selection = "F";
	
	ics.StreamText("selection:'" + selection + "',\r\n");

	// ===========================
		
	ics.StreamText("options: {\r\n");
	
	ics.StreamText("ovrdable:'" + ics.GetVar("ContentDetails:ovrdable") + "',\r\n");
	ics.StreamText("mapstyle:'" + ics.GetVar("ContentDetails:mapstyle") + "',\r\n");

	int nTypes = Integer.parseInt(ics.GetVar("ContentDetails:types:Total"));		
	
	ics.StreamText("types: [\r\n");
	
	if (nTypes > 1 || (nTypes == 1 && !"_ALL_".equals(ics.GetVar("ContentDetails:types:0"))))
	{
		for (int t = 0; t < nTypes; t++)
		{
			if (t != 0)
				ics.StreamText(",");
			
			ics.StreamText("'" + ics.GetVar("ContentDetails:types:" + Integer.toString(t)) + "'");
		}
	}
	
	ics.StreamText("]\r\n");		// close "types" array
	ics.StreamText("},\r\n"); 		// close "options" object
	
	// ===========================
		
	ics.StreamText("sortorder: [\r\n");
	
	IList sortOrderList = ics.GetList("ContentDetails:Sortorder");		
	
	if (sortOrderList != null)
	{
		int nSorts = sortOrderList.numRows();
		
		for (int rec=0; rec < nSorts; rec++)
		{
			sortOrderList.moveTo(rec+1);
	
			if (rec != 0)
				ics.StreamText(",");
				
			ics.StreamText("{ attributetypename:'" +  sortOrderList.getValue("attributetypename") + "'");
			ics.StreamText(", attributename:'" +  sortOrderList.getValue("attributename") + "'");
			ics.StreamText(", direction:'" +  sortOrderList.getValue("direction") + "' }\r\n");
		}		
	}
	
	ics.StreamText("],\r\n"); 		// close "sortorder" array
		
	// ===========================
		
	ics.StreamText("segments: [\r\n");

	IList segList = ics.GetList("SegFromKeysList"); 
	int nSegs = segList.numRows();
	
	for (int seg=0; seg < nSegs; seg++)
	{
		segList.moveTo(seg+1);

		if (seg != 0)
			ics.StreamText(",");
		
		ics.StreamText("{name:'" + segList.getValue("segName") + "'");
		ics.StreamText(",key:'" + segList.getValue("segKey") + "'");
		ics.StreamText(",id:'" + segList.getValue("segId") + "'");

		ics.StreamText(", assets: [\r\n");

		// asset list detail goes here

		FTValList args = new FTValList();

		args.removeAll();
		args.setValString("NAME", "theCurrentAsset");
		args.setValString("LISTVARNAME", "recList");
		args.setValString("BUCKET", segList.getValue("segKey") + "_IN");
		ics.runTag("ACOLLECTION.SORTMANUALRECOMMENDATIONS", args);

		IList recList = ics.GetList("recList");		
		
		int nRecs = recList.numRows();
		
		for (int rec=0; rec < nRecs; rec++)
		{
			recList.moveTo(rec+1);
			
			String assetid = recList.getValue("assetid");
			String assettype = recList.getValue("assettype");
			String confidence = recList.getValue("confidence");
			
			Float f = new Float(confidence);
			f = f*100;
			confidence = Integer.toString(f.intValue());
			
			args.removeAll();
			args.setValString("TYPE",  assettype);
			args.setValString("LIST", "assetList");
			args.setValString("FIELD1", "id");
			args.setValString("VALUE1", assetid);
			ics.runTag("ASSET.LIST", args);
			
			IList assetList = ics.GetList("assetList");
			
			args.removeAll();
			args.setValString("LIST", "assetTypeList");
			args.setValString("FIELD1", "assettype");
			args.setValString("VALUE1", assettype);
			ics.runTag("ASSETTYPE.LIST", args);
			
			IList assetTypeList = ics.GetList("assetTypeList"); 
			
			if (rec != 0)
				ics.StreamText(",");
				
			ics.StreamText("{id:'" +  assetid + "'");
			ics.StreamText(",type:'" +  assettype + "'");
			ics.StreamText(",typedesc:'" +  assetTypeList.getValue("description") + "'");
			ics.StreamText(",name:'" +  assetList.getValue("name") + "'");
			ics.StreamText(",confidence:'" + confidence + "'");
			
			ics.StreamText("}\r\n");	// close the asset object
		}
		
		ics.StreamText("]");	// close the  "assets" array
		
		ics.StreamText(" }\r\n");	// close one "segment" object
	}

	ics.StreamText("] \r\n");	// close "segments" array

	// now - deal with the "no segments apply" case

	{
		ics.StreamText(", assets: [\r\n");

		FTValList args = new FTValList();
		
		args.removeAll();
		args.setValString("NAME", "theCurrentAsset");
		args.setValString("LISTVARNAME", "recList");
		args.setValString("BUCKET", "");
		ics.runTag("ACOLLECTION.SORTMANUALRECOMMENDATIONS", args);
	
		IList recList = ics.GetList("recList");		
	
		//@BJN DUPLICATE
		
		int nRecs = recList.numRows();
		
		for (int rec=0; rec < nRecs; rec++)
		{
			recList.moveTo(rec+1);
			
			String assetid = recList.getValue("assetid");
			String assettype = recList.getValue("assettype");
			String confidence = recList.getValue("confidence");
	
			Float f = new Float(confidence);
			f = f*100;
			confidence = Integer.toString(f.intValue());

			args.removeAll();
			args.setValString("TYPE",  assettype);
			args.setValString("LIST", "assetList");
			args.setValString("FIELD1", "id");
			args.setValString("VALUE1", assetid);
			ics.runTag("ASSET.LIST", args);
			
			IList assetList = ics.GetList("assetList");
			
			args.removeAll();
			args.setValString("LIST", "assetTypeList");
			args.setValString("FIELD1", "assettype");
			args.setValString("VALUE1", assettype);
			ics.runTag("ASSETTYPE.LIST", args);
			
			IList assetTypeList = ics.GetList("assetTypeList"); 
			
			if (rec != 0)
				ics.StreamText(",");
				
			ics.StreamText("{id:'" +  assetid + "'");
			ics.StreamText(",type:'" +  assettype + "'");
			ics.StreamText(",typedesc:'" +  assetTypeList.getValue("description") + "'");
			ics.StreamText(",name:'" +  assetList.getValue("name") + "'");
			ics.StreamText(",confidence:'" + confidence + "'");
			
			ics.StreamText("}\r\n");	// close the asset object
		}
		
		ics.StreamText("]");	// close "assets" array
	}
	
	ics.StreamText("} \r\n");	// close outer level "listData" object
	ics.StreamText("</script>\r\n");
} %>

<style type="text/css">
	div.LISTDATA {
		padding: 5px;
		border-style: solid;
		border-color: black;
		border-width: 1px;
	}

	div.ASSETTYPELIST {
		margin: 3px;
		padding: 3px;
		border-style: solid;
		border-color: red;
		border-width: 1px;
	} 

	div.ASSETTYPE {
		margin: 3px;
		padding: 1px;
		border-style: dotted;
		border-color: red;
		border-width: 1px;
	} 
	
	div.ANDADDER {
		margin: 3px;
		padding: 1px;
		border-style: dashed;
		border-color: red;
		border-width: 1px;
	} 

	div.ASSETLIST {
		margin: 3px;
		padding: 3px;
		border-style: solid;
		border-color: blue;
		border-width: 1px;
	} 
	
	div.ASSET {
		margin: 3px;
		padding: 1px;
		border-style: dotted;
		border-color: blue;
		border-width: 1px;
	}
	
	div.ORADDER {
		margin: 3px;
		padding: 1px;
		border-style: dashed;
		border-color: blue;
		border-width: 1px;
	}
	
	span.ROWLEFT {
		float: left;
	}
	
	span.ROWRIGHT {
		float: right;
	}

	span.CELLLEFT {
		float: left;
	}
	
	span.CELLRIGHT {
		float: right;
	}
	
</style>

<script type="text/javascript">

function onRemoveAsset(evt)
{
//	debugger

	setTabDirty();

	var cell = evt.target;
	
	while (!cell.id)
		cell = cell.parentElement;
	
	var s = cell.id.split("_");
	var att = s[1];
	
	if (s.length > 2)
	{	// this is a "known segment" Asset
		var seg = s[2];
		listData.segments[seg].assets.splice(att, 1);
	}
	else
	{	// this is a "no segments apply" asset
		listData.assets.splice(att, 1);
	}
		
	renderListData();	
}

function onRemoveSegment(evt)
{
//	debugger
	
	setTabDirty();
	
	var cell = evt.target;
	
	while (!cell.id)
		cell = cell.parentElement;
	
	var s = cell.id.split("_");
	var seg = s[1];
	
	listData.segments.splice(seg, 1);

	renderListData();	
}

function onConfidenceValueChange(value)
{
//	debugger

	setTabDirty();

	this.assetData.confidence = value;
	renderListData();	
}

function renderConfidenceTextbox(parentDiv, data)
{
	var value = data.confidence;
	
	var textbox = dojo.create("input", {type: "text", size: 4}, parentDiv);
	textbox = new fw.dijit.UIInput ({value: value}, textbox);
	textbox.assetData = data;
	textbox.connect(textbox, "onChange", onConfidenceValueChange);
}

function renderAsset(div, data)
{
	var altText = '<xlat:stream key="dvin/AT/Common/Removefromlist"/>';
	var statusText = '<xlat:stream key="dvin/AT/Common/Removefromlist" escape="true"/>';

	var a = dojo.create("a", {onclick: onRemoveAsset,
							  onmouseover: "window.status='" + statusText + "'; return true;",
							  onmouseout: "window.status=''; return true;",
							 }, div);
	
	dojo.create("img", { src: "<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconDeleteContent.gif",
				         title: altText, alt: altText, border: "0", hspace: "2" }, a);
	
	dojo.create("span", {}, div).innerHTML = data.id + " | " + data.name + "(" + data.typedesc + ")";			
	renderConfidenceTextbox(div, data);
	dojo.create("span", {}, div).innerHTML = " %";			
}

function dropSelect(args)
{
// debugger
	
	var values = args.getAllDnDValues();
	
	if (values.length > 0)
	{
		setTabDirty();
		
		// clean up the dropZone for the next go around...		
		var nodes = dojo.query('div.dojoDndItem');
		if (nodes.length > 0)
		{
			var dndNode = nodes[0];   
			fw.ui.dnd.util.destroyItem(args._source, dndNode);
			//clean up event hook for node being removed
			dojo.disconnect(args._source._removeConnects[dndNode.id]);
			delete args._source._removeConnects[dndNode.id];
			args.showDropZone();
		}
		
		// add the data to the appropriate "assets" array...
		var asset = {id: values[0][0], type: values[0][1], name: values[0][2], typedesc: values[0][1], confidence: "100"};
		
		var s = args.id.split("_");
		var seg = s[1];
	
		if (seg && seg != "")
		{
			var segment = listData.segments[seg];
	
			if (!segment.assets)
				segment.assets = new Array();
			
			segment.assets[segment.assets.length] = asset;
		}
		else
		{
			if (!listData)
				listData.assets = new Array();
			
			listData.assets[listData.assets.length] = asset;
		}

		// then - redraw everything...
		
		renderListData();
	}
	else
	{
		alert("NO VALUES");
	}
}

function listSelect(args)
{
// debugger
	
	var values = args.getAllDnDValues();
	
	if (values.length > 0)
	{
		setTabDirty();

		listData.assets = new Array();

		var confidence = 100;
		
		for (var v = 0; v < values.length; v++)
		{
			// add the data to the "assets" array...
			var asset = {id: values[v][0], type: values[v][1], name: values[v][2], typedesc: values[v][1], confidence: confidence};
			
			listData.assets[listData.assets.length] = asset;
			
			if (confidence > 0)
				confidence--;
		}
		
		// then - redraw everything...
		// renderListData();
	}
	else
	{
		alert("NO VALUES");
	}
}


function onSegComboChange(value)
{
//	debugger

	if (value != "none")
	{	// value is the id of the segment want to add...
		
		setTabDirty();
		
		var segment = new Object();
	
		segment.id = value;
		
		for (var sd = 0; sd < segmentData.length; sd++)
		{	
			if (value == segmentData[sd].id)
			{
				segment.key = segmentData[sd].key;		//@BJN TEMP HACK alert...
				break;
			}
		}
		
		segment.name = this.displayedValue;
		segment.assets = new Array();

		listData.segments[listData.segments.length] = segment;
	}
	
	renderDetails();
}


function onModeComboChange(value)
{
//	debugger

	setTabDirty();

	listData.mode = value;
	renderDetails();
}

function onTypeComboChange(value)
{
//	debugger

	setTabDirty();

	listData.type = value;
	renderDetails();
}

function isRecommendationMode()
{
	return listData.mode == "Rec";
}

function isStaticType()
{
	return listData.type == "manual";
}

function isDynamicType()
{
	return listData.type == "element";
}

function isAssetType()
{
	return listData.type == "assetlocal";
}

function renderOption(combo, label, value, setting)
{
	var option = dojo.create("option", {value: value}, combo);
	option.innerHTML = label;
	if (setting == value)
		option.setAttribute("selected", "");
}

function renderModePicker()
{
	var modePickerDiv = dojo.byId("modePickerDiv");
	
	var widgets = dijit.findWidgets(modePickerDiv);
	dojo.forEach(widgets, function(w) {
	    w.destroyRecursive(true);
	});	
	
	modePickerDiv.innerHTML = "";

	var modeCombo = dojo.create("select", {}, modePickerDiv);

	renderOption ( modeCombo, '<xlat:stream key="dvin/AT/AdvCols/List"/>', "List", listData.mode);
	renderOption ( modeCombo, '<xlat:stream key="dvin/AT/AdvCols/Rec"/>', "Rec", listData.mode);

	modeCombo = new fw.dijit.UISimpleSelect ({}, modeCombo);
	modeCombo.connect(modeCombo, "onChange", onModeComboChange);
}

function renderTypePicker()
{
//	debugger
	
	var typePickerDiv = dojo.byId("typePickerDiv");
	
	var widgets = dijit.findWidgets(typePickerDiv);
	dojo.forEach(widgets, function(w) {
	    w.destroyRecursive(true);
	});	
	
	typePickerDiv.innerHTML = "";

	var typeCombo = dojo.create("select", {}, typePickerDiv);

	if (isRecommendationMode())
		renderOption ( typeCombo, '<xlat:stream key="dvin/AT/AdvCols/RelatedItems"/>', "assetlocal", listData.type);
	
	renderOption ( typeCombo, '<xlat:stream key="dvin/AT/AdvCols/StaticListsPlus"/>', "manual", listData.type);
	
	if (isRecommendationMode())
		renderOption ( typeCombo, '<xlat:stream key="dvin/AT/AdvCols/DynamicLists"/>', "element", listData.type);
	
	typeCombo = new fw.dijit.UISimpleSelect ({}, typeCombo);
	typeCombo.connect(typeCombo, "onChange", onTypeComboChange);
}

function renderSegmentPicker ()
{
	var segPickerDiv = dojo.byId("segPickerDiv");
	
	var widgets = dijit.findWidgets(segPickerDiv);
	dojo.forEach(widgets, function(w) {
	    w.destroyRecursive(true);
	});	
	
	segPickerDiv.innerHTML = "";

	dojo.style("segPickerDiv", "display", isRecommendationMode() && isStaticType() ? "block" : "none");

	if (isRecommendationMode())
	{		
		var segCombo = dojo.create("select", {}, segPickerDiv);
	
		renderOption ( segCombo, '<xlat:stream key="dvin/AT/AdvCols/SelectSegment"/>', "none", "");
		
		for (var sd = 0; sd < segmentData.length; sd++)
		{
			var bInclude = true;
			
			for (var seg = 0; seg < listData.segments.length; seg++)
			{
				if ( segmentData[sd].name == listData.segments[seg].name)
				{
					bInclude = false;
					break;
				}
			}
			
			if (bInclude) 
				renderOption ( segCombo, segmentData[sd].name, segmentData[sd].id, "");
		}
	
		segCombo = new fw.dijit.UISimpleSelect ({}, segCombo);
		segCombo.connect(segCombo, "onChange", onSegComboChange);
	}
}

function renderListData ()
{
	var listDataDiv = dojo.byId("listDataDiv");
	
	var widgets = dijit.findWidgets(listDataDiv);
	dojo.forEach(widgets, function(w) {
	    w.destroyRecursive(true);
	});	
	
	listDataDiv.innerHTML = "";

	var altText = '<xlat:stream key="dvin/AT/Common/Removefromlist"/>';
	var statusText = '<xlat:stream key="dvin/AT/Common/Removefromlist" escape="true"/>';
	
	if (isRecommendationMode())
	{	// Recommendation Mode
		
		if (isStaticType())
		{
			for (var seg = 0; seg < listData.segments.length; seg++)
			{
				var segDiv = dojo.create("div", {id: "seg_" + seg, class: "SEGMENT"}, listDataDiv);
				var segment = listData.segments[seg];
				
				var labelDiv = dojo.create("div", {}, segDiv);
		
				var a = dojo.create("a", {onclick: onRemoveSegment,
										  onmouseover: "window.status='" + statusText + "'; return true;",
										  onmouseout: "window.status=''; return true;",
										 }, labelDiv);
				
				dojo.create("img", { src: "<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconDeleteContent.gif",
							         title: altText, alt: altText, border: "0", hspace: "2" }, a);
				
				dojo.create("span", {}, labelDiv).innerHTML = segment.name;		
				
				var listDiv = dojo.create("div", {class: "ASSETLIST"}, segDiv);
			
				for (var att = 0; att < segment.assets.length; att++)
				{
					var assetDiv = dojo.create("div", {id: "att_" + att + "_" + seg, class: "ASSET"}, listDiv)
					renderAsset(assetDiv, segment.assets[att]);
				}
				
				var dropDiv = dojo.create("div", {id: "dropseg_" + seg}, segDiv);
				var dropWidget = new fw.ui.dijit.form.TypeAhead ( { accept: ['*'], cs_environment: 'ucform', isDropZone: true  }, dropDiv);
				dojo.connect(dropWidget, 'onChange', function() { dropSelect(this); });		
		
				dojo.publish("typeAhead/Ready", [dropWidget]);
				dojo.attr(dropWidget.domNode, "style", {display: "none"});
				dropWidget.startup();
			}
		
			var segDiv = dojo.create("div", {id: "seg_none", class: "SEGMENT"}, listDataDiv);
			
			var labelDiv = dojo.create("div", {}, segDiv);
			
			dojo.create("span", {}, labelDiv).innerHTML = '<xlat:stream key="dvin/AT/AdvCols/IfNoSegmentsApply"/>';	
			
			var listDiv = dojo.create("div", {class: "ASSETLIST"}, segDiv);
			
			for (var att = 0; att < listData.assets.length; att++)
			{
				var assetDiv = dojo.create("div", {id: "att_" + att, class: "ASSET"}, listDiv)
				renderAsset(assetDiv, listData.assets[att]);
			}
			
			var dropDiv = dojo.create("div", {id: "dropseg_"}, segDiv);
			var dropWidget = new fw.ui.dijit.form.TypeAhead ( { accept: ['*'], cs_environment: 'ucform', isDropZone: true  }, dropDiv);
			dojo.connect(dropWidget, 'onChange', function() { dropSelect(this); });		
		
			dojo.publish("typeAhead/Ready", [dropWidget]);
			dojo.attr(dropWidget.domNode, "style", {display: "none"});
			dropWidget.startup();
		}
		else
		if (isDynamicType())
		{
			var segDiv = dojo.create("div", {id: "seg_" + seg, class: "SEGMENT"}, listDataDiv);
			
			segDiv.innerHTML = "Dynamic List is not Implemented"
			
			//@BJN Dynamic Lists here...
			
			
			//@BJN Dynamic Lists here...
		}
		else
		if (isAssetType())
		{
			var segDiv = dojo.create("div", {id: "seg_" + seg, class: "SEGMENT"}, listDataDiv);
			
			segDiv.innerHTML = "Associated Assets requires no extra detail"
		}		
	}
	else
	{	// List Mode

//		debugger	
		
		var segDiv = dojo.create("div", {id: "seg_list", class: "SEGMENT"}, listDataDiv);
	
		var widVal = [];
		
		for (var att = 0; att < listData.assets.length; att++)
		{
			var asset = listData.assets[att];
			widVal.push(asset.type + ":" + asset.id + ":" + asset.name + ":");
		}
	
		var dropDiv = dojo.create("div", {id: "droplist_"}, segDiv);
		var dropWidget = new fw.ui.dijit.form.TypeAhead ( { accept: ['*'], 
															value: widVal,
															multiple: true,
															multiOrdered: true,
															displaySearchbox: true,
															cs_environment: 'ucform',
															isDropZone: true 															
														  }, dropDiv);
		
		
		dojo.connect(dropWidget, 'onChange', function() { listSelect(this); });		
	
		dojo.publish("typeAhead/Ready", [dropWidget]);
		dojo.attr(dropWidget.domNode, "style", {display: "none"});
		dropWidget.startup();
	}
}


function onOverrideComboChange(value)
{
	listData.options.ovrdable = value;	
}

function onMapStyleComboChange(value)
{
	listData.options.mapstyle = value;	
}

function onAssetTypesComboChange(value)
{
	if (value == "T")
	{
		listData.options.types.length = 0;
	}
	
	renderOptions();
}

function renderOptions ()
{
//	debugger
	
	var optionsDiv = dojo.byId("optionsDiv");
	
	var widgets = dijit.findWidgets(optionsDiv);
	dojo.forEach(widgets, function(w) {
	    w.destroyRecursive(true);
	});	
	
	optionsDiv.innerHTML = "";
	
	{
		var comboDiv = dojo.create("div", {}, optionsDiv);
		var combo = dojo.create("select", {}, comboDiv);
	
		renderOption ( combo, '<xlat:stream key="dvin/AT/AdvCols/AppliesToChildren"/>', "C", listData.options.mapstyle);
		renderOption ( combo, '<xlat:stream key="dvin/AT/AdvCols/DoesNotApplyToChildren"/>', "N", listData.options.mapstyle);
		
		combo = new fw.dijit.UISimpleSelect ({style: "width: 400px;"}, combo);
		combo.connect(combo, "onChange", onMapStyleComboChange);
	}

	{
		var comboDiv = dojo.create("div", {}, optionsDiv);
		var combo = dojo.create("select", {}, comboDiv);
		
		renderOption ( combo, '<xlat:stream key="dvin/AT/AdvCols/CanOverride"/>', "T", listData.options.ovrdable);
		renderOption ( combo, '<xlat:stream key="dvin/AT/AdvCols/CanNotOverride"/>', "F", listData.options.ovrdable);
		
		combo = new fw.dijit.UISimpleSelect ({}, combo);
		combo.connect(combo, "onChange", onOverrideComboChange);
	}	

	{
		var comboDiv = dojo.create("div", {}, optionsDiv);
		var combo = dojo.create("select", {}, comboDiv);
		
		var curSel = "F";
		
		if (listData.options.types.length == 0 || listData.options.types[0] == "_ALL_")
			curSel = "T";
		
		renderOption ( combo, '<xlat:stream key="dvin/AT/AdvCols/SelectAllAssetTypes"/>', "T", curSel);
		renderOption ( combo, '<xlat:stream key="dvin/AT/AdvCols/SelectAssetTypes"/>', "F", curSel);
		
		combo = new fw.dijit.UISimpleSelect ({}, combo);
		combo.connect(combo, "onChange", onAssetTypesComboChange);
		
		var assetTypesDiv = dojo.create("div", {class: "ASSETTYPELIST"}, optionsDiv);
		
		if (curSel == "F")
		{
			for (var i = 0; i < listData.options.types.length; i++)
			{
				dojo.create("div", {class: "ASSETTYPE"}, assetTypesDiv).innerHTML = listData.options.types[i];
			}
		}
	}
}

function onSelectionComboChange(value)
{
	listData.selection = value;	
}

function renderSelection ()
{
//	debugger
	
	var selectionDiv = dojo.byId("selectionDiv");
	
	var widgets = dijit.findWidgets(selectionDiv);
	dojo.forEach(widgets, function(w) {
	    w.destroyRecursive(true);
	});	
	
	selectionDiv.innerHTML = "";
	
	var combo = dojo.create("select", {}, selectionDiv);
	
	renderOption ( combo, 'First', "F", listData.selection);
	renderOption ( combo, '<xlat:stream key="dvin/AT/AdvCols/Highest"/>', "H", listData.selection);
	renderOption ( combo, '<xlat:stream key="dvin/AT/AdvCols/Random"/>', "R", listData.selection);
	
	combo = new fw.dijit.UISimpleSelect ({}, combo);
	combo.connect(combo, "onChange", onSelectionComboChange);
}


function onRemoveSortCriteria(evt)
{
//	debugger

	setTabDirty();

	var cell = evt.target;
	
	while (!cell.id)
		cell = cell.parentElement;
	
	var s = cell.id.split("_");
	var att = s[1];
	
	listData.sortorder.splice(att, 1);
	
	renderSortOrder();	
}

function renderSortCriteria(div, data)
{
	var altText = '<xlat:stream key="dvin/AT/Common/Removefromlist"/>';
	var statusText = '<xlat:stream key="dvin/AT/Common/Removefromlist" escape="true"/>';

	var a = dojo.create("a", {onclick: onRemoveSortCriteria,
							  onmouseover: "window.status='" + statusText + "'; return true;",
							  onmouseout: "window.status=''; return true;",
							 }, div);
	
	dojo.create("img", { src: "<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconDeleteContent.gif",
				         title: altText, alt: altText, border: "0", hspace: "2" }, a);
	
	dojo.create("span", {}, div).innerHTML = data.attributetypename + " | " + data.attributename + " | " + data.direction;
}

function onSortAssetComboChange(value)
{
//	debugger

	var attrCombo = dijit.byId("sort_attrs_combo");

	if (value != "none" && attrCombo)
	{
		
		var options = attrCombo.store.root;
		options.length = 1;

		for (var attr = 0; attr < sortAssetData[value].attributes.length; attr++)
		{
			options[options.length] = new Option(sortAssetData[value].attributes[attr], attr);
			// renderOption ( attrCombo, sortAssetData[value].attributes[attr], attr, "none");
			// attrCombo.addOption({label: sortAssetData[value].attributes[attr], value: attr});
		}
	}
}

function onAddSortCriteria(evt)
{
	var criteria = new Object();
	
	criteria.attributetypename = dijit.byId("sort_assets_combo").displayedValue;;
	criteria.attributename = dijit.byId("sort_attrs_combo").displayedValue;
	criteria.direction = dijit.byId("sort_dir_combo").value;

	listData.sortorder[listData.sortorder.length] = criteria;
	
	renderSortOrder();
}

function renderSortOrder()
{
//	debugger
	
	var sortorderDiv = dojo.byId("sortorderDiv");
	
	var widgets = dijit.findWidgets(sortorderDiv);
	dojo.forEach(widgets, function(w) {
	    w.destroyRecursive(true);
	});	
	
	sortorderDiv.innerHTML = "";
	
	// LH combo
	
	var addDiv =  dojo.create("div", {class: "ASSETLIST"}, sortorderDiv);
	
	var assetCombo = dojo.create("select", {id: "sort_assets_combo"}, addDiv);
	
	renderOption ( assetCombo, '&lt;<xlat:stream key="dvin/AT/Common/PickType"/>&gt;', "none", "none");

	for (var asset = 0; asset < sortAssetData.length; asset++)
	{
		renderOption ( assetCombo, sortAssetData[asset].desc, asset, "none");
	}

//	renderOption ( assetCombo, '<xlat:stream key="dvin/AT/Common/Special"/>', asset, "none");
	
	assetCombo = new fw.dijit.UISimpleSelect ({}, assetCombo);
	assetCombo.connect(assetCombo, "onChange", onSortAssetComboChange);
	
	// RH Combo
	var attrCombo = dojo.create("select", {id: "sort_attrs_combo"}, addDiv);
	renderOption ( attrCombo, '&lt;<xlat:stream key="dvin/AT/Flex/PickAttribute"/>&gt;', "none", "none");
	attrCombo = new fw.dijit.UISimpleSelect ({}, attrCombo);

	// also need radio buttons + "add" button HERE
	
	var dirCombo = dojo.create("select", {id: "sort_dir_combo"}, addDiv);
	renderOption ( dirCombo, '<xlat:stream key="dvin/AT/AdvCols/Ascending"/>', "ascending", "");
	renderOption ( dirCombo, '<xlat:stream key="dvin/AT/AdvCols/Descending"/>', "descending", "");
	dirCombo = new fw.dijit.UISimpleSelect ({}, dirCombo);

	var label = '<xlat:stream key="UI/Forms/AddSortCriteria"/>';
	var addButton = dojo.create("input", {type: "button", value: label}, addDiv);
	addButton = new fw.ui.dijit.Button ({title: label, label: label}, addButton);
	addButton.connect(addButton, "onClick", onAddSortCriteria);
	
	// now render the current list...

	var listDiv = dojo.create("div", {class: "ASSETLIST"}, sortorderDiv);
	
	for (var i = 0; i < listData.sortorder.length; i++)
	{
		var criteriaDiv = dojo.create("div", {id: "criteria_" + i, class: "ASSET"}, listDiv)
		renderSortCriteria(criteriaDiv, listData.sortorder[i]);
	}
}

function saveListData()
{
//	debugger	
	
	var listSaveDiv = dojo.byId("listSaveDiv");
	listSaveDiv.innerHTML = "";
	
	dojo.destroy (dojo.query("input[name=AdvColMode]")[0]);	
	dojo.create("input", {type: "hidden", name: "AdvColMode", value: listData.mode}, listSaveDiv);
	
	dojo.destroy (dojo.query("input[name=ACRule]")[0]);	
	dojo.create("input", {type: "hidden", name: "ACRule", value: listData.type}, listSaveDiv);

	// selection criteria	
	
	dojo.destroy (dojo.query("input[name=AdvCols:style]")[0]);	
	dojo.create("input", {type: "hidden", name: "AdvCols:style", value: listData.selection}, listSaveDiv);
	
	// options
	
	dojo.destroy (dojo.query("input[name=AdvCols:ovrdable]")[0]);	
	dojo.create("input", {type: "hidden", name: "AdvCols:ovrdable", value: listData.options.ovrdable}, listSaveDiv);

	dojo.destroy (dojo.query("input[name=AdvCols:mapstyle]")[0]);	
	dojo.create("input", {type: "hidden", name: "AdvCols:mapstyle", value: listData.options.mapstyle}, listSaveDiv);

	dojo.query("input[name^=AdvCols:types:]").forEach(dojo.destroy);
	
	if (listData.options.types.length == 0)
	{
		dojo.create("input", {type: "hidden", name: "AdvCols:types:Total", value: "1"}, listSaveDiv);
		dojo.create("input", {type: "hidden", name: "AdvCols:types:0", value: "_ALL_"}, listSaveDiv);
	}
	else
	{
		dojo.create("input", {type: "hidden", name: "AdvCols:types:Total", value: listData.options.types.length}, listSaveDiv);
		
		for (var t = 0; t < listData.options.types.length; t++)
		{
			dojo.create("input", {type: "hidden", name: "AdvCols:types:" + t, value: listData.options.types[t]}, listSaveDiv);
		}
	}
	
	// sortorder
	
	dojo.destroy (dojo.query("input[name=SortorderCount]")[0]);	
	dojo.create("input", {type: "hidden", name: "SortorderCount", value: listData.sortorder.length}, listSaveDiv);
	
	dojo.query("input[name^=AdvColsAttributeTypeName]").forEach(dojo.destroy);
	dojo.query("input[name^=AdvColsAttributeName]").forEach(dojo.destroy);
	dojo.query("input[name^=AdvColsDirection]").forEach(dojo.destroy);
	
	for (var s= 0; s < listData.sortorder.length; s++)
	{
		dojo.create("input", {type: "hidden", name: "AdvColsAttributeTypeName" + s, value: listData.sortorder[s].attributetypename}, listSaveDiv);
		dojo.create("input", {type: "hidden", name: "AdvColsAttributeName" + s, value: listData.sortorder[s].attributename}, listSaveDiv);
		dojo.create("input", {type: "hidden", name: "AdvColsDirection" + s, value: listData.sortorder[s].direction}, listSaveDiv);
	}
	
	// type specific data
	
	if (isStaticType())
	{
		var index = 0;
		
		if (isRecommendationMode())
		{
			for (var seg = 0; seg < listData.segments.length; seg++)
			{
				var segment = listData.segments[seg];
				
				dojo.create("input", {type: "hidden", name: "ManualRecSegmentKey" + (seg+1), value: segment.key}, listSaveDiv);
				
				for (var att = 0; att < segment.assets.length; att++)
				{
					var asset = segment.assets[att];
					
					dojo.create("input", {type: "hidden", name: "AdvColsManualRecsAssetType" + index, value: asset.type}, listSaveDiv);
					dojo.create("input", {type: "hidden", name: "AdvColsManualRecsAssetId" + index, value: asset.id}, listSaveDiv);
					dojo.create("input", {type: "hidden", name: "AdvColsManualRecsConfidence" + index, value: asset.confidence}, listSaveDiv);
					dojo.create("input", {type: "hidden", name: "AdvColsManualRecsBucket" + index, value: segment.key + "_IN"}, listSaveDiv);
		
					index++;
				}
			}
		}
		
		for (var att = 0; att < listData.assets.length; att++)
		{
			var asset = listData.assets[att];
			
			dojo.create("input", {type: "hidden", name: "AdvColsManualRecsAssetType" + index, value: asset.type}, listSaveDiv);
			dojo.create("input", {type: "hidden", name: "AdvColsManualRecsAssetId" + index, value: asset.id}, listSaveDiv);
			dojo.create("input", {type: "hidden", name: "AdvColsManualRecsConfidence" + index, value: asset.confidence}, listSaveDiv);
			dojo.create("input", {type: "hidden", name: "AdvColsManualRecsBucket" + index, value: ""}, listSaveDiv);
	
			index++;
		}
		
		dojo.create("input", {type: "hidden", name: "ManualrecsCount", value: index}, listSaveDiv);
		
		// rework the "used Segments" indicator
		var strPickedIdsOfSegments = "";
		var strPickedKeyOfSegments = "";
		var strPickedInsOfSegments = "";
		var strPickedOutsOfSegments = "";
	
		if (isRecommendationMode())
		{
			for (var seg = 0; seg < listData.segments.length; seg++)
			{
				var segment = listData.segments[seg];
				
				if (seg > 0)
				{
					strPickedIdsOfSegments += ",";
					strPickedKeyOfSegments += ",";
					strPickedInsOfSegments += ",";
					strPickedOutsOfSegments += ",";
				}
				
				strPickedIdsOfSegments += segment.id;
				strPickedKeyOfSegments += segment.key;
				strPickedInsOfSegments += segment.key + "_IN";
				strPickedOutsOfSegments += segment.key + "_OUT";
			}
		}
		
		dojo.query("input[name=PickedIdsOfSegments]")[0].value= strPickedIdsOfSegments;
		dojo.query("input[name=PickedKeyOfSegments]")[0].value= strPickedKeyOfSegments;
		dojo.query("input[name=PickedInsOfSegments]")[0].value= strPickedInsOfSegments;
		dojo.query("input[name=PickedOutsOfSegments]")[0].value= strPickedOutsOfSegments;
	}
}

function renderDetails()
{
	renderModePicker();
	renderTypePicker();
	renderSegmentPicker();
	renderListData();
}

function renderAll()
{
	renderOptions();
	renderSelection();
	renderSortOrder();
	renderDetails();
}

dojo.addOnLoad(renderAll);
</script>	

<tr><td colspan="6">
	<div id="modePickerDiv" class="LISTDATA">Mode Picker Goes Here!</div>
	<div id="typePickerDiv" class="LISTDATA">Type Picker Goes Here!</div>
	<div id="segPickerDiv" class="LISTDATA">Segment Picker Goes Here!</div>
	<div id="listDataDiv" class="LISTDATA">Rendered listData Goes Here!</div>
	<div style="display:none" id="listSaveDiv" class="LISTDATA">Saved listData Goes Here!</div>

	<div>
	@BJN Experiments <a href="javascript:saveListData()">Test 1</a> : 
	</div>		
</td></tr>


<!-- END - render JS/JSON data representing the segments and assets -->

</cs:ftcs>
