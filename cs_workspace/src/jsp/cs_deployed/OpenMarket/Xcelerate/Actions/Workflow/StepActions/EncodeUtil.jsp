<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld" %>
<%
//
// OpenMarket/Xcelerate/Actions/Workflow/StepActions/EncodeUtil
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
<render:packargs outstr="paramString">
	<render:argument name="assignee" value='<%=ics.GetVar("assignee")%>'/>
	<render:argument name="assigneerole" value='<%=ics.GetVar("assignedrole")%>'/>
	<render:argument name="assigner" value='<%=ics.GetVar("assigner_user_name")%>'/>
	<render:argument name="assetname" value='<%=ics.GetVar("assetname")%>'/>
	<render:argument name="instruction" value='<%=ics.GetVar("comment")%>'/>
</render:packargs>
</cs:ftcs>