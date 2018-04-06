<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Util/ConvertDateTZByXhr
// Converts jdbc formatted date from client's time zone to server's time zone
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" 
%><%@ page import="COM.FutureTense.Interfaces.IList" 
%><%@ page import="COM.FutureTense.Interfaces.Utilities" 
%><%@ page import="COM.FutureTense.Util.ftErrors" 
%><%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.text.DateFormat"%>
<%@ page import="com.openmarket.xcelerate.util.ConverterUtils"%>
<%@ page import="org.codehaus.jackson.map.ObjectMapper"%>
<cs:ftcs>
<%
if(Boolean.valueOf(ics.GetVar("wemUsers")))
{
	DateFormat df = null; 
	if (ics.GetSSVar("locale")!=null)
	{
		String[] currLocale = ics.GetSSVar("locale").split("_");
		df = DateFormat.getDateTimeInstance(DateFormat.FULL, DateFormat.FULL, new Locale(currLocale[0], currLocale[1]));
	}
	else
	{
		df = DateFormat.getDateTimeInstance(DateFormat.FULL, DateFormat.FULL);
	}
	df.setTimeZone(TimeZone.getTimeZone(ics.GetSSVar("time.zone")));
	SimpleDateFormat simpleFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");

	String[] dates = request.getParameterValues("date");
	List<String> formattedDates = new ArrayList<String>();
	for(String d : dates) {
		Date parsedDate = simpleFormat.parse(d);
		formattedDates.add(df.format(parsedDate));
	}
	out.println("{ \"formattedDates\" : " + new ObjectMapper().writeValueAsString(formattedDates) + "}");
}
else
{ 
	out.println(ConverterUtils.convertJDBCDate(ics.GetVar("date"),ics.GetSSVar("time.zone"),TimeZone.getDefault().getID()));
}
%>
</cs:ftcs>