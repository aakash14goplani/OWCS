<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// fatwire/security/SecurityConfigsFront
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
<%@ page import="COM.FutureTense.Access.*"%>
<%@ page import="com.fatwire.cs.core.security.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.fatwire.security.*"%>
<%@ page import="com.fatwire.realtime.util.Util"%>
<%@ page import="com.fatwire.assetapi.site.*, com.fatwire.cs.core.security.SecurityManager"%>
<cs:ftcs>
<string:encode variable="cs_imagedir" varname="cs_imagedir"/>
<string:encode variable="cs_environment" varname="cs_environment"/>
<string:encode variable="cs_formmode" varname="cs_formmode"/>
<satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/PickAssetPopupForAssetType" outstring="urlPickAsset">
	<satellite:argument name="cs_SelectionStyle" value="single"/>
	<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
    <satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
    <satellite:argument name="cs_CallbackSuffix" value='SelectId'/>
</satellite:link>
<script type="text/javascript" src="<%=request.getContextPath()%>/js/prototype.js"></script>
<script LANGUAGE="JavaScript">
var restrictedAssetTypes = ["FW_View","FW_Application","Template","CSElement","SiteEntry","AdvCols","Segments"];
function checkfields()
{
	var obj = document.forms['0'];
	
	if ( (obj.elements['objectname'].value.length == 0) ||
		 (obj.elements['objectname'].value.match(/^[\s]/) != null) ) {
	
	//Here means something is wrong, let us figure out what
			if (obj.elements['objecttype'].value == 'ASSET'  && obj.elements['sitename'].value == '') {
				alert('<xlat:stream key="dvin/UI/Admin/Error/Youmustspecifysitename" encode="false" escape="true"/>');
			}
			
			if (obj.elements['objectname'].value.length == 0) {
				alert('<xlat:stream key="dvin/UI/Admin/Error/Youmustspecifynamefortype" encode="false" escape="true"/>');
			}
			
			if ( obj.elements['objectname'].value.match(/^[\s]/) != null ) {
				alert('<xlat:stream key="dvin/UI/Admin/Error/Objectnamecannotstartwithaspace" encode="false" escape="true"/>');
			}
			obj.elements['objectname'].focus();
			return false;
	}
	if($('configaction').options.selectedIndex == -1){
		alert('<xlat:stream key="dvin/UI/Admin/Error/mustspecifyaction" encode="false" escape="true"/>');
		return false;
	}
	if(checkGroups()){
		return true;
	} else {
		return false;
	}
}
function checkGroups()
{
	var obj = document.forms['0'];
	if (obj.elements['groups'].selectedIndex == -1)
	{
		alert('<xlat:stream key="dvin/UI/Admin/Error/mustspecifygroups" encode="false" escape="true"/>');
		obj.elements['groups'].focus();
		return false;
	}
	return true;
}

function populateAssetSubType(element,assettype){
	if(assettype != '' && typeof(assettype)!='undefined') {
		url = "<%=request.getContextPath()%>/REST/types/" + assettype + "/subtypes";
		var headers = {
			'Content-type': 'application/json',
			'Accept': 'application/json'
		};
		new Ajax.Request(url, {
			method: 'get',
			requestHeaders  : headers,
			onCreate:function(){showLoading('ajaxLoading');},
			onSuccess: function(transport) {
				var dataObject = transport.responseText.evalJSON();
				var dataArray = dataObject.type;
				if(typeof(dataArray) === 'undefined'){
					hideLoading('ajaxLoading');
					return;
				}
				//Now add the other values
				for(var i=0 ; i < dataArray.length;i++ ){
					var optn = document.createElement("OPTION");
					optn.text = dataArray[i].name;
					optn.value = dataArray[i].name;
					//Add the option to the object name drop down
					element.options.add(optn);
				}
				hideLoading('ajaxLoading');
			},
			onError: function(transport) { 
				hideLoading('ajaxLoading');
			}
		});
	}
}

function populateAssetTypesForSite(element,sitename){
	if(sitename != '' && typeof(sitename)!='undefined') {
		var url = "<%=request.getContextPath()%>/REST/sites/" + sitename + "/types";
		var headers = {
			'Content-type': 'application/json',
			'Accept': 'application/json'
		};
		new Ajax.Request(url, {
			method: 'get',
			requestHeaders  : headers,
			onCreate:function(){showLoading('ajaxLoading');},
			onSuccess: function(transport) {
				var dataObject = transport.responseText.evalJSON();
				var dataArray = dataObject.type;
				if(typeof(dataArray) === 'undefined'){
					hideLoading('ajaxLoading');
					return;
				}
				//Lets remove the restricted asset types
				for(var i=0 ; i < dataArray.length;i++ ){
					if(restrictedAssetTypes.indexOf(dataArray[i].name) != -1){
						//Remove the entry
						dataArray.splice(i,1);
						//Modify i to take into account the removed element
						i--;
					}
				}
				//Now add the other values
				for(var i=0 ; i < dataArray.length;i++ ){
					var optn = document.createElement("OPTION");
					optn.text = dataArray[i].name;
					optn.value = dataArray[i].name;
					//Add the option to the object name drop down
					element.options.add(optn);
				}
				hideLoading('ajaxLoading');
			},
			on403: function(transport) { 
				alert('<xlat:stream key="dvin/UI/Error/NoPrivilegeToAccessResource"/>');
				hideLoading('ajaxLoading');
				$('objectname').disabled=true;
			}
		});
	}
}

function populateObjectName(type){
var url = '';
var dataArray = [];
	if(type == 'SITE'){
		url = "<%=request.getContextPath()%>/REST/sites";
	} else if(type == 'USER'){
		url = "<%=request.getContextPath()%>/REST/users";
	} else if(type == 'ROLE'){
		url = "<%=request.getContextPath()%>/REST/roles";
	} else if (type == 'ASSETTYPE'){
		url = "<%=request.getContextPath()%>/REST/types";
	} else if (type == 'INDEX'){
		url = "<%=request.getContextPath()%>/REST/indexes";
	} else if (type == 'APPLICATION'){
		url = "<%=request.getContextPath()%>/REST/applications";
	} else if (type == 'GROUP'){
		url = "<%=request.getContextPath()%>/REST/groups";
	}
	if(url != '') {
		var headers = {
			'Content-type': 'application/json',
			'Accept': 'application/json'
		};
		new Ajax.Request(url, {
			method: 'get',
			requestHeaders  : headers,
			onCreate:function(){showLoading('ajaxLoading');},
			onSuccess: function(transport) {
				var dataObject = transport.responseText.evalJSON();
				if(type == 'SITE'){
					dataArray = dataObject.site;
				} else if(type == 'USER'){
					dataArray = dataObject.users;
				} else if(type == 'ROLE'){
					dataArray = dataObject.role;
				} else if (type == 'ASSETTYPE'){
					dataArray = dataObject.type;
					//Lets remove the restricted asset types
					for(var i=0 ; i < dataArray.length;i++ ){
						if(restrictedAssetTypes.indexOf(dataArray[i].name) != -1){
							//Remove the entry
							dataArray.splice(i,1);
							//Modify i to take into account the removed element
							i--;
						}
					}
				} else if (type == 'INDEX'){
					dataArray = dataObject.indexConfig;
				} else if (type == 'APPLICATION'){
					dataArray = dataObject.applications;
				} else if (type == 'GROUP'){
					dataArray = dataObject.groups;
				}
				if(typeof(dataArray) === 'undefined')
					return;
				dataArray.sort(sortDataArrayOptions);
				//Now add the other values
				for(var i=0 ; i < dataArray.length;i++ ){
					var optn = document.createElement("OPTION");
					optn.text = dataArray[i].name;
					if (type == 'APPLICATION'){
						optn.value = dataArray[i].id;
					} else {
						optn.value = dataArray[i].name;
					}
					//Add the option to the object name drop down
					$('objectname').options.add(optn);
				}
				hideLoading('ajaxLoading');
			},
			on403: function(transport) { 
				alert('<xlat:stream key="dvin/UI/Error/NoPrivilegeToAccessResource"/>');
				hideLoading('ajaxLoading');
				$('objectname').disabled=true;
			}
		});
	}
}

//Prepopulate the object name dropdown when the page loads if the action is new.
if("new" == '<%=ics.GetVar("action")%>'){
	Event.observe(window, 'load', function() {
		objectTypeSelected($('objecttype').value);
	});
}

