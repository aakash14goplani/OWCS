<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld"%>
<%//
// OpenMarket/Xcelerate/PrologActions/Publish/AdvPub/ShowPubSessionLog
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
<string:encode variable="cs_imagedir" varname="cs_imagedir"/>
<string:encode variable="cs_environment" varname="cs_environment"/>
<string:encode variable="cs_formmode" varname="cs_formmode"/>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment"/>
<%-- Verfies if user has publishing permission to target--%>
<ics:callelement element="OpenMarket/Xcelerate/Actions/Security/PublishAccessCheck">
    <ics:argument name="targetid" value='<%=ics.GetVar("pubtgt:id")%>'/>
</ics:callelement>
<%if(ics.GetVar("doproceed").equals("true")){%>
<html>
<head>
<%
if(ics.GetVar("showPubSessionLog:rowsPerPage") == null){
ics.SetVar("showPubSessionLog:rowsPerPage","50");
}
if(ics.GetVar("showPubSessionLog:_logDisplayPage") == null){
ics.SetVar("showPubSessionLog:_logDisplayPage","1");
}
if(ics.GetVar("status") == null){
ics.SetVar("status","");
}
%>
<satellite:link pagename="OpenMarket/Xcelerate/PrologActions/Publish/AdvPub/PublishingStatController" assembler="query" outstring="pubStatcontrollerURL">
	<satellite:argument name="pubSessionID" value='<%=ics.GetVar("pubsess:id")%>'/>
	<satellite:argument name="pubtgt:name" value='<%=ics.GetVar("pubtgt:name")%>'/>
	<satellite:argument name="pubtgt:id" value='<%=ics.GetVar("pubtgt:id")%>'/>
	<satellite:argument name="pubdt:name" value='<%=ics.GetVar("pubdt:name")%>'/>
	<satellite:argument name="action" value='getLogData'/>
</satellite:link>
<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/PrologActions/Publish/AdvPub/ShowPubSessionLog" outstring="pubSessionLogURL">
	<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
	<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
	<satellite:argument name="cs_imagedir" value='<%=ics.GetVar("cs_imagedir")%>'/>
	<satellite:argument name="pubsess:id" value='<%=ics.GetVar("pubsess:id")%>'/>
	<satellite:argument name="pubtgt:name" value='<%=ics.GetVar("pubtgt:name")%>'/>
	<satellite:argument name="pubtgt:id" value='<%=ics.GetVar("pubtgt:id")%>'/>
	<satellite:argument name="pubdt:name" value='<%=ics.GetVar("pubdt:name")%>'/>
	<satellite:argument name="action" value="getLogData"/>
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
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/LoadDojo"/>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/SetStylesheet">
		<ics:argument name="pagename" value="OpenMarket/Xcelerate/PrologActions/Publish/AdvPub/ShowPubSessionLog"/>
</ics:callelement>
<script language="JavaScript" src="<%=request.getContextPath()%>/js/prototype.js"></script>
<script language="JavaScript" src="<%=request.getContextPath()%>/js/URLDecoder.js"></script>
<script language="JavaScript" src="<%=request.getContextPath()%>/js/prototabs.js"></script>
<script type="text/javascript">
<!--
var searchBxFlag = true;
var url='<%=ics.GetVar("pubStatcontrollerURL")%>';
var _logDisplayPage='<%=ics.GetVar("showPubSessionLog:_logDisplayPage")%>';
var rowsPerPage='<%=ics.GetVar("showPubSessionLog:rowsPerPage")%>';
var _logSearchDisplayPage='0';
var _searchStr="";
var status = "";
var _extmsgs=new Array();
var _rescIds = new Array();

function init(){
    retrieveData(rowsPerPage,_logDisplayPage,'_logTabBody');
}

function decodeURI(decodedTxt) {
// first replace any + charecters with single space as javascript built in functions do not replace + with space character
	var tempTxt = decodedTxt.replace(/\+/g, ' ');
	return Url.decode(tempTxt);
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

function showMsg(msg){
$(alertPubSessionLog).style.display="";
$(alertPubSessionLog).update(msg).setStyle({ background: '#FFF1A8' });
}

function retrieveData(numberOfRows,pageNo,tabBodyId) {
  var addParam = '&displayPage=' + pageNo + '&rowsPerPage=' + numberOfRows;
  var effUrl=(tabBodyId=="_logTabBody")?(url + addParam):(url + addParam + '&search=' + _searchStr + '&status=' + status);
  new Ajax.Request(effUrl, {
  	method: 'get',onSuccess: function(transport) {
	removeChildrenFromNode($(tabBodyId));
	updateLogs(transport,tabBodyId);}});
  }

function updateLogs(req,tabBodyId) {
			var _logData = req.responseText.evalJSON();
			var _dataTableBody = $(tabBodyId);
			var rowStyle = "pubTile-row-normal";
			for (var i=0;i < _logData.log.list.length;i++){
			    _tbodyRow=document.createElement("tr");
				_tbodyRow.height="50px";
				_tbodyRow.className=rowStyle;
				_tbodyRow.id = i;
				_tbodyCell_0 = document.createElement("td");
				_tbodyCell_0.innerHTML="&nbsp;";
				_tbodyRow.appendChild(_tbodyCell_0);
				_tbodyCell_0_1 = document.createElement("td");
				_tbodyCell_0_1.innerHTML="&nbsp;";
				_tbodyRow.appendChild(_tbodyCell_0_1);
				_tbodyCell_0_2 = document.createElement("td");
				_tbodyCell_0_2.innerHTML="&nbsp;";
				_tbodyRow.appendChild(_tbodyCell_0_2);
				_tbodyCell_1 = document.createElement("td");
				_tbodyCell_1.style.whiteSpace="nowrap";
				_tbodyCell_1_txt = document.createTextNode(_logData.log.list[i].logDate);
				_tbodyCell_1.appendChild(_tbodyCell_1_txt);
				_tbodyRow.appendChild(_tbodyCell_1);
				_tbodyCell_1_1 = document.createElement("td");
				_tbodyCell_1_1.innerHTML="&nbsp;";
				_tbodyRow.appendChild(_tbodyCell_1_1);
				_tbodyCell_4 = document.createElement("td");
				if(_logData.log.list[i].type && trim(_logData.log.list[i].type).length == 0){
				_tbodyCell_4.innerHTML="&nbsp;";
				} else {
				_tbodyCell_4_txt = document.createTextNode(_logData.log.list[i].type);
				_tbodyCell_4.appendChild(_tbodyCell_4_txt);
				}
				_tbodyRow.appendChild(_tbodyCell_4);
				_tbodyCell_4_1 = document.createElement("td");
				_tbodyCell_4_1.innerHTML="&nbsp;";
				_tbodyRow.appendChild(_tbodyCell_4_1);
				_tbodyCell_2 = document.createElement("td");
				_tbodyCell_2.className="sized6";
				if(_logData.log.list[i].status && trim(_logData.log.list[i].status).length == 0){
				_tbodyCell_2.innerHTML="&nbsp;";
				} else {
				_tbodyCell_2_txt = document.createTextNode(_logData.log.list[i].status);
				_tbodyCell_2.appendChild(_tbodyCell_2_txt);
				}
				_tbodyRow.appendChild(_tbodyCell_2);
				_tbodyCell_2_1 = document.createElement("td");
				_tbodyCell_2_1.innerHTML="&nbsp;";
				_tbodyRow.appendChild(_tbodyCell_2_1);
				var extStatusStr = "";
				var displayInfoWindow = false;
				textStr = decodeURI(_logData.log.list[i].text);
				var extStatusStrDis = "";
				if(_logData.log.list[i].text.length > 200){
				 displayInfoWindow = true;
				 textStrDis = textStr.substring(0,200) + " ....";
				} else {
					textStrDis = textStr;
				}
				_tbodyCell_3 = document.createElement("td");
				_tbodyCell_3.id='txt_' + i;
				_tbodyCell_3_txt = document.createTextNode(textStrDis);
				_tbodyCell_3.appendChild(_tbodyCell_3_txt);
				_extmsgs[i] =textStr;
				_tbodyRow.appendChild(_tbodyCell_3);
				_tbodyCell_3_1 = document.createElement("td");
				_tbodyCell_3_1.innerHTML="&nbsp;";
				_tbodyRow.appendChild(_tbodyCell_3_1);
				if(displayInfoWindow)
					_tbodyRow.onmouseover = function(evt){evt=evt || window.event; javascript:showTooltip(evt,_extmsgs[this.id],this.id);}
				_dataTableBody.appendChild(_tbodyRow);
				if (rowStyle == "pubTile-row-normal"){
				  rowStyle = "pubTile-row-highlight";
				} else {
				  rowStyle = "pubTile-row-normal"
				}
			}
			if(_logData.log.list.length !=0){
				if(tabBodyId == '_logTabBody'){
				    _logDisplayPage=_logData.log.currentPage;
					_logPageCount=_logData.log.pageCount;
					var paginationLink = getPaginationLink(rowsPerPage,_logDisplayPage,_logPageCount,tabBodyId);
					$('_logPaginationT').innerHTML=paginationLink;
					$('_logPaginationB').innerHTML=paginationLink;
				} else if(tabBodyId == '_logSearchTabBody') {
					_logSearchDisplayPage=_logData.log.currentPage;
					_logSearchPageCount=_logData.log.pageCount;
					var paginationLink = getPaginationLink(rowsPerPage,_logSearchDisplayPage,_logSearchPageCount,tabBodyId);
					$('_searchLogPaginationT').innerHTML=paginationLink;
					$('_searchLogPaginationB').innerHTML=paginationLink;
				}
			}
			var tabInfoElement =(tabBodyId == '_logSearchTabBody')?$('_logSearchTabInfo'):$('_logTabInfo');
			if(_logData.log.list.length == 0){
				tabInfoElement.innerHTML='<xlat:stream key="dvin/UI/NoSearchResults" encode="false" escape="true"/>';
				tabInfoElement.style.display='';
			} else {
			   tabInfoElement.style.display='none';
			}
}

function getPaginationLink(rows,displayPage,pageCount,tabBodyId){
	var paginationLink = '';
	if(displayPage > 2 ){
		paginationLink +="<IMG BORDER='0' HEIGHT='12' WIDTH='15' src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/doubleArrowLeft.gif'/><a href='#' onClick='retrieveData(" + rows + ",1,&#39;" + tabBodyId + "&#39;);return false;'><xlat:stream key='dvin/UI/First' encode='false' escape='true'/></a><IMG BORDER='0' HEIGHT='12' WIDTH='15' src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/leftArrow.gif'/><a href='#' onClick='retrieveData(" + rows + "," + (displayPage - 1) + ",&#39;" + tabBodyId + "&#39;);return false;'><xlat:stream key='dvin/UI/Previous' encode='false' escape='true'/></a>&nbsp;" 
	} else if (displayPage == 2 ){
		paginationLink +="<IMG BORDER='0' HEIGHT='12' WIDTH='15' src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/doubleArrowLeft.gif'/><a href='#' onClick='retrieveData(" + rows + ",1,&#39;" + tabBodyId + "&#39;);return false;'><xlat:stream key='dvin/UI/First' encode='false' escape='true'/></a>&nbsp;"
	}
	<xlat:lookup key="dvin/UI/PageOf" varname="PageOf" escape="true"/>
	var PageOf = '<%=ics.GetVar("PageOf")%>';
	PageOf = PageOf.replace("Variables.displayPage",displayPage);
	PageOf = PageOf.replace("Variables.totalPages",pageCount);
	
	paginationLink += PageOf;
	
	if(displayPage < pageCount-1){
	//Use the pageNo as -1 for the last page so that we dont send any hardcoded value to the server.
	paginationLink +="&nbsp;<a href='#' onClick='retrieveData(" + rows + "," + (displayPage + 1)+ ",&#39;" + tabBodyId + "&#39;);return false;'><xlat:stream key='dvin/UI/Next' encode='false' escape='true'/></a><IMG BORDER='0' HEIGHT='12' WIDTH='15' src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/rightArrow.gif'/><a href='#' onClick='retrieveData(" + rows + ",-1,&#39;" + tabBodyId + "&#39;);return false;'><xlat:stream key='dvin/UI/Last' encode='false' escape='true'/></a><IMG BORDER='0' HEIGHT='12' WIDTH='15' src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/doubleArrow.gif'/>" 
	} else if (displayPage == pageCount-1){
		paginationLink +="&nbsp;<a href='#' onClick='retrieveData(" + rows + ",-1,&#39;" + tabBodyId + "&#39;);return false;'><xlat:stream key='dvin/UI/Last' encode='false' escape='true'/></a><IMG BORDER='0' HEIGHT='12' WIDTH='15' src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/doubleArrow.gif'/>" 
	} else if (displayPage == pageCount){
		paginationLink +="&nbsp;[<a href='#' onClick='retrieveData(" + rows + "," + displayPage + ",&#39;" + tabBodyId + "&#39;);return false;'><xlat:stream key='dvin/UI/Update' encode='false' escape='true'/></a>]" 
	}
	return paginationLink;
}
function executeSearch(){
    status=($('_errorsOnlyChBx').checked)? "ERROR":"";
    if((dijit.byId('_searchBx').getValue() && trim(dijit.byId('_searchBx').getValue()).length == 0  && !$('_errorsOnlyChBx').checked) || (!dijit.byId('_searchBx').getValue() && !$('_errorsOnlyChBx').checked)){
			alert('<xlat:stream key="dvin/UI/NoTextToSearch" encode="false" escape="true"/>');
			searchBxFlag = false;
	} else {
			searchBxFlag = true;
			_searchStr = dijit.byId('_searchBx').getValue();
			retrieveData(rowsPerPage,1,'_logSearchTabBody');
			$('_searchTab').style.display='inline';
			tabSet1.openPanel($('_searchTab'));
	}
}

function trim(str){
	return str.replace(/^\s+|\s+$/g, '') ;
}

function switchTab(elm){
	$('_searchTab').style.display='none';
	dijit.byId('_searchBx').setValue('');
	tabSet1.openPanel(elm);
}
function showLoading(){
	$('ajaxLoading').style.display='block';
}
function hideLoading(){
	$('ajaxLoading').style.display='none';
}
function executeAction(action,url){
	new Ajax.Request(url, {
	method: 'get',
	onSuccess: function(transport) {
		if(action=='downloadLog'){
		    location.href='<%=ics.GetVar("logURL")%>';
			$(alertPubStatus).style.display = 'none';
		}
	},onComplete: function(transport) { 
		var header = transport.getResponseHeader("userAuth");
		if(header == "false")parent.parent.location='<%=ics.GetVar("urlTimeoutError")%>';
	}
});
}
//-->
</script>
</head>
<body onload="init();">
<ics:setvar name="serverTimeZone" value='<%=java.util.TimeZone.getDefault().getID()%>' />
<xlat:lookup key='UI/Forms/datesInServerTime' varname="datesInServerTime"/>
<div class="width-outer-70">
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
				<ics:argument name="msgtext" value='<%=ics.GetVar("datesInServerTime")%>'/>
				<ics:argument name="severity" value="info" />
			</ics:callelement>
</div>
<table border="0" cellpadding="0" cellspacing="0" class="width-outer-70">
	<tr>
		<td><span class="title-text"><xlat:stream key="dvin/UI/SessionLog"/></span></td>
	</tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar">
		<ics:argument name="SpaceBelow" value="No"/>
	</ics:callelement>
	<tr>
	<td>
		<table border="0" cellpadding="0" cellspacing="0">
		<tr>
		<td class="form-label-text"><xlat:stream key="dvin/UI/Publish/SessionID"></xlat:stream>:</td>
		<td><img height="1" width="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
		<td class="form-inset"><string:stream variable="pubsess:id"/></td>
		</tr>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
		<tr>
		<td class="form-label-text"><xlat:stream key="dvin/Common/Destination"/>:</td>
		<td><img height="1" width="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
		<td class="form-inset"><xlat:stream key="dvin/UI/Publish/pubtgtnameusingpubdtname"/></td>
		</tr>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
		</table>
	</td>
	</tr>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar"/>
</table>
<satellite:form  name="procfrm" id="procfrm" onsubmit="return false;">
<satellite:link pagename="OpenMarket/Xcelerate/PrologActions/Publish/AdvPub/PublishingStatController" assembler="query" outstring="pubStatcontrollerURL">
	<satellite:argument name="pubSessionID" value='<%=ics.GetVar("pubsess:id")%>'/>
	<satellite:argument name="pubtgt:name" value='<%=ics.GetVar("pubtgt:name")%>'/>
	<satellite:argument name="pubtgt:id" value='<%=ics.GetVar("pubtgt:id")%>'/>
	<satellite:argument name="pubdt:name" value='<%=ics.GetVar("pubdt:name")%>'/>
	<satellite:argument name="action" value="downloadLog"/>
</satellite:link>
<table class="width-outer-90"><tr><td width="40%"><IMG src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/doubleArrow.gif'/>&nbsp;<A HREF="#" onclick="executeAction('downloadLog','<%=ics.GetVar("pubStatcontrollerURL")%>');"><b><xlat:stream key="dvin/UI/PublishingStatus/DownloadLog"/></b></A></td><td align="right"><table><tr><td><div id="_searchBx" dojoType="fw.dijit.UIInput"  clearButton="true"></div></td><td><BR/></td><td><span><a href='#' onclick="executeSearch();return searchBxFlag;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/SearchLogs"/></ics:callelement></a></span></td></tr><tr><td colspan="3" align="left"><input type="checkbox" id="_errorsOnlyChBx"/>&nbsp;<xlat:stream key="dvin/UI/Publish/ShowOnly"/></td></tr></table></td></tr></table>
<div class="tabs6 width width-outer-70">
	<div class="minwidth">
		<div class="container">
			<ul id="pubLogtabs">
				<li id="_logsTab"><a style="text-decoration:none;width:auto;" href="#_t1"><span>&nbsp;&nbsp;&nbsp;<xlat:stream key="dvin/UI/Publish/Log/SessionLogs"/>&nbsp;&nbsp;&nbsp;</span></a></li>
				<li id="_searchTab" style="display:none"><xlat:lookup key="dvin/UI/CloseSearchResults" varname="_XLAT_" escape="true"/><a class="logtabs" style="text-decoration:none;width:auto;" href="#_t2"><span>&nbsp;&nbsp;&nbsp;<xlat:stream key="dvin/UI/SearchResults"/>&nbsp;&nbsp;<img id="_X" title="<%=ics.GetVar("_XLAT_")%>" style="vertical-align:middle;border:none;" onClick="switchTab($('_logsTab'));" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/x_close.gif' onmouseover="this.src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/x_close_hover.gif'" onmouseout="this.src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/x_close.gif'"/>&nbsp;&nbsp;&nbsp;</span></a></li>
			</ul>
		</div>
	</div>
</div>
<div id ="_main" style="display:none;" class="width-outer-90">
	<div id="_t1" class="panel width-inner-100" style="min-width:700px;">
	<table style="width:100%;" border="0"><tr><td align="right"><span id="_logPaginationT"></span></td></tr></table>
	<table BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%" >
		<tr>
		<td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
		</tr>
		<tr>
			<td class="tile-dark" VALIGN="top" WIDTH="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
			<td>
	<table id="_logTab" width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
	<thead>
	    <tr>
		<td class="tile-a" width="5px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;</td>
        <td class="tile-b" width="5px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><BR /></DIV></td>
        <td class="tile-b" width="5px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td align="left" nowrap="nowrap" class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="dvin/UI/Publish/Log/Date"/></DIV></td>
        <td class="tile-b" width="5px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td align="left" nowrap="nowrap" class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="dvin/UI/Publish/Stage"/></DIV></td>
        <td class="tile-b" width="5px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td align="left" nowrap="nowrap" class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="dvin/UI/Publish/Log/Status"/></DIV></td>
        <td class="tile-b" width="5px"  background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td align="left" nowrap="nowrap" class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="dvin/UI/Publish/Log/Details"/></DIV></td>
        <td class="tile-c" width="5px"  background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;</td>
	</tr>
	<tr><td colspan="11" id="_logTabInfo" style="background-color:#F7F8FA;height:40px;text-align:center;display:none"></td></tr>
	</thead>
	<tbody id="_logTabBody">
	</tbody>
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
	<table style="width:100%;"><tr><td align="left"><xlat:stream key="dvin/UI/Show"/> 
	<% if(ics.GetVar("showPubSessionLog:rowsPerPage").equals("50")){
	%>50 <%
	} else{%><a href='<%=ics.GetVar("pubSessionLogURL")%>&#38;showPubSessionLog:rowsPerPage=50<%if(ics.GetVar("search") !=null){%>&#38;search=<%=ics.GetVar("search")%><%} if(ics.GetVar("status") !=null){%>&#38;status=<%=ics.GetVar("status")%><%}%>'>50</a><%}%>
	<% if(ics.GetVar("showPubSessionLog:rowsPerPage").equals("100")){
	%>100 <%
	} else{%><a href='<%=ics.GetVar("pubSessionLogURL")%>&#38;showPubSessionLog:rowsPerPage=100<%if(ics.GetVar("search") !=null){%>&#38;search=<%=ics.GetVar("search")%><%} if(ics.GetVar("status") !=null){%>&#38;status=<%=ics.GetVar("status")%><%}%>'>100</a><%}%>
	<% if(ics.GetVar("showPubSessionLog:rowsPerPage").equals("150")){
	%>150 <%
	} else{%><a href='<%=ics.GetVar("pubSessionLogURL")%>&#38;showPubSessionLog:rowsPerPage=150<%if(ics.GetVar("search") !=null){%>&#38;search=<%=ics.GetVar("search")%><%} if(ics.GetVar("status") !=null){%>&#38;status=<%=ics.GetVar("status")%><%}%>'>150</a><%}%>&nbsp;<xlat:stream key="dvin/UI/itemsperpage"/></td><td align="right"><span id="_logPaginationB"></span></td></tr></table>
	</div>
	<div id="_t2" class="panel width-inner-100" style="min-width:700px;">
	<table style="width:100%;"><tr><td align="right"><span id="_searchLogPaginationT"></span></td></tr></table>
	<table BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
		<tr>
		<td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
		</tr>
		<tr>
			<td class="tile-dark" VALIGN="top" WIDTH="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
			<td>
	<table id="_logSearchTab" width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
	<thead>
	    <tr>
		<td class="tile-a" width="5px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;</td>
        <td class="tile-b" width="5px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><BR /></DIV></td>
        <td class="tile-b" width="5px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td align="left" nowrap="nowrap" class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="dvin/UI/Publish/Log/Date"/></DIV></td>
        <td class="tile-b" width="5px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td align="left" nowrap="nowrap" class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="dvin/UI/Publish/Stage"/></DIV></td>
        <td class="tile-b" width="5px" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td align="left" nowrap="nowrap" class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="dvin/UI/Publish/Log/Status"/></DIV></td>
        <td class="tile-b" width="5px"  background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td align="left" nowrap="nowrap" class="tile-b" background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'><DIV class="new-table-title"><xlat:stream key="dvin/UI/Publish/Log/Details"/></DIV></td>
        <td class="tile-c" width="5px"  background='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif'>&nbsp;</td>
	</tr>
	<tr><td colspan="11" id="_logSearchTabInfo" style="background-color:#F7F8FA;height:40px;text-align:center;display:none" ><xlat:stream key="dvin/UI/Publish/Log/SpecifyText"/></td></tr>
	</thead>
	<tbody id="_logSearchTabBody">
	</tbody>
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
	<table style="width:100%;"><tr><td align="right"><span id="_searchLogPaginationB"></span></td></tr></table>
	</div>
	</div>
	<table class="width-outer-90"><tr><td align="left">
<%
if (ics.GetVar("cs_environment")=="portal"){%>
<a href="javascript:void(0);" onclick="window.close();"><IMG border="0" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/doubleArrow.gif'/>&nbsp;<xlat:stream key="dvin/UI/GotoPublishConsole"/></a>
<% }else{%>
    <satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/PublishConsoleFront" outstring="urlpubconsfront">
        <satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
        <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
		<%if(!"true".equals(ics.GetVar("_pubLive"))){%>
			<satellite:argument name="rows" value='<%=ics.GetVar("pubConsole:rows")%>'/>
		<%}%>
		<satellite:argument name="defaultTab" value="_t1"/>
    </satellite:link>
    <a href='<%=ics.GetVar("urlpubconsfront")%>'><IMG border="0" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/doubleArrow.gif'/>&nbsp;<b><xlat:stream key="dvin/UI/GotoPublishConsole"/></b></a>

<%}%></td><td align="right">
<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/PrologActions/Publish/AdvPub/PublishingStatus" outstring="urlpubstatus">
                        <satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
                        <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
						<satellite:argument name="cs_imagedir" value='<%=ics.GetVar("cs_imagedir")%>'/>
						<satellite:argument name="pubsess:id" value='<%=ics.GetVar("pubsess:id")%>'/>
						<%if(ics.GetVar("pubsess:status") != null ){%>
							<satellite:argument name="pubsess:status" value='<%=ics.GetVar("pubsess:status")%>'/>
						<%}%>
						<satellite:argument name="pubtgt:name" value='<%=ics.GetVar("pubtgt:name")%>'/>
						<satellite:argument name="pubtgt:id" value='<%=ics.GetVar("pubtgt:id")%>'/>
						<satellite:argument name="pubdt:name" value='<%=ics.GetVar("pubdt:name")%>'/>
						<satellite:argument name="_pubLive" value='<%=ics.GetVar("_pubLive")%>'/>
						<satellite:argument name="rows" value='<%=ics.GetVar("pubConsole:rows")%>'/>
				</satellite:link>
	 <a href='<%=ics.GetVar("urlpubstatus")%>'><IMG border="0" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/doubleArrow.gif'/>&nbsp;<b><xlat:stream key="dvin/UI/GotoPublishStatus"/></b></td></tr></table>
</satellite:form>
<div id="ajaxLoading" style="width:200px;height:100px;position:absolute; top: 350px; display:none; left: 320px;" bgcolor="white">
<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="#ffffff" align="center" style="border: 1px solid rgb(204,204,204);">
<tbody>
<tr>
<td valign="middle" align="center">
<img src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/wait_ax.gif'/>
<br/>
<br/>
<b>
<span id="loadingMsg"><xlat:stream key="dvin/UI/Loading"/></span>
<img src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/short_Progress.gif'/>
</b>
<a id="hider2" style="cursor: pointer; text-decoration: underline;"/>
</td>
</tr>
</tbody>
</table>
</div>
<script type="text/javascript">
document.onkeypress = function (e) {
	//the purpose of this function is to allow the enter key to search
	var key;
    if(window.event){
        key = window.event.keyCode;//IE
	} else {
        key = e.which;     //firefox
	}
	if (key == 13)
    {
        executeSearch();
		if(window.event){
			event.keyCode = 0;//IE
		} 
	}
}

dojo.addOnLoad(function() {
	dojo.addClass(dojo.body(), 'ttip');
});
var tooltips = {};
function showTooltip(evt,text,id){
	var target = evt.target || evt.srcElement;
	if(!tooltips[id]){
		var ttip = new dijit.Tooltip({
			label: text,
			connectId: dojo.query('td', dojo.byId(id)),
			showDelay : 250
		});
		ttip.open(target);
		tooltips[id] = ttip;
	} else {
		tooltips[id].open(target);
	}
	var conn = dojo.connect(dojo.byId(id), 'onmouseout',
		function() {
			tooltips[id].close();
			dojo.disconnect(conn);
	});
}
</script>
<script type="text/javascript">
Ajax.Responders.register({
  onCreate:showLoading,
  onComplete:hideLoading
});
var tabSet1 = new ProtoTabs('pubLogtabs',{defaultPanel:'_t1'});
$("_main").style.display="";
</script>
</body>
</html>
<%}%>
</cs:ftcs>