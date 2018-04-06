<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%//
// OpenMarket/Flame/Common/AddToPortalHistory
//
// INPUT
//
// OUTPUT
//%><cs:ftcs><%
    String history = ics.GetSSVar("portalhistory");
    String id = ics.GetVar("id");
    String assettype = ics.GetVar("assettype");
    ics.ClearErrno(); %>
    <asset:list list='lCurrentAsset' type='<%=assettype%>' field1='id' value1='<%=id%>' excludevoided='true'/> <%
    if (ics.GetErrno() != 0) {
        //<asset:list> may fail if the asset is not created yet,
        //so we avoid adding non-existing asset to portal history.
        ics.ClearErrno();
    } else if (history == null || history.length()==0)  {
        ics.SetSSVar("portalhistory", id + "," + assettype);
    } else {
        String currentAsset = id + "," + assettype;
        if (history.indexOf(currentAsset) == -1) {
            String newHistory = currentAsset + ";" + history;
            ics.SetSSVar("portalhistory", newHistory);
        }
    }
%></cs:ftcs>
