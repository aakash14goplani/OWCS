<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><cs:ftcs>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>

<assetset:setasset name="ArticleSet" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>' />

<render:lookup key="ContentAttrType" varname="ContentAttrType" />
<render:lookup key="HeadlineAttrName" match=":x" varname="HeadlineAttrName" />
<assetset:getattributevalues 
          name="ArticleSet" 
          attribute='<%=ics.GetVar("HeadlineAttrName")%>' 
          listvarname="HeadlineList" 
          typename='<%=ics.GetVar("ContentAttrType")%>' 
          />

<title><string:stream variable="site"/>: <string:stream list='HeadlineList' column="value" /></title>

</cs:ftcs>