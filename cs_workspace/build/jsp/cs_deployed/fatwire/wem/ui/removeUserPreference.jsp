<%@page import="org.codehaus.jettison.json.JSONObject"%>
<%@page import="com.fatwire.services.SiteService"%>
<%@page import="com.fatwire.services.ServicesManager"%>
<%@page import="com.fatwire.system.SessionFactory"%>
<%@page import="com.fatwire.system.Session"%>
<%@page import="com.fatwire.ui.util.GenericUtil"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="usermanager" uri="futuretense_cs/usermanager.tld" %>
<%
//
// removeUserPreference 
//
// INPUT
//
// OUTPUT
//
%>
<cs:ftcs>

<%

	//Extract the userid part Only 
	String user =  GenericUtil.getLoggedInUserName(ics) ; 
	
	//Get the site that the user is logged into 
	String siteid = ics.GetVar("siteid");
	
	//Get  key/attribute name 
	String name = ics.GetVar("name") ; 
	
	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager)ses.getManager(ServicesManager.class.getName());
	SiteService siteService = servicesManager.getSiteService();

	siteService.removeUserPreference(user,siteid,name ) ; 

	JSONObject contextJSONObject = new JSONObject();
	contextJSONObject.put("user",ics.GetVar("loginuser"));

%>
<%=contextJSONObject.toString()%>

</cs:ftcs>