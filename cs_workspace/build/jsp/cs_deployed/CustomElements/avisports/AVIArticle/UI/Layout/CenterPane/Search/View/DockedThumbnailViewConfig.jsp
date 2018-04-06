<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<cs:ftcs>
	<thumbnailviewconfig>
		<numberofitems>1000</numberofitems>
		<!-- configure the following if need to sort other than relevance by default-->
		<defaultsortfield></defaultsortfield>
		<defaultsortorder></defaultsortorder>
		<numberofitemsperpage>10</numberofitemsperpage>
		<formatter>fw.ui.GridFormatter.thumbnailFormatter</formatter>
		
		<!-- Below are the fields to display for each thumbnail image -->
		<!-- From the column definition below only the first column is displayed in the docked version 
		and the rest are displayed as part of tooltip  if the displayinttoltip element is true-->
		<fields>
			<field id="name">
				<fieldname>name</fieldname>
				<displayname><xlat:stream key="dvin/Common/Name" escape="true"/></displayname>
				<displayintooltip>true</displayintooltip>
			</field>
			<field id="category">
				<fieldname>category</fieldname>
				<displayname>Category</displayname>
				<displayintooltip>true</displayintooltip>
			</field>
			<field id="updateddate">
				<fieldname>updateddate</fieldname>
				<displayname><xlat:stream key="dvin/Common/Modified" escape="true"/></displayname>
				<displayintooltip>true</displayintooltip>
				<dateformat>dd MMM yyyy HH:mm</dateformat>
			</field>
		</fields>
		<assettypes>
			<assettype id="AVIArticle">
				<type>AVIArticle</type>
				<subtype></subtype>
				<element>UI/Layout/CenterPane/Search/View/GlobalThumbnail</element>
			</assettype>
		</assettypes>
	</thumbnailviewconfig>
</cs:ftcs>