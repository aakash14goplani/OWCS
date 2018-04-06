<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ page import="com.fatwire.cs.core.db.PreparedStmt,
                   com.fatwire.cs.core.db.StatementParam,
                   oracle.stellent.ucm.poller.*,
                   java.util.*"
%>
<cs:ftcs><%--

INPUT 

OUTPUT

--%>

<%-- Record dependencies for the SiteEntry and the CSElement --%>
<ics:if condition='<%=ics.GetVar("seid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry"/></ics:then></ics:if>
<ics:if condition='<%=ics.GetVar("eid")!=null%>'><ics:then><render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement"/></ics:then></ics:if>

<%
String range = ics.GetVar("delete.fragment");
String sql = null;

if (range != null) {

    range = range.replace(' ', '+');
    int index = range.indexOf(';');
    String polldate1 = range.substring(0, index);
    String polldate2 = range.substring(index + 1);

    PreparedStmt stmt = new PreparedStmt (String.format("DELETE FROM %s WHERE polldate BETWEEN ? AND ?", Constants.BatchTable), Collections.singletonList (Constants.BatchTable));
    stmt.setElement (0, Constants.BatchTable, "polldate");
    stmt.setElement (1, Constants.BatchTable, "polldate");
    StatementParam param = stmt.newParam ();
    param.setString (0, polldate1);
    param.setString (1, polldate2);
    ics.SQL (stmt, param, false);

    stmt = new PreparedStmt (String.format ("DELETE FROM %s WHERE polldate BETWEEN ? AND ?", Constants.PollerTable), Collections.singletonList (Constants.PollerTable));
    stmt.setElement (0, Constants.PollerTable, "polldate");
    stmt.setElement (1, Constants.PollerTable, "polldate");
    param = stmt.newParam ();
    param.setString (0, polldate1);
    param.setString (1, polldate2);
    ics.SQL (stmt, param, false);

} else {
    int count = Integer.valueOf(ics.GetVar("delete.count"));
    for (int i = 0; i < count; i++) {
        String pollDate = ics.GetVar("delete.single." + i).replace(' ', '+');
        
	    PreparedStmt stmt = new PreparedStmt (String.format("DELETE FROM %s WHERE polldate = ?", Constants.BatchTable), Collections.singletonList (Constants.BatchTable));
	    stmt.setElement (0, Constants.BatchTable, "polldate");
	    StatementParam param = stmt.newParam ();
	    param.setString (0, pollDate);
	    ics.SQL (stmt, param, false);
	    
	    stmt = new PreparedStmt (String.format("DELETE FROM %s WHERE polldate = ?", Constants.PollerTable), Collections.singletonList (Constants.PollerTable));
	    stmt.setElement (0, Constants.PollerTable, "polldate");
	    param = stmt.newParam ();
	    param.setString (0, pollDate);
	    ics.SQL (stmt, param, false);
    }
}
%>

</cs:ftcs>
