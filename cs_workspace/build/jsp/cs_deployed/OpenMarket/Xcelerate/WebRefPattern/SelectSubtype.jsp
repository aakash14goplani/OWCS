<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%//
// OpenMarket/Xcelerate/WebRefPattern/SelectSubtype
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@page import="com.fatwire.services.ui.beans.LabelValueBean"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="org.codehaus.jackson.map.ObjectMapper"%>
<%@page import="java.util.*"%>
<%@ page import="com.openmarket.xcelerate.asset.AssetPatternUtil"%>
<cs:ftcs>
<xlat:lookup key='dvin/Common/Any' escape="false" encode="false" varname="optionAny"/>
<%
	List<LabelValueBean> subtypeList = new ArrayList<LabelValueBean>();
	AssetPatternUtil assetPatternUtil = new AssetPatternUtil(ics);
	String assetType = ics.GetVar("assetType");
	String isBlobURLType = ics.GetVar("isBlobURLType");
	if (StringUtils.isBlank(isBlobURLType))
		subtypeList.add(new LabelValueBean(ics.GetVar("optionAny"), ""));	
%>
<asset:getlegalsubtypes type='<%=assetType%>' list="subtypes" pubid='<%=ics.GetVar("publicationId")%>'/>
<ics:if condition='<%=ics.GetList("subtypes")!=null && ics.GetList("subtypes").hasData()%>' >
<ics:then>
<ics:listloop listname="subtypes">
	<ics:listget listname="subtypes" fieldname="subtype" output="subtype"/>
	<%
		String subtype = ics.GetVar("subtype");
		if (StringUtils.isNotBlank(subtype))
		{
			if (StringUtils.isNotBlank(isBlobURLType)) {
				Map<String, String> attrMap = assetPatternUtil.getBlobAttributesAsMap(assetType, subtype);
				if (attrMap.size() > 0) {
					LabelValueBean labelValue = new LabelValueBean(subtype, subtype);
					subtypeList.add(labelValue);
				}
			}
			else {
				LabelValueBean labelValue = new LabelValueBean(subtype, subtype);
				subtypeList.add(labelValue);
			}
		}
	%>
</ics:listloop>
</ics:then>
</ics:if>
{ identifier: "value", label: "label", items: <%=new ObjectMapper().writeValueAsString(subtypeList)%> }
</cs:ftcs>