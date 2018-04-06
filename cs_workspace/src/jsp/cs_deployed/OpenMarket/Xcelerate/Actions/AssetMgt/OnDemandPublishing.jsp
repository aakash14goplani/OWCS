<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%//
// OpenMarket/Xcelerate/Actions/AssetMgt/OnDemandPublishing
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
<%@ page import="com.openmarket.xcelerate.commands.PubTargetManagerDispatcher"%>
<%@ page import="COM.FutureTense.Interfaces.FTValList"%>
<cs:ftcs>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment"/>
<html>
<head>
<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/AssetMgt/PublishableAssets" outstring="publishableAssetsURL">
	<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
	<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
	<satellite:argument name="cs_imagedir" value='<%=ics.GetVar("cs_imagedir")%>'/>
	<satellite:argument name="target" value='<%=ics.GetVar("target")%>'/>
	<satellite:argument name="rowsPerPage" value='<%=ics.GetVar("rowsPerPage")%>'/>
	<satellite:argument name="displayPage" value='<%=ics.GetVar("displayPage")%>'/>
</satellite:link>
<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/PrologActions/Publish/AdvPub/PublishingStatController" outstring="pubStatControllerURL"/>
<script language="JavaScript" src="<%=request.getContextPath()%>/js/json2.js"></script>
<script language="JavaScript" src="<%=request.getContextPath()%>/js/prototype.js"></script>
<script language="JavaScript" src="<%=request.getContextPath()%>/js/prototabs.js"></script>
<script type="text/javascript">
var W3CDOM = (document.createElement && document.getElementsByTagName);
var_searchStr ='';
var notWhitespace = /\S/;
//If there is no search page default display page to 1 and rowsPerPage for search
var rowsPerPage = 10;
var displayPage = 1;

function init(){
	updateODPanel('_t3','<%=ics.GetVar("publishableAssetsURL")%>&onDemandQueue=true&divContainerId=_t3');
}

function cleanWhitespace(node) {
  for (var x = 0; x < node.childNodes.length; x++) {
    var childNode = node.childNodes[x];
    if ((childNode.nodeType == 3)&&(!notWhitespace.test(childNode.nodeValue))) {
	// that is, if it's a whitespace text node
      node.removeChild(node.childNodes[x]);
      x--;
    }
    if (childNode.nodeType == 1) {
	// elements can have text child nodes of their own
      cleanWhitespace(childNode);
    }
  }
}

function addEvent(obj, eventType,fn, useCapture)
{
	if (obj.addEventListener) {
		obj.addEventListener(eventType, fn, useCapture);
		return true;
	} else {
		if (obj.attachEvent) {
			var r = obj.attachEvent("on"+eventType, fn);
			return r;
		}
	}
}

// this function is needed to work around
// a bug in IE related to element attributes
function hasClass(obj) {
   var result = false;
   if (obj.getAttributeNode("class") != null) {
       result = obj.getAttributeNode("class").value;
   }
   return result;
}

function toggleVisibility() {

    var theImage = this;
    var theRowName = this.id.replace('_image', '_comment');
    var theRow = document.getElementById(theRowName);
    if (theRow.style.display=="none") {
        theRow.style.display = "";
        theImage.src = '<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/Collapse.gif';
		var rowId = this.parentNode.parentNode.id;
		var assetStr = this.parentNode.parentNode.id.split(':');
		updatePanel('dep:' + assetStr[2],'<%=ics.GetVar("publishableAssetsURL")%>&divContainerId=dep:' + assetStr[2] + '&onlyMyDepsAssetId=' + assetStr[1] + ':' + assetStr[2] + '&rowsPerPage=5');
    } else {
        theRow.style.display = "none";
        theImage.src = '<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/Expand.gif';
    }
}

