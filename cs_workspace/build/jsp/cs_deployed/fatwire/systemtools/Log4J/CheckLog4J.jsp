<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// fatwire/systemtools/Log4J/CheckLog4J
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
<%@ page import="org.apache.commons.logging.LogFactory"%>
<cs:ftcs><%
			 /*
	              If the Log factory returns Log4J logger, set the property Log4J to true, else false.
	         */
	        Object log_attribute =
	            LogFactory.getFactory().getAttribute(
	                "org.apache.commons.logging.Log");
	        boolean checkLog4j =
	            log_attribute != null
	                && LogFactory.getFactory()
	                    .getAttribute("org.apache.commons.logging.Log")
	                    .toString().toLowerCase().contains("log4j");
	        ics.SetVar("Log4J", String.valueOf(checkLog4j));
%></cs:ftcs>