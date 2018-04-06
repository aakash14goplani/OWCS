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
		out.println("Outer Map size: " + attributeMap.size());
		out.println("<br/><br/>****Looping for Ground Level " + assetId + " : " + assetType + "****<br/><br/>");
		
		for(Map.Entry<?,?> entry : attributeMap.entrySet()) {
			key = entry.getKey().toString();
			value = entry.getValue().toString();
			out.println(key + " : " + value + "<br/>");
			
			if(value.contains(":") || value.contains(",")) {
				String nestedAssetType = "", nestedAssetId = "";								
				for(String assetComponent : value.split(",")) {
					nestedAssetType = assetComponent.split(":")[0];
					nestedAssetId = assetComponent.split(":")[1];
				
					if(Utilities.goodString(nestedAssetId)) {
						String regex = "\\d+";      
				        Pattern pattern = Pattern.compile(regex);
				        if(pattern.matcher(nestedAssetId).matches()) {
				        	ics.removeAttribute("actualData");
				        	
				        	%><ics:callelement element="Risk_Engineering/Automation/RemoveMetaData">
								<ics:argument name="cid" value="<%=nestedAssetId %>"/>
								<ics:argument name="c" value="<%=nestedAssetType %>" />
							</ics:callelement>
							<asset:getsubtype objectid="<%=nestedAssetId %>" type="<%=nestedAssetType %>" output="levelObeAssetSubtype" /><%
							
							/*Duplication Starts*/
							
							String levelOneNlexSubTypeDefinition = ics.GetVar("levelObeAssetSubtype");
							MutableAssetData levelOneAssetData = assetDataManager.newAssetData(nestedAssetType, levelOneNlexSubTypeDefinition);
							
							Map<?,?> levelOneMap = (Map<?,?>)ics.getAttribute("actualData");
							out.println("<br/>Inner Map size: " + levelOneMap.size() + "<br/>");
							String levelOneKey = "", levelOneValue = "";
							ics.ClearErrno();
							
							out.println("<br/><br/>****Looping for Level One " + nestedAssetId + " : " + nestedAssetType + "****<br/><br/>");
							
							for(Map.Entry<?,?> levelOneEntry : levelOneMap.entrySet()) {
								levelOneKey = levelOneEntry.getKey().toString();
								levelOneValue = levelOneEntry.getValue().toString();
								out.println(levelOneKey + " : " + levelOneValue + "<br/>");
								
								if(levelOneValue.contains(":") || levelOneValue.contains(",")) {
									String levelOneNestedAssetType = ""; 
									String levelOneNestedAssetId = ""; 
									for(String levelOneAssetComponent : levelOneValue.split(",")) {
										levelOneNestedAssetId = levelOneAssetComponent.split(":")[1];
										levelOneNestedAssetType = levelOneAssetComponent.split(":")[0];
										if(Utilities.goodString(levelOneNestedAssetId)) {
											String levelOneRegex = "\\d+";      
									        Pattern levelOnePattern = Pattern.compile(levelOneRegex);
									        if(levelOnePattern.matcher(levelOneNestedAssetId).matches()) {
									        	
									        	out.println("<br/><br/>****Need to loop for Level Two " + levelOneNestedAssetId + " : " + levelOneNestedAssetType + "****<br/><br/>");
									        }
										}
									}
								}
								else {
					            	levelOneAssetData.getAttributeData(levelOneKey).setData(levelOneValue);
					            }
							}
							assetDataManager.insert(Arrays.<AssetData>asList(levelOneAssetData));
							AssetId nestedAssetIdInstance = levelOneAssetData.getAssetId(); //new AssetIdImpl(nestedAssetType,Long.valueOf(nestedAssetId));
							out.println("<br/><br/>****Done with Level One****<br/><br/>");	
							
							/* Duplication Ends */	
							assetData.getAttributeData(key).setData(Arrays.<AssetData>asList(levelOneAssetData));										
				        }
					}	
				}
				assetData.getAttributeData(key).setData(value);
			}
			else {
            	assetData.getAttributeData(key).setData(value);
            }
		}
		assetDataManager.insert(Arrays.<AssetData>asList(assetData));
		if(ics.GetErrno() == 0)
			out.println("SUCCESS: " +  "assetData.getAssetId() + <br/>");
		else
			out.println("FAIL: " + ics.GetErrno() + "<br/>");
	}
	/*catch(Exception e) {
		out.println("Exception Occured in WriteAPI element: " + e.getMessage() + "<br/>");
	}*/
	finally {
	
	}
%></cs:ftcs>