<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// fatwire/wem/ui/admin/Heading
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
<div class="breadcrumbs" id="breadcrumbs"></div>
<h1 id="Heading:title"><%=ics.GetVar("Heading:title")%></h1>
<%if(null != ics.GetVar("Heading:subtitle")){%>
<div id="Heading:subtitle" class="subtitle"><string:stream value='<%=ics.GetVar("Heading:subtitle")%>'/></div>
<%}%>
<script type="text/javascript">
var breadcrumbNode = dojo.byId("breadcrumbs");
if (breadcrumbNode) {
	var breadcrumbHTML="";
	for(var i=0;i < AdminUIManager.activePage;i++){
		if('<string:stream value='<%=ics.GetVar("fw:adminUI:identifier")%>'/>' != 'null'){
			breadcrumbHTML += "<a href=\"javascript:AdminUIManager.loadPage('" + AdminUIManager.dataArray[i].pageId + "?fw:adminUI:identifier=<string:stream value='<%=ics.GetVar("fw:adminUI:identifier")%>'/>','prev');\">" + AdminUIManager.dataArray[i].pageName + "</a> &gt ";
		} else {
			breadcrumbHTML += "<a href=\"javascript:AdminUIManager.loadPage('" + AdminUIManager.dataArray[i].pageId + "','prev');\">" + AdminUIManager.dataArray[i].pageName + "</a> &gt ";
		}
	}
	//current decision is to not show current level in breadcrumb
	//breadcrumbHTML += "<span class='current'><%=ics.GetVar("Heading:title")%></span>";
	breadcrumbNode.innerHTML = breadcrumbHTML || '&nbsp;';
	breadcrumbHTML = null;
	breadcrumbNode = null;
}
</script>
</cs:ftcs>
