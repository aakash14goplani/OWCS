<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%//
// fatwire/wem/ui/admin/user/Edit
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
<%@ page import="oracle.fatwire.sites.timezone.util.TimeZoneUtil"%>
<cs:ftcs>
<ics:setvar name="cspath" value="../../../../.."/>
<script type="text/javascript">
dojo.require("fw.ui.dojox.data.CSItemFileWriteStore");
 postprocess = function() {
  //first update the editObj with the values
  AdminUIManager.mapForm('mainform',AdminUIManager.editObj,false,AdminUIManager.formNamespace);
  AdminUIManager.editObj.otherAttributes = [];
  var j = 0;
  for(var prop in AdminUIManager.editObj._tempOtherAttributes){
		var obj = new Object();
		obj.name = prop;
		obj.value = AdminUIManager.editObj._tempOtherAttributes[prop];
		AdminUIManager.editObj.otherAttributes[j]=obj;
		j++;
	}
	delete AdminUIManager.editObj._tempOtherAttributes;
	//If there is no other attributes in the user dont send the empty array to the server
	if(AdminUIManager.editObj.otherAttributes.length == 0){
		delete AdminUIManager.editObj.otherAttributes;
	}
  //Remove the empty array if there was no group selected
  if(dijit.byId("selectGroups_TransferBox").get("value").length == 0){
	delete AdminUIManager.editObj.groups;
  }
  if(dojo.byId('wem:AdminUI:imagesrc').value != '-1'){
	AdminUIManager.editObj['imagesrc'] = dojo.byId('wem:AdminUI:imagesrc').value;
  }
 };
 
 preprocess = function() {
	//Call the initialize method from the image uploader to initialize it
	initializeUploader();
	if(AdminUIManager.editObj.thumbimagesrc){
		if (dojo.isIE < 9) {
			elementsImageReplacement.hasRequiredFlashVersion();
			elementsImageReplacement.display(AdminUIManager.editObj.thumbimagesrc.substring(AdminUIManager.editObj.thumbimagesrc.indexOf(',')+1),"profileImgDiv",90,90);
		} else {
			changeDivImage(AdminUIManager.editObj.thumbimagesrc);
		}
		dijit.byId('hRemove').set('disabled',false);
	}
	if(AdminUIManager.submitResp){
		AdminUIManager.showMessage(AdminUIManager.submitResp);
	}
	//Reset the object
	AdminUIManager.submitResp = null;
	AdminUIManager.addOtherAttributes();
	//Since addOtherAttribute will set the name field as required which is any way a non editable field here lets set requiured to false
	dijit.byId('wem:AdminUI.name').set('required',false);
	dojo.destroy('req_name');
	//Also set the password field as not required 
	dijit.byId('wem:AdminUI.password').set('required',false);
	dijit.byId('wem:AdminUI.password').set('value', '');
	dojo.destroy('req_password');
	//force re-validation of confirmPwd field after removing required
	//attribute of password (its "otherfield")
	dijit.byId('wem:AdminUI.confirmPwd').validate();
	
	//Now populate the appropriate values
	if(typeof(AdminUIManager.editObj.otherAttributes) != 'undefined'){
		for(var i=0;i < AdminUIManager.editObj.otherAttributes.length;i++){
			var oAttr = AdminUIManager.editObj.otherAttributes[i];
			dijit.byId('wem:AdminUI._tempOtherAttributes.' + oAttr.name).set('value',oAttr.value);
		}
	}
 }
 </script>
<%--- Adding this temporarily --%>
<ics:callelement element="fatwire/wem/ui/admin/Heading">
	<xlat:lookup key="fatwire/wem/admin/user/edit/Heading" varname="_XLAT_"/>
	<ics:argument name="Heading:title" value='<%=ics.GetVar("_XLAT_")%>'/>
