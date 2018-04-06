<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>

<cs:ftcs>

<!-- OpenMarket/Xcelerate/AssetType/AdvCols/ContentFormJavascript -->

<style type="text/css">
	@import url("js/fw/css/ui/Common.css");
	
	div.recDetail {
		padding: 5px;
		border-style: none;
		border-color: black;
		border-width: 1px;
	}
	
	div.recListData {
		padding: 5px;
		border-style: none;
		border-color: black;
		border-width: 1px;
	}
	
	div.recOptions {
		padding: 5px;
		border-style: none;
		border-color: black;
		border-width: 1px;
	}

	div.recSelection {
		padding: 5px;
		border-style: none;
		border-color: black;
		border-width: 1px;
	}
	
	div.recSortOrder {
		padding: 0px;
		border: none 0px;
	}
	
	div.recSortOrderAdder {
		padding: 5px;
		border: none, 0px;
	}
	
	.recSortOrderCombo {
		margin-top: 0px;
		margin-bottom: 0px;
		margin-left: 0px;
		margin-right: 12px;
		display: inline-block;
	}
	
	div.recSortOrderList {
		margin-top: 12px;
		margin-bottom: 12px;
		margin-left: 29px;
		margin-right: 0px;
		
		padding: 2px 6px;
	
		border: 1px solid #dedddd;
		background-color: #f3f3f3;
	}
	
	div.recSortOrderItem {
		margin-top: 4px;
		margin-bottom: 4px;
		margin-left: 0px;
		margin-right: 0px;

		padding-top: 0px;
		padding-bottom: 0px;
		padding-left: 3px;
		padding-right: 3px;
		
		background-color: white;	
	}
	
	div.recModePicker {
	}
	
	div.recTypePicker {
		padding: 5px;
		border-style: none;
		border-color: black;
		border-width: 1px;
	}
	
	div.recSegment {
		padding: 4px;
		margin-top: 12px;
		margin-bottom: 12px;
		margin-left: 0px;
		margin-right: 0px;
		
		border: 1px solid #dedddd;
		background-color: #f3f3f3;
		
		box-shadow: 1px 1px 0px 0px #dedddd;		
	}
	
	.recSegmentBody {
		margin-top: 8px;
		margin-bottom: 16px;
		margin-left: 24px;
		margin-right: 24px;

		background-color: #f3f3f3;		
	}
	
	div.recSegmentDrop {
		padding: 6px;
		margin-top: 8px;
		margin-bottom: 16px;
		margin-left: 120px;
		margin-right: 120px;
		
//		border: 1px solid #dedddd;
		border: 0px none;
		
		background-color: white;
	}
	
	div.recAssetTypeDisp {
		margin-top: 8px;	
		margin-left: 24px;
		margin-bottom: 8px;				
	}	
	
	div.recAssetTypeList {
		margin-top: 12px;
		margin-bottom: 12px;
		margin-left: 0px;
		margin-right: 0px;
		
		padding: 2px 6px;
	
		border: 1px solid #dedddd;
		background-color: #f3f3f3;
	} 

	div.recAssetType {
		margin-top: 4px;
		margin-bottom: 4px;
		margin-left: 0px;
		margin-right: 0px;

		padding-top: 0px;
		padding-bottom: 0px;
		padding-left: 3px;
		padding-right: 3px;
		
		background-color: white;				
	} 

	div.recAssetList {
		margin: 3px;
		padding: 0px;
		border: 0px none;
		background-color: #f3f3f3;		
	} 
	
	div.recAsset {
		margin-top: 4px;
		margin-bottom: 4px;
		margin-left: 0px;
		margin-right: 0px;

		padding-top: 0px;
		padding-bottom: 0px;
		padding-left: 3px;
		padding-right: 3px;
		
		background-color: white;				
	}

	.recAssetHeader {
		margin-top: -12px;
		margin-bottom: -4px;
		margin-left: 0px;
		margin-right: 0px;

		padding-top: 0px;
		padding-bottom: 0px;
		padding-left: 3px;
		padding-right: 3px;
		
		background-color: transparent;				
	}

	.recAssetHeaderRemove {
		display: inline-block;
		vertical-align: middle;		
		float: right;
	}

	.recAssetHeaderIn {
		margin-left: 0px;
		margin-right: 0px;
		width: 5em;
		font-weight: bold;		
		display: inline-block;
		cursor: pointer;
	}

	.recAssetHeaderOut {
		margin-left: 2px;
		margin-right: 28px;
		width: 5em;
		font-weight: bold;
		display: inline-block;
		cursor: pointer;
	}

	.recAssetIcon {
		margin-top: 0px;
		margin-bottom: 0px;
		margin-left: 5px;
		margin-right: 5px;
		display: inline-block;		
		vertical-align: middle;
	}
	
	.recAssetSeparator {
		width: 4px;
		height: 32px;
		margin-top: 0px;
		margin-bottom: 0px;
		margin-left: 3px;
		margin-right: 6px;
		display: inline-block;		
		vertical-align: top;		
		background-color: #f3f3f3;
	}
	
	.recAssetName {
		margin-top: 4px;
		margin-bottom: 4px;
		display: inline-block;
		vertical-align: middle;
		text-overflow: ellipsis;
	}
	
	.recAssetPercent {
		margin-top: 2px;
		margin-bottom: 4px;
		display: inline-block;
		vertical-align: middle;
		text-overflow: ellipsis;
	}

	.recSegmentHeader {
		margin-top: 4px;
		margin-bottom: 0px;
	}

	.recSegmentIcon {
		margin-left: 3px;
		margin-right: 6px;
		vertical-align: middle;
	}

	.recSegmentLabel {
		font-weight: bold;
		display: inline-block;
		vertical-align: middle;		
		text-overflow: ellipsis;	
	}
	
	.recNoSegmentLabel {
		margin-left: 11px;	
	}
	
	.recRemove {
		margin-top: 1px;
		height: 30px;	
		display: inline-block;
		vertical-align: middle;		
		float: right;
	}
	
	.recRemoveImage {
		vertical-align: middle;		
		margin-left: 16px;
		margin-right: 12px;
	}

	.recRemoveSegmentImage {
		vertical-align: middle;		
		margin-left: 0px;
		margin-right: 6px;
	}

	.recCheckLabel {
		margin-left: 8px;
	}	

	.recHidden {
		visibility: hidden;
	}

	.recSortColumn {
		padding-left: 2px;
		padding-right: 2px;
		vertical-align: middle;
		display: inline-block;
		text-overflow: ellipsis;
	}

	.fw .recComboTrik .UIComboBox .dijitInputInner { 
		width: 100% !important; 
	}
	
	.AdvForms .recSegment .defaultFormStyle {
		width: 	100% !important; 	
	}
	
	.AdvForms .recSegmentDrop .defaultFormStyle {
		width: 	100% !important; 	
	}
	
	.DropZone .DropOuter {
		height: auto;
	}

	.recAssetDrop {
		margin-top: 3px;
		margin-bottom: 3px;
		margin-left: 93px;
		margin-right: 93px;
		padding: 6px;
		
//		border: 1px solid green;
		border: 0px none;

		background-color: white;		
	} 
		
	.recSegmentDrop .DropZone .DropHand {
		display: none;
	}
	
	.recSegmentDrop .DropZone .DropText {
		display: inline-block;
//		vertical-align: middle;		
	}
		
	.recAssetDrop .DropZone .DropHand {
		display: none;
//		width: 64px;
//		vertical-align: middle;				
	}
	
	.recAssetDrop .DropZone .DropText {
		display: inline-block;
		vertical-align: middle;		
	}

	.clearfix:before, .clearfix:after { content: ""; display: table; }
	.clearfix:after { clear: both; }
	.clearfix { zoom: 1; }
		
</style>

<script type="text/javascript">

dojo.require("dojo.data.ItemFileReadStore");
dojo.require('dijit.form.CheckBox');

/*
function tidyWidgets(div)
{
	var widgets = dijit.findWidgets(div);
	dojo.forEach(widgets, function(w) {
	    w.destroyRecursive(true);
	});	
}
*/

