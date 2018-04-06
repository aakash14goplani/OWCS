<%@page import="com.fatwire.assetapi.common.AssetAccessException"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/UIFramework/Util/DetermineDefaultStyleEligibility
//
// This element checks the eligibilty for applying default form style to basic and flex assets
//
// INPUT
//		assettype
// OUTPUT
// 		defaultFormStyle set to true or flase in ics for the given assettype
//
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="com.fatwire.assetapi.util.AssetUtil"%>
<%@ page import="com.openmarket.xcelerate.asset.AssetType"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.concurrent.ConcurrentHashMap"%>
<cs:ftcs>
<%
	String assetType = ics.GetVar("styledassettype");
	if(assetType != null && assetType.trim().length() > 0 && ! (assetType.indexOf(";") > 0) && ! (assetType.indexOf(".") > 0))
	{
		Map<String, Boolean> defaultStyleSupportedAssetTypes = (Map<String, Boolean>) application.getAttribute("defaultStyleSupportedAssetTypes");
		if (defaultStyleSupportedAssetTypes == null)
		{
			defaultStyleSupportedAssetTypes = new ConcurrentHashMap<String, Boolean>();
			application.setAttribute("defaultStyleSupportedAssetTypes", defaultStyleSupportedAssetTypes);
		}
		Boolean isSupported = defaultStyleSupportedAssetTypes.get(assetType);
		// Page is not a basic and flex asset, it is treated as a special asset
		boolean specialAssetTypes = Arrays.asList("Page").contains(assetType);
		if (isSupported != null)
		{
			ics.SetVar("defaultFormStyle", isSupported.toString());
		}
		else
		{
			// handle the exception so that if some how asset type is wrong it will not break the flow.
			try
			{
				boolean isFlexAsset = AssetUtil.isFlexAsset(ics, assetType);
				boolean isAMAsset = AssetUtil.isAMAsset(ics, assetType);
		
				// check for default form style
				Boolean defaultFormStyle = Boolean.FALSE;
				if(isFlexAsset || isAMAsset || specialAssetTypes)
				{
					defaultFormStyle = Boolean.TRUE;
				}
				ics.SetVar("defaultFormStyle",defaultFormStyle.toString());
				defaultStyleSupportedAssetTypes.put(assetType, defaultFormStyle);
			}
			catch(AssetAccessException exception)
			{
				// dont set anythihng we don't bother as the asset type is not correct
			}
		}
		
		if(specialAssetTypes)
		{
			ics.SetVar("defaultFormStyle",Boolean.TRUE.toString());
		}
	}
%>
</cs:ftcs>