<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.ui.beans.UITreeBean"
%><%@page import="org.codehaus.jackson.map.ObjectMapper"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
	try 
	{
		UITreeBean treeBn = (UITreeBean)request.getAttribute("treeBean");		
	%>
	<%= new ObjectMapper().writeValueAsString(treeBn)%>
	<%
	} catch(Exception e) {
		UIException uie = new UIException(e);
		request.setAttribute(UIException._UI_EXCEPTION_, uie);
		throw uie;
	}
%></cs:ftcs>