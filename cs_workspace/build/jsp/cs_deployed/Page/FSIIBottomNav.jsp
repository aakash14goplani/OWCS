<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld" 
%><cs:ftcs>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>
<p>Copyright (c) 2012, Oracle and/or its affiliates. All rights reserved.</p>
</cs:ftcs>