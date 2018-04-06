<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="locale" uri="futuretense_cs/locale1.tld" %>
<%@ taglib prefix="dateformat" uri="futuretense_cs/dateformat.tld" %>
<%@ taglib prefix="date" uri="futuretense_cs/date.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>


<%//
// OpenMarket/Xcelerate/Util/SetClientRevisionTime
// Actually incase of revision tracking dates are stored in the databased on GMT time zone
// This element is used to display those dates based on the client time zone (modified to
//server time zone)
// it is modified to show now on the server time zone
// Client time zone is set in session as clientTimezoneOffset at the time of user login
// INPUT
// this is called by OpenMarket/Xcelerate/Actions/RevisionTracking/ShowTrackedHistory
// OUTPUT 
// author vipin
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList,java.util.*,java.text.*" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<cs:ftcs>
<%
if (ics.GetVar("versionDate")!=null)
{
%>
<locale:create varname="LocaleName" localename='<%=ics.GetSSVar("locale")%>'/>
<dateformat:create name="dObject" datestyle="short" timestyle="short" locale="LocaleName" timezoneid='<%=ics.GetSSVar("time.zone")%>'/>
<dateformat:create name="fObject" datestyle="full" timestyle="full" locale="LocaleName" timezoneid='<%=ics.GetSSVar("time.zone")%>'/>
<dateformat:getdatetime name="dObject" value='<%=ics.GetVar("versionDate")%>' valuetype="jdbcdate" varname="dateShortVersion"/>
<dateformat:getdatetime name="fObject" value='<%=ics.GetVar("versionDate")%>' valuetype="jdbcdate" varname="dateFullVersion"/>
<SPAN ID="revisionDateSpanId" TITLE='<%=ics.GetVar("dateFullVersion")%>'><%=ics.GetVar("dateShortVersion")%></SPAN>
<% } else { %>
No info available
<% } %> 
</cs:ftcs>
