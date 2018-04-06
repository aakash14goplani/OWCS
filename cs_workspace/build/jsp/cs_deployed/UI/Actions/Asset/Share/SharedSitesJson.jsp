<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ page import="java.util.*"
%><%@ page import="org.codehaus.jackson.map.ObjectMapper"
%><%@ page import="com.fatwire.services.beans.entity.SiteBean"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><cs:ftcs><%
	try 
	{
		List<SiteBean> selectedSites = (ArrayList<SiteBean>)request.getAttribute("selectedSites");
	%>
	{
		"identifier": "id",
		"items": <%=new ObjectMapper().writeValueAsString(selectedSites)%>
	}
	<%
	} catch(Exception e) {
		UIException uie = new UIException(e);
		request.setAttribute(UIException._UI_EXCEPTION_, uie);
		throw uie;
	}
%></cs:ftcs>