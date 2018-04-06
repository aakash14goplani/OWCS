<%@page import="org.json.simple.JSONValue"%>
<%@page import="org.json.simple.parser.JSONParser"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%><%@ taglib
	prefix="asset" uri="futuretense_cs/asset.tld"%><%@ taglib
	prefix="assetset" uri="futuretense_cs/assetset.tld"%><%@ taglib
	prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"%><%@ taglib
	prefix="ics" uri="futuretense_cs/ics.tld"%><%@ taglib
	prefix="listobject" uri="futuretense_cs/listobject.tld"%><%@ taglib
	prefix="render" uri="futuretense_cs/render.tld"%><%@ taglib
	prefix="searchstate" uri="futuretense_cs/searchstate.tld"%><%@ taglib
	prefix="siteplan" uri="futuretense_cs/siteplan.tld"%><%@ page
	import="COM.FutureTense.Interfaces.*,
				   com.fatwire.system.*,
                   com.fatwire.assetapi.data.*,
                   java.net.*,
                   com.fatwire.assetapi.query.*,
                   java.util.*,
                   com.openmarket.xcelerate.asset.*,
                   com.fatwire.assetapi.def.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors,
                   org.json.simple.JSONObject,
                   org.json.simple.JSONArray"%><cs:ftcs>
	<%-- GenerateJSON

INPUT

OUTPUT

--%>
	<%-- Record dependencies for the SiteEntry and the CSElement --%>
	<ics:if condition='<%=ics.GetVar("seid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry" />
		</ics:then>
	</ics:if>
	<ics:if condition='<%=ics.GetVar("eid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement" />
		</ics:then>
	</ics:if>

	<%!/*public JSONObject createAssetJSONObj(String assetStr) {
		String assetType = assetStr.substring(0, assetStr.indexOf(":"));
		String assetId = assetStr.substring(assetStr.indexOf(":") + 1);
		JSONObject assetObj = new JSONObject();
		assetObj.put("AssetType", assetType);
		assetObj.put("AssetID", assetId);
		return assetObj;
	}*/%>

	<%
		/*JSONObject attributeObj = null;
			JSONArray list = null;
			JSONObject obj = new JSONObject();
			String assetStr, assetType, assetIdLoc = null;

			try {
				Session ses = SessionFactory.getSession();
				AssetDataManager mgr = (AssetDataManager) ses.getManager(AssetDataManager.class.getName());
				AssetId assetIdObj = new AssetIdImpl(ics.GetVar("assetType"), Long.valueOf(ics.GetVar("assetId")));
				List<AssetId> newList = new ArrayList<AssetId>();
				newList.add(assetIdObj);
				Iterable<AssetData> assetData = mgr.read(newList);
				for (AssetData data1 : assetData) {
					attributeObj = new JSONObject();
					List<AttributeData> AttrDataList = data1.getAttributeData();
					for (AttributeData AttrName : AttrDataList) {
						list = new JSONArray();
						if (AttrName.getData() != null && AttributeTypeEnum.ASSET.equals(AttrName.getType())) {
							if (ArrayList.class.isInstance(AttrName.getData())) {
								ArrayList<AssetIdImpl> assetList = (ArrayList) AttrName.getData();
								for (AssetIdImpl assetIdImpl : assetList) {
									list.add(createAssetJSONObj(assetIdImpl.toString()));
								}
								attributeObj.put(AttrName.getAttributeName(), list);
							} else {
								attributeObj.put(AttrName.getAttributeName(),createAssetJSONObj(AttrName.getData().toString()));
							}
						} else if (AttrName.getData() != null
								&& (AttributeTypeEnum.STRING.equals(AttrName.getType())
										|| AttributeTypeEnum.LARGE_TEXT.equals(AttrName.getType()))) {
							attributeObj.put(AttrName.getAttributeName(),URLEncoder.encode((String) AttrName.getData(), "UTF-8"));
						} else if (AttrName.getData() != null
								&& !AttributeTypeEnum.ARRAY.equals(AttrName.getType())) {
							attributeObj.put(AttrName.getAttributeName(), AttrName.getData().toString());
						} else {
							attributeObj.put(AttrName.getAttributeName(), AttrName.getData());
						}
					}
					obj.put("Attributes", attributeObj);
				}
			} catch (Exception e) {
		}
			obj.put("Timestamp", "" + new Date() + "");
			obj.put("AssetType", ics.GetVar("assetType"));
			out.println(obj);*/
			
		String assetId = ics.GetVar("cid");
		String assetType = ics.GetVar("c");
		String authContent = null;	
		String v_pageName = "Risk_Engineering/GetAssetInfoEJ";
		ics.LogMsg("Inside LoadAssetInfo with assetId : "+assetId+" & assetType "+assetType+"<br/>");
		
		FTValList inList = new FTValList();
		inList.put("assetId",assetId);
		inList.put("assetType",assetType);
		if(assetId != null && assetType != null)
			authContent = ics.ReadPage(v_pageName, inList).replaceAll("(?m)^[\t]*\r?\n", "").trim();
		else
			ics.LogMsg("Null Asset Id / Type passed in Load Asset to Call Get Asset");
			
		if(authContent != null)
			out.println(authContent);
		else
			out.println("AuthContent Empty");
	%>
</cs:ftcs>