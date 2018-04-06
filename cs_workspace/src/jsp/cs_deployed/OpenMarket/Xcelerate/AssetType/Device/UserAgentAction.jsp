<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/Device/UserAgentAction
//
// INPUT
// 
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors,java.util.*,com.fatwire.cs.core.mobility.*,com.fatwire.cs.core.mobility.device.*,com.fatwire.cs.core.mobility.ServiceLocator" %>
<%@ page import="COM.FutureTense.Util.ftMessage,COM.FutureTense.Mobility.*,COM.FutureTense.Mobility.Device.*"%>
<%@ page import="com.fatwire.cs.core.mobility.device.DeviceGroup" %>
<cs:ftcs>

<ics:removevar name="matchedGroup"/>
<ics:removevar name="matchedDevice"/>
<ics:removevar name="result"/>
<%
String userAgent=ics.GetVar("Device:useragent");
if (userAgent==null)
{
	userAgent=ics.GetVar("useragent");
}
boolean result = true;

if (userAgent!=null)
{
	String matchedDeviceGroup = null,matchedDevice = null;
	DeviceService srv = ServiceLocator.getService("DeviceService", DeviceService.class);
	Device  device = srv.getDevice(userAgent,ics);
	
	if (device != null)
	{
		matchedDevice = device.getCapability(DeviceProperties.MODEL_NAME); //for wurfl
		
		if(matchedDevice == null)   //for default repository
		matchedDevice = device.getId();
		
		ics.SetVar("matchedDevice", matchedDevice);
		
		DeviceGroup group = device.getDeviceGroup();
		if (group != null)
		{
			matchedDeviceGroup = group.getName();
			ics.SetVar("matchedGroup", matchedDeviceGroup);
		}		
	}
	else
		result = false;	
}

ics.SetVar("result", String.valueOf(result));

%>

</cs:ftcs>