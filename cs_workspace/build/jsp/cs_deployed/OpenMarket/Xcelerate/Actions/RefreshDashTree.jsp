<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Actions/RefreshDashTree
//
// INPUT
//
// OUTPUT
//%>
<%-- 
//Uncomment the import statements when you use this element
<%@ page import="com.fatwire.cs.ui.view.backing.helper.TreeUtil" %>
<%@ page import="com.fatwire.assetapi.data.AssetId" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
--%>

<cs:ftcs>
<%

	/**	 Call any of the following functions depending upon the operation (edit/create/delete)
		// Update the Dash tree on creation of any asset.
		
			List<AssetId> parentIds = new ArrayList<AssetId>();	
			TreeUtil.updateTreeOnCreate(parentIds , createdAssetId); // Where createdAssetId (com.fatwire.assetapi.data.AssetId Object) is assetId of the created asset
																	// and parentIds is the list of parents of the created asset
	
		// Update the Dash tree on updation of any asset.
			List<AssetId> parentIds = new ArrayList<AssetId>();
			TreeUtil.updateTreeOnSave(parentIds , updatedAssetId); // Where updatedAssetId (com.fatwire.assetapi.data.AssetId Object) is assetId of the updated asset
																	// and parentIds is the list of parents of the updated asset
		
		// Update the Dash tree on deletion of any asset.
				
			TreeUtil.updateTreeOnDelete(deletedAssetId); // Where deletedAssetId (com.fatwire.assetapi.data.AssetId Object) is assetId of the deleted asset

    */
%>



<!-- user code here -->

</cs:ftcs>
