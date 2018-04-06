<%@page import="java.util.Enumeration"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// fatwire/systemtools/SystemInfo/SysInfoDownload
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
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment" />
<ics:callelement element="OpenMarket/Gator/UIFramework/UITimeOutCheck" />
<ics:callelement element="OpenMarket/Xcelerate/Admin/CheckIsUserAdmin"> 
	<ics:argument name="adminRoleToCheck" value="GeneralAdmin" />
</ics:callelement><%
if(Boolean.valueOf(ics.GetVar("userIsGeneralAdmin")))
{
%>
<html>
<head>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/LoadDojo"/>
<link href='<%=ics.GetVar("cs_imagedir")%>/../js/fw/css/ui/global.css' rel="styleSheet" type="text/css">
<satellite:link pagename="fatwire/systemtools/SystemInfo/Download" assembler="query" outstring="createZipURL">
<satellite:parameter name="op" value='<%=ics.GetVar("op") %>' />
</satellite:link>
<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/Security/TimeoutError" outstring="urlTimeoutError"/>
<script language="JavaScript" src='<%=request.getContextPath()%>/js/prototype.js'></script>
<script type="text/javascript">
function execute(url){
	var warningMessage = '<xlat:stream key="fatwire/SystemTools/SystemInfo/PerformanceWarning" encode="false" escape="true"/>';
	var val= confirm(warningMessage);
	if(val)
	{
	showLoading();
	new Ajax.Request(url, {
	method: 'get',
	onSuccess: function(transport) {
			var respText= transport.responseText,
				index1 = respText.indexOf('_FW_MARKER1_'),
				index2 = respText.indexOf('_FW_MARKER2_'),
				json = respText.substring(index1+12,index2).evalJSON(),
				urlValue = json['outPutUrl'],
				errorMessage;
			
			if(urlValue && urlValue !== '')
			{
				hideLoading();
				location.href=urlValue;
			}
			else
			{
				errorMessage = json['X-errorMessage'];
				if(errorMessage && errorMessage !== '')
				{
					$('processing').style.display='none';
					$('errorOccured').style.display='block';
					$('errorMessageID').innerHTML = errorMessage;
				}
			}
	},onComplete: function(transport) { 
		var header = transport.getResponseHeader("userAuth");
		if(header == "false")
			parent.parent.location='<%=ics.GetVar("urlTimeoutError")%>';
	}
});
	}
	else
		{
		$('ajaxLoading').style.display='block';
		$('userCancelled').style.display='block';
		 return;
		}
}
function showLoading(){
	$('ajaxLoading').style.display='block';
	$('processing').style.display='block';
}
function hideLoading(){
	$('processing').style.display='none';
	$('processingCompleted').style.display='block';
}
</script>

</head>
<body onload="execute('<%=ics.GetVar("createZipURL")%>');">
<ics:callelement element="fatwire/systemtools/SystemInfo/ShowLoading" />
</body>
</html>
<%}else{
%>
	<xlat:lookup key="dvin/UI/Error/notallowedtoviewpage" encode="false" varname="msg"/>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
		<ics:argument name="msgtext" value='<%=ics.GetVar("msg")%>'/>
		<ics:argument name="severity" value="error"/>
	</ics:callelement>
<%}%>
</cs:ftcs>