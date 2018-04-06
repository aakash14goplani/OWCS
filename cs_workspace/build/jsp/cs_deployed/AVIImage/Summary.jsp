<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><cs:ftcs><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
<assetset:setasset name="image" type="AVIImage" id='<%=ics.GetVar("cid") %>' />
<assetset:getmultiplevalues name="image" prefix="image" immediateonly="true">
	<assetset:sortlistentry attributename='<%=ics.GetVar("thumbnail-field") %>' attributetypename="ContentAttribute" />
	<assetset:sortlistentry attributename="alternateText" attributetypename="ContentAttribute" />
</assetset:getmultiplevalues>
<render:getbloburl outstr="imageUrl" c="AVIImage" cid='<%=ics.GetVar("cid") %>' field='<%=ics.GetVar("thumbnail-field") %>' />
<img class="photo <ics:getvar name="thumbnail" />" src="<string:stream variable="imageUrl" />" alt="<ics:listget listname="image:alternateText" fieldname="value" />" />
</cs:ftcs>