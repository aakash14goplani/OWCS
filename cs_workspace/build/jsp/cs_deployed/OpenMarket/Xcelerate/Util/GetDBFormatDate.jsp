<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Util/GetDBFormatDate
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
<%@ page import="com.openmarket.xcelerate.util.ConverterUtils"%>
<cs:ftcs>

<%
/*
	This element receives a date string in a given locale format and converts it to
	database format yyyy-MM-dd HH:mm:ss. It sets the output in an ICS variable.
	
*/
	String localeDate = ics.GetVar("inputDate");
	String outputVar = ics.GetVar("outputVar");
	String result = "";
	if(!"".equals(localeDate))
	{
		result = ConverterUtils.convertDateToDBFormat(localeDate,ics.GetVar("locale"));
	}
	ics.SetVar(outputVar, result);
%> 
</cs:ftcs>