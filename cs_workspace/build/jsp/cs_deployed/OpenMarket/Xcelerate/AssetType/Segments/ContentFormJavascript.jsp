<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ page import="com.openmarket.xcelerate.util.ConverterUtils" %>

<cs:ftcs>

<!-- OpenMarket/Xcelerate/AssetType/Segments/ContentFormJavascript -->

<link href="js/fw/css/ui/Common.css" rel="stylesheet" type="text/css">
<link href="js/fw/css/UISegments.css" rel="stylesheet" type="text/css">
<link href="js/fw/css/UISlideWizard.css" rel="stylesheet" type="text/css">
<style type="text/css">
	.clearfix:before, .clearfix:after { content: ""; display: table; }
	.clearfix:after { clear: both; }
	.clearfix { zoom: 1; }
</style>
	
<script type="text/javascript">

dojo.require("dojo.data.ItemFileReadStore");
dojo.require('dijit.form.CheckBox');
dojo.require('fw.ui.dijit.SlideWizard');

function segToolsToggle()
{
	var link = dojo.byId("segToolsToggle");
	var divs = dojo.query(".segAdder", 'ruleSetDiv');
	var isOn = dojo.hasClass(link, 'segToolsOn');

	for (var d = 0; d < divs.length; d++) 
		dojo.style(divs[d], "display", isOn ? "none" : "block"); 
	
	link.innerHTML = isOn ? '<xlat:stream key="dvin/AT/Segments/ShowTools" escape="true" encode="false" />' 
			              : '<xlat:stream key="dvin/AT/Segments/HideTools" escape="true" encode="false" />';

	dojo.toggleClass(link, "segToolsOn");
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

function onTextValueChange(value)
{
	setTabDirty();
	
	var cell = findActiveCell(this.domNode);
	var data = nvRuleSet.rows[cell.row].cols[cell.col]; 
	data.VALUE = value;
}

function onTextHighValueChange(value)
{
	setTabDirty();

	var cell = findActiveCell(this.domNode);
	var data = nvRuleSet.rows[cell.row].cols[cell.col]; 
	data.HIGHVALUE = value;
}

function onDateValueChange(value)
{
	setTabDirty();

	var cell = findActiveCell(this.domNode);
	var data = nvRuleSet.rows[cell.row].cols[cell.col]; 
	
	if (value != "")
	{
		var dateFormatPattern = '<%=ConverterUtils.getDateFormatPattern(ics.GetSSVar("locale"))%>'; 
		var newDate = dojo.date.locale.parse(value, {selector: 'date', datePattern: dateFormatPattern });
		value = newDate.getTime().toString();
	}	
		
	data.VALUE = value;
	data.VALUETZ = "";
}

function onDateHighValueChange(value)
{
	setTabDirty();

	var cell = findActiveCell(this.domNode);
	var data = nvRuleSet.rows[cell.row].cols[cell.col]; 

	if (value != "")
	{
		var dateFormatPattern = '<%=ConverterUtils.getDateFormatPattern(ics.GetSSVar("locale"))%>'; 
		var newDate = dojo.date.locale.parse(value, {selector: 'date', datePattern: dateFormatPattern });
		value = newDate.getTime().toString(); 
	}
	
	data.HIGHVALUE = value;
	data.HIGHVALTZ = "";
}

function onDateStartChange(value)
{
	setTabDirty();

	var cell = findActiveCell(this.domNode);
	var data = nvRuleSet.rows[cell.row].cols[cell.col]; 

	if (value != "")
	{
		var dateFormatPattern = '<%=ConverterUtils.getDateFormatPattern(ics.GetSSVar("locale"))%>'; 
		var newDate = dojo.date.locale.parse(value, {selector: 'date', datePattern: dateFormatPattern });
		value = newDate.getTime().toString();
	}
	
	data.HSTARTDATE = value;
	data.HSTARTTZ = "";
}

function onDateEndChange(value)
{
	setTabDirty();

	var cell = findActiveCell(this.domNode);
	var data = nvRuleSet.rows[cell.row].cols[cell.col]; 
	
	if (value != "")
	{
		var dateFormatPattern = '<%=ConverterUtils.getDateFormatPattern(ics.GetSSVar("locale"))%>'; 
		var newDate = dojo.date.locale.parse(value, {selector: 'date', datePattern: dateFormatPattern });
		value = newDate.getTime().toString();
	}
	
	data.HENDDATE = value;
	data.HENDTZ = "";
}

function onEnumComboChange(value)
{
	setTabDirty();

	var cell = findActiveCell(this.domNode);
	var data = nvRuleSet.rows[cell.row].cols[cell.col]; 
	data.VALUE = value;	
}

function onEnumComboHighValueChange(value)
{
	setTabDirty();

	var cell = findActiveCell(this.domNode);
	var data = nvRuleSet.rows[cell.row].cols[cell.col]; 
	data.HIGHVALUE = value;	
}

function onOpCheckClick(value)
{
	setTabDirty();

	var cell = findActiveCell(this.domNode);
	var data = nvRuleSet.rows[cell.row].cols[cell.col]; 
	data.RULEOP = value ? 'exclude' : 'include';	
}

function onBooleanComboChange(value)
{
	setTabDirty();

	var cell = findActiveCell(this.domNode);
	var data = nvRuleSet.rows[cell.row].cols[cell.col]; 
	data.VALUE = value;	
	
	renderCellBody(cell.cellDiv, data);	
}

function getNewDate()
{
	var newDate = new Date();
	
	newDate.setHours(0);
	newDate.setMinutes(0);
	newDate.setSeconds(0);

	return newDate.getTime().toString();	
}


function onCompOpComboChange(value)
{
	setTabDirty();

	var cell = findActiveCell(this.domNode);
	
	var data = nvRuleSet.rows[cell.row].cols[cell.col];
	
	if (data.COMPAREOP == "bt")
	{	// clear out old 
		data.HIGHVALUE="";
		data.HIGHVALTZ="";
	}		
	
	data.COMPAREOP = value;	

	if (value == "bt")
	{	// initialise new 
		data.HIGHVALUE="";
		data.HIGHVALTZ="";
		
		if (data.RULETYPE == "scalar")
		{
			findCatAndAtt(data);

			if (data.attIndex != -1)
			{
				if (visitorData.categories[data.catIndex].attributes[data.attIndex].type == "timestamp")
				{
					var newDate = getNewDate();
					data.HIGHVALUE=newDate;
				}
			}			
		}
	}		
	
	renderCellBody(cell.cellDiv, data);	
}

function onAssetOpComboChange(value)
{
	setTabDirty();

	var cell = findActiveCell(this.domNode);
	var data = nvRuleSet.rows[cell.row].cols[cell.col]; 
	data.ASSETOP = value;	
	
	renderCellBody(cell.cellDiv, data);	
}

function onModeComboChange(value)
{
	setTabDirty();

	var cell = findActiveCell(this.domNode);
	var data = nvRuleSet.rows[cell.row].cols[cell.col]; 
	data.CARTMODE = value;	
	
	if (data.CARTMODE == "all")
	{
		data.assets = new Array();
	}
	
	renderCellBody(cell.cellDiv, data);	
}

function onHistoryOpComboChange(value)
{
	setTabDirty();

	var cell = findActiveCell(this.domNode);
	var data = nvRuleSet.rows[cell.row].cols[cell.col]; 
	data.HOP = value;	
	
	if (value == "first" || value == "last")
	{		
		var newDate = getNewDate();
		
		data.VALUE=newDate;
		data.VALUETZ="";
		data.HIGHVALUE=newDate;
		data.HIGHVALTZ="";
		
	}
	else
	{
		data.VALUE="";
		data.VALUETZ="";
		data.HIGHVALUE="";
		data.HIGHVALTZ="";
	}
	
	renderCellBody(cell.cellDiv, data);	
}

function onHistoryDateOpComboChange(value)
{
	setTabDirty();

	var cell = findActiveCell(this.domNode);
	var data = nvRuleSet.rows[cell.row].cols[cell.col]; 
	
	data.HDATEOP = value;	
	
	data.HINTERVAL="";		
	data.HRELTYPE="";		
	data.HSTARTDATE="0";
	data.HSTARTTZ="";
	data.HENDDATE="";
	data.HENDTZ="";
	
	if (value == "relative")
	{
		data.HINTERVAL="";		
		data.HRELTYPE="hours";		
	}
	
	if (value == "fixed")
	{
		var newDate = getNewDate();
		
		data.HSTARTDATE=newDate;
		data.HENDDATE=newDate;
	}
	
	renderCellBody(cell.cellDiv, data);	
}

function onSumFieldsComboChange(value)
{
	setTabDirty();

	var cell = findActiveCell(this.domNode);
	var data = nvRuleSet.rows[cell.row].cols[cell.col]; 
	data.HFIELD = value;	
	
	renderCellBody(cell.cellDiv, data);	
}


function onHistoryRelOpComboChange(value)
{
	setTabDirty();

	var cell = findActiveCell(this.domNode);
	var data = nvRuleSet.rows[cell.row].cols[cell.col]; 
	data.HRELTYPE = value;	
	
	renderCellBody(cell.cellDiv, data);	
}

function onTextIntervalChange(value)
{
	setTabDirty();

	var cell = findActiveCell(this.domNode);
	var data = nvRuleSet.rows[cell.row].cols[cell.col]; 
	data.HINTERVAL = value;
}

function onTextHistoryConstraintValueChange(value)
{
	setTabDirty();

	this.historyConstraintValue.value = value;
}

function onHistoryConstraintValueComboChange(value)
{
	setTabDirty();

	this.historyConstraintValue.value = this.displayedValue;	
}

function onHistoryConstraintClick (value)
{
	var cell = findActiveCell(this.domNode);
	var field = this.field;
	var data = nvRuleSet.rows[cell.row].cols[cell.col];
	var fields = historyData.categories[data.catIndex].attributes[data.attIndex].fields;

	if (this.checked)
	{
		// add a new value to data.constraints
		// but check in case it's already there - cuz I am getting spurious-looking click events firing!!
		
		for (var index = 0; index < data.constraints.length; index++)
		{
			if (data.constraints[index].name == fields[field].name)
				break;
		}

		if (index == data.constraints.length)	
		{
			setTabDirty();

			var constraint = new Object();

			constraint.name = fields[field].name;
			constraint.values = new Array();
			constraint.type = fields[field].constraint.htype;
			
			if (fields[field].constraint.htype == "assetattr")
			{
				constraint.assettype = fields[field].constraint.assettype;
				constraint.assetattribute = fields[field].constraint.assetattribute;				
			}

			if (fields[field].constraint.htype == "value")
				constraint.values[0] = {value: fields[field].defaultvalue, valtz: "0"};
			
			data.constraints[data.constraints.length] = constraint;
		}
	}
	else
	{
		setTabDirty();

		// remove a value from data.constraints
		for (var index = 0; index < data.constraints.length; index++)
		{
			if (data.constraints[index].name == fields[field].name)
			{
				// nuke the data constraints object and break...				
				data.constraints.splice(index, 1);
				break;		
			}
		}
	}
	
	var myFunc = function() {renderHistoryConstraint(cell.cellDiv, field, data);}
	setTimeout(myFunc, 100);
}

function createScalarData()
{
	var data = new Object();
	
	data.RULETYPE = "scalar";
	data.RULEOP = "include";
	
	data.RULECATEGORY = "";	
	data.VARNAME = "";
	data.VARDESC = "";
	
	data.COMPAREOP = "==";
	data.VALUE = "";
	
	return data;
}

function createHistoryData()
{
	var data = new Object();
	
	data.RULETYPE = "history";
	data.RULEOP = "include";

	data.RULECATEGORY = "";	
	data.VARNAME = "";
	data.VARDESC = "";
	
	data.HOP="";
	data.HFIELD="";
	data.COMPAREOP = "=="
	data.VALUE = "";

	data.HDATEOP="none";	
	data.HSTARTDATE="0";

	data.constraints = new Array();
	
	return data;
}

function createCartData()
{
	var data = new Object();
	
	data.RULETYPE = "cart";
	data.RULEOP = "include";
	
	data.COMPAREOP = "=="
	data.VALUE = "";
	
	data.ASSETOP = 'value';
	data.CARTMODE = "all";
	
	return data;	
}

function createDummyData()
{
	var data = new Object();
	
	data.RULETYPE = "dummy";
	data.RULEOP = "include";

	data.VARNAME = "";

	data.COMPAREOP = "==";
	data.VALUE = "";
	
	return data;
}

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

function destroyDiv(div)
{
	tidyWidgets(div)
	dojo.destroy(div);
}

function removeDummyCell()
{
	var divs = dojo.query(".segCellDummy", 'ruleSetDiv');
	
	if (divs.length > 0)
	{
		var row = findActiveRow(divs[0]);

		if (nvRuleSet.rows[row.row].cols.length == 0)
			removeRow(row);
		else
			destroyDiv(divs[0]);
	}
}

function onAddDummyCell(evt)
{
	var row = findActiveRow(evt.target);
	
	addDummyCell(row);
}

function addDummyCell(row)
{
	var divs = dojo.query(".segCellDummy", 'ruleSetDiv');
	if (divs.length > 0)
	{
		var dummyRow = findActiveRow(divs[0]);
		if (row.row == dummyRow.row)
			return;	// this row already has a dummy cell established
			
		removeDummyCell();
	}
	
	var data = createDummyData();

	// we do not add this to the real data yet - only to the DOM...
	
	var adder = dojo.query(".segCellAdder", row.rowDiv)[0];
	var cellDiv = dojo.create("div", {className: "segCell segCellDummy"}, adder, "before");
	renderCell(cellDiv, data);

	// set focus to the picker
	var cell = findActiveCell(dojo.query(".segCellDummy", 'ruleSetDiv')[0]);
	setFocus(cell.row, cell.col, ".segAttPicker");
}

function onAddRow(evt)
{
//	var row = findActiveRow(evt.target);
//	doAddRow(row);

	doAddRow ();
}

function doAddRow(/*row*/)
{
	setTabDirty();

//	row = row || {row: -1};
//	var nRow = row.row + 1; 
	var nRow = nvRuleSet.rows.length;
	
	var newRow = new Object();
	newRow.cols = new Array();

	var rows = nvRuleSet.rows;
	rows.splice(nRow, 0, newRow);
	
//	var newRowDiv = row.rowDiv ? dojo.create("div", {className: "segRow"}, row.rowDiv, "after")
//			                : dojo.create("div", {className: "segRow"}, 'ruleSetDiv');
	
	var adder = dojo.query(".segRowAdder", 'ruleSetDiv')[0];
	var newRowDiv = dojo.create("div", {className: "segRow"}, adder, "before")
	
	renderRow(newRowDiv);

	addDummyCell({row: nRow, rowDiv: newRowDiv});
}

function onRemoveAsset(evt)
{	// used for both Cart and History

	setTabDirty();

	var cell = findActiveCell(evt.target);

	var div = evt.target;
	
	while (!div.id)
		div = div.parentElement;
	
	var s = div.id.split("_");
	var row = s[1];
	var col = s[2];

	var data = nvRuleSet.rows[cell.row].cols[cell.col];
	
	if (s.length == 4)
	{	// this is a Cart asset
		var asset = s[3];
		var assets = data.assets;
		
		if (assets)
			assets.splice(asset, 1);
		
		renderCellBody(cell.cellDiv, data);	
	}
	else	
	if (s.length == 5)
	{	// this is a History Constraint Asset
		var constraint = s[3]; 
		var asset = s[4];
		var values = data.constraints[constraint].values;

		if (values)
			values.splice(asset, 1);
		
		renderCellBody(cell.cellDiv, data);	
	}
}

function renderOpCheck(parentDiv, data)
{
	var bChecked = (data.RULEOP == "exclude");
	
	if (isEditMode)
	{	
		var checkbox = new dijit.form.CheckBox({className: 'segExcludeBox', checked: bChecked, name: "foo"}).placeAt(parentDiv);
		dojo.connect(checkbox, "onChange", onOpCheckClick);
		
		var altText = '<xlat:stream key="dvin/AT/Segments/Excludecriterion" escape="true" encode="false" />';	
		var label = dojo.create("label", {title: altText, className: 'segExcludeBoxLabel'}, parentDiv);
		label.innerHTML = '<xlat:stream key="dvin/AT/Segments/Exclude" escape="true" encode="false" />';
		dojo.attr(label, "for", "foo");
	}
	else
	{
		var label = dojo.create("label", {className: 'segExcludeBoxLabel'}, parentDiv);
		label.innerHTML = bChecked ? '<xlat:stream key="dvin/AT/Segments/Exclude" escape="true" encode="false" />' 
								   : '<xlat:stream key="dvin/AT/Segments/Include" escape="true" encode="false" />';
	}
}

function renderCompOpCombo(parentDiv, data, type)
{
	parentDiv = dojo.create("div", {className: "segFieldDiv"}, parentDiv);

	var compOpData = 
	{
		identifier: "value",
		label: "label",
		items: 
		[
			{value: '==', label: '<xlat:stream key="dvin/AT/Common/isequalto" escape="true" encode="false" />'},
			{value: '!=', label: '<xlat:stream key="dvin/AT/Common/isnotequalto" escape="true" encode="false" />'},
			{value:  '>', label: '<xlat:stream key="dvin/AT/Common/isgreaterthan" escape="true" encode="false" />'},
			{value:  '>=', label: '<xlat:stream key="dvin/AT/Common/isgreaterorequalto" escape="true" encode="false" />'},
			{value:  '<', label: '<xlat:stream key="dvin/AT/Common/islessthen" escape="true" encode="false" />'},
			{value:  '<=', label: '<xlat:stream key="dvin/AT/Common/islessorequalto" escape="true" encode="false" />'},
			{value:  'bt', label: '<xlat:stream key="dvin/AT/Common/isbetween" escape="true" encode="false" />'},
		]
	};

	if (type == "boolean")
	{
		compOpData = 
		{
			identifier: "value",
			label: "label",
			items: 
			[
				{value: '==', label: '<xlat:stream key="dvin/AT/Common/isequalto" escape="true" encode="false"/>'}
			]
		};
	}

	if (type == "string")
	{
		compOpData =
		{
			identifier: "value",
			label: "label",
			items: 
			[
				{value: '==', label: '<xlat:stream key="dvin/AT/Common/isequalto" escape="true" encode="false"/>'},
				{value: '!=', label: '<xlat:stream key="dvin/AT/Common/isnotequalto" escape="true" encode="false"/>'},
				{value:  'cieq', label: '<xlat:stream key="dvin/AT/Common/isequaltocaseinsensitive" escape="true" encode="false"/>'},
				{value:  'cine', label: '<xlat:stream key="dvin/AT/Common/isnotequaltocaseinsensitive" escape="true" encode="false"/>'},
				{value:  'cont', label: '<xlat:stream key="dvin/AT/Common/contains" escape="true" encode="false"/>'}
			]
		};
	}
	
	if (isEditMode)
	{
		var compOpStore = new dojo.data.ItemFileReadStore({data:dojo.clone(compOpData)});
		var compOpCombo = new fw.dijit.UISimpleSelect ({store: compOpStore, searchAttr: "label", value: data.COMPAREOP}).placeAt(parentDiv);
		compOpCombo.connect(compOpCombo, "onChange", onCompOpComboChange);
	}
	else
	{	// inspectMode
		var label = '';
			
		for (var i = 0; i < compOpData.items.length; i++)
		{
			if (compOpData.items[i].value == data.COMPAREOP)
			{
				label = compOpData.items[i].label;
				break;
			}
		}
		
		new fw.dijit.UIInput ({type: "text", size: 14, value: label, readOnly: true}).placeAt(parentDiv);
	}
}

function renderValueTextbox(parentDiv, data, maxlength)
{
	maxlength = (maxlength && maxlength > 0) ? maxlength : 255;
	
	var div1 = dojo.create("div", {className: "segValue", style: "display: inline-block"}, parentDiv);
	var textbox1 = new fw.dijit.UIInput ({type: "text", size: 14, value: data.VALUE}).placeAt(div1);
	dojo.attr(textbox1.textbox, "maxlength", maxlength);
	
	if (!isEditMode)
		textbox1.set("readOnly", true);
	
	textbox1.connect(textbox1, "onChange", onTextValueChange);
	
	if (data.COMPAREOP == "bt")
	{
		dojo.create("div", {className: "segTextConnector"}, parentDiv).innerHTML = '<xlat:stream key="dvin/AT/Segments/ValueANDConnector" escape="true" encode="false"/>';
		
		var highValue = data.HIGHVALUE ? data.HIGHVALUE : ""; 
		var div2 = dojo.create("div", {className: "segHighValue", style: "display: inline-block"}, parentDiv);
		var textbox2 = new fw.dijit.UIInput ({type: "text", size: 14, value: highValue}).placeAt(div2);
		dojo.attr(textbox2.textbox, "maxlength", maxlength);

		if (!isEditMode)
			textbox2.set("readOnly", true);
		
		textbox2.connect(textbox2, "onChange", onTextHighValueChange);
	}
}

function renderMoneyValueTextbox(parentDiv, data)
{
	var localeCurrencySymbol = '<xlat:stream key="dvin/AT/Promotions/LocaleCurrencySymbol" escape="true" encode="false"/>';

	dojo.create("div", {className: "segCurrencySymbol"}, parentDiv).innerHTML = localeCurrencySymbol;
	
	var div1 = dojo.create("div", {className: "segValue", style: "display: inline-block"}, parentDiv);
	var textbox1 = new fw.dijit.UIInput ({type: "text", size: 14, value: data.VALUE}).placeAt(div1);
	dojo.attr(textbox1.textbox, "maxlength", 30);
	
	if (!isEditMode)
		textbox1.set("readOnly", true);
	
	textbox1.connect(textbox1, "onChange", onTextValueChange);
	
	if (data.COMPAREOP == "bt")
	{
		dojo.create("div", {className: "segTextConnector"}, parentDiv).innerHTML = '<xlat:stream key="dvin/AT/Segments/ValueANDConnector" escape="true" encode="false" />';
		
		dojo.create("div", {className: "segCurrencySymbol"}, parentDiv).innerHTML=localeCurrencySymbol;

		var highValue = data.HIGHVALUE ? data.HIGHVALUE : ""; 
		var div2 = dojo.create("div", {className: "segHighValue", style: "display: inline-block"}, parentDiv);
		var textbox2 = new fw.dijit.UIInput ({type: "text", size: 14, value: highValue}).placeAt(div2);
		dojo.attr(textbox2.textbox, "maxlength", 30);

		if (!isEditMode)
			textbox2.set("readOnly", true);
		
		textbox2.connect(textbox2, "onChange", onTextHighValueChange);
	}
}


function renderTimePicker(parentDiv, value, timezone, callback)
{
	var pickADateString = '<xlat:stream key="fatwire/Alloy/UI/PickADate" escape="true" encode="false" />';		
	var datePickerString = '<xlat:stream key="fatwire/Alloy/UI/DatePicker" escape="true" encode="false" />';		
	var dateFormatPattern = '<%=ConverterUtils.getDateFormatPattern(ics.GetSSVar("locale"))%>'; // 'yyyy-MM-dd HH:mm:ss'; 

	var dateObject = new Date(new Number(value));
	var dateBox = dojo.create("input", {type: "text", size: 14}, parentDiv);
	var dateString = dojo.date.locale.format(dateObject,{selector: 'date', datePattern: dateFormatPattern });		

	if (isEditMode)
	{
		dateBox = new fw.dijit.UIInput ( {value: dateString, clearButton: false, readOnly: true }, dateBox);
		dateBox.connect(dateBox, "onChange", callback);
		
		var calDiv = dojo.create("div", {className: "calButton"}, parentDiv);
		calDiv = new dijit.form.DropDownButton({
			label: '<img alt="' + datePickerString + '" title="' + pickADateString + '" src="js/fw/images/ui/ui/engage/calendarButton.png" border="0"/>',
	
			dropDown: null,
			onClick: function() {
				if(!this.dropDown) {
					var _tstampwgt = new fw.ui.dijit.TimestampPicker({
						onTimeStampSelect: function(timeStamp) {
							dateBox.set('value', dojo.date.locale.format(this.timeStamp,{selector: 'date',datePattern: dateFormatPattern }));
						},	
						timeStamp: new Date(new Number(value)),
						timePicker: true 						
					});
					this.dropDown = _tstampwgt;
				}
				this.openDropDown();
			}
		}, calDiv);
	}
	else
	{
		dateBox = new fw.dijit.UIInput ( {value: dateString, readOnly: true }, dateBox);
	}
}

function renderEnumCombo(parentDiv, theAtt, theValue, callback)
{
	if (isEditMode)
	{
		var enumData = {identifier: "value", label: "label", items: []};
		var selValue="";
		
		for (var e = 0; e < theAtt.constraint.list.length; e++)
		{
			var label = theAtt.constraint.list[e];
			var value = theAtt.constraint.list[e];
			
			if (theAtt && theAtt.type == "timestamp")
			{	
				// trim Visitor Attribute enum constraint value to remove the "nano" ".s" value - hack?
				label = label.substr(0,19);
				
				// convert the "value" to a milliseconds date value 					
				var date = dojo.date.locale.parse(label, {selector: 'date', datePattern: 'yyyy-MM-dd HH:mm:ss' });
				value = date.getTime().toString();
			}

			enumData.items.push( {value: value, label: label} );

			if (theValue == value)
				selValue=value;
		}

		var enumStore = new dojo.data.ItemFileReadStore({data:dojo.clone(enumData)});
		
		enumCombo = new fw.dijit.UISimpleSelect ({store: enumStore, searchAttr: "label", value: selValue}).placeAt(parentDiv);
		enumCombo.connect(enumCombo, "onChange", callback);
	}
	else
	{
		var value = theValue;			
		
		if (theAtt && theAtt.type == "timestamp")
		{	
			var dateObject = new Date(new Number(value));
			value = dojo.date.locale.format(dateObject,{selector: 'date', datePattern: 'yyyy-MM-dd HH:mm:ss' });		
		}			
		
		new fw.dijit.UIInput ({type: "text", size: 14, value: value, readOnly: true}).placeAt(parentDiv);
	}
}

function renderBooleanCombo (parentDiv, value, callback)
{
	if (isEditMode)
	{	
		var boolData = {identifier: "value", label: "label", 
				  items: [{value: "true", label: '<xlat:stream key="dvin/AT/Common/true" escape="true" encode="false" />'},
				          {value: "false", label: '<xlat:stream key="dvin/AT/Common/false" escape="true" encode="false" />'}  	        
				  ]};
	
		var boolStore = new dojo.data.ItemFileReadStore({data:dojo.clone(boolData)});
		
		var div1 = dojo.create("div", {className: "segValue", style: "display: inline-block"}, parentDiv);
		var boolCombo = new fw.dijit.UISimpleSelect ({store: boolStore, searchAttr: "label", value: value}).placeAt(div1);
		boolCombo.connect(boolCombo, "onChange", callback);
	}
	else
	{
		new fw.dijit.UIInput ({type: "text", size: 14, readOnly: true,
								value: value == 'true' ? '<xlat:stream key="dvin/AT/Common/true" escape="true" encode="false" />'
											           : '<xlat:stream key="dvin/AT/Common/false" escape="true" encode="false" />'
		}).placeAt(parentDiv);	
	}
}

function _eyeMouseOver (evt)
{
	var cell = findActiveCell(evt.target);
	
	var divs = dojo.query('.segCellMenu', cell.cellDiv);
	
	if (divs.length == 0)
		dojo.attr(evt.target, 'src', 'js/fw/images/ui/ui/engage/SuperMenuOn.png');
	else	
		dojo.attr(evt.target, 'src', 'js/fw/images/ui/ui/engage/SuperMenuHover.png');
	
	return true;
}

function _eyeMouseOut (evt)
{
	var cell = findActiveCell(evt.target);
	
	var divs = dojo.query('.segCellMenu', cell.cellDiv);
	
	if (divs.length == 0)
		dojo.attr(evt.target, 'src', 'js/fw/images/ui/ui/engage/SuperMenuOff.png');
	else
		dojo.attr(evt.target, 'src', 'js/fw/images/ui/ui/engage/SuperMenuOn.png');
		
	return true;
}

function renderAttCombo(cellDiv, data, selAtt)
{
	selAtt = selAtt || "";
	
	if (isEditMode)
	{
		// (Scalar) Vistor Attributes
	
		var attData = {identifier: "value", label: "label", items: []};
	
		for (var cat=0; cat < visitorData.categories.length; cat++)
		{	
			var category = visitorData.categories[cat];
			
			for (var att=0; att < category.attributes.length; att++)
			{
				var label = category.attributes[att].desc;
				
				if (category.attributes[att].type != 'blob')	// prevent use of binary attributes in these rules
					attData.items.push( {value: "scalar_" + cat + "_" + att, label: label} );
			}
		}
		
		// History Definitions
		
		for (var cat=0; cat < historyData.categories.length; cat++)
		{	
			var category = historyData.categories[cat];
				
			for (var att=0; att < category.attributes.length; att++)
			{
				var label = category.attributes[att].desc;
				attData.items.push( {value: "history_" + cat + "_" + att, label: label} );
			}
		}
		
		// Shopping Cart
		
		attData.items.push( {value: 'cart_0_0', label: '<xlat:stream key="dvin/AT/Segments/ShoppingCart" escape="true" encode="false"/>'} );
		
		// now render the combo + "eye"...
	
		var pickDiv = dojo.create("div", {className: "segAttPicker segRound"}, cellDiv);
		
		var attStore = new dojo.data.ItemFileReadStore({data:dojo.clone(attData)});
		var attCombo = new fw.dijit.UIFilteringSelect ({store: attStore, searchAttr: "label", value: selAtt, hasDownArrow: false, intermediateChanges: false}).placeAt(pickDiv);
	
		attCombo.connect(attCombo, "onChange", onAttComboChange);
	
		var altText = '<xlat:stream key="dvin/AT/Segments/SuperMenuAlt" escape="true" encode="false"/>';
		
		var a = dojo.create("a", {onclick: onShowCellMenu}, pickDiv);
		dojo.create("img", { className: "segEyeImage", src: "js/fw/images/ui/ui/engage/SuperMenuOff.png", 
								title: altText, alt: altText, border: "0px",
								onmouseover: _eyeMouseOver, onmouseout: _eyeMouseOut					
		}, a);
	}
	else
	{	// isInspectMode
		var desc = '';
		
		var s = selAtt.split('_');
		if (s[0] == 'scalar')
			desc = visitorData.categories[s[1]].attributes[s[2]].desc;		
		else if (s[0] == 'history')
			desc = historyData.categories[s[1]].attributes[s[2]].desc;		
		else if (s[0] == 'cart')
			desc = '<xlat:stream key="dvin/AT/Segments/ShoppingCart" escape="true" encode="false"/>';

		var pickDiv = dojo.create("div", {className: "segAttPicker segRound"}, cellDiv);
		new fw.dijit.UIInput ({type: "text", size: 14, value: desc, readOnly: true}).placeAt(pickDiv);	
	}
}

function renderDummyCell(cellDiv, data)
{	
	tidyWidgets(cellDiv);
	
	cellDiv.innerHTML = "";

	renderAttCombo(cellDiv, data, "none");
	
	if (nvRuleSet.rows.length > 1 || nvRuleSet.rows[0].cols.length > 0) 	
	{
		var exDiv = dojo.create("div", {className: 'segRemove clearfix'}, cellDiv);
		renderRemoveCell(exDiv, onRemoveCell);
	}
}	

function onMegaMenuClick(evt)
{
	var v = evt.target.id.split("_");
	var kind = v[0];
	var cat = v[1];
	var att = v[2]

	if (att == "none")
		return;
	
	setTabDirty();
	
	var cell = findActiveCell(evt.target);

	doMegaAction(cell, kind, cat, att);
}
	
function onAttComboChange(value)
{
	if (value == "none")
	{
		this.reset();
		return;
	}
	
	if (value == this._resetValue)
		return;

	var v = value.split("_");
	var kind = v[0];
	var cat = v[1];
	var att = v[2]

	if (att == "none")
	{
		this.reset();
		return;
	}
	
	setTabDirty();
	
	var cell = findActiveCell(this.domNode);

	doMegaAction(cell, kind, cat, att);
}

function doMegaAction (cell, kind, cat, att)
{
	var data = createDummyData();
	
	if (kind == 'scalar')
	{
		data = createScalarData();
		data.VARNAME = visitorData.categories[cat].attributes[att].id;	
		data.VARDESC = visitorData.categories[cat].attributes[att].desc;
		
		if (visitorData.categories[cat].attributes[att].assetid)
			data.VARASSETID = visitorData.categories[cat].attributes[att].assetid;	
		
		data.RULECATEGORY = visitorData.categories[cat].name;
		data.COMPAREOP="==";
		
		if (visitorData.categories[cat].attributes[att].type == "timestamp")
		{
			var newDate = getNewDate();

			data.VALUE=newDate;
			data.VALUETZ="";
			
			data.HIGHVALUE="";
			data.HIGHVALTZ="";
		}
		else
		{
			data.VALUE="";
			data.VALUETZ="";
			data.HIGHVALUE="";
			data.HIGHVALTZ="";
		}
	}
	else
	if (kind == 'history')
	{
		data = createHistoryData();
		data.RULECATEGORY = historyData.categories[cat].name;
		data.VARNAME = historyData.categories[cat].attributes[att].id;
		data.VARDESC = historyData.categories[cat].attributes[att].desc;		
		
		if (historyData.categories[cat].attributes[att].assetid)				
			data.VARASSETID = historyData.categories[cat].attributes[att].assetid;				
		
		var fields = historyData.categories[cat].attributes[att].fields; 
		var nSummableFields = 0;
		
		for (var i = 0; i < fields.length; i++)
		{
			var fType = fields[i].type;
			
			if (fType == "int" || fType == "money" || fType == "short" || fType == "long" || fType == "double")
			{
				nSummableFields++;
			}
		}
	
		data.HOP = (nSummableFields == 0) ? 'count' : 'sum';
	}
	else
	if (kind == 'cart')
	{
		data = createCartData();
	}

	if (data.RULETYPE != "dummy")
	{
		dojo.removeClass(cell.cellDiv, "segCellDummy");
		nvRuleSet.rows[cell.row].cols[cell.col] = data;
		
		var divs = dojo.query(".segCellMenu", cell.cellDiv);
		
		if (divs && divs.length > 0)
			destroyDiv(divs[0]);
	}
	
	renderCellBody(cell.cellDiv, data);
	
	if (kind == 'scalar')
	{
		findCatAndAtt(data);

		if (data.attIndex != -1)
		{
			var theAtt = visitorData.categories[data.catIndex].attributes[data.attIndex];
		
			if (theAtt && theAtt.constraint.type != 'enum' && theAtt.type != "boolean" && theAtt.type != "timestamp")
				setFocus(cell.row, cell.col, ".segValue");
		}
	}
}

function findCatAndAtt(data)
{
	data.catIndex = -1;	
	data.attIndex = -1;
			
	for (var cat=0; cat < visitorData.categories.length; cat++)
	{	
		var category = visitorData.categories[cat];

		for (var att=0; att < category.attributes.length; att++)
		{
			if (data && category.attributes[att].id == data.VARNAME)
			{
				if (data.RULECATEGORY != category.name)
				{	// attribute was moved to a different category
					data.RULECATEGORY = category.name;
				}
				
				data.catIndex = cat;	
				data.attIndex = att;
				return;						// R E T U R N
			}
		}
	}
}

function renderScalarCell(cellDiv, data)
{
	tidyWidgets(cellDiv);
	cellDiv.innerHTML = "";

	// ==== Exclude + Remove ====

	var exDiv = dojo.create("div", {className: 'segRemove clearfix'}, cellDiv);
	renderOpCheck(exDiv, data);
	renderRemoveCell(exDiv, onRemoveCell);
	
	// ==== Attribute ====

	var attData = {identifier: "value", label: "label", items: []};

	var selAtt = "";	
	var theAtt = null;
	
	findCatAndAtt(data);

	if (data.attIndex != -1)
	{ 
		selAtt = "scalar_" + data.catIndex + "_" + data.attIndex;
		theAtt = visitorData.categories[data.catIndex].attributes[data.attIndex];	
	}
		
	renderAttCombo(cellDiv, data, selAtt);

	// ==== Operator ====
		
	renderCompOpCombo(cellDiv, data, theAtt ? theAtt.type : 'string');

	// ==== Value ====
		
	var valDiv = dojo.create("div", {className: "segFieldDiv"}, cellDiv);		
	
	if (theAtt && theAtt.constraint.type == 'enum')
	{
		var div1 = dojo.create("div", {className: "segValue", style: "display: inline-block"}, valDiv);
		renderEnumCombo (div1, theAtt, data.VALUE, onEnumComboChange);

		if (data.COMPAREOP == "bt")
		{
			dojo.create("div", {className: "segTextConnector"}, valDiv).innerHTML = '<xlat:stream key="dvin/AT/Segments/ValueANDConnector" escape="true" encode="false" />';
			
			var div2 = dojo.create("div", {className: "segHighValue", style: "display: inline-block"}, valDiv);
			renderEnumCombo (div2, theAtt, data.HIGHVALUE, onEnumComboHighValueChange);
		}
	}
	else
	{
		if (theAtt && theAtt.type == "timestamp")
		{
			var div1 = dojo.create("div", {className: "segValue", style: "display: inline-block"}, valDiv);
			renderTimePicker(div1, data.VALUE, data.VALUETZ, onDateValueChange);
			
			if (data.COMPAREOP == "bt")
			{
				dojo.create("div", {className: "segTextConnector"}, valDiv).innerHTML = '<xlat:stream key="dvin/AT/Segments/ValueANDConnector" escape="true" encode="false" />';
				var div2 = dojo.create("div", {className: "segHighValue", style: "display: inline-block"}, valDiv);
				renderTimePicker(div2, data.HIGHVALUE, data.HIGHVALTZ, onDateHighValueChange);
			}
		}
		else
		if (theAtt && theAtt.type == "boolean")
		{
			renderBooleanCombo(valDiv, data.VALUE, onBooleanComboChange);
		}
		else
		if (theAtt && theAtt.type == "string")
		{
			renderValueTextbox(valDiv, data, theAtt.length);
		}
		else
		if (theAtt && theAtt.type == "money")
		{
			renderMoneyValueTextbox(valDiv, data);
		}
		else			
		{
			renderValueTextbox(valDiv, data);
		}
	}
}

function dropShoppingCartAsset(args)
{
	var values = args.getAllDnDValues();
	
	setTabDirty();
	
	var cell = findActiveCell(args.domNode);		
	var data = nvRuleSet.rows[cell.row].cols[cell.col];

	var newvalues = new Array();

	for (var v = 0; v < values.length; v++)
	{
		// add the data to the "assets" array...
		newvalues[v] = {id: values[v][0], type: values[v][1], name: values[v][2] /*, typedesc: values[v][1]*/};
	}
	
	data.assets = newvalues;
}

function addShoppingCartAssetFromTree(evt)
{
   	var encodedString = parent.frames["XcelTree"].document.TreeApplet.exportSelections()+'';
   	var assetArray = encodedString.split(':');
   	var assetcheck = unescape(assetArray[0]);	
   	if (assetcheck.indexOf('assettype=')!=-1 && assetcheck.indexOf('id=')!=-1)
   	{
    	setTabDirty();

		var cell = findActiveCell(evt.target);		
		var data = nvRuleSet.rows[cell.row].cols[cell.col];

		if (!data.assets) 
			data.assets = new Array();
		
		var values = data.assets;
		
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
					values.push({id: asset.id, type: asset.type, name: asset.name});
			}
		}
   		
   		renderCellBody(cell.cellDiv, data);
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

function addHistoryConstraintAssetFromTree(evt)
{
   	var encodedString = parent.frames["XcelTree"].document.TreeApplet.exportSelections()+'';
   	var assetArray = encodedString.split(':');
   	var assetcheck = unescape(assetArray[0]);	
   	if (assetcheck.indexOf('assettype=')!=-1 && assetcheck.indexOf('id=')!=-1)
   	{
    	setTabDirty();

		var cell = findActiveCell(evt.target);		
		
		// figure out which field we are in...
		var field = 0;
		
		var obj = evt.target;
		while (obj && !dojo.hasClass(obj, "segHistoryConstraintDisp"))
			obj = obj.parentElement;
		
		var disps = dojo.query('.segHistoryConstraintDisp', cell.cellDiv );
		
		for (var f = 0; f < disps.length; f++)
		{
			if (disps[f] === obj)
			{
				field = f;
				break;
			}
		}	
		
		var data = nvRuleSet.rows[cell.row].cols[cell.col];
		var fields = historyData.categories[data.catIndex].attributes[data.attIndex].fields;
		
		var index = 0;
		
		for (index = 0; index < data.constraints.length; index++)
		{
			if (data.constraints[index].name == fields[field].name)
				break;
		}
		
		var values = new Array();
			
		if (index < data.constraints.length)
		{	
			// add to existing constraint
			var constraint = data.constraints[index];
			values = constraint.values;
		}
		else
		{
			// add a new constraint
			var constraint = new Object();
			
			constraint.name = fields[field].name;
			constraint.type = fields[field].constraint.htype;
			constraint.values = values;
			data.constraints[index] = constraint;
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
					values.push({id: asset.id, type: asset.type, name: asset.name});
			}
		}
   		
   		renderHistoryConstraint(cell.cellDiv, field, data);	
	}
   	else
   	{
      	alert('<xlat:stream key="dvin/UI/PleaseSelectAssetFromTree" escape="true" encode="false"/>');
   	}
}

