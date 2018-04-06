<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="property" uri="futuretense_cs/property.tld" %>
<%//
// FatWire/Analytics/AddPerformanceIndicatorGraph
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

<!-- user code here -->
<property:get param="analytics.enabled" inifile="futuretense_xcel.ini" varname="analyticsEnabled"/>
<property:get param="analytics.piurl" inifile="futuretense_xcel.ini" varname="piurl"/>

<%
String enabled = ics.GetVar("analyticsEnabled");
if( !enabled .equalsIgnoreCase("true") )
{
  return;
}

String assetID =  ics.GetVar("AssetId");
String assetType= ics.GetVar("AssetType");
String sitename = ics.GetVar("sitename");;
String target = ics.GetVar("piurl") + "?objid=" + assetID + "&objtype=" + assetType + "&sitename=" + sitename;
%>
<img src="<%=target%>" />
</cs:ftcs>