function initCollapsingRows(tbody_id)
{
	if (!W3CDOM) return;
	// the flag we'll use to keep track of
    // whether the current row is odd or even
	var even = true;
	cleanWhitespace($(tbody_id));
	var trs = $(tbody_id).childNodes;
	for (var i = 0; i < trs.length; i++) {
        if (i%2==0) {
			// Get a reference to the TD's
            var td = trs[i].getElementsByTagName('td')[1];
			if(td && td.id != "collapsible"){
				td.align="center";
				td.valign="middle";
				// Assign a related unique ID to the next row where the comment is
                // This is the row that will be expanded and collapsed
                var theRowName = "row_" + i + "_comment";
				trs[i+1].id = theRowName;
                trs[i+1].style.display = "none";
				// Create the new image object
                var theNewImage = document.createElement('img');
				var theNewImageName = "row_" + i + "_image";
                theNewImage.id = theNewImageName;
                theNewImage.src = '<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/Expand.gif';
				theNewImage.width = 18;
                theNewImage.height = 13;
				theNewImage.style.cursor = "pointer";
				theNewImage.className="expand";
				// Add "onclick" event to the image that expands and collapses the next row
                theNewImage.onclick = toggleVisibility;
				// Insert an image into the document tree inside the first TD
				if ((trs[i+1].getElementsByTagName('div')).length > 0){
					td.appendChild(theNewImage);
				}
				td.style.width="1%";
				td.id="collapsible";
			}
			// Skip the collapsbile row
            i++;
		}
    }

	// Reset "even" for the next table
    even = true;
}

function updatePanel(divId,url){
	//warning if 'showAll' is chosen
	var startIndex = url.indexOf('rowsPerPage=') + 12; 
	var endIndex = url.indexOf('&displayPage');
	var size = url.substr(startIndex,endIndex - startIndex);
	if(size > 5000){
		if (confirm('<xlat:stream key="dvin/UI/OnDemandPublishing/ShowAllWarning" encode="false" escape="true"/>') == false)
			return false;
	}
	if(url.indexOf('onDemandQueue=true') != -1){
		updateODPanel(divId,url);
	} else {
		new Ajax.Request(url,{
			method : 'get',
			onComplete: function(transport){
			$(divId).update(transport.responseText);
		}
		});
	}
}

function updateODPanel(divId,url){
	new Ajax.Request(url,{
		method : 'get',
		onSuccess: function(transport){
			$(divId).update(transport.responseText);
		},onComplete: function(transport){
			initCollapsingRows(divId+ ':AssetsBody');
		}
	});
}

function updatePanelsInSequence(first,firstURL,second,secondURL){
	new Ajax.Request(firstURL,{
		method : 'get',
		onSuccess: function(transport){
			$(first).update(transport.responseText);
		},onComplete: function(){
			updatePanel(second,secondURL);
		}
	});
}

function changeCheckBoxes(elm,FieldName){
	var objCheckBoxes = document.getElementsByName(FieldName);
	var CheckValue = elm.checked;
	if(!objCheckBoxes)
		return;
	var countCheckBoxes = objCheckBoxes.length;
	if(!countCheckBoxes)
		objCheckBoxes.checked = CheckValue;
	else
	// set the check value for all check boxes
	for(var i = 0; i < countCheckBoxes; i++){
		objCheckBoxes[i].checked = CheckValue;
		tr = objCheckBoxes[i].parentNode.parentNode;
		tr.style.backgroundColor = (objCheckBoxes[i].checked) ? "#eaf4fd" : "#fff";
	}
}

function changeRowColor(chbx) {
		tr = chbx.parentNode.parentNode;
		tr.style.backgroundColor = (chbx.checked) ? "#eaf4fd" : "#fff";
}

