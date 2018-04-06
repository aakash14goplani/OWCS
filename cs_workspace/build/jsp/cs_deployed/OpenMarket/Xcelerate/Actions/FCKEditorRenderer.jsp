<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Actions/FCKEditorRenderer
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
<%@ page import="com.openmarket.xcelerate.publish.EmbeddedLink"%>
<cs:ftcs>

<%
if(ics.UserIsMember("xceleditor")){
	String fieldData = ics.GetVar("fieldData");
	response.setContentType("text/xml");
	response.setHeader("Cache-Control", "no-cache");
	//Remove all the direct script tags
	String _fieldData = fieldData.replaceAll("(?i)<script[^>]*>.*?</script[^>]*>","");
	EmbeddedLink link = new EmbeddedLink(ics,_fieldData,false,false,true);
	String ret = link.evaluate();
	ics.StreamText(org.apache.commons.lang.StringEscapeUtils.escapeHtml(ret));
} else {
	//Set header that the login is invalid.
    ics.StreamHeader("userAuth","false");
}
%>
</cs:ftcs>