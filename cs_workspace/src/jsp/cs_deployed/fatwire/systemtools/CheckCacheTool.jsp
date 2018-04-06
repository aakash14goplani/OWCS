<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// fatwire/systemtools/CheckCacheTool
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
<%@ page import="com.fatwire.cs.systemtools.util.CacheUtil"%>
<cs:ftcs>
<%
	//check if eh cache is enabled.
    ics.SetVar("isPageCacheEnabled",String.valueOf(CacheUtil.isPageCacheEnabled()));
   	//check if asset cache is enabled in cs-cache  
    ics.SetVar("isAssetCacheEnabled",String.valueOf(CacheUtil.isAssetCacheEnabled()));
   	ics.SetVar("isLinkedCacheEnabled", ics.GetProperty("rsCacheOverInCache"));
   	boolean isCacheManagementEnabled = CacheUtil.isCacheManagementEnabled() || Boolean.valueOf(ics.GetProperty("rsCacheOverInCache"));
    ics.SetVar("isCacheManagerEnabled",String.valueOf(isCacheManagementEnabled));
	ics.SetVar("isCasCacheEnabled",String.valueOf(CacheUtil.isCasCacheEnabled()));
	ics.SetVar("isURLCacheEnabled",String.valueOf(CacheUtil.isURLCacheEnabled()));
	
	%>
	
</cs:ftcs>