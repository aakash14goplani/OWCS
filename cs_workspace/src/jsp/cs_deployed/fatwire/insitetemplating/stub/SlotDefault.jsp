<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><cs:ftcs> 
<div dojotype="fw.ui.slot.SingleSlotSource" 
     id="${cs.id}"
     jsId="fwslots.${cs.slotType}.${cs.id}"
     accept='' 
     emptytext='${cs.emptyText}'
     slotArgs='${cs.slotArgs}'>
</div>
</cs:ftcs>