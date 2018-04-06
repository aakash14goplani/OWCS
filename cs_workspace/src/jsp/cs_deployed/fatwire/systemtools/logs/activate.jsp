<%@ page import="COM.FutureTense.Interfaces.FTValList" 
%><%@page import="com.fatwire.cs.systemtools.logs.LogCommons.UIConstants"
%><%@page import="COM.FutureTense.Interfaces.FTValList"
%><%@page import="COM.FutureTense.Interfaces.ICS"
%><%@page import="COM.FutureTense.Interfaces.IList"
%><%@page import="COM.FutureTense.Interfaces.Utilities"
%><%@page import="COM.FutureTense.Util.ftErrors"
%><%@page import="COM.FutureTense.Util.ftMessage"
%><%// fatwire/systemtools/logs/activate
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><cs:ftcs><%
boolean logOK = true;
final String CS_LOCALE = ics.GetSSVar("locale");
%><!-- Check General Admin -->
<ics:callelement element="OpenMarket/Xcelerate/Admin/CheckIsUserAdmin"> 
	<ics:argument name="adminRoleToCheck" value="GeneralAdmin" />
</ics:callelement>
<%
String strRender = ics.GetVar("render");
boolean render = strRender == null ? true : Boolean.valueOf(strRender);
if(!Boolean.valueOf(ics.GetVar("userIsGeneralAdmin")))
{
    logOK = false;
	if (render)
	{
%><xlat:lookup key="dvin/UI/Error/notallowedtoviewpage" encode="false" varname="msg"/>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
		<ics:argument name="msgtext" value='<%=ics.GetVar("msg")%>'/>
		<ics:argument name="severity" value="error"/>
	</ics:callelement><%
	}
}
if (logOK)
{%><!-- Check Log4j -->
<ics:callelement element="fatwire/systemtools/Log4J/CheckLog4J" />
<%
	if(!Boolean.valueOf(ics.GetVar("Log4J")))
	{
		logOK = false;
		if (render)
		{
%><xlat:lookup encode="false" varname="logsinactive" locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "LogsInactive"%>'/><div>
			<table align="center">
				<tr>
					<td><div style="color: red" id='<%= UIConstants.ELEM_ERROR%>'><ics:getvar name="logsinactive" /></div></td>
				</tr>
			</table>
		</div><%
		}
	}
}%><ics:setvar name="logOK" value='<%= String.valueOf(logOK)%>' />
</cs:ftcs>