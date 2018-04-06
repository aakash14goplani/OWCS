<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%//
// fatwire/wem/sso/ssoconfig
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>
<%@ page import="java.util.*"%>
<%@ page import="com.fatwire.wem.sso.*"%>
<cs:ftcs>
<%
	SSOConfig ssconfig=DynamicInjector.instance().get("ssoconfig");
	List<String> protectedurls=ssconfig.getProtectedMappingIncludes();
	boolean isCatalogManagerProtected=false;
	for (String str:protectedurls) {
		if (str.indexOf("CatalogManager")>=0) {
			isCatalogManagerProtected=true;
			break;
		}
	}
	// Pass SSO classes for instantiation on remote clients. 
	String authPrefix    = DynamicInjector.instance().get("ssoprovider").getClass().getSimpleName().toLowerCase().substring(0,3); 
	String providerClass = DynamicInjector.instance().get("ssoprovider").getClass().getName();  
	String configClass   = DynamicInjector.instance().get("ssoconfig").getClass().getName(); 
	String tickets = "/tickets";
	if ( authPrefix.equalsIgnoreCase("oam") )
		tickets = ""; 

	out.println("<casproperties>");
	out.println("<authPrefix>"+authPrefix+"</authPrefix>");
	out.println("<restServiceUrl>"+ssconfig.getServiceUrl()+"</restServiceUrl>");
	out.println("<ticketServerUrl>"+ssconfig.getTicketUrl()+ssconfig.getRestPath()+tickets+"</ticketServerUrl>");
	out.println("<ticketParamName>ticket</ticketParamName>");
	out.println("<multiticketParamName>multiticket</multiticketParamName>");
	out.println("<usesso>"+isCatalogManagerProtected+"</usesso>");
	out.println("<providerClass>"+providerClass+"</providerClass>");
	out.println("<configClass>"+configClass+"</configClass>"); 
	out.println("</casproperties>");
%>
</cs:ftcs>