function dropHistoryConstraintAsset(args)
{
	var values = args.getAllDnDValues();
	
	setTabDirty();
	
	var cell = findActiveCell(args.domNode);		

	// figure out which field we are in...
	var field = 0;
	
	var obj = args.domNode;
	while (obj && !dojo.hasClass(obj, "segHistoryConstraintDisp"))
		obj = obj.parentElement;
	
	var disps = dojo.query('.segHistoryConstraintDisp', cell.cellDiv );
	
	for (var f = 0; f < disps.length; f++)
	{
		if (disps[f] === obj)
		{
			field = f;
			break;
		}
	}	
	
	var data = nvRuleSet.rows[cell.row].cols[cell.col];
	var fields = historyData.categories[data.catIndex].attributes[data.attIndex].fields;
	
	var index = 0;
	
	for (index = 0; index < data.constraints.length; index++)
	{
		if (data.constraints[index].name == fields[field].name)
			break;
	}
	
	var newvalues = new Array();

	for (var v = 0; v < values.length; v++)
	{
		// add the data to the "assets" array...
		newvalues[v] = {id: values[v][0], type: values[v][1], name: values[v][2] /*, typedesc: values[v][1]*/};
	}
	
	if (index < data.constraints.length)
	{	
		// add to existing constraint
		var constraint = data.constraints[index];
		constraint.values = newvalues;
	}
	else
	{
		// add a new constraint
		var constraint = new Object();
		
		constraint.name = fields[field].name;
		constraint.type = fields[field].constraint.htype;

		constraint.values = newvalues;
		
		data.constraints[index] = constraint;
	}
}

