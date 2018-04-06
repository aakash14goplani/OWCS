<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld" %>

<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="com.fatwire.assetapi.data.AssetId" %>
<%@ page import="com.fatwire.cs.mayura.ui.model.service.ServiceParameter" %>
<%@ page import="com.fatwire.cs.mayura.ui.constant.CSServiceConstants"%>
<%@ page import="com.fatwire.cs.ui.exception.service.ErrorMessage" %>
<%@ page import="com.fatwire.cs.ui.exception.LocalizedMessageException" %>
<%@ page import="java.util.HashMap"%>
<cs:ftcs>
<%
		/*
				Element Name:	AlloyUI/Tree/placePage.jsp
				
				Purpose:		
						This element is used for TWO operations: to PLACE a given page under a node in site plan tree
						and also to UNPLACE a given node from the site plan tree.
						The attribute operationType determines whether a page is placed or unplaced
				Input:
						Parent AssetId object
						Child AssetId object(contains asset id and asset type of the asset to be placed)
						Index in the parent where the child has to be placed  (This attribute is for Place page operation only)
						Operation type (can be PlacePage or UnPlace page - see CSServiceConstants.java for the string defn. )
													
				Output:		
						The given asset is placed or unplaced according to the operationType 
						
				-Sathish Paul Leo
		
		*/
	// Retrieve the map from the servlet request object
	ServiceParameter parameters = (ServiceParameter)  request.getAttribute(com.fatwire.cs.ui.model.dao.CSElementGateWayDao.CSElementParameters);	
	

	//Retrieve the AssetId reference to the parent node asset. This is used to extract the node id and to load the site node
	AssetId parentAssetId = (AssetId) parameters.get(CSServiceConstants.PARENT_ASSET_ID);
	
	//Retrieve the AssetId reference to the Page that needs to be placed
	AssetId childAssetId = (AssetId) parameters.get(CSServiceConstants.ASSET_ID);
	
	String pAssetId="";
	String pAssetType ="";
	String cAssetId = "";
	String cAssetType ="";
	
	
	if(parentAssetId != null)
	{
		pAssetId = Long.toString(parentAssetId.getId());
		pAssetType = parentAssetId.getType();
	}
	if(childAssetId != null)
	{
		cAssetId = Long.toString(childAssetId.getId());
		cAssetType = childAssetId.getType();	
	}
	
	//Retrieve the operation type
	String operationType = (String) parameters.get(CSServiceConstants.OPERATION_TYPE_FOR_PLACE_PAGES_SERVICE);


/*	
	//Test data
	String pAssetId="1118867611403";
	String pAssetType ="Page";
	String cAssetId = "1176127820174";
	String cAssetType ="Page";


	String operationType = CSServiceConstants.UNPLACE_PAGE_OPERATION_TYPE;	
*/	
%>
	<ics:setvar name="operationSuccess" value="true" />
<%
	if(operationType != null && operationType.equals(CSServiceConstants.PLACE_PAGE_OPERATION_TYPE))
	{
		//Retrieve the index in the site plan tree that the child needs to be placed under the parent
		Integer index = (Integer) parameters.get(CSServiceConstants.INDEX);

		if(!pAssetId.equals("") && !cAssetId.equals("") && index != null)
		{
			String childIndex = index.toString();	
%>
			<ics:callelement element="AlloyUI/Tree/Util/placePage_XML" >
				<ics:argument name="pAssetId" value='<%=pAssetId%>' />
				<ics:argument name="cAssetId" value='<%=cAssetId%>' />
				<ics:argument name="childIndex" value='<%=childIndex%>' />
				<ics:argument name="pAssetType" value='<%=pAssetType%>' />
				<ics:argument name="cAssetType" value='<%=cAssetType%>' />
				<ics:argument name="operationType" value='<%=operationType%>' />
			</ics:callelement>

<%					
		}
	}
	else if (operationType!= null && operationType.equals(CSServiceConstants.UNPLACE_PAGE_OPERATION_TYPE))
	{
		if(!pAssetId.equals("") && !cAssetId.equals(""))
		{
%>			
			<ics:callelement element="AlloyUI/Tree/Util/placePage_XML" >
				<ics:argument name="pAssetId" value='<%=pAssetId%>' />
				<ics:argument name="cAssetId" value='<%=cAssetId%>' />
				<ics:argument name="pAssetType" value='<%=pAssetType%>' />
				<ics:argument name="cAssetType" value='<%=cAssetType%>' />
				<ics:argument name="operationType" value='<%=operationType%>' />
			</ics:callelement>			
<%
		}
	}
	parameters.put(CSServiceConstants.RETURN_VALUE, new Boolean(ics.GetVar("operationSuccess")));
	parameters.put(CSServiceConstants.ERRNO, ics.GetVar("errno"));

	if(ics.GetVar("operationSuccess").equals("false"))
	{
		ErrorMessage errorMessageObj = parameters.getErrorMessage();
		String messageString = "";
		HashMap errorMessageParameters = new HashMap();
		LocalizedMessageException localizedException;
		if(ics.GetVar("cannotCheckOutParentPage") != null && ics.GetVar("cannotCheckOutParentPage").equals("true"))
		{
			errorMessageParameters.put("functionName", operationType);
			localizedException = new LocalizedMessageException("fatwire/Alloy/Authorization/CannotCompleteFunction",errorMessageParameters);
			messageString = localizedException.getMessage();
		}
		
		if(ics.GetVar("noPrivileges") != null && ics.GetVar("noPrivileges").equals("true"))
		{
			localizedException = new LocalizedMessageException("fatwire/Alloy/Authorization/IllegalTransition");
			messageString += localizedException.getMessage();
		}		
		errorMessageObj.setErrorMessage(messageString);		
	}
	
%>	
</cs:ftcs>