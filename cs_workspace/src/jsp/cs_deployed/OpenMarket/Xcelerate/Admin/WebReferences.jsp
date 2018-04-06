<%@page import="com.openmarket.xcelerate.asset.WebReferencesManager"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.List"%>
<%@page import="com.fatwire.assetapi.util.AssetUtil"%>
<%@page import="com.fatwire.assetapi.data.AssetId"%>
<%@page import="COM.FutureTense.Interfaces.IList"%>
<%@page import="com.fatwire.services.dao.helper.Tags"%>
<%@page import="java.util.StringTokenizer"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%//
// OpenMarket/Xcelerate/Admin/WebReferences
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment" />
<ics:callelement element="OpenMarket/Gator/UIFramework/UITimeOutCheck" />
<ics:callelement element="OpenMarket/Xcelerate/Util/SetLocale"/>

<%!
	final static String OPERATION = "op";
	final static String SORT = "sort";
	final static String SORT_ASC = "asc";
	final static String SORT_DESC = "desc";
	final static String SEARCH_CHOICE = "searchChoice";
	
%>
<%
	String contextPath= request.getContextPath();
	String locale = (String)session.getAttribute("locale");
	String defaultLocale = (String)session.getAttribute("defaultLocale");
	locale = defaultLocale == null ? "en_US": defaultLocale;
%>
<html>
<head>
<LINK href='<%=contextPath%>/Xcelerate/data/css/<%=locale%>/common.css' rel="stylesheet" type="text/css" />
<LINK href='<%=contextPath%>/Xcelerate/data/css/<%=locale%>/content.css' rel="stylesheet" type="text/css" />
<LINK href='<%=contextPath%>/Xcelerate/data/css/<%=locale%>/cacheTool.css' rel="stylesheet" type="text/css" />
<ics:callelement element="OpenMarket/Xcelerate/Util/LoadDefaultStyleSheet">
	<ics:argument name="cssFilesToLoad" value="common.css,content.css,cacheTool.css"/>
</ics:callelement>
<script type="text/javascript">
function search(op)
{
	var operation = document.getElementById("op");
	operation.value = op;
	var selected = false;
	if(op == "delete")
	{
		var urlsToDelete = "";
		var objCheckBoxes = document.forms["dataform"].elements["key"];
		if(objCheckBoxes)
		{
			var totalCheckBox = objCheckBoxes.length;
			if(totalCheckBox)
			{
				for(var count=0; count < totalCheckBox; count++)
				{
					if(objCheckBoxes[count].checked)
					{
						if(urlsToDelete.length > 0)
						{
							urlsToDelete += ",";
						}
						urlsToDelete += objCheckBoxes[count].value;
						selected = true;						
					}
					
				}
			}
			else
			{
				if(objCheckBoxes.checked)
				{
					urlsToDelete += objCheckBoxes.value + ":";
					selected = true;
				}
			}
		}
		document.getElementById("urlsToDelete").value = urlsToDelete;
	}
	
	if(op == "delete")
	{
		if(selected)
		{
			document.forms[0].submit();
		}
		else
		{
			if(op == "delete")
			{
				alert('<xlat:stream key="fatwire/SystemTools/WebReference/SelectURLForDelete" encode="false" escape="true" evalall="false"/>');
			}			
			selected = false;
		}
	}
	else
	{
		document.forms[0].submit();	
	}
}

function checkAll(key, source)
{
	var objCheckBoxes = document.forms["dataform"].elements[key];
	if(objCheckBoxes)
	{
		var totalCheckBox = objCheckBoxes.length;
		if(totalCheckBox)
		{
			for(var count=0; count < totalCheckBox; count++)
			{
				objCheckBoxes[count].checked = source.checked;
			}
		}
		else
		{
			objCheckBoxes.checked = source.checked;
		}
	}
}


