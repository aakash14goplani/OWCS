<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%//
// OpenMarket/Xcelerate/Util/HandleAssetTypeOperations
//
// INPUT - currentAssetType. An Asset Type name.
//
// OUTPUT - Sets the variables for showing/hiding different operations on the 'currentAssetType' node. If an Asset Type name is found to be in operations no show array, that operation will
//          not be shown as children of this asset type in Admin Tree, Asset Type node.It gives operation level flexibility to show/hide, as not all operation are for all assets. 
//%>



<cs:ftcs>
<%!
boolean isOpNotAllowed(ICS ics, String currentAssetType, String[] notAllowedAssetTypes, String outVar)
{
  for(String assetType : notAllowedAssetTypes)
   if(assetType.equalsIgnoreCase(currentAssetType))
      {
	    if(Utilities.goodString(outVar))
	    ics.SetVar(outVar,"no");
		
		return true;		
	  }
	return false;
}
%>
<asset:getassettypeproperties
      type='<%=ics.GetVar("currentAssetType")%>'/>
<%
ics.RemoveVar("showCategory");
ics.RemoveVar("showSubTypes");
ics.RemoveVar("showAssociation");
ics.RemoveVar("showTracking");
ics.RemoveVar("showStartMenu");
ics.RemoveVar("showWebReferencePatterns");

String currentAssetType = ics.GetVar("currentAssetType");
if(Utilities.goodString(currentAssetType))
{
	//ProxyAssetType can be any name so can't manage a list of asset type names like below. 
	if(Boolean.valueOf(ics.GetVar("IsProxyAssetType"))==true)
	{
		ics.SetVar("showCategory","no");
		ics.SetVar("showSubTypes","no");
		ics.SetVar("showAssociation","no");
		ics.SetVar("showTracking","no");
		ics.SetVar("showStartMenu","yes");
		ics.SetVar("showWebReferencePatterns","yes");
	}
	else
	{
		String[] noCategoryAssetTypes = {"Slots","SitePlan","WebRoot"};  
		isOpNotAllowed(ics,currentAssetType, noCategoryAssetTypes,"showCategory");           
		String[] noSubTypeAssetTypes = {"Slots","SitePlan","WebRoot"};
		isOpNotAllowed(ics,currentAssetType, noSubTypeAssetTypes,"showSubTypes"); 
		String[] noAssociationsAssetTypes = {"Slots","SitePlan","WebRoot"};
		isOpNotAllowed(ics,currentAssetType, noAssociationsAssetTypes,"showAssociation"); 
		String[] nonRevisionTrackedAssetTypes = {"Slots","SitePlan","Device","WebRoot"};
		isOpNotAllowed(ics,currentAssetType, nonRevisionTrackedAssetTypes,"showTracking"); 
		String[] noStartMenuAssetTypes = {"Slots","SitePlan","WebRoot"};
		isOpNotAllowed(ics,currentAssetType, noStartMenuAssetTypes,"showStartMenu");
		String[] noWebReferenceAssetTypes = {"Slots","WebRoot"};
		isOpNotAllowed(ics,currentAssetType, noWebReferenceAssetTypes,"showWebReferencePatterns");
	}	  
	  
}
%>

</cs:ftcs>