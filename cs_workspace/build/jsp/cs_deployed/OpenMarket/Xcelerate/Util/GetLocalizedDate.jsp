<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Xcelerate/Util/GetLocalizedDate
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

<!-- user code here -->
<%
	/*
		This element receives a date value in the database format yyyy-MM-dd HH:mm:ss and 
		converts it to a locale specific format (with MEDIUM date and time formats)
	*/
	String dbDate = ics.GetVar("inputDate");
	String outputVar = ics.GetVar("outputVar");
	String result = "";

	if(!"".equals(dbDate))
	{
		result = ConverterUtils.getLocalizedDate(dbDate,ics.GetSSVar("locale"));
	}
	ics.SetVar(outputVar, result);
%>
</cs:ftcs>