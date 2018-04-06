<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld"%>
<%@ taglib prefix="property" uri="futuretense_cs/property.tld" %>
<%//
// fatwire/wem/integration/launchApplication
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="com.openmarket.xcelerate.site.Publication"%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>

<%@page import="com.fatwire.services.dao.helper.Tags"%><cs:ftcs>

<%

if(ics.GetVar("clientTimezoneOffset") != null){
String timezone = null;
if(ics.GetVar("tzsign") != null)
{
if("plus".equals(ics.GetVar("tzsign")))
timezone = "+"+ics.GetVar("clientTimezoneOffset").trim();
}
else
timezone = ics.GetVar("clientTimezoneOffset");
%>
<ics:setssvar name="clientTimezoneOffset" value='<%=timezone%>'/>
<%}%>

<%
	String pubName  = ics.GetVar("pubName");
	Publication publication = Publication.Load(ics,"name",pubName);
	String pubid = publication.Get("id");
	ics.SetSSVar("pubid",pubid);
	ics.SetVar("wem","true");
	ics.SetSSVar("PublicationName",pubName);
	ics.SetSSVar("WemUI","true");
	String csapplication = ics.GetVar("application");
	String contextPath = request.getContextPath();
	//Launch Advanced UI
	if("advanced".equals(csapplication))
	{
%>
<property:get param="xcelerate.showSiteTree" inifile="futuretense_xcel.ini" varname="propshowsitetree"/>
<%-- The _enableForms property enables/disables following assettypes from the advanced ui.
		�	All Flex assets and their parent assets
		�	All basic assets
		�	Engage assets like Recommendation, Segment and Promotion
		�	Special assets like Query and Collection
--%>
<property:get param="advancedUI.enableAssetForms" inifile="futuretense_xcel.ini" varname="_enableForms"/>
<ics:callelement element="OpenMarket/Xcelerate/Actions/Security/SetPublicationName"/>
<ics:if condition='<%=!"true".equals(ics.GetVar("_enableForms"))%>'>
<ics:then>
	<ics:setvar name="ThisPage" value="ShowStartMenuItems"/>
</ics:then>
<ics:else>
	<ics:setvar name="ThisPage" value="ShowMyDesktopFront"/>
</ics:else>
</ics:if>
<satellite:link assembler="query"
                       pagename="OpenMarket/Xcelerate/UIFramework/ShowMainFrames" outstring="advancedUIURL">
	  <satellite:argument name="showSiteTree" value='<%=ics.GetVar("propshowsitetree")%>'/>
	  <satellite:argument name="wem" value="true"/>
	  <satellite:argument name="ThisPage" value='<%=ics.GetVar("ThisPage")%>'/>
</satellite:link>
<script type="text/javascript">	
		
		location.href= '<%=ics.GetVar("advancedUIURL")%>';
		
 </SCRIPT>	
<%
// Launch UC1
 } else if("uc1".equals(csapplication))
 {
	 Tags.usermanagerGetloginuser(ics,"loginuser");
 %> 
 <ics:callelement element="OpenMarket/Xcelerate/Util/SetLocale">
	 <ics:argument name="loginuser" value='<%=ics.GetVar("loginuser")%>'/>
 </ics:callelement>
 <script type="text/javascript">	
			location.href= '<%=contextPath%>/ContentServer?pagename=fatwire/ui/controller/controller&elementName=UI/Layout';
 </script> 
<%
 }
%>


</cs:ftcs>