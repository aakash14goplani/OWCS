<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/DeviceGroup/ContentDetails/screendimensions
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
 <xlat:lookup key="UI/Forms/NotApplicable" varname="NotAvailable"/>
<script>
var FIELD_SEPARATOR=";";

function createResolutionTextNode(value)
{
	var disabled = false;
	var node;
	
	if(!value || dojo.string.trim(value).length == 0)
	{
		value = '<%=ics.GetVar("NotAvailable")%>';
		disabled = true;
	}
	else if(!isDeviceNamesEmpty())
	{
		disabled = true;
	}
	
	if(!disabled)
		node = document.createTextNode(value);
	else
	{
		node = document.createElement('span')
		node.setAttribute('class', 'disabledText');
		node.innerHTML  = value;
	}
	return  node;
}

function loadScreenDimensions(){
	var fieldValue = new String( '<%=org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(ics.GetVar("fieldvalue"))%>');
	var node;
	if(fieldValue)
	{
		var values = fieldValue.split(FIELD_SEPARATOR);
		if(dojo.byId("minwidth"))
		{
			node = createResolutionTextNode(values[0])
			dojo.byId("minwidth").appendChild(node);
		}
		if(dojo.byId("maxwidth"))
		{
			node = createResolutionTextNode(values[1])
			dojo.byId("maxwidth").appendChild(node);
		}
		if(dojo.byId("minheight"))
		{
			node = createResolutionTextNode(values[2])
			dojo.byId("minheight").appendChild(node);
		}
		if(dojo.byId("maxheight"))
		{
			node = createResolutionTextNode(values[3])
			dojo.byId("maxheight").appendChild(node);
		}
		
	}
}
</script>
<style>
	.dimensions-section .attribute {
		width: 25%;
		text-align: right;
		padding-right: 10px;
		white-space: nowrap;
	}
</style>
<div name="criteriaSection" class="dimensions-section" style="border : 1px solid #d9d7d3;border-radius: 4px; padding: 8px;" >
    <div >
	<table width="80%">
		<tr>
			<td class="attribute">
				<xlat:stream key="dvin/UI/MobilitySolution/ScreenDimensions/minWidth" />:
			</td>
			<td id="minwidth">
			</td>
			</tr>
			
		<tr>
			<td class="attribute">
				<xlat:stream key="dvin/UI/MobilitySolution/ScreenDimensions/maxWidth" />:
			</td>
			<td id="maxwidth">
			</td>
		</tr>
			
		<tr>
			<td class="attribute">
			<xlat:stream key="dvin/UI/MobilitySolution/ScreenDimensions/minHeight" />:
			</td>
			<td id="minheight" >
			</td>
			</tr>
			
		<tr>
			<td class="attribute">
			<xlat:stream key="dvin/UI/MobilitySolution/ScreenDimensions/maxHeight" />:
			</td>
			<td id="maxheight">
			</td>
		</tr>
	</table>
    </div>
</div>
</cs:ftcs>