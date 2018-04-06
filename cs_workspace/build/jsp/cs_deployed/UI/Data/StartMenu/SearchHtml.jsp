<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ page import="com.fatwire.services.beans.entity.StartMenuBean"
%><%@ page import="com.fatwire.ui.util.SearchUtil"
%><%@ page import="org.apache.commons.lang.StringUtils"
%><%@ page import="org.apache.commons.lang.math.NumberUtils"
%><%@ page import="java.util.List"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="com.fatwire.services.ui.beans.UIStartMenuBean"
%><%@ page import="org.codehaus.jackson.map.ObjectMapper"
%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"
%>
<cs:ftcs>
<xlat:lookup key="fatwire/Alloy/UI/Scroller/NoStartMenusAvailable" escape="true" varname="nostartmenus"/>
<%
try 
{
	List<UIStartMenuBean> searchStartMenuList = (List<UIStartMenuBean>)request.getAttribute("searchStartMenuData");	
	String noDataMsg = ics.GetVar("nostartmenus");
	String json = new ObjectMapper().writeValueAsString(searchStartMenuList);
%>

<%--
- The following snippet generates the search start menu dropdown title
- and link to advanced search.
-
- TODO move this to widget instead
--%>
<c:set var="titleContent" scope="page">
  <div class="searchTypeHeader"><div class="searchTypeAdvanced"><%
  %><a href="#" onclick="SitesApp.event('search', 'advanced-search');"><%
  %><xlat:stream key="dvin/UI/advancedsearch" escape="true"/><%
  %></a></div><div class="searchTypeTitle"><xlat:stream key="UI/Search/SearchType" escape="true"/></div></div>
</c:set>

<c:set var="titleContent" scope="page">${fn:replace(titleContent, '"', '\\"')}</c:set>
<c:set var="titleContent" scope="page">${fn:replace(titleContent, "'", "\\&#39;")}</c:set>

<div 
	data-dojo-type='fw.ui.dijit.FlexibleMenu'
	data-dojo-props='
		id: "searchStartMenu",
		"class": "searchStartMenuPopup",
		noDataMessage: "<%=noDataMsg%>",
		defaultItem: null,
		previousItem: null,
		afterPostCreate: function() {
			this.set({
				"titleContent": "${titleContent}",
				"items": <%=json%>,
				"rows": 10,
				"columns": 4
			});
		},
		createMenuItem: function(item) {
			var self = this, // = flexible menu
				menuItem = new fw.ui.dijit.CheckedMenuItem({
					label: item.description || item.name,
					title: item.description || item.name,
					checked: false,
					"class": "ellipsis",
					onChange: function() {
						self.onSelect(this);
					},
					value: item
				});
			
			if (item.name === "<%=SearchUtil.ALL%>") {
				self.defaultItem = menuItem;
			}
			
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
%></cs:ftcs>