<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Gator/UIFramework/UITimeOutPopup
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
<cs:ftcs><%
if(!ics.UserIsMember("xceleditor"))
{
%>
        <satellite:link assembler="query" pagename="OpenMarket/Xcelerate/Actions/Security/TimeoutErrorPopup" outstring="urltimeouterror">
        </satellite:link>
		<script type="text/javascript">
			parent.parent.location='<%= ics.GetVar("urltimeouterror")%>';
		</script>
        <throwexception/>
		<%
}
%></cs:ftcs>