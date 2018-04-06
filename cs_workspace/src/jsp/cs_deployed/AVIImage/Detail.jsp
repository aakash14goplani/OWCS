<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><cs:ftcs><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
<assetset:setasset name="image" type="AVIImage" id='<%=ics.GetVar("cid") %>' />
<assetset:getmultiplevalues name="image" prefix="image" immediateonly="true">
	<assetset:sortlistentry attributename="imageFile" attributetypename="ContentAttribute" />
	<assetset:sortlistentry attributename="caption" attributetypename="ContentAttribute" />
	<assetset:sortlistentry attributename="width" attributetypename="ContentAttribute" />
	<assetset:sortlistentry attributename="height" attributetypename="ContentAttribute" />
	<assetset:sortlistentry attributename="alternateText" attributetypename="ContentAttribute" />
</assetset:getmultiplevalues>
<render:getbloburl outstr="imageUrl" c="AVIImage" cid='<%=ics.GetVar("cid") %>' field="imageFile" />
<img src="<string:stream variable="imageUrl" />" alt="<ics:listget listname="image:alternateText" fieldname="value" />" 
		width="<ics:listget listname="image:width" fieldname="value" />" 
		height="<ics:listget listname="image:height" fieldname="value" />" />
<div class="caption"><insite:edit field="caption" list="image:caption" column="value" 
									params="{noValueIndicator: 'Enter Image Caption'}"/></div>
</cs:ftcs>