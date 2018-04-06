<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Errors/en_US/TimeoutErrorPopup
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
<property:get param="xcelerate.charset" inifile="futuretense_xcel.ini" varname="charset"/>
<ics:setvar name="cs.contenttype" value='text/html; charset=<%=ics.GetVar("charset")%>'/>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment"/>
<%
String imageDir = ics.GetVar("cs_imagedir");
String locale = ics.GetSSVar("locale");
%>
<html>
<head>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/StandardHeader"/>
<title><XLAT:STREAM KEY="UI/ErrorHTML/CSTimeoutErrorHeader" ESCAPE="false" ENCODE="false"/></title>
<link href='<%=imageDir%>/data/css/<%=locale%>/login.css' rel="styleSheet" type="text/css"/>
<ics:callelement element="OpenMarket/Xcelerate/Util/LoadDefaultStyleSheet">
	<ics:argument name="cssFilesToLoad" value="login.css"/>
</ics:callelement>
<script type='text/javascript'>
function actionOnClose() {
if(window.opener != null )
 window.opener.parent.parent.location = '<%=imageDir%>'+'/LoginPage.html';
 window.close();
}
</script>
</head>
<body bgcolor="e8eaeb">
<table width="100%" height="95%" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td width="50%"></td>
		<td width="1%" valign="middle">
			<table cellpadding="0" cellspacing="0" border="0">
			<tr>
			<td></td>
			<td><img src='<%=imageDir%>/graphics/common/logo/spacer.gif' width="440" height="1" border="0" /><br /></td>
			<td rowspan="2" background='<%=imageDir%>/graphics/common/logo/verticalshadow.gif'>
			<img src='<%=imageDir%>/graphics/common/logo/spacer.gif' width="4" height="1" border="0" /><br /></td>
			</tr>							   
			<tr>
			<td><img src='<%=imageDir%>/graphics/common/logo/spacer.gif' width="1" height="345" border="0"/><br /></td>
			<td>
				<table border="0" cellpadding="0" cellspacing="0"><!-- border outter table BEGIN -->
				<tr>
				<td>

				<table cellpadding="0" cellspacing="0" style="border: 1px solid #777;"><!-- border inner table BEGIN -->
				<tr>
				<td>

				<table width="440" height="370" cellpadding="0" cellspacing="0" background='<%=imageDir%>/graphics/common/logo/timeout_login_upper.jpg' style="background-repeat: no-repeat;" bgcolor="#ffffff" class="tableborder">
				<tr>
				<td valign="top">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td><img src='<%=imageDir%>/graphics/common/logo/spacer.gif' width="1" height="65" border="0"/><br /></td>
						</tr>
						<tr>
							<td><img src='<%=imageDir%>/graphics/<%=locale%>/logo/timeout_message.gif' width="223" height="27" hspace="29"/></td>
						</tr>
						<tr>
							<td><img src='<%=imageDir%>/graphics/common/logo/spacer.gif' width="20" height="15" align="top" /></td>
						</tr>
						<tr>
							<td> <span class="timeoutfontstyle7"><XLAT:STREAM KEY="UI/ErrorHTML/CSTimeoutReason" ESCAPE="false" ENCODE="false"/></span>
								<ul class="timeoutlist">
									<XLAT:STREAM KEY="UI/ErrorHTML/CSTimeoutReasons" ESCAPE="false" ENCODE="false"/>
								</ul>
								<span class="timeoutfontstyle7"><XLAT:STREAM KEY="UI/ErrorHTML/UnsavedMessage" ESCAPE="false" ENCODE="false"/></span>
							</td>
						</tr>
					</table>
				</td>
				</tr>
				<tr>
				<td valign="top">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td><img src='<%=imageDir%>/graphics/common/logo/spacer.gif' width="25" height="15" /></td>
						</tr>
						<tr>
							<td></td>
							<td><img src='<%=imageDir%>/graphics/common/logo/timeout_timeout.gif' width="85" height="85"/></td>
							<td><img src='<%=imageDir%>/graphics/common/logo/spacer.gif' width="25" height="15"/></td>
							<td>
								<table cellpadding="0" cellspacing="0" border="0">
								<tr align="left" valign="top">
								<td class="timeoutfontstyle9" style="padding-left:10px;"><XLAT:STREAM KEY="dvin/UI/Error/ContactSysAdmin" ESCAPE="false" ENCODE="false"/></td>
								</tr>
								<tr>
								<td height="15" align="left" valign="top"><img src='<%=imageDir%>/graphics/common/logo/spacer.gif' width="10" height="15"/></td>
								</tr>
								<tr>
								<td align="left" valign="top" style="padding-left:10px;"><span class="timeoutfontstyle4"><A href='javascript:actionOnClose();' class="timeoutlogin" ><XLAT:STREAM KEY="dvin/UI/Pleaseloginagain" ESCAPE="false" ENCODE="false"/></A> <a class="timeoutfontstyle4"> <a class="timeoutfontstyle4"> >></a></span> </td>
								</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
				</tr>
				</table>
				</td>
				</tr>
				</table><!-- border inner table END -->

				</td>
				</tr>
				</table><!-- border outter table END -->
			</td>
			</tr>
			<tr>
			<td><img src='<%=imageDir%>/graphics/common/logo/spacer.gif' width="1" height="4" border="0" /><br /></td>
			<td colspan="2"><img src='<%=imageDir%>/graphics/common/logo/horizontalshadow.gif' width="446" height="5" /><br /></td>
			</tr>
			</table>

		</td>
		<td width="49%"></td>
	</tr>
</table>

</body>
</html>
</cs:ftcs>