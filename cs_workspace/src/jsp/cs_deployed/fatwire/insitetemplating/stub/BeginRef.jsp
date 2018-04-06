<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><cs:ftcs><%
%><div dojotype="fw.ui.slot.SingleSlotSource" id="${cs.id}" jsId="${cs.jsId}"
     accept='' emptytext='${cs.emptyText}' slotArgs='${cs.slotArgs}'
     buttons='${cs.buttons}'>
<div class="dojoDndItem" dndType="${cs.assetType}" dndData="{id: '${cs.assetId}', type: '${cs.assetType}', name: '${cs.assetName}'}">
</cs:ftcs>