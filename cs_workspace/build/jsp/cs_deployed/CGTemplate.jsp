<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="cg" uri="futuretense_cs/cg.tld"%>
<cs:ftcs>
<cg:render id='<%=ics.GetVar("cid")%>' type='<%=ics.GetVar("c")%>'/>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>
</cs:ftcs>