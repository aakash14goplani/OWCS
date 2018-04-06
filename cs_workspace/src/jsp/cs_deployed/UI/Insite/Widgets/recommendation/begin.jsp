<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><cs:ftcs><%
%><div dojotype="fw.ui.slot.SingleSlotSource" id="${cs.id}" jsId="${cs.jsId}"
     accept='' emptytext='${cs.emptyText}' slotArgs='${cs.slotArgs}'
     buttons='${cs.buttons}' title="${cs.title}" class="${cs.cssStyle}">
<div class="dojoDndItem" dndType="${cs.assetType}" dndData="{id: '${cs.assetId}', type: '${cs.assetType}', name: '${cs.assetName}'}">
<div style='color:yellow;height:2em;margin:4px;padding:4px;background-color:#778899'> How about a nice analytics graph here for the asset below?</div>
</cs:ftcs>