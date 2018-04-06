<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><cs:ftcs><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
<render:calltemplate tname="Summary/SideBar" args="c,cid" style="element" />
</cs:ftcs>