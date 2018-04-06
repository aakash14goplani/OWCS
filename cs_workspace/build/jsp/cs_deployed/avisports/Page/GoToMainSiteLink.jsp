<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%//
// avisports/Page/GoToMainSiteLink
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>

<ics:callelement element="avisports/Page/GetHome" />
<ics:ifnotempty variable="AVIHomeId">
<ics:then>
	<render:callelement elementname="avisports/Page/GetLink" scoped="global">
		<render:argument name="assetid" value='<%=ics.GetVar("AVIHomeId")%>' />		
		<render:argument name="d" value="default" />		
	</render:callelement>
<a href="<%=ics.GetVar("pageUrl") %>"><xlat:stream key="dvin/UI/Mobility/MainSite" /></a>	
</ics:then>
</ics:ifnotempty>

</cs:ftcs>