</script>
</head>
<table class="width-outer-70" cellspacing="0" cellpadding="0" border="0">
<tbody>
<tr>
<td>
<span class="title-text"><xlat:stream key="fatwire/SystemTools/WebReference/Heading" encode="true" escape="false" evalall="false"/></span>
</td>
</tr>
<tr>
<td>
<img width="1" height="5" src="<%=contextPath%>/Xcelerate/graphics/common/screen/dotclear.gif">
</td>
</tr>
<tr>
<td style="border-bottom: 1px dashed #B9B9B9; clear: both; color: #9E9E9E; font-size: 12px;font-weight: bold;">
<img width="1" height="1" src="<%=contextPath%>/Xcelerate/graphics/common/screen/dotclear.gif">
</td>
</tr>
</tbody>
</table>
</br>
<div class="width-outer-70">
<b><xlat:stream key="fatwire/SystemTools/WebReference/SubHeading" encode="true" escape="false" evalall="false"/></b>
</div>

</br></br>
<%
	String operation = ics.GetVar(OPERATION);	
	int num = 0;
	String searchText = "";
	String fieldToSearch = ics.GetVar(SEARCH_CHOICE);
	String sortBy = "createddate";
	String resultsPerPage = StringUtils.defaultString(ics.GetVar("resultsPerPage"),"25");
	int pagesize =  Integer.parseInt(resultsPerPage);
	boolean isAscending =  ics.GetVar(SORT) == null || SORT_ASC.equalsIgnoreCase(ics.GetVar(SORT));
	String orderToSort = isAscending ? SORT_ASC : SORT_DESC;

	if(ics.GetVar("sortBy") != null)
	{
		sortBy = ics.GetVar("sortBy");
	} 
	if(ics.GetVar("searchText") != null)
	{
		searchText = ics.GetVar("searchText");
		if("webreferenceurl".equals(fieldToSearch))
		{	// User might have typed encoded or decoded url as part of search. So encode it before doing search
			searchText = WebReferencesManager.encodeURL(searchText);
		}
		
	}
	if(searchText != null && searchText.trim().length() > 0  && ! "delete".equalsIgnoreCase(operation))
	{
		operation = "search";
	}	
	if("load".equalsIgnoreCase(operation))
	{
			String sql = "select * from WebReferences  order by " + sortBy + " " + orderToSort;
			%>
			<ics:sql sql="<%=sql %>" listname="urllist" table="WebReferences" />
			<%
		
	}
	else if("search".equalsIgnoreCase(operation))
	{
		String sql = "";
		
		if( (searchText != null) && (searchText.trim().length() > 0) && (! "*".equalsIgnoreCase(searchText))) {
				sql = "select * from Webreferences where " + fieldToSearch + " like '%" + searchText + "%'" + " order by " + sortBy + " " + orderToSort;
		}
		else {
			sql = "select * from Webreferences order by " + sortBy + " " + orderToSort;
		}
%>
		<ics:sql sql='<%=sql %>' listname="urllist" table="WebReferences" />
<%
	}
	else if("delete".equalsIgnoreCase(operation))
	{
		String urlstoDelete = ics.GetVar("urlsToDelete");
		List<AssetId> assetsToTouch =  new LinkedList<AssetId>();
		List<String> webreferencesIdToDelete =  new LinkedList<String>();		
		if ( (urlstoDelete != null) && (urlstoDelete.trim().length() > 0) )
		{
			StringTokenizer tokenizer = new StringTokenizer(urlstoDelete, ",");
			while(tokenizer.hasMoreTokens())
			{
				String identifier = tokenizer.nextToken();
				if(identifier.indexOf(";") > 0)
				{
					StringTokenizer urlAssetIDTokenizer  = new StringTokenizer(identifier, ";");					
					String webreferencesIdString = urlAssetIDTokenizer.nextToken();
					String assetIdString = urlAssetIDTokenizer.nextToken();
					AssetId assetId = AssetUtil.toAssetId(assetIdString);
					if(assetId != null)
					{
						assetsToTouch.add(assetId);
						webreferencesIdToDelete.add(webreferencesIdString);
					}
				}
			}
		}
		for(AssetId asset:assetsToTouch )
		{
		%>
			 <asset:load name="assetToTouch" type='<%=asset.getType() %>' objectid='<%=asset.getId()+""%>'/>
		<% 
	 		Tags.assetTouch(ics,"assetToTouch",true);
		 }
		String deleteSql = "delete from Webreferences where id in  (" + StringUtils.join(webreferencesIdToDelete, ",") +")"; 
		
		
		String sql = "select * from Webreferences order by " + sortBy + " asc";
%>
		<ics:sql sql='<%=deleteSql%>' listname="deleteList" table="WebReferences" />		
		<ics:sql sql='<%=sql %>' listname="urllist" table="WebReferences" />		
<%
	}