function renderCartCell(cellDiv, data)
{
	tidyWidgets(cellDiv);
	
	cellDiv.innerHTML = "";
	
	var headDiv = dojo.create("div", {}, cellDiv);	

	var ex = dojo.create("div", {className: 'segRemove clearfix'}, headDiv);
	renderOpCheck(ex, data);
	renderRemoveCell(ex, onRemoveCell);	

	renderAttCombo(headDiv, data, "cart_0_0");

	// the value/count combo
	
	var opDiv = dojo.create("div", {className: "segShim1"}, cellDiv);	
	
	var opComboDiv = dojo.create("div", {className: "segFieldDiv"}, opDiv);	
	
	var assetOpData = {identifier: "value", label: "label", 
			  items: [{value: "value", label: '<xlat:stream key="dvin/AT/Segments/Totvaluecartitems" escape="true" encode="false" />'},
			          {value: "count", label: '<xlat:stream key="dvin/AT/Segments/Totcountcartitems" escape="true" encode="false" />'}  	        
			  ]};
	
	if (isEditMode)
	{
		var assetOpStore = new dojo.data.ItemFileReadStore({data:dojo.clone(assetOpData)});
		var assetOpCombo = new fw.dijit.UISimpleSelect ({store: assetOpStore, searchAttr: "label", value: data.ASSETOP}).placeAt(opComboDiv);
		assetOpCombo.connect(assetOpCombo, "onChange", onAssetOpComboChange);
	}
	else
	{
		var label = getLabelForValue(assetOpData.items, data.ASSETOP);		
		new fw.dijit.UIInput ({type: "text", size: 14, value: label, readOnly: true}).placeAt(opComboDiv);
	}		
	
	renderCompOpCombo(opDiv, data, "");	

	var localeCurrencySymbol = '<xlat:stream key="dvin/AT/Promotions/LocaleCurrencySymbol" escape="true" encode="false"/>';
	
	var fieldDiv = dojo.create("div", {className: "segFieldDiv"}, opDiv);
	
	if (data.ASSETOP == 'value')
		dojo.create("div", {className: "segCurrencySymbol"}, fieldDiv).innerHTML=localeCurrencySymbol;

	var div1 = dojo.create("div", {className: "segValue", style: "display: inline-block"}, fieldDiv);
	var textbox1 = new fw.dijit.UIInput ({type: "text", size: 14, value: data.VALUE}).placeAt(div1);
	
	if (!isEditMode)
		textbox1.set("readOnly", true);
	
	textbox1.connect(textbox1, "onChange", onTextValueChange);
	
	if (data.COMPAREOP == "bt")
	{
		dojo.create("div", {className: "segTextConnector"}, fieldDiv).innerHTML = '<xlat:stream key="dvin/AT/Segments/ValueANDConnector" escape="true" encode="false" />';
		
		if (data.ASSETOP == 'value')
			dojo.create("span", {}, fieldDiv).innerHTML="&nbsp;" +  localeCurrencySymbol;

		var highValue = data.HIGHVALUE ? data.HIGHVALUE : "";
		
		var div2 = dojo.create("div", {className: "segHighValue", style: "display: inline-block"}, fieldDiv);
		var textbox2 = new fw.dijit.UIInput ({type: "text", size: 14, value: highValue}).placeAt(div2);

		if (!isEditMode)
			textbox2.set("readOnly", true);
		
		textbox2.connect(textbox2, "onChange", onTextHighValueChange);
	}
	
	// Restrict to Assets 

	var modeDiv = dojo.create("div", {className: "segFieldDiv"}, cellDiv);
	
	var modeData = {identifier: "value", label: "label", 
			  items: [{value: "all", label: '<xlat:stream key="dvin/UI/Admin/Norestrictions" escape="true" encode="false"/>'},
			          {value: "specified", label: '<xlat:stream key="dvin/AT/Segments/Restricttospecificproducts" escape="true" encode="false"/>'}  	        
			  ]};

	if (isEditMode)
	{
		var modeStore = new dojo.data.ItemFileReadStore({data:dojo.clone(modeData)});
		var modeCombo = new fw.dijit.UISimpleSelect ({store: modeStore, searchAttr: "label", value: data.CARTMODE}).placeAt(modeDiv);
		modeCombo.connect(modeCombo, "onChange", onModeComboChange);
	}
	else
	{
		var label = getLabelForValue(modeData.items, data.CARTMODE);		
		new fw.dijit.UIInput ({type: "text", size: 14, value: label, readOnly: true}).placeAt(modeDiv);
	}
	
	if (data.CARTMODE != "all")
	{
		var attDiv = dojo.create("div", {}, cellDiv);	
		var disp = dojo.create("div", {className: "segCartAssetsDiv"}, attDiv); 
		var dropFrame = dojo.create("div", {className: "segDropFrame"}, disp); 
		var dropDiv = dojo.create("div", {}, dropFrame);

		if (isEditMode)
		{
			var widVal = [];
			
			if (data.assets)
			{
				for (var att = 0; att < data.assets.length; att++)
				{
					var asset = data.assets[att];
					widVal.push(asset.type + ":" + asset.id + ":" + asset.name + ":");
				}
			}

			var acceptList = ['*'];
			var dropWidget = new fw.ui.dijit.form.TypeAhead ( { accept: acceptList, 
																value: widVal,
																multiple: true,
																multiOrdered: true,
																displaySearchbox: false,
																cs_environment: '<%=ics.GetVar("cs_environment")%>',
																isDropZone: true 															
															  }, dropDiv);
	
			dojo.publish("typeAhead/Ready", [dropWidget]);
			dojo.attr(dropWidget.domNode, "style", {display: "none"});
			dropWidget.startup();
			dojo.connect(dropWidget, 'onChange', function() { dropShoppingCartAsset(this); });
			dojo.connect(dropWidget, 'onEdit',  function(item) { doEditAssetItem(item); });
			
			if (!isContributorMode)
			{
				var treeDiv = dojo.create("div", {}, dropFrame);

				var label = '<xlat:stream key="dvin/AT/AdvCols/AddSelectedItems" escape="true" encode="false"/>';

				var addButton = dojo.create("input", {type: "button", value: label}, treeDiv);
				addButton = new fw.ui.dijit.Button ({title: label, label: label, accept: acceptList}, addButton);
				addButton.connect(addButton, "onClick", addShoppingCartAssetFromTree);
				
				var hintDiv = dojo.create("div", {}, treeDiv);
				hintDiv.innerHTML= '<xlat:stream key="dvin/AT/AdvCols/HintSelectedItemsFromTree" escape="true" encode="false" />';
			}
		}
		else
		{
			renderAssetList(dropDiv, data.assets);
		}
	}	
}

