<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><cs:ftcs>
<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
<assetset:setasset name="article" type='<%=ics.GetVar("c") %>' id='<%=ics.GetVar("cid") %>' />
<assetset:getattributevalues name="article" attribute="headline" listvarname="headline" typename="ContentAttribute" />
<assetset:getattributevalues name="article" attribute="subheadline" listvarname="subheadline" typename="ContentAttribute" />
<title><ics:listget listname="headline" fieldname="value" /></title>
<meta name="description" content='<ics:listget listname="subheadline" fieldname="value" />' />
</cs:ftcs>