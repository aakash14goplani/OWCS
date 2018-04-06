<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/CSClient/Util/TimestampToJDBCDate
//
// INPUT
//  cs_InDate
//  Variables.cs_OutDate
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
java.util.GregorianCalendar gc = new java.util.GregorianCalendar();
gc.setTimeInMillis( Long.parseLong(ics.GetVar("cs_InDate")) ); 

ics.SetVar(ics.GetVar("cs_OutDate"), Utilities.sqlDate(gc));
%>
</cs:ftcs>