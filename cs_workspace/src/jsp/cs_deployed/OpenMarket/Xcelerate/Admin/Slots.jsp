<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="com.openmarket.ICS.listloop"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="com.fatwire.composition.slots.SlotsManager"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%//
// OpenMarket/Xcelerate/Admin/Slots
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
	if(op == "delete" || op == "void")
	{
		var assetToDelete = "";
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
						assetToDelete += objCheckBoxes[count].value + ":";
						selected = true;
					}
				}
			}
			else
			{
				if(objCheckBoxes.checked)
				{
					assetToDelete += objCheckBoxes.value + ":";
					selected = true;
				}
			}
		}
		document.getElementById("assetToDelete").value = assetToDelete;
	}
	
	if(op == "delete" || op == "void")
	{
		if(selected)
		{
			document.forms[0].submit();
		}
		else
		{
			if(op == "delete")
			{
				alert('<xlat:stream key="dvin/Common/DeleteAssetMessgae" encode="false" escape="true" evalall="false"/>');
			}
			else
			{
				alert('<xlat:stream key="dvin/Common/VoidAssetMessgae" encode="false" escape="true" evalall="false"/>');
			}
			selected = false;
		}
	}
	else
	{
		document.forms[0].submit();	
	}
}

function checkAllSlots(key, source)
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
<span class="title-text"><xlat:stream key="fatwire/SystemTools/Slots/Heading" encode="true" escape="false" evalall="false"/></span>
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
<b><xlat:stream key="fatwire/SystemTools/Slots/SubHeading" encode="true" escape="false" evalall="false"/></b>
</div>

</br></br>
<%
	String operation = ics.GetVar(OPERATION);
	int num = 0;
	String searchText = "";
	String fieldToSearch = ics.GetVar(SEARCH_CHOICE);
	String sortBy = "name";
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
	}
	if(searchText != null && searchText.trim().length() > 0  && ! "delete".equalsIgnoreCase(operation) && !"void".equalsIgnoreCase(operation))
	{
		operation = "search";
	}
	if("load".equalsIgnoreCase(operation))
	{
		String sql = "select * from Slots  where status != 'VO' order by " + sortBy + " " + orderToSort;
		%>
			<ics:sql sql="<%=sql %>" listname="slotlist" table="Slots" />
      		<%
	}
	else if("search".equalsIgnoreCase(operation))
	{
		String sql = "";
		if( (searchText != null) && (searchText.trim().length() > 0) && (! "*".equalsIgnoreCase(searchText)))
		{
			sql = "select * from Slots where " + fieldToSearch + " like '%" + searchText + "%'" + " AND status != 'VO' " + "order by " + sortBy + " " + orderToSort;
		}
		else
		{
			sql = "select * from Slots where status != 'VO' order by " + sortBy + " " + orderToSort;
		}
%>
		<ics:sql sql='<%=sql %>' listname="slotlist" table="Slots" />
<%
	}
	else if("delete".equalsIgnoreCase(operation) || "void".equalsIgnoreCase(operation))
	{
		String assetsToDelete = ics.GetVar("assetToDelete");
		if ( (assetsToDelete != null) && (assetsToDelete.trim().length() > 0) )
		{
			if(assetsToDelete.indexOf(":") > 0)
			{
				assetsToDelete = assetsToDelete.substring(0, assetsToDelete.lastIndexOf(":"));
			}
			
			StringTokenizer tokenizer = new StringTokenizer(assetsToDelete, ":");
			while(tokenizer.hasMoreTokens())
			{
				String assetId = tokenizer.nextToken();
%>
				 <asset:load name="slottodelete" type='Slots' objectid='<%=assetId%>'/>
<% 
				 if("delete".equalsIgnoreCase(operation))
				 {
%>
				 	<asset:delete name="slottodelete"/>
<%
				 }
				 else
				 {
%>
				 	<asset:void name="slottodelete"/>
<%
				 }
			}
		}
		String sql = "select * from Slots where status != 'VO' order by " + sortBy + " asc";
%>
		<ics:sql sql='<%=sql %>' listname="slotlist" table="Slots" />
<%
	}
%>
<!-- Handle Search here -->
<satellite:form action='<%=contextPath + "/ContentServer"%>' method="POST" name="dataform" id="dataform">
<input type="hidden" name="pagename" id="pagename" value="OpenMarket/Xcelerate/Admin/Slots"/>
<input type="hidden" name="op" id="op" value=""/>
<input type="hidden" name="assetToDelete" id="assetToDelete" value=""/>
<div>
<div style="float:left;margin-right:10px;margin-left:15px;" class="form-label-inset">

