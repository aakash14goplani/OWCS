<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Gator/Scripts/ApplyIconsAndTooltip
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

<script type='text/javascript'>
dojo.require('fw.ui.dijit.form.IconMappingConfig');
dojo.addOnLoad(function() {
	// "AttributeName" is overlapping with "AttrName"
	// AttrName is used in Flex Assets and AttributeName is used in Basic Assets
	var attrName = '<%= null != ics.GetVar("AttributeName") ? ics.GetVar("AttributeName") : ics.GetVar("AttrName")%>',
		fileInfoJSON = '<%= org.apache.commons.lang.StringEscapeUtils.escapeJavaScript(ics.GetVar("fileInfoJSON"))%>',	
		divNamePrefix = '<%= ics.GetVar("divNamePrefix") %>',
		allDisplayURLValues = dojo.query('div[name^="' + divNamePrefix + attrName + '"]'),
		iconImageNode,
		fileName = '',
		fileExtension = '',
		actualIconName = '',
		iconsPath = 'js/fw/images/ui/ui/multiValuedAttributes/ExtensionIcons/170x170/',
		iconsExtension = '.png',
		imgNode = {},
		
		isValidJSON = function(strJson) {
			try {
				dojo.fromJson(strJson);
				return true;
			} catch (e) {
				return false;
			}
		},
		
		passInfoToLightbox = function(imgNode, fileInfo) {
			var lbWidget = dijit.getEnclosingWidget(imgNode);
			lbWidget.set('displayInfo', fileInfo);
		};
		
	if (!isValidJSON(fileInfoJSON)) return;
	fileInfoJSON = dojo.fromJson(fileInfoJSON);

	for (var i = 0; i < allDisplayURLValues.length; i++) {
		if (!fileInfoJSON[i + 1]) continue;	
				
		new dijit.Tooltip({connectId: [allDisplayURLValues[i]], label: fw.util.createTooltip(fileInfoJSON[i + 1])});
				
		imgNode = dojo.query('img', allDisplayURLValues[i])[0];
		if ('iconImg' === dojo.attr(imgNode, 'name')) 
			iconImageNode = imgNode;
		else
			passInfoToLightbox(imgNode, fileInfoJSON[i + 1]);
		
		if (!iconImageNode) continue;
		dojo.style(iconImageNode, 'width', '96px');
		
		fileName = fileInfoJSON[i + 1]['filename']; 
		fileExtension = fileName.split('.').pop().toLowerCase();
		
		actualIconName = fw.ui.dijit.form.iconMapping[fileExtension] ? 
						 fw.ui.dijit.form.iconMapping[fileExtension] : fw.ui.dijit.form.DEFAULT_ICON;
		dojo.attr(iconImageNode, 'src', iconsPath + actualIconName + iconsExtension);
	}
});
</script>

</cs:ftcs>