<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/DeviceGroup/ContentDetails/capabilities
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
<xlat:lookup key="UI/UC1/JS/NotProvided" varname="NotProvided" />
<xlat:lookup key="dvin/Common/Yes" varname="yesOption" />
<xlat:lookup key="dvin/Common/No" varname="noOption" />
<xlat:lookup key="dvin/UI/MobilitySolution/Capabilities/dontEvaluate" varname="dontEvaluate" />
<script>
var FIELD_SEPARATOR=";";

function getOptionsMap()
{
	var optionsMap = new Array();
	optionsMap['y'] = '<%=ics.GetVar("yesOption")%>';
	optionsMap['n'] = '<%=ics.GetVar("noOption")%>';
	optionsMap['d'] = '<%=ics.GetVar("dontEvaluate")%>';
	return optionsMap;
}

function createCapabilityTextNode(option)
{
	var node;
	var optionsMap = getOptionsMap();
	if(option == 'd' || !isDeviceNamesEmpty())
	{
		node = document.createElement('span');
		node.setAttribute('class', 'disabledText');
		node.innerHTML  = optionsMap[option];
	}
	else
	 	node = document.createTextNode(optionsMap[option]);
	return  node;
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
				if(dojo.byId("touchId") && caps[0])
				{
				 	var touchSupport = new String(caps[0]);
				 	node = createCapabilityTextNode(touchSupport.split('=')[1]);
				 	dojo.byId("touchId").appendChild(node);
				}

				if(dojo.byId("JSSupportId") && caps[1])
				{
					var jsSupport = new String(caps[1]);
					node = createCapabilityTextNode(jsSupport.split('=')[1]);
					dojo.byId("JSSupportId").appendChild(node);
				}
			
				if(dojo.byId("dualOId") && caps[2])
				{
					var dualSupport = new String(caps[2]);
					node = createCapabilityTextNode(dualSupport.split('=')[1]);
					dojo.byId("dualOId").appendChild(node);
				}
				if(dojo.byId("isTabletId") && caps[3])
				{
					var tabletSupport = new String(caps[3]);
					node = createCapabilityTextNode(tabletSupport.split('=')[1]);
					dojo.byId("isTabletId").appendChild(node);
				}
		}
	
	}
}

</script>

<xlat:lookup key="dvin/Common/Yes" varname="yesOption" />
<xlat:lookup key="dvin/Common/No" varname="noOption" />
<xlat:lookup key="dvin/UI/MobilitySolution/Capabilities/dontEvaluate" varname="dontEvaluate" />

<body>
<script>
dojo.addOnLoad(function() {
	loadCapabilities();
	loadScreenDimensions();
}
);
</script>
<style>
	.capabilities-section .attribute {
		width: 20%;
		text-align: right;
		padding-right: 10px;
		white-space: nowrap;
	}
</style>
<div name="criteriaSection" class="capabilities-section" style="border : 1px solid #d9d7d3;border-radius: 4px; padding: 8px;">
    <div>
    <table width="100%">
    <tr>
    <td class="attribute">
<xlat:stream key="dvin/UI/MobilitySolution/Capabilities/TouchScreen" />:
    </td>
     <td id="touchId">
    </td>
    </tr>
    <tr>
    <td class="attribute">
<xlat:stream key="dvin/UI/MobilitySolution/Capabilities/JavaScript" />:
    </td>
     <td id="JSSupportId">
    </td>
    </tr>
    <tr>
    <td class="attribute">
<xlat:stream key="dvin/UI/MobilitySolution/Capabilities/DualOrientation" />:
    </td>
     <td id="dualOId">
    </td>
    </tr>
    <tr>
 <td class="attribute">
<xlat:stream key="dvin/UI/MobilitySolution/Capabilities/isTablet" />:
    </td>
     <td id="isTabletId">
    </td>
    </tr>
    </table>
     
    </div>
</div>
</body>
</cs:ftcs>