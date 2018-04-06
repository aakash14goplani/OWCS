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
if (ics.GetObj("wcc.ui.rendition.name.list") == null) {
    
	ArrayList<String> nameList = new ArrayList<String>();
    ics.SetObj("wcc.ui.rendition.name.list", nameList);
    
    ics.CallElement("WCC/Util/LoadIntegrationIni", null);
    FileBasedProps wccProps = (FileBasedProps) ics.GetObj("wcc.integration.ini");
    
    TreeSet<String> uniqueSet = new TreeSet<String>();
    
    for (String name : wccProps.stringPropertyNames()) {
    	if (name.startsWith(Constants.RenditionPrefix)) {
    		uniqueSet.add(name.substring(Constants.RenditionPrefix.length()));
    	}
    }
    
    nameList.addAll(uniqueSet);
}
%>
</cs:ftcs>
