<%@page import="java.util.ArrayList"%>
<%@page import="com.fatwire.cs.ui.framework.UIException"%>
<%@page import="org.codehaus.jackson.map.ObjectMapper"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.fatwire.services.ui.beans.UIPreferenceBean"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.Map"%>
<%@page import="com.fatwire.services.SiteService"%>
<%@page import="com.fatwire.services.ServicesManager"%>
<%@page import="com.fatwire.system.SessionFactory"%>
<%@page import="com.fatwire.system.Session"%>
<%@page import="com.fatwire.ui.util.GenericUtil"%>
<%@page import="org.codehaus.jackson.map.annotate.JsonSerialize"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@ taglib prefix="usermanager" uri="futuretense_cs/usermanager.tld"%>
<%
	//
	// getAllUserPreferences
	//
	// INPUT
	//
	// OUTPUT
	//
%>
<cs:ftcs>
	<%
	
			String user = GenericUtil.getLoggedInUserName(ics);
			Session ses = SessionFactory.getSession();
			ServicesManager servicesManager = (ServicesManager) ses.getManager(ServicesManager.class.getName());
			SiteService siteService = servicesManager.getSiteService();
			// Got to the site service to fetch the logged in users 
			// site specific preferences set of key/value data 
			Map<String, String> prefs = siteService.getUserPreferences(user, null);

			if (StringUtils.isNotEmpty(prefs.get("WEMUI:lastSite")))
			{
				prefs.putAll(siteService.getUserPreferences(user, prefs.get("WEMUI:lastSite")));
			}
			// Build some UIPreferenceBean beans to serilize...
			List<UIPreferenceBean> items = new ArrayList<UIPreferenceBean>();

			// Populate list of site keys data
			Iterator iter = prefs.keySet().iterator();
			while (iter.hasNext())
			{
				// get the parameter name by key 
				String key = (String) iter.next();
				// get the array of String values by key/name 
				String value = (String) prefs.get(key);
				items.add(new UIPreferenceBean(key, value));
			}
			//convert the list to json
			//as we do not want to serilaise the null values, set the serialization config to 
			//have JsonSerialize.Inclusion.NON_NULL  which allows us not to serialize null values.
			ObjectMapper mapper = new ObjectMapper();
			mapper.getSerializationConfig().setSerializationInclusion((JsonSerialize.Inclusion.NON_NULL));
			String json = mapper.writeValueAsString(items);
	%>
	{
		"items": <%=json%>
	}
	<%
			
	%>
</cs:ftcs>