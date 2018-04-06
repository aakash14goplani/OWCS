<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@page import="java.lang.Math"%>
<cs:ftcs>
<%
ics.SetVar("cgManagementContainerId", "managementContainer" + Math.random());
ics.SetVar("cgContainerId", "communityGadgetContainer" + Math.random());
%>
<div id="<ics:getvar name="cgManagementContainerId"/>"></div>
<div id="<ics:getvar name="cgContainerId"/>"></div>
<script type="text/javascript">
cos = window.cos || {};
cos.sites = cos.sites || {};
cos.sites.assets =  cos.sites.assets || [];

cos.sites.assets['<ics:getvar name="cid"/>'] = {
	assetType: '<ics:getvar name="cgAssetType"/>',	
	tagName: '<ics:getvar name="cgTagName"/>',
	tagVersion: '<ics:getvar name="cgTagVersion"/>',
	siteName: '<ics:getvar name="cgSiteName"/>',
	containerId : '<ics:getvar name="cgManagementContainerId"/>',
	managementURL: '<ics:getvar name="cgManagementUrl"/>',
	multiticket : '<ics:getvar name="cgMultiTicket"/>',
	attrs: {
		<ics:getvar name="cgTagParameters"/>
		<ics:getvar name="cgContentTypeParameter"/>
	}
};

var widget = {
	name: '<ics:getvar name="cgTagName"/>', 
	version: '<ics:getvar name="cgTagVersion"/>', 
	elementID: '<ics:getvar name="cgContainerId"/>',
	attributes: {
		<ics:getvar name="cgTagParameters"/>
		<ics:getvar name="cgContentTypeParameter"/>
	}
};

var existObject = function (name) {
	var units = name.split('.');
	var parent = window;
	for (var unit; units.length && (unit = units.shift());) {
		if (typeof parent[unit] == 'undefined') {
			return false;
		}
		parent = parent[unit];
	}	
	return true;
};

if (existObject('<ics:getvar name="cgWidgetName"/>')) {
	cos.widgets.widgetLand.register(<ics:getvar name="cgWidgetName"/>);
	cos.widgets.widgetLand.loadWidget(widget);
} else {
	cos.pageWidgets = cos.pageWidgets || [];
	cos.pageWidgets.push(widget);
	(function () {
		onloadHandler = window.onloadHandler || {};
		if ( ! onloadHandler.alreadyProcessed) {
			var script = document.createElement('script');
			script.src = '<ics:getvar name="cgProductionUrl"/>/wsdk/widget/<ics:getvar name="cgScripts"/>.js?site_id=<ics:getvar name="cgSiteName"/>';
			script.type = 'text/javascript';
			script.charset = 'utf-8';
			document.getElementsByTagName("head").item(0).appendChild(script);
			onloadHandler.alreadyProcessed = true;
		}
		setTimeout(function () {
			if (typeof <ics:getvar name="cgWidgetName"/> == 'undefined') {
				document.getElementById('<ics:getvar name="cgContainerId"/>').innerHTML = "<div style='font-family: Tahoma, Verdana, Geneva, sans-serif;font-size: 12px;color: #333333;border: 1px solid #dbdfe1;padding-left: 5px;padding-top: 4px;height: 22px;'><ics:getvar name="cgServiceIsAnavailable"/></div>";
			}}, 30000);
	})();
}
</script>
</cs:ftcs>