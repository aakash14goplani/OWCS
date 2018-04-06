<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// fatwire/wem/integration/processSSOLogout
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="com.fatwire.wem.sso.SSO" %>
<%@ page import="java.util.Properties" %>
<cs:ftcs>
<iframe src='<%=SSO.getSSOSession().getSignoutUrl()%>' style="position: absolute; top: -100px; visibility: hidden;">
</iframe>

<!-- user code here -->

</cs:ftcs>