<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="controller" uri="futuretense_cs/controller.tld" %>
<%//
// OpenMarket/Xcelerate/UIFramework/ApplicationPage
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
<ics:callelement element="OpenMarket/Xcelerate/Util/EncodeFieldsValue"/>

<ics:if condition='<%="ucform".equals(ics.GetVar("cs_environment"))%>'>
<ics:then>
	<controller:callelement elementname="UI/Actions/AdvancedUI" />
</ics:then>
<ics:else>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/ApplicationPageStandard" />
</ics:else>
</ics:if>
<div style="visibility:hidden;height:100px;"></div>
</cs:ftcs>