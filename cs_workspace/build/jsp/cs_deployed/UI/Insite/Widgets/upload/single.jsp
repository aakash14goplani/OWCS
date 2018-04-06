<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><cs:ftcs><%
%><span dojoType="fw.ui.dijit.insite.UploadEditor"
	editorParams="${cs.editorParams}"
	widgetArgs="{assetName: '${cs.assetName}', fieldName:'${cs.fieldName}', fieldValue: '${cs.value}', fieldType: '${cs.fieldType}', assetId: {type: '${cs.assetType}', id: '${cs.assetId}'}, editorParams: '{maxLength: ${cs.maxSize}, required: ${cs.isRequired}}', isEditable: ${cs.isEditable}, isMultivalued: ${cs.isMultivalued}, index: ${cs.index}, _authkey_:'${sessionScope._authkey_}', _authtoken_:'${sessionScope.csrfuuid}'}"><%
	%>${cs.body}</span><%
%></cs:ftcs>