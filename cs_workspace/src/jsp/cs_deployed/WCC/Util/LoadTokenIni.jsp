<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   oracle.stellent.ucm.poller.*,
                   java.io.*,
                   COM.FutureTense.Util.ftErrors"
%>
<cs:ftcs>
<%
if (ics.GetObj("wcc.token.ini") == null) {
    
    String clusterPath = ics.GetProperty(ftMessage.clustersyncprop); 
    String iniPath = clusterPath + File.separator + "ucm" + File.separator + "ini";
    String iniName = "wcc-token.ini";
    
    File iniFile = new File(iniPath, iniName);
    FileBasedProps tokenProps;
    
    try {
        
    	tokenProps = new FileBasedProps (iniFile);
        
    } catch (FileNotFoundException e) {
        
    	iniFile.getParentFile().mkdirs();
        iniFile.createNewFile();
        
        tokenProps = new FileBasedProps(iniFile);
        
        tokenProps.setProperty(Constants.QueueToken, "");
        
        tokenProps.save();
    }
    
    ics.SetObj("wcc.token.ini", tokenProps);
}
%>
</cs:ftcs>
