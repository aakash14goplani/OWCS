<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><cs:ftcs><ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>'   c="Template"/></ics:then></ics:if>
<%-- This template is simply a typeless template that dispatches to the Detail 
     template for the specified asset.  It is used primarily for previewing, 
     demonstration, and debugging. --%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<body>
<render:lookup varname="DetailVar" key="Detail" />
<render:calltemplate tname='<%=ics.GetVar("DetailVar")%>' args="c,cid,p,locale" context="" />
</body>
</html>
</cs:ftcs>