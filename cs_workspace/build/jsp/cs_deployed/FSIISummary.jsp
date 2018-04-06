<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><cs:ftcs><ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>'   c="Template"/></ics:then></ics:if>
<%-- This template is simply a typeless template that dispatches to the Summary 
     template for the specified asset.  It is used primarily for previewing, 
     demonstration, and debugging. --%>
<render:lookup varname="SummaryVar" key="Summary" />
<render:calltemplate args="c,cid,p,locale" tname='<%=ics.GetVar("SummaryVar")%>' context="" />
</cs:ftcs>