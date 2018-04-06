<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><%@ page import="com.fatwire.ui.util.SearchUtil"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><cs:ftcs>
	<div class="container">
		<div class="menu">
			<div class="item logoWebCenterSites"></div>
			<div data-dojo-type="fw.dijit.UIMenuBar" id="wemmenu"></div>
		</div>
	</div>
	<div id="searchBoxContainer" class="searchBoxContainer">
		<div class="searchBoxLeft"></div>
		<div class="searchBoxContent">
			<input type="text" data-dojo-type="fw.dijit.UIInput" data-dojo-props="'class': 'searchTextBox',
				id: 'searchBox',
				placeHolder: '<xlat:stream key="dvin/Common/Search" escape="true"/>',
				clearButton: true,
				searchObject: {
					placeHolderText: '<xlat:stream key="dvin/Common/Search" escape="true"/>',
					item: '<%=SearchUtil.ALL%>'
				}" />
			<span id="searchTypeMenu" class="typeIcon"></span>
			<div id="searchBtn" dojoType="fw.dijit.UIActionImage" disabledImage="false" src="js/fw/images/ui/ui/search/searchButton.png" width="32" height="29" alt='<xlat:stream key="dvin/Common/Search"/>' title='<xlat:stream key="dvin/Common/Search"/>' class="searchButton"></div>
		</div>
		<div class="searchBoxRight"></div>
	</div>
	<div class="toolbarExtn">
		<div class="toolbarContent">
			<div id="extButtons" class="toolbarExtnButtons">
				<div id="deviceBtn" class="buttons" dojoType="fw.ui.dijit.FlexibleButton" alt='<xlat:stream key="dvin/UI/MobilitySolution/ToolBar/ToggleSkinWidget"/>' title='<xlat:stream key="dvin/UI/MobilitySolution/ToolBar/ToggleSkinWidget"/>' name='skin-widget' style="display:none;" /></div>
				<div id="refreshBtn" class="buttons" dojoType="fw.ui.dijit.FlexibleButton" alt='<xlat:stream key="dvin/TreeApplet/Commands/RefreshDisplay"/>' title='<xlat:stream key="dvin/TreeApplet/Commands/RefreshDisplay"/>' name='refresh' style="display:none;" /></div>
			</div>
		</div>
		<div class="toolbarBorder"></div>
	</div>
</cs:ftcs>
