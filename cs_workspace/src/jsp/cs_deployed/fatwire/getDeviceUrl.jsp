<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="usermanager" uri="futuretense_cs/usermanager.tld" %>
<%//
// fatwire/getDeviceUrl
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
<cs:ftcs><ics:getproperty name="xcelerate.batchuser" file="futuretense_xcel.ini" output="batchusername"
/><ics:getproperty name="xcelerate.batchpass" file="futuretense_xcel.ini" output="batchpassword"
/><%
String decrypted_password="default";
if (Utilities.cryptoEnabled())
{
  decrypted_password = Utilities.decryptString(ics.GetVar("batchpassword"));
}

%><usermanager:loginuser username='<%=ics.GetVar("batchusername")%>' password='<%=decrypted_password%>'  varname="loggedIn"
/><ics:if condition='<%="true".equalsIgnoreCase(ics.GetVar("loggedIn"))%>'>
   <ics:then><%
        String pagename=ics.GetVar("requestpagename");
        String userAgent=ics.GetVar("userAgent");
		COM.FutureTense.Mobility.DeviceHelper.getDeviceUrl( ics, userAgent );
%><usermanager:logout /></ics:then></ics:if>

</cs:ftcs>