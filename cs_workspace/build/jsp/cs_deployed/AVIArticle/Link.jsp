<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><cs:ftcs>
<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
<assetset:setasset name="article" type="AVIArticle" id='<%=ics.GetVar("cid") %>' />
<assetset:getattributevalues name="article" attribute="headline" listvarname="headline" typename="ContentAttribute" />
<render:callelement elementname="avisports/AVIArticle/GetLink" scoped="global" />
<a href="<ics:getvar name="articleUrl" />"><ics:listget listname="headline" fieldname="value" /></a>
</cs:ftcs>