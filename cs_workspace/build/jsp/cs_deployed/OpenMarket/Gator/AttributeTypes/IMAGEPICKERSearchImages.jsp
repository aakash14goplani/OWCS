<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" 
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld" 
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld" 
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld" 
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"
%><%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld"
%><%@ taglib prefix="locale" uri="futuretense_cs/locale1.tld"
%><%//
// OpenMarket/Gator/AttributeTypes/IMAGEPICKERSearchImages
//
// INPUT
//
// OUTPUT
//
// For the search to work, the asset type that is going to be searched has to be enabled
// for search engine Global index source and indexed by the search engine first.
//
// To enable the asset type and index for search, Login CS Direct interface with user that
// has previlege to access Admin tab. After login, click on Admin tab, expand search, and click
// on Configure Global Search, select add from dropdown list, check the asset type and click
// OK. Click Ok in the popup confirm window.
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="com.fatwire.cs.core.search.source.IndexSourceConfig" %>
<%@ page import="com.fatwire.search.source.IndexSourceConfigImpl" %>
<%@ page import="com.fatwire.search.engine.SearchEngineConfigImpl" %>
<%@ page import="com.fatwire.cs.core.search.source.IndexSourceMetadata" %>
<%@ page import="com.fatwire.cs.core.search.query.QueryExpression" %>
<%@ page import="com.fatwire.search.query.QueryExpressionImpl" %>
<%@ page import="com.fatwire.search.query.SortOrderImpl"%>
<%@ page import="com.fatwire.search.source.SearchIndexFields" %>
<%@ page import="com.fatwire.cs.core.search.query.Operation" %>
<%@ page import="com.fatwire.cs.core.search.query.SortOrder" %>
<%@ page import="com.fatwire.cs.core.search.data.ResultRow" %>
<%@ page import="com.fatwire.cs.core.search.engine.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="com.fatwire.util.SearchResultComparator" %>
<%!

    /**
     * Parses the date for the given format
     *
     * @param date the date string to be parsed.
     * @param format the date format of the string, such as yyyy/MM/dd.
     * @return the Date object represented by the string.
     * @throws ParseException if the string cannot be parsed as a Date object.
     */
    public static Date parseDate(String date, String format) throws ParseException
    {
        if (date != null)
        {
            SimpleDateFormat sformat = new SimpleDateFormat(format);
            return sformat.parse(date);
        }
        return new Date();
    }

%>
<cs:ftcs>
    <xlat:lookup key="dvin/UI/Common/NotApplicableAbbrev" varname="_NA_"/>
    <listobject:create name="lo" columns="id,name,startdate,enddate"/>
