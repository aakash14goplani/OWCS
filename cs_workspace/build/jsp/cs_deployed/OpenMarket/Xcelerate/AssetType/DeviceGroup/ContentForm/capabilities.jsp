<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/DeviceGroup/ContentForm/capabilities
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
<script>
var FIELD_SEPARATOR=";";
function isCapabilitiesEmpty()
{
return (dijit.byId("touchId").value == "d" && dijit.byId("JSSupportId").value == "d" && dijit.byId("dualOId").value == "d" && dijit.byId("isTabletId").value == "d");
}

function prepareCapabilitiesForSave()
{
	var field = document.getElementById('<%=fieldname%>');
	if(field)
	{
		var value="";
		if(dijit.byId("touchId"))
			value=value+'touchSupport='+dijit.byId("touchId").get('value')+FIELD_SEPARATOR;
	
		if(dijit.byId("JSSupportId"))
			value=value+'JSSupport='+dijit.byId("JSSupportId").get('value')+FIELD_SEPARATOR;
	
		if(dijit.byId("dualOId"))
			value=value+'dualOrientationSupport='+dijit.byId("dualOId").get('value')+FIELD_SEPARATOR;
	
		if(dijit.byId("isTabletId"))
			value=value+'tabletSupport='+dijit.byId("isTabletId").get('value')+FIELD_SEPARATOR;
		
		field.value=value;
	}
}

function loadCapabilities()
{
	var capabilitylist  = new String( '<%=org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(ics.GetVar("fieldvalue"))%>');
	if(capabilitylist)
	{
		var capabilities  = new String(capabilitylist.split(FIELD_SEPARATOR));
		if(capabilities)
		{
		   		var caps = capabilities.split(",");
				if(dijit.byId("touchId") && caps[0])
				{
				 	var touchSupport = new String(caps[0]);
					dijit.byId("touchId").set('value',touchSupport.split('=')[1]);
				}
				
				if(dijit.byId("JSSupportId") && caps[1])
				{
					var jsSupport = new String(caps[1]);
					dijit.byId("JSSupportId").set('value',jsSupport.split('=')[1]);
				}
			
				if(dijit.byId("dualOId") && caps[2])
				{
					var dualSupport = new String(caps[2]);
					dijit.byId("dualOId").set('value',dualSupport.split('=')[1]);
				}
			
				if(dijit.byId("isTabletId") && caps[3])
				{
					var tabletSupport = new String(caps[3]);
					dijit.byId("isTabletId").set('value',tabletSupport.split('=')[1]);
				}
		}
	
	}
}

function makeCategoryReadOnly(){
	var categoryField = '<%=ics.GetVar("AssetType")%>'+':'+"category";
	if(document.getElementById(categoryField))
		document.getElementById(categoryField).setAttribute("readonly","true");
}
</script>

<xlat:lookup key="dvin/Common/Yes" varname="yesOption" />
<xlat:lookup key="dvin/Common/No" varname="noOption" />
<xlat:lookup key="dvin/UI/MobilitySolution/Capabilities/dontEvaluate" varname="dontEvaluate" />
<xlat:lookup key="dvin/UI/MobilitySolution/SkinSaveErrdMSg" varname="failMsg" />
<xlat:lookup key="dvin/UI/MobilitySolution/SkinSaveErrdMSg" varname="failMsg" />


<div name="criteriaSection" class="capabilities-section" style="border : 1px solid #d9d7d3;border-radius: 4px; padding: 8px;">
<style>
	.capabilities-section .attribute {
		width: 20%;
		text-align: right;
		padding-right: 10px;
		white-space: nowrap;
	}
</style>
    <div>
    <table width="100%">
    <tr>
    <td class="attribute">
<xlat:stream key="dvin/UI/MobilitySolution/Capabilities/TouchScreen" />:
    </td>
     <td>
<select data-dojo-type="fw.dijit.UISimpleSelect" id="touchId" >
 <option value="y"><string:stream variable='yesOption' /></option>
  <option value="n"><string:stream variable="noOption" /></option>
  <option value="d" selected="selected"><string:stream variable="dontEvaluate" /></option>
</select>
    </td>
    </tr>
    <tr>
    <td class="attribute">
<xlat:stream key="dvin/UI/MobilitySolution/Capabilities/JavaScript" />:
    </td>
     <td>
<select data-dojo-type="fw.dijit.UISimpleSelect" id="JSSupportId">
  <option value="y"><string:stream variable='yesOption' /></option>
  <option value="n"><string:stream variable="noOption" /></option>
  <option value="d" selected="selected"><string:stream variable="dontEvaluate" /></option>
</select>
    </td>
    </tr>
    <tr>
    <td class="attribute">
<xlat:stream key="dvin/UI/MobilitySolution/Capabilities/DualOrientation" />:
    </td>
     <td>
<select data-dojo-type="fw.dijit.UISimpleSelect" id="dualOId">
  <option value="y"><string:stream variable='yesOption' /></option>
  <option value="n"><string:stream variable="noOption" /></option>
  <option value="d" selected="selected"><string:stream variable="dontEvaluate" /></option>
</select>
    </td>
    </tr>
    <tr>
 <td class="attribute">
<xlat:stream key="dvin/UI/MobilitySolution/Capabilities/isTablet" />:
    </td>
     <td>
<select data-dojo-type="fw.dijit.UISimpleSelect" id="isTabletId">
  <option value="y"><string:stream variable='yesOption' /></option>
  <option value="n"><string:stream variable="noOption" /></option>
  <option value="d" selected="selected"><string:stream variable="dontEvaluate" /></option>
</select>
    </td>
    </tr>
    </table>
     
    </div>
</div>
<input type="hidden" id='<%=fieldname%>' name='<%=fieldname%>'>

</cs:ftcs>