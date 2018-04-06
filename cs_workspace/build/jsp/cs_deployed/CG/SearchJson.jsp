<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@page import="org.codehaus.jettison.json.JSONObject"%>
<cs:ftcs>
<%
JSONObject json = (JSONObject) request.getAttribute("results");
if (json != null)
{
	out.print(json.toString());
}
else
{%>
{identifier:"id", numRows:0, items:[]}
<%}%>
</cs:ftcs>