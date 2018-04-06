<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="render" uri="futuretense_cs/render.tld" %>
<%@ page import="java.util.*"%>
<%@ page import="COM.FutureTense.Interfaces.ICS, com.fatwire.cs.core.security.CSObject, COM.FutureTense.Access.CSObjectImpl, COM.FutureTense.Cache.CacheManager, COM.FutureTense.Access.SecurityManagerImpl, com.fatwire.cs.core.security.CSObjectTypeEnum" %>
<cs:ftcs><%
    CacheManager.RecordItem( ics, SecurityManagerImpl.elementName );    
    com.fatwire.rest.util.ElementUtil.getAllSecurityConfigs( ics, null );
%></cs:ftcs>