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
			<field id="siteplan">
				<fieldname>siteplan</fieldname>
				<displayname><xlat:stream key="dvin/UI/SitePlan" escape="true"/></displayname>
				<displayintooltip>true</displayintooltip>
			</field>
			<field id="updateddate">
				<fieldname>updateddate</fieldname>
				<displayname><xlat:stream key="dvin/Common/Modified" escape="true"/></displayname>
				<displayintooltip>true</displayintooltip>
				<dateformat>MM/dd/yyyy hh:mm a z </dateformat>
			</field>
			<field id="locale">
				<fieldname>locale</fieldname>
				<displayname><xlat:stream key="dvin/UI/Admin/Locale" escape="true"/></displayname>
				<displayintooltip>true</displayintooltip>
			</field>
		</fields>
		<assettypes>
			<assettype id="Media_C">
				<type>Media_C</type>
				<subtype></subtype>
				<element>UI/Layout/CenterPane/Search/View/ImageThumbnail</element>
				<attribute>FSII_ImageFile</attribute>
			</assettype>
		</assettypes>
	</thumbnailviewconfig>
</cs:ftcs>