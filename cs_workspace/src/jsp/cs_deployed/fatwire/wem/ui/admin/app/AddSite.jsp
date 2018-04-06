<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%//
// fatwire/wem/ui/admin/app/AddSite
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
    dijit.byId('addSite_TransferBox').set('selectedItems', obj.addSite_TransferBox);
  };
  
  preprocess = function() {
	//we need to disable continue button until something is selected in transfer box 
	//disableContinueIfNoneSelected(dijit.byId('addSite_TransferBox'));
  
	if(AdminUIManager.editObj.description)
		dojo.byId('Heading:subtitle').innerHTML=AdminUIManager.editObj.description;
	if(typeof(AdminUIManager.editObj.sites) != 'undefined'){
		var excludedValues = new Array();
		if(!dojo.isArrayLike(AdminUIManager.editObj.sites)) {
			excludedValues[0] = AdminUIManager.editObj.sites.site;
		} else {
			for(var i=0;i<AdminUIManager.editObj.sites.length;i++){
				if(AdminUIManager.editObj.sites[i]._newRoles)
					continue;
				excludedValues[i] = AdminUIManager.editObj.sites[i].site;
			}
		}
		console.log('Setting excluded values ' + excludedValues);
		dijit.byId('addSite_TransferBox').set('excludedValues',excludedValues);
		}
	};
  
  postprocess = function() {
  //first update the editObj with the values
  AdminUIManager.mapForm('mainform',AdminUIManager.editObj,false,AdminUIManager.formNamespace);
 
  //Now format the obj as required by the rest service.
    var sites = dijit.byId('addSite_TransferBox').get('value');
	console.log('sites',sites);
	var siteObj = new Array();
	for(var i=0;i<sites.length;i++){
		var obj = new Object();
		obj.site=sites[i];
		obj.roles=new Array();
		obj._newRoles=true;
		siteObj[i] = obj;
	}
	
	if(typeof(AdminUIManager.editObj.sites) != 'undefined'){
		if(!dojo.isArrayLike(AdminUIManager.editObj.sites)) {
			siteObj[siteObj.length] = AdminUIManager.editObj.sites
		} else {
			for(var i=0,j=siteObj.length;i<AdminUIManager.editObj.sites.length;i++,j++){
				siteObj[j] = AdminUIManager.editObj.sites[i];
			}
		}
	}
	
	if(siteObj.length > 0)
		AdminUIManager.editObj._temp=siteObj;
  };
 </script>
			<ics:setvar name="cspath" value="../../../../.."/>
			<ics:callelement element="fatwire/wem/ui/admin/Heading">
				<xlat:lookup key="fatwire/wem/admin/app/addSite/Heading" varname="_XLAT_"/>
				<ics:argument name="Heading:title" value='<%=ics.GetVar("_XLAT_")%>'/>
				<ics:argument name="Heading:subtitle" value='<%=ics.GetVar("fw:adminUI:identifier")%>'/>
			</ics:callelement>
			
			<input type="hidden" id="pageId" value="app/AddSite"/>
			<div class="form"><div dojoType="fw.dijit.UIForm" id="mainform">
			<div class="fieldset"></div>
			<xlat:lookup key="fatwire/wem/admin/common/Available" varname="_XLAT_1"/>
			<xlat:lookup key="fatwire/wem/admin/common/Selected" varname="_XLAT_2"/>	
			<div class="row">
			<select dojotype="fw.dijit.UITransferBox" id="addSite_TransferBox" required="true" name="addSite_TransferBox" size="10" store="sitesstore" storeStructure="{title:'name',value:'name'}" title1='<%=ics.GetVar("_XLAT_1")%>' title2='<%=ics.GetVar("_XLAT_2")%>'>
			</select>
			</div>
			<div class="clear"></div>
			<div class="buttonsrow">
			<button id="btnContinue" dojoType="fw.ui.dijit.Button" buttonType="Continue wemButtonStyle" buttonStyle="grey" onClick="dijit.byId('addSite_TransferBox').selectAll();AdminUIManager.continueForm('AssignRoles?fw:adminUI:identifier=<%=ics.GetVar("fw:adminUI:identifier")%>&fw:adminUI:submitPage=app/AssignSites');">
			 <xlat:stream  key='fatwire/wem/admin/common/actions/Continue'/>
			 </button>
			<span class="button" style="top:1px;" onclick="dijit.byId('addSite_TransferBox').selectAll();AdminUIManager.loadPage('app/AssignSites?fw:adminUI:identifier=<%=ics.GetVar("fw:adminUI:identifier")%>','prev');"><xlat:stream key="fatwire/wem/admin/common/actions/Cancel"/></span>
			</div>
			</div><%--end of UIForm--%>
			</div>

			<ics:callelement element="fatwire/wem/ui/admin/Description">
				<xlat:lookup key="fatwire/wem/admin/site/addSite/DescriptionTitle" varname="_XLAT_"/>
				<ics:argument name="Description:heading" value='<%=ics.GetVar("_XLAT_")%>'/>
				<xlat:lookup key="fatwire/wem/admin/site/addSite/DescriptionBody" encode="false" varname="_XLAT_"/>
				<ics:argument name="Description:description" value='<%=ics.GetVar("_XLAT_")%>'/>
				<ics:argument name="Description:image" value="gears"/>
			</ics:callelement>
			<div class="clear"></div>

</cs:ftcs>
