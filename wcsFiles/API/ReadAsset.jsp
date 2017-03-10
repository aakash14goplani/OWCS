<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.openmarket.xcelerate.asset.AssetIdImpl"%>
<%@page import="com.fatwire.system.SessionFactory"%>
<%@page import="com.fatwire.system.Session"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   COM.FutureTense.Util.ftErrors"
%>
<cs:ftcs>
<%-- Record dependencies for the Template --%>
	<ics:if condition='<%=ics.GetVar("tid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("tid")%>' c="Template" />
		</ics:then>
	</ics:if>
<%
	String assetId = ics.GetVar("cid");
	String assetType = ics.GetVar("c");
	try
	{
		Session sessionObject = SessionFactory.getSession();
		AssetDataManager assetDataManager = (AssetDataManager)sessionObject.getManager(AssetDataManager.class.getName());
		
		AssetId assetIdInstance = new AssetIdImpl(assetType, Long.valueOf(assetId));
		List<AssetId> assetIdList = new ArrayList<AssetId>();
		assetIdList.add(assetIdInstance);
		
		Iterable<AssetData> assetDataList = assetDataManager.read(assetIdList);
		for(AssetData assetData : assetDataList){
			/* AssetDataImpl assetDataImpl = new AssetDataImpl(assetData.getAssetId());
			Iterable<String> associationNameList = assetDataImpl.getAssociationNames();
			for(String associationName : associationNameList){
				List<AssetId> associatedAssetsList = assetDataImpl.getAssociatedAssets(associationName);
				for(AssetId associatedAssets : associatedAssetsList){
					out.println("Associated Assets" + associatedAssets.toString() +  "<br/>");
				}
			} */
				
			List<AttributeData> attributeDataList = new ArrayList<AttributeData>();
			attributeDataList = assetData.getAttributeData();
			if(!attributeDataList.isEmpty() && attributeDataList != null){
				for(AttributeData attributeData : attributeDataList){
					out.println(attributeData.getAttributeName() + " : " + attributeData.getData() + " -> " + 
					attributeData.getType() + "<br/>");
				}		
			}
		}
		
		out.println("<br/><br/>Query Started<br/><br/>");
		String query = "select assetid from AssetPublication where assettype='HIG_Taxonomy'", columnName, columnValue;
		StringBuffer errorList = new StringBuffer(" ");
		ics.SetVar("assettype", "HIG_Taxonomy");
		//IList ilist = ics.CallSQL("", arg1, arg2, arg3, arg4, arg5);
		IList ilist = ics.SelectTo("AssetPublication", "assetid, assettype", "assettype", null, -1, "selectToList", false, errorList);
		int rows = ilist.numRows();
		int cols = ilist.numColumns();
		out.println(rows + " : " + cols);
		for(int i=1; i<=rows; i++){
			for(int j=0; j<cols; j++){
				columnName = ilist.getColumnName(j);
				columnValue = ilist.getValue(columnName);
				out.println(columnName + " : " + columnValue + "<br/>");
				ilist.moveTo(i+1);
			}
		}
	}	
	catch(Exception e){
		out.println("Exception Occured : " + e.getMessage() + "<br/>" + e);
	}
 %>	
</cs:ftcs>