<%@ page import="java.util.StringTokenizer"
%><%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%//
// OpenMarket/Flame/Common/RemoveFromPortalHistory
//
// INPUT
//
// OUTPUT
//%><cs:ftcs><%
    String history = ics.GetSSVar("portalhistory");
    String id = ics.GetVar("id");
    if (id!=null && history!=null && history.length()>0) {
        String newHistory = null;
        StringTokenizer st = new StringTokenizer(history, ";");
        while (st.hasMoreTokens()) {
             String assetStr = st.nextToken();
             String assetid = assetStr.substring(0, assetStr.indexOf(','));

             if (!id.equals(assetid)) {
                 if (newHistory == null)
                    newHistory = assetStr;
                 else
                    newHistory += ";" + assetStr;
             }
        }

        if (newHistory == null)
            ics.RemoveSSVar("portalhistory");
        else
            ics.SetSSVar("portalhistory", newHistory);
    }
%></cs:ftcs>