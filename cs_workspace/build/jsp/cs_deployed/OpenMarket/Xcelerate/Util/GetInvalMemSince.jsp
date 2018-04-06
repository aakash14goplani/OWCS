<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld" %>
<%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld" %>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld" %>
<%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld" %>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld" %>
<%@ page import="COM.FutureTense.Cache.CacheHelper" %>
<cs:ftcs>
<%
    long since = Long.parseLong(ics.GetVar("TIME"));
    out.print(CacheHelper.getInvalidatedItemsAsStringList(ics, since));
%>
</cs:ftcs>