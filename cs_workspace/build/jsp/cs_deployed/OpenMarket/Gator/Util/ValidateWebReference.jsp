<%@page import="com.fatwire.cs.core.webreference.WebReferencesBean"%>
<%@page import="com.openmarket.xcelerate.asset.WebReferencesManager"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld"%>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// OpenMarket/Gator/Util/ValidateWebReference
//
// INPUT
//
// OUTPUT
//%>
<cs:ftcs>
<xlat:lookup varname="urlalreadyexists" key="UI/Forms/URLAlreadyExists"/>
<xlat:lookup varname="urlalreadyexistsasredirect" key="UI/Forms/URLAlreadyExistsAsRirect"/>
<%
	String webreferenceURL = ics.GetVar("webreferenceurl");
	String host = ics.GetVar("host");
	String action = ics.GetVar("action");
	String message ="";
	boolean exists = true;
	WebReferencesManager webReferencesManager = new WebReferencesManager(ics);
	if("new".equals(action))
	{	
		WebReferencesBean webreference = webReferencesManager.getWebReferenceForUnresolvedHost(host,webreferenceURL);
	 	exists = webreference!= null;
		message = ics.GetVar("urlalreadyexists");
	} else
	{
		WebReferencesBean webreference = webReferencesManager.getWebReferenceForRedirectUrl(host,webreferenceURL);
		exists = webreference!= null;
		message = ics.GetVar("urlalreadyexistsasredirect");
	}
%>
	{"status":"<%=exists ?"error" : "success" %>",
	"message":"<%=exists ? message : ""%>"}
	
</cs:ftcs>