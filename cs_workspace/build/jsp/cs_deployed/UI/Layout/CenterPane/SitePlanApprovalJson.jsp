<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// UI/Layout/CenterPane/SitePlanApprovalJson
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
<%@ page import="com.fatwire.services.ui.beans.UIApprovalBean,
				 java.util.List,
				 com.fatwire.ui.util.GenericUtil,
				 com.fatwire.cs.ui.framework.UIException,
				 org.codehaus.jackson.map.ObjectMapper
				" %>
<cs:ftcs>
<%
try {
	List<UIApprovalBean> result = GenericUtil.emptyIfNull((List<UIApprovalBean>) request.getAttribute("result"));
%>
{
	"identifier": "id",
	"items": <%= new ObjectMapper().writeValueAsString(result)%>
}
<%
} catch(Exception e) {
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}%>
</cs:ftcs>