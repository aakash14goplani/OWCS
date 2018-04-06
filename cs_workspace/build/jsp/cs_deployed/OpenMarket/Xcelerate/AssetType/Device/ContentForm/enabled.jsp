<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Xcelerate/AssetType/Device/ContentForm/enabled
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


<ics:if condition='<%=("on".equalsIgnoreCase(ics.GetVar("fieldvalue")) || "Y".equalsIgnoreCase(ics.GetVar("fieldvalue")))%>'>
	<ics:then>
		<input type="checkbox" id='<%=ics.GetVar("AssetType")%>:<%=ics.GetVar("fieldname")%>' name='<%=ics.GetVar("AssetType")%>:<%=ics.GetVar("fieldname")%>' value="Y" checked="true"/>
	</ics:then>
	<ics:else>
		<input type="checkbox" id='<%=ics.GetVar("AssetType")%>:<%=ics.GetVar("fieldname")%>' name='<%=ics.GetVar("AssetType")%>:<%=ics.GetVar("fieldname")%>' />
	</ics:else>
</ics:if>
</cs:ftcs>