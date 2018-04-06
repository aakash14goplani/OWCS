<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<cs:ftcs>
<searchconfig>
	<!-- out of the box search view elements -->
	<listview>UI/Layout/CenterPane/Search/View/ListView</listview>
	<thumbnailview>UI/Layout/CenterPane/Search/View/ThumbnailView</thumbnailview>
	
	<!-- configure this attribute, to have one of the above defined views as default view-->
	<defaultview>listview</defaultview>
	
	<assettypeviews>
		<!-- configure this attribute to have one of the above defined views as default view for a particular asset type. This
		choice will apply for the very first time and stays until user switches to different view -->
		<assettype id="Page" name="Page">listview</assettype>
	</assettypeviews>
</searchconfig>
</cs:ftcs>