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
                   COM.FutureTense.Util.ftErrors"
%>
<cs:ftcs>
<%-- Record dependencies for the Template --%>
	<ics:if condition='<%=ics.GetVar("tid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template" />
		</ics:then>
	</ics:if>

	<ics:setvar name="sachin" value="shendge"/>
	Sachin <ics:getvar name="sachin"/> <br/>
	<asset:load name="basicAsset" type='<%=ics.GetVar("c") %>' objectid='<%=ics.GetVar("cid") %>' flushonvoid="true"/>
	<asset:scatter name="basicAsset" prefix="asset"/>
	Name : <ics:getvar name="asset:name"/> <br/>
	Address : <ics:getvar name="asset:address"/>
	
	<%
		ics.SetVar("name", "Sachin");
		out.println("Get : " + ics.GetVar("name"));
	 %>

</cs:ftcs>