function sortDataArrayOptions(darry1,darry2){
	var x = darry1.name.toLowerCase();
    var y = darry2.name.toLowerCase();
    return ((x < y) ? -1 : ((x > y) ? 1 : 0));
}

function OpenPickAssetPopUp(site){
	var url = '<%=ics.GetVar("urlPickAsset")%>';
	var pURL = url + '&pubname=' + site + '&searchAType=' + $('objectname').value;
	return window.open(pURL, "PickAssetPopUp", "directories=no,left=700,location=no,menubar=no,resizable=yes,top=50,width=600,height=550");
}


function PickAssetCallback_SelectId(id){
	var objectNameSelect = document.getElementById('objectname');
	//Reset the object before populating it
	objectNameSelect.length = 0;
	var optn = document.createElement("OPTION");
	var data = id.split(':');
	var assettype = data[0];
	var assetid = data[1];
	var assetname = data[2];
	optn.text = assetname;
	optn.value = assettype + ':' + assetid;
	objectNameSelect.options.add(optn);
	objectNameSelect.multiple=false;
	objectNameSelect.style.width="300px";
	//Set the config action to the required list of actions
	var options = ['READ','UPDATE','DELETE'];
	//Reset the config action
	$('configaction').length = 0;
	for(var i=0;i< options.length;i++){
		createNewOption('configaction',i,getLocaleString(options[i]),options[i],false);
	}
	//Enable the action drop down
	$('configaction').disabled = false;
	//Make the browse button invisible
	$('assetBrowse').style.display='none';
}

function showLoading(waitingDiv){
	$(waitingDiv).style.cursor ='wait';
    $('ajaxLoading').style.display='block';
}

function hideLoading(waitingDiv){
	$(waitingDiv).style.cursor ='default'
    $('ajaxLoading').style.display='none';
}

function createNewOption(elementId,position,text,value,resetBeforeAdd,selectedIndex){
	var element = document.getElementById(elementId);
	if(resetBeforeAdd)
		element.length = 0;
	var elOptNew = document.createElement('option');
	elOptNew.text = text;
	elOptNew.value = value;
	element.options.add(elOptNew, position);
	if(typeof(selectedIndex)!='undefined')
		element.options.selectedIndex=selectedIndex;
}

function objectTypeSelected(type){
	
	$('configaction').disabled=true;
	$('objectname').disabled=false;
	$('objectname').style.width='220px';
	//Reset the subtype element
	$('objectsubtype').length = 0;
	//Make the object subtype row invisible
	$('objsubtypeRow').style.display='none';
	//Make the site row invisible and reset the site value
	$('sitename').value='';
	$('siteRow').style.display = 'none';
	//Object type selection will populate the object name dropdown.
	//Reset the object name drop down before populating it
	$('objectname').length = 0;
	//Hide the asset browse button
	$('assetBrowse').style.display='none';
	//Add the default select name option
	createNewOption('objectname',0,'<xlat:stream key="dvin/Common/SelectSite"/>','',false);
	if(type === 'SITE' || type === 'USER' || type === 'ROLE' || type === 'INDEX'|| type === 'ASSETTYPE' || type === 'APPLICATION' || type === 'GROUP' || type === 'ENGAGE' || type === 'VISITOR'){
		//Add the Any option
		createNewOption('objectname',1,'<%=_showLocaleString(ics,"_ANY_")%>','_ANY_',false);
		populateObjectName(type);
	} else if(type === 'ACL' || type === 'USERLOCALES' || type === 'USERDEF'){
		//Add the Any option
		createNewOption('objectname',1,'<%=_showLocaleString(ics,"_ANY_")%>','_ANY_',false);
	} else if(type === 'ASSET'){
		//Make the site row visible
		$('siteRow').style.display = '';
		$('objectname').disabled = true;
	}
	
	if(type === 'ENGAGE') {
		$('siteRow').style.display = '';
	}
}

function objectNameSelected(name){
	$('configaction').disabled=false;
	//Object name selection will populate the action dropdown based on the value of object name
	//Reset the config action drop down before populating it
	$('configaction').length = 0;
	if(name == '') {
		$('assetBrowse').style.display='none';
		return;
	}
	if(name == '_ANY_'){
		//Hide the browse button
		$('assetBrowse').style.display='none';
	//handle different object types
		if($('objecttype').value=='SITE' || $('objecttype').value=='USER' || $('objecttype').value=='ROLE' || $('objecttype').value=='INDEX'){
			var options = ['CREATE','DELETE','LIST','READ','UPDATE'];
		} else if($('objecttype').value=='ACL' || $('objecttype').value=='USERLOCALES' || $('objecttype').value=='GROUP'){
			var options = ['LIST'];
		} else if($('objecttype').value=='ASSETTYPE'){
			$('objectsubtype').length = 0;
			$('objsubtypeRow').style.display = 'none';
			var options = ['CREATE','DELETE','LIST','READ'];
		} else if($('objecttype').value=='APPLICATION'){
			var options = ['CREATE','DELETE','UPDATE'];
		} else if($('objecttype').value=='ASSET'){
			var options = ['CREATE','DELETE','LIST','READ','UPDATE'];
		} else if($('objecttype').value=='USERDEF' ||  $('objecttype').value=='ENGAGE'){
			var options = ['READ'];
		}  else if($('objecttype').value == 'VISITOR') {
			
			var options = ['CREATE' ,'READ'];
		}
		for(var i=0;i< options.length;i++){
			createNewOption('configaction',i,getLocaleString(options[i]),options[i],false);
		}
	} else {
	//handle different object types
		if($('objecttype').value=='SITE' || $('objecttype').value=='USER' || $('objecttype').value=='ROLE' || $('objecttype').value=='INDEX'){
			var options = ['DELETE','READ','UPDATE'];
		} else if($('objecttype').value=='ASSETTYPE'){
			var options = ['DELETE','READ'];
			$('objsubtypeRow').style.display='';
			
			//Add the default select name option
			createNewOption('objectsubtype',0,'<xlat:stream key="dvin/Common/SelectSite"/>','',true);
			//Add the Any option
			createNewOption('objectsubtype',1,'<%=_showLocaleString(ics,"_ANY_")%>','_ANY_',false);
			populateAssetSubType($('objectsubtype'),name);
		} else if($('objecttype').value=='ASSET'){
			$('assetBrowse').style.display='';
			var options = ['CREATE','DELETE','LIST','READ','UPDATE'];
		} else if($('objecttype').value=='APPLICATION'){
			var options = ['DELETE','UPDATE'];
		} else if($('objecttype').value=='GROUP' ){
			var options = ['READ'];
		}
		for(var i=0;i< options.length;i++){
			createNewOption('configaction',i,getLocaleString(options[i]),options[i],false);
		}
	}
}

function objectSubTypeSelected(subtype){
	$('configaction').disabled=false;
	$('configaction').length=0;
	if($('objecttype').value == 'ASSETTYPE'){
		if(subtype == '_ANY_'){
			var options = ['LIST'];
			for(var i=0;i< options.length;i++){
				createNewOption('configaction',i,getLocaleString(options[i]),options[i],false);
			}
		} else if(subtype == ''){
			if($('objectname').value == '_ANY_' ){
				$('objectsubtype').style.display = 'none';
				var options = ['CREATE','LIST'];
				for(var i=0;i< options.length;i++){
					createNewOption('configaction',i,getLocaleString(options[i]),options[i],false);
				}
				
			} else {
				$('objectsubtype').style.display = '';
				var options = ['DELETE','READ'];
				for(var i=0;i< options.length;i++){
					createNewOption('configaction',i,getLocaleString(options[i]),options[i],false);
				}
				
			}
			
		} else {
			var options = ['READ'];
			for(var i=0;i< options.length;i++){
				createNewOption('configaction',i,getLocaleString(options[i]),options[i],false);
			}
		}
	}
}

