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
		String assetId = ics.GetVar("cid");
	%><ics:callelement element="Risk_Engineering/Logic/LoadAssetInfoEJ">
		<ics:argument name="asset_id" value="<%=assetId %>"/>
		<ics:argument name="asset_type" value="Page"/>
		<ics:argument name="assetPrefix" value="<%=assetId %>"/>
	</ics:callelement><% 
	String pageAsset = ics.GetVar(assetId + ":page_asset");
	String imageAsset = ics.GetVar(assetId + ":image_asset");
	String pageText = ics.GetVar(assetId + ":page_text");
	String pageInteger = ics.GetVar(assetId + ":page_integer");
	
	out.println("pageAsset: " + pageAsset);
	out.println("imageAsset: " + imageAsset);
	out.println("pageText: " + pageText);
	out.println("pageInteger: " + pageInteger);
	
	ics.RemoveVar(assetId + ":page_asset");
	ics.RemoveVar(assetId + ":image_asset");
	ics.RemoveVar(assetId + ":page_text");
	ics.RemoveVar(assetId + ":page_integer");
%></cs:ftcs>