function unApprove(divContainerId){
    var assets='';
	var _chbxSel = false;
	var objCheckBoxes = document.forms[0].elements[divContainerId + ':' + 'chbx'];
	if(!objCheckBoxes)
		return;
	var countCheckBoxes = objCheckBoxes.length;
	if(!countCheckBoxes){
		if(objCheckBoxes.checked){
			_chbxSel = true;
			var assetArray = new Array();
			assetArray = objCheckBoxes.id.split(':');
            if (assetArray[3]!='VO'){
			assets = assetArray[1] + ':' + assetArray[2];
		}
        }

	} else {
	// get the value for all checked check boxes
		var _firstSelectedAsset = true;
		for(var i = 0; i < countCheckBoxes ; i++){
			if(objCheckBoxes[i].checked){
				_chbxSel = true;
				var assetArray = new Array();
				assetArray = objCheckBoxes[i].id.split(':');
                if (assetArray[3]!='VO'){
			    if(_firstSelectedAsset){
					assets = assetArray[1] + ':' + assetArray[2];
				} else {
					assets += ' ' + assetArray[1] + ':' + assetArray[2];
				}
				_firstSelectedAsset = false;
			}
		}
	}
	}
		if(!_chbxSel){
			showMsg(divContainerId,'<xlat:stream key="dvin/UI/OnDemandPublishing/NoAssetsSelected" encode="false" escape="true"/>');
			return false;
		} else if (assets.length==0){
            showMsg(divContainerId,'<xlat:stream key="dvin/UI/OnDemandPublishing/CannotUapproveVoided" encode="false" escape="true"/>');
            return false;
		} else {
		    if($('_t2:displayPage') && $('_t2:ROWSPERPAGEVAR')){
				displayPage = $('_t2:displayPage').value;
				rowsPerPage = $('_t2:ROWSPERPAGEVAR').value;
			}
			if(divContainerId == '_t1') {
			    updatePanelsInSequence('_t1','<%=ics.GetVar("publishableAssetsURL")%>&assetsQueue=true&function=unapprove&divContainerId=_t1&assetsToUnApprove=' + assets + '&displayPage=' + $('_t1:displayPage').value  + '&rowsPerPage=' + $('_t1:ROWSPERPAGEVAR').value,'_t2','<%=ics.GetVar("publishableAssetsURL")%>&divContainerId=_t2&searchAssets=true&assetsQueue=true&displayPage=' + displayPage  + '&rowsPerPage=' + rowsPerPage);
			}
			if(divContainerId == '_t2') {
				updatePanelsInSequence('_t2','<%=ics.GetVar("publishableAssetsURL")%>&assetsQueue=true&function=unapprove&divContainerId=_t2&searchAssets=true&assetsToUnApprove=' + assets + '&displayPage=' + displayPage + '&rowsPerPage=' + rowsPerPage,'_t1','<%=ics.GetVar("publishableAssetsURL")%>&divContainerId=_t1&assetsQueue=true&displayPage=' + $('_t1:displayPage').value + '&rowsPerPage=' + $('_t1:ROWSPERPAGEVAR').value);
			}
		}
	}

function showMsg (divContainerId,message) {
    if($(divContainerId+ ':alert')){
		$(divContainerId+ ':alert').update(message).setStyle({ background: '#FFF1A8' });;
		$(divContainerId+ ':alert').style.display = '';
	}
}

function addToOnDemandQueue(divContainerId){
	var assetIds='';
	var _chbxSel = false;
	var objCheckBoxes = document.forms[0].elements[divContainerId + ':chbx'];
	if(!objCheckBoxes)
		return;
	var countCheckBoxes = objCheckBoxes.length;
	if(!countCheckBoxes){
		if(objCheckBoxes.checked){
			_chbxSel = true;
			var assetArray = new Array();
			assetArray = objCheckBoxes.id.split(':');
			assetIds = assetArray[1] + ':' + assetArray[2];
		}

	} else {
	// get the value for all checked check boxes
	var _firstSelectedAsset = true;
	for(var i = 0; i < countCheckBoxes ; i++){
		if(objCheckBoxes[i].checked){
		    _chbxSel = true;
			var assetArray = new Array();
			assetArray = objCheckBoxes[i].id.split(':');
			if(_firstSelectedAsset){
				assetIds = assetArray[1] + ':' + assetArray[2];
			} else {
				assetIds += ';' + assetArray[1] + ':' + assetArray[2];
			}
			_firstSelectedAsset = false;
		}
	}
	}
	if(!_chbxSel){
		showMsg(divContainerId,'<xlat:stream key="dvin/UI/OnDemandPublishing/NoAssetsSelected" encode="false" escape="true"/>');
		return false;
	}
	var url = '<%=ics.GetVar("pubStatControllerURL")%>&action=getDependentAssets&target=<%=ics.GetVar("target")%>&assetIds=' + assetIds;
	if(assetIds.length > 0){
	    new Ajax.Request(url, {
			method: 'get',onLoading: showMsg(divContainerId,'<xlat:stream key="dvin/UI/OnDemandPublishing/PublishWaitDependenciesResolved" encode="false" escape="true"/>'),
			onComplete: function(transport) {
				if($('_t2:displayPage') && $('_t2:ROWSPERPAGEVAR')){
					displayPage = $('_t2:displayPage').value;
					rowsPerPage = $('_t2:ROWSPERPAGEVAR').value;
				}
			    updatePanel('_t1','<%=ics.GetVar("publishableAssetsURL")%>&assetsQueue=true&divContainerId=_t1&displayPage=' + $('_t1:displayPage').value + '&rowsPerPage=' + $('_t1:ROWSPERPAGEVAR').value);
				updatePanel('_t2','<%=ics.GetVar("publishableAssetsURL")%>&divContainerId=_t2&searchAssets=true&assetsQueue=true&displayPage=' + displayPage + '&rowsPerPage=' + rowsPerPage);
				updateODPanel('_t3','<%=ics.GetVar("publishableAssetsURL")%>&onDemandQueue=true&divContainerId=_t3&displayPage=' + $('_t3:displayPage').value + '&rowsPerPage=' + $('_t3:ROWSPERPAGEVAR').value);
			}
			});
		}
}

