<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld"
%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"
%><%@ page import="COM.FutureTense.Interfaces.*"
%><%@ page import="com.fatwire.ui.util.GenericUtil"
%><%@ page import="com.fatwire.assetapi.util.AssetUtil"
%><%@ page import="com.fatwire.services.ServicesManager"
%><%@ page import="com.fatwire.system.SessionFactory"
%><%@ page import="com.fatwire.system.Session"
%><%@ page import="com.fatwire.services.SiteService"
%><%@ page import="java.util.*"%><cs:ftcs><%
// determines the full list of asset types supported in the editorial UI
Session ses = SessionFactory.getSession();
ServicesManager servicesManager = (ServicesManager)ses.getManager(ServicesManager.class.getName());
SiteService siteService = servicesManager.getSiteService();
List<String> enabledTypes = siteService.getEnabledTypes(GenericUtil.getLoggedInSite(ics));
pageContext.setAttribute("enabledTypes", enabledTypes, PageContext.PAGE_SCOPE);
List<String> supported = new ArrayList<String>();
List<String> searchable = new ArrayList<String>();
List<String> proxy = new ArrayList<String>();

FTValList args = new FTValList();
for (String type: enabledTypes) {
	if (AssetUtil.isProxyAssetType(ics, type)) {
		supported.add(type);
		searchable.add(type);
		proxy.add(type);
		continue;
	}
	args.clear();
	args.setValString("assettype", type);
	ics.CallElement("OpenMarket/Xcelerate/Util/CheckAssetTypeSupport", args);
	if ("true".equals(ics.GetVar("isSupported"))) {
		supported.add(type);
	}
	if ("true".equals(ics.GetVar("isSearchable"))) {
		searchable.add(type);
	}
}
request.setAttribute("supportedTypes", supported);
request.setAttribute("searchableTypes", searchable);
request.setAttribute("proxyTypes", proxy);
%>
</cs:ftcs>