<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
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

<render:lookup varname="LayoutVar" key="Layout" />
<render:lookup varname="WrapperVar" key="Wrapper" match=":x"/>
<render:gettemplateurl outstr="aUrl" args="c,cid,p" tname='<%=ics.GetVar("LayoutVar")%>' wrapperpage='<%=ics.GetVar("WrapperVar")%>' />
<a href='<string:stream variable="aUrl"/>'><string:stream list='HeadlineList' column="value" /></a>
</cs:ftcs>