function removeFromOnDemandQueue(){
	var assetIds='';
	var _chbxSel = false;
	var objCheckBoxes = document.forms[0].elements['_t3:chbx'];
	if(!objCheckBoxes)
		return;
	var countCheckBoxes = objCheckBoxes.length;
	if(!countCheckBoxes){
		if(objCheckBoxes.checked){
			_chbxSel = true;
			var assetArray = new Array();
			assetArray = objCheckBoxes.id.split(':');
			assetIds = assetArray[1] + ':' + assetArray[2];
		}

	} else {
	// get the value for all checked check boxes
		var _firstSelectedAsset = true;
		for(var i = 0; i < countCheckBoxes ; i++){
			if(objCheckBoxes[i].checked){
				_chbxSel = true;
				var assetArray = new Array();
				assetArray = objCheckBoxes[i].id.split(':');
				if(_firstSelectedAsset){
					assetIds = assetArray[1] + ':' + assetArray[2];
				} else {
					assetIds += ';' + assetArray[1] + ':' + assetArray[2];
				}
				_firstSelectedAsset = false;
			}
		}
	}
	if(!_chbxSel){
		showMsg('_t3','<xlat:stream key="dvin/UI/OnDemandPublishing/NoAssetsSelected" encode="false" escape="true"/>');
		return false;
	}
	var url = '<%=ics.GetVar("pubStatControllerURL")%>&action=removeFromSession&target=<%=ics.GetVar("target")%>&assetIds=' + assetIds;

	if(assetIds.length > 0){
	    new Ajax.Request(url, {
			method: 'get',onLoading: showMsg('_t3','<xlat:stream key="dvin/UI/OnDemandPublishing/RemovingAssetsfromODQueue" encode="false" escape="true"/>'),
			onComplete: function() {
				if($('_t2:displayPage') && $('_t2:ROWSPERPAGEVAR')){
					displayPage = $('_t2:displayPage').value;
					rowsPerPage = $('_t2:ROWSPERPAGEVAR').value;
				}
				updatePanel('_t1','<%=ics.GetVar("publishableAssetsURL")%>&assetsQueue=true&divContainerId=_t1&displayPage=' + $('_t1:displayPage').value + '&rowsPerPage=' + $('_t1:ROWSPERPAGEVAR').value);
				updatePanel('_t2','<%=ics.GetVar("publishableAssetsURL")%>&divContainerId=_t2&searchAssets=true&assetsQueue=true&displayPage=' + displayPage + '&rowsPerPage=' + rowsPerPage);
				updateODPanel('_t3','<%=ics.GetVar("publishableAssetsURL")%>&onDemandQueue=true&divContainerId=_t3&displayPage=' + $('_t3:displayPage').value + '&rowsPerPage=' + $('_t3:ROWSPERPAGEVAR').value);
			}
			});
		}
}

