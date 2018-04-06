<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ page import="com.fatwire.assetapi.def.*, com.openmarket.xcelerate.asset.AssetIdImpl, java.util.regex.*, com.fatwire.assetapi.data.*, com.fatwire.system.SessionFactory, java.util.*, com.fatwire.system.Session, COM.FutureTense.Interfaces.*"
%><cs:ftcs>
	<%-- Risk_Engineering/Risk_Engineering/Automation/WriteAPI --%>
	<ics:if condition='<%=ics.GetVar("seid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry" />
		</ics:then>
	</ics:if>
	<ics:if condition='<%=ics.GetVar("eid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement" />
		</ics:then>
	</ics:if><% 
	
	try {
		String assetType = ics.GetVar("c");
		String assetId = ics.GetVar("cid");
		
		%><ics:callelement element="Risk_Engineering/Automation/RemoveMetaData">
			<ics:argument name="cid" value="<%=assetId %>"/>
			<ics:argument name="c" value="<%=assetType %>" />
		</ics:callelement>
		<asset:getsubtype objectid="<%=assetId %>" type="<%=assetType %>" output="assetSubtype" /><%
		
		Session sessionFactory = SessionFactory.getSession();
		AssetDataManager assetDataManager = (AssetDataManager)sessionFactory.getManager(AssetDataManager.class.getName());
		
		String flexSubTypeDefinition = ics.GetVar("assetSubtype");
		MutableAssetData assetData = assetDataManager.newAssetData(assetType, flexSubTypeDefinition);
		
		Map<?,?> attributeMap = (Map<?,?>)ics.getAttribute("actualData");
		String key = "", value = "";
		ics.ClearErrno();
		
		Map<String,String> attributeTypeMap = new HashMap<String,String>();
		List<AttributeData> attributeDataList = new ArrayList<AttributeData>();
		attributeDataList = assetData.getAttributeData();
		if(!attributeDataList.isEmpty() && attributeDataList != null){
			for(AttributeData attributeData : attributeDataList){
				attributeTypeMap.put(attributeData.getAttributeName(), attributeData.getType().toString());
			}
		}
		
		if(attributeTypeMap.containsKey("page_image"))
			out.println("Result: " + attributeTypeMap.get("page_image") + "<br/><br/>");
		
		for(Map.Entry<?,?> entry : attributeTypeMap.entrySet()) {
			out.println(entry.getKey() + " : " + entry.getValue() + "<br/>");			
		}
	}
	catch(Exception e) {
		out.println("Exception Occured in WriteAPI element: " + e.getMessage());
	}
%></cs:ftcs>