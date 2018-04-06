<%@page import="java.util.regex.PatternSyntaxException"%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%
//
// fatwire/systemtools/SystemInfo/ThreadDump
//
// INPUT
//
// OUTPUT
//
%><%@ page import="java.lang.management.ManagementFactory"
%><%@ page import="java.lang.management.ThreadInfo"
%><%@ page import="java.util.regex.Pattern"
%><%@ page import="java.lang.Thread.State"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="com.fatwire.cs.systemtools.systeminfo.ThreadDump"
%><%@ page import="com.fatwire.realtime.util.Util"
%><cs:ftcs>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment" />
<html>
<HEAD>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/LoadDojo"/>
<link href='<%=ics.GetVar("cs_imagedir")%>/../js/fw/css/ui/global.css' rel="styleSheet" type="text/css">
<link href='<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale")%>/common.css' rel="styleSheet" type="text/css">
<link href='<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale")%>/content.css' rel="styleSheet" type="text/css">
<ics:callelement element="OpenMarket/Xcelerate/Util/LoadDefaultStyleSheet">
	<ics:argument name="cssFilesToLoad" value="common.css,content.css"/>
</ics:callelement>
</HEAD>
<BODY>
<ics:callelement element="OpenMarket/Gator/UIFramework/UITimeOutCheck" />
<ics:callelement element="OpenMarket/Xcelerate/Admin/CheckIsUserAdmin"> 
	<ics:argument name="adminRoleToCheck" value="GeneralAdmin" />
</ics:callelement><%
if(Boolean.valueOf(ics.GetVar("userIsGeneralAdmin")))
{
		String threadDump= null;
		try
		{
			threadDump = ThreadDump.processThreadDumpRequest(ics);
			if("".equals(threadDump))
			{
			    String noResults = Util.xlatLookup(ics,"fatwire/SystemTools/SystemInfo/ThreadInfo/NoResults");
				%>
				<ics:callelement element="fatwire/systemtools/SystemInfo/ThreadInfo">
					<ics:argument name="errorMessage" value='<%=noResults%>'/>
					<ics:argument name="severity" value='info'/>
				</ics:callelement>
				<%
			}else{
			%>
			
			<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
			<tr><td>
			<span class="title-text"><xlat:stream key="fatwire/SystemTools/SystemInfo/ThreadInfo/ThreadDump" /></span>
			</td></tr>
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
				<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
				<tr>
				<td><textarea style="width:100%;height:800px;" readonly="readonly"><%=threadDump%></textarea></td>
				</tr>
			</table>
			<%
			}
		}
		catch(PatternSyntaxException e)
		{
		    String errorMsg = Util.xlatLookup(ics,"fatwire/SystemTools/SystemInfo/ThreadInfo/errorMessage") +" "+ e.getLocalizedMessage();
			%>
			<ics:callelement element="fatwire/systemtools/SystemInfo/ThreadInfo">
				<ics:argument name="errorMessage" value='<%=errorMsg%>'/>
				<ics:argument name="severity" value='error'/>
			</ics:callelement>
			<%   
		}
}else{
%>
	<xlat:lookup key="dvin/UI/Error/notallowedtoviewpage" encode="false" varname="msg"/>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
		<ics:argument name="msgtext" value='<%=ics.GetVar("msg")%>'/>
		<ics:argument name="severity" value="error"/>
	</ics:callelement>
<%
}
%>
</BODY>
</html>
</cs:ftcs>