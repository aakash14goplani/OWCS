<%@ page import="com.fatwire.flame.portlets.FlamePortlet,
                 com.openmarket.xcelerate.interfaces.UserManagerFactory,
                 COM.FutureTense.Util.FStringBuffer"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="property" uri="futuretense_cs/property.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Flame/SiteInfo/View
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
	<%
	ics.CallElement("OpenMarket/Xcelerate/UIFramework/BasicEnvironment", null);
	FStringBuffer acls = new FStringBuffer(ics.GetSSVar("currentpubACLs"));
	acls.replaceAll(",", ", "); //add white-space to allow word wrap
	%>
	<table border="0" cellpadding="2" cellspacing="0" width="100%">
	<tr class="portlet-section-body">
		<td valign="top"><b><xlat:stream key="dvin/Common/User"/>:</b></td>
		<td><%=UserManagerFactory.make(ics).getDisplayableUserName()%></td>
	</tr>
	<tr class="portlet-section-alternate">
		<td valign="top"><b><xlat:stream key="dvin/Common/Site"/>:</b></td>
		<td><%=ics.GetSSVar("PublicationName")%></td>
	</tr>
	<tr class="portlet-section-body">
		<td valign="top"><b><xlat:stream key="dvin/Common/Role"/>:</b></td>
		<td><%=acls%></td>
	</tr>
	<satellite:link assembler="query" outstring="urlLoginPost">
		<satellite:argument name="<%=FlamePortlet.ACTION%>" value="select"/>
	</satellite:link>
	<tr>
		<td colspan="2" align="right"><a href='<%=ics.GetVar("urlLoginPost")%>'><xlat:stream key="dvin/Common/SelectSite"/></a></td>
	</tr>
	</table>
</cs:ftcs>