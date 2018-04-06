<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="org.codehaus.jackson.map.ObjectMapper"
%><%@page import="com.fatwire.services.ui.beans.UIAssetStatusBean"
%><cs:ftcs><%
	try 
	{		
		UIAssetStatusBean statusBn = (UIAssetStatusBean)request.getAttribute("statusBean");
	%>
	<%= new ObjectMapper().writeValueAsString(statusBn)%>
	<%
	} catch(Exception e) {
		UIException uie = new UIException(e);
		request.setAttribute(UIException._UI_EXCEPTION_, uie);
		throw uie;
	}
%></cs:ftcs>