function siteSelected(sitename){
	//Reset the object name drop down width
	$('objectname').length = 0;
	$('objectname').style.width='220px';
	//Reset the config action button
	$('configaction').length=0;
	$('assetBrowse').style.display='none';
	if(sitename != ''){
		if($('objecttype').value == 'ASSET'){
			//Add the default select name option
			createNewOption('objectname',0,'<xlat:stream key="dvin/Common/SelectSite"/>','',false);
			if(sitename != '_ANY_'){
				populateAssetTypesForSite($('objectname'),sitename);
			} 
			createNewOption('objectname',1,'<xlat:stream key="dvin/UI/Any"/>','_ANY_',false);
			$('objectname').disabled = false;
		} else 
		{
			$('objectname').disabled = false;
			createNewOption('objectname',1,'<%=_showLocaleString(ics,"_ANY_")%>','_ANY_',false);
			var options = ['READ'];
			for(var i=0;i< options.length;i++){
				createNewOption('configaction',i,getLocaleString(options[i]),options[i], true);
			}
			$('configaction').disabled = false;
			
		}
	}
}
<%-- Client side method to get the locale strings--%>
function getLocaleString(str){
	if(str == "CREATE"){
		return '<%=Util.xlatLookup(ics,"dvin/Common/Create")%>';
	} else if(str == "UPDATE"){
		return '<%=Util.xlatLookup(ics,"dvin/UI/Update")%>';
	} else if(str == "DELETE"){
		return '<%=Util.xlatLookup(ics,"dvin/Common/Delete")%>';
	} else if(str == "READ"){
		return '<%=Util.xlatLookup(ics,"dvin/Common/ReadOrHead")%>';
	} else if(str == "LIST"){
		return '<%=Util.xlatLookup(ics,"dvin/Common/List")%>';
	} else if(str == "_ANY_"){
		return '<%=Util.xlatLookup(ics,"dvin/UI/Any")%>';
	} else if(str == "SITE"){
		return '<%=Util.xlatLookup(ics,"dvin/Common/Site")%>';
	} else if(str == "USER"){
		return '<%=Util.xlatLookup(ics,"dvin/Common/User")%>';
	} else if(str == "GROUP"){
		return '<%=Util.xlatLookup(ics,"dvin/UI/Admin/Group")%>';
	} else if(str == "ROLE"){
		return '<%=Util.xlatLookup(ics,"dvin/Common/Role")%>';
	} else if(str == "INDEX"){
		return '<%=Util.xlatLookup(ics,"dvin/UI/Admin/Index")%>';
	} else if(str == "ASSET"){
		return '<%=Util.xlatLookup(ics,"dvin/UI/Asset")%>';
	} else if(str == "ASSETTYPE"){
		return '<%=Util.xlatLookup(ics,"dvin/UI/AssetTypenospace")%>';
	} else if(str == "USERLOCALES"){
		return '<%=Util.xlatLookup(ics,"dvin/UI/UserLocales")%>';
	} else if(str == "USERDEF"){
		return '<%=Util.xlatLookup(ics,"dvin/UI/UserDef")%>';
	} else if(str == "ACL"){
		return '<%=Util.xlatLookup(ics,"dvin/UI/ACLs")%>';
	}
}

function actionSelected(){
	//We implictly select the read option if update or create action is selected.
	var selectRead = false;
	var readIndex = -1;
	for(var i=0;i < $('configaction').options.length;i++){
		if($('configaction').options[i].selected && ($('configaction').options[i].value == 'CREATE' ||  $('configaction').options[i].value == 'UPDATE')){
			selectRead = true;
		}
		if($('configaction').options[i].value == 'READ'){
			readIndex = i
		}
	}
	if(readIndex != -1) {
		if(selectRead)
			$('configaction').options[readIndex].selected = true;
	}
}	
</script>
<%
ics.SetVar("userIsGeneralAdmin","false");
%>
<!-- Check if the current user has General Admin role in any one of the publications 
	If so, he can set the security and manage them.
-->
<%
String _pubid = ics.GetSSVar("pubid");
//Allow the access for the management(pubid = 0) site by default
if(!"0".equals(_pubid)){
%>
	<ics:callelement element="OpenMarket/Xcelerate/Admin/CheckIsUserAdmin">
		<ics:argument name="adminRoleToCheck" value="GeneralAdmin" />
	</ics:callelement>
<%	
} else {
	ics.SetVar("userIsGeneralAdmin","true");
}