function tidyWidgets(div)
{	
	// super-version to clean up asset lists too...
	var widgets = dijit.findWidgets(div);
	dojo.forEach(widgets, function(w) {
		if (w._source)
		{
			var nodes = dojo.query('div.dojoDndItem', div);
			if (nodes.length > 0)
			{
				for (var node=0; node < nodes.length; node++)
				{
					var dndNode = nodes[node];   
					fw.ui.dnd.util.destroyItem(w._source, dndNode);
					//clean up event hook for node being removed
					dojo.disconnect(w._source._removeConnects[dndNode.id]);
					delete w._source._removeConnects[dndNode.id];
				}
			}
		}
	    w.destroyRecursive(true);
	});	
}

function findActiveSegment(obj)
{
	var seg = {};	

	while (obj && !dojo.hasClass(obj, "recSegment"))
		obj = obj.parentElement;
	
	seg.segDiv = obj;

	var segs = dojo.query('.recSegment', 'listDataDiv' );
	
	for (var n = 0; n < segs.length; n++)
	{
		if (segs[n] === obj)
		{
			seg.seg = n;
			break;
		}
	}	
	
	return seg;
}

function findActiveAsset(obj)
{
	var att = {};	
	
	while (obj && !dojo.hasClass(obj, "recAsset"))
		obj = obj.parentElement;
	
	if (obj)
	{
		var seg = findActiveSegment(obj);

		att.attDiv = obj;
		att.segDiv = seg.segDiv;
		att.seg = seg.seg;
		
		var atts = dojo.query('.recAsset', seg.segDiv );
		
		for (var n = 0; n < atts.length; n++)
		{
			if (atts[n] === obj)
			{
				att.att = n;
				break;
			}
		}
	}
	
	return att;
}

function onRemoveAsset(evt)
{
	setTabDirty();

	var att = findActiveAsset(evt.target);
	var bEmpty = false;
	
	if (att.seg < listData.segments.length)
	{	// this is a "known segment" Asset
		listData.segments[att.seg].assets.splice(att.att, 1);
	
		bEmpty = (listData.segments[att.seg].assets.length == 0);
	}
	else
	{	// this is a "no segments apply" asset
		
		if (listData.assets.length == 0)
		{	// KLUDGE... assume called from a Dynamic type...
			listData.elementid = "";
			listData.elementname = "";
		}
		else			
			listData.assets.splice(att.att, 1);
	
		bEmpty = (listData.assets.length == 0);
	}

	if (bEmpty)
	{	// hide the header row...
		var seg = findActiveSegment(att.attDiv);
		var headers = dojo.query('.recAssetHeader', seg.segDiv);
		if (headers.length > 0)
			dojo.style (headers[0], "display", "none");
	}
	
	tidyWidgets(att.attDiv);
	dojo.destroy(att.attDiv);
}

function onRemoveSegment(evt)
{
	setTabDirty();
	
	var seg = findActiveSegment(evt.target);
	
	listData.segments.splice(seg.seg, 1);

	tidyWidgets(seg.segDiv);	
	dojo.destroy(seg.segDiv);
}

function onConfidenceValueChange(value)
{
	setTabDirty();

	this.assetData.confidence = value;
}

function renderInConfidenceTextbox(parentDiv, data, bShow)
{
	var value = data.confidence || "";

	if (bShow)	
	{
		textbox = new fw.dijit.UIInput ({value: value, regExp: '[0-9]{0,3}', maxLength: 3}).placeAt(parentDiv);
		dojo.create("span", {className: "recAssetPercent"}, parentDiv).innerHTML = "&nbsp;%&nbsp;&nbsp;";
	}
	else
	{
		textbox = new fw.dijit.UIInput ({value: value, regExp: '[0-9]{0,3}', maxLength: 3}).placeAt(parentDiv);
		dojo.addClass(textbox.domNode, 'recHidden');
		dojo.create("span", {className: "recAssetPercent recHidden"}, parentDiv).innerHTML = "&nbsp;%&nbsp;&nbsp;";
	}
	
	dojo.style(textbox.domNode, 'width', '3em');
		
	if (bShow)
	{
		textbox.assetData = data;
		textbox.connect(textbox, "onChange", onConfidenceValueChange);
	}
}

function onOutConfidenceValueChange(value)
{
	setTabDirty();

	this.assetData.outconfidence = value;
}

function renderOutConfidenceTextbox(parentDiv, data, bShow)
{
	var value = data.outconfidence || "";

	var textbox;
		
	if (bShow)	
	{
		textbox = new fw.dijit.UIInput ({value: value, regExp: '[0-9]{0,3}', maxLength: 3}).placeAt(parentDiv);
		dojo.create("span", {className: "recAssetPercent"}, parentDiv).innerHTML = "&nbsp;%";
	}
	else
	{
		textbox = new fw.dijit.UIInput ({value: value, regExp: '[0-9]{0,3}', maxLength: 3}).placeAt(parentDiv);
		dojo.addClass(textbox.domNode, 'recHidden');
		dojo.create("span", {className: "recAssetPercent recHidden"}, parentDiv).innerHTML = "&nbsp;%";
	}
	
	dojo.style(textbox.domNode, 'width', '3em');
		
	if (bShow)
	{
		textbox.assetData = data;
		textbox.connect(textbox, "onChange", onOutConfidenceValueChange);
	}
}

function renderRemoveItem(div, funcToRun)
{
	var altText = '<xlat:stream key="dvin/AT/Common/Removefromlist"  escape="true" encode="false"/>';
	var statusText = '<xlat:stream key="dvin/AT/Common/Removefromlist" escape="true" encode="false"/>';

	var rhs = dojo.create("div", {className: "recRemove"}, div);
	var a = dojo.create("a", {onclick: funcToRun,
							  onmouseover: "window.status='" + statusText + "'; return true;",
							  onmouseout: "window.status=''; return true;",
							 }, rhs);

	dojo.create("img", { className: "recRemoveImage", src: "js/fw/images/ui/ui/forms/deactive.png",
	    title: altText, alt: altText}, a);
}

function renderRemoveSegment(div, funcToRun)
{
	var altText = '<xlat:stream key="dvin/AT/Common/Removefromlist" escape="true" encode="false"/>';
	var statusText = '<xlat:stream key="dvin/AT/Common/Removefromlist" escape="true" encode="false"/>';

	var rhs = dojo.create("div", {className: "recRemove"}, div);
	var a = dojo.create("a", {onclick: funcToRun,
							  onmouseover: "window.status='" + statusText + "'; return true;",
							  onmouseout: "window.status=''; return true;",
							 }, rhs);
	
	dojo.create("img", { className: "recRemoveSegmentImage", src: "<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconDeleteContent.gif",
				         title: altText, alt: altText, border: "0", hspace: "2" }, a);
}

function renderAsset(div, data, bShowInConfidence, bShowOutConfidence)
{
	var altText = '<xlat:stream key="dvin/AT/Common/Removefromlist" escape="true" encode="false"/>';
	var statusText = '<xlat:stream key="dvin/AT/Common/Removefromlist" escape="true" encode="false"/>';

	// we do the RHS first and it will all be floated to the right 
	// (I think it makes wrapping better if that happens...)
	
	var rhs = dojo.create("div", {className: "recRemove"}, div);
	
	renderInConfidenceTextbox(rhs, data, bShowInConfidence);
	renderOutConfidenceTextbox(rhs, data, bShowOutConfidence);	
	
	var a = dojo.create("a", {onclick: onRemoveAsset,
							  onmouseover: "window.status='" + statusText + "'; return true;",
							  onmouseout: "window.status=''; return true;",
							 }, rhs);

	dojo.create("img", { className: "recRemoveImage", src: "js/fw/images/ui/ui/forms/deactive.png",
	    title: altText, alt: altText}, a);
	
	// now render the LHS of the line...
	
	var iconPath = data.icon ? data.icon : "Xcelerate/OMTree/TreeImages/AssetTypes/" + data.type + ".png";
	var iconAltText = "";
	
	dojo.create("img", { className: "recAssetIcon", src: iconPath, title: iconAltText, alt: iconAltText, border: "0px"}, div);
	dojo.create("span", {className: "recAssetSeparator"}, div).innerHTML = "&nbsp;";
	
	// dojo.create("span", {className: 'recAssetName'}, div).innerHTML = data.name;
	var s = dojo.create("span", {className: 'recAssetName'}, div);
	var altText = '<xlat:stream key="fatwire/Alloy/UI/EditAsset" escape="true" encode="false"/>';
	dojo.create("a", {href: "javascript:void(0)", title: altText, alt: altText, onclick: onEditAsset}, s).innerHTML = data.name;
}

