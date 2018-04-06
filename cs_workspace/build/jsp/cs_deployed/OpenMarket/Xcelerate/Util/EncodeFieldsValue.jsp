<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Enumeration"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="string" uri="futuretense_cs/string.tld" %>
<%//
// OpenMarket/Xcelerate/Util/EncodeFieldsValue
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
	HashMap<String, String> variableMap = new HashMap<String, String>();
	if("GET".equalsIgnoreCase(request.getMethod()))
	{
		String[] charsToEscape = new String[]{"'", "\"", ":", "<", ">", "%", "?", "\\"};
		Enumeration<String> attrNames  = ics.GetVars();
		
		while(attrNames.hasMoreElements())
		{
			String attrName = attrNames.nextElement();
			String attrValue = ics.GetVar(attrName);
			if(attrValue != null)
			{
				for(String chars : charsToEscape)
				{
					if(attrValue.contains(chars))
					{
						variableMap.put(attrName, attrValue);
						break;
					}
				}
			}
		}
		
		for(String key : variableMap.keySet())
		{
%>
			<string:encode variable='<%=key %>' varname="outputVar" />
<%
			ics.SetVar(key, ics.GetVar("outputVar"));
		}
	}
%>

</cs:ftcs>
