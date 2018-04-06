<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><cs:ftcs>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>

<assetset:setasset name="ProductSet" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>' />

<render:lookup key="ProductAttrType" varname="ProductAttrType" />
<render:lookup key="NameAttrName" match=":x" varname="NameAttrName" />
<assetset:getattributevalues 
          name="ProductSet" 
          attribute='<%=ics.GetVar("NameAttrName")%>' 
          listvarname="NameList" 
          typename='<%=ics.GetVar("ProductAttrType")%>' 
          />

<title><string:stream variable="site"/>: <string:stream list='NameList' column="value" /></title>
</cs:ftcs>