<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%--
fatwire/wem/ui/EditProfile
--%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="oracle.fatwire.sites.timezone.util.TimeZoneUtil" %>
<cs:ftcs>
 <%-- set relative path to webapp folder once and for all. --%>
<ics:setvar name="cspath" value="../.."/>
	<script type="text/javascript">
		dojo.require("fw.ui.dojox.data.CSItemFileWriteStore");
		//TODO: refactor this to avoid global object creation
		AdminUIManager = dijit.byId('wemtopbar').adminUIManager;

		if(!slscache)
			var slscache = new fw.data.SysLocStrCache();

		postprocess = function() {
		  //first update the editObj with the values
		  AdminUIManager.mapForm('mainform',AdminUIManager.editObj,false,AdminUIManager.formNamespace);
		  if(dojo.byId('wem:AdminUI:imagesrc').value != '-1'){
			AdminUIManager.editObj['imagesrc'] = dojo.byId('wem:AdminUI:imagesrc').value;
		  }
		 };
		 
		 preprocess = function() {
			AdminUIManager.mapForm('mainform', AdminUIManager.editObj, true,
				AdminUIManager.formNamespace);
			dojo.byId('Heading:subtitle').innerHTML=AdminUIManager.editObj.name;
			//Call the initialize method from the image uploader to initialize it
			initializeUploader();
			if(AdminUIManager.editObj.thumbimagesrc){
				if (dojo.isIE < 9) {
					if(!elementsImageReplacement.hasDataUriSupport()) {
						elementsImageReplacement.hasRequiredFlashVersion();
						elementsImageReplacement.display(AdminUIManager.editObj.thumbimagesrc.substring(AdminUIManager.editObj.thumbimagesrc.indexOf(',')+1),"profileImgDiv",90,90);
					}
				} else {
					changeDivImage(AdminUIManager.editObj.thumbimagesrc);
				}
				dijit.byId('hRemove').set('disabled',false);
			}
			dijit.byId('wem:AdminUI.password').set('value', '');
			if (dijit.byId('wem:AdminUI.password').get('value') && dijit.byId('wem:AdminUI.password').get('value').length > 0)  
				dijit.byId('wem:AdminUI.oldpassword').set('required',true); 
			else 
				dijit.byId('wem:AdminUI.oldpassword').set('required',false);
			//Add the action widgets to the form
			var
			mainform = dijit.byId('mainform'),
			widgetIds = ['btnSaveAndClose', 'btnSave'];
			if (mainform) {
				for (var i = 0; i < widgetIds.length; i++) {
					var w = dijit.byId(widgetIds[i]);
					if (w) {
						mainform.addActionWidget(w);
					}
				}
			}
		};
		clearUserPreferences = function() {			
			var xhrArgs = {
					url : dojo.config.fw_csPath + "wem/fatwire/wem/ui/removeUserPreference",
					preventCache: true
			}
			dojo.xhrGet(xhrArgs).then(function() {
				parent.doSignout();
			});			
		};
		
		saveAndCloseAction = function() {
			AdminUIManager.submitForm(dojo.byId('mainform')['wem:AdminUI.name'].value,'user/Edit',false);
			dijit.byId('userEditProfileCP').destroyRecursive(false);
			showHiddenApplication();
		};
		cancelAndCloseAction = function() {
			dijit.byId('userEditProfileCP').destroyRecursive(false);
			showHiddenApplication();
		};
		showHiddenApplication = function() {
			// making visible hidden application
			//	which made hidden to prevent applet bleed-through edit profile page
			if(dojo.some(dojo.query('#wembody > div.wembody'), function(item) {
				if(dojo.style(item, 'visibility') === 'hidden') {
					dojo.style(item, 'visibility', 'visible');
					return true;
				}
			})) {
				console.debug('making visible previous application');
			};
		}
	</script>
 <div dojoType="dijit.layout.BorderContainer" class="mainBorderContainer">
   <div dojoType="dijit.layout.ContentPane" splitter="false" region="top" class="headerContentPane">
    <div class="container">
     <div class="menu">
      <div class="item logoWebCenterSites"></div>
      <div class="item separator"></div>
	  <xlat:lookup key="fatwire/wem/ui/admin/profile/Edit" varname="_XLAT_"/>
      <div class="item logoText"><%=ics.GetVar("_XLAT_")%></div>
      <%-- add clearing div after floats to register region height --%>
      <div style="clear: both">&nbsp;</div>
     </div>
    </div>
   </div>
   <!-- end of menu bar area, start of main area -->
   <div dojoType="dijit.layout.ContentPane" region="center" class="mainContentPane">
    <div class="containerBg">
     <div class="container">
		 <br/>
			<xlat:lookup key="fatwire/wem/ui/admin/profile/Edit" varname="_XLAT_"/>
			<h1 id="Heading:title"><%=ics.GetVar("_XLAT_")%></h1>
			<div style="width:790px;position:relative;">
				<div id="Heading:subtitle" class="subtitle"></div>
				<xlat:lookup key="fatwire/wem/admin/user/edit/ClearUserPreferenceAndLogout"  varname="_XLAT_"/>
				<div style="position:absolute;top:10px;right:0;"><a href="#" onclick="clearUserPreferences();return false;" style="color:#4A91B8;" class="UIActionLink"><%=ics.GetVar("_XLAT_")%></a></div>
			</div>
			<br/><div id="msg"></div><br/>
		 <div class="form" style="margin-right: 110px">
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
			  <div dojoType="fw.dijit.UIInput" name="wem:AdminUI.name" disabled="true"></div>
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
			  <div dojoType="fw.dijit.UIInput" regExp="[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}" trim="true" name="wem:AdminUI.email" <%=isLdap%>></div>
			 </div>

			 <div class="row">
			  <xlat:lookup key="fatwire/wem/admin/common/fields/Locale" varname="_XLAT_" escape="true"/>
			  <label><ics:getvar name="_XLAT_"/></label>
		   <div dojoType="fw.data.cs.ClientRestStore" resource="userlocales" jsId="localesstore"></div>
			  <select id="locale" name="wem:AdminUI.locale" jsId="sites" dojoType="fw.dijit.UIFilteringSelect" required="false" store="localesstore" searchAttr="description" <%=isLdap%>>
			  </select>
			 </div>
			 <%
				String json = "{ \"identifier\": \"id\", \"items\": [" + TimeZoneUtil.listTimeZones(ics.GetSSVar("locale")).replaceAll("'","&#39;") + "]}";
				%>
				<div class="row">
				  <xlat:lookup key="dvin/Common/TimeZone" varname="_XLAT_" escape="true"/>
			      <label><ics:getvar name="_XLAT_"/></label>
			   <div dojoType="fw.ui.dojox.data.CSItemFileWriteStore" jsId="timezonesstore" data='<%=json%>'></div>
			      <select id="wem:AdminUI.timezone" name="wem:AdminUI.timezone" required="false" dojoType="fw.dijit.UIFilteringSelect" store="timezonesstore" searchAttr="name"	<%=isLdap%>>
			      </select>     
			     </div> 
				
			<xlat:lookup key="fatwire/wem/admin/common/fields/Password" varname="_XLAT_"/>
			 <div class="fieldset"><%=ics.GetVar("_XLAT_").toUpperCase()%></div>
			 
			 <div class="row">
			  <label><xlat:stream key="fatwire/admin/common/fields/OldPassword"/></label>
			  <div dojoType="fw.dijit.UIInput" id="wem:AdminUI.oldpassword" name="wem:AdminUI.oldpassword" type="password"></div>
			 </div>
			 
			 <div class="row">
			  <label><xlat:stream key="fatwire/wem/admin/common/fields/NewPassword"/></label>
	<div dojoType="fw.dijit.UIInput" id="wem:AdminUI.password" name="wem:AdminUI.password" type="password" onInput="dijit.byId('wem:AdminUI.confirmPwd').validate(false);if (this.get('value') && this.get('value').length > 0)  dijit.byId('wem:AdminUI.oldpassword').set('required',true); else dijit.byId('wem:AdminUI.oldpassword').set('required',false);"></div>
			 </div>

			 <div class="row">
			  <label><xlat:stream key="fatwire/wem/admin/common/fields/ConfirmPassword"/></label>
			  <xlat:lookup key="fatwire/wem/admin/common/fields/ConfirmPassword" varname="_XLAT_"/>
			  <xlat:lookup key="fatwire/wem/admin/common/error/RequiredField" varname="_XLAT_E"/>
			  <div dojoType="fw.dijit.UIInput" id="wem:AdminUI.confirmPwd" name="wem:AdminUI.confirmPwd" type="password" constraints="{'otherField': 'wem:AdminUI.password'}"
    validator="AdminUIManager.matchFieldValues"></div>
			 </div>
			 <div class="clear"></div>
			 <div class="buttonsrow">
			  <label>&nbsp;</label>	  
	  <button id="btnSaveAndClose" dojoType="fw.ui.dijit.Button" buttonType="OK wemButtonStyle" buttonStyle="grey" onClick="saveAndCloseAction()">
		<xlat:stream  key='fatwire/wem/admin/common/actions/SaveAndClose'/>
	  </button>
      <span id="btnSave" style="top:0;" dojoType="fw.dijit.UIActionLink" onClick="AdminUIManager.submitForm(dojo.byId('mainform')['wem:AdminUI.name'].value,'user/Edit',false);AdminUIManager.showFeedback();">
	  <xlat:stream key="fatwire/wem/admin/common/actions/Save"/></span>
		  <span onclick="cancelAndCloseAction()" style="top:0;" class="button"><xlat:stream key="fatwire/wem/admin/common/actions/Cancel"/></span>
			 </div>
		   </div>
		  </div>
	<ics:callelement element="fatwire/wem/ui/admin/Description"> 
      <xlat:lookup key="fatwire/wem/ui/admin/profile/DescriptionTitle" varname="_XLAT_"/>
      <ics:argument name="Description:heading" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <xlat:lookup key="fatwire/wem/ui/admin/profile/DescriptionBody" varname="_XLAT_" encode="false"/>
	  <ics:argument name="Description:description" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <ics:argument name="Description:image" value="gears"/>
</ics:callelement>
   <div class="clear"></div>
	</div>
   </div>
  </div>
 </cs:ftcs>