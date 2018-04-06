<%@taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"%>
<%@taglib prefix="ics" uri="futuretense_cs/ics.tld"%>
<%@page import="java.util.List"%>
<%@page import="com.fatwire.cs.ui.framework.UIException"%>
<%@page import="com.fatwire.services.SiteService"%>
<%@page import="com.fatwire.ui.util.GenericUtil"%>
<%@page import="com.fatwire.services.ServicesManager"%>
<%@page import="com.fatwire.system.SessionFactory"%>
<%@page import="com.fatwire.system.Session"%>
<%@page import="com.fatwire.services.beans.entity.RoleBean"%>
<cs:ftcs><%
try {

	Session ses = SessionFactory.getSession();
	ServicesManager servicesManager = (ServicesManager) ses.getManager(ServicesManager.class.getName());
	SiteService siteService = servicesManager.getSiteService();
	List<RoleBean> userRoles = siteService.getUserRoles(GenericUtil.getLoggedInSite(ics));
	for (RoleBean role : userRoles)
	{
		if ("|SiteAdmin|GeneralAdmin|Designer|".contains("|" + role.getName() + "|"))
		{
			ics.SetVar("user-access-is-granted", "true");
			break; 
		}
	}
}
catch(Exception e)
{
	UIException uie = new UIException(e);
	request.setAttribute(UIException._UI_EXCEPTION_, uie);
	throw uie;
}
%></cs:ftcs>

