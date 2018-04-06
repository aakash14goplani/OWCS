<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Actions/LocaleHierarchyView
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
<cs:ftcs>
<%--
	This element/logic is only used for ucforms
--%>
<% 
	ics.SetVar(ics.GetVar("AssetType") + ":id",  ics.GetVar("id"));
%>
<ics:callelement element="OpenMarket/Xcelerate/Admin/LocaleHierarchy/LocaleHierarchyView" />
<ics:removevar name='<%=ics.GetVar("AssetType") + ":id"%>'/>
</cs:ftcs>