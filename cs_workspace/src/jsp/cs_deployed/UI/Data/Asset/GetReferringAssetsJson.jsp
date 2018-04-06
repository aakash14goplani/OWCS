<%@page import="com.fatwire.services.ui.beans.UIReferenceBean"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="java.util.List"
%><%@page import="org.codehaus.jackson.map.ObjectMapper"
%><%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs><%
try {
	List<UIReferenceBean> result = GenericUtil.emptyIfNull((List<UIReferenceBean>) request.getAttribute("result"));
	%>{'identifier':'id','items':<%=new ObjectMapper().writeValueAsString(result)%>}<%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>