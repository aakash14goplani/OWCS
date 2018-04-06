<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// fatwire/systemtools/SystemInfo/ShowLoading
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
<cs:ftcs>
<div id="ajaxLoading" style="width:400px;position:absolute; top: 250px; display:none; left: 320px;" bgcolor="white">
<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="#f7f8fa" align="center" style="border: 1px solid rgb(204,204,204);">
<tbody id="processing" style="display:none;padding:50px;">
<tr>
<td valign="middle" align="center">
<img src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/wait_ax.gif'/>
<br/>
<br/>
<b>
<span id="loadingMsg"><xlat:stream key="dvin/UI/Loading"/></span>
<img src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/short_Progress.gif'/>
</b>
<BR/>
<span><b><xlat:stream key="fatwire/SystemTools/SystemInfo/DownloadWaitMessage"/></b></span>
<a id="hider2" style="cursor: pointer; text-decoration: underline;"/>
</td>
</tr>
</tbody>
<tbody id="processingCompleted" style="display:none;padding:80px;">
<tr>
<td valign="middle" align="center">
<b><xlat:stream key="fatwire/SystemTools/SystemInfo/DownloadSuccessMessage" /></b>
<a id="hider2" style="cursor: pointer; text-decoration: underline;"/>
</td>
</tr>
</tbody>
<tbody id="userCancelled" style="display:none;padding:80px;">
<tr>
<td valign="middle" align="center">
<b><xlat:stream key="fatwire/SystemTools/SystemInfo/DownloadCancelMessage" /></b>
<a id="hider2" style="cursor: pointer; text-decoration: underline;"/>
</td>
</tr>
</tbody>
<tbody id="errorOccured" style="display:none;padding:80px;">
<tr>
<td valign="middle" align="center">
<b id="errorMessageID"></b>
<a id="hider2" style="cursor: pointer; text-decoration: underline;"/>
</td>
</tr>
</tbody>
</table>
</div>
</cs:ftcs>