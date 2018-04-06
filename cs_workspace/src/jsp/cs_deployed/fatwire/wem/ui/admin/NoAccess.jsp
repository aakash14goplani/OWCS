<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%//
// fatwire/wem/ui/admin/NoAccess
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>

<cs:ftcs>
<%--- Adding this temporarily --%>
<ics:setvar name="cspath" value="../../../../.."/>
<div class="container">
     <p style="padding: 100px 0"><xlat:stream key="fatwire/wem/admin/error/common/ApplicationAccessNotAllowed"/></p>
</div>
</cs:ftcs>

