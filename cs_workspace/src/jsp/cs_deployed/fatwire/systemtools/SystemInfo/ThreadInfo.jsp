<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// fatwire/systemtools/SystemInfo/ThreadInfo
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
<%@ page import="java.lang.management.ManagementFactory"
%><%@ page import="java.lang.management.ThreadInfo"
%><%@ page import="java.lang.management.ThreadMXBean"
%><%@ page import="com.fatwire.cs.systemtools.systeminfo.ThreadDump"
%><%@ page import="java.util.regex.Pattern"%>
<%@ page import="java.lang.Thread.State"%>
<%@ page import="COM.FutureTense.Interfaces.Utilities"%>
<%
final String VAR_REQHANDLERURL = "requestURL";
%>
<cs:ftcs>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment" />
<ics:callelement element="OpenMarket/Gator/UIFramework/UITimeOutCheck" />
<ics:callelement element="OpenMarket/Xcelerate/Admin/CheckIsUserAdmin"> 
	<ics:argument name="adminRoleToCheck" value="GeneralAdmin" />
</ics:callelement><%
if(Boolean.valueOf(ics.GetVar("userIsGeneralAdmin")))
{
    // final String defaultLocale = ics.GetSSVar("locale");
    final String defaultLocale = "en_US";
%>
<satellite:link assembler="query" pagename='fatwire/systemtools/SystemInfo/Download' outstring='createZipURL' />
<satellite:link assembler="query" pagename='fatwire/systemtools/SystemInfo/ThreadDump' outstring='<%= VAR_REQHANDLERURL%>' />
<html>
<HEAD>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/LoadDojo"/>
<link href='<%=ics.GetVar("cs_imagedir")%>/../js/fw/css/ui/global.css' rel="styleSheet" type="text/css">
<link href='<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale") %>/common.css' rel="styleSheet" type="text/css">
<link href='<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetSSVar("locale") %>/content.css' rel="styleSheet" type="text/css">
<ics:callelement element="OpenMarket/Xcelerate/Util/LoadDefaultStyleSheet">
	<ics:argument name="cssFilesToLoad" value="common.css,content.css"/>
</ics:callelement>
<script language="JavaScript" src='<%=request.getContextPath()%>/js/prototype.js'></script>
<ics:callelement element="fatwire/systemtools/SystemInfo/SysInfoCommons" />
<script language="JavaScript">
function check_before_submit(download) {

		var target = document.forms[0].elements['ThreadStateOptions'];
		   var sel = false;
		   for(i=0;i<target.options.length;i++) {
		     if (target.options[i].selected) {
				sel = true;
				break;
			 }
		   }
		 
		if(download === 'false')
			{
			document.forms[0].action = '<%= ics.GetVar(VAR_REQHANDLERURL) %>';
			document.forms[0].submit();
			}
		else
		{
			execute('<%=ics.GetVar("createZipURL")%>','threadInfo');
		}
		
		  
}
</script>
<%
 String errMessage = ics.GetVar("errorMessage");
 String errSeverity = ics.GetVar("severity");
 if(!"".equals(errMessage) && errMessage!=null)
 {%>
 	<div class="width-outer-70">
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage" >
		<ics:argument name="msgtext" value='<%=errMessage%>'/>
		<ics:argument name="severity" value='<%=errSeverity%>'/>
	</ics:callelement>
	</div>
<%}%>
<satellite:form name="appForm" id="appForm" action='<%=ics.GetVar(VAR_REQHANDLERURL) %>' method="post">
<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key="fatwire/SystemTools/SystemInfo/ThreadInfo/ThreadInfo" /></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>
<ics:callelement element="fatwire/systemtools/SystemInfo/ShowLoading" />
<table class="width-outer-70" BORDER="0" CELLSPACING="0" CELLPADDING="0">
<tr>
  <td>
    <table class="width-inner-100">
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
	<tr>
		<td class="form-label-text" style="width:100px;">
		<xlat:stream key="fatwire/SystemTools/SystemInfo/ThreadInfo/ThreadNameInput"/>:</td>
		<td>
		<input type="text" name="thread_name" value=".*" />&nbsp;&nbsp;
		<xlat:stream key="fatwire/SystemTools/SystemInfo/ThreadInfo/RegularExpression"/>:<input style="position:relative;top:2px;" type="checkbox" name="regex" value="selected" checked/>
		</td>
		<td></td>
	</tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
	<tr>
		<td class="form-label-text"  style="width:100px;" VALIGN="TOP" ALIGN="LEFT"><xlat:stream key="fatwire/SystemTools/SystemInfo/ThreadInfo/States" />:</td>
		<td VALIGN="TOP" ALIGN="LEFT">
				<%
				Thread.State[] states  = Thread.State.values();
				%>
				<select name="ThreadStateOptions" SIZE='<%=states.length -1 %>' MULTIPLE="yes" style="width:200px;">
				<%
				for(Thread.State state : states ) {
					if(!"TERMINATED".equalsIgnoreCase(state.name())) {
					%>
					<option value='<%= state.name() %>'><%= state.name() %></option>
					<%}
				}%>
				</select>
		</td>
		<td></td>
	</tr>
	 <xlat:lookup key="fatwire/SystemTools/SystemInfo/ShowResults" varname="ShowResults"/>
<xlat:lookup key="fatwire/SystemTools/SystemInfo/Download" varname="Download"/>

	 <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar"/>
	<tr>
	<TD class="form-label-text"></TD><TD class="form-inset">
		<a href='#' onclick="check_before_submit('false');"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton">
			<ics:argument name="buttonkey" value="UI/Forms/ShowResults"/></ics:callelement>
		</a>
		
		<%
		if(ThreadDump.enableThreadDump()){
		%>
		<a href='#' onclick="check_before_submit('true');"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Download"/></ics:callelement></a>
	</TD>
	</tr>
	</table>
    </td>
  </tr>
  
 
  	
</table>


<%}else { %><xlat:lookup key="fatwire/SystemTools/SystemInfo/ThreadInfo/NoDownload" encode="false" varname="msg"/>
	<div class="width-outer-70">
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
		<ics:argument name="msgtext" value='<%=ics.GetVar("msg")%>'/>
		<ics:argument name="severity" value="info"/>
	</ics:callelement>
	</div>	
<%} %>
</satellite:form>
</html>
<%}else{
%>
	<xlat:lookup key="dvin/UI/Error/notallowedtoviewpage" encode="false" varname="msg"/>
	<div class="width-outer-70">
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
		<ics:argument name="msgtext" value='<%=ics.GetVar("msg")%>'/>
		<ics:argument name="severity" value="error"/>
	</ics:callelement>
	</div>
<%
}
%>

</cs:ftcs>