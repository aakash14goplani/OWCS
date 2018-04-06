<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><cs:ftcs><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/>
<asset:list list="asset" excludevoided="true" type="YouTube" field1='id' value1='<%=ics.GetVar("cid") %>'/>
<ics:listget listname="asset" fieldname="externalid" output="videoId" />
<iframe id="ytplayer" type="text/html" width="610" height="343"
  src="http://www.youtube.com/embed/<ics:getvar name="videoId"/>"
  frameborder="0"></iframe>
</cs:ftcs>