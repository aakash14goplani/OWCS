<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.openmarket.xcelerate.asset.AssetIdImpl"%>
<%@page import="com.fatwire.system.SessionFactory"%>
<%@page import="com.fatwire.system.Session"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*"
%>
<cs:ftcs>
<%-- Record dependencies for the Template --%>
	<ics:if condition='<%=ics.GetVar("tid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template" />
		</ics:then>
	</ics:if>
<%
	String assetId = ics.GetVar("cid");
	String assetType = ics.GetVar("c");
	try
	{
		Session sessionObject = SessionFactory.getSession();
		AssetDataManager assetDataManager = (AssetDataManager)sessionObject.getManager(AssetDataManager.class.getName());
		
		AssetId assetIdInstance = new AssetIdImpl(assetType, Long.valueOf(assetId));
		List<AssetId> assetIdList = new ArrayList<AssetId>();
		assetIdList.add(assetIdInstance);
		
		Iterable<AssetData> assetDataList = assetDataManager.read(assetIdList);
		for(AssetData assetData : assetDataList){
			AssetDataImpl assetDataImpl = new AssetDataImpl(assetData.getAssetId());
			Iterable<String> associationNameList = assetDataImpl.getAssociationNames();
			for(String associationName : associationNameList){
				List<AssetId> associatedAssetsList = assetDataImpl.getAssociatedAssets(associationName);
				for(AssetId associatedAssets : associatedAssetsList){
					out.println("Associated Assets" + associatedAssets.toString() +  "<br/>");
				}
			}
				
			List<AttributeData> attributeDataList = new ArrayList<AttributeData>();
			attributeDataList = assetData.getAttributeData();
			if(!attributeDataList.isEmpty() && attributeDataList != null){
				for(AttributeData attributeData : attributeDataList){
					out.println(attributeData.getAttributeName() + " : " + attributeData.getData() + " -> " + 
					attributeData.getType() + "<br/>");
				}		
			}
		}
	}	
	catch(Exception e){
		out.println("Exception Occured : " + e.getMessage() + "<br/>" + e);
	}
 %>	
</cs:ftcs>