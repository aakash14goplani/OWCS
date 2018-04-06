<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.TimeZone"%>
<%@page import="java.util.Calendar"%>
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
                   COM.FutureTense.Util.ftErrors,
                   com.openmarket.xcelerate.util.ConverterUtils"
%>
<%!
private static String getTimeZoneParam(ICS ics, String param)
{
	String retVal = null;
	if("server".equals(param))
	{
		retVal = TimeZone.getDefault().getID();
	}
	else if("client".equals(param))
	{
		retVal = ics.GetSSVar("time.zone");
	}
	else
	{
		retVal = param;
	}
	return retVal;
}
%>
<cs:ftcs><%--

INPUT

OUTPUT

--%>
<%

String inputDate = ics.GetVar("inputDate");
String inputDateType = ics.GetVar("inputDateType");
if("now".equals(inputDate))
{
	inputDate = String.valueOf(System.currentTimeMillis()) ;
	inputDateType="millis";
}

String outputDate = null;
String fromTimeZone = getTimeZoneParam(ics,ics.GetVar("fromTimeZone"));
String toTimeZone =  getTimeZoneParam(ics,ics.GetVar("toTimeZone"));

if(Utilities.goodString(inputDateType) && "millis".equals(inputDateType))
{
	Calendar c = Calendar.getInstance();
	c.setTimeInMillis(Long.parseLong(inputDate));
	SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	inputDate = dateFormatter.format(c.getTime());
 	
}

if(Utilities.goodString(inputDate))
{
	outputDate = ConverterUtils.convertJDBCDate(inputDate,fromTimeZone,toTimeZone);
}

if("millis".equals(ics.GetVar("outputType")))
{
	if(Utilities.goodString(outputDate))
	{
		String format = null;
		if(outputDate.length() == 19  )
		{
			format = "yyyy-MM-dd HH:mm:ss";
		}
		else if(outputDate.length() > 19 && outputDate.length() <= 23)
		{
			format = "yyyy-MM-dd HH:mm:ss.SSS";
		}
		
		SimpleDateFormat simpleFormat = new SimpleDateFormat(format);
		simpleFormat.setTimeZone(TimeZone.getTimeZone(toTimeZone));
		simpleFormat.applyLocalizedPattern(format);
		Date dInterMediate = simpleFormat.parse(outputDate);
		ics.SetVar("outputDate",dInterMediate.getTime()+"");
	}
}
else
{
	ics.SetVar("outputDate", outputDate);
}
%>
</cs:ftcs>
