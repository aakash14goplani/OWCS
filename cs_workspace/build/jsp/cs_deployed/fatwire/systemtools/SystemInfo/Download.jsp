<%@page import="com.fatwire.cs.systemtools.util.SysInfoUtils"%>
<%@page import="com.fatwire.realtime.util.Util"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>

<%//
// fatwire/systemtools/SystemInfo/DownloadAll
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
<%@ page import="java.util.Date" %>

<cs:ftcs>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment" />
<%
if(!ics.UserIsMember("xceleditor"))
{
	ics.SetVar("userAuth","false");
	return;
}
%>
<ics:callelement element="OpenMarket/Xcelerate/Admin/CheckIsUserAdmin"> 
	<ics:argument name="adminRoleToCheck" value="GeneralAdmin" />
</ics:callelement><%
if(Boolean.valueOf(ics.GetVar("userIsGeneralAdmin")))
{
	try
	{
		 String blobId = SysInfoUtils.processDownload(ics,application);
		 String zipArg = "attachment;filename=SysInfo.zip";
	
	%>
	<satellite:blob assembler="query" service='<%=ics.GetVar("empty")%>'
		blobtable="MungoBlobs"
		blobkey="id"
		blobwhere='<%=blobId%>'
		blobcol="urldata"
		csblobid='<%=ics.GetSSVar("csblobid")%>'
		outstring="sysInfoURL"
		blobnocache="true">
		<satellite:argument name="blobheadername1" value="content-type"/>
		<satellite:argument name="blobheadervalue1" value="application/octet-stream"/>
		<satellite:argument name="blobheadername2" value="Content-Disposition"/>
		<satellite:argument name="blobheadervalue2" value='<%=zipArg%>'/>
		<satellite:argument name="blobheadername3" value="MDT-Type"/>
		<satellite:argument name="blobheadervalue3" value="abinary; charset=UTF-8"/>
	</satellite:blob>
	_FW_MARKER1_{'outPutUrl':'<%=ics.GetVar("sysInfoURL")%>'}_FW_MARKER2_
	<%
	}
	catch(Exception e)
	{
	%>
	_FW_MARKER1_{"X-errorMessage":"<%= e.getMessage().replace("\"","\\\"") %>"}_FW_MARKER2_
	<%}
} else{%>
	<xlat:lookup key="dvin/UI/Error/notallowedtoviewpage" encode="false" varname="msg"/>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
		<ics:argument name="msgtext" value='<%=ics.GetVar("msg")%>'/>
		<ics:argument name="severity" value="error"/>
	</ics:callelement>
<%}%>
</cs:ftcs>