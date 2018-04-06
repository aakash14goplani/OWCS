<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   oracle.stellent.ucm.poller.*,
                   java.util.*,
                   COM.FutureTense.Util.ftErrors"
%><cs:ftcs>
<%
if (ics.GetObj("wcc.ui.conversion.name.list") == null) {
    
    ArrayList<String> nameList = new ArrayList<String>();
    ics.SetObj("wcc.ui.conversion.name.list", nameList);
    
    nameList.add("html");
    nameList.add("images");
}
%>
</cs:ftcs>
