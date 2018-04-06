<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Util/CheckAssetTypeForShare
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
ics.RemoveVar("isNonSharable");
String[] nonSharableAssetTypes = {"Page","DeviceGroup","Device"};
String currentAssetType = ics.GetVar("assettype");
if(Utilities.goodString(currentAssetType))
{
for(String assetType : nonSharableAssetTypes)
   if(assetType.equalsIgnoreCase(currentAssetType))
      {
	    ics.SetVar("isNonSharable","yes");
		break;		
	  }
}
%>

</cs:ftcs>