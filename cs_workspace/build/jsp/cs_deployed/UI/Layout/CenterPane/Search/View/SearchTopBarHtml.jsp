<%@page import="java.util.Map"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><%@page import="org.apache.commons.lang.BooleanUtils"
%><%@page import="org.apache.commons.lang.StringUtils"
%><%@page import="org.apache.commons.collections.CollectionUtils"
%><%@page import="com.fatwire.services.beans.asset.basic.DimensionBean"
%><%@page import="java.util.List"
%><%@page import="com.fatwire.services.SiteService"
%><%@page import="com.fatwire.services.ServicesManager"
%><%@page import="com.fatwire.system.SessionFactory"
%><%@page import="com.fatwire.system.Session"
%><%@page import="com.fatwire.ui.util.SearchUtil"
%><%@page import="com.fatwire.cs.ui.framework.UIException"
%><%@page import="org.apache.commons.configuration.beanutils.ConfigurationDynaBean"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="controller" uri="futuretense_cs/controller.tld"
%><cs:ftcs><%
try {
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager) ses.getManager(ServicesManager.class.getName());
	SiteService siteService = servicesManager.getSiteService();
	List<String> enabledTypes = siteService.getEnabledTypes(GenericUtil.getLoggedInSite(ics));
	boolean dimensionEnabled = CollectionUtils.isNotEmpty(enabledTypes) && enabledTypes.contains(DimensionBean.DIMENSION);

	ConfigurationDynaBean configBean = (ConfigurationDynaBean) request.getAttribute("sortconfig");
	Map<String, String> sortMap = GenericUtil.emptyIfNull(SearchUtil.getSortFields(ics, configBean, dimensionEnabled));

	boolean sortExists = StringUtils.isNotBlank(ics.GetVar("sort")); 
	String defaultSortField = ics.GetVar("defaultSortField");
	if(StringUtils.equalsIgnoreCase(ics.GetVar("defaultSortOrder"), "descending")) {
		defaultSortField = "-" + defaultSortField;
	}
	String sortField = sortExists ? request.getParameter("sort") : defaultSortField;

	boolean isFull = !BooleanUtils.toBoolean(StringUtils.defaultString(ics.GetVar("dock")));
	boolean isClose = BooleanUtils.toBoolean(StringUtils.defaultString(ics.GetVar("close")));
	boolean isSelect = BooleanUtils.toBoolean(StringUtils.defaultString(ics.GetVar("select")));
	boolean isList = StringUtils.equalsIgnoreCase(ics.GetVar("viewType"), "list");
	boolean isRunSaveSearch = StringUtils.equalsIgnoreCase(ics.GetVar("searchType"), "runSaveSearch");
	boolean isBrowse = BooleanUtils.toBoolean(StringUtils.defaultString(ics.GetVar("browse")));
