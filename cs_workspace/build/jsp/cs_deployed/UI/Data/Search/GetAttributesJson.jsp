<%@page import="com.fatwire.services.ui.beans.UIAssetBean"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%>
<%@page import="org.codehaus.jackson.map.ObjectMapper"%><cs:ftcs><%
try {
	List<UIAssetBean> assetAttributes = GenericUtil.emptyIfNull((List<UIAssetBean>)request.getAttribute("assetAttributes"));
%>{identifier: "name",label: "name",items:<%= new ObjectMapper().writeValueAsString(assetAttributes)%>}<%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>