<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>

<cs:ftcs>
<ics:if condition='<%="false".equals(System.getProperty("newEngageUI"))%>' >
<ics:then>
	<ics:callelement element="OpenMarket/Xcelerate/AssetType/HFields/ContentDetailsXML"></ics:callelement>
</ics:then>
<ics:else>
	<ics:callelement element="OpenMarket/Xcelerate/AssetType/HFields/ContentDetailsJSP"></ics:callelement>
</ics:else>
</ics:if>
</cs:ftcs>