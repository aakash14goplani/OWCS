<%@page import="com.fatwire.services.AssetService"%>
<%@page import="com.fatwire.system.SessionFactory"%>
<%@page import="com.fatwire.system.Session"%>
<%@page import="com.fatwire.services.ServicesManager"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ page import="COM.FutureTense.Interfaces.*" %>
<%@ page import="java.util.*"%>
<%@ page import="com.fatwire.assetapi.data.*"%>
<%@ page import="com.openmarket.xcelerate.interfaces.*"%>
<%@ page import="com.openmarket.xcelerate.asset.AssetIdImpl"%>
<%@ page import="com.fatwire.services.dao.helper.asset.AssetDataHelper"%>
<%@page import="com.fatwire.ui.util.GenericUtil"%>
<%@page import="com.fatwire.assetapi.util.AssetUtil"%>

<cs:ftcs>


<ics:callelement element="OpenMarket/Gator/UIFramework/GetDefaultNodeBehavior" > </ics:callelement>
				

<%

// Get the Logged in user site id 
long siteId = GenericUtil.getLoggedInSite(ics);

// Get the users history for the logged in site 
String siteHistory = "_history_"+GenericUtil.getLoggedInSite(ics)+"_"; 

// Get the history asset based list from session variable 
String history = ics.GetSSVar(siteHistory);

//parse and generate a list of history assets 
if ( null != history)
{
	List<AssetId> assetList = new ArrayList<AssetId>();
	String[] args = history.split(";");
	if ( null != args && args.length > 0 )
	{
		// Parse and generate a list of history assets 
		for ( String arg : args )
		{
			String[] nv = arg.split(",");
			if ( null != nv && nv.length == 2)
			{
				String id = nv[0];
				String assetType =  nv[1];
				assetList.add( new AssetIdImpl(assetType, Long.parseLong(id)) );
			}
		}
		
		String okFunctions = "edit;delete;treerefresh";
		String executeFunction = ics.GetVar("cs_defaultFunctionChild") ;
		String refresh= "History";
		
		String name;
		String id;
		String type;
		String assetsubtype = null;
		// generate nodes from history list of assets
		for ( AssetId  asset : assetList )
		{
			Session ses = SessionFactory.getSession();
			ServicesManager	servicesManager = (ServicesManager) ses.getManager(ServicesManager.class.getName());
			AssetService assetService = servicesManager.getAssetService();
			AssetData assetData =  assetService.read(asset,Arrays.asList(IAsset.NAME));
			if ( assetData != null)
			{
				name = (String)assetData.getAttributeData(IAsset.NAME).getData();
				id = Long.toString(asset.getId());
				type = asset.getType();				
				assetsubtype = AssetUtil.getSubtype(ics, asset );			
				%>
				
				<ics:callelement element="OpenMarket/Gator/UIFramework/BuildTreeNodeID" >
					<ics:argument name="ID" value='<%=id%>' />
					<ics:argument name="AssetType" value='<%=type%>' />
				</ics:callelement>
								
				<ics:callelement element="OpenMarket/Gator/UIFramework/FindAssetImage" >				
					<ics:argument name="AssetType" value='<%=type%>' />
					<ics:argument name="AssetDef" value='<%=assetsubtype%>' />
				</ics:callelement>
					
				<%
					String image = ics.GetVar("imageUsed") ; 				
				%>	
				
				<ics:callelement element="OpenMarket/Gator/UIFramework/BuildTreeNode" >
					<ics:argument  name="Label"           value='<%=name%>' />
					<ics:argument  name="Image"           value='<%=image%>' />				
					<ics:argument  name="executeFunction" value='<%=executeFunction%>' />				
					<ics:argument  name="okFunctions"     value='<%=okFunctions%>' />
					<ics:argument  name="RefreshKeys"    value='<%=refresh%>' />							
				</ics:callelement>
				<% 
			}
		}	
	}
}
%>
</cs:ftcs>