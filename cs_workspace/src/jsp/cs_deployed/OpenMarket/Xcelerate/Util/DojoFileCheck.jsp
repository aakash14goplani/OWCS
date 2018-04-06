<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Util/DojoFileCheck
//
// INPUT
// 		PublicationName and AssetType
//		filepath and filename
//
// OUTPUT
//		_afterLoad_ : this variable is set true if 'AfterLoad.js' is exists else set false
//		_preSave_: this variable is set true if 'PreSave.js' is exists else set false
//
// 		providing filepath and filename, it will create an ICS variable with filename
//
//%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@ page import="java.io.*"%>
<%!
	private static final Log FILECHECKLOG = LogFactory.getLog(ftMessage.GENERIC_DEBUG);
	private void fileCheck(ICS ics, ServletContext application, String path, String filename){
		try{
			File file = new File(application.getRealPath(path));
			ics.SetVar(filename, String.valueOf(file.exists()));
		}catch(Exception e){
			FILECHECKLOG.error("File not accessible in this path: " + path + "\n" + e.getMessage());
		}
	}
%>
<cs:ftcs>
<%
	// providing filepath and filename, it will create an ICS variable with filename
	if ( Utilities.goodString(ics.GetVar("filepath")) && Utilities.goodString(ics.GetVar("filename")) ) {
		fileCheck(ics, application, ics.GetVar("filepath") , ics.GetVar("filename"));
	} else {
		String customPath = File.separator + "js" + File.separator + "extensions" + File.separator + "sites" + File.separator + 
							ics.GetSSVar("PublicationName") + File.separator + "assettypes" + File.separator + ics.GetVar("AssetType"),			
		 		afterLoad = customPath + File.separator + "AfterLoad.js",
		 		preSave = customPath + File.separator + "PreSave.js";
		fileCheck(ics, application, afterLoad, "_afterLoad_");
		fileCheck(ics, application, preSave, "_preSave_");
	}
%>
</cs:ftcs>