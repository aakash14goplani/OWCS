<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"%>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"%>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld"%>
<cs:ftcs>
	<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>
	<assetset:setasset name="image" type="AVIImage" id='<%=ics.GetVar("cid") %>' />
	<assetset:getmultiplevalues name="image" prefix="image" immediateonly="true">
		<assetset:sortlistentry attributename='largeThumbnail' attributetypename="ContentAttribute" />
		<assetset:sortlistentry attributename="alternateText" attributetypename="ContentAttribute" />
	</assetset:getmultiplevalues>
	<render:getbloburl outstr="imageUrl" c="AVIImage" cid='<%=ics.GetVar("cid") %>' field='largeThumbnail' />
	<img src="<string:stream variable="imageUrl" />" class="<ics:getvar name="thumbnail" />" width='100%' alt="<ics:listget listname="image:alternateText" fieldname="value" />" />
</cs:ftcs>