%>
<!-- Handle Search here -->
<satellite:form action='<%=contextPath + "/ContentServer"%>' method="POST" name="dataform" id="dataform">
<input type="hidden" name="pagename" id="pagename" value="OpenMarket/Xcelerate/Admin/WebReferences"/>
<input type="hidden" name="op" id="op" value=""/>
<input type="hidden" name="urlsToDelete" id="urlsToDelete" value=""/>
<div>

<div style="float:left;margin-right:10px;margin-left:15px;" class="form-label-inset">
<xlat:stream key="fatwire/SystemTools/logs/ResultsPerPage" encode="true" escape="false" evalall="false"/>
</div>
<div style="float:left;margin-right:10px;">
   <input type="text" name="resultsPerPage" id="resultsPerPage" class="form-inset" size="4" value="<%=resultsPerPage%>">
</div>

<div style="float:left;margin-right:10px;margin-left:15px;" class="form-label-inset">
<xlat:stream key="dvin/Common/SearchCriteria" encode="true" escape="false" evalall="false"/>
</div>

<div style="float:left;margin-right:10px;">
<select name="searchChoice" id="searchChoice">
<option value="webroot" <%=ics.GetVar(SEARCH_CHOICE) == null || "webroot".equalsIgnoreCase(ics.GetVar(SEARCH_CHOICE)) ? "selected= \"\"" : "" %>><xlat:stream key='UI/Forms/WebRoot' encode="true" escape="false" evalall="false"/></option>
<option value="webreferenceurl" <%="webreferenceurl".equalsIgnoreCase(ics.GetVar(SEARCH_CHOICE)) ? "selected= \"\"" : "" %>><xlat:stream key='dvin/UI/CSAdminForms/URL' encode="true" escape="false" evalall="false"/></option>
<option value="template" <%="template".equalsIgnoreCase(ics.GetVar(SEARCH_CHOICE)) ? "selected= \"\"" : "" %>><xlat:stream key='dvin/UI/Template' encode="true" escape="false" evalall="false"/></option>
<option value="wrapper" <%="wrapper".equalsIgnoreCase(ics.GetVar(SEARCH_CHOICE)) ? "selected= \"\"" : "" %>><xlat:stream key='dvin/UI/Wrapper' encode="true" escape="false" evalall="false"/></option>
<option value="httpstatus"  <%="httpstatus".equalsIgnoreCase(ics.GetVar(SEARCH_CHOICE)) ? "selected= \"\"" : "" %>><xlat:stream key='UI/Forms/HttpStatus' encode="true" escape="false" evalall="false"/></option>
</select>
</div>

<div style="float:left;margin-right:10px;">
<%
	if(searchText != null && searchText.trim().length() > 0)
	{
%>
		<input type="text" size="30" name="searchText" id="searchText" value='<string:stream variable="searchText"/>'/>
<%
	}
	else
	{
%>
		<input type="text" size="30" name="searchText" id="searchText"/>
<%
	}
%>		
</div>

<div style="float:left;margin-right:20px;">

<a href="#">
<div class="button-left"></div>
<div class="button-middle">
	<div class="button-text" title="<xlat:stream key="dvin/Common/Search" encode="true" escape="false" evalall="false"/>" onclick="javascript:search('search');"><xlat:stream key="dvin/Common/Search" encode="true" escape="false" evalall="false"/></div>
