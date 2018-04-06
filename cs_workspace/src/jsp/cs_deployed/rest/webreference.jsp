<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ page import="java.util.*"%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="com.fatwire.rest.util.*"%>
<%@ page import="com.fatwire.rest.beans.*"%>
<%@ page import="com.fatwire.rest.service.*"%>
<%@ page import="com.fatwire.rest.service.impl.*"%>
<cs:ftcs><%
	oracle.fatwire.sites.webreference.webrefcache.WebRefCacheUtil.locateAndSerializeWebReference( ics );	
%></cs:ftcs>
