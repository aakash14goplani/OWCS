<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// fatwire/wem/ui/admin/AssignRoles
//
// INPUT
//
// OUTPUT
//%>
<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.net.URLDecoder"%>
<cs:ftcs>
<string:encode variable="fw:adminUI:submitPage" varname="fw:adminUI:submitPage"/>
<string:encode variable="fw:adminUI:site" varname="fw:adminUI:site"/>
<string:encode variable="fw:adminUI:identifier" varname="fw:adminUI:identifier"/>
<%
String submitPage = ics.GetVar("fw:adminUI:submitPage");
String pageType = submitPage.substring(0,submitPage.indexOf('/'));
String pageAssign = submitPage.substring(submitPage.indexOf("Assign") + 6);
%>
<%
// Decode the username to properly handle foreign language character sets 
String _identifier = request.getParameter("fw:adminUI:identifier");
String _adminUIUser = request.getParameter("fw:adminUI:user");
if (null == _adminUIUser) _adminUIUser = "";
%> 
<%--Retrieve the single and the plural title strings --%>
<%if("user/AssignSites".equals(ics.GetVar("fw:adminUI:submitPage")) || "app/AssignSites".equals(ics.GetVar("fw:adminUI:submitPage"))){%>
	<xlat:lookup key='<%="fatwire/wem/admin/" + pageType + "/assignRoles_S/Heading"%>' encode="false" escape="true" varname="pageTitle_S"/>
	<xlat:lookup key='<%="fatwire/wem/admin/" + pageType + "/assignRoles_P/Heading"%>' encode="false" escape="true" varname="pageTitle_P"/>
<%}else{%>
	<xlat:lookup key='<%="fatwire/wem/admin/site/assignRolesTo" + pageAssign+ "_S/Heading"%>' encode="false" escape="true" varname="pageTitle_S"/>
	<xlat:lookup key='<%="fatwire/wem/admin/site/assignRolesTo" + pageAssign+ "_P/Heading"%>' encode="false" escape="true" varname="pageTitle_P"/>
<%}%>
<%if("user/AssignSites".equals(ics.GetVar("fw:adminUI:submitPage")) || "app/AssignSites".equals(ics.GetVar("fw:adminUI:submitPage"))){%>
	<xlat:lookup key='<%="fatwire/wem/admin/" + pageType + "/assigningRoles_S/DescriptionTitle"%>' encode="false" escape="true" varname="pageTitle_SD"/>
	<xlat:lookup key='<%="fatwire/wem/admin/" + pageType + "/assigningRoles_P/DescriptionTitle"%>' encode="false" escape="true" varname="pageTitle_PD"/>
<%}else{%>
	<xlat:lookup key='<%="fatwire/wem/admin/site/assigningRolesTo" + pageAssign+ "_S/DescriptionTitle"%>' encode="false" escape="true" varname="pageTitle_SD"/>
	<xlat:lookup key='<%="fatwire/wem/admin/site/assigningRolesTo" + pageAssign+ "_P/DescriptionTitle"%>' encode="false" escape="true" varname="pageTitle_PD"/>
<%}%>
<script type="text/javascript">
  populate = function(obj) {
	dijit.byId('assignRoles_TransferBox').set('selectedItems', obj.assignRoles_TransferBox);
  };
  
  preprocess=function(){
	//we need to disable "save and close"  and the save button until something is selected in transfer box 
	//[KGF] this is now handled by validation widgets
	//disableSaveIfNoneSelected(dijit.byId('assignRoles_TransferBox'));
	//Remove the general admin role from the transfer box if its site admin
	if(!AdminUIManager._fullAccess)
		dijit.byId('assignRoles_TransferBox').set('excludedValues', ['GeneralAdmin']);
	//Update the title of the page.For the navigation from the root user or the app page the title string is always going to be singular but for site it will be determined based on the choosen users/apps
	if('<%=ics.GetVar("fw:adminUI:submitPage")%>'=='user/AssignSites' || '<%=ics.GetVar("fw:adminUI:submitPage")%>'=='app/AssignSites'){
		dojo.byId('Heading:title').innerHTML= '<%=ics.GetVar("pageTitle_S")%>';
		dojo.byId('Description:heading').innerHTML= '<%=ics.GetVar("pageTitle_SD")%>';
	} else {
		if(AdminUIManager.editObj._temp){
			var counter = 0;
			for(var i=0 ; i < AdminUIManager.editObj._temp.length ; i++){
				var obj = AdminUIManager.editObj._temp[i];
				if(obj._newRoles)
					counter++;
			}
			if(counter == 1){
				dojo.byId('Heading:title').innerHTML= '<%=ics.GetVar("pageTitle_S")%>';
				dojo.byId('Description:heading').innerHTML= '<%=ics.GetVar("pageTitle_SD")%>';
			} else {
				dojo.byId('Heading:title').innerHTML='<%=ics.GetVar("pageTitle_P")%>';
				dojo.byId('Description:heading').innerHTML= '<%=ics.GetVar("pageTitle_PD")%>';
			}
		} else {
			dojo.byId('Heading:title').innerHTML='<%=ics.GetVar("pageTitle_S")%>';
			dojo.byId('Description:heading').innerHTML='<%=ics.GetVar("pageTitle_SD")%>';
		}
	}
	
	if(AdminUIManager.editObj.description){
		dojo.byId('Heading:subtitle').innerHTML=AdminUIManager.editObj.description;
	} else {
		dojo.byId('Heading:subtitle').innerHTML=AdminUIManager.editObj.name;
	}
	dojo.byId('pageId').value='<%=ics.GetVar("fw:adminUI:submitPage")%>'.substring(0,'<%=ics.GetVar("fw:adminUI:submitPage")%>'.indexOf('/')) + "/AssignRoles";
	if('<%=ics.GetVar("fw:adminUI:submitPage")%>'=='user/AssignSites' || '<%=ics.GetVar("fw:adminUI:submitPage")%>'=='app/AssignSites'){
		if(typeof(AdminUIManager.editObj.sites) != 'undefined'){
			if(!dojo.isArrayLike(AdminUIManager.editObj.sites) && AdminUIManager.editObj.sites.site == '<%=ics.GetVar("fw:adminUI:site")%>') {
				var roles = AdminUIManager.editObj.sites.roles;
				dijit.byId("assignRoles_TransferBox").set("selectedItems",roles);
			} else {
				for(var i=0;i<AdminUIManager.editObj.sites.length;i++){
					if(AdminUIManager.editObj.sites[i].site == '<%=ics.GetVar("fw:adminUI:site")%>'){
						var roles = AdminUIManager.editObj.sites[i].roles;
						dijit.byId("assignRoles_TransferBox").set("selectedItems",roles);
					}
				}
			}
		}
	} else if('<%=ics.GetVar("fw:adminUI:submitPage")%>'=='site/AssignUsers'){
		if(typeof(AdminUIManager.editObj.siteUsers) != 'undefined' && typeof(AdminUIManager.editObj.siteUsers.user) != 'undefined'){
			if(!dojo.isArrayLike(AdminUIManager.editObj.siteUsers.user) && AdminUIManager.editObj.siteUsers.user.name == '<%= _adminUIUser %>'){
				var roles = AdminUIManager.editObj.siteUsers.user.roles;
				dijit.byId("assignRoles_TransferBox").set("selectedItems",roles);
			} else {
				for(var i=0;i<AdminUIManager.editObj.siteUsers.user.length;i++){
					if(AdminUIManager.editObj.siteUsers.user[i].name == '<%= _adminUIUser %>'){
						var roles = AdminUIManager.editObj.siteUsers.user[i].roles;
						dijit.byId("assignRoles_TransferBox").set("selectedItems",roles);
					}
				}
			}
		}
	} else if('<%=ics.GetVar("fw:adminUI:submitPage")%>'=='site/AssignApps'){
		if(typeof(AdminUIManager.editObj.applications) != 'undefined'){
			if(!dojo.isArrayLike(AdminUIManager.editObj.applications)  && AdminUIManager.editObj.applications.application == '<%=ics.GetVar("fw:adminUI:application")%>') {
				var roles = AdminUIManager.editObj.applications.roles;
				dijit.byId("assignRoles_TransferBox").set("selectedItems",roles);
			} else {
				for(var i=0;i<AdminUIManager.editObj.applications.length;i++){
					if(AdminUIManager.editObj.applications[i].application == '<%=ics.GetVar("fw:adminUI:application")%>'){
						var roles = AdminUIManager.editObj.applications[i].roles;
						dijit.byId("assignRoles_TransferBox").set("selectedItems",roles);
					}
				}
			}
		}
	}	
  };
  
  postprocess = function() {
  //first update the editObj with the values
  AdminUIManager.mapForm('mainform',AdminUIManager.editObj,false,AdminUIManager.formNamespace);
  
  //Now format the obj as required by the rest service.
    var roles = dijit.byId('assignRoles_TransferBox').get('value');
	var userObj = new Array();
	
	if('<%=ics.GetVar("fw:adminUI:submitPage")%>'=='user/AssignSites' || '<%=ics.GetVar("fw:adminUI:submitPage")%>'=='app/AssignSites'){
		//Restore the temp object
		if(AdminUIManager.editObj._temp)
			AdminUIManager.editObj.sites = AdminUIManager.editObj._temp;
		if(!dojo.isArrayLike(AdminUIManager.editObj.sites)) {
			//Check if the user is site admin and the actual role list contains the GeneralAdmin role then add it back (since it was removed in preprocess) .
			if(!AdminUIManager._fullAccess && dojo.indexOf(AdminUIManager.editObj.sites.roles,'GeneralAdmin') !=-1){
				roles[roles.length]='GeneralAdmin';
			}
			AdminUIManager.editObj.sites.roles = roles;
		} else {
			for(var i=0;i<AdminUIManager.editObj.sites.length;i++){
				if(AdminUIManager.editObj.sites[i]._newRoles){
					//Check if the user is site admin and the actual role list contains the GeneralAdmin role then add it back (since it was removed in preprocess) .
					if(!AdminUIManager._fullAccess && dojo.indexOf(AdminUIManager.editObj.sites[i].roles,'GeneralAdmin') !=-1){
						roles[roles.length]='GeneralAdmin';
					}
					AdminUIManager.editObj.sites[i].roles=roles;
					delete AdminUIManager.editObj.sites[i]._newRoles;
				} else if(AdminUIManager.editObj.sites[i].site == '<%=ics.GetVar("fw:adminUI:site")%>'){
					//Check if the user is site admin and the actual role list contains the GeneralAdmin role then add it back (since it was removed in preprocess) .
					if(!AdminUIManager._fullAccess && dojo.indexOf(AdminUIManager.editObj.sites[i].roles,'GeneralAdmin') !=-1){
						roles[roles.length]='GeneralAdmin';
					}
					AdminUIManager.editObj.sites[i].roles=roles;
				}
			}
		}
	} else if('<%=ics.GetVar("fw:adminUI:submitPage")%>'=='site/AssignUsers'){
		//Restore the temp object
		if(AdminUIManager.editObj._temp){
			AdminUIManager.editObj.siteUsers = {};
			AdminUIManager.editObj.siteUsers.user = AdminUIManager.editObj._temp;
		}
		
		if(typeof(AdminUIManager.editObj.siteUsers) != 'undefined' && typeof(AdminUIManager.editObj.siteUsers.user) != 'undefined'){
			if(!dojo.isArrayLike(AdminUIManager.editObj.siteUsers.user) && AdminUIManager.editObj.siteUsers.user.name == '<%= _adminUIUser %>'){
				//Check if the user is site admin and the actual role list contains the GeneralAdmin role then add it back (since it was removed in preprocess) .
				if(!AdminUIManager._fullAccess && dojo.indexOf(AdminUIManager.editObj.siteUsers.user.roles,'GeneralAdmin') !=-1){
						roles[roles.length]='GeneralAdmin';
				}
				AdminUIManager.editObj.siteUsers.user.roles=roles;
			} else {
				for(var i=0;i<AdminUIManager.editObj.siteUsers.user.length;i++){
					if(AdminUIManager.editObj.siteUsers.user[i]._newRoles){
						//Check if the user is site admin and the actual role list contains the GeneralAdmin role then add it back (since it was removed in preprocess) .
						if(!AdminUIManager._fullAccess && dojo.indexOf(AdminUIManager.editObj.siteUsers.user[i].roles,'GeneralAdmin') !=-1){
							roles[roles.length]='GeneralAdmin';
						}
						AdminUIManager.editObj.siteUsers.user[i].roles=roles;
						delete AdminUIManager.editObj.siteUsers.user[i]._newRoles;
					} else if(AdminUIManager.editObj.siteUsers.user[i].name == '<%= _adminUIUser %>'){
						//Check if the user is site admin and the actual role list contains the GeneralAdmin role then add it back (since it was removed in preprocess) .
						if(!AdminUIManager._fullAccess && dojo.indexOf(AdminUIManager.editObj.siteUsers.user[i].roles,'GeneralAdmin') !=-1){
							roles[roles.length]='GeneralAdmin';
						}
						AdminUIManager.editObj.siteUsers.user[i].roles=roles;
					}
				}
			}
		}
	} else if('<%=ics.GetVar("fw:adminUI:submitPage")%>'=='site/AssignApps'){
		//Restore the temp object
		if(AdminUIManager.editObj._temp)
			AdminUIManager.editObj.applications = AdminUIManager.editObj._temp;
		if(!dojo.isArrayLike(AdminUIManager.editObj.applications)) {
			//Check if the user is site admin and the actual role list contains the GeneralAdmin role then add it back (since it was removed in preprocess) .
			if(!AdminUIManager._fullAccess && dojo.indexOf(AdminUIManager.editObj.applications.roles,'GeneralAdmin') !=-1){
				roles[roles.length]='GeneralAdmin';
			}
			AdminUIManager.editObj.applications.roles=roles;
		} else{
		for(var i=0;i<AdminUIManager.editObj.applications.length;i++){
			if(AdminUIManager.editObj.applications[i]._newRoles){
				//Check if the user is site admin and the actual role list contains the GeneralAdmin role then add it back (since it was removed in preprocess) .
				if(!AdminUIManager._fullAccess && dojo.indexOf(AdminUIManager.editObj.applications[i].roles,'GeneralAdmin') !=-1){
					roles[roles.length]='GeneralAdmin';
				}
				AdminUIManager.editObj.applications[i].roles=roles;
				delete AdminUIManager.editObj.applications[i]._newRoles;
			} else if(AdminUIManager.editObj.applications[i].application == '<%=ics.GetVar("fw:adminUI:application")%>'){
				//Check if the user is site admin and the actual role list contains the GeneralAdmin role then add it back (since it was removed in preprocess) .
				if(!AdminUIManager._fullAccess && dojo.indexOf(AdminUIManager.editObj.applications[i].roles,'GeneralAdmin') !=-1){
					roles[roles.length]='GeneralAdmin';
				}
				AdminUIManager.editObj.applications[i].roles=roles;
			}
		}
		}
	}
	//Clear the temp object before submitting
	if(AdminUIManager.editObj._temp)
		clearTempObject();
};

