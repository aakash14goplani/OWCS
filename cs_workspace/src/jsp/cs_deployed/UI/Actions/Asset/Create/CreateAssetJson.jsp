<%@page import="com.fatwire.assetapi.data.AssetData"%>
<%@page import="com.fatwire.services.beans.asset.AssetSaveStatusBean"%>
<%@page import="com.fatwire.cs.ui.framework.UIException"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.fatwire.services.beans.asset.AssetSaveStatusBean"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ page import="java.util.*"
%><%@ page import="com.fatwire.assetapi.data.AssetId"
%><%@ page import="org.codehaus.jackson.map.ObjectMapper"
%><cs:ftcs>{<%
	try {
	AssetSaveStatusBean status = (AssetSaveStatusBean) request.getAttribute("saveStatus");
	ObjectMapper mapper = new ObjectMapper();
	AssetData assetData = status.getAssetData();
	List<String> errList = (List<String>) request.getAttribute("errorMessages");;
	List<String> refreshKeys = (List<String>) status.getRefreshKeys();
	%>'refreshkeys':<%=  mapper.writeValueAsString(StringUtils.join(refreshKeys,";"))%><%
	if(errList != null && errList.size() > 0) {
		%>,'errors':<%= mapper.writeValueAsString(errList)%><%
	}
	if(assetData != null &&  assetData.getAssetId() != null) {		
		%>,'asset':<%= mapper.writeValueAsString(assetData.getAssetId())%><%
	}
} catch(Exception e) {	
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%>
}</cs:ftcs>