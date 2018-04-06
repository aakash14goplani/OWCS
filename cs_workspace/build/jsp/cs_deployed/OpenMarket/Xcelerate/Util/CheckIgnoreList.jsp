<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Util/CheckIgnoreList
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
<%@ page import="java.util.*"%>
<cs:ftcs>

<%
	
	/*	
		The purpose of this element is check if for a given asset type and attribute name, should the Start menu screen show the 
		attribute in the list of default values.	
	
		If the attribute name does not have the given asset type in the to-be-ignored list, then this element does not do anything.
		If not it sets an ICS variable ignoreCurrentAttribute to indicate to the OpenMarket/Xcelerate/Util/GetAssetFields element
		
		The ics object "masterIgnoreList" is a Map<String, List> containing the set of attributes and the list assets for which they must be 
		disabled in their corresponding start menu items.
		This object is created and is set in ICS Scope from within the element OpenMarket/Xcelerate/Util/CreateStartMenuItemIgnoreList.jsp
				
	*/
	
	Map<String, List<String>> masterIgnoreList = (Map<String, List<String>>) ics.GetObj("masterIgnoreList");
	
	String assetType = ics.GetVar("AssetType");
	String attributeName = ics.GetVar("AttrName");
	
	if(assetType != null && attributeName != null)
	{
		List<String> assetTypeList = masterIgnoreList.get(attributeName);		
		if(assetTypeList != null && assetTypeList.contains(assetType))
			ics.SetVar("ignoreCurrentAttribute","true");		
	}
%>
</cs:ftcs>