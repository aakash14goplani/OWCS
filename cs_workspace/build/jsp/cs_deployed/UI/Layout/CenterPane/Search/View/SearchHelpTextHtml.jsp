<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<cs:ftcs>
	<img id="searchHelpIcon" class="searchHelpIcon" src="js/fw/images/ui/ui/search/helpIcon.png" alt="Help" title="" width="12" height="15" />
		<div data-dojo-type="fw.ui.dijit.HoverableTooltip" data-dojo-props="connectedNodes:'searchHelpIcon', position:'below','class':'searchHelpTextTooltip'">
			<xlat:stream key="UI/UC1/Layout/SearchHelpText" escape="false" encode="false"/>
		</div>
</cs:ftcs>