<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   COM.FutureTense.Util.ftErrors"
%><cs:ftcs><%--

INPUT

OUTPUT

--%>
<%-- Record dependencies for the Template --%>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>

<asset:load name="P" type='<%=ics.GetVar("c") %>' objectid='<%=ics.GetVar("cid") %>'/>
<asset:scatter name="P" prefix="my"/>
<ics:getvar name="my:name"/>

<assetset:setasset name="P1" type='<%=ics.GetVar("c") %>' id='<%=ics.GetVar("cid") %>'/>

<assetset:getattributevalues name="P1" listvarname="op1" attribute="headline" typename="Article_A"/>
<assetset:getattributevalues name="P1" listvarname="op2" attribute="subheadline" typename="Article_A"/>


<ics:listloop listname="op1">
<ics:listget fieldname="value" listname="op1"/>
</ics:listloop>


<ics:listloop listname="op2">
<ics:listget fieldname="value" listname="op2"/>
</ics:listloop>

<assetset:getmultiplevalues name="P1" prefix="pp">
	<assetset:sortlistentry attributetypename="Article_A" attributename="postDate" />
	<assetset:sortlistentry attributetypename="Article_A" attributename="author" />
</assetset:getmultiplevalues>

<ics:listloop listname="pp:postDate">
<ics:listget fieldname="value" listname="pp:postDate"/>
</ics:listloop>

<ics:listloop listname="pp:author">
<ics:listget fieldname="value" listname="pp:author"/>
</ics:listloop>


</cs:ftcs>