//Hack for IE to modify the name of the element
function renameEl(el, newName) {
	if(typeof(el) == "string") {
		el = document.getElementById(el);
	}
	if(navigator.userAgent.toLowerCase().indexOf("msie") != -1) { // Internet Explorer
		el.removeAttribute('name');
		attributeEl = document.createElement('INPUT');
		attributeEl.setAttribute('Name', newName);
		holder = document.createElement('DIV');
		holder.appendChild(attributeEl);
		document.body.appendChild(holder);
		holder.innerHTML = holder.innerHTML;
		attributeEl = holder.firstChild;
		el.mergeAttributes(attributeEl, false);
		holder.parentNode.removeChild(holder);
	} else {
		el.name = newName;
	}
}

function executeSearch(){
    if(dijit.byId('_searchBx') && trim(dijit.byId('_searchBx').getValue()).length == 0){
			alert('<xlat:stream key="dvin/UI/NoTextToSearch" encode="false" escape="true"/>');
			searchBxFlag = false;
	} else {
			searchBxFlag = true;
			_searchStr = dijit.byId('_searchBx').getValue();
			var url = '<%=ics.GetVar("pubStatControllerURL")%>&action=populateSearchedAssets&target=<%=ics.GetVar("target")%>&matchThis=' + _searchStr;
			if($('_t2:ROWSPERPAGEVAR')){
					rowsPerPage = $('_t2:ROWSPERPAGEVAR').value;
			}
			//Create the search results in the session
			new Ajax.Request(url, {
				method: 'get',
				onComplete: function() {
				updatePanel('_t2','<%=ics.GetVar("publishableAssetsURL")%>&divContainerId=_t2&searchAssets=true&assetsQueue=true' + '&rowsPerPage=' + rowsPerPage);
				$('_searchTab').style.display='inline';
				tabSet1.openPanel($('_searchTab'));
			}
			});
	}
}

