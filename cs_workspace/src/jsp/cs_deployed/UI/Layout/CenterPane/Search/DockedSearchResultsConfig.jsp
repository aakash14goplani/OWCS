<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><cs:ftcs>
<dockedsearchconfig>
	<!-- out of the box search docked view elements -->
	<dockedlistview>UI/Layout/CenterPane/Search/View/DockedListView</dockedlistview>
	<dockedthumbnailview>UI/Layout/CenterPane/Search/View/DockedThumbnailView</dockedthumbnailview>
	
	<!-- configure this attribute, to have one of the above defined views as default docked view-->
	<defaultview>dockedlistview</defaultview>
	
	<assettypeviews>
		<!-- configure this attribute to have one of the above defined views as default docked view for a particular asset type. This
		choice will apply for the very first time and stays until user switches to different view -->
		<assettype id="Page" name="Page">dockedlistview</assettype>
	</assettypeviews>
</dockedsearchconfig>
</cs:ftcs>