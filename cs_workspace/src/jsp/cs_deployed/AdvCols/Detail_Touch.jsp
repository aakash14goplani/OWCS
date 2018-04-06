<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><cs:ftcs>
<ics:if condition='<%=ics.GetVar("tid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("tid")%>' c="Template"/></ics:then></ics:if>

<asset:list type="AdvCols" list="AdvColsList" field1="id" value1='<%=ics.GetVar("cid") %>' />
<ics:listget listname="AdvColsList" fieldname="name" output="recName" />
<commercecontext:getrecommendations collection='<%=ics.GetVar("recName") %>' listvarname="assetlist" />

<div class="post-wrapper">
	<ics:listloop listname="assetlist">
		<ics:listget listname="assetlist" fieldname="assetid" output="assetid" />
		<ics:listget listname="assetlist" fieldname="assettype" output="assettype" />
		<div class="post">
			<render:calltemplate tname="Summary" c='<%=ics.GetVar("assettype") %>' cid='<%=ics.GetVar("assetid") %>' />
		</div>
	</ics:listloop>
</div>
</cs:ftcs>