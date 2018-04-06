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
if (ics.GetObj("wcc.ui.meta.name.type.map") == null) {

    ics.CallElement("WCC/Util/LoadIntegrationIni", null);

    try {
        IdcService idcService = new IdcService (ics);
        ics.SetObj("wcc.ui.meta.name.type.map", idcService.getMetaKeyTypeMap());

    } catch (Throwable e) {
        ics.SetObj("wcc.ui.meta.name.type.map", new HashMap<String,String>(0));
    }
}
%>
</cs:ftcs>