function renderAssetList(parentDiv, assets)
{
	if (assets)
	{
		for (var att = 0; att < assets.length; att++)
		{
			dojo.create("div", {className: 'segAsset'}, parentDiv).innerHTML = assets[att].name + " (" + assets[att].type + ")";
		}
	}
}

function getLabelForValue(items, value)
{
	var label = "";

	for (var i = 0; i < items.length; i++)
	{
		if (items[i].value == value)
		{
			label = items[i].label;
			break;
		}
	}
	return label;
}

function renderHistoryCell(cellDiv, data)
{
	tidyWidgets(cellDiv);
	cellDiv.innerHTML = "";
	
	data.catIndex = -1;	
	data.attIndex = -1;
	
	for (var cat=0; cat < historyData.categories.length; cat++)
	{	
		for (var att=0; att < historyData.categories[cat].attributes.length; att++)
		{
			if (historyData.categories[cat].attributes[att].id == data.VARNAME)
			{	
				if (data.RULECATEGORY != historyData.categories[cat].name)
				{	// attribute was moved to a different category
					data.RULECATEGORY = historyData.categories[cat].name;
				}

				data.catIndex = cat;
				data.attIndex = att;
				break;
			}
		}
	}

	var headDiv = dojo.create("div", {}, cellDiv);	

	var ex = dojo.create("div", {className: 'segRemove clearfix'}, headDiv);
	renderOpCheck(ex, data);
	renderRemoveCell(ex, onRemoveCell);	

	var selAtt = "";

	if (data.attIndex != -1)
		selAtt = "history_" + data.catIndex + "_" + data.attIndex;
	
	renderAttCombo(headDiv, data, selAtt);

	if (data.attIndex == -1)
		return; // R E T U R N	
	
	// the sum/count/earliest/latest combo
	// the value/count combo
	
	var fields = historyData.categories[data.catIndex].attributes[data.attIndex].fields; 

	var nSummableFields = 0;
	
	for (var i = 0; i < fields.length; i++)
	{
		var fType = fields[i].type;
		
		if (fType == "int" || fType == "money" || fType == "short" || fType == "long" || fType == "double")
		{
			nSummableFields++;
		}
	}
	
	var opDiv = dojo.create("div", {className: "segShim1"}, cellDiv);	
	
	var opComboDiv = dojo.create("div", {className: "segFieldDiv"}, opDiv);
	
	var historyOpData = {identifier: "value", label: "label", items: []};

	if (nSummableFields > 0)
		historyOpData.items.push( {value: "sum", label: '<xlat:stream key="dvin/AT/Segments/Total" escape="true" encode="false" />'} );
		
	historyOpData.items.push( {value: "count", label: '<xlat:stream key="dvin/AT/Segments/Count" escape="true" encode="false" />'} );  	        
	historyOpData.items.push( {value: "first", label: '<xlat:stream key="dvin/AT/Segments/Earliestdaterecorded" escape="true" encode="false" />'} ); 	        
	historyOpData.items.push( {value: "last", label: '<xlat:stream key="dvin/AT/Segments/Latestdaterecorded" escape="true" encode="false" />'} ); 
	
	if (isEditMode)
	{		
		var historyOpStore = new dojo.data.ItemFileReadStore({data:dojo.clone(historyOpData)});
		var historyOpCombo = new fw.dijit.UISimpleSelect ({store: historyOpStore, searchAttr: "label", value: data.HOP}).placeAt(opComboDiv);
		historyOpCombo.connect(historyOpCombo, "onChange", onHistoryOpComboChange);
	}
	else
	{
		var label = getLabelForValue(historyOpData.items, data.HOP);
		new fw.dijit.UIInput ({type: "text", size: 14, value: label, readOnly: true}).placeAt(opComboDiv);
	}

	// next bunch depends on HOP...
	
	if (data.HOP == 'sum')
	{
		// so - here we need to locate the "fields" list in the historyData
		// then we need to filter out the "summable" fields and offer them here
		// summable == short,long,int,double,money
	
		var sumFieldsData = {identifier: "value", label: "label", items: []};
		var compOpType = "";
		var fieldDesc = "";
		
		for (var i = 0; i < fields.length; i++)
		{
			var fType = fields[i].type;
			
			if (fType == "int" || fType == "money" || fType == "short" || fType == "long" || fType == "double")
			{
				sumFieldsData.items.push( {value: fields[i].name, label: fields[i].desc} );
				
				if (!data.HFIELD || data.HFIELD == "")
					data.HFIELD = fields[i].name;	// set default value for new cell
			}
			
			if (fields[i].name == data.HFIELD)
			{
				compOpType = fType;
				fieldDesc = fields[i].desc;
			}				
		}
		
		var div2 = dojo.create("div", {className: "segFieldDiv"}, opDiv);
		
		if (isEditMode)
		{	
			var sumFieldsStore = new dojo.data.ItemFileReadStore({data:dojo.clone(sumFieldsData)});
			var sumFieldsCombo = new fw.dijit.UISimpleSelect ({store: sumFieldsStore, searchAttr: "label", value: data.HFIELD}).placeAt(div2);
			sumFieldsCombo.connect(sumFieldsCombo, "onChange", onSumFieldsComboChange);
		}
		else
		{
			new fw.dijit.UIInput ({type: "text", size: 14, value: fieldDesc, readOnly: true}).placeAt(div2);
		}
		
		// now, we need a compOpCombo...
		renderCompOpCombo(opDiv, data, compOpType);	
			
		var valDiv = dojo.create("div", {className: "segFieldDiv"}, opDiv);		
		
		// and one of two value text entry fields
		if (compOpType == "money")
			renderMoneyValueTextbox(valDiv, data);
		else
			renderValueTextbox(valDiv, data);
	}
	else
	if (data.HOP == 'count')
	{
		// now, we need a compOpCombo...
		renderCompOpCombo(opDiv, data, compOpType);	
		
		var valDiv = dojo.create("div", {className: "segFieldDiv"}, opDiv);		
		
		// and one of two value text entry fields
		renderValueTextbox(valDiv, data);
	}
	else
	if (data.HOP == 'first' || data.HOP == 'last')
	{
		var valDiv = dojo.create("div", {className: "segFieldDiv"}, opDiv);		
		
		renderTimePicker(valDiv, data.VALUE, data.VALUETZ, onDateValueChange)
	}
	
	// render the "Restrict to a specific time period" line
	
	var timeDiv = dojo.create("div", {}, cellDiv);	
	
	var timeComboDiv = dojo.create("div", {className: "segFieldDiv"}, timeDiv);
	
	var historyDateOpData = {identifier: "value", label: "label", 
			  items: [{value: "none", label: '<xlat:stream key="dvin/AT/Segments/Overall" escape="true" encode="false" />'},
			          {value: "relative", label: '<xlat:stream key="dvin/AT/Segments/Thelast" escape="true" encode="false" />'},
			          {value: "fixed", label: '<xlat:stream key="dvin/AT/Segments/Aspecifictimeperiod" escape="true" encode="false" />'}  	        
			  ]};

	if (isEditMode)
	{
		var historyDateOpStore = new dojo.data.ItemFileReadStore({data:dojo.clone(historyDateOpData)});
		var historyDateOpCombo = new fw.dijit.UISimpleSelect ({store: historyDateOpStore, searchAttr: "label", value: data.HDATEOP}).placeAt(timeComboDiv);
		historyDateOpCombo.connect(historyDateOpCombo, "onChange", onHistoryDateOpComboChange);
	}
	else
	{
		var label = getLabelForValue(historyDateOpData.items, data.HDATEOP);
		new fw.dijit.UIInput ({type: "text", size: 14, value: label, readOnly: true}).placeAt(timeComboDiv);
	}
	
	// next bunch depends on HDATEOP...
	
	if (data.HDATEOP == 'none')
	{
		// show nothing...
	}
	else
	if (data.HDATEOP == 'relative')
	{
		var timeRelDiv = dojo.create("div", {className: "segFieldDiv"}, timeDiv);
		
		var div3 = dojo.create("div", {className: "segValue, segHInterval", style: "display: inline-block"}, timeRelDiv);
		var textbox3 = new fw.dijit.UIInput ({type: "text", size: 14, value: data.HINTERVAL}).placeAt(div3);
		dojo.attr(textbox3.textbox, "maxlength", 10);
		
		if (!isEditMode)
			textbox3.set("readOnly", true);
		
		textbox3.connect(textbox3, "onChange", onTextIntervalChange);
		
		var historyRelOpData = {identifier: "value", label: "label", 
				  items: [{value: "hours", label: '<xlat:stream key="dvin/Common/hours" escape="true" encode="false" />'},
				          {value: "days", label: '<xlat:stream key="dvin/Common/lcdays" escape="true" encode="false" />'},
				          {value: "weeks", label: '<xlat:stream key="dvin/Common/weeks" escape="true" encode="false" />'},
				          {value: "months", label: '<xlat:stream key="dvin/Common/months" escape="true" encode="false" />'},
				          {value: "years", label: '<xlat:stream key="dvin/Common/years" escape="true" encode="false" />'}  	        
				  ]};
	
		var timeRelComboDiv = dojo.create("div", {className: "segFieldDiv"}, timeDiv);
		
		if (isEditMode)
		{
			var historyRelOpStore = new dojo.data.ItemFileReadStore({data:dojo.clone(historyRelOpData)});
			var historyRelOpCombo = new fw.dijit.UISimpleSelect ({store: historyRelOpStore, searchAttr: "label", value: data.HRELTYPE}).placeAt(timeRelComboDiv);
			historyRelOpCombo.connect(historyRelOpCombo, "onChange", onHistoryRelOpComboChange);
		}
		else
		{
			var label = getLabelForValue(historyRelOpData.items, data.HRELTYPE);
			new fw.dijit.UIInput ({type: "text", size: 14, value: label, readOnly: true}).placeAt(timeRelComboDiv);
		}
	}
	else
	if (data.HDATEOP == 'fixed')
	{
		dojo.create("div", {className: "segTextConnector"}, timeDiv).innerHTML = '<xlat:stream key="dvin/AT/Segments/FixedDateBETWEEN" escape="true" encode="false" />';
		renderTimePicker(timeDiv, data.HSTARTDATE, data.HSTARTTZ, onDateStartChange)
		dojo.create("div", {className: "segTextConnector"}, timeDiv).innerHTML = '<xlat:stream key="dvin/AT/Segments/ValueANDConnector" escape="true" encode="false" />';
		renderTimePicker(timeDiv, data.HENDDATE, data.HENDTZ, onDateEndChange)
	}
	
	// render the "History Attributes" block
	
	var attDiv = dojo.create("div", {className: "segHistoryConstraintDiv"}, cellDiv);	

	// ATTRIBUTE STUFF

	var fields = historyData.categories[data.catIndex].attributes[data.attIndex].fields;
	
	if (fields && fields.length && fields.length > 0)
	{
		for (var field = 0; field < fields.length; field++)
		{
			var rowDiv = dojo.create("div", {className: 'segHistoryConstraintRow'}, attDiv);
			
			var index = 0;
			
			for (index = 0; index < data.constraints.length; index++)
			{
				if (data.constraints[index].name == fields[field].name)
					break;
			}
			
			if (index < data.constraints.length || isEditMode)
			{
				// we have a value for this field
			
				if (isEditMode)
				{
					var bChecked = (index < data.constraints.length);
					var checkbox = new dijit.form.CheckBox({checked: bChecked});
					checkbox.field = field;
					checkbox.placeAt(rowDiv);
					
					dojo.addClass(checkbox.focusNode, 'segHistoryConstraintBox');
					dojo.connect(checkbox, "onChange", onHistoryConstraintClick);
				}
				
				var label = dojo.create("label", {className: 'segHistoryConstraintLabel'}, rowDiv);
				label.innerHTML = fields[field].desc;
				dojo.attr(label, "for", "foo");			
				
				// we are listing the known fields...
				// each field may or may not have a constraint (or constraints) to apply.
				// to make it cleaner to change the rendering and re-rendering of this data
				// we need to create a findable placeholder object...
				// so - create each object here - based on the type of the data
				// at runtime, in the clickhandler, we will redraw this small part of the display.
				// that way, we don't upset dojo by doing "connect" from inside an event handler
		
				dojo.create("div", {className: 'segHistoryConstraintDisp'}, rowDiv);
				renderHistoryConstraint(cellDiv, field, data);
			}
		}
	}
}

