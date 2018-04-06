<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" 
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" 
%><cs:ftcs>
	<asset:get name="currentAsset" field="pagename" output="pagename"/>
	<%String slotid = ics.GetVar("cid") + ":" + ics.GetVar("c") + ":" + ics.GetVar("pagename");%>	
	<div id='<%=slotid%>' class="insite-Search">
	    <ics:callelement element="fatwire/insitetemplating/stub/SlotHandle">
	        <ics:argument name="mainslotid" value="fw_it_preview" />   
	        <ics:argument name="slottitle" value='<%=ics.GetVar("slottitle")%>' />
	    </ics:callelement>	
	    <render:satellitepage pagename='<%= ics.GetVar("pagename") %>' >
	        <render:argument name='rendermode' value='<%=ics.GetVar("rendermode")%>' />
	    </render:satellitepage>         
	</div>
</cs:ftcs>