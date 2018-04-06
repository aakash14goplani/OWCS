<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Util/CheckForTabContainer
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
<%@ page import="com.fatwire.assetapi.util.AssetUtil"%>
<%@ page import="com.openmarket.xcelerate.asset.AssetType"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.concurrent.ConcurrentHashMap"%>
<cs:ftcs>
<%
	String assetType = ics.GetVar("AssetType");
	Map<String, Boolean> requiresBorderContainer = (Map<String, Boolean>) application.getAttribute("bcSupportedAssetTypes");
	if (requiresBorderContainer == null)
	{
		requiresBorderContainer = new ConcurrentHashMap<String, Boolean>();
		application.setAttribute("bcSupportedAssetTypes", requiresBorderContainer);
	}	
	Boolean isRequiredBC= requiresBorderContainer.get(assetType);
	if (isRequiredBC != null)
	{
		ics.SetVar("hasTabContainer", isRequiredBC.toString());
	}
	else
	{
		Boolean hasTabContainer = Boolean.FALSE;
		boolean isAMAsset = false;
		boolean isFlexAsset = false;
		boolean isParentType = false;
		boolean isFlexAttribute = false;
		boolean isFlexDef = false;
		
		AssetType type = AssetType.Load(ics, assetType);
		if (type != null)
		{
			boolean specialAssetTypeWithTab = Arrays.asList("Article","FW_Application","FW_View","Page","Template","CSElement","SiteEntry","Image").contains(assetType);
			
			if(!specialAssetTypeWithTab)
			{
				isParentType = AssetUtil.isParentType(ics, assetType);
				
				if(!isParentType)
				{
					isFlexAsset = AssetUtil.isFlexAsset(ics, assetType);
					if(!isFlexAsset)
					{
						isAMAsset = AssetUtil.isAMAsset(ics, assetType);
					}
				}
				
				if(!isParentType && !isFlexAsset && !isAMAsset){
					isFlexAttribute = AssetUtil.isFlexAttribute(ics, assetType);
					if(!isFlexAttribute)
						isFlexDef = AssetUtil.isFlexDef(ics, assetType);
				}
			}
			
			if (isAMAsset || isFlexAsset || isParentType || specialAssetTypeWithTab || isFlexAttribute || isFlexDef)
			{
				hasTabContainer = Boolean.TRUE;
			}
		}
		requiresBorderContainer.put(assetType, hasTabContainer);
		ics.SetVar("hasTabContainer",hasTabContainer.toString());
	}
%>
</cs:ftcs>