</ics:callelement>
<input type="hidden" id="pageId" value="user/Edit"/>
   <div class="form">
   <div id="msg"></div>
	<xlat:lookup key="fatwire/wem/admin/user/edit/UserImage" varname="_XLAT_"/>
     <div class="fieldset"><%=ics.GetVar("_XLAT_").toUpperCase()%></div>
	  <ics:callelement element="fatwire/wem/ui/admin/user/ImageUpload"/>
		
    <div dojoType="fw.dijit.UIForm" id="mainform">
	<input type="hidden" id="wem:AdminUI:imagesrc" value="-1"/>
    <!-- All possible warning boxes see fw.dijit.UIForm.showMessage() to display them
		<div class="infobox"><b>Did you know!</b> You have a chance to win a million dollars if you fill out the form correctly?</div>
		<div class="errorbox"><b>Error!</b> You have committed a fatal error.</div>
		<div class="successbox"><b>Success!</b> You have successfully accomplished your task.</div>
		<div class="warningbox"><b>Warning!</b> If you proceed, you will not be able to complete this form.</div>
	-->
    <p></p>
	<xlat:lookup key="fatwire/wem/admin/user/edit/UserData" varname="_XLAT_"/>
     <div class="fieldset"><%=ics.GetVar("_XLAT_").toUpperCase()%></div>

     <div class="row">
      <!-- label should be a separate tag and can not include UIInput inside cause of CSS -->
	  <xlat:lookup key="fatwire/wem/admin/common/fields/Name" varname="_XLAT_" escape="true"/>
      <label><ics:getvar name="_XLAT_"/></label>
      <div dojoType="fw.dijit.UIInput" name="wem:AdminUI.name" id="wem:AdminUI.name" disabled="true"></div>
     </div>
	 
	 <!-- bug 14403558: for LDAP install certain fields on user profile screen are not supported -->
	 <ics:getproperty name="cs.manageUser" file="futuretense.ini" output="cs_manageuser"/>
	 <%	
	 String isLdap =""; 
	 if(!ics.GetVar("cs_manageuser").equals(""))
	 {
		 isLdap="disabled=disabled";
	 } 
	 %>
	 
     <div class="row">
	  <xlat:lookup key="fatwire/wem/admin/common/fields/Email" varname="_XLAT_" escape="true"/>
      <label><ics:getvar name="_XLAT_"/></label>
      <div dojoType="fw.dijit.UIInput" regExp="[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}" trim="true" id="wem:AdminUI.email" name="wem:AdminUI.email" <%=isLdap%>></div>
     </div>

     <div class="row">
	  <xlat:lookup key="fatwire/wem/admin/common/fields/Locale" varname="_XLAT_" escape="true"/>
      <label><ics:getvar name="_XLAT_"/></label>
   <div dojoType="fw.data.cs.ClientRestStore" resource="userlocales" jsId="localesstore"></div>
      <select id="wem:AdminUI.locale" name="wem:AdminUI.locale" required="false" dojoType="fw.dijit.UIFilteringSelect" store="localesstore" searchAttr="description" <%=isLdap%>>
      </select>
     </div>
	<%
	String json = "{ \"identifier\": \"id\", \"items\": [" + TimeZoneUtil.listTimeZones(ics.GetSSVar("locale")).replaceAll("'","&#39;") + "]}";
	%>
	<div class="row">
	  <xlat:lookup key="dvin/Common/TimeZone" varname="_XLAT_" escape="true"/>
      <label><ics:getvar name="_XLAT_"/></label>
   <div dojoType="fw.ui.dojox.data.CSItemFileWriteStore" jsId="timezonesstore" data='<%=json%>'></div>
      <select id="wem:AdminUI.timezone" name="wem:AdminUI.timezone" required="false" dojoType="fw.dijit.UIFilteringSelect" store="timezonesstore" searchAttr="name" <%=isLdap%>>
      </select>     
     </div> 
	
	<div class="row">
   <label style="padding-top: 33px;">
	  <xlat:stream key="fatwire/wem/admin/common/fields/ACLs"/></label>
   <div dojoType="fw.data.cs.ClientRestStore" resource="acls" jsId="aclsstore"></div>
	<xlat:lookup key="fatwire/wem/admin/common/Available" varname="_XLAT_1"/>
	<xlat:lookup key="fatwire/wem/admin/common/Selected" varname="_XLAT_2"/>
   <select dojotype="fw.dijit.UITransferBox" style="padding-top: 10px;"
    id="wem:AdminUI.acls" name="wem:AdminUI.acls" size="10"
    store="aclsstore" storeStructure="{title:'name',value:'name'}"
    title1='<%=ics.GetVar("_XLAT_1")%>' title2='<%=ics.GetVar("_XLAT_2")%>'>
   </select>
   </div>
   <div class="row">
   <label style="padding-top: 33px;">
	  <xlat:stream key="fatwire/wem/admin/common/fields/Groups"/></label>
   <div dojoType="fw.data.cs.ClientRestStore" resource="groups" jsId="groupsstore"></div>
	<xlat:lookup key="fatwire/wem/admin/common/Available" varname="_XLAT_1"/>
	<xlat:lookup key="fatwire/wem/admin/common/Selected" varname="_XLAT_2"/>
   <select dojotype="fw.dijit.UITransferBox" style="padding-top: 10px;"
    id="selectGroups_TransferBox" name="wem:AdminUI.groups" size="10"
    store="groupsstore" storeStructure="{title:'name',value:'name'}"
    title1='<%=ics.GetVar("_XLAT_1")%>' title2='<%=ics.GetVar("_XLAT_2")%>'>
   </select>
   </div>
	<xlat:lookup key="fatwire/wem/admin/common/fields/Password" varname="_XLAT_"/>
     <div class="fieldset"><%=ics.GetVar("_XLAT_").toUpperCase()%></div>

	 
     <div class="row">
      <label><xlat:stream key="fatwire/wem/admin/common/fields/NewPassword"/></label>
      <div dojoType="fw.dijit.UIInput" id="wem:AdminUI.password" name="wem:AdminUI.password" type="password" onInput="dijit.byId('wem:AdminUI.confirmPwd').validate(false);"></div>
     </div>

     <div class="row">
      <label><xlat:stream key="fatwire/wem/admin/common/fields/ConfirmPassword"/></label>
	  <xlat:lookup key="fatwire/wem/admin/common/fields/ConfirmPassword" varname="_XLAT_"/>
	  <xlat:lookup key="fatwire/wem/admin/common/error/RequiredField" varname="_XLAT_E"/>
      <div dojoType="fw.dijit.UIInput" id="wem:AdminUI.confirmPwd" name="wem:AdminUI.confirmPwd" type="password" constraints="{'otherField': 'wem:AdminUI.password'}"
    validator="AdminUIManager.matchFieldValues"></div>
