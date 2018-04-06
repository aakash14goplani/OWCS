<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="org.apache.commons.lang.math.NumberUtils"
%><%@page import="com.fatwire.services.ui.beans.UIBookmarkBean"
%><%@page import="org.codehaus.jackson.map.ObjectMapper"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
	try {	
		UIBookmarkBean bookmarkBn = (UIBookmarkBean)request.getAttribute("bookmarkBean");		
	%>
	<%= new ObjectMapper().writeValueAsString(bookmarkBn)%>
	<%
	} catch(Exception e) {
		UIException uie = new UIException(e);
		request.setAttribute(UIException._UI_EXCEPTION_, uie);
		throw uie;
	}
%></cs:ftcs>