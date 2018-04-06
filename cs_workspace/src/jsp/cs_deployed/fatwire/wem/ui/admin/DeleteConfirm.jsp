<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// fatwire/wem/ui/admin/DeleteConfirm
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
<string:encode variable="fw:adminUI:deleteConfMsg" varname="fw:adminUI:deleteConfMsg"/>
<div dojoType="fw.dijit.UIDialog" id="confirmDeleteDialog" style="display:none">
 <div class="title"><%=ics.GetVar("fw:adminUI:deleteConfMsg")%></div>
 <xlat:lookup key="fatwire/wem/admin/common/OperationNoUndone" varname="_XLAT_" escape="true"/>
 <div><%=ics.GetVar("_XLAT_")%></div>
 <div class="buttons">
 <%
String deleteCall = "";
String _username = request.getParameter("fw:adminUI:identifier");

//Different button would be used for xhrdelete(delete) and deletebyedit(remove)
String deleteBtn="";
if("deleteByEdit".equals(ics.GetVar("fw:adminUI:deleteType"))) {

	deleteCall = "AdminUIManager.deleteByEdit('" +
	ics.GetVar("fw:adminUI:element") + "','"+
	_username + "'";
	if(ics.GetVar("fw:adminUI:urlkey") != null){
		deleteCall += ",'" + ics.GetVar("fw:adminUI:urlkey") + "'";
	}
	deleteCall +=  ");";
	deleteBtn="btnRemove.png";
} else { //simple REST DELETE request
	deleteCall = "AdminUIManager.deleteByXHR('" +
	ics.GetVar("fw:adminUI:element") + "');";
	deleteBtn="btnDelete.png";	
}
   %>
   <div style="padding-right:20px; display:inline-block">
		<button dojoType="fw.ui.dijit.Button" buttonStyle="grey" buttonType="Delete wemButtonStyle" onClick="<string:stream value='<%=deleteCall%>'/>" dijit.byId('confirmDeleteDialog').hide();">
			<% if (deleteBtn.equalsIgnoreCase("btnRemove.png")) { %>
				<xlat:stream  key='fatwire/wem/admin/common/actions/Remove'/>
			<% } else {%>
				<xlat:stream  key='fatwire/wem/admin/common/actions/Delete'/>
			<% } %>		
	   </button>
	</div>
	<div style="display:inline-block">
	   <button dojoType="fw.ui.dijit.Button" buttonStyle="grey" buttonType="Cancel wemButtonStyle" onClick="dijit.byId('confirmDeleteDialog').hide();">
			<xlat:stream  key='fatwire/wem/admin/common/actions/Cancel'/>
	   </button>
   </div>
 </div>
</div>

</cs:ftcs>