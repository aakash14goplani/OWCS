<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// UI/Actions/Tree/PasteSiteNavigationJson
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
<%@ page import="com.fatwire.mobility.util.MobilityUtils" %>
<%@ page import="com.fatwire.mobility.util.MobilityUtils.PasteSiteNavigationState" %>
<cs:ftcs>

<%
	PasteSiteNavigationState result = (PasteSiteNavigationState) request.getAttribute("result");
	int statusCode = PasteSiteNavigationState.SUCCESS.statusCode;
	String localeMessage = "";
	
	if (null != result) 
	{
		statusCode = result.statusCode;
		if (Utilities.goodString(result.localeMessageKey)) 
			localeMessage = ics.getLocaleString(result.localeMessageKey, ics.GetSSVar("locale"));
	}
%>

{
	"statusCode": <%= statusCode %>,
	"message": "<%= localeMessage %>"
}

</cs:ftcs>