<%@page import="com.fatwire.cs.systemtools.logs.LogCommons"
%><%@page import="com.fatwire.cs.systemtools.logs.LogCommons.UIConstants"
%><%@page import="com.fatwire.cs.systemtools.logs.LogCommons.Action"
%><%@page import="com.fatwire.cs.systemtools.logs.processor.LogAnalyzer"
%><%@page import="com.fatwire.cs.systemtools.logs.beans.Log"
%><%@page import="COM.FutureTense.Interfaces.FTValList"
%><%@page import="COM.FutureTense.Interfaces.ICS"
%><%@page import="COM.FutureTense.Interfaces.IList"
%><%@page import="COM.FutureTense.Interfaces.Utilities"
%><%@page import="COM.FutureTense.Util.ftErrors"
%><%@page import="COM.FutureTense.Util.ftMessage"
%><%// fatwire/systemtools/logs/logViewerHome
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><cs:ftcs>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment"/>
<ics:callelement element="OpenMarket/Gator/UIFramework/UITimeOutCheck" />
<html><head>
<ics:callelement element="fatwire/systemtools/logs/logCommons" /><%
if(Boolean.valueOf(ics.GetVar("logOK")))
{
	final String CS_IMAGEDIR = ics.GetVar("cs_imagedir");
    final String CS_LOCALE = ics.GetSSVar("locale");
    // final String CS_LOCALE_NEW_BUTTONS = CS_LOCAL;
    final String CS_LOCALE_NEW_BUTTONS = "en_US";
%>
<script>
window.onload = function()
{
	resetSearchForm();
	setHotKeys();
	actions['<%= Action.FETCH%>']();
};

function resetSearchForm()
{
	var flags = document.getElementsByName('<%= LogAnalyzer.FLAGS%>');
	flags[0].checked = <%= UIConstants.DEFAULT_FLAGS_CHECKED[0]%>;
	flags[1].checked = <%= UIConstants.DEFAULT_FLAGS_CHECKED[1]%>;
	flags[2].checked = <%= UIConstants.DEFAULT_FLAGS_CHECKED[2]%>;
	flags[3].checked = <%= UIConstants.DEFAULT_FLAGS_CHECKED[3]%>;
	flags[4].checked = <%= UIConstants.DEFAULT_FLAGS_CHECKED[4]%>;
	
	// Set flags
	document.getElementById('<%= UIConstants.ELEM_FLAGS_LABEL[1]%>').style.display = 'none';
	document.getElementById('<%= UIConstants.ELEM_FLAGS_LABEL[3]%>').style.display = 'none';
	document.getElementById('<%= UIConstants.ELEM_FLAGS_LABEL[4]%>').style.display = 'none';

	flags[0].onclick = function()
	{
		if (flags[0].checked)
			document.getElementById('<%= UIConstants.ELEM_FLAGS_LABEL[1]%>').style.display = 'inline';
		else
		{
			flags[1].checked = false;
			document.getElementById('<%= UIConstants.ELEM_FLAGS_LABEL[1]%>').style.display = 'none';
		}
	};
	
	flags[1].onclick = function()
	{
		if (!flags[0].checked)
			flags[1].checked = false;
	};
	
	flags[2].onclick = function()
	{
		if (flags[2].checked)
		{
			document.getElementById('<%= UIConstants.ELEM_FLAGS_LABEL[3]%>').style.display = 'inline';
			document.getElementById('<%= UIConstants.ELEM_FLAGS_LABEL[4]%>').style.display = 'inline';
		}
		else
		{
			flags[3].checked = false;
			flags[4].checked = false;
			document.getElementById('<%= UIConstants.ELEM_FLAGS_LABEL[3]%>').style.display = 'none';
			document.getElementById('<%= UIConstants.ELEM_FLAGS_LABEL[4]%>').style.display = 'none';
		}
	};
	
	flags[3].onclick = function()
	{
		if (!flags[2].checked)
			flags[3].checked = false;
	};
	
	flags[4].onclick = function()
	{
		if (!flags[2].checked)
			flags[4].checked = false;
	};
	
	var q = document.getElementById('<%= LogAnalyzer.QUERY%>');
	q.innerHTML = "<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "DefaultSearchExpression"%>'/>";
	q.onclick = function()
	{
		document.getElementById('<%= LogAnalyzer.QUERY%>').innerHTML='';
		q.onclick = null;
	};
	document.getElementById('<%= LogAnalyzer.QUERY%>').focus();
	document.getElementById('<%= LogAnalyzer.SEARCHLINE1%>').value = '0';
}


function checkTimeOut()
{
    
	new Ajax.Request('ContentServer', {
    	method : 'get',
    	parameters: {pagename:'<%=UIConstants.PAGE_REQHANDLER%>', <%=UIConstants.VAR_TIMEOUTTEST%>: true },
    	onSuccess: function(transport){
		var callbackVals = createCallBackJSON(transport.responseText.strip(),'_CALLBACK_VALS_BEGIN_','_CALLBACK_VALS_END_');
		var header = callbackVals['<%=UIConstants.X_UITIMEOUTTEST%>'];
		if( header != undefined && header != null && header !== "" )
			parent.parent.location = header;
    	}
	});
	
}
function goToLog(stLine)
{
	checkTimeOut();
	var vUrl = '<%= ics.GetVar(UIConstants.VAR_VIEWERURL)%>' + '&<%= LogAnalyzer.LINE2%>=' + stLine + '&<%= LogAnalyzer.PAGESIZE%>=' + '<%= UIConstants.DEFAULT_PAGESIZE%>';
	window.open(vUrl, '<%= UIConstants.VAR_VIEWERURL%>', 'scrollbars=yes,directories=no,location=no,menubar=no,resizable=yes,status=no,toolbar=no,scrollbars=yes');
}

function tailLog()
{	
	//Make an Ajax request to check if user has timeout.
	checkTimeOut();
	var vUrl = '<%= ics.GetVar(UIConstants.VAR_TAILERURL)%>' + '&<%= LogAnalyzer.PAGESIZE%>=' + document.getElementById('<%= LogAnalyzer.PAGESIZE%>').value;
	window.open(vUrl, '<%= UIConstants.VAR_TAILERURL%>', 'scrollbars=yes,directories=no,location=no,menubar=no,resizable=yes,status=no,toolbar=no,scrollbars=yes');	
}

var hotkeyListeners =
{
		<%= UIConstants.ELEM_VIEWBUTTON%>: "<%= Action.FETCH%>",
		<%= UIConstants.ELEM_DOWNLOADBUTTON%>: "<%= Action.EXPORT%>",
		<%= UIConstants.ELEM_SEARCHBUTTON%>: "<%= Action.SEARCH%>"
};

function setHotKeys()
{
	var elem;
	//reuse the same listener logic between keyup and click events where possible
	for (elem in hotkeyListeners)
	{
		// Failsafe in case of frameworks augmenting Object prototype with enumerable properties
		if (!hotkeyListeners.hasOwnProperty(elem)) { continue; }
		document.getElementById(elem).href = "javascript:actions." + hotkeyListeners[elem] + "();";
	}
	
	document.onkeyup = function(event)
	{
		event = event || window.event;
		var k = event.which || event.keyCode;
		// Ctrl + V
		if(event.ctrlKey && k == 86)
			actions[hotkeyListeners.<%= UIConstants.ELEM_VIEWBUTTON%>]();
		// Ctrl + L
		if(event.ctrlKey && k == 76)
			tailLog();
		// Ctrl + S
		if(event.ctrlKey && k == 83)
			actions[hotkeyListeners.<%= UIConstants.ELEM_DOWNLOADBUTTON%>]();
		// Ctrl + Enter
		if(event.ctrlKey && k == 13)
			actions[hotkeyListeners.<%= UIConstants.ELEM_SEARCHBUTTON%>]();
		// Alt + 1
		if(event.altKey && k == 49)
			document.getElementsByName('<%= LogAnalyzer.FLAGS%>')[0].click();
		// Alt + 2
		if(event.altKey && k == 50)
			document.getElementsByName('<%= LogAnalyzer.FLAGS%>')[1].click();
		// Alt + 3
		if(event.altKey && k == 51)
			document.getElementsByName('<%= LogAnalyzer.FLAGS%>')[2].click();
		// Alt + 4
		if(event.altKey && k == 52)
			document.getElementsByName('<%= LogAnalyzer.FLAGS%>')[3].click();
		// Alt + 5
		if(event.altKey && k == 53)
			document.getElementsByName('<%= LogAnalyzer.FLAGS%>')[4].click();
	};
}
</script>
</head><body>

<ics:setvar name="serverTimeZone" value='<%=java.util.TimeZone.getDefault().getID()%>' />
<xlat:lookup key='UI/Forms/datesInServerTime' varname="datesInServerTime"/>
<div class="width-outer-70">
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
				<ics:argument name="msgtext" value='<%=ics.GetVar("datesInServerTime")%>'/>
				<ics:argument name="severity" value="info" />
			</ics:callelement>
</div>
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
<input type="hidden" id='<%= UIConstants.VAR_LITE%>' name='<%= UIConstants.VAR_LITE%>' value="true"/>
<input type="hidden" id='<%= LogAnalyzer.LINE1%>' name='<%= LogAnalyzer.LINE1%>'/>
<input type="hidden" id='<%= LogAnalyzer.LINE2%>' name='<%= LogAnalyzer.LINE2%>'/>
<input type="hidden" id='<%= LogAnalyzer.SEARCHLINE1%>' name='<%= LogAnalyzer.SEARCHLINE1%>'/>
<table class="width-outer-70"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="16" nowrap="nowrap">
		<div class="form-inset">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td>
					<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td nowrap="nowrap">
								<xlat:lookup key="fatwire/Alloy/UI/PickADate" varname="pickADateString" />
								<xlat:lookup key="fatwire/Alloy/UI/DatePicker" varname="datePickerString" />
								<div class="form-inset"  style="display: table;">
									<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "Date"%>'/>
									<div id='<%= LogAnalyzer.DATE1%>' name='<%= LogAnalyzer.DATE1%>' dojoType="fw.dijit.UIInput"  clearButton="true" readonly="true"></div>
									<DIV ID="<%= LogAnalyzer.DATE1 + "Div"%>" STYLE="display:none"></DIV>
									<ics:callelement element="OpenMarket/Xcelerate/Scripts/DateTimeWidget">
										<ics:argument name="inputFieldId" value="<%= LogAnalyzer.DATE1%>"/>
									</ics:callelement>
								</div>
							</td>
							<td>
								<div class="form-inset">
									<select id='<%= LogAnalyzer.PAGESIZE%>' name='<%= LogAnalyzer.PAGESIZE%>'><%for(String size : UIConstants.ELEM_PAGESIZE_OPTS) {%><option value='<%= size%>' <%= UIConstants.DEFAULT_PAGESIZE.equals(size) ? "selected" : ""%>><%= size%></option><%}%>
									</select>&nbsp;<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "ItemsPerPage"%>'/>
								</div>
							</td>
							<td align="right">
								<a id='<%= UIConstants.ELEM_VIEWBUTTON%>' href="#"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/ViewLogs"/></ics:callelement></a>
							</td>
						</tr>
					</table>
					</td>
					
				</tr>
			</table>
		</div>
		<div class="form-inset">
			<table border="0" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td align="center">
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td align="center">
								<div id='<%= UIConstants.ELEM_QTEXTERR%>' class="form-inset" style='display: none;'>
								<img width="15" height="15" src='<%= CS_IMAGEDIR%>/graphics/common/msg/error.gif'/>&nbsp;<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "NoSearchString"%>'/>
								</div>
							</td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td>
								<div class="form-inset">
								<textarea rows="6" cols="65" style="resize:none;" id='<%= LogAnalyzer.QUERY%>' name='<%= LogAnalyzer.QUERY%>'></textarea>
								</div>
							</td>
							<td>
								<div class="form-inset" style="white-space:nowrap;">
								<%for(int i=0; i<UIConstants.ELEM_FLAGS_LABEL.length; i++) {%><label id='<%= UIConstants.ELEM_FLAGS_LABEL[i]%>' title="<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + UIConstants.ELEM_FLAGS_TITLE[i]%>'/>"><input type="checkbox" name='<%= LogAnalyzer.FLAGS%>' value='<%= UIConstants.ELEM_FLAGS_VALUE[i]%>' <%= UIConstants.ELEM_FLAGS_CHECKED[i] ? "checked=\"checked\"" : ""%> /><xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + UIConstants.ELEM_FLAGS_LABEL[i]%>'/>&nbsp;<img width="15" height="15" src='<%= CS_IMAGEDIR%>/graphics/common/icon/help_new.png'/><br/></label><%}%>
								</div>
							</td>
						</tr>
						<tr>
						<td colspan="2">
							<table border="0" cellpadding="0" cellspacing="0">
							<tr>
							<td>
							<div class="form-inset" style="display:inline">
								<select id='<%= LogAnalyzer.SEARCHSIZE%>' name='<%= LogAnalyzer.SEARCHSIZE%>'><%for(String size : UIConstants.ELEM_SEARCHSIZE_OPTS) {%><option value='<%= size%>' <%= UIConstants.DEFAULT_SEARCHSIZE.equals(size) ? "selected" : ""%>><%= size%></option><%}%>
								</select>&nbsp;<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "ResultsPerPage"%>'/>
							</div>	
							</td><td>
						
								<a id='<%= UIConstants.ELEM_SEARCHBUTTON%>' style='display: inline;' href="javascript:actions.<%= Action.SEARCH%>();"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/SearchLogs"/></ics:callelement></a>
						</td>
						</tr>
						</table>
						</td>
						</tr>
					</table>
					</td>
				</tr>
			</table>
		</div>
		</td>
		
	</tr>
</table>
<div class="width-outer-70">
	<a style="display: inline-block;" id='<%= UIConstants.ELEM_DOWNLOADBUTTON%>' href="javascript:actions.<%= Action.EXPORT%>()"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/DownloadLogs"/></ics:callelement></a>
	<a style="display: inline-block;" id='<%= UIConstants.ELEM_TAILBUTTON%>' href="javascript:tailLog()"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/TailLogs"/></ics:callelement></a>
</div>

</satellite:form>
<ics:callelement element="fatwire/systemtools/logs/logOutput" /><%
}%></body></html></cs:ftcs>