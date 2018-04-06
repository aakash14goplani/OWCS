<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="insite" uri="futuretense_cs/insite.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ page import="java.util.*, java.text.*, java.io.*"
%><cs:ftcs>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>'   c="Template"/></ics:then></ics:if>
<assetset:setasset name="ProductParentSet" type='<%=ics.GetVar("c")%>' id='<%=ics.GetVar("cid")%>' />

<render:lookup key="ProductAttrType" varname="ProductAttrType" />
<%-- Look up which field to render based on the subtype --%>
<asset:getsubtype type='<%=ics.GetVar("c")%>' objectid='<%=ics.GetVar("cid")%>'/>
<%
String subtype = ics.GetVar("subtype"); // never null if data is valid
String keyname = subtype+"LinkAttr";
String sitepfx = ics.GetVar("sitepfx");
int i = subtype.indexOf(sitepfx);
if (i == 0)
{
    // replication may have added the prefix to the name Strip it as we don't use it in the key.
	keyname = subtype.substring(sitepfx.length())+"LinkAttr";
	keyname = keyname.trim(); // manual prefixing sometimes includes a space between pfx and name.
}
%> 
<render:lookup key='<%=keyname%>' varname="LinkAttrName" match=":x" />
<assetset:getattributevalues 
          name="ProductParentSet" 
          attribute='<%=ics.GetVar("LinkAttrName")%>' 
          listvarname="NameList" 
          typename='<%=ics.GetVar("ProductAttrType")%>' 
          />

<listobject:create name="inputListName" columns="assetid,assettype" />
	<listobject:addrow name="inputListName">
		<listobject:argument name="assetid" value='<%=ics.GetVar("cid")%>' />
		<listobject:argument name="assettype" value='<%=ics.GetVar("c")%>' />
	</listobject:addrow>
<listobject:tolist name="inputListName" listvarname="assetInputList" />
<asset:filterassetsbydate inputList="assetInputList" outputList="assetOutputList" date='<%=ics.GetSSVar("__insiteDate")%>' />

<ics:if condition='<%=ics.GetList("assetOutputList")!=null && ics.GetList("assetOutputList").hasData()%>' >
<ics:then>
	<ics:listget listname="assetOutputList" fieldname="assetid" output="cid" />
	<ics:listget listname="assetOutputList" fieldname="assettype" output="c" />
	  
	<render:lookup varname="LayoutVar" key="Layout" />
	<render:lookup varname="WrapperVar" key="Wrapper" match=":x"/>
	<render:gettemplateurl outstr="aUrl" args="c,cid,p" tname='<%=ics.GetVar("LayoutVar")%>' wrapperpage='<%=ics.GetVar("WrapperVar")%>' />
	<a href='<string:stream variable="aUrl"/>'><string:stream list='NameList' column="value" /></a>
</ics:then>
</ics:if>
</cs:ftcs>