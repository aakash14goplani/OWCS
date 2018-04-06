<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   java.util.*"
%>
<%@ page import="com.fatwire.cs.core.db.PreparedStmt" %>
<cs:ftcs>
<%
if (ics.GetObj("wcc.ui.site.name.list") == null) {
    
    ArrayList<String> nameList = new ArrayList<String>();
    ics.SetObj("wcc.ui.site.name.list", nameList);

    PreparedStmt stmt = new PreparedStmt ("SELECT name from Publication", Collections.singletonList ("Publication"));
    IList sqlResult = ics.SQL (stmt, null, false);
    int totalRow = sqlResult.numRows();

    for (int row = 1; row <= totalRow; row++) {
        sqlResult.moveTo(row);
        
        nameList.add(sqlResult.getValue("name"));
    }
    
    Comparator<String> comparator = new Comparator<String> () {
        public int compare(String s1, String s2) {
        	return s1.toLowerCase().compareTo(s2.toLowerCase());
        }
        public boolean equals(Object obj) {
        	return super.equals(obj);
        }
    };
    
    Collections.sort(nameList, comparator);
}
%>
</cs:ftcs>
