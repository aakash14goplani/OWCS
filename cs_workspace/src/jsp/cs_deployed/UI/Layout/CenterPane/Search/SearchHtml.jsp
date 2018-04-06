<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="controller" uri="futuretense_cs/controller.tld" %>

<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@page import="com.fatwire.ui.util.GenericUtil"%>
<cs:ftcs>
<%
	String viewId = GenericUtil.cleanString(ics.GetVar("viewId"));
%>
<div id="viewContainer_<%= viewId%>" dojoType="dijit.layout.BorderContainer">
	
		<controller:callelement elementname="UI/Layout/CenterPane/Toolbar" responsetype="html">
			<controller:argument name="showRefresh" value="true" />
		</controller:callelement>
	
	<div id='contentPane_<%= viewId%>' dojoType="dijit.layout.ContentPane" region="center" class="searchContainer fwGridContainer"></div>
</div>
</cs:ftcs>