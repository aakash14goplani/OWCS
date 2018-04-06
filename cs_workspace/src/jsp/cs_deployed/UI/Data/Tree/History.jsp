<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><%@ page import="java.util.*"
%><%@ page import="com.fatwire.services.beans.entity.TreeNodeBean"
%><%@ page import="com.fatwire.assetapi.data.*"
%><%@ page import="com.openmarket.xcelerate.interfaces.*"
%><%@ page import="com.openmarket.xcelerate.asset.AssetIdImpl"
%><%@ page import="com.fatwire.services.dao.helper.asset.AssetDataHelper"
%><%@ page import="com.fatwire.cs.ui.framework.UIException"
%><cs:ftcs><%
try{
	String SYSTEM_NODE_HISTORY = "_history_"; // TODO put somewhereelse
	String SEMICOL = ";";
	String COMMA = ",";
	
	List<TreeNodeBean> nodeList = new LinkedList<TreeNodeBean> ();
	
	// Get the history asset based list from session variable 
	String history = ics.GetSSVar(SYSTEM_NODE_HISTORY) ; 
	
	// parse and generate a list of history assets 
	if ( null != history)
	{
		List<AssetId> assetList = new ArrayList<AssetId>();
		String[] args = history.split(SEMICOL);
		if ( null != args && args.length > 0 )
		{
			// Parse and generate a list of history assets 
			for ( String arg : args )
			{
				String[] nv = arg.split(COMMA);
				if ( null != nv && nv.length == 2)
				{
					String id = nv[0];
					String assetType =  nv[1];
					assetList.add( new AssetIdImpl(assetType, Long.parseLong(id)) );
				}
			}
			
			String name;
			// generate nodes from history list of assets
			for ( AssetId  asset : assetList )
			{
				AssetData assetData =  AssetDataHelper.getAssetData( ics, asset );
				if ( assetData != null)
				{
					name = (String)assetData.getAttributeData(IAsset.NAME).getData();
					// Generate the node 
					TreeNodeBean node = new TreeNodeBean ( String.valueOf(asset.getId()), asset.getType(), name);
					
					// Fixed PR#28325 right click options not working in System tree for History tab 
					// Set both the OkActions for label display 
					// and each respectable associated Config.js execute function keys 
					// 
					//
					node.setNodeType("asset"); // TODO remove hardcoded string
					
					node.setOkAction("Status;Inspect;Edit;Delete");
					node.setOkFunctions("viewstatus;inspect;edit;delete");
					
					// Execute my function inspect 
					node.setExecuteFunction("inspect") ; 
					nodeList.add(node);			
				}
			}	
		}
		else
		{
			// build dummy node
		}
	}
	request.setAttribute("nodeList", nodeList);
} catch(UIException e) {
	request.setAttribute(UIException._UI_EXCEPTION_, e);
	throw e;
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}
%>
</cs:ftcs>