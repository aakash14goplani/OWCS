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
<ics:listget listname="assetlist" fieldname="#numRows" output="count" />
<%
int total = Utilities.goodString(ics.GetVar("count")) ? Integer.parseInt(ics.GetVar("count")) : 0;
int nbItems = (total % 2==0 ? total/2 : total/2+1);
%>
<div class="two-column">
	<ics:if condition='<%=ics.GetVar("ArticleName")!=null%>'>
		<ics:then>
			<h2 class="title"><%=ics.GetVar("ArticleName")%> Articles</h2>
		</ics:then>
	</ics:if>	
	<div class="post-wrapper" style="display:inline-block">
		<ics:listloop listname="assetlist" maxrows="1">
			<ics:listget listname="assetlist" fieldname="assetid" output="assetid" />
			<ics:listget listname="assetlist" fieldname="assettype" output="assettype" />
			<div class="post">
				<render:calltemplate tname="Summary/Feature" c='<%=ics.GetVar("assettype") %>' cid='<%=ics.GetVar("assetid") %>' />
			</div>
		</ics:listloop>
	</div>
	<div class="post-wrapper" style="display:inline-block">
		<ics:listloop listname="assetlist" maxrows="1" startrow="2">
			<ics:listget listname="assetlist" fieldname="assetid" output="assetid" />
			<ics:listget listname="assetlist" fieldname="assettype" output="assettype" />
			<div class="post">
				<render:calltemplate tname="Summary/Feature" c='<%=ics.GetVar("assettype") %>' cid='<%=ics.GetVar("assetid") %>' />
			</div>
		</ics:listloop>
	</div>
	<div style="clear: both"></div>
</div>
<div class="post-wrapper">
	<ics:listloop listname="assetlist"  startrow='3' maxrows ='<%=String.valueOf(nbItems - 1) %>'>
		<ics:listget listname="assetlist" fieldname="assetid" output="assetid" />
		<ics:listget listname="assetlist" fieldname="assettype" output="assettype" />
		<div class="post">
			<render:calltemplate tname="Summary" c='<%=ics.GetVar("assettype") %>' cid='<%=ics.GetVar("assetid") %>' />
		</div>
	</ics:listloop>
</div>
<div class="post-wrapper">
	<ics:listloop listname="assetlist" startrow='<%=String.valueOf(nbItems + 2) %>'>
		<ics:listget listname="assetlist" fieldname="assetid" output="assetid" />
		<ics:listget listname="assetlist" fieldname="assettype" output="assettype" />
		<div class="post">
			<render:calltemplate tname="Summary" c='<%=ics.GetVar("assettype") %>' cid='<%=ics.GetVar("assetid") %>' />
		</div>
	</ics:listloop>
</div>
</cs:ftcs>