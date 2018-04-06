<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Actions/Publish/GetEmbededLinkExtraParams
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
<%@ page import="java.util.*"%>
<cs:ftcs>

<%
// find out if there is a legal link generated 
if (!"_NOLINK_".equalsIgnoreCase(ics.GetVar("_referURL_")) && ics.GetVar("_ADDITIONALPARAMS_")!=null)
{
String params=ics.GetVar("_ADDITIONALPARAMS_");
FTValList vl=new FTValList();
ics.decode(com.fatwire.cs.core.uri.Util.decodeUTF8(params),vl);

Map map=new TreeMap(vl);
String _return=ics.encode(null,map,false);
ics.SetVar("_referURL_",ics.GetVar("_referURL_")+"&"+_return);

}

%>

</cs:ftcs>