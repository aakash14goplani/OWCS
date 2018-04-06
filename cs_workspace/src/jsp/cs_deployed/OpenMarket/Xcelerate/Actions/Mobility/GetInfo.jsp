<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Actions/Mobility/GetInfo
//
// INPUT
//	serviceName - This is the method in MobilityUtil Class which will be called 
//	outVar - Name of the output variable which will be set in ICS scope with value as the output of this element. When variable 'outVar' is not set, default output var name is "result" 
//
// OUTPUT
//	    The output of the method is set to ics variable name stored in input variable 'outVar'(if variable outVar is present in ICS). If outVar absent in ICS scope, default name "result"      will be used for setting output in iCS.
//			 									This could be an object or string as per the return type of the method in use.
//
//	
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="com.fatwire.mobility.util.MobilityUtils"%>
<%@ page import="java.lang.reflect.Method"%>
<%@ page import="java.util.List"%>
<cs:ftcs>

<%
	String serviceName = ics.GetVar("serviceName");
    String outVar = ( Utilities.goodString( ics.GetVar("outVar") ) ? ics.GetVar("outVar") : "result" );
	if ("getDeviceGroups".equals(serviceName)) {
		
		ics.SetObj(outVar, MobilityUtils.getDeviceGroups(ics));
		
	} else if ("getPropertyValues".equals(serviceName)) {
		
		ics.SetVar(outVar, MobilityUtils.getPropertyValues((List) ics.GetObj(ics.GetVar("listOfObjectsVarName")), ics.GetVar("property")));
		
	} else if ("getDefaultDeviceGroup".equals(serviceName)) {
		
		ics.SetVar(outVar, MobilityUtils.DEFAULT_DEVICEGROUP_NAME);
		
	} else if ("getDefaultDeviceImage".equals(serviceName)) {
		
		ics.SetVar(outVar, MobilityUtils.DESKTOP_DEVICEIMAGE_NAME);
		
	}
%>

</cs:ftcs>