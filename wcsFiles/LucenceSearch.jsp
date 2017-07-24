<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Set"%>
<%@page import="com.fatwire.cs.core.search.data.IndexData"%>
<%@page import="java.util.Collections"%>
<%@page import="com.fatwire.cs.core.search.data.ResultRow"%>
<%@page import="com.fatwire.cs.core.search.engine.SearchResult"%>
<%@page import="com.fatwire.search.query.SortOrderImpl"%>
<%@page import="com.fatwire.cs.core.search.query.SortOrder"%>
<%@page import="com.fatwire.search.util.SearchUtils"%>
<%@page import="com.fatwire.cs.core.search.query.Operation"%>
<%@page import="com.fatwire.search.query.QueryExpressionImpl"%>
<%@page import="com.fatwire.cs.core.search.query.QueryExpression"%>
<%@page import="com.fatwire.cs.core.search.engine.SearchEngine"%>
<%@page import="com.fatwire.search.engine.SearchEngineConfigImpl"%>
<%@page import="com.fatwire.cs.core.search.engine.SearchEngineConfig"%>
<%@page import="com.fatwire.cs.core.search.source.IndexSourceMetadata"%>
<%@page import="java.util.List"%>
<%@page import="com.fatwire.search.source.IndexSourceConfigImpl"%>
<%@page import="com.fatwire.cs.core.search.source.IndexSourceConfig"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*"
%><% 
/**************************************************************************************************************
   *    Element Name        :  LucenceSearch 
   *    Author              :  Aakash Goplani 
   *    Creation Date       :  (10/06/2017) 
   *    Description         :  Element to implement search based on Lucence.
   *    Input Parameters    :  Variables required by this Element 
   *                            1. assetType (on which assettype it is to be searched)
   *							2. site (to limit search result to current site)
   *							3. keyvalue (value to be searched)
   *    Output              :  search results
 ***************************************************************************************************************/
