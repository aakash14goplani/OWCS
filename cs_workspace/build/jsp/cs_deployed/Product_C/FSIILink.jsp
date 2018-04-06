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

<assetset:setasset name="ProductSet" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>' />

<render:lookup key="ProductAttrType" varname="ProductAttrType" />
<render:lookup key="NameAttrName" match=":x" varname="NameAttrName" />
<assetset:getattributevalues name="ProductSet" attribute='<%=ics.GetVar("NameAttrName")%>' listvarname="NameList" typename='<%=ics.GetVar("ProductAttrType")%>' />
<render:lookup varname="LayoutVar" key="Layout" />
<render:lookup varname="WrapperVar" key="Wrapper" match=":x"/>
<render:gettemplateurl outstr="aUrl" args="c,cid,p" tname='<%=ics.GetVar("LayoutVar")%>' wrapperpage='<%=ics.GetVar("WrapperVar")%>' />
<a href='<string:stream variable="aUrl"/>'><string:stream list='NameList' column="value" /></a>
</cs:ftcs>