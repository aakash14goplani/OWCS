<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%//
// OpenMarket/Xcelerate/WebRefPattern/DeletePattern
//
// INPUT
//
// OUTPUT
//%>
<%@page import="com.openmarket.xcelerate.asset.WebReferencesPattern"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<cs:ftcs>
<%
	String status = "fail";
	String patternId = request.getParameter("patternId");
	if (StringUtils.isNotBlank(patternId)) 
	{
		WebReferencesPattern webReferencesPattern = new WebReferencesPattern(ics);
		webReferencesPattern.delete(Long.valueOf(patternId));
		status = "success";
	}	
%>
{"status" : "<%=status%>"}
</cs:ftcs>