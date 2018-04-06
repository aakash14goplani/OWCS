<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="org.codehaus.jackson.map.ObjectMapper"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="java.util.*"
%><%@ page import="com.fatwire.services.ui.beans.UIPreviewSegmentBean"
%><cs:ftcs><%
	try 
	{
		List<UIPreviewSegmentBean> sList = (List<UIPreviewSegmentBean>)request.getAttribute("sList");
	%>
	<%= new ObjectMapper().writeValueAsString(sList)%>
	<%
	} catch(Exception e) {
		UIException uie = new UIException(e);
		request.setAttribute(UIException._UI_EXCEPTION_, uie);
		throw uie;
	}
%></cs:ftcs>
