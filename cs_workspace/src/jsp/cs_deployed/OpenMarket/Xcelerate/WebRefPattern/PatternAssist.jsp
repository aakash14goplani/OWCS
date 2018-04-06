<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/WebRefPattern/PatternAssist
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="java.util.*"%>
<%@ page import="com.openmarket.xcelerate.asset.AssetPatternUtil"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<cs:ftcs>
<%		
	StringBuilder contentAttrJson = new StringBuilder("{\"identifier\": \"attrName\", \"items\": [");	
	int contentAttrCount = 0;	
	String subtype = ics.GetVar("subtype");
	if (StringUtils.isBlank(subtype))
		subtype = null;
	AssetPatternUtil assetPatternUtil = new AssetPatternUtil(ics);
	Map<String, String> attrMap = assetPatternUtil.getAttributesAsMap(ics.GetVar("assetType"), subtype);
	if (attrMap.size() > 0)
	{
		for (Map.Entry<String, String> entry : attrMap.entrySet()) 
		{
			if (contentAttrCount > 0)
				contentAttrJson.append(",");
			contentAttrJson.append("{\"attrName\": \"" + entry.getKey() + "\",\"attrType\": \"" + entry.getValue() + "\"}");
			contentAttrCount ++;
		} 
	}
	contentAttrJson.append("],\"numRows\": " + contentAttrCount  + "}");
	out.println((String) contentAttrJson.toString());	
%>
</cs:ftcs>