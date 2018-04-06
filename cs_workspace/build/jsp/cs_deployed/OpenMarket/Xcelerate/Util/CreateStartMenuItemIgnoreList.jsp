<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Util/CreateStartMenuItemIgnoreList
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.util.*"%>
<cs:ftcs>

<%
	/*
		This element constructs a Map containing the set of attributes and the list of asset types 
		for which the attributes must not be available in the list of default values for Start Menu items screen.
		
		As of May 2nd 2008, we have three attributes: startdate, enddate, Dimension and the list of assets for which the
		default values for those attributes must not be displayed in the start menu screen.
		-Sathish Paul Leo
	*/


	Map<String, List<String>> masterIgnoreList = new HashMap<String, List<String>>();
	
	//Create lists to hold assettype names for which startdate, enddate and Dimension attributes must be ignored on the Start Menu item screen
	List<String> dateIgnoreList = new ArrayList<String>();
	List<String> dimensionIgnoreList = new ArrayList<String>();
	
	//Setup the list of asset types for which we explicitly disable start/end dates
	dateIgnoreList.add("CAttributes");
	dateIgnoreList.add("Dimension");
	dateIgnoreList.add("DimensionSet");
	dateIgnoreList.add("Content_CD");
	dateIgnoreList.add("Content_PD");
	dateIgnoreList.add("Document_CD");
	dateIgnoreList.add("Document_PD");
	dateIgnoreList.add("Media_CD");
	dateIgnoreList.add("Media_PD");
	dateIgnoreList.add("Product_CD");
	dateIgnoreList.add("Product_PD");
	dateIgnoreList.add("Media_A");
	dateIgnoreList.add("Product_A");
	dateIgnoreList.add("Content_A");
	dateIgnoreList.add("Document_A");
	dateIgnoreList.add("Document_F");
	dateIgnoreList.add("Media_F");
	dateIgnoreList.add("Product_F");
	dateIgnoreList.add("Content_F");
	dateIgnoreList.add("Template");
	dateIgnoreList.add("SiteEntry");
	dateIgnoreList.add("CSElement");
	dateIgnoreList.add("FSIIVisitorDef");
	dateIgnoreList.add("FSIIVisitorPDef");
	dateIgnoreList.add("ProductTmpls");
	dateIgnoreList.add("CGroupTmpls");
	dateIgnoreList.add("ContentTmpls");
	dateIgnoreList.add("HFields");
	dateIgnoreList.add("HistoryVals");
	dateIgnoreList.add("PAttributes");
	dateIgnoreList.add("PGroupTmpls");
	dateIgnoreList.add("SparkContentAttrib");
	dateIgnoreList.add("SparkDocDef");
	dateIgnoreList.add("SparkDocParentDef");
	dateIgnoreList.add("SparkContentDef");
	dateIgnoreList.add("SparkContentParentDef");
	dateIgnoreList.add("SparkDocAttrib");
	dateIgnoreList.add("AttrTypes");

	//Associate the to-be ignored list of asset types for start/end date attributes
	masterIgnoreList.put("startdate",dateIgnoreList);
	masterIgnoreList.put("enddate",dateIgnoreList);
		
	dimensionIgnoreList.add("CSElement");
	dimensionIgnoreList.add("SiteEntry");
	dimensionIgnoreList.add("Template");
	
	masterIgnoreList.put("Dimension",dimensionIgnoreList);
	
	List<String> filenameAndPathIgnoreList = new ArrayList<String>();
	List<String> categoryIgnoreList = new ArrayList<String>();
	List<String> templateIgnoreList = new ArrayList<String>();
	
	filenameAndPathIgnoreList.add("Collection");
	filenameAndPathIgnoreList.add("Query");
	filenameAndPathIgnoreList.add("Page");
	filenameAndPathIgnoreList.add("Promotions");
	filenameAndPathIgnoreList.add("AdvCols");
	filenameAndPathIgnoreList.add("Segments");
	filenameAndPathIgnoreList.add("StyleSheet");
	
	
	StringBuffer errStr = new StringBuffer();
	String WhereClause = null;
	IList _myList;
	WhereClause = ics.SQLExp("ComplexAssets", ICS.SQLExpIN, "IN", "com.openmarket.gator.flexgroups.FlexGroupManager, com.openmarket.gator.flexassets.FlexAssetManager", "class");
	_myList = ics.SQL("ComplexAssets", "SELECT assettypename, class FROM ComplexAssets WHERE " + WhereClause, null, -1, true, errStr);
	if(_myList.hasData())
	{
		for(int i = 0; i <= _myList.numRows(); i++)
		{
			_myList.moveTo(i);
			filenameAndPathIgnoreList.add(_myList.getValue("assettypename"));
		}
	}
	
	WhereClause = ics.SQLExp("AssetType", ICS.SQLExpOR, "LIKE", "com.openmarket.sampleasset.asset., com.openmarket.xcelerate.asset., com.openmarket.assetmaker.asset.", "logic");
	_myList = ics.SQL("AssetType", "SELECT assettype, logic FROM AssetType WHERE " + WhereClause, null, -1, true, errStr);
	if(_myList.hasData())
	{
		for(int i = 0; i <= _myList.numRows(); i++)
		{
			_myList.moveTo(i);
			filenameAndPathIgnoreList.add(_myList.getValue("assettype"));
		}
	}
	
	masterIgnoreList.put("filename", filenameAndPathIgnoreList);
	//Using the same list for path as well
	masterIgnoreList.put("path", filenameAndPathIgnoreList);
	masterIgnoreList.put("renderid", filenameAndPathIgnoreList);
	
	categoryIgnoreList.add("Collection");
	categoryIgnoreList.add("Query");
	
	masterIgnoreList.put("category", categoryIgnoreList);
	
	templateIgnoreList.add("Promotions");
	masterIgnoreList.put("template", templateIgnoreList);
	
	//In future if we decide to restrict more attributes for other asset types, this is the place to add to.
	
	//Finally we set the Map object in ICS scope so that the helper element(CheckIgnoreList.jsp) can use it and not have to recreate it.
	ics.SetObj("masterIgnoreList",masterIgnoreList);
	
%>

</cs:ftcs>