function renderHistoryConstraint(cellDiv, field, data)
{
	var cell = findActiveCell(cellDiv);
	var fieldRows = dojo.query('.segHistoryConstraintRow', cell.cellDiv );
	var box = dojo.query('.segHistoryConstraintBox', fieldRows[field])[0];
	var disp = dojo.query('.segHistoryConstraintDisp', fieldRows[field])[0];
	
	var fields = historyData.categories[data.catIndex].attributes[data.attIndex].fields;
	
	if (disp)
	{
		tidyWidgets(disp);
		
		disp.innerHTML = "";			
		
		var index = 0;
		
		for (index = 0; index < data.constraints.length; index++)
		{
			if (data.constraints[index].name == fields[field].name)
				break;
		}
		
		if (index < data.constraints.length)
		{
			// we have a value for this field
			
			if (fields[field].constraint.htype == 'assetattr')
			{
				var dropFrame = dojo.create("div", {className: "segDropFrame"}, disp); 
				var dropDiv = dojo.create("div", {}, dropFrame);

				if (isEditMode)
				{					
					var widVal = [];
			
					var values = data.constraints[index].values;
					
					for (var val = 0; val < values.length; val++)
					{
						var asset = values[val];
						widVal.push(asset.type + ":" + asset.id + ":" + asset.name + ":");
					}

					var acceptList = ['*'];
					
					var dropWidget = new fw.ui.dijit.form.TypeAhead ( { accept: acceptList, 
																		value: widVal,
																		multiple: true,
																		multiOrdered: true,
																		displaySearchbox: false,
																		cs_environment: '<%=ics.GetVar("cs_environment")%>',
																		isDropZone: true 															
																	  }, dropDiv);
	
					dojo.publish("typeAhead/Ready", [dropWidget]);
					dojo.attr(dropWidget.domNode, "style", {display: "none"});
					dropWidget.startup();
					dojo.connect(dropWidget, 'onChange', function() { dropHistoryConstraintAsset(this); });
					dojo.connect(dropWidget, 'onEdit',  function(item) { doEditAssetItem(item); });
					
					
					if (!isContributorMode)
					{
						var treeDiv = dojo.create("div", {}, dropFrame);

						var label = '<xlat:stream key="dvin/AT/AdvCols/AddSelectedItems" escape="true" encode="false"/>';

						var addButton = dojo.create("input", {type: "button", value: label}, treeDiv);
						addButton = new fw.ui.dijit.Button ({title: label, label: label, accept: acceptList}, addButton);
						addButton.connect(addButton, "onClick", addHistoryConstraintAssetFromTree);
						
						var hintDiv = dojo.create("div", {}, treeDiv);
						hintDiv.innerHTML= '<xlat:stream key="dvin/AT/AdvCols/HintSelectedItemsFromTree" escape="true" encode="false" />';
					}
				}
				else
				{
					renderAssetList(dropDiv, data.constraints[index].values);
				}
			}	
			else
			if (fields[field].constraint.type == 'enum')
			{
				if (isEditMode)
				{
					var enumData = {identifier: "value", label: "label", items: []};
					var enumValue="";
		
					for (var e = 0; e < fields[field].constraint.list.length; e++)
					{
						enumData.items.push( {value: e, label: fields[field].constraint.list[e]} );
					
						if (data.constraints[index].values[0].value == fields[field].constraint.list[e])
							enumValue=e;
					}
					
					var enumStore = new dojo.data.ItemFileReadStore({data:dojo.clone(enumData)});
					enumCombo = new fw.dijit.UISimpleSelect ({store: enumStore, searchAttr: "label", value: enumValue}).placeAt(disp);
					enumCombo.historyConstraintValue=data.constraints[index].values[0]
					enumCombo.connect(enumCombo, "onChange", onHistoryConstraintValueComboChange);
				}
				else
				{
					var label = data.constraints[index].values[0].value;
					new fw.dijit.UIInput ({type: "text", size: 14, value: label, readOnly: true}).placeAt(disp);					
				}
			}
			else
			{
				var textbox = dojo.create("input", {type: "text", size: 14}, disp);
				textbox = new fw.dijit.UIInput ({value: data.constraints[index].values[0].value}, textbox);

				if (!isEditMode)
					textbox.set("readOnly", true);
				
				textbox.historyConstraintValue = data.constraints[index].values[0];
				textbox.connect(textbox, "onChange", onTextHistoryConstraintValueChange);
			}
		}
	}
}
	