<%-- example with error
      <div dojoType="fw.dijit.UIInput" name="confirmPwd" type="password" error='<%=ics.GetVar("_XLAT_E")%>' hideErrorOnActivity="true"></div>
--%>
     </div>

     <div class="clear"></div>
     <div class="buttonsrow">
      <label>&nbsp;</label>
	   <button id="btnSaveAndClose" dojoType="fw.ui.dijit.Button" buttonType="OK wemButtonStyle" buttonStyle="grey" onClick="AdminUIManager.submitForm(dojo.byId('mainform')['wem:AdminUI.name'].value,'user/Browse')">
		<xlat:stream  key='fatwire/wem/admin/common/actions/SaveAndClose'/>
	  </button>
      <span style="top:0;" id="btnSave" dojoType="fw.dijit.UIActionLink"
       onClick="AdminUIManager.submitForm(dojo.byId('mainform')['wem:AdminUI.name'].value,'user/Browse',false);"
       ><xlat:stream key="fatwire/wem/admin/common/actions/Save"/></span>
	   <span style="top:0;" onclick="AdminUIManager.loadPage('user/Browse','prev');" class="button"><xlat:stream key="fatwire/wem/admin/common/actions/Cancel"/></span>
     </div>
   </div><%--end of UIForm--%>
  </div>

	<ics:callelement element="fatwire/wem/ui/admin/Description"> 
		<xlat:lookup key="fatwire/wem/admin/user/edit/DescriptionTitle" varname="_XLAT_"/>
		<ics:argument name="Description:heading" value='<%=ics.GetVar("_XLAT_")%>'/>
		<xlat:lookup key="fatwire/wem/admin/user/edit/DescriptionBody" varname="_XLAT_" encode="false"/>
		<ics:argument name="Description:description" value='<%=ics.GetVar("_XLAT_")%>'/>
		<ics:argument name="Description:image" value="gears"/>
	</ics:callelement>
   <div class="clear"></div>
</cs:ftcs>
