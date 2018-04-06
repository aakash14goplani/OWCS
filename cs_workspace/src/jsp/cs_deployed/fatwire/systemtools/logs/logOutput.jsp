<%@ page import="COM.FutureTense.Interfaces.FTValList" 
%><%@page import="com.fatwire.cs.systemtools.logs.LogCommons.UIConstants"
%><%@page import="COM.FutureTense.Interfaces.FTValList"
%><%@page import="COM.FutureTense.Interfaces.ICS"
%><%@page import="COM.FutureTense.Interfaces.IList"
%><%@page import="COM.FutureTense.Interfaces.Utilities"
%><%@page import="COM.FutureTense.Util.ftErrors"
%><%@page import="COM.FutureTense.Util.ftMessage"
%><%// fatwire/systemtools/logs/logOutput
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><cs:ftcs><%
if(Boolean.valueOf(ics.GetVar("logOK")))
{
    final String CS_IMAGEDIR = ics.GetVar("cs_imagedir");
    final String CS_LOCALE = ics.GetSSVar("locale");
%><!-- Processing progress -->
<div id='<%= UIConstants.ELEM_AJAXLOADING%>' style="width:250px;position:absolute; top: 250px; display:none; left: 320px;">
	<table width="100%" height="100%" cellspacing="0" cellpadding="40" bgcolor="#f7f8fa" align="center" style="border: 1px solid rgb(204,204,204);">
		<tbody id='<%= UIConstants.ELEM_AJAXPROCESSING%>' style="padding:50px;">
			<tr>
				<td valign="middle" align="center">
				<img src='<%=CS_IMAGEDIR%>/graphics/common/icon/wait_ax.gif'/>
				<br/>
				<br/>
				<b>
				<span id="loadingMsg"><xlat:stream locale='<%= CS_LOCALE%>' key="dvin/UI/Loading"/></span>
				<img src='<%=CS_IMAGEDIR%>/graphics/common/icon/short_Progress.gif'/>
				</b>
				<BR/>
				<label id='<%= UIConstants.ELEM_LOADINGMSG%>'></label>
				<a id="hider2" style="cursor: pointer; text-decoration: underline;"></a>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<%-- Output --%>
<div>
	<table width="100%">
		<tr>
			<td align="center"><div style="color: green; font-weight: bold;" id='<%= UIConstants.ELEM_MESSAGE%>'></div></td>
		</tr>
	</table>
</div>
<div>
	<table width="100%">
		<tr>
			<td align="center"><div style="color: red; font-weight: bold;" id='<%= UIConstants.ELEM_ERROR%>'></div></td>
		</tr>
	</table>
</div>
<div style="margin:15px 0 0 15px;" id='<%= UIConstants.ELEM_OUTPUT%>'></div>
<%}%></cs:ftcs>