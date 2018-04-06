<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><cs:ftcs>
	<listviewconfig>
		<numberofitems>1000</numberofitems>
		<numberofitemsperpage>100</numberofitemsperpage>
		<!-- the system default sort is  by relevance, configure the following if need to sort other than relevance by default-->
		<defaultsortfield></defaultsortfield>
		<defaultsortorder></defaultsortorder>
		<!-- following is the pagination page step size configuration for the grid -->
		<pagestepsize>"10", "25", "50", "100", "<xlat:stream key='dvin/Common/All' escape='true'/>"</pagestepsize>
		
		<!-- From the field definition below only the first field is displayed in the docked version 
		and the rest are displayed as part of tooltip  if the displayinttoltip element is true-->
		<fields>
			<field id="name">
				<fieldname>name</fieldname>
				<displayname><xlat:stream key="dvin/AT/Common/Name"/></displayname>
				<width>350px</width>
				<formatter>fw.ui.GridFormatter.nameFormatter</formatter>
				<displayintooltip>true</displayintooltip>
			</field>
			<field id="AssetType_Description">
				<fieldname>AssetType_Description</fieldname>
				<displayname><xlat:stream key="dvin/Common/Type"/></displayname>
				<width>200px</width>
				<formatter></formatter>
				<displayintooltip>true</displayintooltip>
			</field>
			<!-- locale field will be displayed only if the site is dimension enabled -->
			<field id="locale">
				<fieldname>locale</fieldname>
				<displayname><xlat:stream key="dvin/UI/Admin/Locale"/></displayname>
				<width>120px</width>
				<formatter></formatter>
				<displayintooltip>true</displayintooltip>
			</field>
			
			<field id="updateddate">
				<fieldname>updateddate</fieldname>
				<displayname><xlat:stream key="dvin/Common/Modified"/></displayname>
				<!-- dateformat is  an option to specify custom date format. This should be a valid java date format string 
				 If there is any dateformat string specified here it will be used to format the	date.-->
				<!-- <dateformat>MM/dd/yyyy hh:mm a z </dateformat> -->
				
				<!-- javadateformat will be used if there is no dataformat element present.
				Valid values are SHORT, MEDIUM, LONG and FULL. Again if this element is not present or no value specified,
				system uses SHORT by default. -->
				<javadateformat>SHORT</javadateformat>
				
				<!--
				It is preferred to have "auto" for the last field. 
				Making it "auto" is to adjust any space left over by other 
				fields so that the grid renders well.
				-->
				<width>160px</width>
				<formatter></formatter>
				<displayintooltip>true</displayintooltip>
			</field>
			<field id="tags">
				<fieldname>tags</fieldname>
				<displayname><xlat:stream key="UI/UC1/Layout/Tags"/></displayname>
				<width>auto</width>
				<formatter>fw.ui.GridFormatter.tagFormatter</formatter>
				<displayintooltip>true</displayintooltip>
			</field>
			<field id="siteplan">
				<fieldname>siteplan</fieldname>
				<displayname><xlat:stream key="dvin/UI/SitePlan"/></displayname>
				<width>auto</width>
				<formatter>fw.ui.GridFormatter.sitePlanFormatter</formatter>
				<displayintooltip>true</displayintooltip>
			</field>
		</fields>
	</listviewconfig>
</cs:ftcs>
