<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%//
// fatwire/ui/controller/readConfiguration
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
<%
String elementName= ics.GetVar("configElementName");
if(elementName!=null)
	{
%>
	<ics:callelement element="<%=elementName%>"/>	  
<%
	}
%>
</cs:ftcs>