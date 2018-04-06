<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><cs:ftcs><ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>'   c="Template"/></ics:then></ics:if>
<%-- This template is simply a typeless template that dispatches to the Link 
     template for the specified asset.  It is used primarily for previewing, 
     demonstration, and debugging. --%>
<render:lookup varname="LinkVar" key="Link" />
<render:calltemplate tname='<%=ics.GetVar("LinkVar")%>' args="c,cid,p" context="" />
</cs:ftcs>