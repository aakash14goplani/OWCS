<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>

<cs:ftcs>

<!-- OpenMarket/Xcelerate/AssetType/ScalarVals/ContentFormJavascript -->

<style type="text/css">
	@import url("js/fw/css/ui/Common.css");

	.svRound {
		-webkit-border-radius: 3px;
		-moz-border-radius: 3px;
		border-radius: 3px;
	}

	.clearfix:before, .clearfix:after { content: ""; display: table; }
	.clearfix:after { clear: both; }
	.clearfix { zoom: 1; }

	.svNullAllowedGroup, 
	.svDefaultValueGroup, 
	.svRangeGroup, 
	.svLengthGroup, 
	.svRangeGroup, 
	.svEnumGroup, 
	.svConstraintTypeGroup
	{
		display: none;
	}
	
</style>
	
<script type="text/javascript">

function svShowGroup(group, bShow)
{
	var rows = dojo.query(group);
	
	if (rows)
	{
		for (var i = 0; i < rows.length; i++) 
			dojo.style(rows[i], "display", bShow ? "table-row" : "none");
	}
}

function svShowInline(group, bShow)
{
	var rows = dojo.query(group);
	
	if (rows)
	{
		for (var i = 0; i < rows.length; i++) 
			dojo.style(rows[i], "display", bShow ? "inline" : "none");
	}
}

function svSetWidgetValue(name, value)
{
	var obj = document.forms[0];

	if (obj)
	{
		var widget = dijit.getEnclosingWidget(obj.elements[name]);
		if (widget)
		{
			widget.set('value', value);
		}
	}
}

function svGetFormValue(name)
{
	var obj = document.forms[0];
	var val = "";
	
	if (obj)
		val = obj.elements[name].value;
	
	return val;
}

function svClearEnumList ()
{
	var obj = document.forms[0]; 
	var target = obj.elements['ScalarVals:sMyEnumValues'];

	for (var i = target.options.length; i > 0; i--)
	{
		target.options[i-1] = null;
	}
}

function svRemoveEnumValues ()
{
	var obj = document.forms[0];
	var target = obj.elements['ScalarVals:sMyEnumValues'];

	for (var i = target.options.length; i > 0; i--)
	{
		if (target.options[i-1].selected)
		{
			target.options[i-1] = null;
			setTabDirty();			
		}
	}
}

function svAddEnumValue ()
{
	var obj = document.forms[0];
	
	var src = obj.elements['ScalarVals:myEnumValue'];	
	var target = obj.elements['ScalarVals:sMyEnumValues'];

	// validate the value!!
	
	if (!checkNewEnumData('ScalarVals:type', 'ScalarVals:myEnumValue', 'ScalarVals:length'))
		return;

	var bFound = false;
	
	for (var i = 0; i < target.options.length; i++) 
	{
		if (target.options[i].value == src.value)
		{
			target.options[i].selected = true;		// select the dup if we found one
			bFound = true;
		}
		else
			target.options[i].selected = false;		// deselect everything else
	}
	
	if (!bFound)
	{		
		var newIndex=target.options.length;
		target.options[newIndex] = new Option(src.value, src.value);
		target.options[newIndex].selected=true;
		setTabDirty();		
	}
	
	src.value = "";	
}


function svCaptureData()
{	// helper called at start of save to get data into teh right format for saving
	// right now, all it does is perpetuate the old mechanism where we "select" all the options in the enum list...
	
	var obj = document.forms[0]; // .elements[0];
	var target = obj.elements['ScalarVals:sMyEnumValues'];

	for (var i = target.options.length; i > 0; i--)
	{
		target.options[i-1].selected = true;
	}
}

function svShowControls()
{
	var atype = svGetFormValue('ScalarVals:type');
	svShowGroup (".svLengthGroup", atype == 'string'); 		
	svShowGroup (".svNullAllowedGroup", atype != 'blob');
	
	if (atype == 'blob' || atype == 'boolean')
	{
		svShowGroup (".svConstraintTypeGroup", false);
	}
	else
	{
		var obj = document.forms[0];
		var widget = dijit.getEnclosingWidget(obj.elements['ScalarVals:constrainttype']);
		
		var sel = widget.store.root;
		sel.options.length = 0;
		
		sel.add(new Option('<xlat:stream key="dvin/Common/lowercasenone" />', 'none', false, false));
		
		if (atype != 'string')
			sel.add(new Option('<xlat:stream key="dvin/AT/SVals/range" />', 'range', false, false));
		
		sel.add(new Option('<xlat:stream key="dvin/AT/SVals/enumeration" />', 'enum', false, false));
		
		svShowGroup (".svConstraintTypeGroup", true);
	}

	var nullallowed = svGetFormValue('ScalarVals:nullallowed');
	svShowGroup (".svDefaultValueGroup", nullallowed == 'F');
	
	if (nullallowed == 'F')
	{
		svShowInline (".svDefaultValueTextbox",atype != 'boolean');
		svShowInline (".svDefaultValuePicker", atype == 'boolean');
	}
	
	var constrainttype = svGetFormValue('ScalarVals:constrainttype');	
	svShowGroup (".svRangeGroup", constrainttype == 'range'); 	
	svShowGroup (".svEnumGroup", constrainttype == 'enum'); 	
}

function onChangeType(value)
{
	if (value == this._resetValue)
		return;
	
	if (thisPage == "NewContentFront" || confirm("<xlat:stream key="dvin/AT/SVals/StoredDataWillBeDeleted" escape="true" encode="false"/>"))
	{
		setTabDirty();		
		svSetWidgetValue('ScalarVals:constrainttype', "none");
		
		svSetWidgetValue('ScalarVals:nullallowed', 'T');
		svSetWidgetValue('ScalarVals:defaultval', '');
		
		svSetWidgetValue('ScalarVals:length', '');

		svSetWidgetValue('ScalarVals:lowerrange', '');
		svSetWidgetValue('ScalarVals:upperrange', '');
		svSetWidgetValue('ScalarVals:myEnumValue', '');
		
		svClearEnumList();

		svShowControls();
		
		this._resetValue = value;
	}
	else
	{
		this.reset();
	}
}

function onChangeDefaultAllowed(value)
{
	setTabDirty();	
	
	var atype = svGetFormValue('ScalarVals:type');
	svShowGroup (".svDefaultValueGroup", value == 'F');
	
	svShowInline (".svDefaultValueTextbox",atype != 'boolean');
	svShowInline (".svDefaultValuePicker", atype == 'boolean');
	
	if (atype == 'boolean')
		svSetWidgetValue('ScalarVals:defaultval', 'true');
	else
		svSetWidgetValue('ScalarVals:defaultval', '');
}

function onChangeDefaultValuePicker(value)
{
	setTabDirty();	
	svSetWidgetValue('ScalarVals:defaultval', value);
}

function onChangeConstraint(value)
{
	setTabDirty();		
	
	svClearEnumList();

	svSetWidgetValue('ScalarVals:lowerrange', '');
	svSetWidgetValue('ScalarVals:upperrange', '');
	svSetWidgetValue('ScalarVals:myEnumValue', '');
	
	svShowGroup (".svRangeGroup", value == 'range'); 	// show/hide the Range fields
	svShowGroup (".svEnumGroup", value == 'enum'); 		// show/hide the Enum fields
}
	
dojo.addOnLoad(svShowControls);

</script>	

</cs:ftcs>