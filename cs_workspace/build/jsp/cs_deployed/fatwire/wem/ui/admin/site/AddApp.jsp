<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%//
// fatwire/wem/ui/admin/site/AddApp
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<cs:ftcs>
 <script type="text/javascript">
  populate = function(obj) {
	dijit.byId('addApp_TransferBox').set('selectedItems', obj.addApp_TransferBox);
  };
  
  preprocess = function() {
	//we need to disable continue button until something is selected in transfer box
	//[KGF] this is now done by validation widgets
	//disableContinueIfNoneSelected(dijit.byId('addApp_TransferBox'));
	if(AdminUIManager.editObj.description)
		dojo.byId('Heading:subtitle').innerHTML=AdminUIManager.editObj.description;

	//Nothing to preprocess if there are no applications for the site(Rare case since there will always be system applications even for the new site) 
	if(typeof(AdminUIManager.editObj.applications) != 'undefined'){
		var excludedValues = new Array();
		if(typeof(AdminUIManager.editObj.applications) != 'undefined'){
		if(!dojo.isArrayLike(AdminUIManager.editObj.applications)) {
			excludedValues[0] = AdminUIManager.editObj.applications.application;
		} else {
			for(var i=0;i<AdminUIManager.editObj.applications.length;i++){
				if(AdminUIManager.editObj.applications[i]._newRoles)
					continue;
				excludedValues[i] = AdminUIManager.editObj.applications[i].application;
			}
		}
		dijit.byId('addApp_TransferBox').set('excludedValues',excludedValues);
		}
	}
  };
  
  postprocess = function() {
  //first update the editObj with the values
  AdminUIManager.mapForm('mainform',AdminUIManager.editObj,false,AdminUIManager.formNamespace);
 
  //Now format the obj as required by the rest service.
    var applications = dijit.byId('addApp_TransferBox').get('value');
	var applicationObj = new Array();
	for(var i=0;i<applications.length;i++){
		var obj = new Object();
		obj.application=applications[i];
		obj.roles=new Array();
		obj._newRoles=true;
		applicationObj[i] = obj;
	}
	if(typeof(AdminUIManager.editObj.applications) != 'undefined'){
		if(!dojo.isArrayLike(AdminUIManager.editObj.applications)) {
			applicationObj[applicationObj.length] = AdminUIManager.editObj.applications;
		} else {
			for(var i=0,j=applicationObj.length;i<AdminUIManager.editObj.applications.length;i++,j++){
				applicationObj[j] = AdminUIManager.editObj.applications[i];
			}
		}
	}
	if(applicationObj.length > 0)
		AdminUIManager.editObj._temp=applicationObj;
  };
 </script>
			<ics:setvar name="cspath" value="../../../../.."/>
			<ics:callelement element="fatwire/wem/ui/admin/Heading">
				<xlat:lookup key="fatwire/wem/admin/site/addApp/Heading" varname="_XLAT_"/>
				<ics:argument name="Heading:title" value='<%=ics.GetVar("_XLAT_")%>'/>
				<ics:argument name="Heading:subtitle" value=''/>
			</ics:callelement>
			
			<input type="hidden" id="pageId" value="site/AddApp"/>
	<div class="form"><div dojoType="fw.dijit.UIForm" id="mainform">
			<div class="fieldset"></div>
			<xlat:lookup key="fatwire/wem/admin/common/Available" varname="_XLAT_1"/>
			<xlat:lookup key="fatwire/wem/admin/common/Selected" varname="_XLAT_2"/>	
			<div class="row">
			<select dojotype="fw.dijit.UITransferBox"
			 id="addApp_TransferBox" name="addApp_TransferBox" required="true"
			 size="10" store="appsstore" storeStructure="{title:'name',value:'name'}"
			 title1='<%=ics.GetVar("_XLAT_1")%>' title2='<%=ics.GetVar("_XLAT_2")%>'>
			</select>
			</div>
			<div class="clear"></div>
			<div class="buttonsrow">
			<button id="btnContinue" dojoType="fw.ui.dijit.Button" buttonType="Continue wemButtonStyle" buttonStyle="grey" onClick="dijit.byId('addApp_TransferBox').selectAll();AdminUIManager.continueForm('AssignRoles?fw:adminUI:identifier=<%=ics.GetVar("fw:adminUI:identifier")%>&fw:adminUI:submitPage=site/AssignApps');">
			 <xlat:stream  key='fatwire/wem/admin/common/actions/Continue'/>
			 </button>
			 <span class="button" style="top:0;" onclick="dijit.byId('addApp_TransferBox').selectAll();AdminUIManager.loadPage('site/AssignApps?fw:adminUI:identifier=<%=ics.GetVar("fw:adminUI:identifier")%>','prev');"><xlat:stream key="fatwire/wem/admin/common/actions/Cancel"/></span>
			</div>
			</div><%--end of UIForm--%>
  </div>

			<ics:callelement element="fatwire/wem/ui/admin/Description">
				<xlat:lookup key="fatwire/wem/admin/site/addApp/DescriptionTitle" varname="_XLAT_"/>
				<ics:argument name="Description:heading" value='<%=ics.GetVar("_XLAT_")%>'/>
				<xlat:lookup key="fatwire/wem/admin/site/addApp/DescriptionBody" encode="false" varname="_XLAT_"/>
				<ics:argument name="Description:description" value='<%=ics.GetVar("_XLAT_")%>'/>
				<ics:argument name="Description:image" value="gears"/>
			</ics:callelement>
			<div class="clear"></div>

</cs:ftcs>
