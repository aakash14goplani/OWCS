<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// AlloyUI/Tree/loadSitePlanTree
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
<%
	// This element is invoked through URL connection. So get the username and pubid and set
	// to the session.
	ics.SetSSVar("pubid",ics.GetVar("pubid"));
	ics.SetSSVar("username",ics.GetVar("username"));	
%>
<ics:callelement element="OpenMarket/Xcelerate/AssetType/Page/LoadSiteTree">	
</ics:callelement>

</cs:ftcs>
