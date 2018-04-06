<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><cs:ftcs>
<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
<render:callelement elementname="avisports/AVIArticle/GetLink" scoped="global" />
<a href="<ics:getvar name="articleUrl" />">Read More</a>
</cs:ftcs>