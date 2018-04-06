<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ page import="COM.FutureTense.Interfaces.*, java.util.*, com.fatwire.assetapi.def.*, com.openmarket.xcelerate.asset.AssetIdImpl, java.util.regex.*, com.fatwire.assetapi.data.*, com.fatwire.system.SessionFactory, com.fatwire.system.Session"
%><cs:ftcs>
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
	
	try {
		String assetType = ics.GetVar("c");
		String assetId = ics.GetVar("cid");
		
		%><ics:callelement element="Risk_Engineering/Logic/LoadAssetInfoEJ">
			<ics:argument name="cid" value="<%=assetId %>"/>
			<ics:argument name="c" value="<%=assetType %>" />
			<ics:argument name="assetPrefix" value="<%=assetId %>"/>
		</ics:callelement>
		<%-- getting error -10004: A required parameter is missing. --%>
		<asset:getsubtype objectid="<%=assetId %>" type="<%=assetType %>" output="assetSubtype" /><%
		
		/* read the asset using asset api */
		
		Session sessionFactory = SessionFactory.getSession();
		AssetDataManager assetDataManager = (AssetDataManager)sessionFactory.getManager(AssetDataManager.class.getName());	
		
		AssetId assetIdInstance = new AssetIdImpl(assetType,Long.valueOf(assetId));
		List<AssetId> assetIdList = new ArrayList<AssetId>();
		assetIdList.clear();
		
		assetIdList.add(assetIdInstance);
		Iterable<AssetData> assetDataList = assetDataManager.read(assetIdList); /* getting error -500: Cannot go to row. */
		
		Map<String,String> attributeTypeMap = new HashMap<String,String>();
		attributeTypeMap.clear();
		List<AttributeData> attributeDataList = new ArrayList<AttributeData>();
		attributeDataList.clear();
		int count = 1;
		
		for(AssetData assetData : assetDataList){
			
			/* fetch type of attribute and save it in a map e.g. body_components : asset */
			out.println("<br/>Attributes: " + assetData.getAssetId() + "<br/>");
			attributeDataList = assetData.getAttributeData();
			if(!attributeDataList.isEmpty() && attributeDataList != null){
				for(AttributeData attributeData : attributeDataList){
					attributeTypeMap.put(attributeData.getAttributeName(), attributeData.getType().toString());
					out.println("<br/>" + count++ + ": " + attributeData.getAttributeName() + " : " + attributeData.getType().toString() + "<br/>");
				}
			}
			
			/* fetch associations if any */
		
			out.println("<br/>Associations: " + assetData.getAssetId() + "<br/>");
			AssetDataImpl assetDataImpl = new AssetDataImpl(assetIdInstance);
			Iterable<String> associationNameList = assetDataImpl.getAssociationNames();
			for(String associationName : associationNameList){
				List<AssetId> associatedAssetsList = assetDataImpl.getAssociatedAssets(associationName);
				for(AssetId associatedAssets : associatedAssetsList){
					out.println("<br/>" + associationName + " : " + associatedAssets + "<br/>");	
				}
			}
		}
		
		out.println("<br/><br/>");
		/* pre-defined array of meta values to be filtered */
		
		String[] metaData = new String[] {"SPTRank","SPTParent","flextemplateid","updateddate","id","Publist","path",
		"status","templateRootElement","urlexternaldoc","SPTNCode","Dimension","createddate","createdby","category",
		"startdate","updatedby","externaldoctype","filename","urlexternaldocxml","enddate","Dimension-parent","fw_uid",
		"SegRating","Relationships","renderid", "subtype", "Webreference"};
		Arrays.sort(metaData);
		
		Enumeration<?> e = ics.GetVars();
		Map<String,String> actualData = new HashMap<String,String>();
		actualData.clear();
		String variableName = "", temp = "";
				
		while(e.hasMoreElements()) {
			variableName = e.nextElement().toString();	
			if(Utilities.goodString(variableName) && variableName.contains(":")) {
				temp = variableName.substring(variableName.indexOf(":") + 1);
				if( Utilities.goodString(temp) && !Arrays.asList(metaData).contains(temp) && Utilities.goodString(ics.GetVar(assetId +":" + temp))) {
					actualData.put(temp, ics.GetVar(assetId +":" + temp));
					out.println(temp + " : " + ics.GetVar(assetId +":" + temp) + "<br/>");
				}
			}
		}	
		
		ics.setAttribute("actualData", actualData);
	}catch(Exception e) {
		out.println("Exception Occured in RemoveMetaData element: " + e.getMessage());
	}
%></cs:ftcs>