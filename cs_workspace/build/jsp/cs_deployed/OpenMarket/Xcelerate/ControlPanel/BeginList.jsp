<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%//
// OpenMarket/Xcelerate/ControlPanel/BeginList
//
// INPUT
//
// OUTPUT
//%><cs:ftcs><%
String parentid = ics.GetVar("parentid");
String cssstyle = ics.GetVar("style");
%>
<SPAN id="<%=parentid%>"<% if (cssstyle != null) { %> STYLE="<%=cssstyle%>"<% } %>>
</cs:ftcs>