<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Util/GetImagePath
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
	/*
		This utility is used to retrieve the full path to the images directory that holds the
		icons for the individual asset types. This is used in the approval dependents screen.
		This element is invoked from 
		OpenMarket/Xcelerate/Actions/AssetMgt/TileMixedAssets
		OpenMarket/Xcelerate/Actions/AssetMgt/TileHeldAssets
	*/
	String realPath = application.getRealPath("Xcelerate/OMTree/TreeImages/AssetTypes");
	ics.SetVar("realPath",realPath);
%>
</cs:ftcs>
