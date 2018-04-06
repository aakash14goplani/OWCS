<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/DeviceGroup/ContentForm/screendimensions
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
<%
String fieldname=ics.GetVar("AssetType")+":"+ics.GetVar("fieldname");
%>
 
<xlat:lookup key="dvin/UI/MobilitySolution/ScreenDimensions/minWidthNonNumeric" varname="minWidthNonNumeric" />
<xlat:lookup key="dvin/UI/MobilitySolution/ScreenDimensions/maxWidthNonNumeric" varname="maxWidthNonNumeric" />
<xlat:lookup key="dvin/UI/MobilitySolution/ScreenDimensions/minHeightNonNumeric" varname="minHeightNonNumeric" />
<xlat:lookup key="dvin/UI/MobilitySolution/ScreenDimensions/maxHeightNonNumeric" varname="maxHeightNonNumeric" />
<xlat:lookup key="fatwire/admin/devicegroup/dimensionMinMaxWidth" varname="dimensionMinMaxWidth" />
<xlat:lookup key="fatwire/admin/devicegroup/dimensionMinMaxHeight" varname="dimensionMinMaxHeight" />

<script>
var FIELD_SEPARATOR=";";

function isDimensionsEmpty()
{
return  ( new String(document.getElementById("minwidth").value).length == 0 && new String(document.getElementById("maxwidth").value).length == 0 && new String(document.getElementById("minheight").value).length == 0 && new String(document.getElementById("maxheight").value).length == 0 );
}

function prepareScreenDimensionsForSave()
{
var field = document.getElementById('<%=fieldname%>');
if(field)
{
var value="";
if(document.getElementById("minwidth") && new String(document.getElementById("minwidth").value).length > 0)
value=value+document.getElementById("minwidth").value;
value=value+FIELD_SEPARATOR;

if(document.getElementById("maxwidth") && new String(document.getElementById("maxwidth").value).length > 0)
value=value+document.getElementById("maxwidth").value;
value=value+FIELD_SEPARATOR;

if(document.getElementById("minheight") && new String(document.getElementById("minheight").value).length > 0)
value=value+document.getElementById("minheight").value;
value=value+FIELD_SEPARATOR;

if(document.getElementById("maxheight") && new String(document.getElementById("maxheight").value).length > 0)
value=value+document.getElementById("maxheight").value;

field.value = value;
}

}


function isDimensionValid()
{

	if(document.getElementById("minwidth") && new String(document.getElementById("minwidth").value).length > 0)
	{
	var minWidth = new String(document.getElementById("minwidth").value);
	if(minWidth < 0 || isNaN(minWidth))
	 {
	   alert('<%=ics.GetVar("minWidthNonNumeric")%>'); 
	   return false;
	  }
	}

	if(document.getElementById("maxwidth") && new String(document.getElementById("maxwidth").value).length > 0)
	{
	var minWidth = new String(document.getElementById("maxwidth").value);
	if(minWidth < 0 || isNaN(minWidth))
	 {
	   alert('<%=ics.GetVar("maxWidthNonNumeric")%>'); 
	   return false;
	  }
	}

	if(document.getElementById("minheight") && new String(document.getElementById("minheight").value).length > 0)
	{
	var minWidth = new String(document.getElementById("minheight").value);
	if(minWidth < 0 || isNaN(minWidth))
	 {
	   alert('<%=ics.GetVar("minHeightNonNumeric")%>'); 
	   return false;
	  }
	}

	if(document.getElementById("maxheight") && new String(document.getElementById("maxheight").value).length > 0)
	{
	var minWidth = new String(document.getElementById("maxheight").value);
	if(minWidth < 0 || isNaN(minWidth))
	 {
	   alert('<%=ics.GetVar("maxHeightNonNumeric")%>'); 
	   return false;
	  }
	}

	if(document.getElementById("minwidth") && new String(document.getElementById("minwidth").value).length > 0 && document.getElementById("maxwidth") && new String(document.getElementById("maxwidth").value).length > 0)
	{
	var minwidth = parseInt(document.getElementById("minwidth").value);
	var maxWidth = parseInt(document.getElementById("maxwidth").value);
		if (minwidth > maxWidth)
		{
		  alert('<%=ics.GetVar("dimensionMinMaxWidth")%>');
		  return false;
		}
	}

	if(document.getElementById("minheight") && new String(document.getElementById("minheight").value).length > 0 && document.getElementById("maxheight") && new String(document.getElementById("maxheight").value).length > 0)
	{
	var minHeight = parseInt(document.getElementById("minheight").value);
	var maxHeight = parseInt(document.getElementById("maxheight").value);
		if (minHeight > maxHeight)
		{
		  alert('<%=ics.GetVar("dimensionMinMaxHeight")%>');
		  return false;
		}
	}


	return true;
}



function loadScreenDimensions(){
var fieldValue = new String( '<%=org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(ics.GetVar("fieldvalue"))%>');

if(fieldValue)
{
var values = fieldValue.split(FIELD_SEPARATOR);


if(document.getElementById("minwidth") && values[0])
document.getElementById("minwidth").value=values[0];

if(document.getElementById("maxwidth") && values[1])
document.getElementById("maxwidth").value=values[1];

if(document.getElementById("minheight") && values[2])
document.getElementById("minheight").value=values[2];

if(document.getElementById("maxheight") && values[3])
document.getElementById("maxheight").value=values[3];
}
}
</script>

<div name="criteriaSection" class="dimensions-section" style="border : 1px solid #d9d7d3;border-radius: 4px; padding: 8px;" >
<style>
	.dimensions-section .attribute {
		width: 25%;
		text-align: right;
		padding-right: 10px;
		white-space: nowrap;
	}
	.fw .capabilities-section .UIComboBox {
		width: 278px;
	}
</style>
    <div  >
      <table width="80%">
 <tr>
<td class="attribute">
<xlat:stream key="dvin/UI/MobilitySolution/ScreenDimensions/minWidth" />:
</td>
<td>
<input type="text" name="minwidth" id="minwidth" size="10" style = "width : 278px; fontSize: 12px; height: 18px; color: rgb(51,51,51); padding-left : 3px"/>
</td>
</tr>

 <tr>
<td class="attribute">
<xlat:stream key="dvin/UI/MobilitySolution/ScreenDimensions/maxWidth" />:
</td>
<td>
<input type="text" name="maxwidth" id="maxwidth" size="10" style = "width : 278px; fontSize: 12px; height: 18px; color: rgb(51,51,51); padding-left : 3px"/>
</td>
</tr>

 <tr>
<td class="attribute">
<xlat:stream key="dvin/UI/MobilitySolution/ScreenDimensions/minHeight" />:
</td>
<td>
<input type="text" name="minheight" id="minheight" size="10" style = "width : 278px; fontSize: 12px; height: 18px; color: rgb(51,51,51); padding-left : 3px"/>
</td>
</tr>

 <tr>
<td class="attribute">
<xlat:stream key="dvin/UI/MobilitySolution/ScreenDimensions/maxHeight" />:
</td>
<td>
<input type="text" name="maxheight" id="maxheight" size="10" style = "width : 278px; fontSize: 12px; height: 18px; color: rgb(51,51,51); padding-left : 3px"/>
</td>
</tr>
</table>

  
    </div>
	
<input type="hidden" id='<%=fieldname%>' name='<%=fieldname%>'>

</cs:ftcs>