function renderRowHeader(rowDiv)
{
	var rowHeaderDiv = dojo.query('.segRowHeader', rowDiv)[0];	
	dojo.create("div", {className: 'segConnectorLine'}, rowHeaderDiv);
	var d = dojo.create("div", {className: 'segConnector segAndConnector segRound'}, rowHeaderDiv);
	dojo.create("div", {className: "segConnectorLabel"}, d).innerHTML = '<xlat:stream key="dvin/AT/Segments/CellANDConnector" escape="true" encode="false" />';
	dojo.create("div", {className: 'segConnectorLine'}, rowHeaderDiv);
}

function renderCellHeader(cellDiv)
{
	var cellHeaderDiv = dojo.query('.segCellHeader', cellDiv)[0];
	dojo.create("div", {className: 'segConnectorLine'}, cellHeaderDiv);
	var d = dojo.create("div", {className: 'segConnector segOrConnector segRound'}, cellHeaderDiv);
	dojo.create("div", {className: "segConnectorLabel"}, d).innerHTML = '<xlat:stream key="dvin/AT/Segments/CellORConnector" escape="true" encode="false" />';
	dojo.create("div", {className: 'segConnectorLine'}, cellHeaderDiv);
}

function _removeCellOver (evt)
{
	dojo.attr(evt.target, 'src', 'js/fw/images/ui/ui/engage/DeleteHover.png'); 
	return true;
}

function _removeCellOut (evt)
{
	dojo.attr(evt.target, 'src', 'js/fw/images/ui/ui/engage/DeleteOff.png'); 
	return true;
}

function renderRemoveCell(div, funcToRun)
{
	if (isEditMode)
	{
		var altText = '<xlat:stream key="dvin/AT/Common/Removefromlist" escape="true" encode="false" />';
		var statusText = '<xlat:stream key="dvin/AT/Common/Removefromlist" escape="true" />';
	
		var s = dojo.create("span", {}, div);
		
		var a = dojo.create("a", {onclick: funcToRun}, s);
	
		dojo.create("img", { className: "segRemoveImage", src: "js/fw/images/ui/ui/engage/DeleteOff.png",
					        	title: altText, alt: altText, 							  
					        	onmouseover: _removeCellOver, 
					        	onmouseout: _removeCellOut
				   }, a);
	}
	else
	{
		dojo.create("img", { className: "segRemoveImage", height: "16px", width: "1px", src: '<%=ics.GetVar("cs_imagedir")+"/graphics/common/screen/dotclear.gif"%>' }, div);
	}
}

function findActiveRow(obj)
{
	var row = {};	

	while (obj && !dojo.hasClass(obj, "segRow"))
		obj = obj.parentElement;
	
	row.rowDiv = obj;

	var rows = dojo.query('.segRow', 'ruleSetDiv' );
	
	for (var nRow = 0; nRow < rows.length; nRow++)
	{
		if (rows[nRow] === obj)
		{
			row.row = nRow;
			break;
		}
	}	
	
	return row;
}

function findActiveCell(obj)
{
	var cell = {};	
	
	while (obj && !dojo.hasClass(obj, "segCell"))
		obj = obj.parentElement;
	
	if (obj)
	{
		var row = findActiveRow(obj);

		cell.cellDiv = obj;
		cell.rowDiv = row.rowDiv;
		cell.row = row.row;
		
		var cells = dojo.query('.segCell', row.rowDiv );
		
		for (var nCol = 0; nCol < cells.length; nCol++)
		{
			if (cells[nCol] === obj)
			{
				cell.col = nCol;
				break;
			}
		}
	}
	
	return cell;
}

function onRemoveCell(evt)
{
	setTabDirty();

	var cell = findActiveCell(evt.target);

	if ( (cell.col == 0 && nvRuleSet.rows[cell.row].cols.length == 1)	// the last/only "real" cell in the row
		  || (nvRuleSet.rows[cell.row].cols.length == 0)				// the dummy cell
	    )
	{
		removeRow(cell);
		
		if (nvRuleSet.rows.length == 0)
		{
			doAddRow();
			
			var link = dojo.byId("segToolsToggle");
			var isOn = dojo.hasClass(link, 'segToolsOn');
			
			if (!isOn)
			{	// special case to handle delete of last row when "show tools" is already off 
				var divs = dojo.query(".segAdder", 'ruleSetDiv');

				for (var d = 0; d < divs.length; d++) 
					dojo.style(divs[d], "display", "none"); 
			}			
		}
		
		return;
	}	
	
	nvRuleSet.rows[cell.row].cols.splice(cell.col, 1);
	
	destroyDiv(cell.cellDiv);
	
	if (cell.col == 0)  // if we just deleted the first cell for this row...
	{					// delete the header of the new first cell (if there is one)
		var headers = dojo.query('.segCellHeader', cell.rowDiv );
		
		if (headers.length > 0)
			dojo.destroy(headers[0]);
	}
}

function removeRow(row)
{
	nvRuleSet.rows.splice(row.row, 1);
	
	destroyDiv(row.rowDiv);
	
	if (row.row == 0) // if we just deleted the first row for this ruleset...
	{					// clean up the header for the new first row
		var headers = dojo.query('.segRowHeader', 'ruleSetDiv' );
		
		if (headers.length > 0)
			dojo.destroy(headers[0]);
	}
}

function renderCell(cellDiv, data)
{
	var cell = findActiveCell(cellDiv);

	if (dojo.hasClass(cellDiv, "segCellDummy"))
	{
		if (nvRuleSet.rows[cell.row].cols.length > 0)
		{
			dojo.create("div", {className: "segCellHeader"}, cellDiv);
			renderCellHeader(cellDiv);
		}	
	}
	else
	if (cell.col > 0)
	{
		dojo.create("div", {className: "segCellHeader"}, cellDiv);
		renderCellHeader(cellDiv);
	}
	
	dojo.create("div", {className: "segCellBody clearfix segRound"}, cellDiv);
	renderCellBody(cellDiv, data);
}

function renderCellBody(cellDiv, data)
{
	var cellBodyDiv = dojo.query('.segCellBody', cellDiv)[0];

	if (data.RULETYPE == 'scalar')
		renderScalarCell(cellBodyDiv, data);
	else
	if (data.RULETYPE == 'cart')
		renderCartCell(cellBodyDiv, data);
	else
	if (data.RULETYPE == 'history')
		renderHistoryCell(cellBodyDiv, data);
	else
	if (data.RULETYPE == 'dummy')
		renderDummyCell(cellBodyDiv, data);
}

function _adderMouseOver (evt)
{
//	dojo.attr(evt.target, 'src', 'js/fw/images/ui/ui/engage/AddHover.png'); 
	return true;
}

function _adderMouseOut (evt)
{
	dojo.attr(evt.target, 'src', 'js/fw/images/ui/ui/engage/AddOff.png'); 
	return true;
}

function renderRowAdder(adderDiv)
{
	var a = dojo.create("a", {onclick: onAddRow}, adderDiv);

	var altText = '<xlat:stream key="dvin/AT/Segments/CellANDAdder" escape="true" encode="false"/>'; 
	
	dojo.create("img", {className: "segAdderIcon", src: "js/fw/images/ui/ui/engage/AddOff.png",
        			title: altText, alt: altText, border: "0",
        			onmouseover: _adderMouseOver, onmouseout: _adderMouseOut
        	    }, a);
	
	dojo.create("div", {className: "segAdderLabel"}, a).innerHTML = '<xlat:stream key="dvin/AT/Segments/CellANDAdder" escape="true" encode="false" />';
}

function changeEyeState (obj, bShow)
{
	var cell = findActiveCell(obj);
	var imgs = dojo.query('.segEyeImage', cell.cellDiv);
	var divs = dojo.query('.segAttPicker', cell.cellDiv);
	
	if (imgs.length > 0)
		dojo.attr(imgs[0], "src", bShow ? "js/fw/images/ui/ui/engage/SuperMenuOn.png" 
										: "js/fw/images/ui/ui/engage/SuperMenuOff.png");

	if (divs.length > 0)
		dojo.style(divs[0], "backgroundColor", bShow ? "#4d6581" : "#dad9d9" );
}

function onShowCellMenu(evt)
{
	var cell = findActiveCell(evt.target);
	
	var divs = dojo.query('.segCellMenu', cell.cellDiv);
	
	if (divs.length == 0)
	{	// show
		divs = dojo.query('.segCellMenu', dojo.byId("ruleSetDiv"));
		
		if (divs.length > 0)
		{
			changeEyeState (divs[0], false);
			destroyDiv(divs[0]);	
		}

		changeEyeState (cell.cellDiv, true);

		dojo.create("div", {className: "segCellMenu"}, cell.cellDiv);
		renderMegaMenu(cell.cellDiv, null);
	}
	else
	{	// hide
		changeEyeState (divs[0], false);
		destroyDiv(divs[0]);
	}
}

