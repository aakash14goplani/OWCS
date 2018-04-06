<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" 
%><%@ taglib prefix="render" uri="futuretense_cs/render.tld" 
%><%@ taglib prefix="blobservice" uri="futuretense_cs/blobservice.tld" 
%><%@ taglib prefix="assetset" uri="futuretense_cs/assetset.tld" 
%><%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" 
%><%@ taglib prefix="string" uri="futuretense_cs/string.tld" 
%><%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" 
%>

<%-- OpenMarket/Gator/AttributeTypes/IMAGEEDITOR--%>

<%@ page import="COM.FutureTense.Interfaces.FTValList"
%><%@ page import="COM.FutureTense.Interfaces.ICS"
%><%@ page import="COM.FutureTense.Interfaces.IList"
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><%@ page import="com.openmarket.basic.util.Base64"
%><%@ page import="com.openmarket.gator.interfaces.IPresentationObject" %>
<%@ page import="com.openmarket.gator.interfaces.IPresentationElement"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.Iterator"%>
<%@ page import="java.util.Vector"%>

<%!String getAttribute(ICS ics, String attributeName, String defaultValue)
{    
    IPresentationObject presObj = (IPresentationObject)ics.GetObj(ics.GetVar("PresInst"));
    String attributeValue = presObj.getPrimaryAttributeValue(attributeName);
    if (!Utilities.goodString(attributeValue))
        return defaultValue;
    else
        return attributeValue;
}
%>

<cs:ftcs>

<%
    String editorType = getAttribute(ics, "EDITORTYPE", "oie");
    if(editorType.equalsIgnoreCase("clarkii")){
%>
	<ics:callelement element="OpenMarket/Gator/AttributeTypes/CLARKII4" /> 
<%
    }else if(editorType.equalsIgnoreCase("oie")){
%>
	<ics:callelement element="OpenMarket/Gator/AttributeTypes/OIE3" /> 
<%
    }
%>
</cs:ftcs>
