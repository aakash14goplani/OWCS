<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@page import="com.fatwire.ui.util.GenericUtil"
%><cs:ftcs>
<%
	String viewId = GenericUtil.cleanString(ics.GetVar("viewId"));
%>
<div id='toolbar_<%= viewId%>' dojoType="fw.ui.dijit.Toolbar" region="top"
	 refresh='<%="true".equals(ics.GetVar("showRefresh"))%>'
	 formMode='<%="true".equals(ics.GetVar("isFormMode"))%>'
	 webMode='<%="true".equals(ics.GetVar("isWebMode"))%>'
	 label='<%=ics.GetVar("label") != null ? ics.GetVar("label") : ""%>'>
</div>
</cs:ftcs>