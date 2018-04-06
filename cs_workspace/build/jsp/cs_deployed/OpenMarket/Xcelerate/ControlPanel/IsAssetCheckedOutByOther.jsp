<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/ControlPanel/isAssetCheckedOutByOther
//
// INPUT
// OUTPUT
//		displays true if checked out by another user, false if not tracked or tracked by current user
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>

<%
    FTValList args = new FTValList();
    args.setValString("ASSETID", ics.GetVar("id"));
    args.setValString("ASSETTYPE", ics.GetVar("AssetType"));
    args.setValString("VARNAME", "checkoutuser");
    ics.runTag("IMPLICITCHECKOUT.IsCheckedOut", args);
%>
<ics:if condition='<%=ics.GetVar("checkoutuser")!=null && !ics.GetVar("checkoutuser").equals(ics.GetVar("username"))%>'>
<ics:then>
true
</ics:then>
<ics:else>
false
</ics:else>
</ics:if>

</cs:ftcs>