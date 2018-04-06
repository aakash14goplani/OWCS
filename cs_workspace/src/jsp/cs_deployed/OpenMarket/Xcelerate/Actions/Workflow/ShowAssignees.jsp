<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Xcelerate/Actions/Workflow/ShowAssignees
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
<ics:if condition='<%="yes".equals(ics.GetVar("cs_AlreadyHaveAssignees"))%>'>
<ics:then>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/RowSpacer" />
	<tr>
	   <td class="form-label-text"><xlat:stream key="dvin/Common/Assignees"/>:</td>
	   <td></td>
	   <td class="form-inset">
		   <ics:callelement element="OpenMarket/Xcelerate/Actions/Workflow/ShowAssigneeSelections">
			   <ics:argument name="cs_RoleList" value="assigneeroles"/>
			   <ics:argument name="cs_RolePrefix" value="ask:"/>
		   </ics:callelement>
	   </td>
   </tr>
</ics:then>
</ics:if>
</cs:ftcs>