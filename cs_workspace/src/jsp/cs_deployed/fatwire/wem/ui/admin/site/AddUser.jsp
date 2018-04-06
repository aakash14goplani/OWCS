<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// fatwire/wem/ui/admin/site/AddUser
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<cs:ftcs>
<string:encode variable="fw:adminUI:identifier" varname="fw:adminUI:identifier"/>
 <script type="text/javascript">
  populate = function(obj) {
	dijit.byId('addUser_TransferBox').set('selectedItems', obj.addUser_TransferBox);
  };
  
  preprocess = function() {
	//we need to disable continue button until something is selected in transfer box 
	//[KGF] this is now handled by validation widgets
	//disableContinueIfNoneSelected(dijit.byId('addUser_TransferBox'));
	if(AdminUIManager.editObj.description)
		dojo.byId('Heading:subtitle').innerHTML=AdminUIManager.editObj.description;

	//Nothing to preprocess if there are no users for the site
    if(typeof(AdminUIManager.editObj.siteUsers) != 'undefined' && typeof(AdminUIManager.editObj.siteUsers.user) != 'undefined'){
		var excludedValues = new Array();
		if(!dojo.isArrayLike(AdminUIManager.editObj.siteUsers.user)) {
			excludedValues[0] = AdminUIManager.editObj.siteUsers.user.name;
		} else {
			for(var i=0;i<AdminUIManager.editObj.siteUsers.user.length;i++){
				if(AdminUIManager.editObj.siteUsers.user[i]._newRoles)
					continue;
				excludedValues[i] = AdminUIManager.editObj.siteUsers.user[i].name;
			}
		}
		dijit.byId('addUser_TransferBox').set('excludedValues',excludedValues);
	}
  };
  
  postprocess = function() {
  //first update the editObj with the values
  AdminUIManager.mapForm('mainform',AdminUIManager.editObj,false,AdminUIManager.formNamespace);
 
  //Now format the obj as required by the rest service.
    var users = dijit.byId('addUser_TransferBox').get('value');
	var userObj = new Array();
	for(var i=0;i<users.length;i++){
		var obj = new Object();
		obj.name=users[i];
		obj.roles=new Array();
		obj._newRoles=true;
		userObj[i] = obj;
	}
	if(typeof(AdminUIManager.editObj.siteUsers) != 'undefined' && typeof(AdminUIManager.editObj.siteUsers.user) != 'undefined'){
		if(!dojo.isArrayLike(AdminUIManager.editObj.siteUsers.user)) {
			userObj[userObj.length] = AdminUIManager.editObj.siteUsers.user
		} else {
			for(var i=0,j=userObj.length;i<AdminUIManager.editObj.siteUsers.user.length;i++,j++){
				userObj[j] = AdminUIManager.editObj.siteUsers.user[i];
			}
		}
	}
	if(userObj.length > 0)
		AdminUIManager.editObj._temp=userObj;
  };
 </script>
			<ics:setvar name="cspath" value="../../../../.."/>
			<ics:callelement element="fatwire/wem/ui/admin/Heading">
				<xlat:lookup key="fatwire/wem/admin/site/addUser/Heading" varname="_XLAT_"/>
				<ics:argument name="Heading:title" value='<%=ics.GetVar("_XLAT_")%>'/>
				<ics:argument name="Heading:subtitle" value=''/>
			</ics:callelement>
			
			<input type="hidden" id="pageId" value="site/AddUser"/>
	<div class="form"><div dojoType="fw.dijit.UIForm" id="mainform">
			<div class="fieldset"></div>
			<xlat:lookup key="fatwire/wem/admin/common/Available" varname="_XLAT_1"/>
			<xlat:lookup key="fatwire/wem/admin/common/Selected" varname="_XLAT_2"/>	
			<div class="row">
			<select dojotype="fw.dijit.UITransferBox"
       id="addUser_TransferBox" name="addUser_TransferBox" required="true"
       size="10" store="usersstore" storeStructure="{title:'name',value:'name'}"
       title1='<%=ics.GetVar("_XLAT_1")%>' title2='<%=ics.GetVar("_XLAT_2")%>'>
			</select>
			</div>
			<div class="clear"></div>
			<div class="buttonsrow">
			 <button id="btnContinue" dojoType="fw.ui.dijit.Button" buttonType="Continue wemButtonStyle" buttonStyle="grey" onClick="dijit.byId('addUser_TransferBox').selectAll();AdminUIManager.continueForm('AssignRoles?fw:adminUI:identifier=<%=ics.GetVar("fw:adminUI:identifier")%>&fw:adminUI:submitPage=site/AssignUsers');">
			 <xlat:stream  key='fatwire/wem/admin/common/actions/Continue'/>
			 </button>
			 <span style="top:0;" class="button" onclick="dijit.byId('addUser_TransferBox').selectAll();AdminUIManager.loadPage('site/AssignUsers?fw:adminUI:identifier=<%=ics.GetVar("fw:adminUI:identifier")%>','prev');"><xlat:stream key="fatwire/wem/admin/common/actions/Cancel"/></span>
			</div>
			</div><%--end of UIForm--%>
	</div>

			<ics:callelement element="fatwire/wem/ui/admin/Description">
				<xlat:lookup key="fatwire/wem/admin/site/addUser/DescriptionTitle" varname="_XLAT_"/>
				<ics:argument name="Description:heading" value='<%=ics.GetVar("_XLAT_")%>'/>
				<xlat:lookup key="fatwire/wem/admin/site/addUser/DescriptionBody" encode="false" varname="_XLAT_"/>
				<ics:argument name="Description:description" value='<%=ics.GetVar("_XLAT_")%>'/>
				<ics:argument name="Description:image" value="gears"/>
			</ics:callelement>
			<div class="clear"></div>

</cs:ftcs>
