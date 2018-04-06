<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/PrologActions/Publish/AdvPub/PageRegen
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="COM.FutureTense.Cache.CacheHelper" %>
<%@ page import="com.fatwire.cache.ehcache.PageCacheProvider" %>
<%@ page import="com.fatwire.cache.*"%>
<%@ page import="java.util.*"%>
<cs:ftcs>
<%
   String toRegen = ics.GetVar("toregen");
   FTValList params = new FTValList();
   Utilities.getParams(toRegen, params, true);
   String pagename = (String) params.remove("pagename");
   ics.InsertPage(pagename, params);
   PageCachePropagater prop = PageCacheProvider.getCachePropagatorFor("cs-cache");
   prop.propagate(CacheHelper.getCacheKeyFor(ics, pagename, params));
%>
</cs:ftcs>