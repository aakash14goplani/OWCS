<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Xcelerate/UIFramework/form/AssetTypeStartEndDate
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
<%@ page import="java.util.*, java.text.*" %>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<cs:ftcs>
<ics:getproperty name="cs.sitepreview" file="futuretense.ini" output="enableSitePreview" />
<%
	if(!"disabled".equalsIgnoreCase(ics.GetVar("enableSitePreview"))) {
	String startDate = null,endDate=null;
	if(Boolean.valueOf(ics.GetVar("contentFormReposted")))
	{
		startDate = StringEscapeUtils.escapeHtml(ics.GetVar("ContentDetails:startdate"));
		endDate = StringEscapeUtils.escapeHtml(ics.GetVar("ContentDetails:enddate"));
	}
	else
	{
		//do not convert if reposted, because the date is not from database but from form (browser)
		String clientTimeZone = ics.GetSSVar("time.zone");
		String serverTimeZone = TimeZone.getDefault().getID();
		startDate = ConverterUtils.convertJDBCDate(StringEscapeUtils.escapeHtml(ics.GetVar("ContentDetails:startdate")),serverTimeZone,clientTimeZone);
		endDate = ConverterUtils.convertJDBCDate(StringEscapeUtils.escapeHtml(ics.GetVar("ContentDetails:enddate")),serverTimeZone,clientTimeZone);
	}
	String localizedStartDate = ConverterUtils.getLocalizedDate(startDate, ics.GetSSVar("locale"));
	String localizedEndDate = ConverterUtils.getLocalizedDate(endDate, ics.GetSSVar("locale"));
%> 
	<xlat:lookup key="fatwire/Alloy/UI/PickADate" varname="pickADateString" />
	<xlat:lookup key="fatwire/Alloy/UI/DatePicker" varname="datePickerString" />
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer" />
	<tr>
	<td class="form-label-text"><xlat:stream key="fatwire/Alloy/UI/StartDate"/>:</td>
	<td></td>
	<td class="form-inset" nowrap="nowrap">
			<div style="display: table;">
			<div id="startDateFieldId" dojoType="fw.dijit.UIInput"  clearButton="true" readonly="true" name='<%=ics.GetVar("startDateFieldName")%>' value="<%= localizedStartDate%>">
			<ics:if condition='<%="true".equals(ics.GetVar("defaultFormStyle"))%>'>
			<ics:then>	
				<script event='startup' type='dojo/connect'>
					dojo.addClass(this.domNode, "defaultFormStyle");
				</script>
			</ics:then>
			</ics:if>
			</div>
			<DIV ID="startDateFieldIdDiv" STYLE="display:none"><%=startDate%></DIV>
			<ics:callelement element="OpenMarket/Xcelerate/Scripts/DateTimeWidget">
				<ics:argument name="inputFieldId" value="startDateFieldId"/>
				<ics:argument name="convertedDate" value='<%=localizedStartDate%>'/>
			</ics:callelement>
			</div>
	</td>
	</tr>
	
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer" />
	<tr>
	<td class="form-label-text"><xlat:stream key="fatwire/Alloy/UI/EndDate"/>:</td>
	<td></td>
	<td class="form-inset" nowrap="nowrap">
		<div style="display: table;">
		<div id="endDateFieldId" dojoType="fw.dijit.UIInput"  clearButton="true" readonly="true" name='<%=ics.GetVar("endDateFieldName")%>' value="<%=ConverterUtils.getLocalizedDate(endDate, ics.GetSSVar("locale"))%>">
		<ics:if condition='<%="true".equals(ics.GetVar("defaultFormStyle"))%>'>
		<ics:then>
			<script event='startup' type='dojo/connect'>
				dojo.addClass(this.domNode, "defaultFormStyle");
			</script>
		</ics:then>
		</ics:if>
		</div>
		<DIV ID="endDateFieldIdDiv" STYLE="display:none"><%=endDate%></DIV>
		<ics:callelement element="OpenMarket/Xcelerate/Scripts/DateTimeWidget">
			<ics:argument name="inputFieldId" value="endDateFieldId"/>
			<ics:argument name="convertedDate" value='<%=localizedEndDate%>'/>
		</ics:callelement>
		</div>
	</td>
	</tr>
<% } %>
</cs:ftcs>