function trim(str){
	return str.replace(/^\s+|\s+$/g, '') ;
}
<%-- The function  showOrHideSearchBx is called by the prototabs.js when any tab is displayed and the ref to the tab element is passed to the function --%>
function showOrHideSearchBx(tabElm){
	(tabElm.id == '_publishableAssetsTab')?$('_searchTable').style.visibility='':$('_searchTable').style.visibility='hidden';
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

function alertForSelectedAssets(divContainerId){
	var objCheckBoxes = document.forms[0].elements[divContainerId + ':chbx'];
	if(!objCheckBoxes)
		return true;
	var countCheckBoxes = objCheckBoxes.length;
	var alertMessage = '';
	if(divContainerId == '_t3'){
		alertMessage = '<xlat:stream key="dvin/UI/OnDemandPublishing/AssetsSelectedRemoveFromQueue" encode="false" escape="true"/>'
	} else {
		alertMessage = '<xlat:stream key="dvin/UI/OnDemandPublishing/AssetsSelectedAddToQueue" encode="false" escape="true"/>'
	}
	if(!countCheckBoxes){
		if(objCheckBoxes.checked){
			alert(alertMessage);
			return false;
		}
	} else { 
		for(var i = 0; i < countCheckBoxes ; i++){
			if(objCheckBoxes[i].checked){
				alert(alertMessage);
				return false;
			}
		}
	}
	return true;
}
</script>
<link href='<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetVar("locale")%>/publish.css' rel="styleSheet" type="text/css"/>
<ics:callelement element="OpenMarket/Xcelerate/Util/LoadDefaultStyleSheet">
	<ics:argument name="cssFilesToLoad" value="publish.css"/>
</ics:callelement>
</head>
<body onLoad="init()">
<xlat:lookup key="dvin/Common/Search" varname="_XLAT_"/>
<xlat:lookup key="dvin/Common/Search" varname="mouseover" escape="true" encode="false"/>
<table class="width-inner-100" id="_searchTable"><tr><td style="width:40%;"></td><td align="right"><table><tr><td><div id="_searchBx" dojoType="fw.dijit.UIInput"  clearButton="true"></div></td><td><BR/></td><td><a href='#' onclick="executeSearch();return searchBxFlag;" onmouseover="window.status='<%=ics.GetVar("mouseover")%>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Search"/></ics:callelement></a></span></td></tr></table></td></tr></table>
<div class="tabs6 width">
	<div class="minwidth">
		<div class="container onDemandContainer">
			<ul id="onDemandTabs">
				<xlat:lookup key="dvin/UI/ApprovedAssets" varname="mouseover" escape="true" encode="false"/>
				<li id="_publishableAssetsTab"><a style="text-decoration:none;width:auto;" href="#_t1" onmouseover="window.status='<%=ics.GetVar("mouseover")%>';return true;" onmouseout="window.status='';return true;"><span>&nbsp;&nbsp;&nbsp;<xlat:stream key="dvin/UI/ApprovedAssets"/>&nbsp;&nbsp;&nbsp;</span></a></li>
				<xlat:lookup key="dvin/UI/CloseSearchResults" varname="_XLAT_"/>
				<xlat:lookup key="dvin/UI/SearchResults" varname="mouseover" escape="true" encode="false"/>
				<li id="_searchTab" style="display:none"><a style="text-decoration:none;width:auto;" href="#_t2" onmouseover="window.status='<%=ics.GetVar("mouseover")%>';return true;" onmouseout="window.status='';return true;"><span>&nbsp;&nbsp;&nbsp;<xlat:stream key="dvin/UI/SearchResults"/>&nbsp;&nbsp;<img id="_X" style="position:relative;bottom:1px;vertical-align:middle;border:none;" onClick="switchTab($('_publishableAssetsTab'));" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/x_close.gif' onmouseover="this.src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/x_close_hover.gif'" onmouseout="this.src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/x_close.gif'" title="<%=ics.GetVar("_XLAT_")%>"/>&nbsp;&nbsp;&nbsp;</span></a></li>
				<xlat:lookup key="dvin/UI/OnDemandPublishing/OnDemandQueue" varname="mouseover" escape="true" encode="false"/>
				<li id="_onDemandTab"><a style="text-decoration:none;width:auto;" href="#_t3" onmouseover="window.status='<%=ics.GetVar("mouseover")%>';return true;" onmouseout="window.status='';return true;"><span>&nbsp;&nbsp;&nbsp;<xlat:stream key="dvin/UI/OnDemandPublishing/OnDemandQueue"/>&nbsp;&nbsp;&nbsp;</span></a></li>
			</ul>
		</div>
	</div>
</div>
<div id ="_main" style="display:none;">
    <div id="_t1" class="panel width-inner-100"></div>
	<div id="_t2" class="panel width-inner-100"></div>
	<div id="_t3" class="panel width-inner-100"></div>
<table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-inner-100">
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
<tr><td colspan="3"></td></tr>
	<% if (ics.UserIsMember("xcelpublish")){%>
	<tr>
   <td colspan="2">
   <SPAN style="float:left">
   <xlat:lookup key="dvin/UI/Back" varname="_XLAT_" escape="true" encode="false"/>
   <IMG style="position:relative;top:4px;" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/back.gif' BORDER="0"/>&nbsp;<A HREF="javascript:void(0)" onclick="return BackHandler()" onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true;"><b><xlat:stream key="dvin/UI/Back"/></b></A></SPAN>
   <SPAN style="float:right">
   <%
   FTValList arglist = new FTValList();
   arglist.setValString("ID",ics.GetVar("target"));
   PubTargetManagerDispatcher.CanEdit(ics,arglist);
   if(!"-12034".equals(ics.GetVar("errno"))){%>
			<xlat:lookup key="dvin/UI/Publish" varname="_XLAT_" escape="true" encode="false"/>
	        <IMG style="position:relative;top:4px;"src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/PublishOnDemandQ.gif' BORDER="0" />&nbsp;<A HREF="javascript:void(0)" onclick="return setODCheck(document.forms[0]);" onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true;"><b><xlat:stream key="dvin/UI/OnDemandPublishing/PublishOnDemandQueue"/></b></A>
	<%}%>
   </SPAN>
   </td>
   <td></td>
</tr>
<%}%>
</table>

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
		} else {
			return false;
	}
	}
}
Ajax.Responders.register({
  onCreate:showLoading,
  onComplete:hideLoading
});

function updateTab(transport){
//dummy do nothing but required by prototabs
}
var tabSet1 = new ProtoTabs('onDemandTabs',{defaultPanel:'_t1',nonajaxUrls:{_t1:'<%=ics.GetVar("publishableAssetsURL")%>&assetsQueue=true&divContainerId=_t1'}});
$('_main').style.display="inline";
</script>
</body>
</html>	
</cs:ftcs>