function renderAssetType(div, data)
{
	var altText = '<xlat:stream key="dvin/AT/Common/Removefromlist" escape="true" encode="false"/>';
	var statusText = '<xlat:stream key="dvin/AT/Common/Removefromlist" escape="true" encode="false"/>';
	
	var rhs = dojo.create("div", {className: "recRemove"}, div);
	
	rhs.innerHTML="&nbsp;"

	var a = dojo.create("a", {onclick: onRemoveAssetType,
		  onmouseover: "window.status='" + statusText + "'; return true;",
		  onmouseout: "window.status=''; return true;",
		 }, rhs);

	dojo.create("img", { className: "recRemoveImage", src: "js/fw/images/ui/ui/forms/deactive.png",
					title: altText, alt: altText}, a);

	var iconPath = "Xcelerate/OMTree/TreeImages/AssetTypes/" + data.type + ".png";

	// look up the real icon
	
	for (var i = 0; i < assetTypeData.length; i++)
	{
		if (assetTypeData[i].type == data.type)
		{
			iconPath = assetTypeData[i].icon;
			break;
		}
	}
	
	var iconAltText = "";
	
	dojo.create("img", { className: "recAssetIcon", src: iconPath, title: iconAltText, alt: iconAltText, border: "0px"}, div);
	dojo.create("span", {className: "recAssetSeparator"}, div).innerHTML = "&nbsp;";
	dojo.create("span", {className: 'recAssetName'}, div).innerHTML = data.desc;			
}

function doDropElement(args)
{
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
		// var asset = {id: values[0][0], type: values[0][1], name: values[0][2], typedesc: values[0][1], confidence: "100"};
	
		listData.elementid = values[0][0];		// id
		listData.elementname = values[0][2];	// name
		
		// then - redraw everything...
		
		renderListData();
	}
}

function addAssetDynamic(seg, asset)
{
	if (seg.seg < listData.segments.length)
	{
		var segment = listData.segments[seg.seg];
		
		if (!segment.assets)
			segment.assets = new Array();
		
		segment.assets.length = 0;
		segment.assets[0] = asset;

		var listDiv = dojo.query('.recAssetList', seg.segDiv)[0];
		listDiv.innerHTML="";
		
		var assetDiv = dojo.create("div", {className: "recAsset"}, listDiv)
		renderAsset(assetDiv, asset);
	}
	else
	{
		if (!listData.assets)
			listData.assets = new Array();

		listData.assets.length = 0;
		listData.assets[0] = asset;
		
		var listDiv = dojo.query('.recAssetList', seg.segDiv)[0];
		listDiv.innerHTML="";
		
		var assetDiv = dojo.create("div", {className: "recAsset"}, listDiv)
		renderAsset(assetDiv, asset);
	}
}

function doDropDynamic(args)
{
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
		
		// add the data to the appropriate "list" object...
		var asset = {id: values[0][0], type: values[0][1], name: values[0][2], typedesc: values[0][1], confidence: "100"};
		var seg = findActiveSegment(args.domNode);
		
		addAssetDynamic(seg, asset);
	}
}

function addAssetStatic(seg, asset)
{
	if (!asset.icon)
	{	
		for (var i = 0; i < assetTypeData.length; i++)
		{
			if (assetTypeData[i].type == asset.type)
			{
				asset.icon = assetTypeData[i].icon;
				break;
			}
		}
	}	
	
	if (seg.seg < listData.segments.length)
	{
		var segment = listData.segments[seg.seg];
	
		if (!segment.assets)
			segment.assets = new Array();
	
		var att = 0;
		for (att= 0; att < segment.assets.length; att++)
		{
			if (asset.id == segment.assets[att].id)
				break;
		}
	
		if (att == segment.assets.length)
		{
			if (att == 0) // list was empty before we came in here...
				dojo.style (dojo.query('.recAssetHeader', seg.segDiv)[0], "display", "block");
			
			segment.assets[att] = asset;
	
			var listDiv = dojo.query('.recAssetList', seg.segDiv)[0];
			var assetDiv = dojo.create("div", {className: "recAsset"}, listDiv)
			renderAsset(assetDiv, asset, true, true);
		}
	}
	else
	{
		if (!listData.assets)
			listData.assets = new Array();
	
		var att = 0;
		for (att= 0; att < listData.assets.length; att++)
		{
			if (asset.id == listData.assets[att].id)
				break;
		}
	
		if (att == listData.assets.length)
		{			
			if (att == 0) // list was empty before we came in here...
				dojo.style (dojo.query('.recAssetHeader', seg.segDiv)[0], "display", "block");
			
			listData.assets[att] = asset;
			
			var listDiv = dojo.query('.recAssetList', seg.segDiv)[0];
			var assetDiv = dojo.create("div", {className: "recAsset"}, listDiv)
			renderAsset(assetDiv, asset, true, false);
		}
	}
}

function doDropStatic(args)
{
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
		var seg = findActiveSegment(args.domNode);

		addAssetStatic(seg, asset);
	}
}

function parseTreeAssetItem(str)
{
	var decodedString = unescape(str.replace(/\+/g, " ")); 
	var params = decodedString.split(',');
	var asset = {id: "", type: "", name: "", typedesc: "", confidence: "100"};
	
	for (var p = 0; p < params.length; p++)
	{
		var s = params[p].split("="); 
		
		if (s[0] == "id")
		{
			asset.id = s[1];
		}
		else if (s[0] == "assettype")
		{
			asset.type = s[1];
		}
		else if (s[0] == "assetsubtype")
		{
		asset.typedesc = s[1];
		}   	   				
		else if (s[0] == "assetname")
		{
			asset.name = s[1];
		}
	}
		
	return asset;		
}

function doAddStaticFromTree(evt)
{  
   	var encodedString = parent.frames["XcelTree"].document.TreeApplet.exportSelections()+'';
   	var assetArray = encodedString.split(':');
   	var assetcheck = unescape(assetArray[0]);	
   	if (assetcheck.indexOf('assettype=')!=-1 && assetcheck.indexOf('id=')!=-1)
   	{
    	setTabDirty();
    	var seg = findActiveSegment(evt.target);
   		
   		for (var i = 0; i < assetArray.length; i++)
   		{
   	    	if (assetArray[i] != "")
   	    	{
   	    		var asset = parseTreeAssetItem(assetArray[i]);
   	    		if (asset.id != "" && asset.type != "")
   	    		{
   	    			var widget = dijit.getEnclosingWidget(evt.target);
   	    			
   	    			if (widget)
   	    			{
   	    				if (widget.accept.length == 1 && widget.accept[0] == "*")
   	    				{
   	    					addAssetStatic(seg, asset);
   	    				}
   	    				else
   	    				{
							for (var a = 0; a < widget.accept.length; a++)
							{
								if (widget.accept[a] == asset.type)	
								{
		   	    					addAssetStatic(seg, asset);
		   	    					break;
								}
							}
   	    				}
   	    			}
   	    		}
   	    	}
   		}
	}
   	else
   	{
      	alert('<xlat:stream key="dvin/UI/PleaseSelectAssetFromTree" escape="true" encode="false"/>');
   	}
}

function doAddDynamicFromTree(evt)
{
   	var encodedString = parent.frames["XcelTree"].document.TreeApplet.exportSelections()+'';
   	var assetArray = encodedString.split(':');
   	var assetcheck = unescape(assetArray[0]);	
   	if (assetcheck.indexOf('assettype=')!=-1 && assetcheck.indexOf('id=')!=-1)
   	{
    	setTabDirty();
    	var seg = findActiveSegment(evt.target);
   		
    	if (assetArray.length == 2)	// we expect the last entry in the array to be empty	
   		{
   	    	if (assetArray[0] != "")
   	    	{
   	    		var asset = parseTreeAssetItem(assetArray[0]);
   	    		if (asset.id != "" && asset.type != "")
   	    		{
   	    			var widget = dijit.getEnclosingWidget(evt.target);
	    			
	    			if (widget)
	    			{
	    				if (widget.accept.length == 1 && widget.accept[0] == "*")
	    				{
	    					addAssetStatic(seg, asset);
	    				}
	    				else
	    				{
							for (var a = 0; a < widget.accept.length; a++)
							{
								if (widget.accept[a] == asset.type)	
								{
		   	    					addAssetDynamic(seg, asset);
		   	    					break;
								}
							}
	    				}
	    			}
	    		}
   	    	}
   		}
    	else 
    	{
   			alert('<xlat:stream key="dvin/UI/Error/Pleaseselect1assetfromthetree" escape="true" encode="false"/>');
    	}
	}
   	else
   	{
      	alert('<xlat:stream key="dvin/UI/PleaseSelectAssetFromTree" escape="true" encode="false"/>');
   	}
}

