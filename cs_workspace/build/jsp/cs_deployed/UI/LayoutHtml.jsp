<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="controller" uri="futuretense_cs/controller.tld"
%><%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><%@page import="com.fatwire.cs.ui.framework.LocalizedMessages"
%><cs:ftcs><!DOCTYPE html>
<html>
<%
	String locale = LocalizedMessages.getLocaleString(ics);
	if(locale != null){
		locale = locale.toLowerCase().replace("_", "-");
	}
%>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<link rel="stylesheet" type="text/css" href="js/fw/css/ui/fw.css"/>
	<link rel="stylesheet" type="text/css" href="js/fw/css/locale/<%=locale%>.css"/>
</head>
<body class="fw">
	<div id="loadingBack">
		<div id="loadingFront">
			<img src="wemresources/images/ui/wem/loading.gif" alt="Loading..." height="32" width="32" /><br />
			<xlat:stream key="dvin/UI/Loadingdotdotdot"/>
		</div>
	</div>
	<script type="text/javascript" src="js/dojo/dojo.js" data-dojo-config="parseOnLoad:true, locale:'<%=locale%>', fw_csPath:'<ics:getproperty name="ft.cgipath" />'"></script>
	<script type="text/javascript" src="ImageEditor/clarkii/clarkii_config.js"></script>
	<script type="text/javascript" src="js/fw/fw_ui.js"></script>
	<script type="text/javascript" src="wemresources/js/dojopatches.js"></script>
	<script type="text/javascript" src="ckeditor/ckeditor.js" defer="defer"></script>
	<script type="text/javascript" src="js/SWFUpload/swfupload.js" defer="defer"></script>
	<script type="text/javascript" src="js/SWFUpload/plugins/swfupload.swfobject.js"></script>
	<script type="text/javascript" src="js/SWFUpload/plugins/swfupload.queue.js" defer="defer"></script>
	<script>
		dojo.require("fw.ui._base");
	</script>
	<div data-dojo-type="dijit.layout.BorderContainer" id="topcontainer" style="width:100%;height:100%;padding:0" data-dojo-props="onLoad:function(){ loadCheck(); }">
		<div data-dojo-type="dijit.layout.ContentPane" id="topPane" style="padding:0;" data-dojo-props="region:'top','class':'headerContentPane'">
			<controller:callelement elementname="${layoutconfig['header']}" responsetype="${layoutconfig['header[@responsetype]']}" />
		</div>
		 <div data-dojo-type="dijit.layout.BorderContainer" id="treeContainer" data-dojo-props="region:'left',minSize:1,maxSize:500,splitter:true,design:'sidebar',preload:true,'class':'treeContainer'">
			<controller:callelement elementname="${layoutconfig['leftnavigation']}" responsetype="${layoutconfig['leftnavigation[@responsetype]']}" />
		</div>
		<div data-dojo-type="fw.dijit.layout.UITabContainer" id="centerTabContainer" data-dojo-props="region:'center'">
			<controller:callelement elementname="${layoutconfig['centerpane']}" responsetype="${layoutconfig['centerpane[@responsetype]']}" />
		</div>
		<div data-dojo-type="dijit.layout.ContentPane" id="rightPane" style="display:none" data-dojo-props="region:'right'">
			<controller:callelement elementname="${layoutconfig['rightnavigation']}" responsetype="${layoutconfig['rightnavigation[@responsetype]']}" />
		</div>
	</div>
</body>
</html>
</cs:ftcs>
