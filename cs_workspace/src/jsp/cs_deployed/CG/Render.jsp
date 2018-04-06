<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<cs:ftcs>
<ics:callelement element="CG/GetMultiTicket"/>
<ics:callelement element="CG/GetParameters"/>
<%
String element = "CG/" + ics.GetVar("cgAssetType") + "/View";

if (ics.GetVar("rendermode").equals("insite"))
{
	element = "CG/" + ics.GetVar("cgAssetType") + "/Edit";
}
%>
<ics:callelement element='<%=element%>'/>
</cs:ftcs>