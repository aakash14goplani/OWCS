<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   COM.FutureTense.Util.ftErrors"
%><cs:ftcs><%--

INPUT

OUTPUT

--%>

<%
String inputDate = ics.GetVar("inputDate");
String[] ar = inputDate.split("'");	
inputDate = ar[1];
%>
<ics:callelement element="OpenMarket/Xcelerate/Util/ConvertJDBCDateTimeZone">
	<ics:argument name='inputDate' value='<%=inputDate %>'/>
	<ics:argument name='fromTimeZone' value='client'/>
	<ics:argument name='toTimeZone' value='server'/>
</ics:callelement>
<%
String newDate = ics.GetVar("outputDate");
String result = "Oracle".equalsIgnoreCase(ics.GetProperty("cs.dbtype")) ? ar[0] +"'" + newDate +"', '" + ar[3] +"')" : "'"+newDate+"'";
ics.SetVar("outputDate" , result);
%>
</cs:ftcs>
