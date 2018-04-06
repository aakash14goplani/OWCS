<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.services.ui.beans.UIApprovalBean"
%><%@page import="org.codehaus.jackson.map.ObjectMapper"
%><%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {
	List<UIApprovalBean> result = GenericUtil.emptyIfNull((List<UIApprovalBean>) request.getAttribute("result"));
	%>{status:<%=new ObjectMapper().writeValueAsString(result)%>}<%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>