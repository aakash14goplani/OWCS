<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%//
// OpenMarket/Xcelerate/WebRefPattern/PatternUIController
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="org.apache.commons.lang.math.NumberUtils"%>
<%!
	private static final Log _log = LogFactory.getLog(ftMessage.GENERIC_DEBUG);
%>
<cs:ftcs>
<%
	String acls = String.valueOf(session.getAttribute("currentACL"));
	long pubId = NumberUtils.toLong(String.valueOf(session.getAttribute("pubid")), -1);
	Boolean isUserLoggedIn =  pubId > 0 && StringUtils.contains(acls, "xceleditor");
	String err = "";
	if (!isUserLoggedIn) 
	{
		err = "TimeOut";
	%>
		{"error": "<%=err%>"}
	<%
	}
	else
	{
		if (StringUtils.isNotBlank(ics.GetVar("ThisPage")))
		{
		%>
			<ics:callelement element='OpenMarket/Xcelerate/Util/EncodeFieldsValue' />
			<ics:callelement element='<%="OpenMarket/Xcelerate/WebRefPattern/" + ics.GetVar("ThisPage")%>' />
		<%	
		}
	}	
%>
</cs:ftcs>