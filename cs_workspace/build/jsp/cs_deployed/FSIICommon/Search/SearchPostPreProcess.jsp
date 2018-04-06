<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors"
%><cs:ftcs>
<%-- Record dependencies for the SiteEntry and the CSElement --%>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>

<render:lookup key="SearchResultsPage" varname="SearchResultsPage" match=":x" ttype="CSElement"/>
<asset:load name="SearchResultsPage" type="Page" field="name" value='<%=ics.GetVar("SearchResultsPage")%>'/>
<asset:get name="SearchResultsPage" field="id" output="SearchResultsPageId"/>
<%-- Now blow away the old c, cid, p and replace them with our own 

     Note that we don't even have to worry about looking up the localized
     version of the search resutls page because the FSII infrastructure
     (in particular, the layout template) will automatically look up the translation
     for the input c and cid that we're specifying.

     Of course, a translation must provide a translated search results page asset.
     --%>
<ics:setvar name="c" value="Page"/>
<ics:setvar name="cid" value='<%=ics.GetVar("SearchResultsPageId")%>'/>
<%-- that's it! --%>
</cs:ftcs>