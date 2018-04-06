<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Xcelerate/Actions/PreviewWithTemplatesDate
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="com.openmarket.xcelerate.util.ConverterUtils"%>
<%@ page import="java.util.TimeZone"%>
<cs:ftcs>
<div class="rowspace" style="margin-left:10px;">
	<xlat:lookup key="fatwire/Alloy/UI/Enterdate" varname="EnterdateString" />
	<xlat:lookup key="fatwire/Alloy/UI/PickADate" varname="pickADateString" />
	<xlat:lookup key="fatwire/Alloy/UI/DatePicker" varname="datePickerString" />
	<ics:setvar name="server_date" value='<%=ics.ResolveVariables("CS.SQLDate")%>' />
	<ics:if condition='<%=ics.GetVar("defaultPreviewDate") != null%>'>
	<ics:then>
		<ics:setvar name="date_value" value='<%=ics.GetVar("defaultPreviewDate")%>' />
		<ics:setssvar name="__insiteDate" value='<%=ics.GetVar("defaultPreviewDate")%>' />
		<ics:removevar name="defaultPreviewDate" />
	</ics:then>
	<ics:else>					
		<ics:setvar name="date_value" value='<%=ics.GetVar("server_date")%>' />
		<ics:setssvar name="__insiteDate" value='<%=ics.GetVar("server_date")%>' />
	</ics:else>
	</ics:if>
	<%
	String clientTime = ConverterUtils.convertJDBCDate(ics.GetVar("date_value"),TimeZone.getDefault().getID(), ics.GetSSVar("time.zone"));
	%>
	<div id="__iDate" dojoType="fw.dijit.UIInput"  clearButton="true" readonly="true" VALUE='<%=ConverterUtils.getLocalizedDate(clientTime, ics.GetSSVar("locale"))%>' title='<%=ics.GetVar("EnterdateString")%>'></div>
	<input type="hidden" name="__insiteDate" id="__insiteDate" value="">
	<div ID="__iDateDiv" style="display:none;"><%=clientTime%></div>
	<ics:callelement element="OpenMarket/Xcelerate/Scripts/DateTimeWidget">
		<ics:argument name="inputFieldId" value="__iDate"/>
	</ics:callelement>
	</div>
	<script type="text/javascript">
		function copyDate(){
			document.getElementById('__insiteDate').value=document.getElementById('__iDateDiv').innerHTML;
		}
	</script>
</cs:ftcs>