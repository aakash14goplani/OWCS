<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@page import="java.lang.Math"%>
<cs:ftcs>
<%
ics.SetVar("cgContainerId", "communityGadgetContainer" + Math.random());
ics.SetVar("cgTagName", "polls".equals(ics.GetVar("cgTagName")) ? "poll" : "poll-summary");
%>
<div id="<ics:getvar name="cgContainerId"/>"></div>
<script type="text/javascript">
cos = window.cos || {};
cos.sites = cos.sites || {};
cos.sites.assets = cos.sites.assets || [];

cos.sites.assets['<ics:getvar name="cid"/>'] = { tagName : '<ics:getvar name="cgTagName"/>' };

cos.sites.alreadyDefinedActionOnEditPoll = cos.sites.alreadyDefinedActionOnEditPoll || (function defineActionOnEditPoll() {
	if (typeof dojo != 'undefined') {
		dojo.subscribe('/fw/ui/slot/activate', dojo.hitch(null, function (source, buttonName) {
			if (buttonName === 'edit') {
   				var objfac = fw.ui.ObjectFactory;
   				var insiteManager = objfac.createManagerObject('insite');
   				var slot = insiteManager.slotManager.getSlotFromSource(source);
   				var asset = cos.sites.assets[slot.assetId];
   				if (typeof asset !== 'undefined' && slot.assetType === 'CGPoll') {
   					parent.SitesApp.warn('<xlat:stream key="CG/PollEditOperationIsNotAllowed" escape="true"/>');
   				}
   			}
		}));
	} else {
		setTimeout(defineActionOnEditPoll, 1000);
	}
	return true;
}());
    
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

var widget = {
	name: '<ics:getvar name="cgTagName"/>', 
    version: '1.0', 
    elementID: '<ics:getvar name="cgContainerId"/>', 
    attributes: { poll_id:'<ics:getvar name="cgId"/>',
    	uid:'<ics:getvar name="cgUid"/>',
    	site_id:'<ics:getvar name="cgSiteName"/>'
    }
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