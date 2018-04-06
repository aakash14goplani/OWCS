<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/WebRefPattern/SelectBlobField
//
// INPUT
//
// OUTPUT
//%>
<%@page import="com.fatwire.services.ui.beans.LabelValueBean"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="org.codehaus.jackson.map.ObjectMapper"%>
<%@page import="java.util.*"%>
<%@ page import="com.openmarket.xcelerate.asset.AssetPatternUtil"%>
<cs:ftcs>
<%
	String subtype = ics.GetVar("subtype");
	if (StringUtils.isBlank(subtype))
		subtype = null;
	AssetPatternUtil assetPatternUtil = new AssetPatternUtil(ics);
	Map<String, String> attrMap = assetPatternUtil.getBlobAttributesAsMap(ics.GetVar("assetType"), subtype);
	List<LabelValueBean> blobFieldList = new ArrayList<LabelValueBean>();
	if (attrMap.size() > 0)
	{
		for (Map.Entry<String, String> entry : attrMap.entrySet()) 
		{
			LabelValueBean labelValue = new LabelValueBean(entry.getKey(), entry.getKey());
			blobFieldList.add(labelValue);
		} 
	}	
%>
{ identifier: "value", label: "label", items: <%=new ObjectMapper().writeValueAsString(blobFieldList)%> }
</cs:ftcs>