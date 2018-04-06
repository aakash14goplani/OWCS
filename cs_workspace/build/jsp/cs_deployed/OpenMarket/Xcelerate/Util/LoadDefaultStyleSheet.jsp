<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Util/LoadDefaultStyleSheet
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="COM.FutureTense.Interfaces.IList"%>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@ page import="java.io.*"%>
<%!
	private static final Log FILECHECKLOG = LogFactory.getLog(ftMessage.GENERIC_DEBUG);
	private boolean fileCheck(ICS ics, ServletContext application, String path){
		boolean fileExists = false;
		try{
			File file = new File(application.getRealPath(path));
			fileExists =  file.exists();
		}catch(Exception e){
			FILECHECKLOG.error("File not accessible in this path: " + path + "\n" + e.getMessage());
		}
		return fileExists;
	}
%>
<cs:ftcs>
<%
	String defLocale = ics.GetSSVar("default_locale");
	if (!Utilities.goodString((defLocale))) {
		String sqlForLocale = "Select * from LocaleMap where ordinal = '1'";
		IList ilistResult = ics.SQL("LocaleMap", sqlForLocale, null, -1, true, true, null);
		if (ilistResult != null && ilistResult.hasData() && ilistResult.numRows() == 1) {
			defLocale = ilistResult.getValue("id");
			ics.SetSSVar("default_locale", defLocale);
		}
	}
	String commonPath = "Xcelerate" + File.separator + "data" + File.separator + "css" + File.separator + ics.GetSSVar("locale") + File.separator;
	String filesToLoad = ics.GetVar("cssFilesToLoad");
	if (Utilities.goodString((filesToLoad)) && Utilities.goodString((defLocale))) {
		String [] fileStrArray = filesToLoad.split(",");
		for (String str : fileStrArray) {
			String filePath = commonPath + str;
			boolean fileExists = false;
			fileExists = fileCheck(ics, application, filePath);
			if (!fileExists) {				
%>			
				<link href='<%= ics.GetVar("cs_imagedir") + "/data/css/" + defLocale + "/" + str %>' rel="stylesheet" type="text/css"/>
<%				
			}
		}
	}
%>
</cs:ftcs>