<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ page import="COM.FutureTense.Interfaces.*, COM.FutureTense.Util.ftMessage, com.fatwire.assetapi.data.*, com.fatwire.assetapi.*, COM.FutureTense.Util.ftErrors, org.json.simple.parser.JSONParser, org.json.simple.JSONObject, java.util.Map, java.util.HashMap, org.json.simple.JSONArray, java.util.Iterator, java.net.URLDecoder"
%>
<cs:ftcs>
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
	</ics:if><%
	
	String assetId = ics.GetVar("cid");
	String assetType = ics.GetVar("c");
	String authContent = null;	
	String v_pageName = "Risk_Engineering/GetAssetInfoEJ";
	
	FTValList inList = new FTValList();
	inList.removeAll();
	inList.put("assetId",assetId);
	inList.put("assetType",assetType);
	authContent = ics.ReadPage(v_pageName, inList).replaceAll("(?m)^[\t]*\r?\n", "").trim();
	
	try
	{
		if(Utilities.goodString(authContent)){
			JSONParser parser = new JSONParser();
			JSONObject jsonObject = null;
			Object object = parser.parse(authContent);
			jsonObject = (JSONObject)object;
			
			String key = "", value = "", decodedString = "";
			Map<?,?> attributeMap = (Map<?,?>)jsonObject.get("Attributes");
			
			for(Object keyObject : attributeMap.keySet().toArray())	{
			
				key = null;	value = null;
			
				if(ics.GetVar("assetPrefix") == null)
					key = "asset:"+keyObject;
				else
					key = ics.GetVar("assetPrefix")+":"+keyObject;
				
				if(attributeMap.get(keyObject) != null){
				
					if(attributeMap.get(keyObject) instanceof JSONObject){
						jsonObject = (JSONObject)attributeMap.get(keyObject);
						value = jsonObject.get("AssetType")+":"+jsonObject.get("AssetId");
					
					}else if(attributeMap.get(keyObject) instanceof JSONArray){
						JSONArray jsonArray = (JSONArray)attributeMap.get(keyObject);
						Iterator<?> itr = jsonArray.iterator();
						int count = 0;
						
						while(itr.hasNext()) {
							count++;
							Object itrObj = itr.next() ;
							if(itrObj != null){
								
								if(itrObj instanceof JSONObject){
									jsonObject = (JSONObject)itrObj;
									if(count > 1){
										value = value + "," + jsonObject.get("AssetType") + ":" + jsonObject.get("AssetId");
									}else{
										value = jsonObject.get("AssetType") + ":" + jsonObject.get("AssetId");
									}					
								}else if(itrObj instanceof String){
									decodedString = URLDecoder.decode((String )itrObj,"UTF-8");
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
						}
						value = decodedString;
					}
				}
				ics.SetVar(key, value);			
			}
		}		
	}
	catch(Exception e){
		%><ics:logmsg msg='<%="Exception Occured in LoadAssetInfo: " + e.getMessage() %>' severity="ERROR"/><%
	}
%></cs:ftcs>