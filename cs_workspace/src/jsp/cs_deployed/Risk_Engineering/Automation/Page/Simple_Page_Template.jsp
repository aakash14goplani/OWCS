<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><cs:ftcs>
	<%-- Record dependencies for the Template --%>
	<ics:if condition='<%=ics.GetVar("tid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template" />
		</ics:then>
	</ics:if><% 
	
	String assetType = ics.GetVar("c");
	String assetId = ics.GetVar("cid");
	
	%><ics:callelement element="Risk_Engineering/Logic/LoadAssetInfoEJ">
		<ics:argument name="asset_id" value="<%=assetId %>"/>
		<ics:argument name="asset_type" value="<%=assetType %>" />
		<ics:argument name="assetPrefix" value="<%=assetId %>"/>
	</ics:callelement>
</cs:ftcs>