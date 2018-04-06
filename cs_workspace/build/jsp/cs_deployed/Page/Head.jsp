<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><cs:ftcs>
<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
<assetset:setasset name="page" type='<%=ics.GetVar("c") %>' id='<%=ics.GetVar("cid") %>' />
<assetset:getattributevalues name="page" attribute="metaTitle" listvarname="metaTitle" typename="PageAttribute" />
<assetset:getattributevalues name="page" attribute="metaDescription" listvarname="metaDescription" typename="PageAttribute" />
<title><ics:listget listname="metaTitle" fieldname="value" /></title>
<meta name="description" content='<ics:listget listname="metaDescription" fieldname="value" />' />
</cs:ftcs>