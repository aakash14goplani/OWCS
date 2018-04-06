<%@page import="java.util.Calendar"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="vdm" uri="futuretense_cs/vdm.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="date" uri="futuretense_cs/date.tld"
%>
<cs:ftcs>
	<%-- Record dependencies for the SiteEntry and the CSElement --%>
	<ics:if condition='<%=ics.GetVar("seid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("seid")%>' c="SiteEntry" />
		</ics:then>
	</ics:if>
	<ics:if condition='<%=ics.GetVar("eid") != null%>'>
		<ics:then>
			<render:logdep cid='<%=ics.GetVar("eid")%>' c="CSElement" />
		</ics:then>
	</ics:if>
<%
	int mergeDays = -7;
	Calendar c = Calendar.getInstance();
	c.add(Calendar.DATE, mergeDays);
%>
	<date:convert varname="mergetime" year="<%=String.valueOf(c.get(Calendar.YEAR))%>" month="<%=String.valueOf(c.get(Calendar.MONTH))%>" day="<%=String.valueOf(c.get(Calendar.DATE))%>" /> 
	<%-- merge inactive after 1 week --%>
<%
	out.println("Merging visitor attributes from : " + ics.GetVar("mergetime") + "<br/>");
 %> 
	<vdm:mergeinactive startdate='<%= ics.GetVar("mergetime")%>'/>
	<ics:removevar name="mergetime"/>	
<%
	int flushDays = -30;
	c = Calendar.getInstance();
	c.add(Calendar.DATE, flushDays);
%>
	<date:convert varname="flushtime" year="<%=String.valueOf(c.get(Calendar.YEAR))%>" month="<%=String.valueOf(c.get(Calendar.MONTH))%>" day="<%=String.valueOf(c.get(Calendar.DATE))%>" /> 
	<%-- flush inactive after 1 month --%>
<%
	out.println("Flushing visitor attributes from : " + ics.GetVar("flushtime"));
 %>
	<vdm:flushinactive startdate='<%= ics.GetVar("flushtime")%>'/>
	<ics:removevar name="flushtime"/>
</cs:ftcs>