%>
<cs:ftcs>
	<%-- Record dependencies for the SiteEntry and the CSElement --%>
	<ics:if condition='<%=ics.GetVar("seid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry" />
		</ics:then>
	</ics:if>
	<ics:if condition='<%=ics.GetVar("eid")!=null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement" />
		</ics:then>
	</ics:if><%
	try{
		String assetType = ics.GetVar("selected_assetType");
		String current_site = (Utilities.goodString(ics.GetVar("selected_site"))) 
								? ics.GetVar("selected_site") : ics.GetVar("site");
		String fromDate = (Utilities.goodString(ics.GetVar("from_date"))) 
							? ics.GetVar("from_date") : ics.ResolveVariables("CS.SQLDate").split(" ")[0];
		String toDate = (Utilities.goodString(ics.GetVar("to_date"))) 
							? ics.GetVar("to_date") : ics.ResolveVariables("CS.SQLDate").split(" ")[0];
		String tags = ics.GetVar("asset_tag");
		String assetName = ics.GetVar("asset_name");
		String assetId = ics.GetVar("asset_id");
		String description = ics.GetVar("asset_description");
		String author = ics.GetVar("selected_author");
		
		out.println("Input Values : <br/><br/>" + "Asset Type : " + assetType + "<br/>Site : " + current_site + 
		"<br/>Search from date : " + fromDate + "<br/>Search to date : " + toDate + "<br/>Tags : " + tags + 
		"<br/>Asset Name : " + assetName + "<br/>Asset Id : " + assetId + "<br/>Description : " + description + 
		"<br/>Author : " + author + "<br/><br/>********************************************************************" +
		"<br/>");
		
		Calendar c1 = Calendar.getInstance();
	    Calendar c2 = Calendar.getInstance();
	    
		Date startDateInstance = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH).parse(fromDate);
	    c1.setTime(startDateInstance);     
	    Date endDateInstance = new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH).parse(toDate);
	    c2.setTime(endDateInstance);
	    
	    long milliseconds1 = c1.getTimeInMillis();
	    long milliseconds2 = c2.getTimeInMillis();
	    long diff = milliseconds2 - milliseconds1;
	    long diffDays = diff / (24 * 60 * 60 * 1000);
	    out.println("m1 : " + milliseconds1 + ", m2" + milliseconds2 + "<br/>");
	    out.println("Time in days: " + diffDays + " days. <br/><br/>");
		
		IndexSourceConfig indexSourceConfig = new IndexSourceConfigImpl(ics);
		List<String> indexSources = indexSourceConfig.getIndexSources();
		for(String index : indexSources){
			out.println("Available Asset Types for Indexing : " + index + "<br/>");
		}
		out.println("<br/><br/>***********************************************************************************" + 
		"<br/><br/>");
		
		IndexSourceMetadata indexSourceMetaData = indexSourceConfig.getConfiguration(assetType);
		String defaultSearchField = indexSourceMetaData.getDefaultSearchField();
		String fieldDescriptor = indexSourceMetaData.getFieldDescriptorString();
		String name = indexSourceMetaData.getName();
		String searchEngine = indexSourceMetaData.getSearchEngineName();
		String uniqueId = indexSourceMetaData.getUniqueIDField();
		out.println("defaultSearchField : " + defaultSearchField + "<br/>fieldDescriptor : " + fieldDescriptor + 
		"<br/>current index for : " + name + "<br/>using search engine : " + searchEngine + "<br/>Uniqueid : " + 
		uniqueId + "<br/><br/>************************************************************************************" + 
		"<br/><br/>");
		
		SearchEngineConfig searchEngineConfig = new SearchEngineConfigImpl(ics);
		/* List<String> engineList = searchEngineConfig.getEngineNames();
		String searchEngine = (!engineList.isEmpty()) ?  engineList.get(0) : "lucene";
		for(String engine : engineList){
			out.println("Engine List : " + engine + "<br/>" + engineList.get(0) + "<br/>");
			out.println("Engine List Size : " + engineList.size() + "<br/>");
			out.println("Engine List Lucence : " + engineList.contains("lucene") + "<br/>");
		} */
		SearchEngine engine = searchEngineConfig.getEngine(searchEngine);
		
		QueryExpression query = null;	
		/*Restrict your search against certain site if required site value is present in global variable scope */
		String sql="Select id from Publication where name='"+current_site+"'";
		%><ics:sql listname="siteList" sql="<%=sql %>" table="Publication" limit="1"/><%
		if(null != ics.GetList("siteList",false) && ics.GetList("siteList",false).hasData()){
			String siteId = ics.GetList("siteList",false).getValue("id");
			query = new QueryExpressionImpl("siteid", Operation.EQUALS, siteId);
			ics.RegisterList("siteList",null);
		}
		
		//Build search for searchCriteria
		QueryExpression subQuery = null;
		boolean isFirst = true;
		
		//assetId
		if(Utilities.goodString(assetId)){
			out.println("Search for assetId : " + assetId + "<br/>");
			if(isFirst)
				subQuery = SearchUtils.newQuery("id", Operation.EQUALS, assetId);
			else
				subQuery = subQuery.or("id", Operation.EQUALS, assetId);
			isFirst = false;
		}
		//assetName
		if(Utilities.goodString(assetName)){
			out.println("Search for assetName : " + assetName + "<br/>");
			if(isFirst)
				subQuery = SearchUtils.newQuery("name", Operation.CONTAINS, assetName);
			else
				subQuery = subQuery.or("name", Operation.CONTAINS, assetName);
			isFirst = false;
		}
		//description
		if(Utilities.goodString(description)){
			out.println("Search for description : " + description + "<br/>");
			if(isFirst)
				subQuery = SearchUtils.newQuery("description", Operation.CONTAINS, description);
			else
				subQuery = subQuery.or("description", Operation.CONTAINS, description);
			isFirst = false;
		}
		//author
		if(Utilities.goodString(author)){
			out.println("Search for Author : " + author + "<br/>");
			if(isFirst)
				subQuery = SearchUtils.newQuery("createdby", Operation.EQUALS, author);
			else
				subQuery = subQuery.or("createdby", Operation.EQUALS, author);
			isFirst = false;
		}
		//tags
		if(Utilities.goodString(tags)){
			tags = tags.replaceAll("\\W", ",");
			out.println("Search for tags : " + tags + "<br/>");
			List<String> tagList = new ArrayList<String>();
			for(String tag : tags.split(","))
				tagList.add(tag);			
			if(isFirst)
				subQuery = SearchUtils.newQuery("fwtags", Operation.CONTAINS, tagList);
			else
				subQuery = subQuery.or("fwtags", Operation.CONTAINS, tagList);
			isFirst = false;
		}
		//date
		/* if(Utilities.goodString(author)){
			out.println("Search for Author : " + author + "<br/>");
			if(isFirst)
				subQuery = SearchUtils.newQuery("updateddate", Operation.RANGE, author);
			else
				subQuery = subQuery.or("updateddate", Operation.RANGE, author);
			isFirst = false;
		} */
		
		//subQuery = SearchUtils.newQuery("type", Operation.CONTAINS, "\""+searchCriteria+"\"" + "~5" );
		//subQuery = subQuery.or("insert_title", Operation.CONTAINS, "\""+searchCriteria+"\"" + "~5" );
		
		//Using AND operation to search against keyword and site
		if(null != subQuery) query = query.and(subQuery);
		
		//limit output results
		query.setMaxResults(100);
		
		//Order result by createddate attribute
		List<SortOrder> sortOrderList= new java.util.ArrayList<SortOrder>();
		SortOrder sortOrder = new SortOrderImpl("createddate",false); //AttributeName, true:ascending and false:descending
		sortOrderList.add(sortOrder);
		query.setSortOrder(sortOrderList);
		
		//Load the query and search against it
		SearchResult<ResultRow> results = engine.search(Collections.singletonList(assetType), query);
		%><listobject:create name="customList" columns="assetid"/><%
		out.println("Result : " + results.hasNext() + "<br/><br/>");
		for(; results.hasNext();){
			ResultRow row = results.next();
	   		// In each row, let's look for the AssetId and type
	   		IndexData idData = row.getIndexData("id");
	   		IndexData tagData = row.getIndexData("tags");
	   		IndexData assetTypeData = row.getIndexData("AssetType");
	   		IndexData createdby = row.getIndexData("createdby");
	   		IndexData createddate = row.getIndexData("createddate");
	   		Set<String> fieldNames = row.getFieldNames();
	   		%><table border="1" ><%
	   		for(String stock : fieldNames){
	   			IndexData data = row.getIndexData(stock);
			   	//out.println(stock + " <=> " + data.getData() + "<br/>");
			   	%><tr><th><%=stock %></th><td><%=data.getData() %></td></tr><%
			}
			%></table><%
			//out.println("<br/><br/>");
	   		Long id = Long.parseLong(idData.getData());
	   		/* out.println("<br/><br/>id : " + id + "<br/>tags : " + tagData.getData() + "<br/>type : " + assetTypeData.getData() + "<br/>createdby : " + createdby.getData() + "<br/>createddate : " + createddate.getData());
	   		out.println("<br/><br/>idData : " + idData + "<br/>"); */
	   		%><listobject:addrow name="customList">
	   			<listobject:argument name="assetid" value="<%= String.valueOf(id) %>"/>
	   		</listobject:addrow><%
		}
		%><listobject:tolist listvarname="multimedia" name="customList"/><%
		//Loop through articles list and build Summary link
		IList multimedia = ics.GetList("multimedia");
		if(null!=multimedia && multimedia.hasData()){
			%><div class='box' style="padding-right: 7%;padding-left: 5%;padding-bottom: 1%;">
				<h2 class="title">SEARCH RESULTS: (<%=ics.GetList("multimedia").numRows() %>) </h2>
				<ul>
					<ics:listloop listname="multimedia">
						<ics:listget listname="multimedia" fieldname="assetid" output="articleId"/>
						<li>
							<div class="post" style="width: auto;">
								<ics:getvar name="articleId"/>
							</div>
						</li>
						<ics:removevar name="articleId"/>
					</ics:listloop>
				</ul>
			</div><%
			ics.RegisterList("multimedia",null);
			%><render:unknowndeps assettype='<%=assetType %>'/><%
		} else {
			%><div class="post">
				<h3 style="text-align: center;width: 900px;">No Articles found</h3>
			</div><%
		}
		/*
			1. https://docs.oracle.com/cd/E29542_01/doc.1111/e29636/asset_type_search.htm#WBCSA972
			2. https://docs.oracle.com/middleware/1221/wcs/admin/GUID-31E8E299-A4DB-45D5-AAF3-243A428B652D.htm#WBCSA974
			3. https://www.function1.com/2014/09/asset-tagging-before-and-after-webcenter-sites-11g-r1-11-1-1-8-0
		*/
	}
	catch(Exception e){
		out.println("Looks like the given asset type is not configured for Lucence search!<br/>Exception details : "
		 + e.getMessage() + "<br/>" + e);
	}
	finally{
		ics.RemoveVar("selected_assetType");
		ics.RemoveVar("selected_site");
		ics.RemoveVar("from_date");
		ics.RemoveVar("to_date");
		ics.RemoveVar("asset_tag");
		ics.RemoveVar("asset_name");
		ics.RemoveVar("asset_id");
		ics.RemoveVar("asset_description");
		ics.RemoveVar("selected_author");
	}
%></cs:ftcs>