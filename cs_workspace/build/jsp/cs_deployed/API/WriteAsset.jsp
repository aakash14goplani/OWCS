<%@page import="java.util.Arrays"%>
<%@page import="java.util.Date"%>
<%@page import="com.fatwire.system.SessionFactory"%>
<%@page import="com.fatwire.system.Session"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"%>
<%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"%>
<%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"%>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld"%>
<%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"%>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"%>
<%@ page import="COM.FutureTense.Interfaces.*, COM.FutureTense.Util.ftMessage, com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*, COM.FutureTense.Util.ftErrors"%>
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
<%!public void createAsset(AssetDataManager assetDataManager, MutableAssetData assetData, String assetName, ICS ics){
		try{
			/* assetData.getAttributeData("name").setData(assetName);
			assetData.getAttributeData("taxo_type").setData("Language");
			assetData.getAttributeData("taxo_name").setData("Language Asset from API");
			assetData.getAttributeData("taxo_value").setData("1234567890");
			assetData.getAttributeData("sic_code").setData("945871");
			assetData.getAttributeData("template").setData("/Demo"); */
			
			assetData.getAttributeData("name").setData(assetName);
			assetData.getAttributeData("headline").setData("Language");
			assetData.getAttributeData("subheadline").setData("Language Asset from API");
			assetData.getAttributeData("abstract").setData("1234567890");
			assetData.getAttributeData("author").setData("945871");
			assetData.getAttributeData("body").setData("<img src='https://docs.oracle.com/cd/E72987_01/wcs/tag-ref/XML/TopLogo.gif'/>");
			assetData.getAttributeData("template").setData("/DemoTemplate");
			
			assetDataManager.insert(Arrays.<AssetData>asList(assetData));
			ics.LogMsg("Asset Created : " + assetData.getAssetId() + "<br/>");	
		}
		catch(Exception e){
			ics.LogMsg("Exception Occured : " + e.getMessage());
		}
	}
%>
<%
	try{
		Session sessionFactory = SessionFactory.getSession();
		AssetDataManager assetDataManager = (AssetDataManager)sessionFactory.getManager(AssetDataManager.class.getName());
		
		String assetName = "Safety Topics", assetType = "Article_C", flag = "diff",  flexDefinition = "articleDefinition", 
		inputType = "flex", sql = "select assetid from AssetPublication where assettype='" + assetType + "'";
%>
		<ics:sql sql="<%=sql%>" listname="listName" table="AssetPublication" />
	 	<ics:listloop listname="listName">
	 		<ics:listget fieldname="assetid" listname="listName" output="aid"/>
	 		[id : <ics:getvar name="aid"/>, 
	 		<asset:load name="someName" type='<%=assetType%>' objectid='<%=ics.GetVar("aid")%>'/>
	 		<asset:scatter name="someName" prefix="asset"/>
	 		name : <ics:getvar name="asset:name"/>]<br/>
	 		<ics:if condition='<%=ics.GetVar("asset:name").equalsIgnoreCase(assetName) %>'>
	 			<ics:then>
	 				<%flag = "same"; %>
	 			</ics:then>
	 		</ics:if>
	 	</ics:listloop>
<%
		out.println("SQL fired : " + sql + "<br/>");		
		if(flag.equals("diff")){
			if("flex".equalsIgnoreCase(inputType)){
				MutableAssetData mutableAssetData = assetDataManager.newAssetData(assetType, flexDefinition);
				createAsset(assetDataManager, mutableAssetData, assetName, ics);
			}
			else if("basic".equalsIgnoreCase(inputType)){
				MutableAssetData basicAssetData = assetDataManager.newAssetData(assetType, "");
				createAsset(assetDataManager, basicAssetData, assetName, ics);	
			}		
		}else
			out.println("asset with name <b>"+assetName+"</b> already exists! <br/>");
	}
	catch(Exception e){
		out.println("Exception Occured : " + e.getMessage());
	}
 %>
</cs:ftcs>