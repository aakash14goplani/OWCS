<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%--
fatwire/wem/ui/admin/app/Browse
--%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<cs:ftcs>
<%--- Adding this temporarily --%>
<ics:setvar name="cspath" value="../../../../.."/>
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
  updateFormFields = function(rowIndex) {
	var appstable = dijit.byId('UITable');
	dojo.byId('tablePageNum').value = appstable.currentPage;
	dojo.byId('tableRowIndex').value = rowIndex;
  }
 </script>
<ics:callelement element="fatwire/wem/ui/admin/Heading">
	  <xlat:lookup key="fatwire/wem/admin/app/browse/Heading" varname="_XLAT_"/>
      <ics:argument name="Heading:title" value='<%=ics.GetVar("_XLAT_")%>'/>
</ics:callelement>
<input type="hidden" id="pageId" value="app/Browse"/>
<div class="form"><div dojoType="fw.dijit.UIForm" id="mainform">
<div id="msg"></div>
 <div class="formtable">
 <div dojoType="fw.data.cs.ClientRestStore" resource="applications" jsId="appsstore"></div>
<xlat:lookup key="fatwire/wem/admin/common/AppName" varname="_XLAT_" escape="true"/>
 <table dojoType="fw.dijit.UITable" autoHeight="true" id="UITable"
  store="appsstore" rowsPerPage="5" searchAttr="name"
  sortByOptions="{'<%=ics.GetVar("_XLAT_")%>':'name'}" sort="name">
  <thead><tr>
   <xlat:lookup key="fatwire/wem/admin/common/AppName" varname="_XLAT_"/>
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
    <a class="UITableEdit" href="javascript:updateFormFields($(rowIndex));AdminUIManager.editForm('$(_ID_)'.substring('$(_ID_)'.indexOf(':') + 1),'app/Edit?wem:AdminUI:identifier=' + '$(_ID_)'.substring('$(_ID_)'.indexOf(':') + 1));"><xlat:stream key="fatwire/wem/admin/common/actions/Edit"/></a>
   <a class="UITableAssign" href="javascript:updateFormFields($(rowIndex));AdminUIManager.editForm('$(_ID_)','app/AssignSites?fw:adminUI:identifier=$(_ID_)');"><xlat:stream key="fatwire/wem/admin/app/assignSites/Heading"/></a>
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
      <xlat:lookup key="fatwire/wem/admin/app/browse/DescriptionTitle" varname="_XLAT_"/>
      <ics:argument name="Description:heading" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <xlat:lookup key="fatwire/wem/admin/app/browse/DescriptionBody" encode="false" varname="_XLAT_"/>
	  <ics:argument name="Description:description" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <ics:argument name="Description:image" value="gears"/>
</ics:callelement>
<div style="clear: both"></div>
</cs:ftcs>

