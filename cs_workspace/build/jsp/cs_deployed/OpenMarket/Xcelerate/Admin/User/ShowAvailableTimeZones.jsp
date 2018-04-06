<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld" %>

<%//
// OpenMarket/Xcelerate/Admin/User/ShowAvailableTimeZones
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
<%@ page import="oracle.fatwire.sites.timezone.util.TimeZoneUtil"%>
<cs:ftcs>

<!-- bug 14403558: for LDAP install certain fields on user profile screen are not supported -->
<%	
String ldapPresent =""; 
if(!ics.GetVar("cs_manageuser").equals(""))
{
	ldapPresent="disabled=\"disabled\"";
} 
%>

<select name="selectedTimezone" size="1" <%=ldapPresent%>>
	<option value="None"> <xlat:stream key='dvin/Common/AutoDetected'/> </option>
	<%
	String prevSelectedTimeZone = ics.GetVar("prevSelectedTimeZone");
	for(String[] item : TimeZoneUtil.getTimeZoneOptions(ics.GetSSVar("locale")))
	{	
		if( item[0].equals(prevSelectedTimeZone) ) {
		%>
		<option value=<%=item[0] %> selected="selected" > <%=item[1]%> </option>
		<%} else { %>		
		<option value=<%=item[0]%> > <%=item[1]%></option>
		<%} 
	}%>
</select>
</cs:ftcs>