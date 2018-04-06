<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%--
fatwire/wem/ui/admin/app/AssignSites
--%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="java.net.URLEncoder" %>
<cs:ftcs>

<script type="text/javascript">
populate = function(obj) {
	var sitestable = dijit.byId('UITable');
	//TODO: restructure this in case fetch is already completed first?
	var conn = dojo.connect(sitestable, 'onInitialFormatComplete',
		function() {
			if (obj.tablePageNum) {
				sitestable.gotoPage(parseInt(obj.tablePageNum, 10));
				dojo.byId('tablePageNum').value = obj.tablePageNum;
			}
			if (obj.tableRowIndex) {
				sitestable.select(obj.tableRowIndex);
				dojo.byId('tableRowIndex').value = obj.tableRowIndex;
			}
			dojo.disconnect(conn);
		});
	if(AdminUIManager.submitResp){
		AdminUIManager.showMessage(AdminUIManager.submitResp);
	}
	//Reset the object
	AdminUIManager.submitResp = null;
};

preprocess = function(){
	if(AdminUIManager.editObj.description)
		dojo.byId('Heading:subtitle').innerHTML=AdminUIManager.editObj.description;
		//TODO: else fall back to name? (description isn't required)
	
	//compare sizes now and disable add button if necessary
	sitesstore.fetch({onComplete: disableAddSiteIfAllAssigned});
	
	//check if anything is already assigned; if not, show message
	siterolesstore.fetch({onBegin: showMessageIfNoneAssigned});
};

updateFormFields = function(rowIndex) {
	var sitestable = dijit.byId('UITable');
	dojo.byId('tablePageNum').value = sitestable.currentPage;
	if(typeof(rowIndex) != 'undefined')
		dojo.byId('tableRowIndex').value = rowIndex;
};

executeOnDelete = function(/*String*/ site){
	var sites = AdminUIManager.editObj.sites;
	if(dojo.isArrayLike(sites)){
		for(var i=0;i < sites.length;i++){
			if(site == sites[i].site){
				sites.splice(i,1);
				break;
			}
		}
		//if there are no sites then delete the property from the editObj
		if(sites.length === 0){
			delete AdminUIManager.editObj.sites;
		}
	} else {
		delete AdminUIManager.editObj.sites;
	}
};

//create stores used on this and subsequent pages
//rather than re-querying REST, use fragment of editObj for table on this page
var obj = [];
if (AdminUIManager.editObj.sites) {
	obj = AdminUIManager.editObj.sites;
	if (obj && !dojo.isArrayLike(obj))
		obj = [obj]; //uncollapse arrays (thanks Jersey...)
}
siterolesstore = new dojo.data.ItemFileReadStore({data: {
	identifier: 'site',
	items: dojo.clone(obj)
}});

//store used to check whether to disable Add button, and used by Add page
sitesstore = new fw.data.cs.ClientRestStore({ resource: 'adminsites' });
</script>

<%-- contents of container div (TODO: only put form div in here) --%>
<ics:setvar name="cspath" value="../../../../.."/>
<ics:callelement element="fatwire/wem/ui/admin/Heading"> 
      <xlat:lookup key="fatwire/wem/admin/app/assignSites/Heading" varname="_XLAT_"/>
      <ics:argument name="Heading:title" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <ics:argument name="Heading:subtitle" value='<%=ics.GetVar("fw:adminUI:identifier")%>'/>
</ics:callelement>
<%-- Include the delete confirmation box--%>
<ics:callelement element="fatwire/wem/ui/admin/DeleteConfirm">
	  <xlat:lookup key="fatwire/wem/admin/app/assignSites/Delete" varname="_XLAT_"/>
      <ics:argument name="fw:adminUI:deleteConfMsg" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <ics:argument name="fw:adminUI:element" value='<%="app/AssignSites?fw:adminUI:identifier=" + URLEncoder.encode(ics.GetVar("fw:adminUI:identifier"),"UTF-8")%>'/>
	  <ics:argument name="fw:adminUI:deleteType" value='deleteByEdit'/>
</ics:callelement>
<%-- TODO: form onsubmit --%>
<input type="hidden" id="pageId" value="app/AssignSites"/>
<div class="form"><div dojoType="fw.dijit.UIForm" id="mainform">
<div id="msg"></div>
 <span class="overtablebtns">
	<button id="btnAdd" dojoType="fw.ui.dijit.Button" buttonStyle="grey" buttonType="Add wemButtonStyle" onClick="updateFormFields();AdminUIManager.loadPage('app/AddSite?fw:adminUI:identifier=<string:stream value='<%=ics.GetVar("fw:adminUI:identifier")%>'/>','next');">
		<xlat:stream  key='fatwire/wem/button/AssigntoSites'/>
   </button>
  </span>
<xlat:lookup key="fatwire/wem/admin/common/SiteName" varname="_XLAT_"  escape="true"/>
 <table dojoType="fw.dijit.UITable" autoHeight="true" id="UITable"
  store="siterolesstore" rowsPerPage="5" searchAttr="site"
  sortByOptions="{'<%=ics.GetVar("_XLAT_")%>':'site'}" sort="site">
  <thead><tr>
	<xlat:lookup key="fatwire/wem/admin/common/SiteName" varname="_XLAT_"/>
   <th width="30%" field="site" formatter="formatBold"><%=ics.GetVar("_XLAT_").toUpperCase()%></th>
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
	<a class="UITableAssign" href="javascript:updateFormFields($(rowIndex));AdminUIManager.continueForm('AssignRoles?fw:adminUI:identifier=<string:stream value='<%=ics.GetVar("fw:adminUI:identifier")%>'/>&fw:adminUI:submitPage=app/AssignSites&fw:adminUI:site=$(_ID_)');"><xlat:stream key="fatwire/wem/admin/app/assignSites/assignRolesToApp"/></a>
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
	<xlat:lookup key="fatwire/wem/admin/app/assignSites/DescriptionTitle" varname="_XLAT_"/>
	<ics:argument name="Description:heading" value='<%=ics.GetVar("_XLAT_")%>'/>
	<xlat:lookup key="fatwire/wem/admin/app/assignSites/DescriptionBody" encode="false" varname="_XLAT_"/>
	<ics:argument name="Description:description" value='<%=ics.GetVar("_XLAT_")%>'/>
	<ics:argument name="Description:image" value="gears"/>
</ics:callelement>
<div style="clear: both"></div>
</cs:ftcs>



