<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="hash" uri="futuretense_cs/hash.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>

<%//
// OpenMarket/Gator/FlexibleAssets/Common/ParentSelectDialogsJSP
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

<!-- user code here -->
<ics:if condition='<%=ics.GetVar("grouptype")==null%>'>
<ics:then>
	<ics:setvar name='grouptype' value='<%=ics.GetVar("AssetType")%>'/><br/>
</ics:then>
</ics:if>
<%
    IList myparentgroups = ics.GetList("MyParentGroups");
    if (myparentgroups != null && myparentgroups.hasData()) { %>
		<ics:callelement element='OpenMarket/Xcelerate/UIFramework/Util/RowSpacer'/>
		<tr>
		<td class="form-label-text">
			<ics:if condition='<%=ics.GetVar("required").equals("true")%>'>
			<ics:then><span class="alert-color">*</span></ics:then></ics:if><string:stream variable='templateName'/>:
			</td>
			<td></td>
			<td class="form-inset">
				<ics:callelement element='OpenMarket/Gator/FlexibleAssets/Common/ParentSelectQueryImpl'/>
			</td>
		</tr>
	<%
    } else { %>
		<tr>
			<td class="form-label-italic-text">
				<ics:if condition='<%=ics.GetVar("required").equals("true")%>'>
				<ics:then><span class="alert-color">*</span></ics:then></ics:if><string:stream variable='templateName'/>
				<ics:if condition='<%=ics.GetVar("multiple").equals("true")%>'>
				<ics:then>
					(M):
				</ics:then>
				<ics:else>
					(S):
				</ics:else>
				</ics:if>
			</td>
			<td></td>
			<td class="form-inset">
				<xlat:stream key='dvin/FlexibleAssets/Common/NoParentsAvailable'/> .
			</td>
		</tr>
  <% } %>
</cs:ftcs>
