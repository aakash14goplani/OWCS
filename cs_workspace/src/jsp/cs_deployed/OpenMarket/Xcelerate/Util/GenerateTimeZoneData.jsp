<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="asset" uri="futuretense_cs/asset.tld"
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld"
%><%@ taglib prefix="commercecontext" uri="futuretense_cs/commercecontext.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ taglib prefix="listobject" uri="futuretense_cs/listobject.tld"
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld"
%><%@ taglib prefix="searchstate" uri="futuretense_cs/searchstate.tld"
%><%@ taglib prefix="siteplan" uri="futuretense_cs/siteplan.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   com.fatwire.assetapi.data.*,
                   com.fatwire.assetapi.*,
                   COM.FutureTense.Util.ftErrors"
%><cs:ftcs><%--

INPUT

OUTPUT

This element generates utility javascript methods, to
generate day light shift times of different years ( which depends on OS).

The data will be in the form of json and is used to match with 
the java.util.TimeZone API to screen possible time zone ids.

See also OpenMarket/Xcelerate/Util/SetTimeZoneInSession

--%>
<script>

function getDSTShiftsForDecade()
{
	var finalDST = '"{ ' ;
	var d = new Date();
	var fullYear = d.getFullYear();
	for(var i= fullYear -1 ;i>= (fullYear - 10 );i--)
	{
		var temp = getDSTShiftForYear(i);
		finalDST = finalDST + "'"+ i + "' : " + temp +" ," ;
		
	}
	finalDST = finalDST.substring(0,finalDST.length - 1) + '}" ';;
	return finalDST;
}

function isLeapYear (year)
{
   if (((year % 4)==0) && ((year % 100)!=0) || ((year % 400)==0))
      return (true);
   else
      return (false);
}

function getDSTShiftForYear(year)
{
	var oneDayMillis = 24*60*60*1000;
	var prevOffset = -1 , checkDate,currentOffset,month,day;
	checkDate = new Date(year, 0, 1 , 0, 0, 0, 0);
	var baseMillis = checkDate.getTime();
	var jsonString = "{ " ;
	for(var k =1;k<364;k++)
	{
		currentOffset = checkDate.getTimezoneOffset();		
		if(prevOffset !== -1 && prevOffset !== currentOffset )
		{
			month = checkDate.getMonth();
			day = checkDate.getDate(); 
			if(day == 1)
			{
				month--;
				if(month == 1)
				{
					//if month is feb
					day = isLeapYear(checkDate.getFullYear()) ? 29 : 28;
				}
				else
				{
					day = month%2 == 0 ? 31 : 30
				}
				
			}
			else
			{
				day--;
			}
			jsonString = jsonString +  " '" + (month + 1) +"' : '" + day  + "' ,";
			
		}
		
		prevOffset =  currentOffset;
		baseMillis = baseMillis + oneDayMillis;
		checkDate.setTime(baseMillis);
	}
	
	jsonString = jsonString.substring(0,jsonString.length -1);
	jsonString  = jsonString +"} ";
	
	
	return jsonString;
}
function getTimeZoneJson()
{
	var now = new Date();
	
    var jan = new Date(now.getFullYear(), 1, 1, 0, 0, 0, 0);
    var jun = new Date(now.getFullYear(), 6, 1, 0, 0, 0, 0);
    var std_time_offset = jan.getTimezoneOffset();
    var daylight_time_offset = jun.getTimezoneOffset();
    
    var jsonString =' { ';
    
    if (std_time_offset == daylight_time_offset) {
	 	jsonString = jsonString +  '"dst" : "false" ';
    } else {
	// positive is southern hemisphere, negative is northern hemisphere
		jsonString = jsonString + ' "dst" : "true" ';
		var hemisphere = daylight_time_offset - std_time_offset;
	
		if (hemisphere > 0)
		{
	            std_time_offset = daylight_time_offset;
	            jsonString = jsonString + ', "northHem" : "false" ';
	    }
	    else
	    {
	    	jsonString = jsonString + ', "northHem" : "true" ';
	    }
	 
	     jsonString = jsonString + ' , "isDayLightOn" : "' + (now.getTimezoneOffset() == daylight_time_offset) + '" ';
	     jsonString = jsonString + ', "dstShiftTimes" : ' + getDSTShiftsForDecade();
    }
    
    jsonString = jsonString + ' , "stdOffset" : "' + std_time_offset +'" }';
    return jsonString;
}
	
</script>

</cs:ftcs>
