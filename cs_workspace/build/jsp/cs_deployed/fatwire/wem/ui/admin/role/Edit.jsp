<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%//
// fatwire/wem/ui/admin/role/Edit
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
<script type="text/javascript">
preprocess = function(){
	if(AdminUIManager.submitResp){
		AdminUIManager.showMessage(AdminUIManager.submitResp);
	}
	//Reset the object
	AdminUIManager.submitResp = null;
};

postprocess = function() {
  //first update the editObj with the values
  AdminUIManager.mapForm('mainform',AdminUIManager.editObj,false,AdminUIManager.formNamespace);
 };
 </script>
<%--- Adding this temporarily --%>
<ics:setvar name="cspath" value="../../../../.."/>
   <ics:callelement element="fatwire/wem/ui/admin/Heading"> 
      <xlat:lookup key="fatwire/wem/admin/role/edit/Heading" varname="_XLAT_"/>
	  <ics:argument name="Heading:title" value='<%=ics.GetVar("_XLAT_")%>'/>
</ics:callelement>
<input type="hidden" id="pageId" value="role/Edit"/>
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

     <xlat:lookup key="fatwire/wem/admin/role/edit/EditUserRole" varname="_XLAT_"/>
	 <div class="fieldset"><%=ics.GetVar("_XLAT_").toUpperCase()%></div>

     <div class="row">
      <!-- label should be a separate tag and can not include UIInput inside cause of CSS -->
      <label><xlat:stream key="fatwire/wem/admin/common/fields/Name"/></label>
      <div dojoType="fw.dijit.UIInput" name="wem:AdminUI.name" disabled="true"></div>
     </div>

     <div class="row">
      <label><span class="required">*</span> <xlat:stream key="fatwire/wem/admin/common/fields/Description"/></label>
	  <div dojoType="fw.dijit.UITextarea" style="width:400px;height:75px;" required="true" name="wem:AdminUI.description" maxLength="255"></div>
     </div>

     
     <div class="clear"></div>
     <div class="buttonsrow">
      <label>&nbsp;</label>
	   <button id="btnSaveAndClose" dojoType="fw.ui.dijit.Button" buttonType="OK wemButtonStyle" buttonStyle="grey" onClick="AdminUIManager.submitForm(dojo.byId('mainform')['wem:AdminUI.name'].value,'role/Browse')">
		<xlat:stream  key='fatwire/wem/admin/common/actions/SaveAndClose'/>
	  </button>
      <span style="top:0;" id="btnSave" dojoType="fw.dijit.UIActionLink"
       onClick="AdminUIManager.submitForm(dojo.byId('mainform')['wem:AdminUI.name'].value,'role/Browse',false);"
       ><xlat:stream key="fatwire/wem/admin/common/actions/Save"/></span>
	   <span style="top:0;" onclick="AdminUIManager.loadPage('role/Browse','prev');" class="button"><xlat:stream key="fatwire/wem/admin/common/actions/Cancel"/></span>
     </div>

   </div><%--end of UIForm--%>
   <%--</form>--%></div>

   <ics:callelement element="fatwire/wem/ui/admin/Description"> 
      <xlat:lookup key="fatwire/wem/admin/role/edit/DescriptionTitle" varname="_XLAT_"/>
      <ics:argument name="Description:heading" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <xlat:lookup key="fatwire/wem/admin/role/edit/DescriptionBody" varname="_XLAT_" encode="false"/>
	  <ics:argument name="Description:description" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <ics:argument name="Description:image" value="gears"/>
</ics:callelement>
   <div class="clear"></div>

</cs:ftcs>
