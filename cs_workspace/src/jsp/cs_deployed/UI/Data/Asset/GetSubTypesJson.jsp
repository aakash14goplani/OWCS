<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="com.fatwire.services.ui.beans.LabelValueBean"
%><%@ page import="java.util.*"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@ page import="org.codehaus.jackson.map.ObjectMapper"
%><cs:ftcs><%
	try
	{
		List<LabelValueBean> subTypes = (List<LabelValueBean>)request.getAttribute("subType");
	%>
	{ identifier: "value", label: "label", items: <%=new ObjectMapper().writeValueAsString(subTypes)%> }
	<%
	} catch(Exception e) {
			UIException uie = new UIException(e);
			request.setAttribute(UIException._UI_EXCEPTION_, uie);
			throw uie;
	}
%></cs:ftcs>