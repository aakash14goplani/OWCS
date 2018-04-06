<%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ page import="org.apache.commons.lang.StringUtils"
%><cs:ftcs><%
try {
%><ics:callelement element="OpenMarket/Xcelerate/UIFramework/StandardVariables" />
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/SetStylesheet" /><%
	String assetType = StringUtils.defaultString(ics.GetVar("assettype"));
	String askStep = StringUtils.defaultString(ics.GetVar("askstep"));
	String workflowId = StringUtils.defaultString(ics.GetVar("workflowid"));
	if(ics.IsElement("OpenMarket/Xcelerate/AssetType/" + ics.GetVar("assettype") + "/SetStylesheet")) {
		%><ics:callelement element='<%= "OpenMarket/Xcelerate/AssetType/" + ics.GetVar("assettype") + "Content_C/SetStylesheet"%>' /><%
	}%><ics:callelement element="OpenMarket/Xcelerate/Actions/SetAssigneesForAskStep">
		<ics:argument name="AssetType" value='<%= assetType%>' />
		<ics:argument name="AskStep" value='<%= askStep%>' />
		<ics:argument name="workflowid" value='<%= workflowId%>' />
	</ics:callelement><%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>