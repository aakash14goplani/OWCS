<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.beans.asset.AssetSaveStatusBean"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="org.codehaus.jackson.map.ObjectMapper"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@page import="com.fatwire.services.beans.ServiceResponse"
%><%@page import="com.fatwire.assetapi.data.AssetId"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@ page import="java.util.*"
%><%@page import="com.fatwire.services.ui.beans.UIAssetCopyBean"
%><cs:ftcs><%
	try 
	{
		List<UIAssetCopyBean> result = GenericUtil.emptyIfNull((List<UIAssetCopyBean>) request.getAttribute("result"));
	%>
	<%= new ObjectMapper().writeValueAsString(result)%>
	<%
	}catch(Exception e) {
		UIException uie = new UIException(e);
		request.setAttribute(UIException._UI_EXCEPTION_, uie);
		throw uie;
	}
%></cs:ftcs>