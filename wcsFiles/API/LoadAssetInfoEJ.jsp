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
                   org.json.simple.parser.JSONParser,
                   org.json.simple.JSONObject,
                   java.util.Map,
                   java.util.HashMap,
                   org.json.simple.JSONArray,
                   java.util.Iterator,
                   java.net.URLDecoder"
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
	ics.LogMsg("authContent : "+authContent);
	
	try
	{
		if(authContent != null){
			JSONParser parser = new JSONParser();
			JSONObject jsonObject = null;
			Object object = parser.parse(authContent);
			jsonObject = (JSONObject)object;
			
			String key = null, value = null, decodedString = null;
			Map<String,String> temp = new HashMap<String,String>();			
			Map<?,?> attributeMap = (Map<?,?>)jsonObject.get("Attributes");
			
			for(Object keyObject : attributeMap.keySet().toArray())
			{
				if(ics.GetVar("assetPrefix") == null)
					key = "asset:"+keyObject;
				else
					key = ics.GetVar("assetPrefix")+":"+keyObject;
				ics.LogMsg("<br/><br/>key : "+key+"-->"+attributeMap.get(keyObject));
				
				if(attributeMap.get(keyObject) != null){
				
					if(attributeMap.get(keyObject) instanceof JSONObject){
						jsonObject = (JSONObject)attributeMap.get(keyObject);
						ics.LogMsg("<br/>Instance of JSONObject : "+jsonObject+"-->"+keyObject);
						value = jsonObject.get("AssetType")+":"+jsonObject.get("AssetId");
					}else if(attributeMap.get(keyObject) instanceof JSONArray){
						JSONArray jsonArray = (JSONArray)attributeMap.get(keyObject);
						ics.LogMsg("<br/>Instance of JSONArray : "+jsonArray+"-->"+keyObject);
						Iterator<?> itr = jsonArray.iterator();
						int count = 0;
						while(itr.hasNext()){
							count++;
							Object itrObj = itr.next() ;
							if(itrObj != null){
								ics.LogMsg("<br/><br/>itrObj"+itrObj);
								if(itrObj instanceof JSONObject){
									jsonObject = (JSONObject)itrObj;
									ics.LogMsg("<br/>Instance of JSONArray/JSONObject : "+jsonObject+"-->"+keyObject+"  : count : "+count);
									if(count > 1){
										value = value + "," + jsonObject.get("AssetType") + ":" + jsonObject.get("AssetId");
									}else{
										value = jsonObject.get("AssetType") + ":" + jsonObject.get("AssetId");
									}					
								}else if(itrObj instanceof String){
									decodedString = URLDecoder.decode((String )itrObj,"UTF-8");
									ics.LogMsg("<br/>Instance of JSONArray/String : "+decodedString+"-->"+keyObject+"  : count : "+count);
									if(count > 1){
										value = value + "," + decodedString;
									}else{
										value = decodedString;
									}	
								}
							}
						}
					}else{
						if(attributeMap.get(keyObject) instanceof String){
							decodedString = URLDecoder.decode((String )attributeMap.get(keyObject),"UTF-8");
							ics.LogMsg("<br/>Instance of String : "+decodedString+"-->"+keyObject);
						}
						value = decodedString;
					}
				}
				ics.SetVar(key, value);				
				temp.put(key, value);			
			}
			ics.setAttribute("attributeMap", temp);
		}
		else{
			ics.LogMsg("AuthContent is null ");
		}
	}
	catch(Exception e){
		out.println("Exception Occured : " + e.getMessage());
		ics.LogMsg("Exception Occured : " + e.getMessage());
	}
 %>
</cs:ftcs>