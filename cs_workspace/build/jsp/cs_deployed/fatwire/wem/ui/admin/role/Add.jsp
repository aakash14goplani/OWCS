<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%//
// fatwire/wem/ui/admin/role/Add
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

<ics:callelement element="OpenMarket/Xcelerate/Scripts/ValidateInputForXSS">	
</ics:callelement>

<script type="text/javascript">

function checkfields()
{
   var obj = dojo.byId('mainform');
   //Don't allow backslash in role name
   var isclean = isCleanString(obj['wem:AdminUI.name'].value,'\\');
	if (!isclean) {
		alert('<xlat:stream key="dvin/FlexibleAssets/Attributes/ApostropheNotAllowed" escape="true" encode="false"/>');
		return false;
	}
	if ( (obj['wem:AdminUI.name'].value.length == 0) ||
		 (obj['wem:AdminUI.name'].value.match(/^[\s]/) != null) ||
		 (obj['wem:AdminUI.name'].value.substr(obj['wem:AdminUI.name'].value.length - 1) == ' ') ) {
	
	//Here means something is wrong, let us figure out what
	
			if (obj['wem:AdminUI.name'].value.length == 0) {
				
				alert('<xlat:stream key="dvin/UI/Admin/Error/Youmustspecifyanameforthisrole" escape="true" encode="false"/>');
				
			}
			
			if ( obj['wem:AdminUI.name'].value.match(/^[\s]/) != null ) {
				
				alert('<xlat:stream key="dvin/UI/Admin/Error/Rolenamescannotstartwithaspace" escape="true" encode="false"/>');
				
			}
			
			if ( obj['wem:AdminUI.name'].value.substr(obj['wem:AdminUI.name'].value.length - 1) == ' ' ) {
				
				alert('<xlat:stream key="dvin/UI/Admin/Error/Rolenamescannotendwithaspace" escape="true" encode="false"/>');
			
			}
			obj['wem:AdminUI.name'].focus();
			return false;
	}
	if (obj['wem:AdminUI.description'].value=="")
	{
		
		alert('<xlat:stream key="dvin/UI/Admin/Error/mustspecifydescriptionrole" escape="true" encode="false"/>');
		
		obj['wem:AdminUI.description'].focus();
		return false;
	}

	return true;
	
}
 postprocess = function() {
  //first update the editObj with the values
  AdminUIManager.mapForm('mainform',AdminUIManager.editObj,false,AdminUIManager.formNamespace);
 };
 
var submitForm  = function(){
	var urlkey;
	if (checkfields()==false) return flase;
	AdminUIManager.submitForm('0','role/Browse',false,true, urlkey, function(){
		if(typeof(dijit.byId('msg')) ==='undefined' || dijit.byId('msg').type != 'error'){
			AdminUIManager.editForm(dojo.byId('mainform')['wem:AdminUI.name'].value,'role/Edit',false);
		}	
	});	
};
 </script>
<%--- Adding this temporarily --%>
<ics:setvar name="cspath" value="../../../../.."/>
   <ics:callelement element="fatwire/wem/ui/admin/Heading"> 
      <xlat:lookup key="fatwire/wem/admin/role/add/Heading" varname="_XLAT_"/>
	  <ics:argument name="Heading:title" value='<%=ics.GetVar("_XLAT_")%>'/>
</ics:callelement>
<input type="hidden" id="pageId" value="role/Add"/>
   <div class="form"><div dojoType="fw.dijit.UIForm" id="mainform">
<%--<form action="" method="post" id="mainform">--%>
    <!-- All possible warning boxes see fw.dijit.UIForm.showMessage() to display them
     <div class="infobox"><b>Did you know!</b> You have a chance to win a million dollars if you fill out the form correctly?</div>
     <div class="errorbox"><b>Error!</b> You have committed a fatal error.</div>
     <div class="successbox"><b>Success!</b> You have successfully accomplished your task.</div>
     <div class="warningbox"><b>Warning!</b> If you proceed, you will not be able to complete this form.</div>
    -->
     <div id="msg"></div>

<p></p>

     <xlat:lookup key="fatwire/wem/admin/role/add/AddRole" varname="_XLAT_"/>
	 <div class="fieldset"><%=ics.GetVar("_XLAT_").toUpperCase()%></div>

     <div class="row">
      <!-- label should be a separate tag and can not include UIInput inside cause of CSS -->
      <label><span class="required">*</span> <xlat:stream key="fatwire/wem/admin/common/fields/Name"/></label>
      <div dojoType="fw.dijit.UIInput" name="wem:AdminUI.name" required="true" maxLength="32"></div>
     </div>

     <div class="row">
      <label><span class="required">*</span> <xlat:stream key="fatwire/wem/admin/common/fields/Description"/></label>
      <div dojoType="fw.dijit.UITextarea" style="width:400px;height:75px;" required="true" name="wem:AdminUI.description" maxLength="255"></div>
     </div>

     
     <div class="clear"></div>
     <div class="buttonsrow">
      <label>&nbsp;</label>
	  <button id="btnSaveAndClose" dojoType="fw.ui.dijit.Button" buttonType="OK wemButtonStyle" buttonStyle="grey" onClick="if(checkfields()!=false){AdminUIManager.submitForm('0','role/Browse');}">
		<xlat:stream  key='fatwire/wem/admin/common/actions/SaveAndClose'/>
	  </button>
      <span style="top:0;" id="btnSave" dojoType="fw.dijit.UIActionLink"
       onclick="submitForm();"
       ><xlat:stream key="fatwire/wem/admin/common/actions/Save"/></span>
      <span style="top:0;" onclick="AdminUIManager.loadPage('role/Browse','prev');" class="button"><xlat:stream key="fatwire/wem/admin/common/actions/Cancel"/></span>
     </div>

   </div><%--end of UIForm--%>
   <%--</form>--%></div>

   <ics:callelement element="fatwire/wem/ui/admin/Description"> 
      <xlat:lookup key="fatwire/wem/admin/role/add/DescriptionTitle" varname="_XLAT_"/>
      <ics:argument name="Description:heading" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <xlat:lookup key="fatwire/wem/admin/role/add/DescriptionBody" varname="_XLAT_" encode="false"/>
	  <ics:argument name="Description:description" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <ics:argument name="Description:image" value="gears"/>
</ics:callelement>
   <div class="clear"></div>

</cs:ftcs>
