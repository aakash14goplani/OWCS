<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="controller" uri="futuretense_cs/controller.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<cs:ftcs>
	<thumbnailviewconfig>
		<numberofitems>1000</numberofitems>
		<!-- the system default sort is  by relevance, configure the following if need to sort other than relevance by default-->
		<defaultsortfield></defaultsortfield>
		<defaultsortorder></defaultsortorder>
		<numberofitemsperpage>10</numberofitemsperpage>
		<formatter>fw.ui.GridFormatter.thumbnailFormatter</formatter>
		<!-- following is the pagination page step size configuration for the grid -->
		<pagestepsize>"10", "25", "50", "100", "<xlat:stream key='dvin/Common/All' escape='true'/>"</pagestepsize>
		
		<!-- Below are the fields to display for each thumbnail image -->
		<!-- From the column definition below only the first column is displayed in the docked version 
		and the rest are displayed as part of tooltip  if the displayinttoltip element is true-->
		<fields>
			<field id="name">
				<fieldname>name</fieldname>
				<displayname><xlat:stream key="dvin/Common/Name" escape="true"/></displayname>
				<displayintooltip>true</displayintooltip>
			</field>
			<field id="AssetType_Description">
				<fieldname>AssetType_Description</fieldname>
				<displayname><xlat:stream key="dvin/Common/Type" escape="true"/></displayname>
				<displayintooltip>true</displayintooltip>
			</field>
			<field id="updateddate">
				<fieldname>updateddate</fieldname>
				<displayname><xlat:stream key="dvin/Common/Modified" escape="true"/></displayname>
				<displayintooltip>true</displayintooltip>
				<!-- dateformat is  an option to specify custom date format. This should be a valid java date format string 
				 If there is any dateformat string specified here it will be used to format the	date.-->
				<!-- <dateformat>MM/dd/yyyy hh:mm a z </dateformat> -->
				
				<!-- javadateformat will be used if there is no dataformat element present. 
				Valid values are SHORT, MEDIUM, LONG and FULL. Again if this element is not present or no value specified,
				system uses SHORT by default -->
				<javadateformat>SHORT</javadateformat>
				
			</field>
			<!-- locale field will be displayed only if the site is dimension enabled -->
			<field id="locale">
				<fieldname>locale</fieldname>
				<displayname><xlat:stream key="dvin/UI/Admin/Locale" escape="true"/></displayname>
				<displayintooltip>true</displayintooltip>
			</field>
			<field id="siteplan">
				<fieldname>siteplan</fieldname>
				<displayname><xlat:stream key="dvin/UI/SitePlan" escape="true"/></displayname>
				<displayintooltip>true</displayintooltip>
			</field>
		</fields>
	</thumbnailviewconfig>
</cs:ftcs>
