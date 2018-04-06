<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Admin/Util/EventDetailTable
//
// INPUT
//
// OUTPUT
//%>
<%-- [KGF]
This element utilizes a Java implementation of some of the
JavaScript functions in EventFront; after much thought, I
decided it'd be better to leave the form alone and do this
for the places we want to spit out the info for chiefly
display purposes.
--%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="com.openmarket.xcelerate.util.TimePatternInfo"%>
<cs:ftcs>
<%
    String sEventTime = ics.GetVar("eventtime");
    if (sEventTime != null)
    {
%><%=TimePatternInfo.getDetailTable(ics, sEventTime)%><%
    }
%>
</cs:ftcs>
