<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Actions/setDimensionRoot
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="com.openmarket.xcelerate.common.DimParentRelationshipImpl,
com.fatwire.mda.DimensionableAssetInstance.DimensionParentRelationship,
java.util.Map, com.fatwire.mda.DimensionableAssetManager" %>
<cs:ftcs>
<%
    Map IOMap = (Map)request.getAttribute("parameterMap");
    com.fatwire.assetapi.data.AssetId assetid = (com.fatwire.assetapi.data.AssetId)IOMap.get("assetID");

    DimensionableAssetManager dam = new com.openmarket.xcelerate.asset.DimensionableAssetManagerImpl(ics);
    DimensionParentRelationship oldParent = dam.getParent(assetid, "Locale");
    DimensionParentRelationship newParent = new DimParentRelationshipImpl("Locale", assetid); // self
    dam.resetParent(assetid, oldParent, newParent);

%>
</cs:ftcs>