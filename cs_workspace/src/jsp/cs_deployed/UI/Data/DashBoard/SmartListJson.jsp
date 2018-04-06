<%@page import="com.fatwire.ui.util.GenericUtil"
%><%@ page import="java.util.*"
%><%@ page import="org.codehaus.jackson.map.ObjectMapper"
%><%@ page import="java.net.URLEncoder"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.ui.beans.UISmartListBean"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><cs:ftcs><%
try {
	List<UISmartListBean> saveSearchData = GenericUtil.emptyIfNull((List<UISmartListBean>) request.getAttribute("saveSearchData"));
	//convert the list to json
	String json = new ObjectMapper().writeValueAsString(saveSearchData);
%>{
		"identifier": "saveSearchId",
		"items": <%=json%>
}<%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>