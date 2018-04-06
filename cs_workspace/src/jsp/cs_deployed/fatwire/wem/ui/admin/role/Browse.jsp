<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%--
fatwire/wem/ui/admin/role/Browse
--%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<cs:ftcs>
<script type="text/javascript">
	preprocess = function(){
		if(AdminUIManager.submitResp){
			AdminUIManager.showMessage(AdminUIManager.submitResp);
			if(AdminUIManager.submitResp._action == 'Added'){
				var link = '&nbsp;<a href=\'#\' id=\'showAnchor\' onClick=\'javascript:AdminUIManager.executeShowLink("' + AdminUIManager.submitResp.name + '");\'><xlat:stream key="fatwire/wem/admin/showlink"/></a>&nbsp;<a style=\'display:none\' id=\'clearAnchor\' href=\'#\' onClick=\'javascript:AdminUIManager.executeClearLink();\'><xlat:stream key="fatwire/wem/admin/clearlink"/></a>';
				var msgtext = dojo.byId('msgtext').innerHTML;
				dojo.byId('msgtext').innerHTML = msgtext + link;
			}
			//Reset the object
			AdminUIManager.submitResp = null;
		}
	}
	populate = function(obj) {
		var rolesTable = dijit.byId('UITable');
		//TODO: restructure this in case fetch is already completed first?
		var conn = dojo.connect(rolesTable, 'onInitialFormatComplete',
			function() {
				if (obj.tablePageNum) {
					rolesTable.gotoPage(parseInt(obj.tablePageNum, 10));
					dojo.byId('tablePageNum').value = obj.tablePageNum;
				}
				if (obj.tableRowIndex) {
					rolesTable.select(obj.tableRowIndex);
					dojo.byId('tableRowIndex').value = obj.tableRowIndex;
				}
				dojo.disconnect(conn);
			});
	}
  updateFormFields = function(rowIndex) {
	var rolesTable = dijit.byId('UITable');
	dojo.byId('tablePageNum').value = rolesTable.currentPage;
	dojo.byId('tableRowIndex').value = rowIndex;
};
 </script> 
<%--- Adding this temporarily --%>
<ics:setvar name="cspath" value="../../../../.."/>
<ics:callelement element="fatwire/wem/ui/admin/Heading"> 
      <xlat:lookup key="fatwire/wem/admin/role/browse/Heading" varname="_XLAT_"/>
	  <ics:argument name="Heading:title" value='<%=ics.GetVar("_XLAT_")%>'/>
</ics:callelement>
<%-- Include the delete confirmation box--%>
<ics:callelement element="fatwire/wem/ui/admin/DeleteConfirm">
	  <xlat:lookup key="fatwire/wem/admin/role/browse/Delete" varname="_XLAT_"/>
      <ics:argument name="fw:adminUI:deleteConfMsg" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <ics:argument name="fw:adminUI:element" value='role/Browse'/>
</ics:callelement>
<input type="hidden" id="pageId" value="role/Browse"/>
<%-- TODO: form onsubmit --%>
<div class="form"><div dojoType="fw.dijit.UIForm" id="mainform">
<div id="msg"></div>
<span class="overtablebtns">
	<button id="btnAdd" dojoType="fw.ui.dijit.Button" buttonStyle="grey" buttonType="Add wemButtonStyle" onClick="AdminUIManager.addForm('role/Add');">
		<xlat:stream  key='fatwire/wem/admin/role/add/AddRole'/>
   </button>
 </span>
 <div class="formtable">
 <div dojoType="fw.data.cs.ServerRestStore" resource="roles" jsId="rolesstore"></div>
 <xlat:lookup key="fatwire/wem/admin/common/RoleName" varname="_XLAT_" escape="true"/>
 <table dojoType="fw.dijit.UITable" autoHeight="true" id="UITable"
  store="rolesstore" rowsPerPage="5" searchAttr="name" queryExpr="<%="${"%>0}"
  sortByOptions="{'<%=ics.GetVar("_XLAT_")%>':'name'}" sort="name">
  <thead><tr>
   <xlat:lookup key="fatwire/wem/admin/common/RoleName" varname="_XLAT_"/>
   <th width="34%" field="name" formatter="formatBold"><%=ics.GetVar("_XLAT_").toUpperCase()%></th>
   <xlat:lookup key="fatwire/wem/admin/common/fields/Description" varname="_XLAT_"/>
	 <th width="66%" field="description" formatter="formatDescription"><%=ics.GetVar("_XLAT_").toUpperCase()%></th>
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
	  <a class="UITableEdit" href="javascript:updateFormFields($(rowIndex));AdminUIManager.editForm('$(_ID_)','role/Edit');"><xlat:stream key="fatwire/wem/admin/common/actions/Edit"/></a>
    <a class="UITableDelete" href="javascript:AdminUIManager.confirmDelete('$(_ID_)');"><xlat:stream key="fatwire/wem/admin/common/actions/Delete"/></a>
   </div>
  </div>
 </div>
 </div>
 <input type="hidden" id="tableRowIndex" name="tableRowIndex" value=""/>
 <input type="hidden" id="tablePageNum" name="tablePageNum" value=""/>
</div><%--end of UIForm--%>
</div>
<%-- TODO: finalize and localize note text --%>
<ics:callelement element="fatwire/wem/ui/admin/Description"> 
      <xlat:lookup key="fatwire/wem/admin/role/browse/DescriptionTitle" varname="_XLAT_"/>
      <ics:argument name="Description:heading" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <xlat:lookup key="fatwire/wem/admin/role/browse/DescriptionBody" varname="_XLAT_" encode="false"/>
	  <ics:argument name="Description:description" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <ics:argument name="Description:image" value="gears"/>
</ics:callelement>
<div style="clear: both"></div>
</cs:ftcs>

