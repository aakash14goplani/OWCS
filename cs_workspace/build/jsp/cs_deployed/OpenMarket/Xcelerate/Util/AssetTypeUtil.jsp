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
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   com.fatwire.assetapi.util.AssetUtil,
                   COM.FutureTense.Util.ftErrors"
%><cs:ftcs><%--

INPUT

OUTPUT

--%>
<%

if("complexAsset".equals(ics.GetVar("checkFor")))
	ics.SetVar("isComplexAsset",AssetUtil.isComplexAsset(ics,ics.GetVar("AssetType")) +"");
else if("amAsset".equals(ics.GetVar("checkFor")))
	ics.SetVar("isAMAsset",AssetUtil.isAMAsset(ics,ics.GetVar("AssetType")) +"");
else if("flexAsset".equals(ics.GetVar("checkFor")))
	ics.SetVar("isFlexAsset",AssetUtil.isFlexAsset(ics,ics.GetVar("AssetType")) +"");
%>
</cs:ftcs>
