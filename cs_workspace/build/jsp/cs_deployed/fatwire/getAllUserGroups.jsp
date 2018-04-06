<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ page import="java.util.*"%>
<%@ page import="COM.FutureTense.Interfaces.ICS, com.fatwire.security.UserGroupManagerImpl, COM.FutureTense.Cache.CacheManager" %>
<cs:ftcs><%
    CacheManager.RecordItem( ics, UserGroupManagerImpl.elementName );
    com.fatwire.rest.util.ElementUtil.getAllUserGroups( ics, ics.GetVar("username"));
%></cs:ftcs>