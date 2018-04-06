<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%>
<cs:ftcs>
<%
/*
This oob configuration element reuses the UI/Layout/CenterPane/Search/View/ThumbnailViewConfig element 
so is the ics:callelement call here.
In case of customization, override this element under CustomElements to have your custom configuration.
If one has customized UI/Layout/CenterPane/Search/View/ThumbnailViewConfig and wants to use the same for 
docked version then have your DockedThumbnailViewConfig call your custom element for example
	<ics:callelement element="CustomElements/.../UI/Layout/CenterPane/Search/View/ThumbnailViewConfig">
	</ics:callelement>
*/
%>
	<ics:callelement element="UI/Layout/CenterPane/Search/View/ThumbnailViewConfig">
	</ics:callelement>	
</cs:ftcs>