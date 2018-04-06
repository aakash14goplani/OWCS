<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="controller" uri="futuretense_cs/controller.tld" %>

<cs:ftcs>
<div id="viewContainer_<ics:getvar name="viewId" />" data-dojo-type="dijit.layout.BorderContainer" data-dojo-props="'class':'dashBoardContainer'">
	<div data-dojo-type="dijit.layout.ContentPane" data-dojo-props="region:'top'">
		<controller:callelement elementname="UI/Layout/CenterPane/Toolbar" responsetype="html">
			<controller:argument name="showRefresh" value="true" />
		</controller:callelement>
	</div>
	<div id='contentPane_<ics:getvar name="viewId" />' data-dojo-type="dojox.layout.ContentPane" data-dojo-props="region:'center','class':'dashBoardContentPane'">
		<controller:callelement elementname="UI/Layout/CenterPane/DashBoardContents" />
	</div>
</div>
</cs:ftcs>