<%@page import="com.fatwire.cs.systemtools.logs.LogCommons.UIConstants"
%><%@page import="com.fatwire.cs.systemtools.logs.LogCommons.Action"
%><%@page import="com.fatwire.cs.systemtools.logs.processor.LogAnalyzer"
%><%@page import="com.fatwire.cs.systemtools.logs.beans.Log"
%><%@page import="COM.FutureTense.Interfaces.FTValList"
%><%@page import="COM.FutureTense.Interfaces.ICS"
%><%@page import="COM.FutureTense.Interfaces.IList"
%><%@page import="COM.FutureTense.Interfaces.Utilities"
%><%@page import="COM.FutureTense.Util.ftErrors"
%><%@page import="COM.FutureTense.Util.ftMessage"
%><%// fatwire/systemtools/logs/logViewer
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"
%><cs:ftcs>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment"/>
<html><head>
<ics:callelement element="fatwire/systemtools/logs/logCommons" /><%
if(Boolean.valueOf(ics.GetVar("logOK")))
{
	final String CS_IMAGEDIR = ics.GetVar("cs_imagedir");
    final String CS_LOCALE = ics.GetSSVar("locale");
%>
<script language="javascript">
window.onload = function()
{
	document.getElementById('<%= LogAnalyzer.LINE2%>').value = '<%= ics.GetVar(LogAnalyzer.LINE2)%>';
	document.getElementById('<%= LogAnalyzer.PAGESIZE%>').value = '<%= ics.GetVar(LogAnalyzer.PAGESIZE)%>';
	actions.<%= Action.NEXT%>();
};
</script>
</head><body>
<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<div class="title-value-text">
		<p><xlat:stream locale='<%= CS_LOCALE%>' key="dvin/TreeApplet/SystemTools/Logs/LogViewer/LogViewerName"/>: <xlat:stream locale='<%= CS_LOCALE%>' key="dvin/TreeApplet/SystemTools/Logs/LogViewer/LogViewerDesc"/></p>
		</div>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>
<%-- Input --%>
<satellite:form id='<%= UIConstants.FORMID%>' action='<%= ics.GetVar(UIConstants.VAR_REQHANDLERURL)%>'>
<input type='hidden' name='<%= UIConstants.VAR_ISLOGVIEWER%>' value='true' />
<input type="hidden" id='<%= UIConstants.VAR_LITE%>' name='<%= UIConstants.VAR_LITE%>' value="true"/>
<input type="hidden" id='<%= LogAnalyzer.LINE1%>' name='<%= LogAnalyzer.LINE1%>'/>
<input type="hidden" id='<%= LogAnalyzer.LINE2%>' name='<%= LogAnalyzer.LINE2%>'/>
<table class="width-outer-70" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td nowrap="nowrap">
			<div class="form-inset">
				<select id='<%= LogAnalyzer.PAGESIZE%>' name='<%= LogAnalyzer.PAGESIZE%>'><%for(String size : UIConstants.ELEM_PAGESIZE_OPTS) {%><option value='<%= size%>' <%= UIConstants.DEFAULT_PAGESIZE.equals(size) ? "selected" : ""%>><%= size%></option><%}%>
				</select>&nbsp;<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "ItemsPerPage"%>'/>
			</div>
		</td>
	</tr>
</table>
</satellite:form>
<ics:callelement element="fatwire/systemtools/logs/logOutput" /><%
}%></body></html></cs:ftcs>