%><div class="searchGridTitle">
	<div class="searchGridTitleLeft"><%
	if(isFull){
		%><div dojoType="fw.dijit.UIActionImage" src="js/fw/images/ui/ui/search/dock.png" id="dock" class="searchDockLink" clickImage="false" hoverImage="false" disabledImage="false" alt='<xlat:stream key="UI/UC1/Layout/Dock"/>' title='<xlat:stream key="UI/UC1/Layout/Dock"/>' width="15" height="15"></div><%
	}else{
		%><div dojoType="fw.dijit.UIActionImage" src="js/fw/images/ui/ui/search/undock.png" id="undock" class="searchDockLink" clickImage="false" hoverImage="false" disabledImage="false" alt='<xlat:stream key="UI/UC1/Layout/Undock"/>' title='<xlat:stream key="UI/UC1/Layout/Undock"/>' width="15" height="15"></div><%
	}
	
	if(isSelect){
		%><select dojotype="dijit.form.Select" id="sortSelect" name="sortSelect" class="searchSortSelect" title='<xlat:stream key="UI/UC1/Layout/Sort"/>'>
			<option>&nbsp</option>
			<%
				for(String key : sortMap.keySet()) {
					String value = sortMap.get(key);
					String selected = StringUtils.equals(sortField, value) ? "selected=\"selected\"" : "";
					%><option value="<%= value%>" <%= selected%>><%= key%></option><%
				}
		%></select><%
	}
	if(isFull && !isRunSaveSearch ) {%>
		<div class="searchQueryContent">
			<%if(!isBrowse){ %>
				<strong><xlat:stream key="UI/UC1/Layout/SearchKeyword"/>:</strong><span id="searchQueryDisplay" class="searchQuery"></span>
				<div id="searchQueryDetails" data-dojo-type="fw.ui.dijit.HoverableTooltip" data-dojo-props="connectedNodes:'searchQueryDisplay', position:'below','class':'searchHelpTextTooltip'"></div>
			<%}else{ %>
				<strong><xlat:stream key="UI/UC1/Layout/Browsing"/>:</strong><span id="searchQueryDisplay" class="searchQuery"></span>
			<%} %>
			<span id="numSearchItems"></span>
		</div>
		<%if(!isBrowse){%>
			<div class="createSmateListLink"><a href="#" id="createSmartList" title='<xlat:stream key="UI/Search/SavedSearchMessage12"></xlat:stream>'><xlat:stream key="dvin/UI/SaveSearch"></xlat:stream></a></div><%
		}
	}
	%></div>
	<div class="searchGridTitleRight">
			<!-- List and Thumbnail icon -->
			<%if(isList){
				%><div dojoType="fw.dijit.UIActionImage" src="js/fw/images/ui/ui/search/listView.png" clickImage="false" hoverImage="false" disabledImage="false" alt='<xlat:stream key="UI/Search/ListView"/>' title='<xlat:stream key="UI/Search/ListView"/>' width="18" height="15"></div>
				<div dojoType="fw.dijit.UIActionImage" id='switchToThumbnail' src="js/fw/images/ui/ui/search/gridView.png" clickImage="false" hoverImage="false" disabledImage="false" alt='<xlat:stream key="UI/Search/ThumbnailView"/>' title='<xlat:stream key="UI/Search/ThumbnailView"/>' width="18" height="15" ></div><%
			} else {
				%><div dojoType="fw.dijit.UIActionImage" id='switchToList' src="js/fw/images/ui/ui/search/listView.png" clickImage="false" hoverImage="false" disabledImage="false" alt='<xlat:stream key="UI/Search/ListView"/>' title='<xlat:stream key="UI/Search/ListView"/>' width="18" height="15" ></div>
				<div dojoType="fw.dijit.UIActionImage" src="js/fw/images/ui/ui/search/gridView.png" clickImage="false" hoverImage="false" disabledImage="false" alt='<xlat:stream key="UI/Search/ThumbnailView"/>' title='<xlat:stream key="UI/Search/ThumbnailView"/>' width="18" height="15" ></div><%
			}%>
			<!-- help button -->
			<controller:callelement elementname="UI/Layout/CenterPane/Search/View/SearchHelpText">
				<controller:argument name="assetTypeParam" value='<%=ics.GetVar("assetTypeParam")%>' />
			</controller:callelement>
			<!--  Close button --><%
			if (isClose) {
				%><div id='refreshDock' dojoType="fw.dijit.UIActionImage" src="js/fw/images/ui/ui/search/refresh.png" clickImage="false" hoverImage="false" disabledImage="false" width="21" height="15" alt='<xlat:stream key="UI/Forms/Refresh"/>' title='<xlat:stream key="UI/Forms/Refresh"/>'></div>
				<div id='closeDock' dojoType="fw.dijit.UIActionImage" src="js/fw/images/ui/ui/search/closeIcon.png" clickImage="false" hoverImage="false" disabledImage="false" width="15" height="15" alt='<xlat:stream key="fatwire/Alloy/UI/Close"/>' title='<xlat:stream key="fatwire/Alloy/UI/Close"/>'></div><%
			}
	%></div>
</div><%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%></cs:ftcs>