<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><cs:ftcs>
<ics:if condition='<%="list".equals(ics.GetVar("action")) %>'>
<ics:then>
	<ics:callelement element="OpenMarket/Xcelerate/Admin/ProxyAssetMakerList" />
</ics:then>
</ics:if>
<ics:if condition='<%="new".equals(ics.GetVar("action")) %>'>
<ics:then>
	<ics:callelement element="OpenMarket/Xcelerate/Admin/ProxyAssetMakerNew" />
</ics:then>
</ics:if>
</cs:ftcs>