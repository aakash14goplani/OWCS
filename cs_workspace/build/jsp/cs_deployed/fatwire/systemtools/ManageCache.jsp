<%@page import="com.fatwire.cs.systemtools.util.CacheUtil"%>
<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// fatwire/systemtools/ManageCache
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
<%@ page import="java.util.Arrays"%>
<cs:ftcs>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment" />
<ics:callelement element="OpenMarket/Gator/UIFramework/UITimeOutCheck" />
<ics:callelement element="OpenMarket/Xcelerate/Admin/CheckIsUserAdmin"> 
	<ics:argument name="adminRoleToCheck" value="GeneralAdmin" />
</ics:callelement>
<ics:callelement element="OpenMarket/Xcelerate/Util/SetLocale"/>
<%
if(Boolean.valueOf(ics.GetVar("userIsGeneralAdmin")))
{
	session.setAttribute("userAuthorized","true");
	request.setAttribute("defaultLocale",ics.GetSSVar("locale"));
	String pageName = ics.GetVar("page");
	 
	if (!Arrays.asList("page", "dep","clusterInfo","assetCache","linkedcache","urlCache").contains(pageName)) 
	    pageName = "summary";
	String jspPageName = "/cachetool/" + pageName +".jsp";
	if(!CacheUtil.isPageCacheEnabled() && "summary".equals(pageName))
	{
	%>
	<xlat:lookup key="dvin/AdminForms/ClearPageCache" encode="false" varname="clearPageCacheMessage"/>
	<xlat:lookup key="fatwire/SystemTools/FSTest/labelMessagespc" encode="false" varname="msg"/>
	<xlat:lookup key="fatwire/SystemTools/ManageCache/ssCache" encode="false" varname="msg_1"/>
	
	<%
		String message = ics.GetVar("msg") +", " + ics.GetVar("msg_1");
	%>
	<jsp:include page='<%=jspPageName%>'>
		<jsp:param name="cachesToClear" value='<%=message %>' />
		<jsp:param name="clearPageCacheMessage" value='<%=ics.GetVar("clearPageCacheMessage") %>' />
	</jsp:include>
	<% }else {%>
	<jsp:include page='<%=jspPageName%>' />
<%
 }
}else
{
%>
	<xlat:lookup key="dvin/UI/Error/notallowedtoviewpage" encode="false" varname="msg"/>
	<ics:callelement element="OpenMarket/Xcelerate/UIFramework/Util/ShowMessage">
		<ics:argument name="msgtext" value='<%=ics.GetVar("msg")%>'/>
		<ics:argument name="severity" value="error"/>
	</ics:callelement>
<%
}
%>
</cs:ftcs>