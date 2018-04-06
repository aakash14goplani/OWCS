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
if (ics.GetObj("wcc.integration.ini") == null) {
    
	String clusterPath = ics.GetProperty(ftMessage.clustersyncprop); 
	String iniPath = clusterPath + File.separator + "ucm" + File.separator + "ini";
	String iniName = "wcc-integration.ini";
    
    File iniFile = new File(iniPath, iniName);
	FileBasedProps wccProps;
    
	try {
		
	    wccProps = new FileBasedProps (iniFile);
	    
	} catch (FileNotFoundException e) {
		
        iniFile.getParentFile().mkdirs();
		iniFile.createNewFile();
        
        wccProps = new FileBasedProps(iniFile);
        
        wccProps.setProperty(Constants.KeyField, "name");

        wccProps.setProperty(Constants.RuleCaseSensitive, "true");
        
        wccProps.setProperty(Constants.BatchSize, "50");
        wccProps.setProperty(Constants.BatchAutoRepeat, "true");
        
        wccProps.setProperty(Constants.ZipDownloadFolder, Poller.defaultDownloadFolder("").getAbsolutePath());
        wccProps.setProperty(Constants.ZipDownloadAutoClean, "true");
        
        wccProps.save();
	}
    
	ics.SetObj("wcc.integration.ini", wccProps);
}
%>
</cs:ftcs>
