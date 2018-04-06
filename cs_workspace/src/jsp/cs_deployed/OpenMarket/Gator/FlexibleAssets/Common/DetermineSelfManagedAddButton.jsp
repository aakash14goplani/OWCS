<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Gator/FlexibleAssets/Common/DetermineSelfManagedAddButton
//	
// This determines if the attribute type creates its own ADD button or rely on reposted ADD button.
// The default attribute editors will have empty AttributeType and they are also considered in the list. 
//
// INPUT
// AttributeType - The attribute type / attribute editor applied to a flex attribute.
//
// OUTPUT
// isSelfManagedAddButton = true implies that the attribute editor manages its own ADD button.
// isSelfManagedAddButton = false imples that the default ADD button is required.
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>

<%
	ics.SetVar("isSelfManagedAddButton", "false");

	if ("TEXTAREA".equals(ics.GetVar("AttributeType")) || 
		"CKEDITOR".equals(ics.GetVar("AttributeType")) || 
		"FCKEDITOR".equals(ics.GetVar("AttributeType")) || 
		"IMAGEPICKER".equals(ics.GetVar("AttributeType")) ||
		"IMAGEEDITOR".equals(ics.GetVar("AttributeType")) ||
		"DATEPICKER".equals(ics.GetVar("AttributeType")) ||
		"UPLOADER".equals(ics.GetVar("AttributeType")) ||
		// This empty condition is to identify default attribute editors.
		"".equals(ics.GetVar("AttributeType"))) 
	{
		ics.SetVar("isSelfManagedAddButton", "true");
	} 
%>

</cs:ftcs>