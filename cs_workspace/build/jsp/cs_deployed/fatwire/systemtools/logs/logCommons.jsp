<%@page import="com.fatwire.cs.systemtools.logs.LogCommons.Action"
%><%@page import="com.fatwire.cs.systemtools.logs.processor.LogAnalyzer"
%><%@ page import="COM.FutureTense.Interfaces.FTValList" 
%><%@page import="com.fatwire.cs.systemtools.logs.LogCommons.UIConstants"
%><%@page import="COM.FutureTense.Interfaces.FTValList"
%><%@page import="COM.FutureTense.Interfaces.ICS"
%><%@page import="COM.FutureTense.Interfaces.IList"
%><%@page import="COM.FutureTense.Interfaces.Utilities"
%><%@page import="COM.FutureTense.Util.ftErrors"
%><%@page import="COM.FutureTense.Util.ftMessage"
%><%// fatwire/systemtools/logs/logCommons
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><cs:ftcs>
<satellite:link assembler="query" pagename='<%= UIConstants.PAGE_VIEWER%>' outstring='<%= UIConstants.VAR_VIEWERURL%>' />
<satellite:link assembler="query" pagename='<%= UIConstants.PAGE_TAILER%>' outstring='<%= UIConstants.VAR_TAILERURL%>' />
<satellite:link assembler="query" pagename='<%= UIConstants.PAGE_REQHANDLER%>' outstring='<%= UIConstants.VAR_REQHANDLERURL%>' />
<satellite:link assembler="query" pagename='<%= UIConstants.PAGE_TIMEOUTERR%>' outstring='<%= UIConstants.VAR_URLTIMEOUTERR%>' /><%
%>
<ics:callelement element="fatwire/systemtools/logs/activate" />
<%if (Boolean.valueOf(ics.GetVar("logOK")))
{
    final String CS_IMAGEDIR = ics.GetVar("cs_imagedir");
    final String CS_LOCALE = ics.GetSSVar("locale");
%>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/LoadDojo"/>
<link href="<%= CS_IMAGEDIR%>/../js/fw/css/ui/global.css" rel="stylesheet" type="text/css"/>
<link href='<%= CS_IMAGEDIR%>/data/css/<%= CS_LOCALE%>/common.css' rel="styleSheet" type="text/css" />
<link href='<%= CS_IMAGEDIR%>/data/css/<%= CS_LOCALE%>/content.css' rel="styleSheet" type="text/css" />
<link href="<%= CS_IMAGEDIR%>/../js/fw/css/ui/Calendar.css" rel="stylesheet" type="text/css" />
<link href="<%= CS_IMAGEDIR%>/../js/fw/css/UIInput.css" rel="stylesheet" type="text/css" />
<ics:callelement element="OpenMarket/Xcelerate/Util/LoadDefaultStyleSheet">
	<ics:argument name="cssFilesToLoad" value="common.css,content.css"/>
</ics:callelement>
<script type="text/javaScript" src='<%=request.getContextPath()%>/js/prototype.js'></script>
<script type="text/javascript">
	dojo.require("fw.ui.dijit.TimestampPicker");
	dojo.require("fw.dijit.UIInput");
	dojo.require("dijit.form.DropDownButton");
	dojo.addOnLoad(function() {dojo.addClass(dojo.body(), 'fw'); });
</script>
<script type="text/javascript">
var actions = 
{
	"<%= Action.EXPORT%>": function()
	{
		doAnalyze('<%= Action.EXPORT%>');
	},

	"<%= Action.FETCH%>": function()
	{
		doAnalyze('<%= Action.FETCH%>');
	},

	"<%= Action.TAIL%>": function()
	{
		doAnalyze('<%= Action.TAIL%>');
	},

	"<%= Action.PREV%>": function()
	{
		doAnalyze('<%= Action.PREV%>');
	},

	"<%= Action.NEXT%>": function()
	{
		doAnalyze('<%= Action.NEXT%>');
	},

	"<%= Action.PREVSEARCH%>": function()
	{
		if (checkQErrors())
			doAnalyze('<%= Action.PREVSEARCH%>');
		else
			return;
	},

	"<%= Action.NEXTSEARCH%>": function()
	{
		if (checkQErrors())
			doAnalyze('<%= Action.NEXTSEARCH%>');
		else
			return;
	},

	"<%= Action.SEARCH%>": function()
	{
		document.getElementById('<%= LogAnalyzer.SEARCHLINE1%>').value = '1';
		actions.<%= Action.NEXTSEARCH%>();
	}

};

var confirmFns = 
{
	forceExecute: function(obj)
	{
		var formAction = obj.formAction;
		document.getElementById('<%= UIConstants.VAR_LITE%>').value = "false";
		doAnalyze(formAction);
	},

	_return: function()
	{
		return;
	}
};

function doAnalyze(formAction)
{
	var dateDiv = document.getElementById('<%= LogAnalyzer.DATE1 + "Div"%>');
	$('<%= UIConstants.FORMID%>').request(
		{
			method: 'post',
			
			parameters: 
			{
				<%= UIConstants.FORMACTION%>: formAction,
				<%= LogAnalyzer.DATE1%>: ( null != dateDiv ? dateDiv.innerHTML :"")
			},
			onCreate: function()
			{
				var msg = '';
				if (formAction === '<%= Action.TAIL%>' || formAction === '<%= Action.FETCH%>' || formAction === '<%= Action.PREV%>' || formAction === '<%= Action.NEXT%>')
				{
					msg = "<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "FetchingLog"%>'/>";
				}
				else if (formAction === '<%= Action.PREVSEARCH%>' || formAction === '<%= Action.NEXTSEARCH%>')
				{
					msg = "<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "SearchingLog"%>'/>";
				}
				else if (formAction === '<%= Action.EXPORT%>')
				{
					msg = "<xlat:stream locale='<%= CS_LOCALE%>' key='<%= UIConstants.CS_XLAT + "GeneratingLog"%>'/>";
				}
				document.getElementById('<%= UIConstants.ELEM_LOADINGMSG%>').innerHTML = msg;
				document.getElementById('<%= UIConstants.ELEM_MESSAGE%>').style.display = 'none';
				document.getElementById('<%= UIConstants.ELEM_ERROR%>').style.display = 'none';
				showLoading();
			},
			onSuccess: function(transport)
			{
				var respText = transport.responseText.strip();				
				var startTag = '_CALLBACK_VALS_BEGIN_';
				var endTag = '_CALLBACK_VALS_END_';
				var text = respText.substring(0,respText.indexOf(startTag));
				var callbackVals = createCallBackJSON(respText,startTag,endTag);
				if(!hasErrors(callbackVals))
				{
					var uiResult = callbackVals['<%=UIConstants.X_UITIMEOUTTEST%>'];
					if(uiResult != undefined && uiResult !== '' && uiResult !== null )
						parent.parent.location = uiResult;
					
					var alertMsg = callbackVals['<%= UIConstants.X_ALERT%>'];
					var confirmMsg = callbackVals['<%= UIConstants.X_CONFIRM%>'];
					if (alertMsg != undefined && alertMsg !== null && alertMsg !== '')
					{
						hideLoading();
						alert(alertMsg);
					}
					else if (confirmMsg != undefined && confirmMsg !== null && confirmMsg !== '')
					{
					    hideLoading();
						var confirmFn = '', confirmArgs = '{}';
						if(confirm(confirmMsg))
						{
						   if(callbackVals.hasOwnProperty('<%= UIConstants.X_CONFIRM_Y_FN%>'))
							confirmFn = callbackVals['<%= UIConstants.X_CONFIRM_Y_FN%>'];
							if(callbackVals.hasOwnProperty('<%= UIConstants.X_CONFIRM_Y_ARGS%>'))
							confirmArgs = callbackVals['<%= UIConstants.X_CONFIRM_Y_ARGS%>'];
						}
						else
						{
							if(callbackVals.hasOwnProperty('<%= UIConstants.X_CONFIRM_N_FN%>'))
							confirmFn = callbackVals['<%= UIConstants.X_CONFIRM_N_FN%>'];
							if(callbackVals.hasOwnProperty('<%= UIConstants.X_CONFIRM_N_ARGS%>'))
							confirmArgs = callbackVals['<%= UIConstants.X_CONFIRM_N_ARGS%>'];
						}
						if (confirmFn)
							confirmFns[confirmFn](confirmArgs.evalJSON(true));
					}
					else
					{
					    if (formAction === '<%= Action.TAIL%>')
						{
							document.getElementById('<%= UIConstants.ELEM_OUTPUT%>').innerHTML = text;
							if (formAction === '<%= Action.TAIL%>')
							{
								var refreshTime = parseInt(<%= UIConstants.TAIL_INTERVAL_MS%>, 10);
								setTimeout("actions.<%= Action.TAIL%>()", refreshTime);
							}
							
						}
						else if (formAction === '<%= Action.FETCH%>' || formAction === '<%= Action.PREV%>' || formAction === '<%= Action.NEXT%>')
						{
							document.getElementById('<%= UIConstants.ELEM_OUTPUT%>').innerHTML = text;
							document.getElementById('<%= LogAnalyzer.LINE1%>').value = callbackVals['<%= LogAnalyzer.LINE1%>'];
							document.getElementById('<%= LogAnalyzer.LINE2%>').value = callbackVals['<%= LogAnalyzer.LINE2%>'];
							var date = null;
							var date1Element = document.getElementById('<%= LogAnalyzer.DATE1 + "Div"%>');
							if (date1Element !== null)
							{
								date = date1Element.value;
							}
						}
						else if (formAction === '<%= Action.PREVSEARCH%>' || formAction === '<%= Action.NEXTSEARCH%>')
						{
							document.getElementById('<%= UIConstants.ELEM_OUTPUT%>').innerHTML = text;
							document.getElementById('<%= LogAnalyzer.SEARCHLINE1%>').value = callbackVals['<%= LogAnalyzer.SEARCHLINE1%>'];
						}
						else if (formAction === '<%= Action.EXPORT%>')
						{
							document.getElementById('<%= UIConstants.ELEM_OUTPUT%>').innerHTML = text;
							location.href = callbackVals['<%= UIConstants.X_XLINK%>'];
						}
						var msg = callbackVals['<%= UIConstants.X_MESSAGE%>'];
						if (msg != undefined && msg !== null && msg !== '')
						{
							document.getElementById('<%= UIConstants.ELEM_MESSAGE%>').style.display = 'inline';
							document.getElementById('<%= UIConstants.ELEM_MESSAGE%>').innerHTML = msg;
						}
						hideLoading();
					}
				}
			},
			onFailure: function(transport)
			{
				var callbackVals = createCallBackJSON(transport.responseText.strip(),'_CALLBACK_VALS_BEGIN_','_CALLBACK_VALS_END_');
				hasErrors(callbackVals);
			},
			onComplete: function(transport)
			{ 
				var callbackVals = createCallBackJSON(transport.responseText.strip(),'_CALLBACK_VALS_BEGIN_','_CALLBACK_VALS_END_');
				var userauth = callbackVals['userAuth'];
				if(userauth != undefined && userauth === 'false')
					parent.parent.location='<%= ics.GetVar(UIConstants.VAR_URLTIMEOUTERR)%>';
				if (formAction !== '<%= Action.TAIL%>')
					document.getElementById('<%= UIConstants.VAR_LITE%>').value = "true";
			}
		}
	);
}

function createCallBackJSON(responseText,startTag,endTag)
{
	var index1 = responseText.indexOf(startTag);
	var index2 = responseText.indexOf(endTag);
	var callbackVals = responseText.substring(index1+startTag.length,index2).evalJSON();
	return callbackVals;
}
function hasErrors(callbackVals)
{
	var hasErrors = false;
	if (callbackVals.hasOwnProperty('<%= UIConstants.X_ERROR%>'))
	{
		var errorMsg = callbackVals['<%= UIConstants.X_ERROR%>'];
		hasErrors = true;
		document.getElementById('<%= UIConstants.ELEM_ERROR%>').style.display = 'inline';
		document.getElementById('<%= UIConstants.ELEM_ERROR%>').innerHTML = errorMsg;
		hideLoading();
	}
	return hasErrors;
}

function showLoading(){
	$('<%= UIConstants.ELEM_AJAXLOADING%>').style.display='block';
}
function hideLoading(){
	$('<%= UIConstants.ELEM_AJAXLOADING%>').style.display='none';
}

function checkQErrors()
{
	var q = document.getElementById('<%= LogAnalyzer.QUERY%>'); 
	if(q.innerHTML === '' && q.value === '')
	{
		document.getElementById('<%= UIConstants.ELEM_QTEXTERR%>').style.display = 'inline';
		//add onkeyup to hide error message when search textarea receives input
		q.onkeyup = checkQErrors;
		return false;
	}
	document.getElementById('<%= UIConstants.ELEM_QTEXTERR%>').style.display = 'none';
	q.onkeyup = null; //unhook any previous handler on textarea
	return true;
}

</script>
<%}%></cs:ftcs>