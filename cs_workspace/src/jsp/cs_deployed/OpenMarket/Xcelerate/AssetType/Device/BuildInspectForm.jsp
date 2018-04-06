<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/Device/BuildInspectForm
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

<tr>
	<td width="40px"></td>
	
	<td style="padding-left: 10px; padding-right: 10px">
		<div style="color: #3e3e3e;font-weight: bold;white-space: nowrap;"><span><xlat:stream key="fatwire/admin/Resolution" />:</span></div>
	</td>
	
	<ics:callelement  element="OpenMarket/Xcelerate/AssetType/Device/AddDimensionLabel">
		<ics:argument name="field" value="height" />
		<ics:argument name="formfunction" value='<%=ics.GetVar("formfunction")%>'/>
	</ics:callelement >
	
	<td style="padding-left: 10px; padding-right: 10px; border-left: 1px solid #ccc">
		<div style="color: #3e3e3e;font-weight: bold;white-space: nowrap;"><span><xlat:stream key="fatwire/admin/Offset" />:</span></div>
	</td>
	
	<ics:callelement element="OpenMarket/Xcelerate/AssetType/Device/AddDimensionLabel">
		<ics:argument name="field" value="topoffset" />
		<ics:argument name="formfunction" value='<%=ics.GetVar("formfunction")%>'/>
	</ics:callelement>
	
	 <td style="border-left: 1px solid #ccc">
	</td>
	
	<ics:callelement element="OpenMarket/Xcelerate/AssetType/Device/AddDimensionLabel">
		<ics:argument name="field" value="pixelratio" />	
		<ics:argument name="formfunction" value='<%=ics.GetVar("formfunction")%>'/>
	</ics:callelement>
	
</tr>
<tr>
	<td colspan="2"></td>

	<ics:callelement element="OpenMarket/Xcelerate/AssetType/Device/AddDimensionLabel">
		<ics:argument name="field" value="width" />
		<ics:argument name="formfunction" value='<%=ics.GetVar("formfunction")%>'/>
	</ics:callelement>
	
	<td style="border-left: 1px solid #ccc"></td>

	
	<ics:callelement element="OpenMarket/Xcelerate/AssetType/Device/AddDimensionLabel">
		<ics:argument name="field" value="leftoffset" />
		<ics:argument name="formfunction" value='<%=ics.GetVar("formfunction")%>'/>
	</ics:callelement>
	
	<td style="border-left: 1px solid #ccc" colspan="3"></td>
	
</tr>

</cs:ftcs>