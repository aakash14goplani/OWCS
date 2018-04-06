<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.ui.beans.UIPreviewURLBean"
%><%@page import="org.codehaus.jackson.map.ObjectMapper"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
	try 
	{
		UIPreviewURLBean bean = (UIPreviewURLBean)request.getAttribute("previewURLBean");		
	%>
	<%= new ObjectMapper().writeValueAsString(bean)%>
	<%
	} catch(Exception e) {
		UIException uie = new UIException(e);
		request.setAttribute(UIException._UI_EXCEPTION_, uie);
		throw uie;
	}
%></cs:ftcs>