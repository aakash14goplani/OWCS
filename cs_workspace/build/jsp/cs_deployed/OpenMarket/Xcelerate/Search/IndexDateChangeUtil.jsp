<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Search/IndexDateChangeUtil
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
<%@ page import="com.fatwire.search.lucene.util.IndexDateChangeICSUtil"%>
<%@ page import="java.util.List"%>
<cs:ftcs>

<!-- user code here -->
<%
    IndexDateChangeICSUtil util = new IndexDateChangeICSUtil( ics );
    String indexes = ics.GetVar("indexes");
    if ( indexes == null )
    {
        indexes = "_ALL_";
    }
    try
    {
        List<String> processedIndexes = util.process( indexes );
        StringBuilder sb = new StringBuilder();
        for ( String index : processedIndexes)
        {
            sb.append(index).append(",");
        }
%>
    Index changes are complete. The date fields in the <%=sb.toString()%> lucene index(es) have been updated to include milliseconds
<%
    }
    catch (Exception e)
    {
        out.println(e);
    }

%>
</cs:ftcs>