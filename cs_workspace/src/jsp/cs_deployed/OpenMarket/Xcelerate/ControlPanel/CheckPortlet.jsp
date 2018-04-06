<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%//
// OpenMarket/Xcelerate/ControlPanel/CheckPortlet
//
// INPUT
//
// OUTPUT   IsVariable.IsPortlet
//%>
<cs:ftcs>
<%
Object obj = null;
Class[] itfs = null;
ics.RemoveVar("IsPortlet");
if ((obj = request.getAttribute("javax.portlet.request")) != null) {
	if ((itfs = obj.getClass().getInterfaces()) != null) {
		for (int i = 0; i < itfs.length; i++) {
			if ("javax.portlet.RenderRequest".equals(itfs[i].getName())) {
				ics.SetVar("IsPortlet", Boolean.TRUE.toString());
				break;
			}
		}
	}
}
%>
</cs:ftcs>