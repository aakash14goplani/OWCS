<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="asset" uri="futuretense_cs/asset.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// OpenMarket/Xcelerate/Util/WarnAssetApproval
//
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.text.ParseException"%>
<cs:ftcs>
<%
/*	Purpose: 
	This element checks for the start date and end date of a given asset (asset id and asset type)
	and shows a warning message if 
		1) start date of the asset occurs in the future
		2) end date of the asset occurs in the past
	
	Input:
		ICS Variables
		1) AssetType
		2) id - asset id

	Output:
	If the start date ane end date of the given asset do not meet the above mentioned criteria, then a warning message is shown
	If the given asset DOES Not have any start/end dates, then no message is shown.
		
	-Sathish Paul Leo
*/	
%>
<%!
/**
 * Parses the date for the given format
 * 
 * inputs 
 		  date the date string to be parsed.
 		  format the date format of the string, such as yyyy/MM/dd.
 * return the Date object represented by the string.
 * throws ParseException if the string cannot be parsed as a Date object.
 */
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
<asset:load name="assetObj" type='<%=ics.GetVar("AssetType")%>' objectid='<%=ics.GetVar("id")%>' />		
<asset:get name="assetObj" field="startdate" output="assetStartDate"/>
<asset:get name="assetObj" field="enddate" output="assetEndDate"/>

<%		
	final String DATE_FORMAT = "yyyy-MM-dd HH:mm:ss";
	long currentTimeMillis = System.currentTimeMillis();
	if(ics.GetVar("assetStartDate") != null && !ics.GetVar("assetStartDate").equals(""))
	{
		Date startDate = parseDate( ics.GetVar("assetStartDate"),  DATE_FORMAT );
        long startDtMillis = startDate.getTime();
		
		//Show a warning message if a user tries to approve an asset whose
		// Start date is later than the current time (asset is not yet valid)

		if(startDtMillis > currentTimeMillis)
		{
%>
  		     <xlat:lookup key="fatwire/Alloy/UI/StartDateIsInFuture" varname="startDateInFutureMsg"/>
		     <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
		        <ics:argument name="msgtext" value='<%=ics.GetVar("startDateInFutureMsg")%>'/>
		        <ics:argument name="severity" value="warning"/>
		     </ics:callelement>
<%
		}
	}
	
	if(ics.GetVar("assetEndDate") != null && !ics.GetVar("assetEndDate").equals(""))
	{
		Date endDate   = parseDate( ics.GetVar("assetEndDate"), DATE_FORMAT );
		long endDtMillis   = endDate.getTime();		
		
		//Show a warning message if a user tries to approve an asset whose
		//End date is earlier than the current time (asset is no longer valid)

		if(endDtMillis < currentTimeMillis)	
		{
%>
		     <xlat:lookup key="fatwire/Alloy/UI/EndDateIsInPast" varname="endDateInPastMsg" />
		     <ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
		        <ics:argument name="msgtext" value='<%=ics.GetVar("endDateInPastMsg")%>'/>
		        <ics:argument name="severity" value="warning"/>
		     </ics:callelement>	
<%	
		}
	}
%>
</cs:ftcs>