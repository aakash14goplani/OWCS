<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%--
fatwire/wem/ui/admin/site/AssignApps
--%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="java.net.URLEncoder" %>

<cs:ftcs>

<script type="text/javascript">
populate = function(obj) {
	var appstable = dijit.byId('UITable');
	//TODO: restructure this in case fetch is already completed first?
	var conn = dojo.connect(appstable, 'onInitialFormatComplete',
		function() {
			if (obj.tablePageNum) {
				appstable.gotoPage(parseInt(obj.tablePageNum, 10));
				dojo.byId('tablePageNum').value = obj.tablePageNum;
			}
			if (obj.tableRowIndex) {
				appstable.select(obj.tableRowIndex);
				dojo.byId('tableRowIndex').value = obj.tableRowIndex;
			}
			dojo.disconnect(conn);
		});
	if(AdminUIManager.submitResp){
		AdminUIManager.showMessage(AdminUIManager.submitResp);
	}
	//Reset the object
	AdminUIManager.submitResp = null;
}

preprocess = function(){
	if(AdminUIManager.editObj.description)
		dojo.byId('Heading:subtitle').innerHTML=AdminUIManager.editObj.description;
		
	//compare sizes now and disable add button if necessary
	appsstore.fetch({onBegin: disableAddIfAllAssigned});
	
	//check if anything is already assigned; if not, show message
	approlesstore.fetch({onBegin: showMessageIfNoneAssigned});
}

updateFormFields = function(rowIndex) {
	var appstable = dijit.byId('UITable');
	dojo.byId('tablePageNum').value = appstable.currentPage;
	if(typeof(rowIndex) != 'undefined')
		dojo.byId('tableRowIndex').value = rowIndex;
}

executeOnDelete = function(/*String*/ application){
	
	var applications = AdminUIManager.editObj.applications;
	if(dojo.isArrayLike(applications)){
		
		for(var i=0;i < applications.length;i++){
			if(application == applications[i].application){	
				applications.splice(i,1);
				break;
			}
		}
			//if there are no applications then delete the property from the editObj
		if(applications.length === 0){
			delete AdminUIManager.editObj.applications;
		}
		
	} else {
		delete AdminUIManager.editObj.applications;
	}
}

//create stores used on this and subsequent pages
//rather than re-querying REST, use fragment of editObj for table on this page
//For new site there would be no applications(Rare case since there will always be system applications even for the new site) so assign the empty array by default
var obj = [];
if(AdminUIManager.editObj.applications){
	obj = AdminUIManager.editObj.applications;
	if (!dojo.isArrayLike(obj))
		obj = [obj];
}
approlesstore = new dojo.data.ItemFileReadStore({data: {
	identifier: 'application',
	items: (obj ? dojo.clone(obj) : [])
}});
//store used to check whether to disable Add button, and used by Add page
appsstore = new fw.data.cs.ClientRestStore({ resource: 'applications' });
</script>

<%-- contents of container div (TODO: only put form div in here) --%>
<ics:setvar name="cspath" value="../../../../.."/>
<ics:callelement element="fatwire/wem/ui/admin/Heading"> 
      <xlat:lookup key="fatwire/wem/admin/site/assignApps/Heading" varname="_XLAT_"/>
      <ics:argument name="Heading:title" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <ics:argument name="Heading:subtitle" value=''/>
</ics:callelement>
<%-- Include the delete confirmation box--%>
<ics:callelement element="fatwire/wem/ui/admin/DeleteConfirm">
	  <xlat:lookup key="fatwire/wem/admin/site/assignApps/Delete" varname="_XLAT_"/>
      <ics:argument name="fw:adminUI:deleteConfMsg" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <ics:argument name="fw:adminUI:element" value='<%="site/AssignApps?fw:adminUI:identifier=" + URLEncoder.encode(ics.GetVar("fw:adminUI:identifier"),"UTF-8")%>'/>
	  <ics:argument name="fw:adminUI:deleteType" value='deleteByEdit'/>
</ics:callelement>
<%-- TODO: form onsubmit --%>
<input type="hidden" id="pageId" value="site/AssignApps"/>
<div class="form"><div dojoType="fw.dijit.UIForm" id="mainform">
<div id="msg"></div>
 <span class="overtablebtns">
  <button id="btnAdd" dojoType="fw.ui.dijit.Button" buttonStyle="grey" buttonType="Continue wemButtonStyle" onClick="updateFormFields();AdminUIManager.loadPage('site/AddApp?fw:adminUI:identifier=<string:stream value='<%=ics.GetVar("fw:adminUI:identifier")%>'/>','next');">
		<xlat:stream  key='fatwire/wem/button/AssignApps'/>
   </button>	
 </span>
<xlat:lookup key="fatwire/wem/admin/common/AppName" varname="_XLAT_"  escape="true"/>
 <table dojoType="fw.dijit.UITable" autoHeight="true" id="UITable"
  store="approlesstore" rowsPerPage="5" searchAttr="application"
  sortByOptions="{'<%=ics.GetVar("_XLAT_")%>':'application'}" sort="application">
  <thead><tr>
	<xlat:lookup key="fatwire/wem/admin/common/AppName" varname="_XLAT_"/>
   <th width="30%" field="application" formatter="formatBold"><%=ics.GetVar("_XLAT_").toUpperCase()%></th>
   <xlat:lookup key="fatwire/wem/admin/common/Roles" varname="_XLAT_"/>   
   <th width="70%" field="roles" formatter="formatRoles"><%=ics.GetVar("_XLAT_").toUpperCase()%></th>
  </tr></thead>
 </table>
 <div style="display:none" id="UITable_popup">
  <div class="UITablePopupTri"></div>
  <div class="UITablePopupContent">
   <div class="lshadow"></div>
   <div class="rshadow"></div>
   <div class="bshadow"></div>
   <div class="blshadow"></div>
   <div class="brshadow"></div>
   <div class="UITablePopupMenu">
	<a class="UITableAssign" href="javascript:updateFormFields($(rowIndex));AdminUIManager.continueForm('AssignRoles?fw:adminUI:identifier=<string:stream value='<%=ics.GetVar("fw:adminUI:identifier")%>'/>&fw:adminUI:submitPage=site/AssignApps&fw:adminUI:application=$(_ID_)');"><xlat:stream key="fatwire/wem/admin/site/assignRolesToApp"/></a>
    <a class="UITableDelete" href="javascript:AdminUIManager.confirmDelete('$(_ID_)');"><xlat:stream key="fatwire/wem/admin/common/actions/Remove"/></a>
   </div>
  </div>
 </div>
<input type="hidden" id="tableRowsPerPage" name="tableRowsPerPage" value=""/>
 <input type="hidden" id="tableRowIndex" name="tableRowIndex" value=""/>
 <input type="hidden" id="tablePageNum" name="tablePageNum" value=""/>
</div></div>
<%-- TODO: finalize and localize note text --%>
<ics:callelement element="fatwire/wem/ui/admin/Description"> 
	<xlat:lookup key="fatwire/wem/admin/site/assignApps/DescriptionTitle" varname="_XLAT_"/>
	<ics:argument name="Description:heading" value='<%=ics.GetVar("_XLAT_")%>'/>
	<xlat:lookup key="fatwire/wem/admin/site/assignApps/DescriptionBody" encode="false" varname="_XLAT_"/>
	<ics:argument name="Description:description" value='<%=ics.GetVar("_XLAT_")%>'/>
	<ics:argument name="Description:image" value="gears"/>
</ics:callelement>
<div style="clear: both"></div>
</cs:ftcs>



