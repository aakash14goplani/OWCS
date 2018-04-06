<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Gator/FlexibleAssets/Common/DetermineFileSize
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="org.apache.commons.io.FileUtils"%>
<cs:ftcs>
<%
try {
	IList attrValueList = ics.GetList(ics.GetVar("listname"));
	attrValueList.moveToRow(IList.gotorow,Integer.parseInt(ics.GetVar("currrow")));
	byte [] data = attrValueList.getFileData(ics.GetVar("columnname"));
	ics.SetVar("filesize",FileUtils.byteCountToDisplaySize(data.length));
} catch(Exception e){
	ics.SetVar("filesize","");
}
%>

</cs:ftcs>