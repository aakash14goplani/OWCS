<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<cs:ftcs>
<c:set var="DeviceID" value='<%=ics.GetVar("deviceid")%>'/> 
<div id='${cs.widgetId}' dojoType="fw.ui.dijit.insite.InlineEditBox" 
	editor="fw.ui.dijit.insite.CKEdit" renderAsHtml="true"
	editorParams='{editorName: "${cs.widgetId}", config: ${cs.editorParams}, required: ${cs.isRequired},enableEmbeddedLinks:${cs.allowEmbeddedLinks},deviceid:"${DeviceID}"}' 
	widgetArgs='{assetName: "${cs.assetName}", assetId: {id: "${cs.assetId}", type: "${cs.assetType}"}, fieldName: "${cs.fieldName}", isEditable: ${cs.isEditable}, isMultivalued: ${cs.isMultivalued}, index: ${cs.index}}'>
	${cs.value}
</div> 
</cs:ftcs>