function renderMegaMenu(cellDiv, data)
{
	var cellMenuDiv = dojo.query('.segCellMenu', cellDiv)[0];
	
	tidyWidgets(cellMenuDiv);
	
	/*
	 * A simple click event handler.
	 */
	var clickHandler = function(evt) {
		evt.stopPropagation(); 
		evt.preventDefault(); 
		onMegaMenuClick(evt);
	}

	var panels = [];
	var panel = {columns: []};
	var column = {};
	var nCol = 0;
	
	var NUMROWS = 12;
	var NUMCOLS = 3;
	
	// Visitor Attributes
	
	for (var cat=0; cat < visitorData.categories.length; cat++)
	{
		var category = visitorData.categories[cat];
		
		column = {title: category.name, items: [], hideScrollArrows: true, hideScrollbars: true};

		var nAtt = 0;
		for (var att=0; att < category.attributes.length; att++)
		{
			if (category.attributes[att].type != 'blob')	// prevent use of binary attributes in these rules
			{
				column.items.push({text: category.attributes[att].desc, onclick: clickHandler, id: "scalar_" + cat + "_" + att});
				
				if ((nAtt+1) % NUMROWS == 0)
				{
					panel.columns.push(column);
					nCol++;
	
					if (nCol % NUMCOLS == 0)
					{
						panels.push(panel);
						panel = {columns: []};
						column = {title: category.name, items: [], hideScrollArrows: true, hideScrollbars: true};	// restate the header if we add a panel	
					}					
					else
						column = {title: "", items: [], hideScrollArrows: true, hideScrollbars: true};
				}
				
				nAtt++;
			}
		}

		if (column.items.length > 0)
		{			
			panel.columns.push(column);
			nCol++;
		}
		
		if (nCol % NUMCOLS == 0 && panel.columns.length > 0)
		{
			panels.push(panel);
			panel = {columns: []};	
		}
	}
	
	// HISTORY Definitions
	
	for (var cat=0; cat < historyData.categories.length; cat++)
	{
		var category = historyData.categories[cat];
		
		column = {title: category.name, items: [], hideScrollArrows: true, hideScrollbars: true};

		for (var att=0; att < category.attributes.length; att++)
		{
			column.items.push({text: category.attributes[att].desc, onclick: clickHandler, id: "history_" + cat + "_" + att});
			
			if ((att+1) % NUMROWS == 0)
			{
				panel.columns.push(column);
				nCol++;

				if (nCol % NUMCOLS == 0)
				{
					panels.push(panel);
					panel = {columns: []};
					column = {title: category.name, items: [], hideScrollArrows: true, hideScrollbars: true};	// restate the header if we add a panel	
				}					
				else
					column = {title: "", items: [], hideScrollArrows: true, hideScrollbars: true};
			}
		}

		if (column.items.length > 0)
		{			
			panel.columns.push(column);
			nCol++;
		}
		
		if (nCol % NUMCOLS == 0 && panel.columns.length > 0)
		{
			panels.push(panel);
			panel = {columns: []};	
		}
	}

	// Shopping Cart
	
	column = {title: "Cart", items: [], hideScrollArrows: true, hideScrollbars: true};
	column.items.push({text: '<xlat:stream key="dvin/AT/Segments/ShoppingCart" escape="true" encode="false" />', onclick: clickHandler, id: 'cart_0_0'});
	panel.columns.push(column);
	
	// close it out...
	
	if (panel.columns.length > 0)
		panels.push(panel);
	
	var slideWizard = new fw.ui.dijit.SlideWizard({ panels: panels });
	dojo.style(slideWizard.domNode, {margin:'5px 2px 0px 2px', height:'320px'});
	slideWizard.placeAt(cellMenuDiv);
	slideWizard.startup();
}

function renderCellAdder(adderDiv) 
{
	var a = dojo.create("a", {onclick: onAddDummyCell}, adderDiv);
	
	var altText = '<xlat:stream key="dvin/AT/Segments/CellORAdder" escape="true" encode="false" />';
	
	dojo.create("img", {className: "segAdderIcon", src: "js/fw/images/ui/ui/engage/AddOff.png",
        			title: altText, alt: altText, border: "0",
	       			onmouseover: _adderMouseOver, onmouseout: _adderMouseOut
    		   }, a);
	
	dojo.create("span", {className: "segAdderLabel"}, a).innerHTML = '<xlat:stream key='dvin/AT/Segments/CellORAdder' escape="true" encode="false" />';
}

function renderRow(rowDiv)
{
	var row = findActiveRow(rowDiv);	
	
	if (row.row != 0)
	{
		dojo.create("div", {className: "segRowHeader"}, rowDiv);
		renderRowHeader(rowDiv);
	}
	
	var cols = nvRuleSet.rows[row.row].cols;
	
	for (var col = 0; col < cols.length; col++)
	{
		var data = nvRuleSet.rows[row.row].cols[col];
		var cellDiv = dojo.create("div", {className: "segCell"}, rowDiv);
		renderCell(cellDiv, data);
	}

	if (isEditMode)
	{
		var cellAdderDiv = dojo.create("div", {className: "segAdder segCellAdder segRound"}, rowDiv);
		renderCellAdder(cellAdderDiv);
	}
}

function renderRuleSet()
{
	var ruleSetDiv = dojo.byId("ruleSetDiv");
	
	tidyWidgets(ruleSetDiv);	
	ruleSetDiv.innerHTML = "";
	
	for (var row = 0; row < nvRuleSet.rows.length; row++)
	{
		var rowDiv = dojo.create("div", {className: "segRow"}, ruleSetDiv);
		renderRow(rowDiv);
	}

	if (isEditMode)
	{
		var rowAdderDiv = dojo.create("div", {className: "segAdder segRowAdder segRound"}, ruleSetDiv);
		renderRowAdder(rowAdderDiv);
		
		if (nvRuleSet.rows.length == 0)
			doAddRow()
	}
}

function getRuleSetText()
{
	var nRows = nvRuleSet.rows.length;
	var str = "NUMAND=" + nRows + ",";		// top level prop 1
	
	if (nRows > 0)
	{
		for (var row = 0; row < nRows; row++)
		{
			str += 'ANDCLAUSE' + row + '=';
			
			var cols = nvRuleSet.rows[row].cols;
			var nCols = cols.length;
			
			str += 'NUMCOL=' + nCols + '%,';
				
			if (nCols > 0)
			{	
				for (var col = 0; col < nCols; col++)
				{
					str += 'ORCLAUSE'  + col + '=';
					
					var cell = cols[col];
					for (var name in cell)
					{
						if (name == 'catIndex' || name == 'attIndex' || name == 'assets' || name == 'constraints')
							continue;
						
						var text = cell[name];

						if (text && text.indexOf('%') >= 0)
							text = text.replace(/%/g, "%%%%%%%%");
						
						if (text && text.indexOf(',') >= 0)
							text = text.replace(/,/g, "%%%%%%%,");
						
						str += name + '=' + text + '%%%,';	// leaf item
					}

					if (cell.assets)
					{
						str += 'NUMASSETS=' + cell.assets.length + '%%%,';
						
						for (var index = 0; index < cell.assets.length; index++)						
						{
							str += 'ASSETKEY' + index + '=' + row + '_' + col + '_ASSETKEY' + index + '%%%,';						
						}
					}
					
					if (cell.constraints)
					{
						str += 'HNUMCONSTR=' + cell.constraints.length + '%%%,';

						for (var index = 0; index < cell.constraints.length; index++)						
						{
							str += 'HCONSTRFIELD' + index + '=' + cell.constraints[index].name + '%%%,';
							str += 'HCONSTRTYPE' + index + '=' + cell.constraints[index].type + '%%%,';	
							
							if (cell.constraints[index].type == "assetattr")
							{
								if (cell.constraints[index].assettype && cell.constraints[index].assettype != null)
									str += 'HCONSTRASSETTYPE' + index + '=' + cell.constraints[index].assettype + '%%%,';
								
//								if (cell.constraints[index].attrkey && cell.constraints[index].attrkey != null)
//									str += 'HCONSTRATTRKEY' + index + '=' + cell.constraints[index].attrkey + '%%%,';

								if (cell.constraints[index].assettype && cell.constraints[index].assettype != null
									 && cell.constraints[index].assetattribute && cell.constraints[index].assetattribute != null)
								{
									str += 'HCONSTRATTRKEY' + index + '=' + cell.constraints[index].assettype + ":" + cell.constraints[index].assetattribute + '%%%,';
								}
							}

							str += 'HNUMCONSTRVALUE' + index + '=' + cell.constraints[index].values.length + '%%%,';						

							for (var val=0; val < cell.constraints[index].values.length; val++)
							{
								if (cell.constraints[index].type == "assetattr")
								{
									str += 'HCONSTRKEY' + index + '-' + val + '=' + row + "_" + col + "_HCONSTRKEY" + index + '-' + val + '%%%,';						
								}
								else
								{
									str += 'HCONSTRVALUE' + index + '-' + val + '=' + cell.constraints[index].values[val].value + '%%%,';						
									str += 'HCONSTRVALTZ' + index + '-' + val + '=' + cell.constraints[index].values[val].valtz + '%%%,';
								}
							}
						}
					}

					str += ';%,'	// end or ORCLAUSE
				}
			}

			str += ';,'	// end or ANDCLAUSE
		}
	}

	for (var name in nvRuleSet)
	{
		if (name != "rows")
		{
			str += name + '=' + nvRuleSet[name] + ',';		// top level scalar prop
		}
	}
	
	str += ';'	// end of outer level
	
	return str;
}

function getRuleSetMapText()
{
	// walk the ruleset and look for "assets" collections
	// dump out key=assetType:assetId values so that I can build a map on the server
	// use the same format as the SegRuleSetHint so that we can load it directly into an nvObject 
	
	var nRows = nvRuleSet.rows.length;
	var str = 'this=<%=ics.GetVar("AssetType")%>:<%=ics.GetVar("id")%>';
	
	if (nRows > 0)
	{
		for (var row = 0; row < nRows; row++)
		{
			var cols = nvRuleSet.rows[row].cols;
			var nCols = cols.length;
			
			if (nCols > 0)
			{	
				for (var col = 0; col < nCols; col++)
				{
					var cell = cols[col];
					if (cell.assets)
					{
						for (var index = 0; index < cell.assets.length; index++)						
						{
							str += ',' + row + '_' + col + '_ASSETKEY' + index + '=';
							str += cell.assets[index].type + ':' + cell.assets[index].id;						
						}
					}
					
					// also, look for history constraint list of asset values
					if (cell.constraints)
					{
						for (var index = 0; index < cell.constraints.length; index++)
						{
							if (cell.constraints[index].type == "assetattr")
							{
								if (cell.constraints[index].values)
								{
									var values = cell.constraints[index].values;
									
									for (var val = 0; val < values.length; val++)
									{
										str += ',' + row + '_' + col + '_HCONSTRKEY' + index + '-' + val + '=';
										str += values[val].type + ':' + values[val].id;						
									}
								}
							}
						}
					}
				}
			}
		}
	}
	
	str += ',;'	// end of nvObject outer level

	return str;
}

function captureRuleSet()
{
	var list = dojo.query("input[name=SegRuleSetHint]");
	
	if (list.length > 0)
		list[0].value = getRuleSetText();
	
	var map = dojo.query("input[name=SegRuleSetMapHint]");
	
	if (map.length > 0)
		map[0].value = getRuleSetMapText();
}

function setFocus(row, col, classname, index)
{
	index = index || 0;

	var rows = dojo.query('.segRow', 'ruleSetDiv');
	var cells = dojo.query('.segCell', rows[row]);
	var cell = cells[col];
	
	var nodes = dojo.query(classname, cell);
	
	if (nodes.length > 0)
	{
		var node = nodes[index];
		var widgets = dijit.findWidgets(node);
		
		if (widgets.length > 0)
		{
			var widget = widgets[0];
			dijit.focus(widget.focusNode);
		}
	}
}

function validateIsInt(str) 
{
	// strip leading zeroes to prevent false negative
	while (str.charAt(0) == '0' && str.length > 1) str = str.substr(1);
	var i = parseInt(str);
	if (isNaN(i))
		return false;
	i = i.toString();
	if (i != str)
		return false;
	return true;
}

function validateIsPositiveInt(str) 
{
	if (!validateIsInt(str)) 
		return false;
	
	if (parseInt(str) < 0) 
		return false;
	
	return true;
}

// check if the string is a 'short'  (16-bit signed)
function validateIsShort(str)
{
 	if(validateIsInt(str))
 	{
  		var n = parseInt(str);
  		if (n >= -32768 && 32767 >= n)
   			return true;
		else 
	 		return false; 
 	}
 	
	return false; 
}

// check if the string is an 'integer'  (32-bit signed)
function validateIsInteger(str)
{
 	if(validateIsInt(str))
 	{
  		var n = parseInt(str);
  		if (n >= -2147483648 && 2147483647 >= n)
   			return true;
		else 
	 		return false; 
 	}
  	return false; 
}

// to check if the string is a 'long'	(64-bit signed)
function validateIsLong(str)
{
	if (validateIsInt(str)) 
	{
		var n = parseInt(str);
		if (n >= -9223372036854775808 && 9223372036854775807 >= n)
			return true;
		else 
			return false; 
	}

	return false; 
}

// to check if the string is 'money'
function validateIsMoney( str)
{
    return /^[0-9]+(,[0-9]{3})*(\.[0-9]{1,3})?$/.test(str);
}

<!-- to check if the string is a 'float'!-->
function validateIsFloat(str)
{
    return /^[-+]?\d*((\.\d+)([eE][-+]?\d+)?)?$/.test(str);
}

function validateBlankValues(row, col, data)
{
	var msg = '<xlat:stream key="dvin/AT/Segments/fieldcantbeblank" escape="true" encode="false"/>';
	
	if ((data.VALUE || "") == "")
	{
		alert(msg);
		setFocus(row, col, ".segValue");		
		return false;
	}
	
	if (data.COMPAREOP == "bt" && (data.HIGHVALUE || "") == "")
	{
		alert(msg);
		setFocus(row, col, ".segHighValue");		
		return false;
	}
	
	return true;
}

function validateAttribute(row, col, data)
{
	var msg = '<xlat:stream key="dvin/AT/Segments/fieldcantbeblank" escape="true" encode="false"/>';

	if (data.attIndex == -1)
	{
		alert(msg);
		setFocus(row, col, ".segAttPicker");		
		return false;
	}
	
	return true;
}

