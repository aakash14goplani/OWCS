<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@page import="com.fatwire.wem.sso.SSO"%>
<%@page import="com.fatwire.wem.sso.SSOSession"%>
<%@page import="COM.FutureTense.Interfaces.Utilities"%>
<cs:ftcs>
<%
	String username = ics.GetProperty("xcelerate.batchuser", "futuretense_xcel.ini", true);
	String password = ics.GetProperty("xcelerate.batchpass", "futuretense_xcel.ini", true);
	SSOSession ssoSession = SSO.getSSOSession();
    String multiTicket = ssoSession.getMultiTicket(username, Utilities.decryptString(password));
	ics.SetVar("cgMultiTicket", multiTicket);
%>
</cs:ftcs>