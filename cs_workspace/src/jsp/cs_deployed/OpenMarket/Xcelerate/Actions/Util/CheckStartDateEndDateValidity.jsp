<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.ParseException" %>
<cs:ftcs>
<%!
	public static Date parseDate(String date, String format) throws ParseException
	{
	    if (date != null)
	    {
	        SimpleDateFormat sformat = new SimpleDateFormat (format);
	        return sformat.parse (date);
	    }
	    return new Date ();
	}
%>
<%
/*	
	This utility is used by OpenMarket/Xcelerate/Actions/AssetMgt/TileHeldAssets.xml to display the approval dependents of a given asset.
	
	Purpose:
		This element simply computes if the given start date and end dates are valid. i.e.
		1) If the given start date is not in future
		2) If the given end date is not in the past
		To do so, the element employs utility functions parseDate to convert to a known date format
		
	Input:
		ICS Variables that are set by TileHeldAssets.xml
		1) startDate
		2) endDate
		
		Both these variables are strings that represent date in the format YYYY-MM-DD hh:mm:ss. 
		
	Output:
		If one of the given conditions (shown in purpose section) is satisfied, the element sets the ICS variable 'dateRangeValid' to the string 'false'. 
		It also sets the reason for the invalid date range as a text, into the ICS variable 'dateRangeFailureDetail'.
	
	-Sathish Paul Leo, for the Site Preview Proj Sept 13th 2007
		
*/
	String daysExpired = "-";
	final String DATE_FORMAT = "yyyy-MM-dd HH:mm:ss";
	Date currentDate = new Date();
	long currentDateMillis = currentDate.getTime();
	if(ics.GetVar("startDate") != null && !ics.GetVar("startDate").equals(""))
	{
		Date startDate = parseDate( ics.GetVar("startDate"),  DATE_FORMAT );		
		long startDateMillis = startDate.getTime();
		if(startDateMillis > currentDateMillis)
		{
			ics.SetVar("dateRangeValid","false");
%>
			<xlat:lookup key="fatwire/Alloy/UI/StartDateIsInFuture" varname="startDateInFutureMsg"/>
<%			
			ics.SetVar("dateRangeFailureDetail", ics.GetVar("startDateInFutureMsg"));
		}
	}

	if(ics.GetVar("endDate") != null  && !ics.GetVar("endDate").equals(""))
	{
		Date endDate = parseDate( ics.GetVar("endDate"),  DATE_FORMAT );		
		long endDateMillis = endDate.getTime();
		if(endDateMillis < currentDateMillis)
		{
			ics.SetVar("dateRangeValid","false");
%>
			<xlat:lookup key="fatwire/Alloy/UI/EndDateIsInPast" varname="endDateInPastMsg" />
<%		
			ics.SetVar("dateRangeFailureDetail", ics.GetVar("endDateInPastMsg"));	
			long difference = currentDateMillis - endDateMillis;
			int dayDiff = (int)Math.floor(difference/1000/60/60/24);  //convert milliseconds to days
			daysExpired = Integer.toString(dayDiff);
		}
	}
	ics.SetVar("daysExpired",daysExpired);
%>

</cs:ftcs>