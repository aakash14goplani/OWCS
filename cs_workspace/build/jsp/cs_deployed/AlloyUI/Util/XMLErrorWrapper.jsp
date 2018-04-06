<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// AlloyUI/Util/XMLErrorWrapper
// This class is just a wrapper around elements contained in OpenMarket/Xcelerate/Errors so that they can be called using a URL
// INPUT elementname: sElementName
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@page import="com.fatwire.ui.util.GenericUtil"
%>
<cs:ftcs>

<!-- Set session variables for this request -->
<%
String sPublicationName = GenericUtil.cleanString(request.getParameter("PublicationName"));
String sLocale = GenericUtil.cleanString(request.getParameter("Locale"));
if(null == sLocale)
	sLocale = "en_US";

%>

<ics:setssvar name="PublicationName" value='<%=sPublicationName %>' />
<ics:setssvar name="Locale" value='<%=sLocale %>' />

<!-- Call the element name passed -->
<ics:callelement element='<%=ics.GetVar("sElementName") %>' />



</cs:ftcs>