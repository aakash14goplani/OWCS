<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Util/CheckForGlobalAssets
//
// Description - A global asset type here means an asset type which is enabled for all sites by default and whose instances too are shared to all the sites.
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
<cs:ftcs>

<%
ics.RemoveVar("isGlobal");
String[] globalAsseTypes = {"DeviceGroup","Device","WebRoot"};
String currentAssetType = ics.GetVar("AssetType");
if(Utilities.goodString(currentAssetType))
{
	for(String assetType : globalAsseTypes)
		  if(currentAssetType.equalsIgnoreCase(assetType))
		      {
			  ics.SetVar("isGlobal","yes");
			  break;
			  }
}

%>

</cs:ftcs>