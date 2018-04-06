<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@ page import="com.fatwire.services.beans.asset.basic.template.TemplatesBean"
%><%@page import="org.codehaus.jackson.map.ObjectMapper"
%><%@ page import="java.util.*"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
	try 
	{
		TemplatesBean templates = (TemplatesBean)request.getAttribute("templatesBean");
		String json =  new ObjectMapper().writeValueAsString(templates.getTemplates());
		int numRows = 0;
		if(templates != null){
			numRows = templates.getCount();
		}
	%>
	{
		"identifier" : "pageName",
		"label" : "name",
		"numRows" : <%=numRows %>,
		"items":<%=json%>
	}	
	<%
	} catch(Exception e) {
		UIException uie = new UIException(e);
		request.setAttribute(UIException._UI_EXCEPTION_, uie);
		throw uie;
	}
%></cs:ftcs>