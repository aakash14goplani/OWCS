<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%//
// fatwire/ui/util/GetSLSObj
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@ page import="java.io.*"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.util.*"%>
<%!
	private static final Log FILECHECKLOG = LogFactory.getLog(ftMessage.GENERIC_DEBUG);
	private boolean fileCheck (ICS ics, ServletContext application, String filePath) {
		boolean fileExists = false;
		try{
			File file = new File(application.getRealPath(filePath));
			fileExists = file.exists();
		}catch(Exception e){
			FILECHECKLOG.error("[fatwire/ui/util/GetSLSObj] File not accessible in this filePath: " + filePath + "\n" + e.getMessage());
		}
		return fileExists;
	}
	
	private String getAlternateFileName (ICS ics, ServletContext application, String filePath, String languageCode) {
		String fileName = "",
			strToMatch = languageCode + "-";
		try {	
			File directory = new File(application.getRealPath(filePath));
			File[] filesAvailable = directory.listFiles();		
			for (File eachFile :  filesAvailable) {
				if (eachFile.isFile()) {
					if (eachFile.getName().contains(strToMatch)) {
						fileName = eachFile.getName();
						break;
					}
				}
			}
		}catch(Exception e){
			FILECHECKLOG.error("[fatwire/ui/util/GetSLSObj] Exception: " +  e.getMessage());
		}		
		return fileName;
	}
	
	private String getFullURL (HttpServletRequest httpRequest) {
		String urlGenerated = "";
		try {
			URL fullURL = new URL(httpRequest.getScheme(), httpRequest.getServerName(), httpRequest.getServerPort(), httpRequest.getContextPath());
			urlGenerated = fullURL.toString();
		}catch(Exception e){
			FILECHECKLOG.error("[fatwire/ui/util/GetSLSObj] Exception: " +  e.getMessage());
		}	
		return urlGenerated;
	}
%>
<cs:ftcs>
<%	
	boolean isFileAvailable = false;
	String defaultFileName = "en-us";
	String cc = ics.GetVar("country_code");
	String ln = ics.GetVar("language_code");
	String relativeDirPath = File.separator + "js" +  File.separator + "fw" + File.separator + "sls";
	String relativeFilePath = relativeDirPath  + File.separator;
	String fileExtension = ".js";
	String fileName = "";
	String filePath = "";
	String userLocale = ics.GetVar("user_locale");
	
	if (Utilities.goodString(userLocale)) {
		filePath = relativeFilePath + userLocale + fileExtension;
		isFileAvailable = fileCheck(ics, application, filePath);
		if (!isFileAvailable) {
			fileName = getAlternateFileName(ics, application, relativeDirPath, userLocale.split("-")[0]);
			if (Utilities.goodString(fileName))	filePath = relativeFilePath + fileName;
			else filePath = relativeFilePath + defaultFileName + fileExtension;
		}
	}
	else {
		if (Utilities.goodString(ln) && Utilities.goodString(cc)) {
			fileName = ln.toLowerCase() + "-" + cc.toLowerCase();
			filePath = relativeFilePath + fileName + fileExtension;
			isFileAvailable = fileCheck(ics, application, filePath);		
			if (!isFileAvailable) {
				fileName = getAlternateFileName(ics, application, relativeDirPath, ln.toLowerCase());
				if (Utilities.goodString(fileName))	filePath = relativeFilePath + fileName;
				else filePath = relativeFilePath + defaultFileName + fileExtension;
			}	
		}	
		else if (Utilities.goodString(ln) && !Utilities.goodString(cc))	{
			fileName = getAlternateFileName(ics, application, relativeDirPath, ln.toLowerCase());
			if (Utilities.goodString(fileName))	filePath = relativeFilePath + fileName;
			else filePath = relativeFilePath + defaultFileName + fileExtension;
		}
		else {
			Enumeration<Locale> localeEnum =  request.getLocales();
			List<Locale> browserLocales = new ArrayList<Locale> ();
			while (localeEnum.hasMoreElements()){
				browserLocales.add((Locale)localeEnum.nextElement());
			}
			String userDefinedLocale = com.fatwire.util.LocaleUtil.getUserLocale(ics, browserLocales);
			if (Utilities.goodString(userDefinedLocale)) {
				userDefinedLocale = userDefinedLocale.toLowerCase().replace("_" , "-");
				filePath = relativeFilePath + userDefinedLocale + fileExtension;
				isFileAvailable = fileCheck(ics, application, filePath);
				if (!isFileAvailable) {
					fileName = getAlternateFileName(ics, application, relativeDirPath, userDefinedLocale.split("-")[0]);
					if (Utilities.goodString(fileName))	filePath = relativeFilePath + fileName;
					else filePath = relativeFilePath + defaultFileName + fileExtension;
				}
			}
			else filePath = relativeFilePath + defaultFileName + fileExtension;
		}
	}	
	filePath =  filePath.replaceAll("\\\\", "/");
	String fullURL = getFullURL(request);
%>
	document.write('<script type="text/javascript" src="<%=fullURL + filePath%>"></script>');
	
</cs:ftcs>