function doAddElementFromTree(evt)
{
   	var encodedString = parent.frames["XcelTree"].document.TreeApplet.exportSelections()+'';
   	var assetArray = encodedString.split(':');
   	var assetcheck = unescape(assetArray[0]);	
   	if (assetcheck.indexOf('assettype=')!=-1 && assetcheck.indexOf('id=')!=-1)
   	{
    	setTabDirty();
    	var seg = findActiveSegment(evt.target);
   		
    	if (assetArray.length == 2)	// note: we expect the last entry in the array to be empty	
   		{
   	    	if (assetArray[0] != "")
   	    	{
   	    		var asset = parseTreeAssetItem(assetArray[0]);
   	    		if (asset.id != "" && asset.type == "CSElement")
   	    		{
   	    			listData.elementid = asset.id;		// id
   	    			listData.elementname = asset.name;	// name
	    		}
   	    	}
   	    	
   	    	renderDetails();
   		}
    	else 
    	{
   			alert('<xlat:stream key="dvin/UI/Error/Pleaseselect1assetfromthetree" escape="true" encode="false"/>');
    	}
	}
   	else
   	{
      	alert('<xlat:stream key="dvin/UI/PleaseSelectAssetFromTree" escape="true" encode="false"/>');
   	}
}

function doAddSegmentFromTree(evt)
{
   	var encodedString = parent.frames["XcelTree"].document.TreeApplet.exportSelections()+'';
   	var assetArray = encodedString.split(':');
   	var assetcheck = unescape(assetArray[0]);	
   	if (assetcheck.indexOf('assettype=')!=-1 && assetcheck.indexOf('id=')!=-1)
   	{
    	setTabDirty();
    	var seg = findActiveSegment(evt.target);
   		
    	if (assetArray.length == 2)	// note: we expect the last entry in the array to be empty	
   		{
   	    	if (assetArray[0] != "")
   	    	{
   	    		var asset = parseTreeAssetItem(assetArray[0]);
   	    		if (asset.id != "" && asset.type == "Segments")
   	    		{
   	    			addSegment(asset);
   	    			
   	    			// then - redraw everything...
   	    			renderDetails();
   	    		}
   	    	}
   		}
    	else 
    	{
   			alert('<xlat:stream key="dvin/UI/Error/Pleaseselect1assetfromthetree" escape="true" encode="false"/>');
    	}
	}
   	else
   	{
      	alert('<xlat:stream key="dvin/UI/PleaseSelectAssetFromTree" escape="true" encode="false"/>');
   	}
}

function doAddListFromTree(evt)
{
   	var encodedString = parent.frames["XcelTree"].document.TreeApplet.exportSelections()+'';
   	var assetArray = encodedString.split(':');
   	var assetcheck = unescape(assetArray[0]);	
   	if (assetcheck.indexOf('assettype=')!=-1 && assetcheck.indexOf('id=')!=-1)
   	{
    	setTabDirty();

		if (!listData.assets)
			listData.assets = new Array();
		
		var values = listData.assets;
		var confidence = 100;

		if (values.length > 0)
		{
			confidence = values[values.length-1].confidence;

			if (confidence > 1)
				confidence--;
		}
		
   		for (var v = 0; v < assetArray.length; v++)
		{
   	    	if (assetArray[v] != "")
			{
				// add the data to the "assets" array...
	    		var asset = parseTreeAssetItem(assetArray[v]);
				
				// filter out duplicates
	    		var att = 0;
	    		for (att= 0; att < values.length; att++)
	    		{
	    			if (asset.id == values[att].id)
	    				break;
	    		}
	    		
	    		if (att == values.length)
					values.push({id: asset.id, type: asset.type, name: asset.name, typedesc: asset.type, confidence: confidence});
	    		
				if (confidence > 1)
					confidence--;
			}
		}
   		
   		renderListData();
   	}
   	else
   	{
      	alert('<xlat:stream key="dvin/UI/PleaseSelectAssetFromTree" escape="true" encode="false"/>');
   	}
}

function doDropList(args)
{
	var values = args.getAllDnDValues();
	
	setTabDirty();

	listData.assets = new Array();

	var confidence = 100;
	
	for (var v = 0; v < values.length; v++)
	{
		// add the data to the "assets" array...
		
		var type = values[v][1];
		
		if (dojo.isArray(type))
			type = type[0];
		
		var asset = {id: values[v][0], type: type, name: values[v][2], typedesc: values[v][1], confidence: confidence};
		
		listData.assets[listData.assets.length] = asset;
		
		if (confidence > 1)
			confidence--;
	}
}

function addSegment(asset)
{
	for (var seg = 0; seg < listData.segments.length; seg++)
	{
		if (asset.id == listData.segments[seg].id)
			break;	// we have already added this segment...
	}
	
	if (seg == listData.segments.length)	// new segment to add to the recommendation
	{	
		var segment = new Object();
	
		segment.id = asset.id;
		
		for (var sd = 0; sd < segmentData.length; sd++)
		{	
			if (segment.id == segmentData[sd].id)
			{
				segment.key = segmentData[sd].key;		// @BJN TEMP HACK alert...
				break;
			}
		}
		
		segment.name = asset.name;
		segment.assets = new Array();

		listData.segments[listData.segments.length] = segment;
	}		
}

function doDropSegment (args)
{
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

		addSegment(asset);
		
		// then - redraw everything...
		renderDetails();
	}
}

function onModeComboChange(value)
{
	if (value == listData.mode)
		return;

	setTabDirty();

	listData.mode = value;
	
	if (isRecommendationMode())
	{		
		listData.type = "manual";
	}
	else
	{	// go to "list" mode
		listData.segments.length = 0;
		
		if (listData.type == "dynamic")
			listData.assets.length = 0;
		
		listData.elementid = "";		
		listData.elementname = "";
		
		listData.type = "";
		
		listData.selection = "H";
		listData.sortorder = [{attributetypename:'SpStrH', attributename:'_CONFIDENCE_', direction:'descending'}];
	}
	
	renderSelection();
	renderSortOrder();
	renderDetails();
}

