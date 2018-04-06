<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/UIFramework/Util/AddCustomHeader
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
<ics:if condition='<%=ics.IsElement("OpenMarket/Xcelerate/AssetType/" + ics.GetVar("AssetType") + "/Header") == true%>'>
<ics:then>
	<ics:callelement element='<%="OpenMarket/Xcelerate/AssetType/" + ics.GetVar("AssetType") + "/Header"%>'/>
</ics:then>
</ics:if>
</cs:ftcs>