<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="java.util.*"
%><%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><%@page import="org.codehaus.jackson.map.ObjectMapper"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="org.apache.commons.lang.StringUtils"
%><cs:ftcs>
<%
	try 
	{
		List<Map<String,Object>> list = (List<Map<String,Object>>)request.getAttribute("templateArguments");
		String  message = (String)request.getAttribute("cs_message");
		if(message != null && StringUtils.isNotBlank(message)){	
	%>
		 {
			"cs_message":"<%=message%>"
		 }
	<%}else { %>
		{
			templateArguments: <%=new ObjectMapper().writeValueAsString(list)%>
		}
	<%
	}
	} catch(Exception e) {
		UIException uie = new UIException(e);
		request.setAttribute(UIException._UI_EXCEPTION_, uie);
		throw uie;
	}
%></cs:ftcs>