function onTypeComboChange(value)
{
	if (value == listData.type)
		return;

	setTabDirty();

	listData.type = value;
	
	// test the NEW and do any cleanup
	
	if (!isElementType())	 
	{
		listData.elementid = "";		
		listData.elementname = "";		
	}
	
//	if (!isStaticType())
//	{
		listData.segments.length = 0;
		listData.assets.length = 0;
//	}

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

function isElementType()
{
	return listData.type == "element";
}

function isAssetType()
{
	return listData.type == "assetlocal";
}

function isDynamicType()
{
	return listData.type == "dynamic";
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
	
	tidyWidgets(modePickerDiv);	
	
	modePickerDiv.innerHTML = "";

	var modeData = {identifier: "value", label: "label", 
			  items: [{value: "List", label: '<xlat:stream key="dvin/AT/AdvCols/List"  escape="true" encode="false"/>'},
			          {value: "Rec", label: '<xlat:stream key="dvin/AT/AdvCols/Rec"  escape="true" encode="false"/>'}  	        
			  ]};

	var modeStore = new dojo.data.ItemFileReadStore({data:dojo.clone(modeData)});
	var modeCombo = new fw.dijit.UISimpleSelect ({store: modeStore, searchAttr: "label", value: listData.mode}).placeAt(modePickerDiv);
	modeCombo.connect(modeCombo, "onChange", onModeComboChange);
}

function renderTypePicker()
{
	var typePickerDiv = dojo.byId("typePickerDiv");
	var typePickerLabel = dojo.byId("typePickerLabel");
	
	tidyWidgets(typePickerDiv);	
	
	typePickerDiv.innerHTML = "&nbsp;";

//	dojo.style('typePickerRow', "display", isRecommendationMode() ? "table-row" : "none");
	
	if (isRecommendationMode())
	{
		typePickerLabel.innerHTML='<xlat:stream key="dvin/AT/AdvCols/Type" escape="true" encode="false"/>:';		
		typePickerDiv.innerHTML = "";

		dojo.addClass(typePickerDiv, 'recTypePicker');
		
		var typeData = {identifier: "value", label: "label", 
				  items: [{value: "manual", label: '<xlat:stream key="dvin/AT/AdvCols/StaticListsPlus" escape="true" encode="false" />'},
				          {value: "dynamic", label: '<xlat:stream key="dvin/AT/AdvCols/DynamicListsPlus" escape="true" encode="false" />'},  	        
				          {value: "element", label: '<xlat:stream key="dvin/AT/AdvCols/DynamicLists" escape="true" encode="false" />'},  	        
				          {value: "assetlocal", label: '<xlat:stream key="dvin/AT/AdvCols/RelatedItems" escape="true" encode="false" />'}  	        
				  ]};

		var typeStore = new dojo.data.ItemFileReadStore({data:dojo.clone(typeData)});
		var typeCombo = new fw.dijit.UISimpleSelect ({store: typeStore, searchAttr: "label", value: listData.type, 
														className: "recComboTrik", style: "width: 300px;"}).placeAt(typePickerDiv);
		typeCombo.connect(typeCombo, "onChange", onTypeComboChange);
	}
	else
	{
		typePickerLabel.innerHTML='<xlat:stream key="dvin/AT/AdvCols/Mode" escape="true" encode="false"/>:';
		
		dojo.removeClass(typePickerDiv, "recTypePicker");
		typePickerDiv.innerHTML = '<xlat:stream key="dvin/AT/AdvCols/List" escape="true" encode="false"/>';
	}
}

function renderStaticBody(segDiv, assets, acceptList, bShowInConfidence, bShowOutConfidence)
{
	var bodyDiv = dojo.query('.recSegmentBody', segDiv)[0];
	
	tidyWidgets(bodyDiv);	
	
	bodyDiv.innerHTML = "";	

	var listDiv = dojo.create("div", {className: "recAssetList"}, bodyDiv);
	
	var headerDiv = dojo.create("div", {className: "recAssetHeader clearfix"}, listDiv)
	
	// we do the RHS first and it will all be floated to the right 
	// (I think it makes wrapping better if that happens...)
	
	var rhs = dojo.create("div", {className: "recAssetHeaderRemove"}, headerDiv);
	
	if (bShowInConfidence)
	{
		var altText = bShowOutConfidence ? '<xlat:stream key="dvin/AT/AdvCols/InSegmentConfidence" escape="true" encode="false"/>'
										 : '<xlat:stream key="dvin/AT/AdvCols/Confidence" escape="true" encode="false"/>';
			
		dojo.create("div", {title: altText, className: "recAssetHeaderIn"}, rhs).innerHTML = '<xlat:stream key="dvin/AT/AdvCols/InHeader" escape="true" encode="false"/>';
	}
	else
		dojo.create("div", {className: "recAssetHeaderIn recHidden"}, rhs).innerHTML = '<xlat:stream key="dvin/AT/AdvCols/InHeader" escape="true" encode="false"/>';
	
	if (bShowOutConfidence)
	{	
		var altText = '<xlat:stream key="dvin/AT/AdvCols/OutOfSegmentConfidence"/>';
		dojo.create("div", {title: altText, className: "recAssetHeaderOut"}, rhs).innerHTML = '<xlat:stream key="dvin/AT/AdvCols/OutHeader" escape="true" encode="false"/>';
	}
	else
		dojo.create("div", {className: "recAssetHeaderOut recHidden"}, rhs).innerHTML = '<xlat:stream key="dvin/AT/AdvCols/OutHeader" escape="true" encode="false"/>';

	if (assets.length == 0)
		dojo.style(headerDiv, "display", "none");
		
	for (var att = 0; att < assets.length; att++)
	{
		var assetDiv = dojo.create("div", {className: "recAsset clearfix"}, listDiv)
		renderAsset(assetDiv, assets[att], bShowInConfidence, bShowOutConfidence);
	}

	var dropFrame = dojo.create("div", {className: "recAssetDrop"}, bodyDiv);
	var dropDiv = dojo.create("div", {}, dropFrame);

	if (isContributorMode)
	{
		var dropWidget = new fw.ui.dijit.form.TypeAhead ( { accept: acceptList, cs_environment: '<%=ics.GetVar("cs_environment")%>', 
															isDropZone: true,
															multiple: true,
															maxVals: 1
														  }, dropDiv);
		
		dojo.connect(dropWidget, 'onChange', function() { doDropStatic(this); });		
		
		dojo.publish("typeAhead/Ready", [dropWidget]);
		dojo.attr(dropWidget.domNode, "style", {display: "none"});
		dropWidget.startup();
		
		dojo.query(".DropText", bodyDiv)[0].innerHTML='<xlat:stream key="dvin/AT/AdvCols/AssetDropZone" escape="true" encode="false" />';
	}
	else
	{
		var label = '<xlat:stream key="dvin/AT/AdvCols/AddSelectedItems" escape="true" encode="false"/>';

		var addButton = dojo.create("input", {type: "button", value: label}, dropDiv);
		addButton = new fw.ui.dijit.Button ({title: label, label: label, accept: acceptList}, addButton);
		addButton.connect(addButton, "onClick", doAddStaticFromTree);
		
//		var labelSpan = dojo.create("span", {}, dropDiv);
//		labelSpan.innerHTML = "Hello World...."; //@BJN!!!!
		
		var hintDiv = dojo.create("div", {}, dropDiv);
		hintDiv.innerHTML= '<xlat:stream key="dvin/AT/AdvCols/HintSelectedItemsFromTree" escape="true" encode="false"/>';
	}
}

function renderDynamicBody(segDiv, assets, dropList)
{
	var bodyDiv = dojo.query('.recSegmentBody', segDiv)[0];
	
	tidyWidgets(bodyDiv);	
	
	bodyDiv.innerHTML = "";	
	
	var listDiv = dojo.create("div", {className: "recAssetList"}, bodyDiv);
	
	for (var att = 0; att < assets.length; att++)
	{
		var assetDiv = dojo.create("div", {className: "recAsset clearfix"}, listDiv)
		renderAsset(assetDiv, assets[att], false, false);
	}

	var dropFrame = dojo.create("div", {className: "recAssetDrop"}, bodyDiv);
	var dropDiv = dojo.create("div", {}, dropFrame);
	
	if (isContributorMode)
	{
		var dropWidget = new fw.ui.dijit.form.TypeAhead ( { accept: dropList, cs_environment: '<%=ics.GetVar("cs_environment")%>', isDropZone: true  }, dropDiv);
		dojo.connect(dropWidget, 'onChange', function() { doDropDynamic(this); });		
	
		dojo.publish("typeAhead/Ready", [dropWidget]);
		dojo.attr(dropWidget.domNode, "style", {display: "none"});
		dropWidget.startup();
		
		dojo.query(".DropText", bodyDiv)[0].innerHTML='<xlat:stream key="dvin/AT/AdvCols/AssetDropZone" escape="true" encode="false" />';
	}
	else
	{
		var label = '<xlat:stream key="dvin/AT/AdvCols/UpdateSelectedItem" escape="true" encode="false"/>';

		var addButton = dojo.create("input", {type: "button", value: label}, dropDiv);
		addButton = new fw.ui.dijit.Button ({title: label, label: label, accept: dropList}, addButton);
		addButton.connect(addButton, "onClick", doAddDynamicFromTree);
		
		var hintDiv = dojo.create("div", {}, dropDiv);
		hintDiv.innerHTML= '<xlat:stream key="dvin/AT/AdvCols/HintSelectedItemFromTree" escape="true" encode="false"/>';
	}
}

function buildAcceptList ()
{
	var acceptList = [];

	if (listData.options.types.length == 0 || (listData.options.types.length == 1 && listData.options.types[0].type == "_ALL_"))
	{
		acceptList[0] = "*";
	}
	else
	{
		for (var i = 0; i < listData.options.types.length; i++)
		{
			acceptList[i] = listData.options.types[i].type;
		}
	}
	return acceptList;
}

function onEditAsset(evt)
{
	var att = findActiveAsset(evt.target);
	var item = {data: {type: [""], id: ""}};
	
	if (att.seg < listData.segments.length)
	{	// this is a "known segment" Asset
		item.data.id = listData.segments[att.seg].assets[att.att].id;
		item.data.type[0] = listData.segments[att.seg].assets[att.att].type;
	}
	else
	{	// this is a "no segments apply" asset
		
		if (listData.assets.length == 0)
		{	// KLUDGE... assume called from a Dynamic type...
			item.data.id = listData.elementid;
			item.data.type[0] = "CSElement";
		}
		else
		{
			item.data.id = listData.assets[att.att].id;
			item.data.type[0] = listData.assets[att.att].type;
		}
	} 

	doEditAssetItem(item);
}

function doEditAssetItem(item)
{
	var urlBase = '<%=ics.GetVar("editBaseURL")%>';
	if (item.data.id) {
		var urlEdit = urlBase+"&AssetType="+item.data.type[0]+"&id="+item.data.id;
		<% if("ucform".equals(ics.GetVar("cs_environment"))) {%>
			var id = item.data.id, 
				type = dojo.isArray(item.data.type) ? item.data.type[0] : item.data.type;
			SitesApp.event(SitesApp.id("asset", type+":"+id), 'edit');
		<%} else { %>
			editwindow = window.open(urlEdit, "_blank");
		<% } %>
	}
	else
	{
		alert('<xlat:stream key="dvin/UI/AssetMgt/NoAssetSpecified" escape="true" encode="false"/>');
	}	
}

function renderListData ()
{
	var listDataDiv = dojo.byId("listDataDiv");
	
	tidyWidgets(listDataDiv);		
	
	listDataDiv.innerHTML = "";

	var acceptList = buildAcceptList();
	
	if (isRecommendationMode())
	{	// Recommendation Mode
		
		if (isStaticType())
		{
			for (var seg = 0; seg < listData.segments.length; seg++)
			{
				var segment = listData.segments[seg];
				
				var segDiv = dojo.create("div", {className: "recSegment"}, listDataDiv);
				
				var headerDiv = dojo.create("div", {className: "recSegmentHeader clearfix"}, segDiv);
				renderRemoveSegment(headerDiv, onRemoveSegment);
				
				var altText = "";				
				dojo.create("img", { className: "recSegmentIcon", src: "Xcelerate/OMTree/TreeImages/AssetTypes/Segments.png",
										title: altText, alt: altText, border: "0px"}, headerDiv);
				
				dojo.create("div", {className: "recSegmentLabel"}, headerDiv).innerHTML = segment.name;
				
				dojo.create("div", {className: "recSegmentBody"}, segDiv);
				renderStaticBody(segDiv, segment.assets, acceptList, true, true);
			}

			renderSegmentDropZone(listDataDiv);				

			var segDiv = dojo.create("div", {className: "recSegment clearfix"}, listDataDiv);
			var headerDiv = dojo.create("div", {className: "recSegmentHeader clearfix"}, segDiv);
			dojo.create("div", {className: "recSegmentLabel recNoSegmentLabel"}, headerDiv).innerHTML = '<xlat:stream key="dvin/AT/AdvCols/IfNoSegmentsApply" escape="true" encode="false"/>';	
			dojo.create("div", {className: "recSegmentBody"}, segDiv);
			
			renderStaticBody(segDiv, listData.assets, acceptList, true, false);
		}
		else
		if (isElementType())
		{
			var segDiv = dojo.create("div", {className: "recSegment"}, listDataDiv);
			var headerDiv = dojo.create("div", {className: "recSegmentHeader clearfix"}, segDiv);
			dojo.create("div", {className: "recSegmentLabel"}, headerDiv).innerHTML = "&nbsp";
			
			var bodyDiv = dojo.create("div", {className: "recSegmentBody"}, segDiv);
			var listDiv = dojo.create("div", {className: "recAssetList"}, bodyDiv);
			var assetDiv = dojo.create("div", {className: "recAsset"}, listDiv)
			
			if (listData.elementid)
			{
				var asset = {id: listData.elementid, name: listData.elementname || "", type: "CSElement"};
				renderAsset(assetDiv, asset);
			}

			var dropFrame = dojo.create("div", {className: "recAssetDrop"}, bodyDiv);
			var dropDiv = dojo.create("div", {}, dropFrame);
			
			if (isContributorMode)
			{
				var dropWidget = new fw.ui.dijit.form.TypeAhead ( { accept: ['CSElement'], cs_environment: '<%=ics.GetVar("cs_environment")%>', isDropZone: true  }, dropDiv);
				dojo.connect(dropWidget, 'onChange', function() { doDropElement(this); });		
//				dojo.connect(dropWidget, 'onEdit',  function(item) { doEditAssetItem(item); });
			
				dojo.publish("typeAhead/Ready", [dropWidget]);
				dojo.attr(dropWidget.domNode, "style", {display: "none"});
				dropWidget.startup();
				
				dojo.query(".DropText", bodyDiv)[0].innerHTML='<xlat:stream key="dvin/AT/AdvCols/AssetDropZone" escape="true" encode="false" />';
			}
			else
			{
				var label = '<xlat:stream key="UI/Forms/UpdateSelectedElement" escape="true" encode="false"/>';

				var addButton = dojo.create("input", {type: "button", value: label}, dropDiv);
				addButton = new fw.ui.dijit.Button ({title: label, label: label}, addButton);
				addButton.connect(addButton, "onClick", doAddElementFromTree);
				
				var hintDiv = dojo.create("div", {}, dropDiv);
				hintDiv.innerHTML= '<xlat:stream key="dvin/AT/AdvCols/HintUpdateElementFromTree" escape="true" encode="false"/>';
			}				
		}
		else
		if (isAssetType())
		{
			var segDiv = dojo.create("div", {className: "recSegment"}, listDataDiv);
			
			segDiv.innerHTML = '<xlat:stream key="dvin/AT/AdvCols/RelatedItemsNote" escape="true" encode="false"/>';
		}
		else
		if (isDynamicType())
		{
			var dropList = ["ContentQuery", "CSElement"];
			
			for (var seg = 0; seg < listData.segments.length; seg++)
			{
				var segment = listData.segments[seg];
				
				var segDiv = dojo.create("div", {className: "recSegment"}, listDataDiv);
				
				var headerDiv = dojo.create("div", {className: "recSegmentHeader clearfix"}, segDiv);
				renderRemoveSegment(headerDiv, onRemoveSegment);
				
				var altText = "";				
				dojo.create("img", { className: "recSegmentIcon", src: "Xcelerate/OMTree/TreeImages/AssetTypes/Segments.png", 
					title: altText, alt: altText, border: "0px"}, headerDiv);
				
				dojo.create("div", {className: "recSegmentLabel"}, headerDiv).innerHTML = segment.name;
				
				dojo.create("div", {className: "recSegmentBody"}, segDiv);
				renderDynamicBody(segDiv, segment.assets, dropList);
			}

			renderSegmentDropZone(listDataDiv);				
			
			var segDiv = dojo.create("div", {className: "recSegment clearfix"}, listDataDiv);
			var headerDiv = dojo.create("div", {className: "recSegmentHeader clearfix"}, segDiv);
			dojo.create("div", {className: "recSegmentLabel recNoSegmentLabel"}, headerDiv).innerHTML = '<xlat:stream key="dvin/AT/AdvCols/IfNoSegmentsApply" escape="true" encode="false"/>';	
			dojo.create("div", {className: "recSegmentBody"}, segDiv);
			
			renderDynamicBody(segDiv, listData.assets, dropList);
		}
	}
	else
	{	// List Mode
		
		var segDiv = dojo.create("div", {className: "recSegment"}, listDataDiv);
		dojo.style(segDiv, "marginRight", "120px");
	
		var widVal = [];
	
		for (var att = 0; att < listData.assets.length; att++)
		{
			var asset = listData.assets[att];
			// "type:id:name:subtype:confidence"
			widVal.push(asset.type + ":" + asset.id + ":" + asset.name + "::" + asset.confidence);
		}

		var dropFrame = dojo.create("div", {className: "segDropFrame"}, segDiv);
		var dropDiv = dojo.create("div", {}, dropFrame);
		
		if (isContributorMode || listData.assets.length > 0)
		{
			var dropWidget = new fw.ui.dijit.form.TypeAhead ( { accept: acceptList, 
																value: widVal,
																multiple: true,
																multiOrdered: true,
																displaySearchbox: false,
																cs_environment: '<%=ics.GetVar("cs_environment")%>',
																isDropZone: true 										
																// @BJN Experiments
																// , displayElementName: 'UI/Engage/RecStaticAsset'	
																// , confidence: true
															  }, dropDiv);
		
			dojo.publish("typeAhead/Ready", [dropWidget]);
			dojo.attr(dropWidget.domNode, "style", {display: "none"});
			dropWidget.startup();
			dojo.connect(dropWidget, 'onChange', function() { doDropList(this); });		
			dojo.connect(dropWidget, 'onEdit',  function(item) { doEditAssetItem(item); });
		}
		
		if (!isContributorMode)
		{
			var treeDiv = dojo.create("div", {}, dropFrame);
			
			var label = '<xlat:stream key="dvin/AT/AdvCols/AddSelectedItems" escape="true" encode="false"/>';

			var addButton = dojo.create("input", {type: "button", value: label}, treeDiv);
			addButton = new fw.ui.dijit.Button ({title: label, label: label, accept: acceptList}, addButton);
			addButton.connect(addButton, "onClick", doAddListFromTree);
			
			var hintDiv = dojo.create("div", {}, treeDiv);
			hintDiv.innerHTML= '<xlat:stream key="dvin/AT/AdvCols/HintSelectedItemsFromTree" escape="true" encode="false"/>';
		}
	}
}

function renderSegmentDropZone(parentDiv)
{
	var dropFrame = dojo.create("div", {className: "recSegmentDrop"}, parentDiv);
	
	var dropDiv = dojo.create("div", {}, dropFrame);
	
	if (isContributorMode)
	{
		var dropWidget = new fw.ui.dijit.form.TypeAhead ( 
				{ accept: ['Segments'], 
				  cs_environment: '<%=ics.GetVar("cs_environment")%>', 
				  isDropZone: true,
				  multiple: true,
				  maxVals: 1
				}, dropDiv);
	
		dojo.connect(dropWidget, 'onChange', function() { doDropSegment(this); });		
	
		dojo.publish("typeAhead/Ready", [dropWidget]);
		dojo.attr(dropWidget.domNode, "style", {display: "none"});
		dropWidget.startup();
		
		dojo.query(".DropText", dropFrame)[0].innerHTML='<xlat:stream key="dvin/AT/AdvCols/SegmentDropZone" escape="true" encode="false" />';
	}
	else
	{
		var label = '<xlat:stream key="dvin/AT/AdvCols/AddSelectedSegment" escape="true" encode="false"/>';

		var addButton = dojo.create("input", {type: "button", value: label}, dropDiv);
		addButton = new fw.ui.dijit.Button ({title: label, label: label}, addButton);
		addButton.connect(addButton, "onClick", doAddSegmentFromTree);
		
		var hintDiv = dojo.create("div", {}, dropDiv);
		hintDiv.innerHTML= '<xlat:stream key="dvin/AT/AdvCols/HintSelectedSegmentFromTree" escape="true" encode="false"/>';
	}
}

function onOverrideClick(value)
{
	setTabDirty();
	
	if (value)
		listData.options.ovrdable = "T";
	else
		listData.options.ovrdable = "F";
}

function onMapStyleClick(value)
{
	setTabDirty();
	
	if (value)
		listData.options.mapstyle = "C";
	else
		listData.options.mapstyle = "N";
}

function onRemoveAssetType(evt)
{
	setTabDirty();

	var cell = evt.target;
	
	while (!cell.id)
		cell = cell.parentElement;
	
	var s = cell.id.split("_");
	var att = s[1];
	
	listData.options.types.splice(att, 1);
		
	renderListData();		// needed to refresh "accept" for the drop zones
	renderOptions();	
}

function onAssetTypesClick(value)
{
	setTabDirty();
	
	if (value)
	{
		listData.options.types.length = 1;
		listData.options.types[0] = {type:"_ALL_", desc: "" };
	}
	else
	{
		listData.options.types.length = 0;
	}
	
	renderListData();		// needed to refresh "accept" for the drop zones
	renderOptions();
}

function onAssetTypePickerChange(value)
{
	if (value == "none")
		return;

	setTabDirty();
	
	listData.options.types[listData.options.types.length] = {type: value, desc: this.displayedValue};

	renderListData();	
	renderOptions();
}

function renderOptions ()
{
	var optionsDiv = dojo.byId("optionsDiv");
	
	tidyWidgets(optionsDiv);		
	
	optionsDiv.innerHTML = "";

	{
		var rowDiv = dojo.create("div", {}, optionsDiv);	
		
		var checkbox = new dijit.form.CheckBox({
			checked: (listData.options.mapstyle == "C")
		}).placeAt(rowDiv);
		
		dojo.connect(checkbox, "onChange", onMapStyleClick);

		var label = dojo.create("label", {className: "recCheckLabel"}, rowDiv);
		label.innerHTML = '<xlat:stream key="dvin/AT/AdvCols/AppliesToChildren" escape="true" encode="false" />';
	}

	{
		var rowDiv = dojo.create("div", {}, optionsDiv);
		var checkbox = new dijit.form.CheckBox({
			checked: (listData.options.ovrdable == "T")
		}).placeAt(rowDiv);

		dojo.connect(checkbox, "onChange", onOverrideClick);

		var label = dojo.create("label", {className: "recCheckLabel"}, rowDiv);
		label.innerHTML = '<xlat:stream key="dvin/AT/AdvCols/CanOverride" escape="true" encode="false" />';
	}	

	{
		var rowDiv = dojo.create("div", {}, optionsDiv);	
		
		var curSel = "F";
		
		if (listData.options.types.length == 1 && listData.options.types[0].type == "_ALL_")
			curSel = "T";

		var checkbox = new dijit.form.CheckBox({
			checked: (curSel == "T") 
		}).placeAt(rowDiv);
		
		dojo.connect(checkbox, "onChange", onAssetTypesClick );
		
		var label = dojo.create("label", {className: "recCheckLabel"}, rowDiv);
		label.innerHTML = '<xlat:stream key="dvin/AT/AdvCols/SelectAllAssetTypes" escape="true" encode="false" />';
		
		if (curSel == "F")
		{		
			var assetListDiv = dojo.create("div", {className: "recAssetTypeDisp"}, optionsDiv);

			var pickerData = {identifier: "value", label: "label", items: []};
			
			pickerData.items.push( {value: 'none', label: '<<xlat:stream key="dvin/AT/Common/PickType" escape="true" encode="false"/>>'} );
			
			for (var i = 0; i < assetTypeData.length; i++)
			{
				var bInclude = true;
				
				for (var j = 0; j < listData.options.types.length; j++)
				{
					if ( assetTypeData[i].type == listData.options.types[j].type)
					{
						bInclude = false;
						break;
					}
				}
				
				if (bInclude)
					pickerData.items.push( {value: assetTypeData[i].type, label: assetTypeData[i].desc} );
			}

			var pickerStore = new dojo.data.ItemFileReadStore({data:dojo.clone(pickerData)});
			var picker = new fw.dijit.UISimpleSelect ({store: pickerStore, searchAttr: "label", value: "none",
														className: "recComboTrik", style: "width: 300px;"}).placeAt(assetListDiv);
			
			picker.connect(picker, "onChange", onAssetTypePickerChange);
			
			// ===============================================================================================

			if (listData.options.types.length > 0)
			{
				var assetTypesDiv = dojo.create("div", {className: "recAssetTypeList"}, assetListDiv);
				
				for (var i = 0; i < listData.options.types.length; i++)
				{
					var assetTypeDiv = dojo.create("div", {id: "atttype_" + i, className: "recAssetType"}, assetTypesDiv)
					renderAssetType(assetTypeDiv, listData.options.types[i]);
				}
			}
		}
	}
}

function onSelectionComboChange(value)
{
	setTabDirty();

	listData.selection = value;	
}

function renderSelection ()
{
	var selectionDiv = dojo.byId("selectionDiv");
	
	tidyWidgets(selectionDiv);		
	
	selectionDiv.innerHTML = "";
	
	dojo.style('selectionRow', "display", isRecommendationMode() ? "table-row" : "none");
	
	if (isRecommendationMode())
	{
		var comboDiv = dojo.create("div", {}, selectionDiv);
		var comboData = {identifier: "value", label: "label", 
				  items: [ // {value: "", label: 'First'},
				          {value: "H", label: '<xlat:stream key="dvin/AT/AdvCols/Highest" escape="true" encode="false"/>'},
				          {value: "R", label: '<xlat:stream key="dvin/AT/AdvCols/Random" escape="true" encode="false"/>'}  	        
				  ]};
	
		var comboStore = new dojo.data.ItemFileReadStore({data:dojo.clone(comboData)});
		var combo = new fw.dijit.UISimpleSelect ({store: comboStore, searchAttr: "label", value: listData.selection}).placeAt(selectionDiv);
		
		combo.connect(combo, "onChange", onSelectionComboChange);
	}
}

function onRemoveSortCriteria(evt)
{
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
	var altText = '<xlat:stream key="dvin/AT/Common/Removefromlist" escape="true" encode="false"/>';
	var statusText = '<xlat:stream key="dvin/AT/Common/Removefromlist" escape="true" encode="false"/>';
	
	var rhs = dojo.create("div", {className: "recRemove"}, div);
	
	rhs.innerHTML="&nbsp;"
	
	var a = dojo.create("a", {onclick: onRemoveSortCriteria,
		  onmouseover: "window.status='" + statusText + "'; return true;",
		  onmouseout: "window.status=''; return true;",
		 }, rhs);

	dojo.create("img", { className: "recRemoveImage", src: "js/fw/images/ui/ui/forms/deactive.png",
					title: altText, alt: altText}, a);

	
	var typeStr = data.attributetypename;
	
	if (typeStr == 'SpStrH')
		typeStr = '<xlat:stream key="dvin/AT/Common/Special" escape="true" encode="false"/>';
		
	var dirStr = data.direction == 'descending' ? '<xlat:stream key="dvin/AT/AdvCols/Descending" escape="true" encode="false"/>'
												: '<xlat:stream key="dvin/AT/AdvCols/Ascending" escape="true" encode="false"/>';
	
	dojo.create("div", {className: "recSortColumn", style: {width: "30%", nowrap: true}}, div).innerHTML = typeStr;
	dojo.create("div", {className: "recSortColumn", style: {width: "35%", nowrap: true}}, div).innerHTML = data.attributename;
	dojo.create("div", {className: "recSortColumn", style: {width: "15%", nowrap: true}}, div).innerHTML = dirStr;
}

function onSortAssetComboChange(value)
{
	var attrCombo = dijit.byId("sort_attrs_combo");

	if (value != "none" && attrCombo)
	{
		var options = attrCombo.store.root;
		options.length = 1;

		for (var attr = 0; attr < sortAssetData[value].attributes.length; attr++)
		{
			options[options.length] = new Option(sortAssetData[value].attributes[attr], attr);
		}
	}
}

function onAddSortCriteria(evt)
{
	if (dijit.byId("sort_assets_combo").value != "none" && dijit.byId("sort_attrs_combo").value != "none")
	{		
		setTabDirty();
		
		var criteria = new Object();
		
		var typeIndex = dijit.byId("sort_assets_combo").value;
		criteria.attributetypename = sortAssetData[typeIndex].name;
		criteria.attributename = dijit.byId("sort_attrs_combo").displayedValue;
		criteria.direction = dijit.byId("sort_dir_combo").value;
	
		listData.sortorder[listData.sortorder.length] = criteria;
		renderSortOrder();
	}
}

function renderSortOrder()
{
	var sortorderDiv = dojo.byId("sortorderDiv");
	
	tidyWidgets(sortorderDiv);		
	
	sortorderDiv.innerHTML = "";
	
	dojo.style('sortorderRow', "display", isRecommendationMode() ? "table-row" : "none");
	
	if (isRecommendationMode())
	{	
		// LH combo
		
		var addDiv =  dojo.create("div", {className: "recSortOrderAdder"}, sortorderDiv);

		var div1 =  dojo.create("div", {className: "recSortOrderCombo"}, addDiv);
		var assetCombo = dojo.create("select", {id: "sort_assets_combo"}, div1);
		
		renderOption ( assetCombo, '&lt;<xlat:stream key="dvin/AT/Common/PickType" escape="true" encode="false"/>&gt;', "none", "none");
	
		for (var asset = 0; asset < sortAssetData.length; asset++)
		{
			renderOption ( assetCombo, sortAssetData[asset].desc, asset, "none");
		}
		
		assetCombo = new fw.dijit.UISimpleSelect ({}, assetCombo);
		assetCombo.connect(assetCombo, "onChange", onSortAssetComboChange);
		
		// RH Combo
		var div2 =  dojo.create("div", {className: "recSortOrderCombo"}, addDiv);
		var attrCombo = dojo.create("select", {id: "sort_attrs_combo"}, div2);
		renderOption ( attrCombo, '&lt;<xlat:stream key="dvin/AT/Flex/PickAttribute" escape="true" encode="false"/>&gt;', "none", "none");
		attrCombo = new fw.dijit.UISimpleSelect ({}, attrCombo);
	
		// also need radio buttons + "add" button HERE
		var div3 =  dojo.create("div", {className: "recSortOrderCombo"}, addDiv);
		var dirCombo = dojo.create("select", {id: "sort_dir_combo"}, div3);
		renderOption ( dirCombo, '<xlat:stream key="dvin/AT/AdvCols/Ascending" escape="true" encode="false"/>', "ascending", "");
		renderOption ( dirCombo, '<xlat:stream key="dvin/AT/AdvCols/Descending" escape="true" encode="false"/>', "descending", "");
		dirCombo = new fw.dijit.UISimpleSelect ({className: "recComboTrik", style: "width: 10em;"}, dirCombo);
	
		addDiv =  dojo.create("div", {className: "recSortOrderAdder"}, sortorderDiv);
		
		var label = '<xlat:stream key="UI/Forms/AddSortCriteria" escape="true" encode="false"/>';
		var addButton = dojo.create("input", {type: "button", value: label}, addDiv);
		addButton = new fw.ui.dijit.Button ({title: label, label: label}, addButton);
		addButton.connect(addButton, "onClick", onAddSortCriteria);
		
		// now render the current list...
		
		if (listData.sortorder.length > 0)
		{	
			var listDiv = dojo.create("div", {className: "recSortOrderList"}, sortorderDiv);
			
			for (var i = 0; i < listData.sortorder.length; i++)
			{
				var criteriaDiv = dojo.create("div", {id: "criteria_" + i, className: "recSortOrderItem clearfix"}, listDiv)
				renderSortCriteria(criteriaDiv, listData.sortorder[i]);
			}
		}
	}
}

function saveListData()
{
	var listSaveDiv = dojo.byId("listSaveDiv");
	listSaveDiv.innerHTML = "";
	
	dojo.destroy (dojo.query("input[name=AdvColMode]")[0]);	
	dojo.create("input", {type: "hidden", name: "AdvColMode", value: listData.mode}, listSaveDiv);
	
	dojo.destroy (dojo.query("input[name=ACRule]")[0]);	
	dojo.create("input", {type: "hidden", name: "ACRule", value: listData.type}, listSaveDiv);
	
	// dynamic list CSElement
	
	dojo.destroy (dojo.query("input[name=AdvCols:elementid]")[0]);	
	dojo.create("input", {type: "hidden", name: "AdvCols:elementid", value: listData.elementid}, listSaveDiv);
	
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
			dojo.create("input", {type: "hidden", name: "AdvCols:types:" + t, value: listData.options.types[t].type}, listSaveDiv);
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
	
	if (isStaticType() || isDynamicType() || !isRecommendationMode())	// anything with one or more lists oa assets
	{
		var index = 0;
		
		if (isRecommendationMode())	// possible multiple lists 
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

					if (asset.outconfidence && asset.outconfidence != "")
					{
						dojo.create("input", {type: "hidden", name: "AdvColsManualRecsAssetType" + index, value: asset.type}, listSaveDiv);
						dojo.create("input", {type: "hidden", name: "AdvColsManualRecsAssetId" + index, value: asset.id}, listSaveDiv);
						dojo.create("input", {type: "hidden", name: "AdvColsManualRecsConfidence" + index, value: asset.outconfidence}, listSaveDiv);
						dojo.create("input", {type: "hidden", name: "AdvColsManualRecsBucket" + index, value: segment.key + "_OUT"}, listSaveDiv);
						
						index++;
					}
				}
			}
		}
		
		// the "list mode" list - or the "no segments apply" list
		
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
	renderListData();
}

dojo.declare('AdvColsDetailTrik', null, {
	
	constructor: function () {
		
	},
	
	renderAll: function() {	
		renderOptions();
		renderSelection();
		renderSortOrder();
		renderDetails();
	}
});

function bootstrap()
{
	new AdvColsDetailTrik().renderAll();
}

dojo.addOnLoad(bootstrap);

</script>	

</cs:ftcs>
