<%@ page import="com.fatwire.flame.portlets.FlamePortlet"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib uri="http://java.sun.com/portlet" prefix="portlet"%>
<%//
// OpenMarket/Flame/Common/UIFramework/PortletCSFormMode
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
<portlet:defineObjects />
<%
String formmode = portletConfig.getInitParameter(FlamePortlet.CONFIG_FORMMODE);
if (formmode != null) ics.SetVar("cs_formmode", formmode);
%>
<!-- This element has to be called after the form so that it can detect the form -->
<%
ics.CallElement("OpenMarket/Xcelerate/Util/SetTimeZone", null);
%>
</cs:ftcs>