<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ page import="oracle.stellent.ucm.poller.Constants,
                 COM.FutureTense.Interfaces.IList,
                 oracle.stellent.ucm.poller.record.WccPollerRecord,
                 oracle.stellent.ucm.poller.record.WccOrphanRecord,
                 oracle.stellent.ucm.poller.record.WccBatchRecord,
                 com.fatwire.cs.core.db.PreparedStmt,
                 java.util.Collections" %>
<cs:ftcs>
<%
    int pageSize = 20, pageIndex = 1;
    try {
        int n = Integer.parseInt (ics.GetVar ("wcc.pagination.pageSize"));
        if (n > 0) {
            pageSize = n;
        }
    } catch (Exception e) {
    }
    ics.SetVar ("wcc.pagination.pageSize", pageSize);

    try {
        int n = Integer.parseInt (ics.GetVar ("wcc.pagination.pageIndex"));
        if (n > 0) {
            pageIndex = n;
        }
    } catch (Exception e) {
    }
    ics.SetVar ("wcc.pagination.pageIndex", -1);

    String table = ics.GetVar ("wcc.pagination.sql.table");
    String field = ics.GetVar ("wcc.pagination.sql.field");
    String order = ics.GetVar ("wcc.pagination.sql.order");

    String safeTable = null;
    if (Constants.PollerTable.equalsIgnoreCase (table) && WccPollerRecord.hasFieldName (field)) {
        safeTable = Constants.PollerTable;
    } else if (Constants.OrphanTable.equalsIgnoreCase (table) && WccOrphanRecord.hasFieldName (field)) {
        safeTable = Constants.OrphanTable;
    } else if (Constants.BatchTable.equalsIgnoreCase (table) && WccBatchRecord.hasFieldName (field)) {
        safeTable = Constants.BatchTable;
    }

    //We can only do the query on tables we know about
    if (safeTable != null) {

        String safeOrder = "ASC";
        if ("desc".equalsIgnoreCase (order)) {
            safeOrder = "DESC";
        }

        PreparedStmt stmt = new PreparedStmt (String.format ("select %s from %s order by %s %s", field, safeTable, field, safeOrder), Collections.singletonList (safeTable));
        IList resultList = ics.SQL(stmt, null, false);
        int totalItemCount = resultList == null ? 0 : resultList.numRows ();

        if (totalItemCount > 0) {
            int totalPageCount = totalItemCount / pageSize;
            if (totalItemCount % pageSize > 0) {
                totalPageCount++;
            }

            if (pageIndex > totalPageCount) {
                pageIndex = totalPageCount;
            }

            int itemBeginIndex = pageSize * (pageIndex - 1) + 1;
            int itemEndIndex = pageSize * pageIndex;
            if (itemEndIndex > totalItemCount) {
                itemEndIndex = totalItemCount;
            }

            resultList.moveTo (itemBeginIndex);
            String itemBeginKey = resultList.getValue (field);

            resultList.moveTo (itemEndIndex);
            String itemEndKey = resultList.getValue (field);

            ics.SetVar ("wcc.pagination.pageIndex", pageIndex);
            ics.SetVar ("wcc.pagination.pageCount", totalPageCount);
            ics.SetVar ("wcc.pagination.itemCount", totalItemCount);
            ics.SetVar ("wcc.pagination.itemIndexBegin", itemBeginIndex);
            ics.SetVar ("wcc.pagination.itemIndexEnd", itemEndIndex);
            ics.SetVar ("wcc.pagination.itemKeyBegin", itemBeginKey);
            ics.SetVar ("wcc.pagination.itemKeyEnd", itemEndKey);
        }
    }
%>
</cs:ftcs>
