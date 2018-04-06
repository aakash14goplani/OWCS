<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %><cs:ftcs>
<span dojoType="fw.ui.dijit.insite.MultivaluedContainer"
	buttons='${cs.buttons}'
	editorParams="${cs.editorParams}"
	widgetArgs="{assetName: '${cs.assetName}', fieldName:'${cs.fieldName}', fieldType: '${cs.fieldType}', assetId: {type: '${cs.assetType}', id: '${cs.assetId}'}, editorParams: '{<c:if test="${not empty cs.maxSize}"> maxLength: ${cs.maxSize},</c:if> required: ${cs.isRequired}}', isEditable: ${cs.isEditable}, isMultivalued: ${cs.isMultivalued}}">
</cs:ftcs>