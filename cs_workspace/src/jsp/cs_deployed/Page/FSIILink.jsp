<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><cs:ftcs><ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>

<%-- Load the page so we can display its description in the link --%>
<asset:load name="a" type="Page" objectid='<%=ics.GetVar("cid")%>'/>

<%-- Look up the tname for the wrapper SiteEntry and Layout template --%>
<render:lookup key="Wrapper" match=":x" varname="WrapperVar" />
<render:lookup key="Layout" varname="LayoutVar" />
<render:gettemplateurl outstr="aUrl" args="c,cid,p" tname='<%=ics.GetVar("LayoutVar")%>' wrapperpage='<%=ics.GetVar("WrapperVar")%>' />

<%-- finally, render the link.  Add an id for style purposes. --%>
<asset:get name="a" field="description"/>
<a href="<string:stream variable="aUrl"/>" id="<string:stream variable="a-id-prefix"/>-PageLink-<string:stream variable="cid"/>"><string:stream variable="description"/></a>
</cs:ftcs>