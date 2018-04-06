<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><cs:ftcs><%-- This template displays the HTML HEAD tag content that is 
                specific to this asset and this asset only.  TITLE, and 
                KEYWORDS would be good things to render here, JavaScript and
                Cascading Style Sheets would not.  Shared items like these
                should be rendered in either the Layout template or a SiteEntry/
                CSElement combo that is called from the Layout template.
                
                This particular one just displays the site name then the
                description field of the current asset. --%>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>

<asset:load name="asset" type='<%=ics.GetVar("c")%>' objectid='<%=ics.GetVar("cid")%>'/>
<asset:get name="asset" field="description" output="description"/>
<title><string:stream variable="site"/>: <string:stream variable="description"/></title>

</cs:ftcs>