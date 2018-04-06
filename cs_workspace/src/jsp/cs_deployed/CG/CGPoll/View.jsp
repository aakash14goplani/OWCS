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
cos.pageWidgets = cos.pageWidgets || [];

cos.pageWidgets.push({name: '<ics:getvar name="cgTagName"/>',
	version: '<ics:getvar name="cgTagVersion"/>',
	elementID: '<ics:getvar name="cgContainerId"/>',
	attributes: { poll_id:'<ics:getvar name="cgId"/>',
		uid:'<ics:getvar name="cgUid"/>',
		site_id:'<ics:getvar name="cgSiteName"/>'}
});

setTimeout(function () {
	if (typeof <ics:getvar name="cgWidgetName"/> == 'undefined') {
		document.getElementById('<ics:getvar name="cgContainerId"/>').innerHTML = "<div style='font-family: Tahoma, Verdana, Geneva, sans-serif;font-size: 12px;color: #333333;border: 1px solid #dbdfe1;padding-left: 5px;padding-top: 4px;height: 22px;'><ics:getvar name="cgServiceIsAnavailable"/></div>";
	}}, 30000);
	
cos.pageScripts = cos.pageScripts || [];
cos.pageScripts.push('<ics:getvar name="cgScriptName"/>');

(function () {
	var oldOnloadHandler = window.onload || function () {};
	if ( ! oldOnloadHandler.alreadyProcessed) {
		window.onload = function () {
			var script = document.createElement('script');
			script.src = '<ics:getvar name="cgProductionUrl"/>/wsdk/widget/'
				+ cos.pageScripts.join(':') + '.js?site_id=<ics:getvar name="cgSiteName"/>';
			script.type = 'text/javascript';
			script.charset = 'utf-8';
			document.getElementsByTagName("head").item(0).appendChild(script);
			oldOnloadHandler.apply(this, arguments);
		};
		window.onload.alreadyProcessed = true;
	}
})();
</script>
</cs:ftcs>