</div>
<div class="button-right"></div>
</a>

</div>

<div>
<a href="#">
<div class="button-left"></div>
<div class="button-middle">
	<div class="button-text" title="<xlat:stream key="dvin/Common/Delete" encode="true" escape="false" evalall="false"/>" onclick="javascript:search('delete');"><xlat:stream key="dvin/Common/Delete" encode="true" escape="false" evalall="false"/></div>
</div>
<div class="button-right"></div>
</a>
</div>
<br><br>
</div>
<br/>
<table BORDER="0" CELLSPACING="0" CELLPADDING="0" style="margin-top: 5px; margin-left:15px;">
<tr>
	<td colspan="3" style="text-align: right;">

<%
	IList urlList = ics.GetList("urllist");
	int numPagesRequired = 1;
	if(urlList != null)
	{
		int totalCount = urlList.numRows();
		ics.SetVar("totalWebReferences", totalCount);
		// We are hardcoding the number of slots to be visible inside the table, i.e, 50
		if(totalCount % pagesize != 0)
		{
			numPagesRequired = (totalCount / pagesize) + 1;
		}
		else
		{
			numPagesRequired = totalCount / pagesize;
		}
	}
	
	String pageNum = ics.GetVar("pagenum");
	int fromPage = 1;
	if( (pageNum != null) && (pageNum.trim().length() > 0) )
	{
		fromPage = Integer.parseInt(pageNum);
	}
	int startFrom = (fromPage * pagesize) - pagesize;
	if(numPagesRequired == 1)
	{
%>
		<ics:setvar name="displayPage" value='<%=""+fromPage %>'/>
		<ics:setvar name="totalPages" value='<%=""+numPagesRequired %>'/>
		<xlat:stream key="dvin/UI/PageOf" encode="true" escape="false" evalall="true"/>
<%
	}
	else if(numPagesRequired > 1)
	{
		if(fromPage > 1)
		{
			String prevPageNum = "" + (fromPage - 1);
%>
		<satellite:link pagename="OpenMarket/Xcelerate/Admin/WebReferences" outstring="prevURL">
			<satellite:parameter name="op" value="load"/>
			<satellite:parameter name="sort" value="<%=orderToSort%>"/>
			<satellite:parameter name="pagenum" value='<%=prevPageNum %>'/>
			<satellite:parameter name="searchText" value='<%=searchText %>'/>
			<satellite:parameter name="searchChoice" value='<%=fieldToSearch %>'/>
			<satellite:parameter name="sortBy" value='<%=sortBy %>'/>
			<satellite:parameter name="resultsPerPage" value='<%=resultsPerPage%>'/>
		</satellite:link>		
			<a href='<%=ics.GetVar("prevURL")%>'><xlat:stream key="dvin/UI/Previous" encode="true" escape="false" evalall="false"/> <%=resultsPerPage%></a> &nbsp; | &nbsp;
<%
		}
%>
			<ics:setvar name="displayPage" value='<%=""+fromPage %>'/>
			<ics:setvar name="totalPages" value='<%=""+numPagesRequired %>'/>
			<xlat:stream key="dvin/UI/PageOf" encode="true" escape="false" evalall="true"/>
<%
		if(fromPage < numPagesRequired)
		{
			String nextPageNum = "" + (fromPage + 1);
%>
			<satellite:link pagename="OpenMarket/Xcelerate/Admin/WebReferences" outstring="nextURL">
				<satellite:parameter name="op" value="load"/>
				<satellite:parameter name="sort" value="<%=orderToSort%>"/>
				<satellite:parameter name="pagenum" value='<%=nextPageNum %>'/>
				<satellite:parameter name="searchText" value='<%=searchText %>'/>
				<satellite:parameter name="searchChoice" value='<%=fieldToSearch %>'/>
				<satellite:parameter name="sortBy" value='<%=sortBy %>'/>
				<satellite:parameter name="resultsPerPage" value='<%=resultsPerPage%>'/>
			</satellite:link>
			&nbsp; | &nbsp; <a href='<%=ics.GetVar("nextURL")%>'><xlat:stream key="dvin/Common/Next" encode="true" escape="false" evalall="false"/> <%=resultsPerPage%></a> &nbsp;&nbsp;
<%
		}
	}
