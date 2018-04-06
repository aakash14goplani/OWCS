<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// UI/Layout/RightNavigationHtml
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
<div id="rightSwitchPanes" data-dojo-type="dijit.layout.ContentPane">
	<div id="dockedSearchContainer" data-dojo-type="dijit.layout.BorderContainer" style="height: 100%; width: 100%; position: absolute; display: none; background: #FFF" data-dojo-props="'class':'dockedSearchContainer', design:'sidebar'">
	</div>
	<div id="deviceContainer" data-dojo-type="dijit.layout.BorderContainer" style="height: 100%; width: 100%; position: absolute; display: none">
		<%-- The top div is a supporting div to show the results just below toolbar so that Search box and toolbar will be visible. --%>
		<div id='devicePaneTop' data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'top'" style="height: 84px; width: 100%; background: #555;"></div>
		<div id='deviceCarousel' data-dojo-type="fw.ui.dijit.insite.Carousel" data-dojo-props="region:'center', isShowScrollIcons: false" style="height: 100%; width: 100%;"></div>
	</div>
</div>
</cs:ftcs>