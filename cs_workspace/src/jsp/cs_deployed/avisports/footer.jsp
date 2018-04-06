<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><cs:ftcs>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/>
<p>Copyright 2000-2013 by AviSports. All rights reserved.</p>
<ics:callelement element="avisports/Page/GoToMobileSiteLink" />
</cs:ftcs>
