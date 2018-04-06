<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ page import="java.util.*"
%><%@ page import="com.fatwire.services.ui.beans.UIPreviewSegmentBean"
%><%@ page import="org.codehaus.jackson.map.ObjectMapper"
%><%@ page import="com.fatwire.cs.ui.framework.UIException"
%>
<cs:ftcs>
<xlat:lookup key="UI/UC1/Layout/NoSegments" escape="true" varname="nosegments"/>
<%
try 
{
	List<UIPreviewSegmentBean> segmentList = (List<UIPreviewSegmentBean>)request.getAttribute("sList");
	String listjson = new ObjectMapper().writeValueAsString(segmentList);
	String json = "[{description: \"" + ics.GetVar("nosegments") + "\", name: \"_nosegments_\"}," +  listjson.substring(1); 
%>
<div
	data-dojo-type='fw.ui.dijit.FlexibleMenu'
	data-dojo-props='
		"class": "segmentChangeMenuPopup",
		defaultItem: null,
		previousItem: null,
		afterStartup: function() {
			SitesApp.event("active", "changesegment", null);	// startup state depends on view setting
		},
		afterPostCreate: function() {
			this.set({
//				"titleContent": "Segments",
				"items": <%=json%>,
				"rows": 10,
				"columns": 4
			});
		},
		createMenuItem: function(item) {
			var menuItemPopup = dijit.getEnclosingWidget(this.domNode.parentNode);
			var self = this, // = flexible menu
				menuItem = new fw.ui.dijit.CheckedMenuItem({
					label: item.description || item.name,
					title: item.description || item.name,
					checked: false,
					"class": "ellipsis",
					onClick: function() {

// Commented out so that you can make multiple picks without closing the popup menu
// simply click outside the menu when you are done. (per change request from KK)					
//						menuItemPopup.onExecute();

						SitesApp.event("active", "changesegment", item.name);
					},
					value: item.name,
					previewSegment: true
				});
			
//			if (item.name === "SOMETRIKVALUE") {
//				self.defaultItem = menuItem;
//			}
			
			return menuItem;
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