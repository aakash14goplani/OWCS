<%@page import="java.net.URLEncoder"%>
<%@page import="com.fatwire.assetapi.def.AttributeTypeEnum"%>
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
                   COM.FutureTense.Util.ftErrors,
                   com.fatwire.system.*,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.query.*,
                   com.openmarket.xcelerate.asset.AssetIdImpl,
                   com.openmarket.xcelerate.asset.AssetList,
                   com.fatwire.assetapi.def.AssetTypeDef,
                   java.util.*,
                   org.json.simple.JSONObject,
                   org.json.simple.JSONArray"
%>
<cs:ftcs>
	<%-- Record dependencies for the Template --%>
	<ics:if condition='<%=ics.GetVar("tid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template" />
		</ics:then>
	</ics:if>
<%!public JSONObject createAssetJSONObject(String Asset){
	String assetId = Asset.substring(Asset.indexOf(":") + 1);
	String assetType = Asset.substring(0, Asset.indexOf(":"));
	JSONObject assetObject = new JSONObject();
	assetObject.put("AssetId",assetId);
	assetObject.put("AssetType",assetType);
	return assetObject;
}
%>
<%
	String assetId = ics.GetVar("assetId");
	String assetType = ics.GetVar("assetType");
	ics.LogMsg("Inside GetAssetInfo with assetId : "+assetId+" & assetType "+assetType+"<br/>");
		
	JSONObject jsonObject = new JSONObject();
	JSONObject jsonAttributeObject = new JSONObject();
	JSONArray jsonArrayList = null;
	
	try
	{
		Session sessionObject = SessionFactory.getSession();
		AssetDataManager assetDataManager = (AssetDataManager)sessionObject.getManager(AssetDataManager.class.getName());
			
		AssetId assetIdInstance = new AssetIdImpl(ics.GetVar("assetType"),Long.valueOf(ics.GetVar("assetId")));
		List<AssetId> assetIdList = new ArrayList<AssetId>();
		assetIdList.add(assetIdInstance);
		int count = 0;
	
			
		Iterable<AssetData> assetDataList = assetDataManager.read(assetIdList);
		for(AssetData assetData : assetDataList){
			AssetDataImpl assetDataImpl = new AssetDataImpl(assetData.getAssetId());
			Iterable<String> associationNameList = assetDataImpl.getAssociationNames();
			for(String associationName : associationNameList){
				jsonArrayList = new JSONArray();
				List<AssetId> associatedAssetsList = assetDataImpl.getAssociatedAssets(associationName);
				for(AssetId associatedAssets : associatedAssetsList){
					jsonArrayList.add(createAssetJSONObject(associatedAssets.toString()));
					ics.LogMsg("Associated Assets"+associatedAssets.toString());
				}
				jsonAttributeObject.put(associationName, jsonArrayList);
			}
			
			String enumAsset = "",enumAssetList = "",enumStringText = "",enumArray = "",enumRest = "";
				
			List<AttributeData> attributeDataList = new ArrayList<AttributeData>();
			attributeDataList = assetData.getAttributeData();
			if(!attributeDataList.isEmpty() && attributeDataList != null){
				for(AttributeData attributeData : attributeDataList){
					jsonArrayList = new JSONArray();
					/*
						Types of ENUM : 
						1. enumstring
						2. enumdate
						3. enumurl
						4. enumarray
						5. enumlong
						6. enumwebreference
						7. enumasset
						8. enumtext
					*/
					//check for enumasset of type [type:id]
					ics.LogMsg(attributeData.getAttributeName()+" --> "+attributeData.getData()+" --> "+attributeData.getType().toString());
					if(attributeData.getData()!=null && AttributeTypeEnum.ASSET.equals(attributeData.getType())){
						//check for enumasset that has list eg publist, webreference, seg-rating etc
						if(ArrayList.class.isInstance(attributeData.getData())){
							ArrayList<AssetIdImpl> assetList = (ArrayList)attributeData.getData();
							for(AssetIdImpl assetIdImpl : assetList){
								jsonArrayList.add(createAssetJSONObject(assetIdImpl.toString()));
								enumAssetList = enumAssetList + " : " +assetIdImpl + "<br/>";
							}
							jsonAttributeObject.put(attributeData.getAttributeName(),jsonArrayList);
							enumAsset = enumAsset + attributeData.getAttributeName() +  " : " +enumAssetList  + "<br/>";
						}
						else{
							jsonAttributeObject.put(attributeData.getAttributeName(),
								createAssetJSONObject(attributeData.getData().toString()));
							enumAsset = enumAsset + attributeData.getAttributeName() +  " : " +attributeData.getData().toString()  + "<br/>";
						}
					} else if(attributeData.getData()!=null && (AttributeTypeEnum.STRING.equals(attributeData.getType()) || 
							AttributeTypeEnum.LARGE_TEXT.equals(attributeData.getType()))){
							//check for enumstring (name, title, description etc) and enumtext (body_text : WYSIWYG)
						jsonAttributeObject.put(attributeData.getAttributeName(),URLEncoder.encode((String )attributeData.getData(),
						"UTF-8"));
						enumStringText = enumStringText + attributeData.getAttributeName() + " : " + 
							URLEncoder.encode((String )attributeData.getData(),"UTF-8")  + "<br/>";
					} else if(attributeData.getData()!=null && !AttributeTypeEnum.ARRAY.equals(attributeData.getType())){
						//check for enumarray eg publist, seg-rating etc
						jsonAttributeObject.put(attributeData.getAttributeName(),attributeData.getData().toString());
						enumArray = enumArray + attributeData.getAttributeName() +  " : " +attributeData.getData().toString()  + "<br/>";
					} else{
						//for rest all enums
						jsonAttributeObject.put(attributeData.getAttributeName(), attributeData.getData());
						enumRest = enumRest + attributeData.getAttributeName() +  " : " +attributeData.getData()  + "<br/>";
					}
				}
			}else{
				ics.LogMsg("Attribute Data List is Empty/Null : "+attributeDataList);
			}
			if(jsonAttributeObject.get("template") != null && jsonAttributeObject.get("template").toString() != null);
			{
	%>
				<asset:gettemplaterootelement template='<%=jsonAttributeObject.get("template").toString() %>' type='<%=assetType %>'
				output="templateRootElement" />
	<%
				jsonAttributeObject.put("templateRootElement",ics.GetVar("templateRootElement"));
			}		
			ics.LogMsg("enumAsset : "+ enumAsset + "<br/>"+"enumAssetList : "+enumAssetList+ "<br/>"+"enumStringText : "+enumStringText + 
			"<br/>"+"enumArray : "+enumArray + "<br/>"+"enumRest : "+enumRest + "<br/>");
		}
	}
	catch(Exception e){
		jsonAttributeObject.put("error_message",e.getMessage());
		jsonAttributeObject.put("assetId",ics.GetVar("assetId"));
	}
	jsonObject.put("Attributes", jsonAttributeObject);
	jsonObject.put("Timestamp", ""+new Date() + "");
	jsonObject.put("AssetType", ics.GetVar("assetType"));
	ics.LogMsg("JSON TREE : "+jsonObject);
	out.println(jsonObject);
 %>
</cs:ftcs>