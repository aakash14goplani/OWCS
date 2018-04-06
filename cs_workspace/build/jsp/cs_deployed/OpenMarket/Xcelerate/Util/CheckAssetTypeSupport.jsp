<%@page import="java.util.List"%>
<%@page import="java.util.concurrent.ConcurrentHashMap"%>
<%@page import="com.fatwire.composition.slots.SlotsManager"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@ page import="com.fatwire.assetapi.util.AssetUtil"%>
<%@ page import="com.openmarket.xcelerate.asset.AssetType"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%
	//
	// OpenMarket/Xcelerate/Util/CheckAssetTypeSupport
	//
	// INPUT
	//
	// OUTPUT
	//
%>

<cs:ftcs>

<%!
    List<String> restricedAssetTypes = Arrays.asList("AttrTypes","FW_Application","FW_View","CSElement","Template","SiteEntry","Dimension","DimensionSet","PageDefinition","DeviceGroup","Device","WebRoot");
	List<String> restricedAssetTypesForSearch = Arrays.asList("AttrTypes","FW_Application","FW_View","Template","Dimension","DimensionSet","PageDefinition","DeviceGroup","Device","SitePlan","WebRoot");
	List<String> specialSupportedTypes = Arrays.asList("FSIIVisitorAttr","FSIIVisitorDef");
%>

	<%
		//Remove the old value
		ics.RemoveVar("isSupported");
		ics.RemoveVar("isSearchable");
		String assetType = ics.GetVar("assettype");
		
		if (("status".equals(ics.GetVar("function")) && "ContentDetailsFront".equalsIgnoreCase(ics.GetVar("ThisPage"))) 
				|| (SlotsManager.SLOTTYPENAME.equals(assetType) && "ucform".equals(ics.GetVar("cs_environment"))))
			{
				ics.SetVar("isSupported", "false");
				ics.SetVar("isSearchable", "false");
			}
			else
			{
				AssetType type = AssetType.Load(ics, assetType);
				if (type != null)
				{
					boolean isFlexDef = AssetUtil.isFlexDef(ics, assetType);
					boolean isFlexFilter = AssetUtil.isFlexFilter(ics, assetType);
					boolean isFlexAttr = AssetUtil.isFlexAttribute(ics, assetType);
					boolean isFlexPDef = AssetUtil.isFlexParentDef(ics, assetType);
					boolean isRestrictedAssetTypes = restricedAssetTypes.contains(assetType);
					boolean isRestrictedAssetTypesForSearch = restricedAssetTypesForSearch.contains(assetType);
					boolean isRestrictedFlex = isFlexAttr || isFlexDef || isFlexPDef || isFlexFilter;
					if (isRestrictedFlex || isRestrictedAssetTypes)
					{
						ics.SetVar("isSupported", "false");
					}
					else
					{
						//Reset the previously set value
						ics.SetVar("isSupported", "true");
					}
					
					// 	for disabling the marketing tab in Advanced UI when we set advancedUI.enableAssetForms=false,
					//	we need to make isSupported true for these "FSIIVisitorAttr" and "FSIIVisitorDef"
					if(specialSupportedTypes.contains(assetType)){
						ics.SetVar("isSupported", "true");
					}
					
					if (isRestrictedFlex || isRestrictedAssetTypesForSearch)
					{
						ics.SetVar("isSearchable", "false");
					}
					else
					{
						//Reset the previously set value
						ics.SetVar("isSearchable", "true");
					}
				}
			}
	%>
</cs:ftcs>