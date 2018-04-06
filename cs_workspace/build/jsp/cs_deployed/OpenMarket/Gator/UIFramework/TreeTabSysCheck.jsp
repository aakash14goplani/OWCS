<%@page import="com.openmarket.xcelerate.treetab.TreeTabConstants"%>
<%@page import="java.util.*"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><cs:ftcs>
<%
boolean flag = false;
for(String tab : TreeTabConstants.SystemTabs)
{
	if(("CSSystem:TreeTabs:"+tab).equals(ics.GetVar("tabuid")))
	{
		flag = true;
		break;
	}
}
%>
<ics:setvar name="systab" value='<%=String.valueOf(flag)%>' /></cs:ftcs>