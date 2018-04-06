<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Gator/AttributeTypes/DeleteTempObjectIds
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="com.openmarket.xcelerate.interfaces.ITempObjects" %>
<%@ page import="com.openmarket.xcelerate.interfaces.TempObjectsFactory" %>
<cs:ftcs>
<%
	try {
		String toDeleteTempId = ics.GetVar("toDeleteTempObjId");
		ITempObjects tempObjects = TempObjectsFactory.make(ics);
		if (Utilities.goodString(toDeleteTempId) && tempObjects.isValid(toDeleteTempId))
			tempObjects.deleteTempObject(toDeleteTempId);
	}
	catch (Exception e) {
		// Add Logger
	}
%>
</cs:ftcs>