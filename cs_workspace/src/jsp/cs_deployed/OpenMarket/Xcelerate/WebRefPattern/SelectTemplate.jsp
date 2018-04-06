<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/WebRefPattern/SelectTemplate
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@page import="com.openmarket.xcelerate.interfaces.ITemplateAssetManager"%>
<%@page import="com.openmarket.assetframework.interfaces.AssetTypeManagerFactory"%>
<%@page import="com.openmarket.assetframework.interfaces.IAssetTypeManager"%>
<%@page import="com.fatwire.services.ui.beans.LabelValueBean"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="org.codehaus.jackson.map.ObjectMapper"%>
<%@page import="com.fatwire.mobility.util.MobilityUtils"%>
<%@page import="java.util.*"%>
<cs:ftcs>
<%

	IAssetTypeManager atm = AssetTypeManagerFactory.getATM(ics);
	ITemplateAssetManager tam = (ITemplateAssetManager)atm.locateAssetManager("Template");
	IList templates = tam.listUniqueNames(ics.GetVar("assetType"), ics.GetVar("subtype"), ics.GetVar("publicationId"), "l", null, true);
	IList filteredTemplates = MobilityUtils.getTemplates(ics, templates, ics.GetVar("assetType"), null);
	List<LabelValueBean> templateList = new ArrayList<LabelValueBean>();
	templateList.add(new LabelValueBean("defaultassettemplate", "__defaultassettemplate__"));
	for ( int i = 1; i <= filteredTemplates.numRows(); i++)
	{
		filteredTemplates.moveTo(i);        	
		String templateName = filteredTemplates.getValue("name");
		String tname = filteredTemplates.getValue("tname");
		LabelValueBean labelValue = new LabelValueBean(tname, tam.getPageName(ics.GetVar("publicationName"), ics.GetVar("assetType"), tname));
		templateList.add(labelValue);
	} 
	
%>
{ identifier: "value", label: "label", items: <%=new ObjectMapper().writeValueAsString(templateList)%> }
</cs:ftcs>