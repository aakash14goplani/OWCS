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
		<fields id="name">
			<field>
				<fieldname>name</fieldname>
				<displayname><xlat:stream key="dvin/Common/Name" escape="true"/></displayname>
				<displayintooltip>true</displayintooltip>
			</field>
			<field id="siteplan">
				<fieldname>siteplan</fieldname>
				<displayname><xlat:stream key="dvin/UI/SitePlan" escape="true"/></displayname>
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
			<assettype id="AVIImage_ArticleImage">
				<type>AVIImage</type>
				<subtype>ArticleImage</subtype>
				<element>UI/Layout/CenterPane/Search/View/ImageThumbnail</element>
				<attribute>smallThumbnail</attribute>
			</assettype>
			<assettype id="AVIImage_Image">
				<type>AVIImage</type>
				<subtype>Image</subtype>
				<element>UI/Layout/CenterPane/Search/View/ImageThumbnail</element>
				<attribute>imageFile</attribute>
			</assettype>
		</assettypes>
	</thumbnailviewconfig>
</cs:ftcs>