function validateIntValues(row, col, data, msg)
{
	// 
	msg = msg || "<xlat:stream key="dvin/AT/Common/specifyvalueasINTEGER" escape="true" encode="false"/>";
	
	if (!validateIsInt(data.VALUE))
	{
		alert(msg);
		setFocus(row, col, ".segValue");
		return false;
	}

	if (data.COMPAREOP == "bt" && !validateIsInt(data.HIGHVALUE))
	{
		alert(msg);
		setFocus(row, col, ".segHighValue");
		return false;
	}
	
	return true;
}

function validateShortValues(row, col, data)
{	
	// 16 bit signed -32768 to 32767 
	
	if (!validateIntValues(row, col, data, '<xlat:stream key="dvin/AT/Common/specifySHORTINTEGER" escape="true" encode="false"/>'))
		return false;
	
	var msg = '<xlat:stream key="dvin/AT/Common/specifySHORTINTEGER" escape="true" encode="false"/>';
	
	if (!validateIsShort(data.VALUE))
	{
		alert(msg);
		setFocus(row, col, ".segValue");
		return false;
	}

	if (data.COMPAREOP == "bt" && !validateIsShort(data.HIGHVALUE))
	{
		alert(msg);
		setFocus(row, col, ".segHighValue");
		return false;
		
		// do range checks here too?
	}
	
	return true;
}

function validateIntegerValues(row, col, data)
{
	// 32 bit signed -2147483648 to 2147483647 	
	
	if (!validateIntValues(row, col, data, '<xlat:stream key="dvin/AT/Common/specifyvalueasINTEGER" escape="true" encode="false"/>'))
		return false;
	
	var msg = '<xlat:stream key="dvin/AT/Common/specifyvalueasINTEGER" escape="true" encode="false"/>';
	
	if (!validateIsInteger(data.VALUE))
	{
		alert(msg);
		setFocus(row, col, ".segValue");
		return false;
	}

	if (data.COMPAREOP == "bt" && !validateIsInteger(data.HIGHVALUE))
	{
		alert(msg);
		setFocus(row, col, ".segHighValue");
		return false;
	}
	
	return true;
}


function validateLongValues(row, col, data)
{
	// 64 bit signed -9223372036854775808 to 9223372036854775807 	
	
	if (!validateIntValues(row, col, data, '<xlat:stream key="dvin/AT/Common/specifyLONGINTEGER" escape="true" encode="false"/>'))
		return false;	
	
	// if this is really a LONG integer - then the range check error message is bogus
	var msg = '<xlat:stream key="dvin/AT/Common/specifyLONGINTEGER" escape="true" encode="false"/>';
	
	if (!validateIsLong(data.VALUE))
	{
		alert(msg);
		setFocus(row, col, ".segValue");
		return false;
	}

	if (data.COMPAREOP == "bt" && !validateIsLong(data.HIGHVALUE))
	{
		alert(msg);
		setFocus(row, col, ".segHighValue");
		return false;
	}
	
	return true;
}

function validateFloatValues(row, col, data)
{
	var msg = '<xlat:stream key="dvin/AT/Common/specifyvalueasFLOAT" escape="true" encode="false"/>';
	
	if (!validateIsFloat(data.VALUE))
	{
		alert(msg);
		setFocus(row, col, ".segValue");
		return false;
	}

	if (data.COMPAREOP == "bt" && !validateIsFloat(data.HIGHVALUE))
	{
		alert(msg);
		setFocus(row, col, ".segHighValue");
		return false;
	}
	
	return true;
}

function validateTimeValues(row, col, data)
{
	var msg = '<xlat:stream key="dvin/UI/Common/PleaseEnterDateInFormat" escape="true" encode="false"/>';
	
	if (!validateIsInt(data.VALUE))
	{
		alert(msg);
		setFocus(row, col, ".segValue");
		return false;
	}

	if (data.COMPAREOP == "bt" && !validateIsInt(data.HIGHVALUE))
	{
		alert(msg);
		setFocus(row, col, ".segHighValue");
		return false;
	}
	
	return true;
}

function validateMoneyValues(row, col, data)
{
 	var msg = '<xlat:stream key="dvin/AT/Common/specifyvalidmoneyvalue" escape="true" encode="false"/>';
 	
 	if (!validateIsMoney(data.VALUE))
 	{
 		alert(msg);
 		setFocus(row, col, ".segValue");
 		return false;
 	}

 	if (data.COMPAREOP == "bt" && !validateIsMoney(data.HIGHVALUE))
 	{
 		alert(msg);
 		setFocus(row, col, ".segHighValue");
 		return false;
 	}
 	
 	return true;
}
 
function validateIntegerRange(row, col, data, theAtt)
{
	if (theAtt.constraint.type == "range")
	{
		var start = parseInt(theAtt.constraint.start);
		var end = parseInt(theAtt.constraint.end);
		
		if (!isNaN(start) && !isNaN(end))
		{
			var value = parseInt(data.VALUE);

			var msg = '<xlat:stream key="dvin/AT/Segments/mustbebetween" escape="true" encode="false"/>';
			msg = msg.replace('Variables.beginvalue', start);
			msg = msg.replace('Variables.endvalue', end);
			
			if (value < start || value > end)
			{
				alert(msg);
				setFocus(row, col, ".segValue");
				
				return false;	
			}
			
			if (data.COMPAREOP == "bt")
			{
				value =  parseInt(data.HIGHVALUE);							

				if (value < start || value > end)
				{
					alert(msg);
					setFocus(row, col, ".segHighValue");
					return false;	
				}
			}
		}
	}
	
	return true;
}

function validateFloatRange(row, col, data, theAtt)
{
	if (theAtt.constraint.type == "range")
	{
		var start = parseFloat(theAtt.constraint.start);
		var end = parseFloat(theAtt.constraint.end);
		
		if (!isNaN(start) && !isNaN(end))
		{
			var value = parseFloat(data.VALUE);

			var msg = '<xlat:stream key="dvin/AT/Segments/mustbebetween" escape="true" encode="false"/>';
			msg = msg.replace('Variables.beginvalue', start);
			msg = msg.replace('Variables.endvalue', end);
			
			if (value < start || value > end)
			{
				alert(msg);
				setFocus(row, col, ".segValue");
				
				return false;	
			}
			
			if (data.COMPAREOP == "bt")
			{
				value =  parseInt(data.HIGHVALUE);							

				if (value < start || value > end)
				{
					alert(msg);
					setFocus(row, col, ".segHighValue");
					return false;	
				}
			}
		}
	}
	
	return true;
}

function validateTimeRange(row, col, data, theAtt)
{
	if (theAtt.constraint.type == "range")
	{
		// trim Visitor Attributes to remove the "nano" ".s" value - hack?
		var startDate = dojo.date.locale.parse(theAtt.constraint.start.substr(0,19), {selector: 'date', datePattern: 'yyyy-MM-dd HH:mm:ss' });		
		var endDate = dojo.date.locale.parse(theAtt.constraint.end.substr(0,19), {selector: 'date', datePattern: 'yyyy-MM-dd HH:mm:ss' });		
		
		var start = startDate.getTime();
		var end = endDate.getTime()
		
		if (!isNaN(start) && !isNaN(end))
		{
			var value = parseInt(data.VALUE);

			var msg = '<xlat:stream key="dvin/AT/Segments/mustbebetween" escape="true" encode="false"/>';
			msg = msg.replace('Variables.beginvalue', startDate.toString());
			msg = msg.replace('Variables.endvalue', endDate.toString());
			
			if (value < start || value > end)
			{
				alert(msg);
				setFocus(row, col, ".segValue");
				
				return false;	
			}
			
			if (data.COMPAREOP == "bt")
			{
				value =  parseInt(data.HIGHVALUE);							

				if (value < start || value > end)
				{
					alert(msg);
					setFocus(row, col, ".segHighValue");
					return false;	
				}
			}
		}
	}
	
	return true;
}

function validateScalarCell(row, col, data)
{
	// simple checks
		
	if (!validateBlankValues(row, col, data))
		return false;

	if (!validateAttribute(row, col, data))
		return false;
	
	// type based validity checks

	var theAtt = visitorData.categories[data.catIndex].attributes[data.attIndex];

	if (theAtt)
	{
		switch (theAtt.type)
		{
			case "short":	// 16 bit
			{
				if (!validateShortValues(row, col, data))
					return false;
				
				if (!validateIntegerRange(row, col, data, theAtt))
					return false;
			}
			break;
		
			case "int":		// 32 bit
			{
				if (!validateIntegerValues(row, col, data))
					return false;

				if (!validateIntegerRange(row, col, data, theAtt))
					return false;
			}
			break;
			
			case "long":	// 64 bit
			{
				if (!validateLongValues(row, col, data))
					return false;
				
				if (!validateIntegerRange(row, col, data, theAtt))
					return false;
			}
			break;
			
			case "double":
			{
				if (!validateFloatValues(row, col, data))
					return false;
				
				if (!validateFloatRange(row, col, data, theAtt))
					return false;
			}
			break;
	
			case "money":
			{
				if (!validateMoneyValues(row, col, data))
					return false;
				
				if (!validateFloatRange(row, col, data, theAtt))
					return false;
			}
			break;
			
			case "timestamp":
			{
				if (!validateTimeValues(row, col, data))
					return false;
				
				if (!validateTimeRange(row, col, data, theAtt))
					return false;
			}
			break;
	
			default:
			{
				
			}
			break;
		}
	}
	
	// logical checks 
	if (data.COMPAREOP == "bt")
	{
		
		
	}
	
	return true;
}

function validateCartCell(row, col, data)
{
	// simple checks
	
	if (!validateBlankValues(row, col, data))
		return false;
	
	// type based validity checks
	
	if (data.ASSETOP == 'value')
	{
		if (!validateMoneyValues(row, col, data))
			return false;
	}
	else
	{
		if (!validateIntValues(row, col, data))
			return false;
	}
	
	return true;
}

function validateHistoryCell(row, col, data)
{
	// simple checks
	
	if (!validateBlankValues(row, col, data))
	return false;

	if (!validateAttribute(row, col, data))
		return false;
		
	// type based validity checks - type is (mostly) dependant on other picks...
	
	if (data.HOP == 'sum')
	{
		var fields = historyData.categories[data.catIndex].attributes[data.attIndex].fields; 
		
		var compOpType = "";
		
		for (var i = 0; i < fields.length; i++)
		{
			var fType = fields[i].type;
			
			if (fields[i].name == data.HFIELD)
				compOpType = fType;
		}

		switch (compOpType)
		{
			case "short":	// 16 bit
			{
				if (!validateShortValues(row, col, data))
					return false;
			}
			break;
		
			case "int":		// 32 bit
			{
				if (!validateIntegerValues(row, col, data))
					return false;
			}
			break;
			
			case "long":	// 64 bit
			{
				if (!validateLongValues(row, col, data))
					return false;
			}
			break;
			
			case "double":
			{
				if (!validateFloatValues(row, col, data))
					return false;
			}
			break;
	
			case "money":
			{
				if (!validateMoneyValues(row, col, data))
					return false;
			}
			break;
			
			default:
			{
				
			}
			break;
		}
	}
	else
	if (data.HOP == 'count')
	{
		if (!validateIntValues(row, col, data))
			return false;
	}
	else
	if (data.HOP == 'first' || data.HOP == 'last')
	{
		if (!validateTimeValues(row, col, data))
			return false;
	}
	
	if (data.HDATEOP == 'relative')
	{
		var msg = '<xlat:stream key="dvin/AT/Segments/fieldcantbeblank" escape="true" encode="false"/>';
		
		if ((data.HINTERVAL || "") == "")
		{
			alert(msg);
			setFocus(row, col, ".segHInterval");		
			return false;
		}
		
		msg = '<xlat:stream key="dvin/AT/Common/specifyvalueasINTEGER" escape="true" encode="false"/>';
		
		if (!validateIsInt(data.HINTERVAL))
		{
			alert(msg);
			setFocus(row, col, ".segHInterval");
			return false;
		}
	}
	
	return true;
}

function validateRuleCell(row, col, data)
{
	if (data.RULETYPE == 'scalar')
	{
		if (!validateScalarCell(row, col, data))
			return false;
	}
	else
	if (data.RULETYPE == 'cart')
	{
		if (!validateCartCell(row, col, data))
			return false;
	}
	else
	if (data.RULETYPE == 'history')
	{	
		if (!validateHistoryCell(row, col, data))
			return false;
	}
	
	return true;
}

function validateRuleSet()
{	
	// do validation of the RuleSet
	// return true if it passes
	// return false and set focus to the relevant control if there is a problem.
	
	for (var row = 0; row < nvRuleSet.rows.length; row++)
	{
		var cols = nvRuleSet.rows[row].cols;
		
		for (var col = 0; col < cols.length; col++)
		{
			if (!validateRuleCell(row, col, cols[col]))
				return false;
		}
	}

	return true;
}
	
dojo.addOnLoad(renderRuleSet);

</script>	

</cs:ftcs>