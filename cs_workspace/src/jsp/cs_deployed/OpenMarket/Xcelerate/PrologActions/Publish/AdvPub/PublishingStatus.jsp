<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld"%>
<%//
// OpenMarket/Xcelerate/PrologActions/Publish/AdvPub/PublishingStatus
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
<%@ page import="java.util.ArrayList"%>
<cs:ftcs>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment"/>
<%-- Verifies if user has sufficient permission. --%>
<ics:callelement element="OpenMarket/Xcelerate/Actions/Security/PublishAccessCheck">
    <ics:argument name="targetid" value='<%=ics.GetVar("pubtgt:id")%>'/>
</ics:callelement>
<%if(ics.GetVar("doproceed").equals("true")){%>
<html>
<head>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/LoadDojo"/>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/SetStylesheet">
	<ics:argument name="pagename" value="OpenMarket/Xcelerate/PrologActions/Publish/AdvPub/PublishingStatus"/>
</ics:callelement>
<satellite:link pagename="OpenMarket/Xcelerate/PrologActions/Publish/AdvPub/PublishingStatController" assembler="query" outstring="pubStatcontrollerURL">
<satellite:argument name="pubSessionID" value='<%=ics.GetVar("pubsess:id")%>'/>
</satellite:link>
<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/Security/TimeoutError" outstring="urlTimeoutError"/>
<satellite:blob assembler="query" service='<%=ics.GetVar("empty")%>'
	blobtable="PubSession"
	blobkey="id"
	blobwhere='<%=ics.GetVar("pubsess:id")%>'
	blobcol="cs_logfile"
	csblobid='<%=ics.GetSSVar("csblobid")%>'
	outstring="logURL"
	blobnocache="true">
	<satellite:argument name="blobheadername1" value="content-type"/>
	<satellite:argument name="blobheadervalue1" value="application/octet-stream"/>
	<satellite:argument name="blobheadername2" value="Content-Disposition"/>
	<satellite:argument name="blobheadervalue2" value='<%="attachment;filename=" + ics.GetVar("pubsess:id") + ".zip"%>'/>
	<satellite:argument name="blobheadername3" value="MDT-Type"/>
	<satellite:argument name="blobheadervalue3" value="abinary; charset=UTF-8"/>
</satellite:blob>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/prototype.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/URLDecoder.js"></script>
<string:encode variable="_pubLive" varname="_pubLive"/>
<script type="text/javascript">
<!--
var tipRefreshIntervalId = 0;
var invokeIntervalId = 0;
var url;
var _msgs=new Array();
var _freq=true;
var canBeResumed=false;
var canBeRestarted=false;
var canBeCancelled=false;
var initial = -120;
var imageWidth=240;
var eachPercent = (imageWidth/2)/100;

function invoke(url) {
    new Ajax.Request(url+ "&action=getProgressStatus", {
		method: 'get',
		onSuccess: function(transport) {updateProgress(transport);},
		onComplete: function(transport) { 
			var header = transport.getResponseHeader("userAuth");
			if(header == "false"){parent.parent.location='<%=ics.GetVar("urlTimeoutError")%>';};}
		});
}

function updateProgress(req) {
		var sessionDetails = req.responseText.evalJSON();
			if(_freq){
			 drawInitialTable(sessionDetails);
			} else {
				for (var i=0;i < sessionDetails.pubsession.processes.length;i++){
					if(sessionDetails.pubsession.status && sessionDetails.pubsession.status.length > 0 ){
						if($('_status').innerHTML!=getSessionStatus(sessionDetails.pubsession.status)){
						//Clear the message only if status is changed.This is helpful when the restart/cancel request is sent.
							$('alertPubStatus').style.display = 'none';
							$('_status').innerHTML = getSessionStatus(sessionDetails.pubsession.status);
						}
					}
					if($('_bar_' + sessionDetails.pubsession.processes[i].name)){
						setStatus(sessionDetails.pubsession.processes[i].progress,"_bar_" + sessionDetails.pubsession.processes[i].name);
						_statElement = $('_stat_' + sessionDetails.pubsession.processes[i].name);
						removeChildrenFromNode(_statElement);
						_statElement_txt = document.createTextNode(sessionDetails.pubsession.processes[i].status);
						_msgs[i] =decodeURI(sessionDetails.pubsession.processes[i].lastAction);
						var _tbodyRow = $('_statGridRow_' + i);
						_tbodyRow.onmouseover =function(event) {showTooltip(event,this.id);};
						_imgElement = $('_bar_' + sessionDetails.pubsession.processes[i].name);
						if(sessionDetails.pubsession.processes[i].status=="Not Started"){
							_tbodyRow.className="pubTile-row-greyout";
						} else {
							_tbodyRow.className=_tbodyRow.getAttribute("class_o");
						}
						if(sessionDetails.pubsession.processes[i].status === "Failed"){
						    _imgElement.className="percentImage4";
							_errorImg = document.createElement("img");
							_errorImg.src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/alert.gif';
							_statElement.appendChild(_errorImg);
						} else {
							_imgElement.className="percentImage1";
						}
						_statElement.appendChild(_statElement_txt);
					}
				}
			}
			if(sessionDetails.pubsession.resume){canBeResumed=true;$('resumeImg').style.display='inline';$('resumeUnavailImg').style.display='none';} else {
				canBeResumed=false;$('resumeImg').style.display='none';$('resumeUnavailImg').style.display='inline';}
			if(sessionDetails.pubsession.restart){canBeRestarted=true;$('redoImg').style.display='inline';$('redoUnavailImg').style.display='none';} else {
				canBeRestarted=false;$('redoImg').style.display='none';$('redoUnavailImg').style.display='inline';}
			if(sessionDetails.pubsession.cancel){canBeCancelled=true;$('cancelImg').style.display='inline';$('cancelUnavailImg').style.display='none';} else {
				canBeCancelled=false;$('cancelImg').style.display='none';$('cancelUnavailImg').style.display='inline';}
			if(sessionDetails.pubsession.failureMessage){
				if(sessionDetails.pubsession.failureMessage.length > 0){
				//Separate alert for failure messages due to requirements from Rich to show the failure alert left aligned.
					$('alertPubStatus').style.display = 'none';
					$('failureMessage').style.display = '';
					$('failureMessage').update("<img src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/alertlarge.gif'/>&nbsp;<span style='position:relative;bottom:13px'>" + sessionDetails.pubsession.failureMessage + "</span>&nbsp;");
				}
			}
}

function setStatus(percent,id)
{
    var statusPercentage = eachPercent * percent;
	var newStatus = initial + statusPercentage + 'px';
	$(id).style.backgroundPosition=newStatus+' 0';
    setStatusText(percent,id);
}

function setStatusText (percent,id)
{
    $(id+'Text').innerHTML =percent+"%";
    $(id).title=percent + '<xlat:stream key="dvin/UI/Publish/PercentCompleted" encode="false" escape="true"/>';
}

function removeChildrenFromNode(node)
{
   if(!node)
   {
      return;
   }

   var len = node.childNodes.length;

	while (node.hasChildNodes())
	{
	  node.removeChild(node.firstChild);
	}
}

function getData(url){
    invokeIntervalId = setInterval(function() {invoke(url)},5000);
}

function decodeURI(decodedTxt) {
// first replace any + charecters with single space as javascript built in functions do not replace + with space character
var tempTxt = decodedTxt.replace(/\+/g, ' ');
return Url.decode(tempTxt);
}

function showMsg(msg){
	$('failureMessage').style.display = 'none';
	$('alertPubStatus').style.display = '';
	$('alertPubStatus').update(msg).setStyle({ background: '#FFF1A8' });
}

function drawInitialTable(sessionDetails){
			var statGrid = $('_statGrid').tBodies[0];
			if(sessionDetails.pubsession.processes.length > 0){
			$('_stime').innerHTML = sessionDetails.pubsession.startTime;
			if(sessionDetails.pubsession.status && sessionDetails.pubsession.status.length > 0)
			$('_status').innerHTML = getSessionStatus(sessionDetails.pubsession.status);
			var rowStyle = "pubTile-row-normal"
			var separator = false;
			for (var i=0;i < sessionDetails.pubsession.processes.length;i++){
				if(separator){
					lineRow = document.createElement("tr");
					lineRowCell = document.createElement("td");
					lineRowCell.colSpan="9";
					lineRowCellImg = document.createElement("img");
					lineRowCellImg.height="1";
					lineRowCellImg.width="1";
					lineRowCellImg.src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif';
					lineRowCell.appendChild(lineRowCellImg);
					lineRow.appendChild(lineRowCell);
					statGrid.appendChild(lineRow);
				}
			    _tbodyRow=document.createElement("tr");
				_tbodyRow.id = "_statGridRow_" + i;
				if(sessionDetails.pubsession.processes[i].status=="Not Started"){
					_tbodyRow.className="pubTile-row-greyout";
				} else {
					_tbodyRow.className=rowStyle;
				}
				_tbodyRow.setAttribute("class_o",rowStyle);
				_tbodyCell_0 = document.createElement("td");
				_tbodyRow.appendChild(_tbodyCell_0);
				_tbodyCell_0_1 = document.createElement("td");
				_tbodyRow.appendChild(_tbodyCell_0_1);
				_tbodyCell_1 = document.createElement("td");
				_tbodyCell_1_txt = document.createTextNode(sessionDetails.pubsession.processes[i].name);
				_tbodyCell_1.appendChild(_tbodyCell_1_txt);
				_tbodyCell_1.className='nowrap';
				_tbodyRow.appendChild(_tbodyCell_1);
				_tbodyCell_1_1 = document.createElement("td");
				_tbodyRow.appendChild(_tbodyCell_1_1);
				_tbodyCell_2 = document.createElement("td");
				_tbodyCell_2.id="_stat_" + sessionDetails.pubsession.processes[i].name;
				if(sessionDetails.pubsession.processes[i].status === "Failed"){
					_errorImg = document.createElement("img");
					_errorImg.src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/alert.gif';
					_tbodyCell_2.appendChild(_errorImg);
				}
				_tbodyCell_2_txt = document.createTextNode(sessionDetails.pubsession.processes[i].status);
				_tbodyCell_2.appendChild(_tbodyCell_2_txt);
				_tbodyRow.appendChild(_tbodyCell_2);
				_tbodyCell_2_1 = document.createElement("td");
				_tbodyRow.appendChild(_tbodyCell_2_1);
				_tbodyCell_3 = document.createElement("td");
				_tbodyCell_3.valign="bottom";
				var percentageWidth = eachPercent * sessionDetails.pubsession.processes[i].progress;
				var actualWidth = initial + percentageWidth;
				_completed = document.createElement("img");
				_completed.id = "_bar_" + sessionDetails.pubsession.processes[i].name;
				_completed.src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/percentImage_empty.png';
				_completed.alt=sessionDetails.pubsession.processes[i].progress+"%";
				if(sessionDetails.pubsession.processes[i].status === "Failed"){
				  _completed.className="percentImage4";
				} else { 
					_completed.className="percentImage1";
				}
				/*@cc_on
					@if(@_win32)
					_completed.style.cssText = "background-position="+actualWidth+"px 0pt";
					@end
				@*/
				_completed.setAttribute("style", "background-position:"+actualWidth+"px 0pt;");
				_span_space = document.createElement("span");
				_span_space.innerHTML="&nbsp;&nbsp;&nbsp;";
				_span = document.createElement("span");
				_span.id="_bar_" + sessionDetails.pubsession.processes[i].name +"Text";
				_span.className="pubStatusTextSpan";
				_span_Text=document.createTextNode(sessionDetails.pubsession.processes[i].progress + "%");
				_span.appendChild(_span_Text);
				_tbodyCell_3.appendChild(_completed);
				_tbodyCell_3.appendChild(_span_space);
				_tbodyCell_3.appendChild(_span);
				_tbodyCell_3.width='170px';
				_tbodyRow.appendChild(_tbodyCell_3);
				_tbodyCell_3_1 = document.createElement("td");
				_tbodyRow.appendChild(_tbodyCell_3_1);
				_msgs[i] =decodeURI(sessionDetails.pubsession.processes[i].lastAction);
				_tbodyRow.onmouseover =function(event) {showTooltip(event,this.id);}
				_tbodyRow.onmouseout = function(event) {stopAutoRefreshTip();}
				statGrid.appendChild(_tbodyRow);
				if (rowStyle == "pubTile-row-normal"){
				  rowStyle = "pubTile-row-highlight";
				} else {
				  rowStyle = "pubTile-row-normal"
				}
			separator=true;
			}
			} else {
				if(sessionDetails.pubsession.startTime){
					$('_stime').innerHTML = sessionDetails.pubsession.startTime;
				} else {
					$('_stime').innerHTML = '<xlat:stream key="dvin/UI/Common/NotApplicableAbbrev" encode="false" escape="true"/>';
				}
				if(!sessionDetails.pubsession.status){
					$('_status').innerHTML = '<xlat:stream key="dvin/UI/Common/NotApplicableAbbrev" encode="false" escape="true"/>';
				}
				if(<%=ics.GetVar("pubsess:status")!=null%>){
					var status = '<%=ics.GetVar("pubsess:status")%>';
					if(status == 'done'){
						status = '<xlat:stream key="dvin/Common/Success" encode="false" escape="true"/>';
					} else if (status == 'failed'){
						status = '<xlat:stream key="dvin/Common/Failed" encode="false" escape="true"/>';
					}
					showMsg(status);
				}
				_data_UnAble_Row = document.createElement("tr");
				_data_UnAble_Cell = document.createElement("td");
				_data_UnAble_Cell.colSpan="9";
				_data_UnAble_Cell.align="center";
				_data_UnAble_Cell_txt = document.createTextNode('<xlat:stream key="dvin/UI/Publish/DataUnavailable" encode="false" escape="true"/>');
				_data_UnAble_Cell.appendChild(_data_UnAble_Cell_txt);
				_data_UnAble_Row.appendChild(_data_UnAble_Cell);
				statGrid.appendChild(_data_UnAble_Row);
			}
			if(sessionDetails.pubsession.publishOption){
				$('pubOption').style.display='';
				$('pubOption').update('(' + sessionDetails.pubsession.publishOption + ')');
			}
			_freq=false;
}

function executeAction(action,url){
if(action=='cancelSession' || action=='cancelDelayedSession'){
		if(!confirm('<xlat:stream key="dvin/UI/Publish/CancelConfirm" escape="true" encode="false"/>')){
			return false;
		}
	} else if(action=='resumeSession'){
		if(!confirm('<xlat:stream key="dvin/UI/Publish/ResumeConfirm" escape="true" encode="false"/>')){
			return false;
		}
	} else if(action=='restartSession'){
		if(!confirm('<xlat:stream key="dvin/UI/Publish/RestartConfirm" escape="true" encode="false"/>')){
			return false;
		}
	}
	new Ajax.Request(url, {
	method: 'get',
	onCreate: function(transport) {
		if(action=='cancelSession' || action=='cancelDelayedSession'){
				showMsg('<xlat:stream key="dvin/UI/Publish/CancellationRequestSent" escape="true" encode="false"/>');
			} else {
				if(action=='resumeSession' || action=='restartSession'){
					if(action=='resumeSession'){
						showMsg('<xlat:stream key="dvin/UI/Publish/SessionResumeRequestSent" escape="true" encode="false"/>');
					} else if(action=='restartSession'){
						showMsg('<xlat:stream key="dvin/UI/Publish/SessionRestartRequestSent" escape="true" encode="false"/>');
					}
				}
			}
	},onSuccess: function(transport) {
		if(action=='resumeSession' || action=='restartSession'){
			var status = transport.responseText.evalJSON();
			if(action=='resumeSession'){
				if(!status.resumeStatus){
					showMsg('<xlat:stream key="dvin/UI/Publish/SessionResumeFailed" escape="true" encode="false"/>');
				}
			} else if(action=='restartSession'){
				if(!status.restartStatus){
					showMsg('<xlat:stream key="dvin/UI/Publish/SessionRestartFailed" escape="true" encode="false"/>');
				}
			}
		} else if(action=='downloadLog'){
		    location.href='<%=ics.GetVar("logURL")%>';
			$('alertPubStatus').style.display = 'none';
		}
	},onLoading:function(){
		if(action=='downloadLog'){
			showMsg('<xlat:stream key="dvin/UI/PublishingStatus/PleaseWaitLogRetrieved" escape="true" encode="false"/>');
		}
	},onComplete: function(transport) { 
		var header = transport.getResponseHeader("userAuth");
		if(header == "false")parent.parent.location='<%=ics.GetVar("urlTimeoutError")%>';
		if (invokeIntervalId != 0)clearInterval(invokeIntervalId);
		getData('<%=ics.GetVar("pubStatcontrollerURL")%>');
	}
});
}

function getSessionStatus(status){
	if(status == "running"){
		return '<xlat:stream key="dvin/Common/Running" escape="true" encode="false"/>';
	} else if(status == "done"){
		return '<xlat:stream key="dvin/Common/Success" escape="true" encode="false"/>';
	} else if(status == "failed"){
		return '<xlat:stream key="dvin/Common/Failed" encode="false" escape="true"/>';
	} else if(status == "cancelled"){
		return '<xlat:stream key="dvin/Common/Cancelled" encode="false" escape="true"/>';
	} else if(status == "waiting"){
		return '<xlat:stream key="dvin/Common/Paused" encode="false" escape="true"/>';
	} else {
		return '<xlat:stream key="dvin/UI/Common/NotApplicableAbbrev" encode="false" escape="true"/>';
	}
}
dojo.require("dijit.Tooltip");
dojo.addOnLoad(function() {
	dojo.addClass(dojo.body(), 'ttip');
});
var tooltips = {};
function showTooltip(evt,id){
	evt = evt || window.event;
	var target = evt.target || evt.srcElement;
	if(!tooltips[id] && _msgs[id.substring(13,id.length)]){
		var ttip = new dijit.Tooltip({
			connectId: dojo.query('td', dojo.byId(id)),
			label: _msgs[id.substring(13,id.length)],
			showDelay : 250
		});
		ttip.open(target);
		tooltips[id] = ttip;
	}
	if("<%=ics.GetVar("_pubLive")%>" == "true" && tipRefreshIntervalId == 0){
		tipRefreshIntervalId = setInterval(function() {
			if(typeof(tooltips[id]) != 'undefined') {
				tooltips[id].label = _msgs[id.substring(13,id.length)];
				tooltips[id].open(target);
			}
		},5000);
	}
	
}

function stopAutoRefreshTip(){
	if("<%=ics.GetVar("_pubLive")%>" == "true"){
		clearInterval(tipRefreshIntervalId);
		tipRefreshIntervalId = 0;
	}
}
//-->
</script>
</head>
<body onload="invoke('<%=ics.GetVar("pubStatcontrollerURL")%>');<%if(ics.GetVar("_pubLive") !=null && ics.GetVar("_pubLive").equals("true")){%>getData('<%=ics.GetVar("pubStatcontrollerURL")%>')<%}%>">
<table border="0" cellpadding="0" cellspacing="0" class="width-outer-70">
	<tr>
		<td><span class="title-text"><xlat:stream key="dvin/UI/PublishingStatus"/></span></td>
	</tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar">
		<ics:argument name="SpaceBelow" value="No"/>
	</ics:callelement>
	<tr>
	<td>
		<table border="0" cellpadding="0" cellspacing="0">
		<tr>
		<td class="form-label-text"><xlat:stream key="dvin/UI/Publish/SessionID"/>:</td>
		<td><img height="1" width="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
		<td class="form-inset" align="left"><string:stream variable="pubsess:id"/></td>
		</tr>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
		<tr>
		<td class="form-label-text"><xlat:stream key="dvin/UI/Publish/Status"/>:</td>
		<td><img height="1" width="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
		<td class="form-inset" align="left"><span id="_status">
		<%
		if(ics.GetVar("pubsess:status") != null ){
			if (ics.GetVar("pubsess:status").equals("done")){
				%><xlat:stream key="dvin/Common/Success" encode="false" escape="true"/><%
			}
			else if (ics.GetVar("pubsess:status").equals("cancelled"))
			{
				%><xlat:stream key="dvin/Common/Cancelled" encode="false" escape="true"/><%
			}
			else{
				%><xlat:stream key="dvin/Common/Failed" encode="false" escape="true"/><%
			}
		}
		else{%>...<%}%></span></td>
		</tr>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
		<tr>
		<td class="form-label-text"><xlat:stream key="dvin/Common/Destination"/>:</td>
		<td><img height="1" width="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
		<td class="form-inset" align="left"><xlat:stream key="dvin/UI/Publish/pubtgtnameusingpubdtname"/>&nbsp;<span style="display:none" id="pubOption"/></td>
		</tr>

		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
		<tr>
		<td class="form-label-text"><xlat:stream key="dvin/PublishEmail/StartTime"/></td>
		<td><img height="1" width="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
		<td class="form-inset" align="left"><span id="_stime">...</span></td>
		</tr>
		</table>
	</td>
	</tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" class="width-outer-50" style="margin-top:0;">
<tr><td><table width="100%"><tr><td width="25%" align="left"><span class="alertMsg" id="failureMessage"/></td><td align="center"><span class="alertMsg" id="alertPubStatus"/></td><td align="right" width="25%"><A href="#" onClick="if(canBeResumed){executeAction('resumeSession','<%=ics.GetVar("pubStatcontrollerURL")%>&action=resumeSession')};return false;" onmouseover="$('resumeImg').src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/resumeHover.gif'" onmouseout="$('resumeImg').src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/resume.gif'" onmouseup="$('resumeImg').src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/resumeHover.gif'" onmousedown="$('resumeImg').src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/resumePressed.gif'"><xlat:lookup key="dvin/UI/Resume" varname="_XLAT_"/><img id="resumeImg" style="display:none;" class="actionAvail" title="<%=ics.GetVar("_XLAT_")%>" border="0" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/resume.gif'/>
</A><xlat:lookup key="dvin/UI/ResumeUnAvailable" varname="_XLAT_"/><img id="resumeUnavailImg" style="display:none;" class="actionUnavail" title="<%=ics.GetVar("_XLAT_")%>" border="0" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/ResumeUnavail.gif'/>&nbsp;&nbsp;<A href="#" onClick="if(canBeRestarted){executeAction('restartSession','<%=ics.GetVar("pubStatcontrollerURL")%>&action=restartSession')};return false;"  onmouseover="$('redoImg').src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/redoHover.gif'" onmouseout="$('redoImg').src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/redo.gif'" onmouseup="$('redoImg').src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/redoHover.gif'" onmousedown="$('redoImg').src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/redoPressed.gif'"><xlat:lookup key="dvin/UI/Redo" varname="_XLAT_"/><img id="redoImg" style="display:none;" class="actionAvail" title="<%=ics.GetVar("_XLAT_")%>" border="0" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/redo.gif'/></A><xlat:lookup key="dvin/UI/RedoUnAvailable" varname="_XLAT_"/><img id="redoUnavailImg" style="display:none;" class="actionUnavail" title="<%=ics.GetVar("_XLAT_")%>" border="0" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/RedoUnavail.gif'/>&nbsp;&nbsp;<A href="#" onClick="if(canBeCancelled){if(canBeResumed){executeAction('cancelDelayedSession','<%=ics.GetVar("pubStatcontrollerURL")%>&action=cancelDelayedSession');}else{executeAction('cancelSession','<%=ics.GetVar("pubStatcontrollerURL")%>&action=cancelSession');}};return false;" onmouseover="$('cancelImg').src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/stopHover.gif'" onmouseout="$('cancelImg').src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/stop.gif'" onmouseup="$('cancelImg').src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/stopHover.gif'" onmousedown="$('cancelImg').src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/stopPressed.gif'"><xlat:lookup key="dvin/UI/Cancel" varname="_XLAT_"/><img id="cancelImg" style="display:none;" class="actionAvail" title="<%=ics.GetVar("_XLAT_")%>" border="0" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/stop.gif'/></A><xlat:lookup key="dvin/UI/CancelUnAvailable" varname="_XLAT_"/><img id="cancelUnavailImg" style="display:none;" class="actionUnavail" title="<%=ics.GetVar("_XLAT_")%>" border="0" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/StopUnavail.gif'/>
</td></tr></table></td></tr>
<tr><td>
<table WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
		<tr>
		<td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
		</tr>
		<tr>
			<td class="tile-dark" VALIGN="top" WIDTH="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
			<td>
	<table id="_statGrid" border="0" width="100%" cellpadding="0" cellspacing="0" bgcolor="#ffffff">
	<tr><td colspan="9" class="tile-highlight"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td></tr>
	<tr><td class="tile-a" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;</td>
        <td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><BR/></DIV></td>
        <td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="dvin/UI/Publish/Stage"/></DIV></td>
		<td class="tile-b" width="100px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><BR/></td>
		<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="dvin/UI/Publish/Status"/></DIV></td>
        <td class="tile-b" width="100px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><BR/></td>
		<td class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="dvin/UI/Publish/PercentCompleted" evalall="false"><xlat:argument name="percent" value=""/></xlat:stream></DIV></td>
        <td class="tile-c" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;</td>
	</tr>
	<tr><td colspan="9" class="tile-dark"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td></tr>
	</table>
	</td>
<td class="tile-dark" VALIGN="top" WIDTH="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
	</tr>
	<tr>
		<td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
	</tr>
	<tr>
		<td></td><td background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif'><IMG WIDTH="1" HEIGHT="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td><td></td>
	</tr>
				</table>
</td></tr>
<tr><td>

<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Admin/Publish/DestEdit" outstring="urlConfdest">
			<satellite:argument name="action" value="details"/>
			<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
            <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
            <satellite:argument name="id" value='<%=ics.GetVar("pubtgt:id")%>'/>
</satellite:link>
<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/PublishConsoleFront" outstring="urlpubconsfront">
        <satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
        <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
		<satellite:argument name="rows" value='<%=ics.GetVar("rows")%>'/>
		<satellite:argument name="defaultTab" value='_t3'/>
</satellite:link>
<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/PrologActions/Publish/AdvPub/ShowPubSessionLog" outstring="pubSessionLogURL">
    <satellite:argument name="cs_imagedir" value='<%=ics.GetVar("cs_imagedir")%>'/>
	<satellite:argument name="pubsess:id" value='<%=ics.GetVar("pubsess:id")%>'/>
	<%if(ics.GetVar("pubsess:status") != null ){%>
		<satellite:argument name="pubsess:status" value='<%=ics.GetVar("pubsess:status")%>'/>
	<%}%>
	<satellite:argument name="pubtgt:name" value='<%=ics.GetVar("pubtgt:name")%>'/>
	<satellite:argument name="pubtgt:id" value='<%=ics.GetVar("pubtgt:id")%>'/>
	<satellite:argument name="pubdt:name" value='<%=ics.GetVar("pubdt:name")%>'/>
	<satellite:argument name="action" value="getLogData"/>
	<satellite:argument name="pubConsole:rows" value='<%=ics.GetVar("rows")%>'/>
</satellite:link>
<satellite:link pagename="OpenMarket/Xcelerate/PrologActions/Publish/AdvPub/PublishingStatController" assembler="query" outstring="pubStatcontrollerURL">
	<satellite:argument name="pubSessionID" value='<%=ics.GetVar("pubsess:id")%>'/>
	<satellite:argument name="pubtgt:name" value='<%=ics.GetVar("pubtgt:name")%>'/>
	<satellite:argument name="pubtgt:id" value='<%=ics.GetVar("pubtgt:id")%>'/>
	<satellite:argument name="pubdt:name" value='<%=ics.GetVar("pubdt:name")%>'/>
	<satellite:argument name="action" value="downloadLog"/>
</satellite:link>
<%
	boolean userIsMember = ics.UserIsMember( "xceladmin" );
%>

<table width="100%" border="0">
<tr>
	<td><IMG src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/doubleArrow.gif'/>&nbsp;<a href='<%=ics.GetVar("pubSessionLogURL")%>'><b><xlat:stream key="dvin/UI/ViewLog"/></b></a></td>
	<td align="right"><span style="position:relative;right:50px;"><IMG src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/doubleArrow.gif'/>&nbsp;<A HREF="#" onclick="executeAction('downloadLog','<%=ics.GetVar("pubStatcontrollerURL")%>');"><b><xlat:stream key="dvin/UI/PublishingStatus/DownloadLog"/></b></A></span></td>
</tr>
<tr>
	<td><IMG src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/doubleArrow.gif'/>&nbsp;<A HREF='<%=ics.GetVar("urlpubconsfront")%>'><b><xlat:stream key="dvin/UI/PublishHistory"/></b></A></td>
	<% if (userIsMember){ %><td align="right"><IMG src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/doubleArrow.gif'/>&nbsp;<A HREF='<%=ics.GetVar("urlConfdest")%>'><b><xlat:stream key="dvin/UI/ConfigurePublishingDestination"/></b></A></td><%}%>
</tr>
</table>
</td></tr>
</table>
</body>
</html>
<%}%>
</cs:ftcs>
