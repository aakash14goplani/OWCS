<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<!-- 
	Build the default template url for a given asset.
	INPUT: 	assetId - if not provided fall back to cid
			assetType - if not provided fall back to c
	OUTPUT: assetUrl
-->
<cs:ftcs>
<%
	if (null == ics.GetVar("assetId") || null == ics.GetVar("assetType"))
	{
		ics.SetVar("assetId", ics.GetVar("cid"));
		ics.SetVar("assetType", ics.GetVar("c"));
	}
	%>
		<asset:load name="asset"  type='<%=ics.GetVar("assetType")%>' objectid='<%=ics.GetVar("assetId")%>' />
		<asset:get name="asset" field="template" output="template" />
	<%
	if (null != ics.GetVar("template"))
	{
		%>
			<render:gettemplateurl	tname='<%= ics.GetVar("template")%>' 
									c='<%=ics.GetVar("assetType")%>' 
									cid='<%=ics.GetVar("assetId") %>'
									ttype="CSElement"
									outstr="_assetUrl" >
			</render:gettemplateurl>	
			<string:encode varname="assetUrl" variable="_assetUrl" />
		<%
	}
%>
</cs:ftcs>