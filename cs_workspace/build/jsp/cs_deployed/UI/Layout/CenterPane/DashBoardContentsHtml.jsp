<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="controller" uri="futuretense_cs/controller.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%//
// UI/Layout/CenterPane/DashBoardContentsHtml
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="org.apache.commons.configuration.beanutils.ConfigurationDynaBean"%>
<%@ page import="org.codehaus.jackson.map.ObjectMapper"%>
<%@ page import="org.codehaus.jackson.type.TypeReference"%>
<%@ page import="com.fatwire.services.ui.beans.LabelValueBean"%>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.commons.configuration.HierarchicalConfiguration"%>
<%@ page import="com.fatwire.ui.util.DashBoardUtil"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>

<cs:ftcs>
		
	<script>
	 	// listen to '/dojox/mdnd/drop/columnUpdated' event as we need to
	 	// store component positions after the drop is completed.
		dojo.subscribe("/dojox/mdnd/drop/columnUpdated", null, function(){ 
			var children = dijit.byId('dashBoardGridContainer').getChildren();
			console.debug("DashBoardContentsHtml - dashboard widgets :", children);
			var params = [];
			for(var i=0; i<children.length; i++){
				params.push({"label":children[i].id, "value":children[i].column});
			}
			var objfac = fw.ui.ObjectFactory;
			var storageService = objfac.getService('storage');
			storageService.setAttribute("dashboard", dojo.toJson(params), true);			
		});
	</script>
	
	<%
		// check whether or not we have single or multiple component in the configuration
		ConfigurationDynaBean bn = (ConfigurationDynaBean)request.getAttribute("dashboardconfig");		
		String colWidths = (bn.containsKey("dashboardlayout.columnwidths")? bn.get("dashboardlayout.columnwidths").toString() : "");
		List<Map<String, String>> listToDisplay = DashBoardUtil.getPersistedComponentList(request, bn);		
	%>


	<div id="dashBoardGridContainer"
		data-dojo-type="fw.ui.dojox.layout.GridContainer"
		data-dojo-props="
			isAutoOrganized:false,		
			hasResizableColumns: false,
			nbZones: ${dashboardconfig['dashboardlayout.numberofcolumns']},
			liveResizeColumns: true,
			dragHandleClass: 'dijitTitlePaneTitle',
			region: 'center',
			colWidths: '<%=colWidths%>'
 	">


	<%	
	for(int i=0; i<listToDisplay.size(); i++)
	{
		Map<String, String> componentMap = listToDisplay.get(i);
	%>	
				
				   <div 
					data-dojo-type="dojox.widget.Portlet"
					data-dojo-props="
						'class': '<%=componentMap.get("style")%>'+' fwPortlet',
						title: '<%=StringEscapeUtils.escapeHtml(componentMap.get("name"))%>',
						open: Boolean(<%=componentMap.get("open")%>),
						closable: Boolean(<%=componentMap.get("closable")%>),
						dragRestriction: Boolean(<%=componentMap.get("dragRestriction")%>),
						column:	parseInt('<%=componentMap.get("column")%>'),
						id:'<%=componentMap.get("id")%>'
					">
						<div
							data-dojo-type="dojox.layout.ContentPane"
							style='height:<%=componentMap.get("height")%>'
							data-dojo-props="
								'class': 'fwPortletContentPane',
								href: 'ContentServer?pagename=fatwire/ui/controller/controller&elementName='+'<%=componentMap.get("url")%>'+'&id='+'<%=componentMap.get("id")%>'+'&title='+'<%=StringEscapeUtils.escapeHtml(componentMap.get("name"))%>',
								loadingMessage: ''
							">
						</div>
				</div>
	<%
			
		}	
	%>

</cs:ftcs>
