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
	// OpenMarket/Xcelerate/Util/CheckTypeForGenerateLink
	//
	// INPUT
	//
	// OUTPUT
	//
%>

<cs:ftcs>

	<%
		//Remove the old value
		ics.RemoveVar("navigateLink");
		String assetType = ics.GetVar("assettype");
		
		if (("status".equals(ics.GetVar("function")) && "ContentDetailsFront".equalsIgnoreCase(ics.GetVar("ThisPage"))) || 
				(SlotsManager.SLOTTYPENAME.equals(assetType) && "ucform".equals(ics.GetVar("cs_environment"))))
			{
				ics.SetVar("navigateLink", "false");
			}
			else
			{
				Map<String, Boolean> supportedAssetTypes = (Map<String, Boolean>) application.getAttribute("supportedAssetTypes");
				if (supportedAssetTypes == null)
				{
					supportedAssetTypes = new ConcurrentHashMap<String, Boolean>();
					application.setAttribute("supportedAssetTypes", supportedAssetTypes);
				}
				Boolean isSupported = supportedAssetTypes.get(assetType);
				if (isSupported != null)
				{
					ics.SetVar("navigateLink", isSupported.toString());
				}
				else
				{
					
					%>
					
					<ics:callelement element="OpenMarket/Xcelerate/Util/CheckAssetTypeSupport">
						<ics:argument name = "assettype" value ='<%=ics.GetVar("assettype")%>'/>
					 </ics:callelement>
					
					<%
					ics.SetVar("navigateLink", ics.GetVar("isSupported"));
					supportedAssetTypes.put(assetType, Boolean.parseBoolean(ics.GetVar("isSupported")));
				}
			}
	%>
</cs:ftcs>