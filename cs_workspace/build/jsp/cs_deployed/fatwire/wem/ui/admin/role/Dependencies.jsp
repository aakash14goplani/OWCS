<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%//
// fatwire/wem/ui/admin/role/Dependencies
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
	if(AdminUIManager.editObj.description)
		dojo.byId('Heading:subtitle').innerHTML=AdminUIManager.editObj.description;
	if(AdminUIManager.submitResp){
		AdminUIManager.showMessage(AdminUIManager.submitResp);
	}
	//Reset the object
	AdminUIManager.submitResp = null;
};
</script>
<ics:setvar name="cspath" value="../../../../.."/>
<ics:callelement element="fatwire/wem/ui/admin/Heading"> 
      <xlat:lookup key="fatwire/wem/admin/role/dependencies/Heading" varname="_XLAT_"/>
	  <ics:argument name="Heading:title" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <ics:argument name="Heading:subtitle" value=''/>
</ics:callelement>
<%-- Include the delete confirmation box--%>
<ics:callelement element="fatwire/wem/ui/admin/DeleteConfirm">
	  <xlat:lookup key="fatwire/wem/admin/role/dependencies/Delete" varname="_XLAT_"/>
      <ics:argument name="fw:adminUI:deleteConfMsg" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <ics:argument name="fw:adminUI:element" value='role/Browse'/>
</ics:callelement>
<input type="hidden" id="pageId" value="role/Dependencies"/>
<%-- TODO: form onsubmit --%>
<div class="form"><div dojoType="fw.dijit.UIForm" id="mainform">
<div id="msg"></div>
 <div class="formtable">
 <div dojoType="fw.data.cs.ClientRestStore" resource="roledependencies" jsId="roledepsstore"
 	params="{role: encodeURIComponent(AdminUIManager.editObj.name)}"></div>
<xlat:lookup key="fatwire/wem/admin/common/fields/Name" varname="_XLAT_" escape="true"/>
 <table dojoType="fw.dijit.UITable" autoHeight="true" id="UITable"
  store="roledepsstore" rowsPerPage="5" searchAttr="name"
  sortByOptions="{'<%=ics.GetVar("_XLAT_")%>':'name'}" sort="name">
  <thead><tr>
   <xlat:lookup key="fatwire/wem/admin/common/fields/Name" varname="_XLAT_"/>
   <th width="34%" field="name" formatter="formatBold"><%=ics.GetVar("_XLAT_").toUpperCase()%></th>
   <xlat:lookup key="fatwire/wem/admin/common/Type" varname="_XLAT_"/>
	 <th width="33%" field="type"><%=ics.GetVar("_XLAT_").toUpperCase()%></th>
   <xlat:lookup key="fatwire/wem/admin/common/Site" varname="_XLAT_"/>
	<th width="33%" field="site"><%=ics.GetVar("_XLAT_").toUpperCase()%></th>
  </tr></thead>
 </table>
 </div>
 <div class="clear"></div>
   <div class="buttonsrow">
	<button dojoType="fw.ui.dijit.Button" buttonStyle="grey" buttonType="Delete wemButtonStyle" onClick="AdminUIManager.deleteIdentifier=AdminUIManager.editObj.name;AdminUIManager.deleteByXHR('role/Browse','roledeps',false,true);AdminUIManager.deleteByXHR('role/Browse',undefined,true,false);">
		<xlat:stream  key='fatwire/wem/admin/role/dependencies/DeleteAllDependencies'/>
    </button>
   <span style="top:0;" onclick="AdminUIManager.loadPage('role/Browse','prev');" class="button"><xlat:stream key="fatwire/wem/admin/common/actions/Cancel"/></span>
   </div>
</div><%--end of UIForm--%>
</div>
<%-- TODO: finalize and localize note text --%>
<ics:callelement element="fatwire/wem/ui/admin/Description"> 
      <xlat:lookup key="fatwire/wem/admin/role/dependencies/DescriptionTitle" varname="_XLAT_"/>
      <ics:argument name="Description:heading" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <xlat:lookup key="fatwire/wem/admin/role/dependencies/DescriptionBody" varname="_XLAT_" encode="false"/>
	  <ics:argument name="Description:description" value='<%=ics.GetVar("_XLAT_")%>'/>
	  <ics:argument name="Description:image" value="gears"/>
</ics:callelement>
<div style="clear: both"></div>
</cs:ftcs>