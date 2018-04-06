<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"
%><%@ page import="COM.FutureTense.Interfaces.*,
                   COM.FutureTense.Util.ftMessage,
                   COM.FutureTense.Util.ftErrors,
                   java.net.*"
%><%--
	OpenMarket/Xcelerate/Util/getCurrentUser

	This outputs some of the current user's info. It's currently used by ShowMainFrames and other
	elements for validating the current user and site selection among Dash, Advanced UI, and InSite
	Editing.

--%><cs:ftcs><%
	String sResponse = "_NOGOOD_";
	try
	{
		String sUsername = ics.GetSSVar("username");
		String sPubId = ics.GetSSVar("pubid");

		if (sUsername != null && sPubId != null)
		{
			sResponse = Utilities.encryptString(sUsername+':'+sPubId);
		}
	}
	catch (Exception e)
	{
		// Something's wrong. sResponse should stay as "_NOGOOD_"
	}

	out.print(sResponse);
%></cs:ftcs>