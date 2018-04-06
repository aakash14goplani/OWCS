<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="java.util.ArrayList"
%><%@page import="org.codehaus.jackson.map.ObjectMapper"
%><%@page import="com.fatwire.services.ui.beans.UIAccessRightsBean"
%><%@page import="com.fatwire.services.ui.beans.UIVersionBean"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs>
<%
	try 
	{
		UIAccessRightsBean permission = (UIAccessRightsBean)request.getAttribute("assetPermission");
		UIVersionBean checkout =  (UIVersionBean)request.getAttribute("checkout");
	%>
		{"permission":<%= new ObjectMapper().writeValueAsString(permission)%>
	<%if(checkout != null){	%>	
		,"checkout":<%= new ObjectMapper().writeValueAsString(checkout)%>	
	<%}	%>
		}	
	<%} 
	catch(Exception e) 
	{
		UIException uie = new UIException(e);
		request.setAttribute(UIException._UI_EXCEPTION_, uie);
		throw uie;
	}
%></cs:ftcs>