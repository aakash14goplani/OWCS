<%@page import="com.fatwire.services.SiteService"%>
<%@page import="com.fatwire.services.ServicesManager"%>
<%@page import="com.fatwire.system.SessionFactory"%>
<%@page import="com.fatwire.system.Session"%>
<%@page import="com.fatwire.ui.util.GenericUtil"%>
<%@page import="org.codehaus.jettison.json.JSONObject"%>
<%@page import="com.fatwire.util.LocaleUtil"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="usermanager" uri="futuretense_cs/usermanager.tld"%>
<%
	//
	// addUserPreference
	//
	// INPUT
	//
	// OUTPUT
	//
%>

<cs:ftcs>
	<%
			String user = GenericUtil.getLoggedInUserName(ics);

			//Get the site that the user is logged into 
			String siteid = ics.GetVar("siteid");

			//Get the user's data prefernce key/value pair 
			String name = ics.GetVar("name");
			// Get the site that the user is logged into 
			String value = ics.GetVar("value");
			
			Session ses = SessionFactory.getSession();
			ServicesManager servicesManager = (ServicesManager) ses.getManager(ServicesManager.class.getName());
			SiteService siteService = servicesManager.getSiteService();

			// Add or update user data preference key 
			siteService.addUserPreference(user, siteid, name, value);

			JSONObject contextJSONObject = new JSONObject();
			contextJSONObject.put("user", ics.GetVar("loginuser"));
	%>
	<%=contextJSONObject.toString()%>
</cs:ftcs>