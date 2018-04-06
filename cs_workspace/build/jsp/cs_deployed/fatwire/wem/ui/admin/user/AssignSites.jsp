<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%--
fatwire/wem/ui/admin/user/AssignSites
--%>
<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="java.net.URLEncoder" %>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>

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

preprocess = function() {
	//compare sizes now and disable add button if necessary
	sitesstore.fetch({onComplete: disableAddSiteIfAllAssigned});
	if(AdminUIManager.editObj.name)
			dojo.byId('Heading:subtitle').innerHTML=AdminUIManager.editObj.name;
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
//For new user sites would be empty so assign the empty array by default
var obj = [];
if(AdminUIManager.editObj.sites) {
	obj = AdminUIManager.editObj.sites;
	if (!dojo.isArrayLike(obj))
		obj = [obj];
}
siterolesstore = new dojo.data.ItemFileReadStore({data: {
	identifier: 'site',
	items: (obj ? dojo.clone(obj) : [])
}});

//store used to check whether to disable Add button, and used by Add page
sitesstore = new fw.data.cs.ClientRestStore({ resource: 'adminsites' });
</script>

<%
String _identifier = request.getParameter("fw:adminUI:identifier");
%>
<%-- contents of container div (TODO: only put form div in here) --%>
<ics:setvar name="cspath" value="../../../../.."/>
<ics:callelement element="fatwire/wem/ui/admin/Heading"> 
      <xlat:lookup key="fatwire/wem/admin/user/assignSites/Heading" varname="_XLAT_"/>
      <ics:argument name="Heading:title" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <ics:argument name="Heading:subtitle" value=''/>
</ics:callelement>
<%-- Include the delete confirmation box--%>
<ics:callelement element="fatwire/wem/ui/admin/DeleteConfirm">
	  <xlat:lookup key="fatwire/wem/admin/user/assignSites/Delete" varname="_XLAT_"/>
      <ics:argument name="fw:adminUI:deleteConfMsg" value='<%=ics.GetVar("_XLAT_")%>'/>
  	  <ics:argument name="fw:adminUI:element" value='<%="user/AssignSites?fw:adminUI:identifier=" + URLEncoder.encode(_identifier,"UTF-8")%>'/>
	  <ics:argument name="fw:adminUI:deleteType" value='deleteByEdit'/>
</ics:callelement>
<%-- TODO: form onsubmit --%>
<input type="hidden" id="pageId" value="user/AssignSites"/>
<div class="form"><div dojoType="fw.dijit.UIForm" id="mainform">
<%--<form action="" method="post" id="mainform">--%>
<div id="msg"></div>
 <span class="overtablebtns">
	<button id="btnAdd" dojoType="fw.ui.dijit.Button" buttonStyle="grey" buttonType="Add wemButtonStyle" onClick="updateFormFields();var arf=encodeURIComponent('<%=_identifier%>');AdminUIManager.loadPage('<%="user/AddSite?fw:adminUI:identifier="%>'+arf,'next');">
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
     <a class="UITableAssign" href="javascript:updateFormFields($(rowIndex)); AdminUIManager.continueForm('AssignRoles?fw:adminUI:identifier=<%=_identifier%>&fw:adminUI:submitPage=user/AssignSites&fw:adminUI:site=$(_ID_)');"><xlat:stream key="fatwire/wem/admin/user/assignRoles_S/Heading"/></a>
    <a class="UITableDelete" href="javascript:AdminUIManager.confirmDelete('$(_ID_)');"><xlat:stream key="fatwire/wem/admin/common/actions/Remove"/></a>
   </div>
  </div>
 </div>
<input type="hidden" id="tableRowsPerPage" name="tableRowsPerPage" value=""/>
 <input type="hidden" id="tableRowIndex" name="tableRowIndex" value=""/>
 <input type="hidden" id="tablePageNum" name="tablePageNum" value=""/>
</div><%--end of UIForm--%>
   <%--</form>--%></div>
<%-- TODO: finalize and localize note text --%>
<ics:callelement element="fatwire/wem/ui/admin/Description"> 
	<xlat:lookup key="fatwire/wem/admin/user/assignSites/DescriptionTitle" varname="_XLAT_"/>
	<ics:argument name="Description:heading" value='<%=ics.GetVar("_XLAT_")%>'/>
	<xlat:lookup key="fatwire/wem/admin/user/assignSites/DescriptionBody" varname="_XLAT_" encode="false"/>
	<ics:argument name="Description:description" value='<%=ics.GetVar("_XLAT_")%>'/>
	<ics:argument name="Description:image" value="gears"/>
</ics:callelement>
<div style="clear: both"></div>
</cs:ftcs>



