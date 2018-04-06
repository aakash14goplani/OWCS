<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@page import="java.util.*"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="org.codehaus.jackson.map.ObjectMapper"
%><cs:ftcs><%
	try 
	{
		List<String> trackedTypes = (ArrayList<String>)request.getAttribute("trackedTypes");
	%>
	"trackedTypes":<%= new ObjectMapper().writeValueAsString(trackedTypes)%>
	<%
	} catch(Exception e) {
		UIException uie = new UIException(e);
		request.setAttribute(UIException._UI_EXCEPTION_, uie);
		throw uie;
	}
%></cs:ftcs>