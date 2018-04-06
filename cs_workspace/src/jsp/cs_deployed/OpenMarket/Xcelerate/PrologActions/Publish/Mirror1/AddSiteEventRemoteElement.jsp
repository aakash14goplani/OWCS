<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/PrologActions/Publish/Mirror1/TriggerAddSiteEvent
//
// INPUT
//		none
// OUTPUT
//		none
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="com.openmarket.xcelerate.interfaces.INotifiable"%>
<%@ page import="com.openmarket.xcelerate.interfaces.IEventManager"%>
<%@ page import="com.openmarket.xcelerate.interfaces.EventManagerFactory"%>
<cs:ftcs>
<%
IEventManager em = EventManagerFactory.make(ics);
FTValList args = new FTValList();
args.setValString(INotifiable.EVENTARG_SITENAME, ics.GetVar(INotifiable.EVENTARG_SITENAME));
em.triggerEvent(INotifiable.EVENT_ADDSITE, args );
%>
</cs:ftcs>