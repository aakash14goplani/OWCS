<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors"
%><cs:ftcs><%-- AVIImage/Detail_NonTouch

INPUT

OUTPUT

--%>
<%-- Record dependencies for the Template --%>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>
<assetset:setasset name="image" type="AVIImage" id='<%=ics.GetVar("cid") %>' />
<assetset:getmultiplevalues name="image" prefix="image" immediateonly="true">
	<assetset:sortlistentry attributename="imageFile" attributetypename="ContentAttribute" />
	<assetset:sortlistentry attributename="caption" attributetypename="ContentAttribute" />
	<assetset:sortlistentry attributename="width" attributetypename="ContentAttribute" />
	<assetset:sortlistentry attributename="height" attributetypename="ContentAttribute" />
	<assetset:sortlistentry attributename="alternateText" attributetypename="ContentAttribute" />
</assetset:getmultiplevalues>
<render:getbloburl outstr="imageUrl" c="AVIImage" cid='<%=ics.GetVar("cid") %>' field="imageFile" />
<img src="<string:stream variable="imageUrl" />" alt="<ics:listget listname="image:alternateText" fieldname="value" />" />
</cs:ftcs>