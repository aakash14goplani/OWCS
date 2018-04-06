<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%
//
// OpenMarket/Xcelerate/ControlPanel/Login/Arguments
//
// INPUT
//
// OUTPUT
//
%><%@ page import="COM.FutureTense.Interfaces.ICS" 
%><cs:ftcs>
	<input type="hidden" name="AssetType" value="<ics:getvar name="AssetType"/>"/>
	<input type="hidden" name="id" value="<ics:getvar name="id"/>"/>
	<input type="hidden" name="pubid" value="<ics:getvar name="pubid"/>"/>
	<input type="hidden" name="mode" value="<%=(ics.GetVar("mode")!=null?ics.GetVar("mode"):"preview") %>"/>
	<ics:if condition='<%=ics.GetVar("target") != null %>'>
	<ics:then>
		<input type="hidden" name="target" value="<ics:getvar name="target"/>"/>
	</ics:then>
	</ics:if>
	</then>
	</if>
	<input type="hidden" name="action" value="login"/>
	<input type="hidden" name="pagename" value="OpenMarket/Xcelerate/ControlPanel/Login"/>
	<input type="hidden" name="cs_environment" value="preview"/>
</cs:ftcs>