<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="controller" uri="futuretense_cs/controller.tld" %>
<cs:ftcs>
<div id="viewContainer_<ics:getvar name="viewId" />" dojoType="dijit.layout.BorderContainer">
	<controller:callelement elementname="UI/Layout/CenterPane/Toolbar" responsetype="html">
		<controller:argument name="showRefresh" value="true" />
	</controller:callelement>
	
	<div id='contentPane_<ics:getvar name="viewId" />' dojoType="dijit.layout.ContentPane" region="center" class="searchContainer fwGridContainer commonViewPane">
		<controller:callelement elementname="UI/Data/Search/AdvancedSearchForm" />
	</div>
</div>
</cs:ftcs>