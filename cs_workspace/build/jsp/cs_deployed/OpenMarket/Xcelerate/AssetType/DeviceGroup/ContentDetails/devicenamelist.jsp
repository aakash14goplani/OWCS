<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/DeviceGroup/ContentDetails/devicenamelist
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
<string:encode variable="fieldvalue" varname="fieldvalue"/>
<script>
	function isDeviceNamesEmpty()
	{
		var deviceNames  = new String(dojo.string.trim('<%=ics.GetVar("fieldvalue")%>'));
		if(deviceNames && deviceNames.length != 0)
		{
			return false;
		}
		return true;
	}
</script>
<div name="criteriaSectionDeviceName" class="capabilities-section" style="border : 1px solid #d9d7d3;border-radius: 4px; padding-top: 5px;padding-bottom: 5px;padding-left: 10px;padding-right: 10px; width: 599px">
<%
String filters = ics.GetVar("fieldvalue");
if(filters  != null)
{		
		String[] filterList = filters.trim().split(";");	
		if(filterList != null && filterList.length == 1 && filterList[0].isEmpty())
		{
			%>
			<span class="disabledText"><xlat:stream key="UI/Forms/NotApplicable"/></span>
			<%
		}
		else if(filterList != null && filterList.length > 0)
		{
		%>			
			<table border="0">
			<%
			for(int i = 0;i<filterList.length;i++)
			{
				%>
				<tr><td><%=filterList[i]%></td></tr>
				<%
			}%>
			</table>
		<%
		} 
		else
		{
			%>
			<span class="disabledText"><xlat:stream key="UI/Forms/NotApplicable"/></span>
			<%
		}
}
else
{
	%>
	<span class="disabledText"><xlat:stream key="UI/Forms/NotApplicable"/></span>
	<%
}
%>
</div>

</cs:ftcs>