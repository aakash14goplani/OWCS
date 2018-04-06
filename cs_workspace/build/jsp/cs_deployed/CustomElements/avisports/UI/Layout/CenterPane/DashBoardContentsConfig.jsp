<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// UI/Layout/CenterPane/DashBoardContentsConfig
//
// INPUT
//
// OUTPUT
//%>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<!-- IMPORTANT : If any changes in this configuration to be effective in is important to clear browser cache.  -->
<cs:ftcs>
	<dashboardconfig>
		
	    <dashboardlayout>
	    	<numberofcolumns>2</numberofcolumns>
	    	<columnwidths>50,50</columnwidths>
	    </dashboardlayout>
	    
		<components>
			<!-- a unique identifier for the component, this should be unique among all the components,
				it is mandatory, it can be alpha numeric but no special characters allowed -->
			<component id="bookmark">
				<name><xlat:stream key="UI/UC1/Layout/Bookmarks" escape="true"/></name>
				<url>UI/Layout/CenterPane/DashBoard/Bookmarks</url>
				<height>300px</height>
				<closable>false</closable>
				<open>true</open>
				<dragRestriction>false</dragRestriction>
				<style>bookmarkPortlet</style>
				<column>1</column>
			</component>
			<!-- a unique identifier for the component, this should be unique among all the components,
				it is mandatory, it can be alpha numeric but no special characters allowed -->
			<component id="smartlist">
				<name><xlat:stream key="dvin/UI/SavedSearches" escape="true"/></name>
				<url>UI/Layout/CenterPane/DashBoard/SmartList</url>
				<height>300px</height>
				<closable>false</closable>
				<open>true</open>
				<dragRestriction>false</dragRestriction>
				<style>smartListPortlet</style>
				<column>2</column>
			</component>
			<!-- a unique identifier for the component, this should be unique among all the components,
				it is mandatory, it can be alpha numeric but no special characters allowed -->
			<component id="assignments">
				<name><xlat:stream key="dvin/UI/Assignments" escape="true"/></name>
				<url>UI/Layout/CenterPane/DashBoard/Workflow</url>
				<height>300px</height>
				<closable>false</closable>
				<open>true</open>
				<dragRestriction>false</dragRestriction>
				<style>assignmentPortlet</style>
				<column>1</column>
			</component>
			<!-- a unique identifier for the component, this should be unique among all the components,
				it is mandatory, it can be alpha numeric but no special characters allowed -->
			<component id="checkouts">
				<name><xlat:stream key="dvin/UI/Checkouts" escape="true"/></name>
				<url>UI/Layout/CenterPane/DashBoard/Checkouts</url>
				<height>300px</height>
				<closable>false</closable>
				<open>true</open>
				<dragRestriction>false</dragRestriction>
				<style>checkoutPortlet</style>
				<column>2</column>
			</component>
		</components>
		
	</dashboardconfig>
</cs:ftcs>