clearTempObject = function() {
	delete AdminUIManager.editObj._temp;
};
 </script>

<ics:setvar name="cspath" value="../../../../.."/>
	<ics:callelement element="fatwire/wem/ui/admin/Heading">
		<ics:argument name="Heading:title" value=''/>
		<ics:argument name="Heading:subtitle" value=''/>
	</ics:callelement>
   <input type="hidden" id="pageId" value=""/>
   <div class="form"><div dojoType="fw.dijit.UIForm" id="mainform">
   <div id="msg"></div>
   <div class="fieldset"></div>
   <div dojoType="fw.data.cs.ClientRestStore" resource="roles" jsId="rolesstore"></div>
	<xlat:lookup key="fatwire/wem/admin/common/Available" varname="_XLAT_1"/>
	<xlat:lookup key="fatwire/wem/admin/common/Selected" varname="_XLAT_2"/>
	 <div class="row">
    <select dojotype="fw.dijit.UITransferBox"
     id="assignRoles_TransferBox" name="assignRoles_TransferBox" required="true"
     size="10" store="rolesstore" storeStructure="{title:'name',value:'name'}"
     title1='<%=ics.GetVar("_XLAT_1")%>' title2='<%=ics.GetVar("_XLAT_2")%>'>
    </select>
   </div>
   <div class="clear"></div>
   <div class="buttonsrow">
   <%
	//For assigning apps to sites, we need our augmented /wem/sites/{sitename} service, 
	//which has added application awareness.  Due to this, presently all sites modification screens are going through this service.
	//However, for the other site screens (Edit and Assign Users), it should be enough to use the vanilla /sites/{sitename} service, 
	//which doesnt deal with apps, which will increase performance.
   if("site/AssignUsers".equals(ics.GetVar("fw:adminUI:submitPage"))) {
   %> 
		<button id="btnSaveAndClose" dojoType="fw.ui.dijit.Button" buttonType="OK wemButtonStyle" buttonStyle="grey" onClick="AdminUIManager.submitForm(AdminUIManager.editObj.name,'site/AssignUsers?fw:adminUI:identifier=<%=_identifier%>',true,false,'Site');">
		<xlat:stream  key='fatwire/wem/admin/common/actions/SaveAndClose'/>
		</button>
	<%} else {%>
		<button id="btnSaveAndClose" dojoType="fw.ui.dijit.Button" buttonType="OK wemButtonStyle" buttonStyle="grey" onClick="var _xname = encodeURIComponent(AdminUIManager.editObj.name);AdminUIManager.submitForm(AdminUIManager.editObj.name,'<%=ics.GetVar("fw:adminUI:submitPage")%>?fw:adminUI:identifier='+_xname);">
		<xlat:stream  key='fatwire/wem/admin/common/actions/SaveAndClose'/>
		</button>
	<%}%> 
   <span class="button" style="top:0;" onclick="var _yname = encodeURIComponent(AdminUIManager.editObj.name); clearTempObject();AdminUIManager.loadPage('<%=ics.GetVar("fw:adminUI:submitPage")%>?fw:adminUI:identifier='+_yname,'prev');"><xlat:stream key="fatwire/wem/admin/common/actions/Cancel"/></span>
   </div>
   </div><%--end of UIForm--%>
   </div>

   <ics:callelement element="fatwire/wem/ui/admin/Description"> 
				<ics:argument name="Description:heading" value=''/>
				<xlat:lookup key='<%="fatwire/wem/admin/" + pageType + "/assignRolesFor" + pageAssign + "/DescriptionBody"%>' encode="false" varname="_XLAT_"/>
				<ics:argument name="Description:description" value='<%=ics.GetVar("_XLAT_")%>'/>
				<ics:argument name="Description:image" value="gears"/>
			</ics:callelement>
   <div class="clear"></div>

</cs:ftcs>
