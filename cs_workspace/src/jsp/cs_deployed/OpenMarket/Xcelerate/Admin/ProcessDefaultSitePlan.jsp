<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Xcelerate/Admin/ProcessDefaultSitePlan
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
<%@ page import="com.fatwire.mobility.util.MobilityUtils"%>
<cs:ftcs>

<ics:if condition='<%=Utilities.goodString(ics.GetVar("primarypubid"))%>'>
<ics:then>
<%
try{
MobilityUtils.addDefaultSitePlanForSite(ics,Long.valueOf(ics.GetVar("primarypubid")));
}catch(Exception e)
{
%>
<xlat.stream key="dvin/Common/siteplanerror"/>
<%
}
%>
</ics:then>
</ics:if>

</cs:ftcs>