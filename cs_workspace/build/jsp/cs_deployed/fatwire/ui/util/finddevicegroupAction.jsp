<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// fatwire/ui/util/finddevicegroupAction
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors,java.util.*,com.fatwire.cs.core.mobility.*,com.fatwire.cs.core.mobility.device.*" %>
<%@ page import="COM.FutureTense.Util.ftMessage,COM.FutureTense.Mobility.*,COM.FutureTense.Mobility.Device.*"%>
<cs:ftcs>

<!-- user code here -->
<%
String userAgent=ics.GetVar("agent");
String what=ics.GetVar("what");

if (userAgent!=null && what!=null && what.equalsIgnoreCase("devicegroup"))
{
	DeviceService srv = ServiceLocator.getService("DeviceService", DeviceService.class);
	List<DeviceGroup> groups=srv.getPossibleMatchingDeviceGroups(ics, userAgent);
	if (groups!=null)
	{
		for (DeviceGroup g:groups)
		{
			out.println("<br/>Device Group : "+g.getName());
		}
	}
	else
	{
	out.println("Not devicegroup found");
	}
}
else if (userAgent!=null && what!=null && what.equalsIgnoreCase("device"))
{
	DeviceService srv = ServiceLocator.getService("DeviceService", DeviceService.class);
	Device  device=srv.getDevice(userAgent,ics);
	if (device!=null)
	{
		out.println("Device ID: "+device.getId());
		out.println("<br/>Device ModelName: "+device.getCapability(DeviceProperties.MODEL_NAME));
		out.println("<br/>Device BrandName: "+device.getCapability(DeviceProperties.BRAND_NAME));
		if (device.getDeviceGroup()!=null)
		{
		out.println("<br/>Device GroupName: "+device.getDeviceGroup().getName());
		}
		else
		{
		out.println("<br/>Device GroupName Not found: ");
		}
	}
	else
	{
	out.println("Not device found");
	}
}
%>
<hr/>
</cs:ftcs>