%>

	</td>
</td>
<tr> 
    <td></td>
    <td class="tile-dark" HEIGHT="1"><IMG WIDTH="1" HEIGHT="1" src='<%=contextPath %>/Xcelerate/graphics/common/screen/dotclear.gif' /></td>
	<td></td>
</tr>
<tr>
<td class="tile-dark" VALIGN="top" WIDTH="1" nowrap="true"><br/></td>
<td>
<table width="100%" cellpadding="0" cellspacing="0" border="0" bgcolor="#ffffff" class="sortable">
	<thead>
	<tr>
		<td class="tile-a" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif'>&nbsp;</td>
		<th align="center" class="tile-b sorttable_nosort" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true"><input type="checkbox" onclick="javascript:checkAll('key', this);" id="selectAll" name="selectAll" class="checkboxLookup" /></th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">

		<% String sortByOrder = isAscending ?   SORT_DESC : SORT_ASC; %>
		<satellite:link pagename="OpenMarket/Xcelerate/Admin/WebReferences" outstring="sortURL">
			<satellite:parameter name="op" value="load"/>
			<satellite:parameter name="sort" value="<%=sortByOrder%>"/>
			<satellite:parameter name="sortBy" value="webroot"/>
			<satellite:parameter name="pagenum" value='<%=pageNum %>'/>
			<satellite:parameter name="searchText" value='<%=searchText %>'/>
			<satellite:parameter name="searchChoice" value='<%=fieldToSearch %>'/>
			<satellite:parameter name="resultsPerPage" value='<%=resultsPerPage%>'/>
		</satellite:link>

		<a href='<%=ics.GetVar("sortURL")%>' style="text-decoration: none">
			<span class="new-table-title"><xlat:stream key="UI/Forms/WebRoot" encode="true" escape="false" evalall="false"/></span>
			<%
				if(sortBy != null && "webroot".equalsIgnoreCase(sortBy))
				{	%>
					<span class="new-table-title" id="sorttable_sortfwdind"><%=(isAscending ? "&nbsp;&#x25be;" : "&nbsp;&#x25b4;")%></span><%
				}
			%>
			 
		</a>
		</th>
				
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b sorttable_sorted" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">

		<satellite:link pagename="OpenMarket/Xcelerate/Admin/WebReferences" outstring="sortURL">
			<satellite:parameter name="op" value="load"/>
			<satellite:parameter name="sort" value="<%=sortByOrder%>"/>
			<satellite:parameter name="sortBy" value="webreferenceurl"/>
			<satellite:parameter name="pagenum" value='<%=pageNum %>'/>
			<satellite:parameter name="searchText" value='<%=searchText %>'/>
			<satellite:parameter name="searchChoice" value='<%=fieldToSearch %>'/>
			<satellite:parameter name="resultsPerPage" value='<%=resultsPerPage%>'/>
		</satellite:link>

		<a href='<%=ics.GetVar("sortURL")%>' style="text-decoration: none">
			<span class="new-table-title"><xlat:stream key="dvin/UI/CSAdminForms/URL" encode="true" escape="false" evalall="false"/></span>
			<%
				if(sortBy != null && "webreferenceurl".equalsIgnoreCase(sortBy)) {
					%>
					<span class="new-table-title" id="sorttable_sortfwdind"><%=(isAscending ? "&nbsp;&#x25be;" : "&nbsp;&#x25b4;")%></span><%
				}
			%>
		</a>
		</th>
		
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>		
		<th class="tile-b sorttable_sorted" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">

		<satellite:link pagename="OpenMarket/Xcelerate/Admin/WebReferences" outstring="sortURL">
			<satellite:parameter name="op" value="load"/>
			<satellite:parameter name="sort" value="<%=sortByOrder%>"/>
			<satellite:parameter name="sortBy" value="assettype, assetid"/>
			<satellite:parameter name="pagenum" value='<%=pageNum %>'/>
			<satellite:parameter name="searchText" value='<%=searchText %>'/>
			<satellite:parameter name="searchChoice" value='<%=fieldToSearch %>'/>
			<satellite:parameter name="resultsPerPage" value='<%=resultsPerPage%>'/>
		</satellite:link>

		<a href='<%=ics.GetVar("sortURL")%>' style="text-decoration: none">
		<span class="new-table-title"><xlat:stream key='dvin/UI/Admin/AssetID' encode="true" escape="false" evalall="false"/></span>
		<%
			if(sortBy != null && "assettype, assetid".equalsIgnoreCase(sortBy)) {	
				%>
					<span class="new-table-title" id="sorttable_sortfwdind"><%=(isAscending ? "&nbsp;&#x25be;" : "&nbsp;&#x25b4;")%></span><%
			}
		%>
		</a>
		</th>
			
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b sorttable_sorted" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">

		<satellite:link pagename="OpenMarket/Xcelerate/Admin/WebReferences" outstring="sortURL">
			<satellite:parameter name="op" value="load"/>
			<satellite:parameter name="sort" value="<%=sortByOrder%>"/>
			<satellite:parameter name="sortBy" value="template"/>
			<satellite:parameter name="pagenum" value='<%=pageNum %>'/>
			<satellite:parameter name="searchText" value='<%=searchText %>'/>
			<satellite:parameter name="searchChoice" value='<%=fieldToSearch %>'/>
			<satellite:parameter name="resultsPerPage" value='<%=resultsPerPage%>'/>
		</satellite:link>

		<a href='<%=ics.GetVar("sortURL")%>' style="text-decoration: none">
		<span class="new-table-title"><xlat:stream key='dvin/UI/Template' encode="true" escape="false" evalall="false"/></span>
		<%
			if(sortBy != null && "template".equalsIgnoreCase(sortBy))
			{ %>
				<span class="new-table-title" id="sorttable_sortfwdind"><%=(isAscending ? "&nbsp;&#x25be;" : "&nbsp;&#x25b4;")%></span><%
			}
		%>
		</a>
		</th>
		
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b sorttable_sorted" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">

		<satellite:link pagename="OpenMarket/Xcelerate/Admin/WebReferences" outstring="sortURL">
			<satellite:parameter name="op" value="load"/>
			<satellite:parameter name="sort" value="<%=sortByOrder%>"/>
			<satellite:parameter name="sortBy" value="wrapper"/>
			<satellite:parameter name="pagenum" value='<%=pageNum %>'/>
			<satellite:parameter name="searchText" value='<%=searchText %>'/>
			<satellite:parameter name="searchChoice" value='<%=fieldToSearch %>'/>
			<satellite:parameter name="resultsPerPage" value='<%=resultsPerPage%>'/>
		</satellite:link>

		<a href='<%=ics.GetVar("sortURL")%>' style="text-decoration: none">
		<span class="new-table-title"><xlat:stream key='dvin/UI/Wrapper' encode="true" escape="false" evalall="false"/></span>
		<%
			if(sortBy != null && "wrapper".equalsIgnoreCase(sortBy)) {	
				%>
				<span class="new-table-title" id="sorttable_sortfwdind"><%=(isAscending ? "&nbsp;&#x25be;" : "&nbsp;&#x25b4;")%></span><%
			}
		%>
		</a>
		</th>
		
			
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b sorttable_sorted" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">

		<satellite:link pagename="OpenMarket/Xcelerate/Admin/WebReferences" outstring="sortURL">
			<satellite:parameter name="op" value="load"/>
			<satellite:parameter name="sort" value="<%=sortByOrder%>"/>
			<satellite:parameter name="sortBy" value="httpstatus"/>
			<satellite:parameter name="pagenum" value='<%=pageNum %>'/>
			<satellite:parameter name="searchText" value='<%=searchText %>'/>
			<satellite:parameter name="searchChoice" value='<%=fieldToSearch %>'/>
			<satellite:parameter name="resultsPerPage" value='<%=resultsPerPage%>'/>
		</satellite:link>

		<a href='<%=ics.GetVar("sortURL")%>' style="text-decoration: none">
		<span class="new-table-title"><xlat:stream key='UI/Forms/HttpStatus' encode="true" escape="false" evalall="false"/></span>		
		<%
			if(sortBy != null && "httpstatus".equalsIgnoreCase(sortBy))
			{	
				%>
				<span class="new-table-title" id="sorttable_sortfwdind"><%=(isAscending ? "&nbsp;&#x25be;" : "&nbsp;&#x25b4;")%></span><%
			}
		%>
		</a>
		</th>

		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;</th>
		</tr>
	</thead>
	<tbody>

		 <%
		
		 if(urlList != null && urlList.hasData())
		 {
			 
		 for (int i=startFrom; urlList.moveToRow(IList.gotorow, i+1); i++)
		  {
			 String webreferenceurl = urlList.getValue("webreferenceurl");
			 String assetid = urlList.getValue("assetid");
			 String assettype = urlList.getValue("assettype");
			 String httpstatus = urlList.getValue("httpstatus");
			 String webroot = urlList.getValue("webroot");
			 String template = urlList.getValue("template");
			 String wrapper = urlList.getValue("wrapper");
			 String id = urlList.getValue("id");
		 	if (num % 2 !=0) 
			{ 
		%>
				<tr class="tile-row-highlight">
		<% 
			}
			else {
	  	%>
				<tr class="tile-row-normal">
		<% 
			} 
		%>
			<td><br/></td>
			<td valign="top" align="left"><input type="checkbox" value='<%=id +";" +assettype + ":" +assetid%>' id="key" name="key"/></td>
        	<td><br/></td>
        	
        	<td VALIGN="TOP" ALIGN="Center">
		    	<DIV class="small-text-inset"><string:stream value='<%=webroot%>'/></div>
			</td>
			<td></td><td></td><td></td><td></td>
			
			
			<td VALIGN="TOP" ALIGN="Center">		    	
		    	<DIV class="small-text-inset"><string:stream value='<%=WebReferencesManager.decodeURL(webreferenceurl)%>'/></div>
			</td>
			<td></td>
			<td></td><td></td><td></td>
			
			<td VALIGN="TOP" ALIGN="Center">
		    	<DIV class="small-text-inset"><string:stream value='<%=assettype+":"+assetid%>'/></div>
			</td>
			<td></td>
			<td></td><td></td><td></td>
			
			<td VALIGN="TOP" ALIGN="Center">
		    	<DIV class="small-text-inset"><string:stream value='<%=template%>'/></div>
			</td>
			<td></td>
			<td></td><td></td><td></td>
			
				
			<td VALIGN="TOP" ALIGN="Center">
		    	<DIV class="small-text-inset"><string:stream value='<%=wrapper%>'/></div>
			</td>
			<td></td>
			<td></td><td></td><td></td>
			
			
			<td VALIGN="TOP" ALIGN="Center">
		    	<DIV class="small-text-inset"><string:stream value='<%=httpstatus%>'/></div>
			</td>
			<td></td>
			</tr>
		<%
		    ++num;
			if(num == pagesize)
				break;
		  }
		 }

	if(urlList == null || !urlList.hasData())
	{
%>
<tr>
	<td colspan="26" align="center"><xlat:stream key="UI/Forms/NoUrlsFound" encode="true" escape="false" evalall="false"/></td>
</tr>
<%		
	}
 %>	
		

</tbody>
</table>
</td>
<td class="tile-dark" VALIGN="top" WIDTH="1" nowrap="true"><br/></td>
</tr>
 <tr>
	<td></td>
	<td class="tile-dark" height="1"><img width="1" height="1" src='<%=contextPath %>/Xcelerate/graphics/common/screen/dotclear.gif'></td>
	<td></td>
</tr>
</table>	
</satellite:form>
</html>
</cs:ftcs>