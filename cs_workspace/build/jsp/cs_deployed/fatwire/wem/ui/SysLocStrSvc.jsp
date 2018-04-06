<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ page import="COM.FutureTense.Interfaces.ICS"%>

<%--
fatwire/wem/ui/SysLocStrSvc

This element implements a JSON service for retrieving SystemLocaleStrings from
Content Server.

INPUT
key1,key2,...keyN: the names of SLS keys to look up.

OUTPUT
Outputs a JSON string representing an object with the requested keys mapped
to their obtained values.
NOTE that this service does NOT filter "Missing ..." locale strings, this will
be the job of the JS implementation so that it can do what it wants (i.e.
perhaps a console.warn for failed lookups on the client side).
NOTE also that this service doesn't bother to be smart about duplicate lookups
within the same request - it's expected that the JS implementation will be
smart about this instead.

Note that the code here is rather deliberately laid out to avoid whitespace
sneaking into the values.  I suppose I could've also avoided this by using
xlat:lookup for the gruntwork and just getting the variable later, but I
figured it's easy enough to get right for streaming to avoid the excess.

@author KGF
--%>

<cs:ftcs>
<%
ics.StreamHeader("Access-Control-Allow-Origin", "*");
%>
{<%
String [] keys = request.getParameterValues("keys");
boolean first = true;
for(String key : keys) {
	if (first) {
		first = false;
	} else {
		%>,<% //output comma to delimit multiple properties in the JSON
	}
	%>"<string:stream value='<%=key %>'/>" : <string:encode varname="key" value="<%=key%>"/>"<xlat:stream key='<%=ics.GetVar("key")%>' encode="false" escape="true" evalall="false"/>"<%
}%>}</cs:ftcs>
