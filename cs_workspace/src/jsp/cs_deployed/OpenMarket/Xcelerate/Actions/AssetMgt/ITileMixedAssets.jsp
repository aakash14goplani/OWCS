
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%//
// OpenMarket/Xcelerate/Actions/AssetMgt/ITileMixedAssets
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
<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/AssetMgt/TileMAssets" outstring="tileMAssetsURL">
	<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
	<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
	<satellite:argument name="cs_imagedir" value='<%=ics.GetVar("cs_imagedir")%>'/>
	<satellite:argument name="target" value='<%=ics.GetVar("target")%>'/>
	<satellite:argument name="rowsPerPage" value='<%=ics.GetVar("rowsPerPage")%>'/>
	<satellite:argument name="displayPage" value='<%=ics.GetVar("displayPage")%>'/>
</satellite:link>
<script language="JavaScript" src="<%=request.getContextPath()%>/js/prototype.js"></script>
<script type="text/javascript">


function init(){
	Ajax.Responders.register({
		onCreate:showLoading,
		onComplete:hideLoading
	});
	updatePanel('_t1','<%=ics.GetVar("tileMAssetsURL")%>&divContainerId=_t1');
}

function updatePanel(divId,url){
	new Ajax.Request(url,{
		method : 'get',
		onComplete: function(transport){
			$(divId).update(transport.responseText);
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
		    updatePanel('_t1','<%=ics.GetVar("tileMAssetsURL")%>&assetsQueue=true&function=unapprove&divContainerId=_t1&assetsToUnApprove=' + assets + '&displayPage=' + $('_t1:displayPage').value);
	}
}

function showMsg (divContainerId,message) {
	$(divContainerId+ ':alert').update(message).setStyle({ background: '#FFF1A8' });;
	$(divContainerId+ ':alert').style.display = '';
}
function showLoading(){
	$('ajaxLoading').style.display='block';
}

function hideLoading(){
	$('ajaxLoading').style.display='none';
}
</script>
<link href='<%=ics.GetVar("cs_imagedir")%>/data/css/<%=ics.GetVar("locale")%>/publish.css' rel="styleSheet" type="text/css"/>
<ics:callelement element="OpenMarket/Xcelerate/Util/LoadDefaultStyleSheet">
	<ics:argument name="cssFilesToLoad" value="publish.css"/>
</ics:callelement>
</head>
<body onLoad="init()">
<div id="_t1" class="panel width-outer-70"></div>
<div id="ajaxLoading" style="width:200px;height:100px;position:absolute; top: 350px; display:none; left: 320px;" bgcolor="white">
<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="#ffffff" align="center" style="border: 1px solid rgb(204,204,204);">
<tbody>
<tr>
<td style="vertical-align:middle;text-align:center">
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
</body>
</html>
</cs:ftcs>