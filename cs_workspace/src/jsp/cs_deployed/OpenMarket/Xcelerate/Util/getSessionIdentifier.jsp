<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" 
%><%@ page import="COM.FutureTense.Interfaces.Utilities"
%><cs:ftcs><%
String sResponse = "";
String sUsername = ics.GetSSVar("username");
String sPubId = ics.GetSSVar("pubid");
if (sUsername != null && sPubId != null)
	sResponse = Utilities.encryptString(sUsername+':'+sPubId);
ics.SetVar("sessionIdentifier", sResponse);
%></cs:ftcs>