<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// fatwire/ui/util/TypeAheadSearchResults
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="java.util.*"%>
<%@ page import="com.fatwire.cs.core.search.data.*"%>
<cs:ftcs>
<ics:if condition='<%=ics.GetVar("name") != null%>'>
<ics:then>
	<ics:setvar name="searchText" value='<%=ics.GetVar("name")%>' />
</ics:then>
</ics:if>
<ics:callelement element="fatwire/ui/util/search"></ics:callelement>

<%
StringBuilder builder = new StringBuilder("{\" identifier\" : \"name\", \n  \"label\" : \"name\", \n" +"  \"items\":  [ ");
List<ResultRow> res = null;
if(null!=(request.getAttribute("searchResults")))
{
	res = (List<ResultRow>) request.getAttribute("searchResults");
	Iterator<ResultRow> resIterator = res.iterator();
	if(res != null && res.size() > 0){
		int counter = 0;
		for( ; resIterator.hasNext() ; )
		{
			
			ResultRow row = resIterator.next();
			String id = "0";
			String name = ""; 
			String subtype = "";
			String assetType = "";
			
			for( String fldName : row.getFieldNames() )
			{
				IndexData idxdata = row.getIndexData( fldName );
				String d = idxdata.getData();
				if("name" == fldName){
					name = d;
				}
				else if("id" == fldName){
					id = d;
				}
				else if("subtype" == fldName){
					subtype = d;
				}
				else if("AssetType" == fldName){
					assetType = d;
				}
				
			}
			if(counter > 0)
			{
				builder.append(",");
			}
			builder.append("{\"type\":\"").append(assetType)  
			.append("\", \"id\": \"").append(id) 
			.append("\", \"name\":\"").append(name)
			.append("\", \"subtype\":\"").append(subtype)
			.append("\"}");
			counter ++;
		}
		builder.append(" ] }") ;
	
	}	
	else 
	{		
		builder.append(" ] }") ;
	}
}
else
{	
	String errorMsg = "";
	if(request.getAttribute("errMessage") != null){
		errorMsg = (String) request.getAttribute("errMessage");
	}
	
	builder.append("{\"type\":\"").append("error")  
		   .append("\", \"ErrorMesseage\": \"").append(errorMsg) 
		   .append("\", \"name\":\"").append("No Rows Available").append("\"}");
	builder.append(" ] }") ;
}
%>
<%=builder.toString()%>

</cs:ftcs>