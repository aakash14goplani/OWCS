<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld" 
%><%@ page import="com.openmarket.xcelerate.publish.PubConstants"
%><%@ page import="COM.FutureTense.Cache.CacheManager"
%><%@ page import="com.fatwire.composition.slots.SlotsManager"
%><cs:ftcs>
<div dojotype="fw.ui.slot.SingleSlotSource" 
     id="${cs.id}"
     jsId="${cs.jsId}"
     accept='' 
     emptytext='${cs.emptyText}'
     slotArgs='${cs.slotArgs}'
     overlayTitle='${cs.title}'
     class="${cs.cssStyle}">
</div>
</cs:ftcs>	