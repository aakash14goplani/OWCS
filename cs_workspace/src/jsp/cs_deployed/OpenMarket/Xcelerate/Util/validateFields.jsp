<%@page import="java.net.URLDecoder"%>
<%@page import="java.lang.Exception"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Util/validateFields
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
<%@ page import="COM.FutureTense.Util.ftMessage,java.util.regex.*,java.util.*"%>
<cs:ftcs>

<%!
    private static final Pattern _pattern=Pattern.compile("(?i)[']");
	private static final Pattern _spacepattern=Pattern.compile("(?i)[()]");

	public boolean validateInput(String columnvalue, String columntype,String wordcounts) {
		boolean success = true;
		String value = columnvalue;
		String type = columntype;
		String count=wordcounts;

		if (null == value && null == type) 
		{
			return false;
		}

		if ("Long".equalsIgnoreCase(type)) 
		{
			try 
			{
			 long val = Long.parseLong(value);
			} 
			catch (NumberFormatException e) 
			{
				success = false;
			}
		} 
		else if ("Date".equalsIgnoreCase(type)) 
		{
			// remove all the single quote to verify validity of date
			try
			{
				value = value.substring(value.indexOf('\''), value.indexOf('\'') + 21);
			}
			catch (Exception e) {}
			Matcher m=_pattern.matcher(value);
			value=m.replaceAll("");
			Calendar cal = Utilities.calendarFromJDBCString(value);
			if (null == cal)
				success = false;
		} 
		else if ("SQL".equalsIgnoreCase(type)) 
		{
			Matcher m=_spacepattern.matcher(value);
			if (m.find())
				success = false;
		} 
		else if ("Nospace".equalsIgnoreCase(type))
		{
			String counts[]=value.split(" ");
			if (counts!=null && counts.length>1)
			{
				success = false;
			}
		}
		else if ("Length".equalsIgnoreCase(type))
		{
				int total=value.length();
				try {
				int expected=Integer.parseInt(count);
				if (total+1>expected)
				{
					success = false;				
				}
				} 
				catch (NumberFormatException e)
				{	
					success = false;				
				}
				
		}
		else if("String".equalsIgnoreCase(type))
		{
			try
			{
				String[] charsToEscape = new String[]{"'", "\"", ";", ":", "<", ">", "%", "?", "\\"};
				value = URLDecoder.decode(value,"utf-8");
				for(String chars : charsToEscape)
				{
					if(value.contains(chars))
					{
						success = false;
						break;
					}
				}
			}
			catch(Exception ex)
			{
				success = false;
			}
		}
		else if("Boolean".equalsIgnoreCase(type))
		{
			if("true".equalsIgnoreCase(value) || "false".equalsIgnoreCase(value))
			{
				success = true;
			}
			else
			{
				success = false;
			}
		}
		else if("Locale".equalsIgnoreCase(type))
		{
			if(value.indexOf("_") == 2 && value.length() == 5)
			{
				success = true;
			}
			else
			{
				success = false;
			}
		}
		return success;
	}
%>

<%
String value=ics.GetVar("columnvalue");
String type=ics.GetVar("type");
String counts=ics.GetVar("wordcounts");
boolean good=validateInput(value,type,counts);
ics.SetVar("validatedstatus",good+"");
%>
</cs:ftcs>