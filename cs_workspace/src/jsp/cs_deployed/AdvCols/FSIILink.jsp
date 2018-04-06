<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><cs:ftcs>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>'   c="Template"/></ics:then></ics:if>
<asset:load name="a" type='<%=ics.GetVar("c")%>' objectid='<%=ics.GetVar("cid")%>'/>
<asset:get name='a' field='description'/>
<render:lookup varname="LayoutVar" key="Layout" />
<render:lookup varname="WrapperVar" key="Wrapper" />
<render:gettemplateurl outstr="aUrl" args="c,cid,p" tname='<%=ics.GetVar("LayoutVar")%>' wrapperpage='<%=ics.GetVar("WrapperVar")%>' />
<a href='<string:stream variable="aUrl"/>'><string:stream variable='description'/></a>
</cs:ftcs>