<div style="float:left;margin-right:10px;margin-left:15px;" class="form-label-inset">
<xlat:stream key="fatwire/SystemTools/logs/ResultsPerPage" encode="true" escape="false" evalall="false"/>
</div>
<div style="float:left;margin-right:10px;">
   <input type="text" name="resultsPerPage" id="resultsPerPage" class="form-inset" size="4" value="<%=resultsPerPage%>">
</div>

<div style="float:left;margin-right:10px;margin-left:15px;">
<xlat:stream key="dvin/Common/SearchCriteria" encode="true" escape="false" evalall="false"/>
</div>

<div style="float:left;margin-right:10px;">
<select name="searchChoice" id="searchChoice">
<option value="name" <%=ics.GetVar(SEARCH_CHOICE) == null || "name".equalsIgnoreCase(ics.GetVar(SEARCH_CHOICE)) ? "selected= \"\"" : "" %>><xlat:stream key="fatwire/SystemTools/Slots/SlotName" encode="true" escape="false" evalall="false"/></option>
<option value="site" <%="site".equalsIgnoreCase(ics.GetVar(SEARCH_CHOICE)) ? "selected= \"\"" : "" %>><xlat:stream key="dvin/Common/Site" encode="true" escape="false" evalall="false"/></option>
<option value="context" <%="context".equalsIgnoreCase(ics.GetVar(SEARCH_CHOICE)) ? "selected= \"\"" : "" %>><xlat:stream key="dvin/Common/context" encode="true" escape="false" evalall="false"/></option>
<option value="templatename" <%="templatename".equalsIgnoreCase(ics.GetVar(SEARCH_CHOICE)) ? "selected= \"\"" : "" %>><xlat:stream key="dvin/Common/Template" encode="true" escape="false" evalall="false"/></option>
<option value="primaryassetid"  <%="primaryassetid".equalsIgnoreCase(ics.GetVar(SEARCH_CHOICE)) ? "selected= \"\"" : "" %>><xlat:stream key="dvin/UI/Admin/PrimaryAssetId" encode="true" escape="false" evalall="false"/></option>
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

<div style="float:left;margin-right:20px;">

<a href="#">
<div class="button-left"></div>
<div class="button-middle">
	<div class="button-text" title="<xlat:stream key="dvin/Common/VoidAsset" encode="true" escape="false" evalall="false"/>" onclick="javascript:search('void');"><xlat:stream key="dvin/Common/VoidAsset" encode="true" escape="false" evalall="false"/></div>
</div>
<div class="button-right"></div>
</a>

</div>

<div style="float:left;margin-right:20px;">
<a href="#">
<div class="button-left"></div>
<div class="button-middle">
	<div class="button-text" title="<xlat:stream key="dvin/Common/Delete" encode="true" escape="false" evalall="false"/>" onclick="javascript:search('delete');"><xlat:stream key="dvin/Common/Delete" encode="true" escape="false" evalall="false"/></div>
</div>
<div class="button-right"></div>
</a>
</div>
</div>
<br/>
<table BORDER="0" CELLSPACING="0" CELLPADDING="0" style="margin-top: 5px; margin-left:15px;">
<tr>
	<td colspan="3" style="text-align:right;">

