<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Gator/AttributeTypes/TYPEAHEAD/TooltipHtml
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

<b>Name</b>: <%= ics.GetVar("dndName") %><br/>
<b>ID</b>: <%= ics.GetVar("dndId") %><br/>
<b>Type</b>: <%= ics.GetVar("dndAssetType") %><br/>
<b>Subtype</b>: <%= ics.GetVar("dndSubtype") %><br/>
---------------------------------------<br/>
<b>Asset Types</b>: <%= ics.GetVar("dndAssetType") %><br/>
<b>Accepted Subtypes</b>: <%= ics.GetVar("acceptedSubtypes") %><br/>
<b>Multiple</b>: <%= ics.GetVar("multiple") %><br/>

</cs:ftcs>