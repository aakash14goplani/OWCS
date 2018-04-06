<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ page import="com.fatwire.services.beans.entity.StartMenuBean"
%><%@ page import="org.apache.commons.lang.StringUtils"
%><%@ page import="org.apache.commons.lang.math.NumberUtils"
%><%@ page import="java.util.List"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.ui.beans.UIStartMenuBean"
%><%@ page import="org.codehaus.jackson.map.ObjectMapper"
%>
<cs:ftcs>
<xlat:lookup key="fatwire/Alloy/UI/Scroller/NoStartMenusAvailable" escape="true" varname="nonewstartmenus"/>
<%
try 
{
	List<UIStartMenuBean> newStartMenuList = (List<UIStartMenuBean>)request.getAttribute("newStartMenuData");
	String json = new ObjectMapper().writeValueAsString(newStartMenuList);
	String noDataMsg = ics.GetVar("nonewstartmenus");
%>
<div 
	data-dojo-type='fw.ui.dijit.FlexibleMenu'
	data-dojo-props='
		"class": "newStartMenu",
		noDataMessage: "<%=noDataMsg%>",
		afterPostCreate: function() {
			this.set({
				"items": <%=json%>,
				"rows": 10,
				"columns": 4
			});
		},
		createMenuItem: function(item) {
			var menuItemPopup = dijit.getEnclosingWidget(this.domNode.parentNode).parentMenu.currentPopup;
			
			item.description = fw.util.encodeString(item.description);  
			item.title = fw.util.encodeString(item.title); 
			item.name = fw.util.encodeString(item.name);  
		
			return new fw.dijit.UIMenuItem({
				label: item.description,
				title: item.description,
				onClick: function() {
					dojo.publish("/webcenter/sites/event", [{
						"target": "document", /* target is document controller */
						"function-name": "new",
						"function-args": {
							"document-type": fw.util.getType({type: item.assettype}),
							"view-type": item.doctype,
							"asset": {
								"type": item.assettype,
								"subtype": item.subtype
							},
							"name": item.name,
							"description": item.description,
							"startmenuid": item.startmenuid,
							"steptype": item.steptype,
							"stepid": item.stepid,
							"flex": item.flex,
							"tname": item.tname,
							"workflowid": item.workflowid
						}
					}]);
					menuItemPopup.onExecute();
				}
			});
		}
	'>
</div>
<%
	} catch(Exception e) {
		UIException uie = new UIException(e);
		request.setAttribute(UIException._UI_EXCEPTION_, uie);
		throw uie;
	}
%>
</cs:ftcs>