<%
	IList slotList = ics.GetList("slotlist");
	int numPagesRequired = 1;
	
	if(slotList != null)
	{
		int totalCount = slotList.numRows();
		ics.SetVar("totalSlots", totalCount);
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
		<satellite:link pagename="OpenMarket/Xcelerate/Admin/Slots" outstring="prevURL">
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
%><satellite:link pagename="OpenMarket/Xcelerate/Admin/Slots" outstring="nextURL">
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
</tr>
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
		<th align="center" class="tile-b sorttable_nosort" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true"><input type="checkbox" onclick="javascript:checkAllSlots('key', this);" id="selectAll" name="selectAll" class="checkboxLookup" /></th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">
<%
		String sortByOrder = isAscending ?   SORT_DESC : SORT_ASC;
		%>
			<satellite:link pagename="OpenMarket/Xcelerate/Admin/Slots" outstring="sortURL">
				<satellite:parameter name="op" value="load"/>
				<satellite:parameter name="sort" value="<%=sortByOrder%>"/>
				<satellite:parameter name="sortBy" value="name"/>
				<satellite:parameter name="pagenum" value='<%=pageNum %>'/>
				<satellite:parameter name="searchText" value='<%=searchText %>'/>
				<satellite:parameter name="searchChoice" value='<%=fieldToSearch %>'/>
				<satellite:parameter name="resultsPerPage" value='<%=resultsPerPage%>'/>
			</satellite:link>
			<a href='<%=ics.GetVar("sortURL")%>' style="text-decoration: none">
				<span class="new-table-title"><xlat:stream key="fatwire/SystemTools/Slots/SlotName" encode="true" escape="false" evalall="false"/></span>
				<%
					if(sortBy != null && "name".equalsIgnoreCase(sortBy))
					{	
						if(isAscending){ %>
							<span class="new-table-title" id="sorttable_sortfwdind">&nbsp;&#x25be;</span>
						<%}else{ %>
							<span class="new-table-title" id="sorttable_sortfwdind">&nbsp;&#x25b4;</span>
						<%}
					}
				%>
				 
			</a>
		</th>
				
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b sorttable_sorted" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">

		<satellite:link pagename="OpenMarket/Xcelerate/Admin/Slots" outstring="sortURL">
			<satellite:parameter name="op" value="load"/>
			<satellite:parameter name="sort" value="<%=sortByOrder%>"/>
			<satellite:parameter name="sortBy" value="site"/>
			<satellite:parameter name="pagenum" value='<%=pageNum %>'/>
			<satellite:parameter name="searchText" value='<%=searchText %>'/>
			<satellite:parameter name="searchChoice" value='<%=fieldToSearch %>'/>
			<satellite:parameter name="resultsPerPage" value='<%=resultsPerPage%>'/>
		</satellite:link>

		<a href='<%=ics.GetVar("sortURL")%>' style="text-decoration: none">
			<span class="new-table-title">
				<xlat:stream key="dvin/Common/Site" encode="true" escape="false" evalall="false"/>
			</span>
			<%
				if(sortBy != null && "site".equalsIgnoreCase(sortBy))
				{	
					if(isAscending){ %>
						<span class="new-table-title" id="sorttable_sortfwdind1">&nbsp;&#x25be;</span>
					<%}else{ %>
						<span class="new-table-title" id="sorttable_sortfwdind1">&nbsp;&#x25b4;</span>
					<%}
				}
			%>
		</a>
		</th>
		
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b sorttable_sorted" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">

		<satellite:link pagename="OpenMarket/Xcelerate/Admin/Slots" outstring="sortURL">
			<satellite:parameter name="op" value="load"/>
			<satellite:parameter name="sort" value="<%=sortByOrder%>"/>
			<satellite:parameter name="sortBy" value="context"/>
			<satellite:parameter name="pagenum" value='<%=pageNum %>'/>
			<satellite:parameter name="searchText" value='<%=searchText %>'/>
			<satellite:parameter name="searchChoice" value='<%=fieldToSearch %>'/>
			<satellite:parameter name="resultsPerPage" value='<%=resultsPerPage%>'/>
		</satellite:link>

		<a href='<%=ics.GetVar("sortURL")%>' style="text-decoration: none">
		<span class="new-table-title">
			<xlat:stream key="dvin/Common/context" encode="true" escape="false" evalall="false"/>
		</span>
		<%
			if(sortBy != null && "context".equalsIgnoreCase(sortBy))
			{	
				if(isAscending){ %>
					<span class="new-table-title" id="sorttable_sortfwdind2">&nbsp;&#x25be;</span>
				<%}else{ %>
					<span class="new-table-title" id="sorttable_sortfwdind2">&nbsp;&#x25b4;</span>
				<%}
			}
		%>
		</a>
		</th>
		
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b sorttable_sorted" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">

		<satellite:link pagename="OpenMarket/Xcelerate/Admin/Slots" outstring="sortURL">
			<satellite:parameter name="op" value="load"/>
			<satellite:parameter name="sort" value="<%=sortByOrder%>"/>
			<satellite:parameter name="sortBy" value="templatename"/>
			<satellite:parameter name="pagenum" value='<%=pageNum %>'/>
			<satellite:parameter name="searchText" value='<%=searchText %>'/>
			<satellite:parameter name="searchChoice" value='<%=fieldToSearch %>'/>
			<satellite:parameter name="resultsPerPage" value='<%=resultsPerPage%>'/>
		</satellite:link>

		<a href='<%=ics.GetVar("sortURL")%>' style="text-decoration: none">
		<span class="new-table-title">
			<xlat:stream key="dvin/Common/Template" encode="true" escape="false" evalall="false"/>
		</span>
		<%
			if(sortBy != null && "templatename".equalsIgnoreCase(sortBy))
			{	
				if(isAscending){ %>
					<span class="new-table-title" id="sorttable_sortfwdind3">&nbsp;&#x25be;</span>
				<%}else{ %>
					<span class="new-table-title" id="sorttable_sortfwdind3">&nbsp;&#x25b4;</span>
				<%}
			}
		%>
		</a>
		</th>
		
			
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
		<th class="tile-b sorttable_sorted" background='<%=contextPath %>/Xcelerate/graphics/common/screen/grad.gif' nowrap="true">

		<satellite:link pagename="OpenMarket/Xcelerate/Admin/Slots" outstring="sortURL">
			<satellite:parameter name="op" value="load"/>
			<satellite:parameter name="sort" value="<%=sortByOrder%>"/>
			<satellite:parameter name="sortBy" value="primaryassetid"/>
			<satellite:parameter name="pagenum" value='<%=pageNum %>'/>
			<satellite:parameter name="searchText" value='<%=searchText %>'/>
			<satellite:parameter name="searchChoice" value='<%=fieldToSearch %>'/>
			<satellite:parameter name="resultsPerPage" value='<%=resultsPerPage%>'/>
		</satellite:link>

		<a href='<%=ics.GetVar("sortURL")%>' style="text-decoration: none">
		<span class="new-table-title">
			<xlat:stream key="dvin/UI/Admin/PrimaryAssetId" encode="true" escape="false" evalall="false"/>
		</span>
		
		<%
			if(sortBy != null && "primaryassetid".equalsIgnoreCase(sortBy))
			{	
				if(isAscending){ %>
					<span class="new-table-title" id="sorttable_sortfwdind3">&nbsp;&#x25be;</span>
				<%}else{ %>
					<span class="new-table-title" id="sorttable_sortfwdind3">&nbsp;&#x25b4;</span>
				<%}
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
		 if(slotList != null && slotList.hasData())
		 {
			 
		 for (int i=startFrom; slotList.moveToRow(IList.gotorow, i+1); i++)
		  {
		    String className = (num & 1)  == 1 ? "tile-row-highlight" : "tile-row-normal";
		  	out.println("<tr class='" + className+"'>");
		  	%>
			<ics:listget listname="slotlist" fieldname="name" output="slotname"/>
			<ics:listget listname="slotlist" fieldname="site" output="siteforslot"/>
			<ics:listget listname="slotlist" fieldname="templatename" output="templateforslot"/>
			<ics:listget listname="slotlist" fieldname="context" output="contextforslot"/>
			<ics:listget listname="slotlist" fieldname="primaryassetid" output="pageidforslot"/>
			<ics:listget listname="slotlist" fieldname="id" output="idforslot"/>
			<td><br/></td>
			<td valign="top" align="left"><input type="checkbox" value='<%=ics.GetVar("idforslot") %>' id="key" name="key"/></td>
        	<td><br/></td>
        	
        	<td VALIGN="TOP" ALIGN="Center">
		    	<DIV class="small-text-inset"><string:stream value='<%=ics.GetVar("slotname") %>'/></div>
			</td>
			<td></td><td></td><td></td><td></td>
			
			
			<td VALIGN="TOP" ALIGN="Center">
		    	<DIV class="small-text-inset"><string:stream value='<%=ics.GetVar("siteforslot") %>'/></div>
			</td>
			<td></td>
			<td></td><td></td><td></td>
			
			<td VALIGN="TOP" ALIGN="Center">
		    	<DIV class="small-text-inset"><string:stream value='<%=ics.GetVar("contextforslot") %>'/></div>
			</td>
			<td></td>
			<td></td><td></td><td></td>
			
			<td VALIGN="TOP" ALIGN="Center">
		    	<DIV class="small-text-inset"><string:stream value='<%=ics.GetVar("templateforslot") %>'/></div>
			</td>
			<td></td>
			<td></td><td></td><td></td>
			
			
			<td VALIGN="TOP" ALIGN="Center">
		    	<DIV class="small-text-inset"><string:stream value='<%=ics.GetVar("pageidforslot") %>'/></div>
			</td>
			<td></td>
			</tr>
		<%
		    ++num;
			if(num == pagesize)
				break;
		  }
		 }

	if(slotList == null || !slotList.hasData())
	{
%>
<tr>
	<td colspan="26" align="center"><xlat:stream key="dvin/UI/NoAssetsFound" encode="true" escape="false" evalall="false"/></td>
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