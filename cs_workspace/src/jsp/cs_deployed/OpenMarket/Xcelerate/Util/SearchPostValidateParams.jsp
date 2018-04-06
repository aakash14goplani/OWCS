<%@page import="java.net.URLDecoder"%>
<%@page import="java.lang.Exception"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Util/SearchPostValidateParams
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
<%@ page import = "java.util.*" %>
<%@ page import="COM.FutureTense.Util.ftMessage,java.util.regex.*,java.util.*"%>
<cs:ftcs>
<%	
	  List stringList = Arrays.asList("Name", "Description", "Type", "ValueStyle", "AttrTypes", "Editing", "Storage", "ExternalTable", "ExternalColumn", "keywords", "alttext", "mimetype", "templname", 
			  "Status", "Subtype", "SubType", "SubTypeDescription", "Category", "uId", "orderBy", "template", "tmplname", "pagename", "UpdatedBy", "OrderBy", "OrderByDesc", "_authkey_", "_charset_", "cs_envirnoment", "cs_formmode", 
			  "PubName", "ttype", "AssetType", "frontpage", "postpage", "Rootelement", "SearchNextStep", "Source", "Abstract", "Body", "Byline", "LinkType", "LinkText", "Aling", "Width", "Height", "Artist", "Alttext", "HREF");

	  List dateList = Arrays.asList("StartDateAfter", "UpdatedAfter", "EndDateBefore", "UpdatedBefore", "StartDateBefore", "EndDateAfter");
	  
	  List longList = Arrays.asList("Id", "flextemplateid", "flexgrouptemplateid", "cs_StartID", "ExternalTabId", "dimensionsearch", "ResultLimit", "AttrTypes", "Width", "Height", "docId");
	  List noSpaceList = Arrays.asList("Subtype", "UpdatedBy");
	  List booleanList = Arrays.asList("AttrValueBasedSch", "AttrBasedSch", "ATTRSEARCH");
	  List sqlList = Arrays.asList("Source", "DirectQuery");
	  List nonNumberList = Arrays.asList("OrderBy");
	  List localList = Arrays.asList("SelectedDim");
	  
	Map<String, String[]> parameters = request.getParameterMap();
	boolean validSoFar = true;
	for(String parameter : parameters.keySet()) 
	{
		if(parameter.equals("SelectedAttrs")){
			String[] values = request.getParameterValues("SelectedAttrs");
			for(int i=0; i<values.length; i++)
			{
				if(! validateInput(values[i], "Long"))
				{
					ics.RemoveVar(parameter);
					break;
				}
			}
			continue;
		}
		
		if(parameter.equals("searchfields")){
			String[] values = request.getParameterValues("searchfields");
			for(int i=0; i<values.length; i++)
			{
				if(! validateInput(values[i], "String"))
				{
					ics.RemoveVar(parameter);
					break;
				}
			}
			continue;
		}
		
		if(parameter.equals("sMyTmplAttributes")){
			String[] values = request.getParameterValues("sMyTmplAttributes");
			for(int i=0; i<values.length; i++)
			{
				if(! validateInput(values[i], "Long"))
				{
					ics.RemoveVar(parameter);
					break;
				}
			}
			continue;
		}
		
		if(parameter.contains("**")){
			String[] specialParameter = parameter.split("\\*\\*");
			if(!validateInput(parameters.get(specialParameter[0])[0], specialParameter[1]))
			{
				ics.RemoveVar(parameter);
				ics.RemoveVar(specialParameter[0]);
				continue;
			}
		}
		
		if(stringList.contains(parameter) && !validateInput(parameters.get(parameter)[0], "String")){
			ics.RemoveVar(parameter);
			continue;
		}
		
		if(dateList.contains(parameter) && !validateInput(parameters.get(parameter)[0], "Date")){
			ics.RemoveVar(parameter);
			ics.RemoveVar(parameter+"Text");
			continue;
		}
			
		
		if(longList.contains(parameter) && !validateInput(parameters.get(parameter)[0], "Long")){
			ics.RemoveVar(parameter);
			continue;
		}
		
		if(noSpaceList.contains(parameter) && !validateInput(parameters.get(parameter)[0], "Nospace")){
			ics.RemoveVar(parameter);
			continue;
		}
		
		if(booleanList.contains(parameter) && !validateInput(parameters.get(parameter)[0], "Boolean")){
			ics.RemoveVar(parameter);
			continue;
		}
		
		if(sqlList.contains(parameter) && !validateInput(parameters.get(parameter)[0], "SQL")){
			ics.RemoveVar(parameter);
			continue;
		}
		
		if(localList.contains(parameter) && !validateInput(parameters.get(parameter)[0], "Locale")){
			ics.RemoveVar(parameter);
			continue;
		}
		if(nonNumberList.contains(parameter) && !validateInput(parameters.get(parameter)[0], "NonNumber")){
			ics.RemoveVar(parameter);
			continue;
		}
	}
%>
	<%!	
	
	final Pattern _pattern=Pattern.compile("(?i)[']");
	 final Pattern _spacepattern=Pattern.compile("(?i)[()]");
	 
	public boolean validateInput(String columnvalue, String columntype) {
		boolean success = true;
		String value = columnvalue;
		String type = columntype;

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
		
		else if("NonNumber".equalsIgnoreCase(type))
		{
			try
			{
				success = false;
				int val = Integer.parseInt(value);
			}
			catch (NumberFormatException e)
			{
				success = true;
			}
		}
		
		else if("Money".equalsIgnoreCase(type))
		{
			try 
			{
			 float val = Float.parseFloat(value);
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
				if(value.equals("") || (value.indexOf('\'') == value.lastIndexOf('\'')))
					return false;
				value = value.substring(value.indexOf('\'')+1, value.lastIndexOf('\''));
				if(value.contains("'"))
					return false;
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

</cs:ftcs>