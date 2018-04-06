<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="date" uri="futuretense_cs/date.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>


<%//
// OpenMarket/Xcelerate/Util/ShowDateInClientTimeZone
// Actually incase of Checkouts in MyWork It shows the last revision date
// This element takes server specific date and shows that as client specific time
// Current it is used by Actions/ShowMyCheckouts.xml can be used other place also
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
<!-- user code here -->
<%
String offsetTime=""; // represent the client time zone
String offsetTTime=""; // time in milli seconds since GMT
if (ics.GetVar("DateString")!=null)
{
// By default it creates the calender object in the server specific time zone
Calendar cal = Utilities.calendarFromJDBCString( ics.GetVar("DateString") );
Date dateObject= cal.getTime();
long millisecondsTime=dateObject.getTime();
offsetTTime=new String(""+millisecondsTime);
offsetTime=ics.GetSSVar("clientTimezoneOffset");
}
%>
<date:clocklist listvarname="DueDate" clock="<%=offsetTTime%>" timezone="<%=offsetTime%>" ></date:clocklist>
<ics:listget listname="DueDate" fieldname="year" output="year" />
<ics:listget listname="DueDate" fieldname="month" output="month" />
<ics:listget listname="DueDate" fieldname="dayofmonth" output="dayofmonth" />
<ics:listget listname="DueDate" fieldname="hour" output="hour" />
<ics:listget listname="DueDate" fieldname="minute" output="minute" />
<ics:listget listname="DueDate" fieldname="second" output="second" />
<ics:listget listname="DueDate" fieldname="ampm" output="ampm" />
<ics:getvar name="year" />-<ics:getvar name="month" />-<ics:getvar name="dayofmonth" /> <ics:getvar name="hour" />:<ics:getvar name="minute" />:<ics:getvar name="second" /> <%=(ics.GetVar("ampm").equals("1")) ? "PM":"AM" %>
</cs:ftcs>

