<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/CSClient/setDimensionParent
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
<!-- This element search for the dimension parent of group locale and set the same asset as the parent-->
<%
int iDPTotal = Integer.parseInt(ics.GetVar("source:Dimension-parent:Total"));
for (int i = 0; i < iDPTotal; i++)
{
    String id = ics.GetVar("source:Dimension-parent:"+i+":asset");
    String group = ics.GetVar("source:Dimension-parent:"+i+":group");
	if ("Locale".equalsIgnoreCase(group))
	ics.SetVar("source:Dimension-parent:"+i+":asset", ics.GetVar("dimparentid"));
}
%>

</cs:ftcs>