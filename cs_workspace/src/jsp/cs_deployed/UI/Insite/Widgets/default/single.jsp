<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><cs:ftcs><%
%><span dojoType="fw.ui.dijit.insite.InlineEditBox" 
	editorParams="${cs.editorParams}"
	widgetArgs="{assetName: '${cs.assetName}', fieldName:'${cs.fieldName}', fieldType: '${cs.fieldType}', assetId: {type: '${cs.assetType}', id: '${cs.assetId}'}, editorParams: '{<c:if test="${cs.maxSize != null}"> maxLength: ${cs.maxSize},</c:if> required: ${cs.isRequired}}', isEditable: ${cs.isEditable}, isMultivalued: ${cs.isMultivalued}, index: ${cs.index}}">
${cs.value}</span>
</cs:ftcs>