<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors"
%><cs:ftcs>
<%-- Record dependencies for the Template --%>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>
<%-- The home page is no different than a standard page from a structure 
         perspective, but its layout is quite different when viewed through a 
         style sheet.  To make this possible, the HomeDetail div is labelled here.
         Next, the standard detail view template is called.  It's called using element
         style because there is no need to call it as a pagelet - this pagelet itself
         is cached - the second one would be redundent. --%>
<div id="HomeDetailView">
	<render:lookup key="StandardDetailView" varname="view"/>
	<render:calltemplate tname='<%=ics.GetVar("view")%>' args="c,cid,p,locale" style="element" />
</div>
</cs:ftcs>