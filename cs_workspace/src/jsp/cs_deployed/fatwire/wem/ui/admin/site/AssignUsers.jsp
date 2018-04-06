<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%--
fatwire/wem/ui/admin/site/AssignUsers
--%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="java.net.URLEncoder" %>

<cs:ftcs>

<script type="text/javascript">
populate = function(obj) {
	var userstable = dijit.byId('UITable');
	//TODO: restructure this in case fetch is already completed first?
	var conn = dojo.connect(userstable, 'onInitialFormatComplete',
		function() {
			if (obj.tablePageNum) {
				userstable.gotoPage(parseInt(obj.tablePageNum, 10));
				dojo.byId('tablePageNum').value = obj.tablePageNum;
			}
			if (obj.tableRowIndex) {
				userstable.select(obj.tableRowIndex);
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
	usersstore.fetch({onBegin: disableAddIfAllAssigned});
	
	//check if anything is already assigned; if not, show message
	userrolesstore.fetch({onBegin: showMessageIfNoneAssigned});
}
  
executeOnDelete = function(/*String*/ user){
	var users = AdminUIManager.editObj.siteUsers.user;
	if(dojo.isArrayLike(users)){
		for(var i=0;i < users.length;i++){
			if(user == users[i].name){
				users.splice(i,1);
				break;
			}
		}
		//if there are no users then delete the property from the editObj
		if(users.length === 0){
			delete AdminUIManager.editObj.siteUsers;
		}
	} else {
		delete AdminUIManager.editObj.siteUsers;
	}
}

updateFormFields = function(rowIndex) {
	var userstable = dijit.byId('UITable');
	dojo.byId('tablePageNum').value = userstable.currentPage;
	if(typeof(rowIndex) != 'undefined')
		dojo.byId('tableRowIndex').value = rowIndex;
}

//create stores used on this and subsequent pages
//rather than re-querying REST, use fragment of editObj for table on this page
//For new site there would be no users so assign the empty array by default
var obj = [];
if(typeof(AdminUIManager.editObj.siteUsers) != 'undefined' && AdminUIManager.editObj.siteUsers.user){
	obj = AdminUIManager.editObj.siteUsers.user;
	if (!dojo.isArrayLike(obj))
		obj = [obj];
}
userrolesstore = new dojo.data.ItemFileReadStore({data: {
	identifier: 'name',
	items: (obj ? dojo.clone(obj) : [])
}});
//store used to check whether to disable Add button, and used by Add page
usersstore = new fw.data.cs.ClientRestStore({ resource: 'users' });
</script>

<%-- contents of container div (TODO: only put form div in here) --%>
<ics:setvar name="cspath" value="../../../../.."/>
<ics:callelement element="fatwire/wem/ui/admin/Heading"> 
      <xlat:lookup key="fatwire/wem/admin/site/assignUsers/Heading" varname="_XLAT_"/>
      <ics:argument name="Heading:title" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <ics:argument name="Heading:subtitle" value=''/>
</ics:callelement>
<%-- Include the delete confirmation box--%>
<ics:callelement element="fatwire/wem/ui/admin/DeleteConfirm">
	  <xlat:lookup key="fatwire/wem/admin/site/assignUsers/Delete" varname="_XLAT_"/>
      <ics:argument name="fw:adminUI:deleteConfMsg" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <ics:argument name="fw:adminUI:element" value='<%="site/AssignUsers?fw:adminUI:identifier=" + URLEncoder.encode(ics.GetVar("fw:adminUI:identifier"),"UTF-8")%>'/>
	  <ics:argument name="fw:adminUI:urlkey" value='Site'/>
	  <ics:argument name="fw:adminUI:deleteType" value='deleteByEdit'/>
</ics:callelement>
<%-- TODO: form onsubmit --%>
<input type="hidden" id="pageId" value="site/AssignUsers"/>
<div class="form"><div dojoType="fw.dijit.UIForm" id="mainform">
<%--<form action="" method="post" id="mainform">--%>
<div id="msg"></div>
 <span class="overtablebtns">
   <button id="btnAdd" dojoType="fw.ui.dijit.Button" buttonStyle="grey" buttonType="Continue wemButtonStyle" onClick="AdminUIManager.loadPage('site/AddUser?fw:adminUI:identifier=<string:stream value='<%=ics.GetVar("fw:adminUI:identifier")%>'/>','next');">
		<xlat:stream  key='fatwire/wem/button/AssignUsers'/>
   </button>	
 </span>
<xlat:lookup key="fatwire/wem/admin/common/UserName" varname="_XLAT_"  escape="true"/>
 <table dojoType="fw.dijit.UITable" autoHeight="true" id="UITable"
  store="userrolesstore" rowsPerPage="5" searchAttr="name"
  sortByOptions="{'<%=ics.GetVar("_XLAT_")%>':'name'}" sort="name">
  <thead><tr>
	<xlat:lookup key="fatwire/wem/admin/common/UserName" varname="_XLAT_"/>
   <th width="30%" field="name" formatter="formatBold"><%=ics.GetVar("_XLAT_").toUpperCase()%></th>
   <xlat:lookup key="fatwire/wem/admin/common/Roles" varname="_XLAT_"/>   
   <th width="70%" field="name" formatter="formatRoles"><%=ics.GetVar("_XLAT_").toUpperCase()%></th>
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
    <a class="UITableAssign" href="javascript:updateFormFields($(rowIndex));var _adminUIUser = encodeURIComponent('$(_ID_)');AdminUIManager.continueForm('AssignRoles?fw:adminUI:identifier=<string:stream value='<%=ics.GetVar("fw:adminUI:identifier")%>'/>&fw:adminUI:user=' + _adminUIUser + '&fw:adminUI:submitPage=site/AssignUsers');"><xlat:stream key="fatwire/wem/admin/user/assignRoles_S/Heading"/></a>
    <a class="UITableDelete" href="javascript:AdminUIManager.confirmDelete('$(_ID_)');"><xlat:stream key="fatwire/wem/admin/common/actions/Remove"/></a>
   </div>
  </div>
 </div>
<input type="hidden" id="tableRowsPerPage" name="tableRowsPerPage" value=""/>
 <input type="hidden" id="tableRowIndex" name="tableRowIndex" value=""/>
 <input type="hidden" id="tablePageNum" name="tablePageNum" value=""/>
</div>
 <%--end of UIForm--%>
   <%--</form>--%></div>
<%-- TODO: finalize and localize note text --%>
<ics:callelement element="fatwire/wem/ui/admin/Description"> 
	<xlat:lookup key="fatwire/wem/admin/site/assignUsers/DescriptionTitle" varname="_XLAT_"/>
	<ics:argument name="Description:heading" value='<%=ics.GetVar("_XLAT_")%>'/>
	<xlat:lookup key="fatwire/wem/admin/site/assignUsers/DescriptionBody" encode="false" varname="_XLAT_"/>
	<ics:argument name="Description:description" value='<%=ics.GetVar("_XLAT_")%>'/>
	<ics:argument name="Description:image" value="gears"/>
</ics:callelement>
<div style="clear: both"></div>
</cs:ftcs>



