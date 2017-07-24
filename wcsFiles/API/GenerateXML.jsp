<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="javax.xml.transform.stream.StreamResult"%>
<%@page import="java.io.StringWriter"%>
<%@page import="javax.xml.transform.dom.DOMSource"%>
<%@page import="javax.xml.transform.Transformer"%>
<%@page import="javax.xml.transform.TransformerFactory"%>
<%@page import="java.util.Date"%>
<%@page import="org.w3c.dom.Element"%>
<%@page import="org.w3c.dom.Document"%>
<%@page import="javax.xml.parsers.DocumentBuilder"%>
<%@page import="javax.xml.parsers.DocumentBuilderFactory"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   COM.FutureTense.Util.ftErrors"
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
	</ics:if>
<%!
	Document document = null;
        String tempVariable = " ";
		
	public Element creteChildNode(String node, String value){
		Element childElement = document.createElement(node);
		childElement.appendChild(document.createTextNode(value));
		return childElement;
	}
	
	public void printItemTree(String assetType, String assetId, String status, String createdBy, String createdDate, 
			String updatedBy, String updatedDate, String assetName, String template, ICS ics, Element rootChannelElement){
		Element childElement = document.createElement("item");
				
		if(assetType != null && !"".equals(assetType)) 
			childElement.appendChild(creteChildNode("assetType", assetType));
		if(assetId != null && !"".equals(assetId)) 
			childElement.appendChild(creteChildNode("assetId", assetId));
		if(status != null && !"".equals(status)) 
			childElement.appendChild(creteChildNode("status", status));
		if(createdBy != null && !"".equals(createdBy))
			childElement.appendChild(creteChildNode("createdBy", createdBy));
		if(createdDate != null && !"".equals(createdDate))
			childElement.appendChild(creteChildNode("createdDate", createdDate));
		if(updatedBy != null && !"".equals(updatedBy))
			childElement.appendChild(creteChildNode("updatedBy", updatedBy));
		if(updatedDate != null && !"".equals(updatedDate))
			childElement.appendChild(creteChildNode("updatedDate", updatedDate));
		if(assetName != null && !"".equals(assetName))
			childElement.appendChild(creteChildNode("assetName", assetName));
		if(template != null && !"".equals(template))
			childElement.appendChild(creteChildNode("template", template));
		
		rootChannelElement.appendChild(childElement);	
		ics.LogMsg("Success : "+ics.GetVar("assetName!"));	
	}
	
	public void printAttributeTree(String assetId, String assetType, ICS ics, Element rootElementAsset){
		String[] assetArray = {"flextemplateid","type","right_rail_components","body_components","title","name","body_assets",
			"browser_title","feature_recommendation","banner_component","taxo_category","category_asset_list","tab_components",
			"body_text","insert_body_text","image","dropdown_components","asset_link","link_url","taxo_industry","taxo_safety_topic",
			"taxo_product","sic_code","type","abstract","duration","audience","file_url","display_title"};
			
		FTValList inList = new FTValList();
		inList.put("cid",assetId);
		inList.put("c",assetType);
		if(assetId != null && assetType != null)
			ics.CallElement("Risk_Engineering/Logic/LoadAssetInfoEJ", inList);
			
		Element attributeChild = document.createElement("attributes");			
		for(String assetAttributeName : assetArray){
			String attributeValue = ics.GetVar("asset:"+assetAttributeName);
			if(assetAttributeName.equals("link_url") || assetAttributeName.equals("file_url")){
				if(attributeValue != null && !"".equals(attributeValue)){
					Element urlElement = document.createElement(assetAttributeName);
					urlElement.appendChild(document.createCDATASection(attributeValue));
					attributeChild.appendChild(urlElement);
				}
			}else if(attributeValue != null && !"".equals(attributeValue))
				attributeChild.appendChild(creteChildNode(assetAttributeName,StringEscapeUtils.escapeXml(attributeValue)));				
			}
		rootElementAsset.appendChild(attributeChild);
	}
	
	public void iterateList(IList list, String assetType, ICS ics, Element rootChannelElement, Element rootElementAsset){
		String assetId = null, status = "", createdBy = "", createdDate = "", updatedBy = "", 
			updatedDate = "", assetName = "", template = "";
		try{
			for(int i = 1; i<= list.numRows(); i++){
				list.moveTo(i);
				assetId = list.getValue("id");
				status = list.getValue("status");
				createdBy =  list.getValue("createdby");
				createdDate = list.getValue("createddate");
				updatedBy = list.getValue("updatedby");
				updatedDate = list.getValue("updateddate");
				assetName = list.getValue("name");
				template = list.getValue("template");
				
				FTValList inList = new FTValList();
				inList.put("cid",assetId);
				inList.put("c",assetType);
				if(assetId != null && assetType != null)
					ics.CallElement("Risk_Engineering/Logic/LoadAssetInfoEJ", inList);
					//ics.LogMsg("Null Asset Id : "+assetId+", Asset Type : "+assetType);	
				else
					ics.LogMsg("Null Asset Id / Type passed in Load Asset to Call Get Asset from GenerateXML");	
					
				printItemTree(assetType, assetId, status, createdBy, createdDate, updatedBy, updatedDate, assetName, template, ics, 
				rootChannelElement);			
				
				printAttributeTree(assetId, assetType, ics, rootElementAsset);	
			}
		}
		catch(Exception e){
			ics.LogMsg("Exception Occured : "+e);
		}
	}
%>  	
<%	
	try{
		DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
		document = dBuilder.newDocument();
		Element rootElementPortal = document.createElement("portal");
		document.appendChild(rootElementPortal);
		Element rootElementAsset = document.createElement("asset");
		rootElementPortal.appendChild(rootElementAsset);
		Element rootChannelElement = document.createElement("channel");
		rootElementPortal.appendChild(rootChannelElement);
		rootElementPortal.appendChild(creteChildNode("TimeStamp",new Date().toString()));			
						
		for(int index = 1; index <= 2; index++){
			if(index == 1){
%>
				<ics:sql sql="select * from HIG_MultiMedia_C" listname="multimediaAssetsList" table="HIG_MultiMedia_C" />
<%
				IList multimediaAssetList = ics.GetList("multimediaAssetsList");
				iterateList(multimediaAssetList, "HIG_MultiMedia_C", ics, rootChannelElement, rootElementAsset);				
			}
			if(index == 2){
%>
				<ics:sql sql="select * from HIG_ComponentWidget_C" listname="componentAssetsList" table="HIG_ComponentWidget_C" />
<%
				IList componentAssetsList = ics.GetList("componentAssetsList");
				iterateList(componentAssetsList, "HIG_ComponentWidget_C", ics, rootChannelElement, rootElementAsset);
			}
		}
			
		TransformerFactory factory = TransformerFactory.newInstance();
		Transformer transformer = factory.newTransformer();
		DOMSource source = new DOMSource(document);
		StringWriter writer = new StringWriter();
		StreamResult result = new StreamResult(writer);
		transformer.transform(source, result);
                tempVariable = writer.getBuffer().toString().replaceAll("\\n|\\r", "");
		out.println(writer.getBuffer().toString().replaceAll("\\n|\\r", ""));
                ics.LogMsg("Temp Var : "+tempVariable );
	}
	catch(Exception e){
		out.println("Exception Occured : "+e);
	}	
%>
</cs:ftcs>