if("true".equals(ics.GetVar("userIsGeneralAdmin"))){
        UserGroupManager ugm = new UserGroupManagerImpl(ics);
        UserManager um = new UserManagerImpl(ics);
        GroupManager gm = new GroupManagerImpl(ics);
        SecurityManager securityM = new SecurityManagerImpl( ics );
		SiteManager sm = new SiteManagerImpl(ics);
		if("list".equals(ics.GetVar("action"))){
		List<Map<String, Object>> securityconfigs = securityM.listAllConfigs();
		String sortByVal = ics.GetVar("sortby");
		if(sortByVal == null || sortByVal.equals("objecttype")){
			Collections.sort(securityconfigs,new ObjectTypeComparator());
		} else if (sortByVal.equals("objectname")){
			Collections.sort(securityconfigs,new ObjectNameComparator());
		} else if (sortByVal.equals("sitename")){
			Collections.sort(securityconfigs,new SiteComparator());
		} else if (sortByVal.equals("action")){
			Collections.sort(securityconfigs,new ActionComparator());
		} 
    %>
	<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key="dvin/UI/Admin/SecurityConfigurations"/></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
	</table>
	<P/><P/>
	<table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-70">
					<tr>
						<td></td><td class="tile-dark" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td><td></td>
					</tr>
					<tr>
						<td class="tile-dark" VALIGN="top" WIDTH="1" NOWRAP="nowrap"><BR /></td>
						<td >
							<table class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff"><tr><td colspan="15" class="tile-highlight"><IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td></tr>
							<tr><td class="tile-a" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;</td>
							<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;</td>
					            	<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;</td><td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">
	  <satellite:link assembler="query" pagename="fatwire/security/SecurityConfigsFront" outstring="urlsecurityconfigs">
		<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
		<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
		<satellite:argument name="action" value="list"/>
		<satellite:argument name="sortby" value="objecttype"/>
	</satellite:link >
													<A HREF='<%=ics.GetVar("urlsecurityconfigs")%>'><DIV class="new-table-title"><xlat:stream key="dvin/UI/Common/Type"/></DIV></A></td>
		  					<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;&nbsp;&nbsp;&nbsp;</td><td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">
	<satellite:link assembler="query" pagename="fatwire/security/SecurityConfigsFront" outstring="urlsecurityconfigs">
		<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
		<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
		<satellite:argument name="action" value="list"/>
		<satellite:argument name="sortby" value="sitename"/>
	</satellite:link >
	                                                <A HREF='<%=ics.GetVar("urlsecurityconfigs")%>'><DIV class="new-table-title"><xlat:stream key="dvin/Common/Site"/></DIV></A></td>
							<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;&nbsp;&nbsp;&nbsp;</td><td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">
	                                                <DIV class="new-table-title"><xlat:stream key="dvin/Common/Subtype"/></DIV></td>
							<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;&nbsp;&nbsp;&nbsp;</td><td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">
	<satellite:link assembler="query" pagename="fatwire/security/SecurityConfigsFront" outstring="urlsecurityconfigs">
		<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
		<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
		<satellite:argument name="action" value="list"/>
		<satellite:argument name="sortby" value="objectname"/>
	</satellite:link >
	<A HREF='<%=ics.GetVar("urlsecurityconfigs")%>'><DIV class="new-table-title"><xlat:stream key="dvin/Common/Name"/></DIV></A></td>
							<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;&nbsp;&nbsp;&nbsp;</td><td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">
	                                                <DIV class="new-table-title"><xlat:stream key="dvin/TreeApplet/SecurityGroups"/></DIV></td>						
							<td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;&nbsp;&nbsp;&nbsp;</td><td class="tile-b" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">
	<satellite:link assembler="query" pagename="fatwire/security/SecurityConfigsFront" outstring="urlsecurityconfigs">
		<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
		<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
		<satellite:argument name="action" value="list"/>
		<satellite:argument name="sortby" value="action"/>
	</satellite:link >
	<A HREF='<%=ics.GetVar("urlsecurityconfigs")%>'><DIV class="new-table-title"><xlat:stream key="dvin/UI/Admin/Action"/></DIV></A></td>						
								<td class="tile-c" background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/grad.gif">&nbsp;</td>
							</tr>
							<tr><td colspan="15" class="tile-dark"><IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td></tr>

					   		<%
							ics.SetVar("rowStyle","tile-row-normal");
							ics.SetVar("separatorLine","0");
							if(securityconfigs.size() == 0){%>
							<tr>
								<td><BR/></td><td colspan="13" style="height:25px;text-align:center;"><xlat:stream key="dvin/UI/Admin/NoSecurityConfigsAvailable"/></td><td><BR/></td>
							</tr>
							<%}
							for(Map<String,Object> entry : securityconfigs){
							String sitename = (String)entry.get("site");
							if("_ANY_".equals(sitename)){
								sitename = _showLocaleString(ics,"_ANY_");
							}
							String objectTypeName = (String)entry.get("objecttype");
							//Don't show the DB option
							if(!"DB".equals(objectTypeName)){
								String objecttype = _showLocaleString(ics,objectTypeName);
								String objectsubtype = (String)entry.get("objectsubtype");
								if("_ANY_".equals(objectsubtype)){
									objectsubtype = _showLocaleString(ics,"_ANY_");
								}
								String objectname = (String)entry.get("objectname");
								if("_ANY_".equals(objectname)){
									objectname = _showLocaleString(ics,"_ANY_");
								}
								List<String> groups = (List<String>)entry.get("accessgroups");
								String actionName = ((ActionEnum)entry.get("action")).getName();
								String configaction =  _showLocaleString(ics,actionName);
								if("1".equals(ics.GetVar("separatorLine"))){
								%>
										<%--<tr>
												<td colspan="15" class="light-line-color"><img height="1" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>
											</tr>--%>
									<%}
									ics.SetVar("separatorLine","1");
									%>
									<tr class='<%=ics.GetVar("rowStyle")%>'><td><BR /></td>
										<td NOWRAP="NOWRAP" ALIGN="LEFT">
										<xlat:lookup key="dvin/Common/Inspect" varname="_XLAT_" escape="true"/>
										<xlat:lookup key="dvin/UI/Admin/InspectThisConfig" varname="_alt_"/>
										<satellite:link assembler="query" pagename="fatwire/security/SecurityConfigsFront" outstring="urlsecurityconfigs">
												<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
												<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
												<satellite:argument name="action" value="inspect"/>
												<%if(sitename != null){%>
												<satellite:argument name="sitename" value='<%=sitename%>'/>
												<%}%>
												<satellite:argument name="objecttype" value='<%=objectTypeName%>'/>
												<%if(objectsubtype != null){%>
												<satellite:argument name="objectsubtype" value='<%=objectsubtype%>'/>
												<%}%>
												<satellite:argument name="objectname" value='<%=objectname%>'/>
												<satellite:argument name="groups" value='<%=_toCommaString((List<String>)groups)%>'/>
												<satellite:argument name="configaction" value='<%=actionName%>'/>
										</satellite:link>
										<A HREF='<%=ics.GetVar("urlsecurityconfigs")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><img height="14" width="14" hspace="2" vspace="4" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconInspectContent.gif'  border="0" title='<%=ics.GetVar("_alt_")%>' alt='<%=ics.GetVar("_alt_")%>'/></A>
											<xlat:lookup key="dvin/Common/Edit" varname="_XLAT_" escape="true"/><xlat:lookup key="dvin/UI/Admin/EditThisConfig" varname="_alt_"/>
											<satellite:link assembler="query" pagename="fatwire/security/SecurityConfigsFront" outstring="urlsecurityconfigs">
												<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
												<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
												<satellite:argument name="action" value="edit"/>
												<%if(sitename != null){%>
												<satellite:argument name="sitename" value='<%=sitename%>'/>
												<%}%>
												<satellite:argument name="objecttype" value='<%=objectTypeName%>'/>
												<%if(objectsubtype != null){%>
												<satellite:argument name="objectsubtype" value='<%=objectsubtype%>'/>
												<%}%>
												<satellite:argument name="objectname" value='<%=objectname%>'/>
												<satellite:argument name="groups" value='<%=_toCommaString((List<String>)groups)%>'/>
												<satellite:argument name="configaction" value='<%=actionName%>'/>
											</satellite:link>
														<A HREF='<%=ics.GetVar("urlsecurityconfigs")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><img height="14" width="14" hspace="2" vspace="4" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconEditContent.gif'  title='<%=ics.GetVar("_alt_")%>' border="0" alt='<%=ics.GetVar("_alt_")%>'/></A>
											
											<xlat:lookup key="dvin/Common/Delete" varname="_XLAT_" escape="true"/><xlat:lookup key="dvin/UI/Admin/DeleteThisConfig" varname="_alt_"/>
											<satellite:link assembler="query" pagename="fatwire/security/SecurityConfigsFront" outstring="urlsecurityconfigs">
												<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
												<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
												<satellite:argument name="action" value="confirmdelete"/>
												<%if(sitename != null){%>
												<satellite:argument name="sitename" value='<%=sitename%>'/>
												<%}%>
												<satellite:argument name="objecttype" value='<%=objectTypeName%>'/>
												<%if(objectsubtype != null){%>
												<satellite:argument name="objectsubtype" value='<%=objectsubtype%>'/>
												<%}%>
												<satellite:argument name="objectname" value='<%=objectname%>'/>
												<satellite:argument name="groups" value='<%=_toCommaString((List<String>)groups)%>'/>
												<satellite:argument name="configaction" value='<%=actionName%>'/>
											</satellite:link>
														<A HREF='<%=ics.GetVar("urlsecurityconfigs")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><img height="14" width="14" hspace="2" vspace="4" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconDeleteContent.gif"  border="0" title='<%=ics.GetVar("_alt_")%>' alt='<%=ics.GetVar("_alt_")%>'/></A>
									
											</td>
											<td><BR /></td><td ALIGN="LEFT">
											<DIV class="small-text-inset">
											<string:stream value='<%=objecttype%>'/>
											</DIV>
											</td>
											<td><BR /></td><td NOWRAP="NOWRAP" ALIGN="LEFT">
													<DIV class="small-text-inset">
														<string:stream value='<%=sitename%>'/>
													</DIV>
											</td>
											<td><BR /></td><td ALIGN="LEFT">
											<DIV class="small-text-inset">
											<string:stream value='<%=objectsubtype%>'/>
											</DIV>
											</td>
											<td><BR /></td><td ALIGN="LEFT">
											<DIV class="small-text-inset">
											<string:stream value='<%=objectname%>'/>
											</DIV>
											</td>
											<td><BR /></td><td ALIGN="LEFT">
											<DIV class="small-text-inset">
											<string:stream value='<%=_toCommaString((List<String>)groups)%>'/>
											</DIV>
											</td>
											<td><BR /></td><td ALIGN="LEFT">
											<DIV class="small-text-inset">
											<string:stream value='<%=configaction%>'/>
											</DIV>
											</td>
											<td><BR /></td></tr>
								<%if("tile-row-normal".equals(ics.GetVar("rowStyle"))){
									ics.SetVar("rowStyle","tile-row-highlight");
								} else {
									ics.SetVar("rowStyle","tile-row-normal");
								}
							}
							}%>
							</table>
						</td>
						<td class="tile-dark" VALIGN="top" WIDTH="1" NOWRAP="nowrap"><BR /></td>
						</tr>
					<tr>
					<td colspan="3" class="tile-dark" VALIGN="TOP" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
					</tr>
					<tr>
					<td></td><td background="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/shadow.gif"><IMG WIDTH="1" HEIGHT="5" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td><td></td>
					</tr>
					</table>
					<satellite:link assembler="query" pagename="fatwire/security/SecurityConfigsFront" outstring="urlsecurityconfigs">
						<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
						<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
						<satellite:argument name="cs_imagedir" value='<%=ics.GetVar("cs_imagedir")%>'/>
                        <satellite:argument name="action" value="new"/>
                    </satellite:link>
	<div class="width-outer-70">
	<A HREF='<%=ics.GetVar("urlsecurityconfigs")%>'><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/AddNew"/></ics:callelement></A>
	</div><P/>
<%} else if("new".equals(ics.GetVar("action"))){
	List<SiteInfo> sites = sm.list();
	//Sort the sites
	Collections.sort(sites,new SiteInfoComparator());
    List<Group> groups = gm.list();
	//Sort the groups
	Collections.sort(groups,new GroupNameComparator());
    ActionEnum[] actions = ActionEnum.values();
	Collections.sort(Arrays.asList(actions),new ActionEnumComparator());
	CSObjectTypeEnum[] objectTypes = CSObjectTypeEnum.values();
	List<CSObjectTypeEnum> objTypeList = Arrays.asList(objectTypes);
	Collections.sort(objTypeList,new ObjectTypeEnumComparator());
	%>
	<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key="dvin/UI/Admin/AddNewSecurityConfiguration"/></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
	</table>	
	<P/>
	<satellite:link assembler="query" pagename="fatwire/security/SecurityConfigsFront" outstring="urlsecurityconfigs">
		<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
		<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
		<satellite:argument name="cs_imagedir" value='<%=ics.GetVar("cs_imagedir")%>'/>
        <satellite:argument name="action" value="list"/>
    </satellite:link>
    <table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-30 margin-top-zero">
	<tr><td>
		<table class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
			<tbody>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td NOWRAP="NOWRAP" class="form-label-text"><span class="alert-color">*</span><xlat:stream key='dvin/UI/Common/Type'/>:
				</td>
				<td class="form-inset">
                  	   <select name='objecttype' id='objecttype'  style="width:220px;" onChange="objectTypeSelected(this.value)">
							<%
                            for( CSObjectTypeEnum oe : objTypeList)
                            {
								String objecttype = _showLocaleString(ics,oe.getName());
								//Remove the DB option from the UI.
								if(!"DB".equals(oe.getName())){
									if("SITE".equals(oe.getName())){
									%>
										<option value='<%=oe.getName()%>' selected><%=objecttype%></option>
									<%
									} else {
									%>
										<option value='<%=oe.getName()%>'><%=objecttype%></option>
									<%
									}
								}
							}
                            %>
						</select> 
				</td>
			</tr>
			</tbody>
			<tbody id="siteRow" style="display:none">
			<%--<tr><td colspan="3" class="light-line-color"><IMG WIDTH="1" HEIGHT="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td></tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td class="form-label-text"><xlat:stream key="dvin/Common/Site"/>:
				</td>
				<td class="form-inset">
						<select name='sitename' style="width=220px;" id="sitename" onchange="siteSelected(this.value)">
                                <option value='' selected><xlat:stream key="dvin/Common/SelectSite"/></option>
								<option value='_ANY_' selected><xlat:stream key="dvin/UI/Any"/></option>
								<%
                                    for( SiteInfo site : sites )
                                    {
										if(!"AdminSite".equals(site.getName())){
										%>
											<option value='<%=site.getName()%>'><%=site.getName()%></option>
										<%
										}
									}
								%>
                			</select>
				</td><td><BR /></td>
			</tr>
			</tbody>
			<tbody>
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td NOWRAP="NOWRAP" class="form-label-text"><span class="alert-color">*</span><xlat:stream key='dvin/Common/Name'/>:
				</td>
				<td class="form-inset">
                  	   <select NAME="objectname" id="objectname" style="width:220px;" onchange="objectNameSelected(this.value)">
					   </select>
					<A href="#" id="assetBrowse" style="display:none" onclick="if(document.getElementById('sitename').value !=''){OpenPickAssetPopUp(document.getElementById('sitename').value)} else{alert('plese select a site');}return false;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Browse"/></ics:callelement></A>
				</td>
			</tr>
			</tbody>
			<tbody id="objsubtypeRow" style="display:none">
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td NOWRAP="NOWRAP" class="form-label-text"><xlat:stream key='dvin/Common/Subtype'/>:
				</td>
				<td class="form-inset">
						<select name='objectsubtype' style="width=220px;" id="objectsubtype" onchange="objectSubTypeSelected(this.value)">
                        </select>
				</td>
			</tr>
			</tbody>
			<tbody>
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td NOWRAP="NOWRAP" class="form-label-text"><span class="alert-color">*</span><xlat:stream key='dvin/TreeApplet/SecurityGroups'/>:
				</td>
				<td class="form-inset">
                  	   <%if(groups.size() != 0){%>
					   <select id='groups' name='groups' size="5" style="width:220px;" MULTIPLE>
							<%
								for( Group g : groups)
								{
							%>
							<option value='<string:stream value='<%=g.getName()%>'/>'><string:stream value='<%=g.getName()%>'/></option>
							<%
								}
							%>
						</select> 
						<%} else {%>
							<input type="hidden" name="groups" value=""/>
								<xlat:lookup key="dvin/UI/GroupsNotAvailable" varname="_XLAT_" escape="true"/>
							<div class="width-outer-70">
								<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
								<ics:argument name="msgtext" value='<%=ics.GetVar("_XLAT_")%>'/>
								<ics:argument name="severity" value="warning"/>
								</ics:callelement>
							</div>
						<%}%>
				</td>
			</tr>
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td NOWRAP="NOWRAP" class="form-label-text"><span class="alert-color">*</span><xlat:stream key='dvin/UI/Admin/Action'/>:
				</td>
				<td class="form-inset">
                  	   <select name='configaction' id='configaction' size="5" style="width:220px;" ONCLICK="javascript:actionSelected();" MULTIPLE>
                            <%
                            for( ActionEnum ac : actions)
                            {
								%>
								<option value='<%=ac.getName()%>'><%=_showLocaleString(ics,ac.getName())%></option>
								<%
                            }
                            %>
                        </select> 
				</td>
			</tr>
			
				<satellite:link assembler="query" pagename="fatwire/security/SecurityConfigsFront" outstring="urlsecurityconfigs">
					<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
					<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
					<satellite:argument name="cs_imagedir" value='<%=ics.GetVar("cs_imagedir")%>'/>
					<satellite:argument name="action" value="list"/>
				</satellite:link >
				<xlat:lookup key="dvin/UI/Cancel" varname="_status_" escape="true"/>
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/FooterBar" />
		<TR>
			<TD class="form-label-text"></TD><TD class="form-inset">
				
				<A HREF='<%=ics.GetVar("urlsecurityconfigs")%>' onmouseover="window.status='<%=ics.GetVar("_status_")%>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Cancel"/></ics:callelement></A>
				<xlat:lookup key="dvin/UI/AddGroup" varname="_XLAT_" escape="true"/>
				<input type="hidden" name="pagename" value="fatwire/security/SecurityConfigsPost"/> 
				<input type="hidden" name="action" value="add"/>
				<INPUT TYPE="HIDDEN" NAME="pageType" VALUE="post"/>
				<%if(groups.size() != 0){%> 
				
				<A HREF="javascript:void(0);" onClick="if(checkfields()!=false){document.forms['AppForm'].submit(); return false;}" onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Save"/></ics:callelement></A><%}%>
				<P/>
				</TD></TR>
			
			</tbody>
			</table>
	</td></tr>
</table>
<P/><P/>

<%} else if("confirmdelete".equals(ics.GetVar("action"))) {
if(ics.GetVar("objectname") == "_ANY_"){
	ics.SetVar("objectname",_showLocaleString(ics,"_ANY_"));
} 
%>
	<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key="dvin/UI/Admin/DeleteSecurityConfiguration"/></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
	</table>
	<P/>
	<xlat:lookup key="dvin/UI/Common/DeleteConfirm" encode="false" varname="deletemessage"/>
	<div class="width-outer-70">
		<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
			<ics:argument name="msgtext" value='<%=ics.GetVar("deletemessage")%>'/>
			<ics:argument name="severity" value="warning"/>
		</ics:callelement>							
	</div>			
							
	<table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-30">
	<tr><td>
		<table class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td NOWRAP="NOWRAP" class="form-label-text"><xlat:stream key='dvin/UI/Common/Type'/>:
				</td>
				<td class="form-inset">
                  	   <%=_showLocaleString(ics,ics.GetVar("objecttype"))%>
				</td>
			</tr>
			<%if(ics.GetVar("sitename") != null){%>
			<%--<tr><td colspan="3" class="light-line-color"><IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td></tr>--%>		
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td class="form-label-text"><xlat:stream key="dvin/Common/Site"/>:
				</td>
				<td class="form-inset">
						<string:stream variable="sitename"/>
				</td><td><BR /></td>
			</tr>
			<%}
			if(ics.GetVar("objectsubtype") != null){%>
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td NOWRAP="NOWRAP" class="form-label-text"><xlat:stream key='dvin/Common/Subtype'/>:
				</td>
				<td class="form-inset">
                  	   <string:stream variable="objectsubtype"/>
				</td>
			</tr>
			<%}%>
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td NOWRAP="NOWRAP" class="form-label-text"><xlat:stream key='dvin/Common/Name'/>:
				</td>
				<td class="form-inset">
                  	   <string:stream variable="objectname"/>
				</td>
			</tr>
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td NOWRAP="NOWRAP" class="form-label-text"><xlat:stream key='dvin/TreeApplet/SecurityGroups'/>:
				</td>
				<td class="form-inset">
						<ics:getvar name="groups" encoding="default"/>
                </td>
			</tr>
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td NOWRAP="NOWRAP" class="form-label-text"><xlat:stream key='dvin/UI/Admin/Action'/>:
				</td>
				<td class="form-inset">
                  	   <%=_showLocaleString(ics,ics.GetVar("configaction"))%>
				</td>
			</tr>
			</table>
	</td></tr>
</table>


<INPUT TYPE="HIDDEN" NAME="pagename" VALUE="fatwire/security/SecurityConfigsPost"/>
<INPUT TYPE="HIDDEN" NAME="action" VALUE="delete"/>
<%if(ics.GetVar("sitename") != null){%>
<INPUT TYPE="HIDDEN" NAME="sitename" VALUE="<string:stream value='<%=ics.GetVar("sitename")%>'/>"/>
<%}%>
<INPUT TYPE="HIDDEN" NAME="objecttype" VALUE="<string:stream value='<%=ics.GetVar("objecttype")%>'/>"/>
<%if(ics.GetVar("objectsubtype") != null){%>
<INPUT TYPE="HIDDEN" NAME="objectsubtype" VALUE="<string:stream value='<%=ics.GetVar("objectsubtype")%>'/>"/>
<%}%>
<INPUT TYPE="HIDDEN" NAME="objectname" VALUE="<string:stream value='<%=ics.GetVar("objectname")%>'/>"/>
<INPUT TYPE="HIDDEN" NAME="groups" VALUE="<string:stream value='<%=ics.GetVar("groups")%>'/>"/>
<INPUT TYPE="HIDDEN" NAME="configaction" VALUE="<string:stream value='<%=ics.GetVar("configaction")%>'/>"/>
	<satellite:link assembler="query" pagename="fatwire/security/SecurityConfigsFront" outstring="urlsecurityconfigs">
		<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
		<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
		<satellite:argument name="action" value="list"/>
	</satellite:link >    

<xlat:lookup key="dvin/UI/Cancel" varname="_status_" escape="true"/>
<xlat:lookup key="dvin/UI/Cancel" varname="_ALT_"/>
<div class="width-outer-70">	
<A HREF='<%=ics.GetVar("urlsecurityconfigs")%>' onmouseover="window.status='<%=ics.GetVar("_status_")%>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Cancel"/></ics:callelement></A>
<xlat:lookup key="dvin/Common/Delete" varname="_XLAT_" escape="true"/>
<xlat:lookup key="dvin/Common/Delete" varname="_ALT_"/>
<A HREF="javascript:void(0);" onclick="document.forms['AppForm'].submit(); return false;" onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Delete"/></ics:callelement></A>
</div>
<%} else if("edit".equals(ics.GetVar("action"))){
if(ics.GetVar("objectname") == "_ANY_"){
	ics.SetVar("objectname",_showLocaleString(ics,"_ANY_"));
} 
List<Group> groups = gm.list();
//Sort the groups
Collections.sort(groups,new GroupNameComparator());
List<String> usergroups = Arrays.asList(ics.GetVar("groups").split( "," ));
%>
<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key="dvin/UI/Admin/EditSecurityConfiguration"/></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>
<table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-30">
	<tr><td>
		<table class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td NOWRAP="NOWRAP" class="form-label-text"><span class="alert-color">*</span><xlat:stream key='dvin/UI/Common/Type'/>:
				</td>
				<td class="form-inset">
                  	   <%=_showLocaleString(ics,ics.GetVar("objecttype"))%>
				</td>
			</tr>
			<%if(ics.GetVar("sitename") != null){%>
			<%--<tr><td colspan="3" class="light-line-color"><IMG WIDTH="1" HEIGHT="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td></tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td class="form-label-text"><xlat:stream key="dvin/Common/Site"/>:
				</td>
				<td class="form-inset">
						<string:stream variable="sitename"/>
				</td><td><BR /></td>
			</tr>
			<%}
			if(ics.GetVar("objectsubtype") != null){%>
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
			</tr>--%>
			
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td NOWRAP="NOWRAP" class="form-label-text"><xlat:stream key='dvin/Common/Subtype'/>:
				</td>
				<td class="form-inset">
                  	   <string:stream variable="objectsubtype"/>
				</td>
			</tr>
			<%}%>
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td NOWRAP="NOWRAP" class="form-label-text"><span class="alert-color">*</span><xlat:stream key='dvin/Common/Name'/>:
				</td>
				<td class="form-inset">
                  	   <string:stream variable="objectname"/>
				</td>
			</tr>
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td NOWRAP="NOWRAP" class="form-label-text"><span class="alert-color">*</span><xlat:stream key='dvin/TreeApplet/SecurityGroups'/>:
				</td>
				<td class="form-inset">
                  	   <select name='groups' MULTIPLE>
                                <%
                                    for(Group group:groups)
									{
									String grp = group.getName();
									if(usergroups.contains("&#39;" + grp + "&#39;")){
                                %>
                			    <option value='<%=grp%>' selected><%=grp%></option>
                                <%
                                  }else{%>
								<option value='<%=grp%>'><%=grp%></option>
								  <%}
								 }
                                %>
                			</select> 
				</td>
			</tr>
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td NOWRAP="NOWRAP" class="form-label-text"><span class="alert-color">*</span><xlat:stream key='dvin/UI/Admin/Action'/>:
				</td>
				<td class="form-inset">
                  	   <%=_showLocaleString(ics,ics.GetVar("configaction"))%>
				</td>
			</tr>
			</table>
	</td></tr>
</table>
<INPUT TYPE="HIDDEN" NAME="pagename" VALUE="fatwire/security/SecurityConfigsPost"/>                
<INPUT TYPE="HIDDEN" NAME="action" VALUE="edit"/>
<%if(ics.GetVar("sitename") != null){%>
<INPUT TYPE="HIDDEN" NAME="sitename" VALUE="<string:stream value='<%=ics.GetVar("sitename")%>'/>"/>
<%}%>
<INPUT TYPE="HIDDEN" NAME="objecttype" VALUE="<string:stream value='<%=ics.GetVar("objecttype")%>'/>"/>
<%if(ics.GetVar("objectsubtype") != null){%>
<INPUT TYPE="HIDDEN" NAME="objectsubtype" VALUE="<string:stream value='<%=ics.GetVar("objectsubtype")%>'/>"/>
<%}%>
<INPUT TYPE="HIDDEN" NAME="objectname" VALUE="<string:stream value='<%=ics.GetVar("objectname")%>'/>"/>
<INPUT TYPE="HIDDEN" NAME="configaction" VALUE="<string:stream value='<%=ics.GetVar("configaction")%>'/>"/>
<satellite:link assembler="query" pagename="fatwire/security/SecurityConfigsFront" outstring="urlsecurityconfigs">
		<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
		<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
		<satellite:argument name="action" value="list"/>
	</satellite:link >    

<xlat:lookup key="dvin/UI/Cancel" varname="_status_" escape="true"/>
<xlat:lookup key="dvin/UI/Cancel" varname="_ALT_"/>
<div class="width-outer-70">
<A HREF='<%=ics.GetVar("urlsecurityconfigs")%>' onmouseover="window.status='<%=ics.GetVar("_status_")%>';return true;" onmouseout="window.status='<%=ics.GetVar("_XLAT_")%>';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Cancel"/></ics:callelement></A>
<xlat:lookup key="dvin/UI/Save" varname="_XLAT_" escape="true"/>
<xlat:lookup key="dvin/UI/Save" varname="_ALT_"/>
<A HREF="javascript:void(0);" onClick="if(checkGroups()!=false){document.forms['AppForm'].submit(); return false;}" onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true;"><ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TextButton"><ics:argument name="buttonkey" value="UI/Forms/Save"/></ics:callelement></A>
</div>
<%} else if("inspect".equals(ics.GetVar("action"))){
	if(ics.GetVar("objectname") == "_ANY_"){
		ics.SetVar("objectname",_showLocaleString(ics,"_ANY_"));
	} 	
%>
<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
	<tr><td>
		<span class="title-text"><xlat:stream key="dvin/UI/Admin/SecurityConfiguration"/> : <string:stream variable="objectname"/></span>
	</td></tr>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/TitleBar"/>
</table>
<table BORDER="0" CELLSPACING="0" CELLPADDING="0" class="width-outer-30 margin-top-zero">
	<tr><td>
		<table class="width-inner-100" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
			<tr>
				<td colspan="3" class="form-label-text"><table border="0" cellpadding="0" cellspacing="0" class="legacyAbar">
				<tr>

	    <!-- construct encoded urls -->
            <ics:encode base="ContentServer" session="true" output="inspect">
                <ics:argument name="pagename" value="fatwire/security/SecurityConfigsFront"/>
                <ics:argument name="action" value="inspect"/>
				<%if(ics.GetVar("sitename") != null){%>
                <ics:argument name="sitename" value='<%=ics.GetVar("sitename")%>'/>
				<%}%>
				<ics:argument name="objecttype" value='<%=ics.GetVar("objecttype")%>'/>
				<%if(ics.GetVar("objectsubtype") != null){%>
				<ics:argument name="objectsubtype" value='<%=ics.GetVar("objectsubtype")%>'/>
				<%}%>
				<ics:argument name="objectname" value='<%=ics.GetVar("objectname")%>'/>
				<ics:argument name="groups" value='<%=ics.GetVar("groups")%>'/>
				<ics:argument name="configaction" value='<%=ics.GetVar("configaction")%>'/>
            </ics:encode>
            <ics:encode base="ContentServer" session="true" output="edit">
                <ics:argument name="pagename" value="fatwire/security/SecurityConfigsFront"/>
                <ics:argument name="action" value="edit"/>
                <%if(ics.GetVar("sitename") != null){%>
                <ics:argument name="sitename" value='<%=ics.GetVar("sitename")%>'/>
				<%}%>
				<ics:argument name="objecttype" value='<%=ics.GetVar("objecttype")%>'/>
				<%if(ics.GetVar("objectsubtype") != null){%>
				<ics:argument name="objectsubtype" value='<%=ics.GetVar("objectsubtype")%>'/>
				<%}%>
				<ics:argument name="objectname" value='<%=ics.GetVar("objectname")%>'/>
				<ics:argument name="groups" value='<%=ics.GetVar("groups")%>'/>
				<ics:argument name="configaction" value='<%=ics.GetVar("configaction")%>'/>
            </ics:encode>
            <ics:encode base="ContentServer" session="true" output="delete">
                <ics:argument name="pagename" value="fatwire/security/SecurityConfigsFront"/>
                <ics:argument name="action" value="confirmdelete"/>
                <%if(ics.GetVar("sitename") != null){%>
                <ics:argument name="sitename" value='<%=ics.GetVar("sitename")%>'/>
				<%}%>
				<ics:argument name="objecttype" value='<%=ics.GetVar("objecttype")%>'/>
				<%if(ics.GetVar("objectsubtype") != null){%>
				<ics:argument name="objectsubtype" value='<%=ics.GetVar("objectsubtype")%>'/>
				<%}%>
				<ics:argument name="objectname" value='<%=ics.GetVar("objectname")%>'/>
				<ics:argument name="groups" value='<%=ics.GetVar("groups")%>'/>
				<ics:argument name="configaction" value='<%=ics.GetVar("configaction")%>'/>
            </ics:encode>

					<td><xlat:lookup key="dvin/Common/Inspect" varname="_XLAT_" escape="true"/>
					<xlat:lookup key="dvin/UI/Admin/InspectThisConfig" varname="_alt_"/>
					<A HREF='<%=ics.GetVar("inspect")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><img height="14" width="14" hspace="2" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconInspectContentUp.gif'  border="0" title='<%=ics.GetVar("_alt_")%>' alt='<%=ics.GetVar("_alt_")%>'/></A></td>
					<td>
					<A HREF='<%=ics.GetVar("inspect")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><span class="action-text"><xlat:stream key="dvin/Common/Inspect"/></span></A></td>
<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><xlat:lookup key="dvin/Common/Edit" varname="_XLAT_" escape="true"/>
					<xlat:lookup key="dvin/UI/Admin/EditThisConfig" varname="_alt_"/>
					<A HREF='<%=ics.GetVar("edit")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><img height="14" width="14" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconEditContentUp.gif" hspace="2" border="0" title='<%=ics.GetVar("_alt_")%>' alt='<%=ics.GetVar("_alt_")%>'/></A></td>
					<td>
					<A HREF='<%=ics.GetVar("edit")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><span class="action-text"><xlat:stream key="dvin/Common/Edit"/></span></A></td>

	<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>

					<td><xlat:lookup key="dvin/Common/Delete" varname="_XLAT_" escape="true"/>
					<xlat:lookup key="dvin/UI/Admin/DeleteThisConfig" varname="_alt_"/>
					<A HREF='<%=ics.GetVar("delete")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><img height="14" width="14" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/iconDeleteContentUp.gif" hspace="2" border="0" title='<%=ics.GetVar("_alt_")%>' alt='<%=ics.GetVar("_alt_")%>'/></A></td>
					<td>
					<A HREF='<%=ics.GetVar("delete")%>' onmouseover="window.status='<%=ics.GetVar("_XLAT_")%>';return true;" onmouseout="window.status='';return true"><span class="action-text"><xlat:stream key="dvin/Common/Delete"/></span></A></td>
<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>
</table>
				</td>
			</tr></table>
			<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff">
			<%--<tr>
				<td colspan="2" class="light-line-color"><img height="1" width="1" src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif"/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td NOWRAP="NOWRAP" class="form-label-text"><xlat:stream key='dvin/UI/Common/Type'/>:
				</td>
				<td class="form-inset">
                  	   <%=_showLocaleString(ics,ics.GetVar("objecttype"))%>
				</td>
			</tr>
			<%if(ics.GetVar("sitename") != null){%>
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td class="form-label-text"><xlat:stream key="dvin/Common/Site"/>:
				</td>
				<td class="form-inset">
						<string:stream variable="sitename"/>
				</td><td><BR /></td>
			</tr>
			<%}
			if(ics.GetVar("objectsubype") != null){%>
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td  class="form-label-text"><xlat:stream key='dvin/Common/Subtype'/>:
				</td>
				<td class="form-inset">
                  	   <string:stream variable="objectsubtype"/>
				</td>
			</tr>
			<%}%>
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td NOWRAP="NOWRAP" class="form-label-text"><xlat:stream key='dvin/Common/Name'/>:
				</td>
				<td class="form-inset">
                  	   <string:stream variable="objectname"/>
				</td>
			</tr>
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td NOWRAP="NOWRAP" class="form-label-text"><xlat:stream key='dvin/TreeApplet/SecurityGroups'/>:
				</td>
				<td class="form-inset">
                  	   <ics:getvar name="groups" encoding="default"/>
				</td>
			</tr>
			<%--<tr>
				<td colspan="3" class="light-line-color"><img height="1" width="1" src='<%=ics.GetVar("cs_imagedir")%>/graphics/common/screen/dotclear.gif'/></td>
			</tr>--%>
			<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer"/>
			<tr>
				<td NOWRAP="NOWRAP" class="form-label-text"><xlat:stream key='dvin/UI/Admin/Action'/>:
				</td>
				<td class="form-inset">
                  	   <%=_showLocaleString(ics,ics.GetVar("configaction"))%>
				</td>
			</tr>
			</table>
	</td></tr>
</table>
    <satellite:link assembler="query" pagename="fatwire/security/SecurityConfigsFront" outstring="urlsecurityconfigs">
		<satellite:argument name="cs_environment" value='<%=ics.GetVar("cs_environment")%>'/>
		<satellite:argument name="cs_formmode" value='<%=ics.GetVar("cs_formmode")%>'/>
		<satellite:argument name="action" value="list"/>
	</satellite:link >   
<DIV class="width-outer-70"><A HREF='<%=ics.GetVar("urlsecurityconfigs")%>'><IMG src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/doubleArrow.gif" WIDTH="15" HEIGHT="12" BORDER="0"/><xlat:stream key="dvin/UI/Admin/Listallsecurityconfigs"/></A>
</DIV><P/>
<%}
} else {
//Not authorized
%>
<xlat:lookup key="dvin/UI/Error/notallowedtoviewpage" encode="false" varname="msg"/>
<div class="width-outer-70">
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
	<ics:argument name="msgtext" value='<%=ics.GetVar("msg")%>'/>
	<ics:argument name="severity" value="error"/>
</ics:callelement>
</div>
<%}%>
<%!
public String _toCommaString(List<String> groups)
    {
        boolean needComma = false;
        StringBuilder sb = new StringBuilder();
        for( String group: groups)
        {
            if ( needComma )
            {
                sb.append(",");
            }
            else
            {
                needComma = true;
            }
            sb.append("'").append(group).append("'");
        }
        return sb.toString();
    }
	//Server side access for fetching locale strings
public String _showLocaleString(ICS ics,String str){
	if("_ANY_".equals(str)){
		return Util.xlatLookup(ics,"dvin/UI/Any");
	} else if("SITE".equals(str)){
		return Util.xlatLookup(ics,"dvin/Common/Site");
	} else if("USER".equals(str)){
		return Util.xlatLookup(ics,"dvin/Common/User");
	} else if("GROUP".equals(str)){
		return Util.xlatLookup(ics,"dvin/UI/Admin/Group");
	} else if("ROLE".equals(str)){
		return Util.xlatLookup(ics,"dvin/Common/Role");
	} else if("INDEX".equals(str)){
		return Util.xlatLookup(ics,"dvin/UI/Admin/Index");
	} else if("ASSET".equals(str)){
		return Util.xlatLookup(ics,"dvin/UI/Asset");
	} else if("ASSETTYPE".equals(str)){
		return Util.xlatLookup(ics,"dvin/UI/AssetTypenospace");
	} else if("APPLICATION".equals(str)){
		return Util.xlatLookup(ics,"dvin/Common/Application");
	} else if("USERLOCALES".equals(str)){
		return Util.xlatLookup(ics,"dvin/UI/UserLocales");
	} else if("USERDEF".equals(str)){
		return Util.xlatLookup(ics,"dvin/UI/UserDef");
	} else if("ACL".equals(str)){
		return Util.xlatLookup(ics,"dvin/UI/ACLs");
	} else if("CREATE".equals(str)){
		return Util.xlatLookup(ics,"dvin/Common/Create");
	} else if("UPDATE".equals(str)){
		return Util.xlatLookup(ics,"dvin/UI/Update");
	} else if("DELETE".equals(str)){
		return Util.xlatLookup(ics,"dvin/Common/Delete");
	} else if("READ".equals(str)){
		return Util.xlatLookup(ics,"dvin/Common/ReadOrHead");
	} else if("LIST".equals(str)){
		return Util.xlatLookup(ics,"dvin/Common/List");
	}else if("ENGAGE".equals(str)){
		return "Engage";
	}else if("VISITOR".equals(str)){
		return "Visitor";
	}
	return null;
}
%>
<div id="ajaxLoading" style="width:200px;height:100px;position:absolute; top: 350px; display:none; left: 320px;" bgcolor="white">
<table width="100%" height="100%" cellspacing="0" cellpadding="0" bgcolor="#ffffff" align="center" style="border: 1px solid rgb(204,204,204);">
<tbody>
<tr>
<td valign="middle" align="center">
<img src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/wait_ax.gif"/>
<br/>
<br/>
<b>
<span id="loadingMsg"><xlat:stream key="dvin/UI/Loading"/></span>
<img src="<%=ics.GetVar("cs_imagedir")%>/graphics/common/icon/short_Progress.gif"/>
</b>
<a id="hider2" style="cursor: pointer; text-decoration: underline;"/>
</td>
</tr>
</tbody>
</table>
</div>
<%!
public class ObjectTypeComparator implements Comparator {
	public int compare(Object obj1, Object obj2) {
		Map<String,Object> map1 = (Map<String,Object>)obj1;
		Map<String,Object> map2 = (Map<String,Object>)obj2;
		String objtype1 = ((String)map1.get("objecttype")).toLowerCase();
		String objtype2 = ((String)map2.get("objecttype")).toLowerCase();
		objtype1 = (objtype1 == null)? ""  : objtype1;
		objtype2 = (objtype2 == null)? ""  : objtype2;
		return objtype1.compareTo(objtype2);
	}
}

public class ObjectNameComparator implements Comparator {
	public int compare(Object obj1, Object obj2) {
		Map<String,Object> map1 = (Map<String,Object>)obj1;
		Map<String,Object> map2 = (Map<String,Object>)obj2;
		String objname1 = ((String)map1.get("objectname")).toLowerCase();
		String objname2 = ((String)map2.get("objectname")).toLowerCase();
		objname1 = (objname1 == null)? ""  : objname1;
		objname2 = (objname2 == null)? ""  : objname2;
		return objname1.compareTo(objname2);
	}
}

public class SiteComparator implements Comparator {
	public int compare(Object obj1, Object obj2) {
		Map<String,Object> map1 = (Map<String,Object>)obj1;
		Map<String,Object> map2 = (Map<String,Object>)obj2;
		String site1 = ((String)map1.get("site")).toLowerCase();
		String site2 = ((String)map2.get("site")).toLowerCase();
		site1 = (site1 == null)? ""  : site1;
		site2 = (site2 == null)? ""  : site2;

		return site1.compareTo(site2);
	}
}

public class ActionComparator implements Comparator {
	public int compare(Object obj1, Object obj2) {
		Map<String,Object> map1 = (Map<String,Object>)obj1;
		Map<String,Object> map2 = (Map<String,Object>)obj2;
		ActionEnum action1 = (ActionEnum)map1.get("action");
		ActionEnum action2 = (ActionEnum)map2.get("action");

		return (action1.getName()).compareTo(action2.getName());
	}
}

private class GroupNameComparator implements Comparator {
  public int compare(Object group, Object anotherGroup) {
    String desc1 = (((Group) group).getDescription()).toLowerCase();
    String name1 = (((Group) group).getName()).toLowerCase();
    String desc2 = (((Group) anotherGroup).getDescription()).toLowerCase();
    String name2 = (((Group) anotherGroup).getName()).toLowerCase();
    desc1 = (desc1 == null)? ""  : desc1;
	name1 = (name1 == null)? ""  : name1;
	desc2 = (desc2 == null)? ""  : desc2;
	name2 = (name2 == null)? ""  : name2;
	if (!(name1.equals(name2)))
      return name1.compareTo(name2);
    else
      return desc1.compareTo(desc2);
  }
}

private class ActionEnumComparator implements Comparator {
  public int compare(Object action, Object anotherAction) {
    String name1 = (((ActionEnum) action).getName()).toLowerCase();
    String name2 = (((ActionEnum) anotherAction).getName()).toLowerCase();
    name1 = (name1 == null)? ""  : name1;
	name2 = (name2 == null)? ""  : name2;
	return name1.compareTo(name2);
  }
}

private class ObjectTypeEnumComparator implements Comparator {
  public int compare(Object oType, Object anotherOType) {
    String name1 = (((CSObjectTypeEnum) oType).getName()).toLowerCase();
    String name2 = (((CSObjectTypeEnum) anotherOType).getName()).toLowerCase();
	name1 = (name1 == null)? ""  : name1;
	name2 = (name2 == null)? ""  : name2;
    return name1.compareTo(name2);
  }
}

private class SiteInfoComparator implements Comparator {
  public int compare(Object siteinfo, Object anothersiteinfo) {
    String desc1 = (((SiteInfo) siteinfo).getDescription()).toLowerCase();
    String name1 = (((SiteInfo) siteinfo).getName()).toLowerCase();
    String desc2 = (((SiteInfo) anothersiteinfo).getDescription()).toLowerCase();
    String name2 = (((SiteInfo) anothersiteinfo).getName()).toLowerCase();
	desc1 = (desc1 == null)? ""  : desc1;
	name1 = (name1 == null)? ""  : name1;
	desc2 = (desc2 == null)? ""  : desc2;
	name2 = (name2 == null)? ""  : name2;
    if (!(name1.equals(name2)))
      return name1.compareTo(name2);
    else
      return desc1.compareTo(desc2);
  }
}
%>
  </cs:ftcs>