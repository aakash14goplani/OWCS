<%@page import="java.util.Date"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.net.URLDecoder"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Util/ValidateData
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
<%
	String varToValidate = ics.GetVar("val_variable");
	String dataTypeToValidate = ics.GetVar("dataType");
	boolean isDataValid = true;
	
	if(dataTypeToValidate.equalsIgnoreCase("long"))
	{
		try
		{
			Long.parseLong(varToValidate);
		}
		catch (NumberFormatException exception)
		{
			isDataValid = false;
		}
	}
	else if(dataTypeToValidate.equalsIgnoreCase("string"))
	{
		String[] charsToEscape = new String[]{"'", "\"", ";", ":", "<", ">", "%", "?", "\\"};
		varToValidate = URLDecoder.decode(varToValidate,"utf-8");
		for(String chars : charsToEscape)
		{
			if(varToValidate.contains(chars))
			{
				isDataValid = false;
				break;
			}
		}
	}
	else if(dataTypeToValidate.equalsIgnoreCase("date"))
	{
		if(varToValidate.indexOf("'") >= 0)
		{
			varToValidate = varToValidate.replaceAll("'","");
		}
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try
		{
			Date date = format.parse(varToValidate);
			if(format.format(date).equals(varToValidate))
			{
				isDataValid = true;
			}
			else
			{
				isDataValid = false;
			}
		}
		catch (ParseException exception)
		{
			isDataValid = false;
		}
	}
	ics.SetVar("isDataValid", Boolean.toString(isDataValid));
%>
</cs:ftcs>