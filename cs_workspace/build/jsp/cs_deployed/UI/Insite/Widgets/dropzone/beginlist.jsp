<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><cs:ftcs>
<span dojoType="fw.ui.dijit.insite.MultivaluedContainer" id="${cs.id}" jsId="${cs.jsId}"
	buttons='${cs.buttons}'
	widgetArgs="{fieldName:'${cs.fieldName}', fieldType: '${cs.fieldType}', legalTypes: '${cs.legalTypes}', assetId: {type: '${cs.assetType}', id: '${cs.assetId}'}, jsId: '${cs.jsId}', editorParams: '{maxLength: ${cs.maxSize}, required: ${cs.isRequired}}', isEditable: ${cs.isEditable}, isMultivalued: ${cs.isMultivalued}, parentId: '${cs.parentId}', parentType: '${cs.parentType}', parentField: '${cs.parentField }'}">
</cs:ftcs>