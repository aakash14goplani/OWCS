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

<assetset:setasset name="ProductParentSet" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>' />

<render:lookup key="ProductAttrType" varname="ProductAttrType" />
<%-- Look up which field to render based on the subtype --%>
<asset:getsubtype type='<%=ics.GetVar("c")%>' objectid='<%=ics.GetVar("cid")%>'/>

<%
String subtype = ics.GetVar("subtype"); // never null if data is valid
%>

<render:lookup key="CategoryLinkAttr" varname="Category" match=":x" />
<%		
String CategoryLinkAttr = ics.GetVar("Category");
if (CategoryLinkAttr.equals(subtype+"Name"))
{
	%><ics:setvar name="LinkAttrName" value='<%=ics.GetVar("Category")%>' /><%
}
%>

<render:lookup key="SubcategoryLinkAttr" varname="Subcategory" match=":x" />
<%		
String SubcategoryLinkAttr = ics.GetVar("Subcategory");
if (SubcategoryLinkAttr.equals(subtype+"Name"))
{
	%><ics:setvar name="LinkAttrName" value='<%=ics.GetVar("Subcategory")%>' /><%
}
%>

<render:lookup key="ManufacturerLinkAttr" varname="Manufacturer" match=":x" />
<%		
String ManufacturerLinkAttr = ics.GetVar("Manufacturer");
if (ManufacturerLinkAttr.equals(subtype+"Name"))
{
	%><ics:setvar name="LinkAttrName" value='<%=ics.GetVar("Manufacturer")%>' /><%
}
%>

<assetset:getattributevalues 
          name="ProductParentSet" 
          attribute='<%=ics.GetVar("LinkAttrName")%>' 
          listvarname="NameList" 
          typename='<%=ics.GetVar("ProductAttrType")%>' 
          />

<title><string:stream variable="site"/>: <string:stream list='NameList' column="value" /></title>

</cs:ftcs>