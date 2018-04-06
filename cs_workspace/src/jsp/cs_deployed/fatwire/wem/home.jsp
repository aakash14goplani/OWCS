<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>
<%@ taglib prefix="xlat" uri="futuretense_cs/xlat.tld" %>
<%//
// fatwire/wem/home
//
// INPUT
//
// OUTPUT
//%>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="com.fatwire.wem.sso.SSO" %>
<cs:ftcs>
<%
//set cs path variable for use for client-side resources
String cspath = request.getContextPath();
if (!cspath.endsWith("/")) {
	cspath += "/";
}

String signoutURL = SSO.getSSOSession().getSignoutUrl();
%>
<ics:callelement element="OpenMarket/Xcelerate/UIFramework/BasicEnvironment"/>
<html>
<head>
  <ics:setssvar name="locale" value='<%=com.fatwire.util.LocaleUtil.getUserLocale(ics,request.getLocales())%>'/>
  <%
  String locale = ics.GetSSVar("locale").toLowerCase().replace("_", "-");
  %>
  <title>Oracle WebCenter Sites 11gR1</title>
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <link rel="shortcut icon" href="<%=cspath%>wemresources/images/icons/sitesFavicon.ico" type="image/x-icon" />
  <style type="text/css">
  @import "<%=cspath%>js/dojo/resources/dojo.css";
  @import "<%=cspath%>js/fw/css/ui/global.css";  
  @import "<%=cspath%>wemresources/css/wemUI.css";
  @import "<%=cspath%>wemresources/css/wem.css";
  @import "<%=cspath%>js/fw/css/AutoHideTopBar.css";
  @import "<%=cspath%>js/fw/css/ui/SWFUpload.css";
  @import "<%=cspath%>js/fw/css/locale/<%=locale%>.css";
  </style>
  <script type="text/javascript" src="<%=cspath%>wemresources/js/WemContext.js"></script>
    
  <satellite:link assembler="query" pagename="fatwire/ui/util/GetSLSObj" outstring="getSLSObj">
	<satellite:argument name="user_locale" value='<%=locale%>'/>
  </satellite:link>
  <script type="text/javascript" src="<%=cspath%>js/dojo/dojo.js"
   djConfig="fw_csPath:'<%=cspath%>', locale:'<%=locale%>'"></script>
   
  <script type="text/javascript" src="<%=cspath%>js/SWFUpload/swfupload.js"></script>
  <script type="text/javascript" src="<%=cspath%>js/SWFUpload/plugins/swfupload.swfobject.js"></script>
  <script type="text/javascript" src="<%=cspath%>js/SWFUpload/plugins/swfupload.queue.js"></script>
  <script type="text/javascript">
	//Initialize wemcontext before loading dojo layers (see AppBar FIXME)
	//Unfortunately it needs to be AFTER dojo because WemContext relies on xhrGet!
	//WEM init will fetch ALL user's persisted user data preferences.	
	WemContext.initialize('<%=cspath%>','<%=signoutURL%>');
  </script>
  
  <!-- layers -->  
  <script type="text/javascript" src="<%=cspath%>js/fw/fw_wem_base.js"></script>
  <script type="text/javascript">
	dojo.require("fw.SystemLocaleString");
  </script>
  <script type="text/javascript" src="<%=cspath%>js/fw/fw_wem_framework.js"></script>

  
  <script type="text/javascript">
  
	dojo.require("fw.wem.framework.WorkSpace");
	dojo.require("fw.xhr");
	var context = WemContext.getInstance();
	//[KGF/DI] wem:signout-less approach to signout handling.
	//Need to define here where I have access to server-side Java for URL
	function doSignout() {
		var url = window.location.href;
		url = url.split('/').slice(0,3).join('/') + dojo.config.fw_csPath +
			'login';
		url = '<%=signoutURL%>?url=' +
			encodeURIComponent(url);		
		window.location.href = url; 
	}
	
	dojo.addOnLoad(function() {
		//adding a class for Mac platform to fix scrollbar issue in Mac webkit browsers
		if(dojo.isMac) {
			dojo.addClass(dojo.body(), 'dj_Mac');
		}
		//Before bothering with anything else, check if we don't have cookies for
		//lastSite and favorites:<lastSite>, in which case we need to redirect
		//BACKWARDS to Welcome (transition) screen... [#22331]
		
		// Get the request Single Instance Handle 
		var context = WemContext.getInstance();
		// Get the user's logged in preference data KEY/NAMED=lastSite
		// At this point we fetched all users preference data 
		// Get the users last logged in site No site welcome the 
		// user to log in SSO wem 
		var lastSite = context.getSiteName() ; 
		var favourites = context.getAttribute(fw.wem._USRPREFERENCE_PREFIX_ + 'favorites');
		if (!lastSite || !favourites)
		{
			var url = window.location.href;
			url = url.split('/').slice(0,3).join('/') + dojo.config.fw_csPath +
				'wem/fatwire/wem/Welcome'; 
			window.location.href = url;
			return; //don't bother running the rest of this handler, just forward
		}
		
		// user has logged in with a site lets go and 
		// create and render WEM workspace
		var workspace = new fw.wem.framework.WorkSpace();		
		workspace.render();		 
	}); 
	<% 
	if(session.getAttribute("X-CSRF-Token") != null){
	%>
		context.setAuthTicket('<%=session.getAttribute("X-CSRF-Token") %>');
	<%	  
	}
	%>
  </script>

  
  <ics:callelement element="OpenMarket/Xcelerate/Util/SetTimeZoneInSession"/>
  <ics:callelement element="OpenMarket/Xcelerate/Util/SetLocale"/>
  <!--[if IE]>
  <script type="text/javascript" src="<%=cspath%>wemresources/js/ui/imagereplace.js"></script>
  <script type="text/javascript" src="<%=cspath%>wemresources/js/ui/swfobject.js"></script>
  <script type="text/javascript">
	//set the swf path this would be used everywhere by elementsImageReplacement
	elementsImageReplacement.setSwfPath("<%=cspath%>wemresources/js/ui/base64image.swf");
  </script>
  <![endif]-->
  </head>
  <body class="fw" style="height:100%">
      <div id="wemloading"><xlat:stream key="fatwire/wem/LoadingWEM"/></div>
  </body>
</html>
</cs:ftcs>
