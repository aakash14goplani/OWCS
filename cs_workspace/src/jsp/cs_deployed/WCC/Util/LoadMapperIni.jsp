<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   oracle.stellent.ucm.poller.*,
                   java.io.*,
                   java.util.*,
                   COM.FutureTense.Util.ftErrors"
%>
<cs:ftcs>
<%
if (ics.GetObj("wcc.mapper.ini") == null) {
    
    String clusterPath = ics.GetProperty(ftMessage.clustersyncprop); 
    String iniPath = clusterPath + File.separator + "ucm" + File.separator + "ini";
    String iniName = "wcc-mappers.ini";
    
    File file = new File(iniPath, iniName);
    IniFile iniFile;
    
    try {
        
        iniFile = new IniFile(file);
        
    } catch (FileNotFoundException e) {

        file.getParentFile().mkdirs();
        file.createNewFile();

        iniFile = new IniFile(file);
    } 

    ics.SetObj("wcc.mapper.ini", iniFile);
}
%>
</cs:ftcs>
