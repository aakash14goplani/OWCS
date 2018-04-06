<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Util/SetTileColumnsFromPropertyFile
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
<%@page import="java.util.StringTokenizer"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.HashSet"%>
<cs:ftcs>
<ics:getproperty name="xcelerate.searchResultCols" file="futuretense_xcel.ini" output="colsList" />
<%
	String colsList = ics.GetVar("colsList");
	StringTokenizer token = new StringTokenizer(colsList,",");
	String currentCol = "";
	Set<String> colsFromPropertyFile = new HashSet<String>();
	Set<String> allCols = new HashSet<String>();
	allCols.add("doIcons");
	allCols.add("doName");
	allCols.add("doDescription");
	allCols.add("doStartDate");
	allCols.add("doEndDate");
	allCols.add("doAssetType");
	allCols.add("doDaysExpired");
	allCols.add("doStatus");
	allCols.add("doLocale");
	allCols.add("doModified");
	
	while(token.hasMoreTokens())
	{
		currentCol = token.nextToken();
		StringBuffer sb = new StringBuffer(currentCol);
		sb.setCharAt(0,(char)(sb.charAt(0)-32));
		currentCol = "do"+sb.toString();
		colsFromPropertyFile.add(currentCol);
		if(ics.GetVar(currentCol)==null)
			ics.SetVar(currentCol,"true");
	}
	
	allCols.removeAll(colsFromPropertyFile);
	//Set the remaining of the columns in search results to be false
	for(String col : allCols)
		ics.SetVar(col,"false");
%>
</cs:ftcs>