<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// search/search
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
<%@ page import="com.fatwire.search.source.*"%>
<%@ page import="com.fatwire.search.engine.*"%>
<%@ page import="com.fatwire.search.query.*"%>
<%@ page import="com.fatwire.cs.core.search.query.*"%>
<%@ page import="com.fatwire.cs.core.search.source.*"%>
<%@ page import="com.fatwire.cs.core.search.engine.*"%>
<%@ page import="com.fatwire.cs.core.search.query.*"%>
<%@ page import="com.fatwire.cs.core.search.data.*"%>
<%@ page import="java.util.*"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>

<cs:ftcs>
<%	
	String sQuery = request.getParameter( "expr" );
	sQuery = StringEscapeUtils.escapeHtml(sQuery);
	String sourceName = request.getParameter( "source" );
	sourceName = StringEscapeUtils.escapeHtml(sourceName);
	String startNum = request.getParameter( "start" );
	String endNum = request.getParameter( "end" );
	IndexSourceConfigImpl con = new IndexSourceConfigImpl( ics );
	List<String> indexSources  = con.getIndexSources();
%>

<table border="0">
	<satellite:form name="search" action="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search" method="POST">
		<tr>
			<td>Search for
			</td>
			<td>
				<input name="expr" value="<%=null == sQuery? "" : sQuery%>" size=50>
			</td>
			<td>
				in
			</td>
			<td>
				<select name="source">
				<%
					for( String source : indexSources )
					{
						%><option value="<%=source%>"><%=source%></option><%		
					}
				%>
				</select>
			</td>
			<td>
				<input type="submit" value="Search" name="B1">
			</TD>
		</tr>	
	</satellite:form>
</table>

<%
	try
	{
		if( null != sQuery && sQuery.length() > 0  )
		{
			sQuery = sQuery.toLowerCase();
			// search with this phrase:
			// first get SearchEngine
			IndexSourceMetadata metadata = con.getConfiguration( sourceName );
			String engineName = metadata.getSearchEngineName();
			//out.println( "Engine name " + engineName );
			
			SearchEngineConfigImpl searchConfig = new SearchEngineConfigImpl( ics );
			SearchEngine eng = searchConfig.getEngine( engineName );
			
			//out.println( "Search Engine found? " + ( null != eng ) );
			
			// Now build a QueryExpression
			QueryExpression q = new QueryExpressionImpl( metadata.getDefaultSearchField(), Operation.CONTAINS, sQuery );
			int startIndex = (null == startNum || startNum.length() == 0 ) ? 0 : Integer.parseInt( startNum );
			int endIndex = (null == endNum || endNum.length() == 0 ) ? 19 : Integer.parseInt( endNum );
			q.setStartIndex( startIndex );
			q.setMaxResults( endIndex );
				
			// Now search;
			SearchResult<ResultRow> res = eng.search( Collections.singletonList( sourceName ), q );	
			
			// Now paint the results:
			%>
			
				<table border="1">
					<tr>
						<td>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=0&end=19&expr=<%=sQuery%>&source=<%=sourceName%>">(1-20)</a>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=20&end=39&expr=<%=sQuery%>&source=<%=sourceName%>">(21-40)</a>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=40&end=59&expr=<%=sQuery%>&source=<%=sourceName%>">(41-60)</a>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=60&end=79&expr=<%=sQuery%>&source=<%=sourceName%>">(61-80)</a>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=80&end=99&expr=<%=sQuery%>&source=<%=sourceName%>">(81-100)</a>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=100&end=119&expr=<%=sQuery%>&source=<%=sourceName%>">(101-120)</a>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=120&end=139&expr=<%=sQuery%>&source=<%=sourceName%>">(121-140)</a>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=140&end=159&expr=<%=sQuery%>&source=<%=sourceName%>">(141-160)</a>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=160&end=179&expr=<%=sQuery%>&source=<%=sourceName%>">(161-180)</a>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=180&end=199&expr=<%=sQuery%>&source=<%=sourceName%>">(181-200)</a>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=200&end=1000&expr=<%=sQuery%>&source=<%=sourceName%>">(beyond 200)</a>
						</td>
					</tr>
				</table>

				<table border="1">
					<tr>
						<td colspan="2">Total results=<b><%=res.getTotal()%></b> showing ( <%=startIndex + 1%> to <%=endIndex + 1%> ) </td>
					</tr>
					<%
						for( ; res.hasNext() ; )
						{
							out.println( "<tr><td>" );
							ResultRow row = res.next();
							for( String fldName : row.getFieldNames() )
							{
								IndexData idxdata = row.getIndexData( fldName );
								String d = idxdata.getData();
								out.println( "<b>" + fldName + ":</b>" );
								out.println( d + "<br/>" );
							}
							out.println( "<b>Relevance:" + row.getRelevance() + "</b>" );
							out.println( "</td></tr>" );
						}
					%>	
				</table>
				<table border="1">
					<tr>
						<td>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=0&end=19&expr=<%=sQuery%>&source=<%=sourceName%>">(1-20)</a>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=20&end=39&expr=<%=sQuery%>&source=<%=sourceName%>">(21-40)</a>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=40&end=59&expr=<%=sQuery%>&source=<%=sourceName%>">(41-60)</a>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=60&end=79&expr=<%=sQuery%>&source=<%=sourceName%>">(61-80)</a>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=80&end=99&expr=<%=sQuery%>&source=<%=sourceName%>">(81-100)</a>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=100&end=119&expr=<%=sQuery%>&source=<%=sourceName%>">(101-120)</a>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=120&end=139&expr=<%=sQuery%>&source=<%=sourceName%>">(121-140)</a>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=140&end=159&expr=<%=sQuery%>&source=<%=sourceName%>">(141-160)</a>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=160&end=179&expr=<%=sQuery%>&source=<%=sourceName%>">(161-180)</a>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=180&end=199&expr=<%=sQuery%>&source=<%=sourceName%>">(181-200)</a>
							<a href="./ContentServer?pagename=OpenMarket/Xcelerate/Search/Search&start=200&end=1000&expr=<%=sQuery%>&source=<%=sourceName%>">(beyond 200)</a>
						</td>
					</tr>
				</table>
			<%
		}
	}
	catch( Exception ex )
	{
		ex.printStackTrace();
	}

%>



</cs:ftcs>