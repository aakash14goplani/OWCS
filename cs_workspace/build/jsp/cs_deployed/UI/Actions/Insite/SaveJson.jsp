<%@page import="java.util.List"%>
<%@page import="com.fatwire.services.beans.asset.AssetSaveStatusBean"%>
<%@page import="com.fatwire.cs.ui.framework.UIException"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"
%><%@page import="org.codehaus.jackson.map.ObjectMapper"
%><%@page import="org.apache.commons.collections.Transformer"
%><%@page import="org.apache.commons.collections.CollectionUtils"
%><%@page import="com.fatwire.services.beans.ServiceResponse"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs>{<%
try {
ServiceResponse resp = (ServiceResponse) request.getAttribute("resp");
boolean status = resp.status() == ServiceResponse.Status.SUCCESS.status();
List<String> refreshKeys = (List<String>) request.getAttribute("refreshKeys");
ObjectMapper mapper = new ObjectMapper();

%> "status": <%= status %>, "messages": <%= mapper.writeValueAsString(resp.getMessages()) %> ,"refreshkeys" : <%=mapper.writeValueAsString(StringUtils.join(refreshKeys,";"))%> 
<% } catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_,uie);
	throw uie;
}%>}</cs:ftcs>