<%

    String searchTerm = ics.GetVar( "searchterm" );
    String category = ics.GetVar( "category" );
    String currentSite = ics.GetSSVar( "pubid" );
    String assettype = ics.GetVar( "ASSETTYPENAMEOUT");
	String displayPage=ics.GetVar( "displayPage");
	if(displayPage == null){
		displayPage = "1";
	}
	String resultsPerPage=ics.GetVar( "resultsPerPage");
	String sortBy=ics.GetVar("sortBy");
	String ascending=ics.GetVar( "ascending");
	IndexSourceConfig srcConfig = new IndexSourceConfigImpl( ics );
    SearchEngineConfig engConfig = new SearchEngineConfigImpl( ics );
    IndexSourceMetadata sourceMd = srcConfig.getConfiguration( "Global" );
    String engineName = sourceMd.getSearchEngineName();
    SearchEngine eng = engConfig.getEngine( engineName );
    QueryExpression expr = null;
    QueryExpression siteExpr = new QueryExpressionImpl( SearchIndexFields.Global.SITEID, Operation.CONTAINS, currentSite );
    siteExpr = siteExpr.or( SearchIndexFields.Global.SITEID, Operation.EQUALS, "0" );
    if ( searchTerm != null )
    {
        expr = new QueryExpressionImpl( sourceMd.getDefaultSearchField(),
                                    Operation.CONTAINS, searchTerm );
        expr = expr.and( siteExpr );
    }
    else
	{
		expr = siteExpr;
		if( category != null )
		{
			expr =  expr.and( new QueryExpressionImpl( sourceMd.getDefaultSearchField(),
                                    Operation.CONTAINS, ics.GetVar("category") ));
		}
	}
	expr = expr.and(SearchIndexFields.Global.ASSET_TYPE, Operation.EQUALS, assettype);
	//Paginate the result
	int startIndex = -1;
	try {
		startIndex = (Integer.parseInt(displayPage) -1) * Integer.parseInt(resultsPerPage);
	} catch (NumberFormatException nfe) {
		startIndex = 0;
	}
	int endIndex = startIndex + Integer.parseInt(resultsPerPage);   // Calculate the end index
	expr.setStartIndex(startIndex);
	
	SearchResult<ResultRow> res_count = eng.search( Collections.singletonList( "Global" ), expr );
	expr.setMaxResults(Integer.parseInt(resultsPerPage));
	try
    {
        
		SearchResult<ResultRow> res = eng.search( Collections.singletonList( "Global" ), expr );
		//Use the search results comparator to sort the search results by the given sortBy attribute
		SearchResultComparator comp = new SearchResultComparator(ics.GetVar("sortBy"));
		List<ResultRow> results = null;
		List<ResultRow> results_count = null;
		
		if(ics.GetVar("sortBy").equals("updateddate")){
			//updated date results - must be descending 
			results = comp.sort(res,false);
			results_count = comp.sort(res_count,false);
		}
		else
		{
			results = comp.sort(res);
			results_count = comp.sort(res_count);
		}
		int resultCounter = 0;
		int counter = startIndex;
		for(ResultRow r:results_count)
		{
			String assetid = r.getIndexData("id").getData();
			 String name = r.getIndexData( "name").getData();
			if ( null != category && category.length() > 0 )
			{
		%>
				<assetset:setasset name='rasset' type='<%=assettype%>' id='<%=assetid%>'/>
				<assetset:getattributevalues name='rasset' typename='<%=ics.GetVar("ATTRIBUTETYPENAMEOUT")%>' attribute='<%=ics.GetVar("CATEGORYATTRIBUTENAMEOUT")%>'  listvarname='outlist'/>
				<ics:if condition='<%=ics.GetList("outlist")!=null && ics.GetList("outlist").hasData()%>'>
				<ics:then>
				<ics:listloop listname='outlist'>
				<ics:listget listname='outlist' fieldname='value' output='categoryvalue'/>
		<%
				if ( category.equals( ics.GetVar( "categoryvalue")))
				{
					counter++;
				}
		%>
				</ics:listloop>
				</ics:then>
				</ics:if>
		<%
			}
		}
		for ( ResultRow r : results )
        {
            String assetid = r.getIndexData( SearchIndexFields.Global.ID).getData();
            String name = r.getIndexData( SearchIndexFields.Global.NAME).getData();
			String startDate = r.getIndexData( SearchIndexFields.Global.STARTDATE).getData();
			String endDate = r.getIndexData( SearchIndexFields.Global.ENDDATE).getData();
            boolean add = true;
            if ( null != assetid && assetid.length() > 0 )
            {
                if ( null != category && category.length() > 0 )
                {
                    add = false;
    %>
                    <assetset:setasset name='rasset' type='<%=assettype%>' id='<%=assetid%>'/>
                    <assetset:getattributevalues name='rasset' typename='<%=ics.GetVar("ATTRIBUTETYPENAMEOUT")%>' attribute='<%=ics.GetVar("CATEGORYATTRIBUTENAMEOUT")%>'  listvarname='outlist'/>
                    <ics:if condition='<%=ics.GetList("outlist")!=null && ics.GetList("outlist").hasData()%>'>
                    <ics:then>
                    <ics:listloop listname='outlist'>
                    <ics:listget listname='outlist' fieldname='value' output='categoryvalue'/>
    <%
                    if ( category.equals( ics.GetVar( "categoryvalue")))
                    {
                        add = true;
                    }
    %>
                    </ics:listloop>
                    </ics:then>
                    </ics:if>
    <%
                }
                if ( add )
                {

					if(startDate == null || "".equals(startDate))
						startDate = ics.GetVar("_NA_");
					else
					{
                        %>
                        <locale:create varname="localename" localename='<%=ics.GetSSVar("locale")%>' />
                        <dateformat:create name="_formatdate_" datestyle="SHORT" locale="localename" timezoneid='<%=ics.GetSSVar("time.zone")%>'/>
                        <dateformat:getdate name="_formatdate_" value='<%=String.valueOf(parseDate(startDate, "yyyyMMddHHmmssSSS").getTime())%>' valuetype="milliseconds" varname="formattedStartDate"/>
                        <%
                        startDate = ics.GetVar("formattedStartDate");
                    }
					if(endDate == null || "".equals(endDate))
						endDate = ics.GetVar("_NA_");
					else
					{
                        %>
                        <locale:create varname="localename" localename='<%=ics.GetSSVar("locale")%>' />
                        <dateformat:create name="_formatdate_" datestyle="SHORT" locale="localename" timezoneid='<%=ics.GetSSVar("time.zone")%>'/>
                        <dateformat:getdate name="_formatdate_" value='<%=String.valueOf(parseDate(endDate, "yyyyMMddHHmmssSSS").getTime())%>' valuetype="milliseconds" varname="formattedEndDate"/>                        <%
                        endDate = ics.GetVar("formattedEndDate");
					}

				%>
                    <listobject:addrow name="lo">
                       <listobject:argument name="id" value='<%=assetid%>'/>
                       <listobject:argument name="name" value='<%=name%>'/>
					   <listobject:argument name="startdate" value='<%=startDate%>' />
					   <listobject:argument name="enddate" value='<%=endDate%>' />
                   </listobject:addrow>
				<%
                }
            }
		resultCounter++;
        }
		int totalRows = res.getTotal();
		if(category!=null)
			totalRows=counter;
		ics.SetVar("totalImages",totalRows);
		int totalPages = (int)Math.ceil(((double)totalRows) / Integer.parseInt(resultsPerPage));
		ics.SetVar("totalPages",totalPages);
		ics.SetVar("displayPage",displayPage);
		if (endIndex > totalRows)
        {
            endIndex = totalRows;
        }
        if(totalRows > 0)
        {
            //set these ics vars for locale string used below
            ics.SetVar("Start", Integer.toString(startIndex + 1));
            ics.SetVar("End", Integer.toString(endIndex));
            ics.SetVar("Total", totalRows);
		%>
		<span class="imagename" style="margin-left:20px;margin-top:0px">
            <xlat:stream key="dvin/UI/Common/ShowingStartthroughEndofTotal"/>
        </span><br/>
        <%
        }
    }
    catch( SearchEngineException ex )
    {
        ics.SetVar("AssetType", assettype);
%><xlat:stream key="dvin/UI/Search/IndexesforATmightnotexist"/><br/>
    <%=ex%>
<%
    }
%>
    <listobject:tolist name="lo" listvarname="Images"/>
</cs:ftcs>
