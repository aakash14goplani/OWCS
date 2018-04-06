<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><cs:ftcs>
<%-- The side nav template for an article simply calls the 
     Page's template instead.  For that reason, this template
     will be uncached, but the called template will be cached. --%>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>

<render:lookup key="SideNav" varname="SideNav" />
<render:calltemplate tname='<%=ics.GetVar("SideNav")%>' c="Page" cid='<%=ics.GetVar("p")%>'
					 context="" args="p,locale" />
</cs:ftcs>